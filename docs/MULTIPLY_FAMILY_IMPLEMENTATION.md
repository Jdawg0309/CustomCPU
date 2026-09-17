# ARM-state multiply family implementation

Measured on: 2026-09-02  
Reference circuit: `debug_armv4t_2.circ`  
Protected master circuits: `armv4t.circ` and `armv4t_2.circ` were not modified

## Status

The complete ARMv4T integer multiply family is implemented in the debug circuit:

| Instruction | Width | Signedness | Accumulates | Result registers | Status |
|---|---:|---|---|---|---:|
| `MUL` | 32 | low 32 bits are sign-independent | no | `Rd` | pass |
| `MLA` | 32 | low 32 bits are sign-independent | yes | `Rd` | pass |
| `UMULL` | 64 | unsigned | no | `RdHi:RdLo` | pass |
| `UMLAL` | 64 | unsigned | yes | `RdHi:RdLo` | pass |
| `SMULL` | 64 | signed | no | `RdHi:RdLo` | pass |
| `SMLAL` | 64 | signed | yes | `RdHi:RdLo` | pass |

Measured verification:

- direct `stage_EX` vector: **4/4**;
- end-to-end multiply discriminator: **27/27 result words**;
- full adversarial CPU suite: **53/54**, with only unrelated `SWP` failing;
- graph/tooling unit tests after adding BitSelector geometry: **18/18**.

This implementation deliberately uses Logisim's built-in 32-bit `Multiplier`
instead of the old hand-built `mul_32`. The built-in component is the correct
FPGA-oriented choice because synthesis can infer dedicated multiplier/DSP
hardware. The exact DSP count and Fmax still require a fresh Vivado run.

## Encoding and decode

### Short multiply

The short family has this shape:

```text
MUL: cond 000000 A S Rd       Rn/SBZ  Rs 1001 Rm
                 0            SBZ
MLA: cond 000000 A S Rd       Rn      Rs 1001 Rm
                 1
```

Operationally, decode requires the multiply signature and the opcode variant:

```text
instr[27:24] = 0000
instr[7:4]   = 1001
```

The `A` bit selects accumulation and `S` requests flag updates.

### Long multiply

The long-family opcode nibble is `instr[24:21]`:

| `instr[24:21]` | Instruction | Signed | Accumulate |
|---:|---|---:|---:|
| `0100` | `UMULL` | 0 | 0 |
| `0101` | `UMLAL` | 0 | 1 |
| `0110` | `SMULL` | 1 | 0 |
| `0111` | `SMLAL` | 1 | 1 |

The live `stage_ID` control outputs are:

```text
mul_long      = instruction is one of the four long forms
mul_signed    = signed long form
mul_long_acc  = long accumulate form
```

These signals are carried into `stage_EX`. Short multiply continues to use the
existing `is_mult`/`is_mla` controls.

## Register-field routing

Multiply encodings reuse normal ARM instruction fields differently. This is a
major source of silent wiring errors.

### Short forms

```text
Rm = instr[3:0]       multiplicand
Rs = instr[11:8]      multiplier
Rn = instr[15:12]     MLA accumulator only
Rd = instr[19:16]     destination
```

Therefore:

```text
MUL  result = (Rm * Rs) mod 2^32
MLA  result = (Rm * Rs + Rn) mod 2^32
```

`Rd` and `Rn` are not in the ordinary data-processing destination/base roles.
A test in which all four register numbers differ is required to expose swaps.

### Long forms

```text
Rm   = instr[3:0]
Rs   = instr[11:8]
RdLo = instr[15:12]
RdHi = instr[19:16]
```

The current reorganized datapath presents those values to `stage_EX` as:

```text
rd_b          = Rm
rs_value      = Rs
mul_acc_value = RdLo
rd_a          = RdHi
```

For non-accumulating long operations the existing values of `RdLo` and `RdHi`
are ignored. For `UMLAL`/`SMLAL`, they form the 64-bit accumulator.

## Multiplier datapath

There is one built-in unsigned 32-by-32 multiplier at `stage_EX` coordinate
`(3600,3100)`:

```text
a    = Rm
b    = Rs
cin  = 0
out  = product[31:0]
cout = unsigned_product[63:32]
```

Only one multiplier is used for both unsigned and signed operations. This
avoids duplicating the largest arithmetic block.

The low 32 product bits are identical for signed and unsigned two's-complement
multiplication. Only the high half requires correction.

## Signed high-half correction

Let:

```text
UHI = high 32 bits of unsigned(Rm) * unsigned(Rs)
```

The high half of the signed two's-complement product is:

```text
SHI = UHI
    - (Rm[31] ? Rs : 0)
    - (Rs[31] ? Rm : 0)
    mod 2^32
```

The circuit implements each subtraction as two's-complement addition:

```text
x - y = x + NOT(y) + 1
```

Two `BitSelector` components explicitly select bit 31 of `Rm` and `Rs`. Each
sign bit controls whether its correction operand is zero or the opposite
multiplicand. Two 32-bit adders then apply the corrections.

Explicit `BitSelector` components are intentional. An earlier splitter-based
version looked connected in a geometry model but produced undefined values in
real Logisim. The dedicated selector gives both Logisim and the Python graph a
deterministic input, selector, and output port.

The high-half selector then chooses:

```text
mul_signed = 0 -> product_hi = UHI
mul_signed = 1 -> product_hi = SHI
```

## Short accumulation

Short `MLA` adds the third operand after multiplication:

```text
short_product = product[31:0]
short_result  = is_mla ? short_product + Rn : short_product
```

Only the low 32 bits are retained. Overflow wraps modulo `2^32`, as required
for the architectural result.

## Long accumulation

Long accumulation is performed as two linked 32-bit additions:

```text
low_sum, carry = product_lo + old_RdLo
high_sum       = product_hi + old_RdHi + carry
```

The result muxes select:

```text
mul_long_acc = 0 -> result_lo = product_lo
                    result_hi = product_hi

mul_long_acc = 1 -> result_lo = low_sum
                    result_hi = high_sum
```

This is addition modulo `2^64`. The regression explicitly proves carry from
the low word reaches the high word, and that `0xffffffffffffffff + 1` wraps to
zero.

## Writing two destination registers

Short multiply uses the normal primary register-file write port.

Long multiply writes two registers in one architectural instruction:

```text
primary port   -> RdLo = result_lo
secondary port -> RdHi = result_hi
```

`stage_EX` exposes:

```text
mul_hi       = result_hi
mul_long_we  = mul_long AND condition_passed
```

In `main`, the secondary port arbitrates between the existing memory/block-load
writer and long multiply:

```text
WD2 = mul_long_we ? MUL_HI : MEM_WD2
WA2 = mul_long_we ? RdHi   : MEM_WA2
WE2 = mul_long_we OR MEM_WE2
```

The condition gate is essential. A failed conditional long multiply must write
neither destination. The end-to-end test poisons both destination registers
before an `UMULLEQ` whose condition is false and verifies both are preserved.

This arbitration logic currently lives in the debug `main` circuit. Before the
user hand-wires the protected master or introduces a pipeline, it would be
cleaner to move the policy behind a named writeback-stage interface so `main`
remains structural.

## Condition handling

All six multiply instructions honor the four-bit ARM condition field.

```text
short write enable = normal register-write qualification AND condition_passed
long low write     = normal qualified primary write
long high write    = mul_long AND condition_passed
```

The focused suite checks a false conditional `MUL` and a false conditional
`UMULL`. This prevents a decode-only implementation from passing while still
writing on failed conditions.

## Flag behavior

When `S=1`, short multiply updates `N` and `Z` from the 32-bit result:

```text
N = result[31]
Z = (result == 0)
```

Long multiply updates `N` and `Z` from the full 64-bit result:

```text
N = result_hi[31]
Z = (result_hi == 0) AND (result_lo == 0)
```

For this ARMv4 implementation, multiply preserves the current `C` and `V`
values. `V` is unaffected architecturally; short-multiply `C` is
architecturally unpredictable, so deterministic preservation is a valid and
testable implementation choice.

The tests prove:

- negative `MULS` sets `N`;
- zero `MULS` sets `Z`;
- negative `SMULLS` uses bit 63, not bit 31;
- zero `UMULLS` requires both halves to be zero;
- the chosen `C`/`V` preservation behavior is stable.

## Verification coverage

The end-to-end program writes 27 result words to RAM. It covers:

1. basic `MUL` and `MLA`;
2. basic `UMULL`, `UMLAL`, `SMULL`, and `SMLAL`;
3. unsigned and signed high halves for all-ones operands;
4. carry propagation during 64-bit accumulation;
5. modulo-`2^64` accumulation wrap;
6. `INT32_MIN * -1`, a signed boundary;
7. `MULS`, `SMULLS`, and `UMULLS` `N`/`Z` behavior;
8. false conditions suppressing the short result and both long destinations;
9. deterministic `C`/`V` preservation.

## Verification commands

Direct execute-stage vector:

```bash
logisim-evolution --no-splash \
  --test-vector stage_EX tests/multiply_long_ex_vector.txt \
  debug_armv4t_2.circ
```

Expected:

```text
Passed: 4, Failed: 0
```

End-to-end program:

```bash
python3 -u tests/debug_multiply_suite.py debug_armv4t_2.circ
```

Expected:

```text
[PASS] MUL MLA UMULL UMLAL SMULL SMLAL
[PASS] 64-bit accumulate carry and signed high halves
[PASS] MULS/SMULLS N/Z condition behavior
27/27 result words correct
```

Full architectural regression:

```bash
python3 -u tests/adversarial_regression.py debug_armv4t_2.circ
```

Measured on 2026-09-02:

```text
PASS=53  WRONG=1
Architectural checks: 53/54 passed
```

Only `SWP` fails. All six multiply-family cases in the full and focused tests
pass.

Tooling regression:

```bash
python3 -m unittest discover -s tests -p 'test_logisim.py'
```

Expected current result:

```text
Ran 18 tests
OK
```

## Bugs found while implementing this family

### Wrong instruction-field tap

A bus/probe name implied bits 23:20 but actually carried a different instruction
slice. Long multiply decode initially used that misleading tap. The working
decode uses the real `opcode = instr[24:21]` path and separately qualifies the
multiply signature.

### Visually connected sign splitters

The first signed-high implementation derived operand sign bits through
splitters. The graph model believed the endpoints were connected, but the real
Logisim vector produced undefined values. Replacing those taps with
`BitSelector(width=32, index=31)` made the connectivity explicit. The Python
geometry model was extended accordingly and its 18 tests pass.

### Second destination must be condition-gated

Writing `RdLo` correctly is insufficient. A long multiply has an independent
high write path, and that path can silently modify `RdHi` even when the
condition fails. `mul_long_we` is generated from both long-decode and
`condition_passed`.

### Long zero is a 64-bit comparison

Testing only the low half would incorrectly set `Z` for values such as
`0x00000001_00000000`. Long `Z` is the AND of two independent zero compares.

## FPGA and timing implications

The behavioral multiplier is currently combinational. That is simple and
correct for the single-cycle reference CPU, but it is likely to become one of
the longest execute paths after synthesis.

Important expectations:

- a 32-by-32 multiply can consume multiple DSP48E1 slices; it is not necessarily
  one DSP per ARM multiply unit;
- the high-half correction and 64-bit accumulator add logic follows the
  multiplier and may dominate the long-accumulate path;
- a future pipeline should register the multiplier output or treat multiply as
  a multi-cycle operation;
- the single-cycle debug circuit should remain the architectural oracle while
  the pipelined implementation is compared against it.

Do not quote an Fmax or DSP count from this document. Those are synthesis and
place-and-route measurements, not properties proven by the Logisim regression.

## Completion boundary

The six ARM-state integer multiply instructions are complete for the tested
user-mode semantics. This does not include multiply-related timing guarantees,
architecturally unpredictable register-overlap cases, exception behavior, or
Thumb encodings. Those belong to later architecture and implementation work.
