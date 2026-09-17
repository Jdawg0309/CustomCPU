# Halfword and byte access implementation

Measured on: 2026-09-02  
Reference circuit: `debug_armv4t_2.circ`  
Protected master circuits: `armv4t.circ` and `armv4t_2.circ` were not modified

## Status

The byte and halfword transfer datapath is implemented and working in the
debug circuit. The dedicated real-Logisim regression passes **19/19**:

| Instruction or behavior | Result |
|---|---:|
| `STRB`, all four byte lanes | 4/4 |
| `LDRB`, all four byte lanes, zero extended | 4/4 |
| `STRH`, low and high halfword lanes | 2/2 |
| `LDRH`, low and high halfword lanes, zero extended | 2/2 |
| `LDRSB`, all four lanes, positive and negative values | 4/4 |
| `LDRSH`, both lanes, positive and negative values | 3/3 |
| Total | **19/19** |

The full adversarial CPU suite also passes its word, byte, halfword, signed-byte,
literal-pool, and program-ROM memory cases. The whole CPU result after the
multiply work is **53/54**; only `SWP` fails.

This document describes what is actually present in the debug circuit. The
older proposal in `specs/fix_5_halfword.md` suggested read-modify-write because
the RAM was believed to lack byte enables. That assumption is obsolete: the
live RAM has four byte-enable inputs, so subword stores preserve neighboring
bytes directly.

## Instructions covered

| Instruction | Width | Extension on load | Store behavior |
|---|---:|---|---|
| `LDRB` | 8 bits | zero extend to 32 bits | — |
| `STRB` | 8 bits | — | enable exactly one byte lane |
| `LDRH` | 16 bits | zero extend to 32 bits | — |
| `STRH` | 16 bits | — | enable the selected pair of byte lanes |
| `LDRSB` | 8 bits | sign extend to 32 bits | — |
| `LDRSH` | 16 bits | sign extend to 32 bits | — |

Ordinary `LDR` and `STR` remain the 32-bit path and enable all four lanes.

## ARM extra-load/store encoding

Halfword and signed transfers use ARM's extra-load/store format, not the normal
single-data-transfer encoding used by `LDR`, `STR`, `LDRB`, and `STRB`.

The defining pattern is:

```text
instr[27:25] = 000
instr[7]     = 1
instr[4]     = 1
instr[6:5]   = SH
```

The `SH` field selects the transfer:

| `SH` | Load meaning | Store meaning |
|---:|---|---|
| `01` | `LDRH` | `STRH` |
| `10` | `LDRSB` | architecturally invalid/reserved |
| `11` | `LDRSH` | architecturally invalid/reserved |

`stage_ID` produces `is_hwxfer` for the three live `SH` patterns. The physical
instruction bit called `B` on the normal transfer path is instruction bit 22.
For the extra-load/store format that same bit has a different meaning:

```text
instr[22] = 1  -> immediate offset
instr[22] = 0  -> register offset
```

That dual meaning is legal because the instruction class decides how the bit is
interpreted.

## Address calculation

The effective byte address still follows the ARM `P`, `U`, and `W` rules already
used by the ordinary memory path. The only difference is how the offset is
formed.

For the immediate form:

```text
offset8 = instr[11:8] : instr[3:0]
offset  = zero_extend(offset8)
```

For the register form:

```text
offset = Rm
```

The offset is added when `U=1` and subtracted when `U=0`. Pre-index and
post-index selection, base writeback, and condition gating remain shared with
the ordinary transfer machinery.

The byte address is split into:

```text
word_index = address >> 2
lane       = address[1:0]
half       = address[1]
```

`lane` selects one of four bytes. `half` selects bits 15:0 or 31:16.

## Physical RAM interface

The stage uses a 32-bit RAM with a 10-bit word address and four independent byte
enables. In the current `stage_MEM` layout the RAM anchor is `(2740,1800)`.

| RAM port | Coordinate | Driver or meaning |
|---|---:|---|
| address | `(2740,1810)` | computed byte address with bits `[1:0]` removed |
| write enable | `(2740,1850)` | qualified store enable |
| output enable | `(2740,1860)` | constant enabled |
| byte enable 3 | `(2740,1870)` | byte bits 31:24 |
| byte enable 2 | `(2740,1880)` | byte bits 23:16 |
| byte enable 1 | `(2740,1890)` | byte bits 15:8 |
| byte enable 0 | `(2740,1900)` | byte bits 7:0 |
| clock | `(2740,1910)` | CPU clock |
| data input | `(2740,1930)` | replicated or full-width store bus |
| data output | `(2980,1930)` | full 32-bit word read from RAM |

This coordinate order is important. Enabling byte enables changed the physical
shape of the Logisim RAM and moved its clock/data ports. A wire that still looks
close after such an attribute change may terminate on the wrong input.

## Store datapath

The RAM's byte enables decide which bytes commit. The data input is replicated
so the selected lane always receives the desired low byte or low halfword.

### Word store

```text
store_bus = Rd
byte_enable = 1111
```

### Byte store

Let `b = Rd[7:0]`:

```text
byte_bus = zero_extend(b)
         | (zero_extend(b) << 8)
         | (zero_extend(b) << 16)
         | (zero_extend(b) << 24)
```

The lane decoder produces:

| `address[1:0]` | Byte enable | Updated word bits |
|---:|---:|---|
| `00` | `0001` | 7:0 |
| `01` | `0010` | 15:8 |
| `10` | `0100` | 23:16 |
| `11` | `1000` | 31:24 |

### Halfword store

Let `h = Rd[15:0]`:

```text
half_bus = zero_extend(h) | (zero_extend(h) << 16)
```

The halfword lane decoder produces:

| `address[1]` | Byte enable | Updated word bits |
|---:|---:|---|
| `0` | `0011` | 15:0 |
| `1` | `1100` | 31:16 |

The non-enabled lanes retain their previous contents inside the RAM. No
read-modify-write feedback path is required.

The fixed shifts are wiring transformations in synthesis; they do not imply a
general barrel shifter on the store-data path.

## Load datapath

The RAM always returns a complete 32-bit word. The load path extracts and
extends the requested subword.

### Byte extraction

```text
address[1:0] = 00 -> raw_byte = ram_data[7:0]
address[1:0] = 01 -> raw_byte = ram_data[15:8]
address[1:0] = 10 -> raw_byte = ram_data[23:16]
address[1:0] = 11 -> raw_byte = ram_data[31:24]
```

Then:

```text
LDRB  -> result = zero_extend(raw_byte)
LDRSB -> result = sign_extend(raw_byte)
```

### Halfword extraction

```text
address[1] = 0 -> raw_half = ram_data[15:0]
address[1] = 1 -> raw_half = ram_data[31:16]
```

Then:

```text
LDRH  -> result = zero_extend(raw_half)
LDRSH -> result = sign_extend(raw_half)
```

The selected value joins the normal load-data/writeback path. Loads are still
condition-gated and write the destination register only when the instruction's
condition passes.

## Why the regression is discriminating

Every store test first writes `0x11223344` as a complete word. A byte or
halfword store then modifies only one lane, followed by a full `LDR`. That makes
neighbor corruption visible. For example:

```text
initial word                = 11223344
STRB 0xaa at address + 1    = 1122aa44
STRH 0xbeef at address + 2  = beef3344
```

The signed-load tests include both signs and multiple lanes. They therefore
distinguish lane-selection errors from sign-extension errors:

```text
LDRSB 0xff -> ffffffff
LDRSB 0x01 -> 00000001
LDRSH 0x8001 -> ffff8001
LDRSH 0x7fff -> 00007fff
```

## Verification commands

Run the focused suite:

```bash
python3 -u tests/memory_lane_regression.py debug_armv4t_2.circ
```

Expected final line:

```text
Memory lane checks: 19/19 passed
```

Run the full architectural regression:

```bash
python3 -u tests/adversarial_regression.py debug_armv4t_2.circ
```

Measured on 2026-09-02:

```text
PASS=53  WRONG=1
Architectural checks: 53/54 passed
```

The single failure is `SWP`, not a byte/halfword transfer failure.

Run the structural checker:

```bash
python3 tests/check_stage.py debug_armv4t_2.circ stage_MEM
```

At the time of this measurement it reports one pre-existing undriven select on
`Multiplexer@760,1830`. All 19 focused memory behaviors and every memory case in
the 54-case suite pass, so this is not being presented as the cause of a known
functional failure. It should still be traced and either driven or removed
before declaring the netlist structurally final.

## Alignment and exception policy still missing

The tested halfword addresses are aligned (`address[0]=0`), and word accesses
are word-aligned. The CPU does not yet implement ARM data-abort exceptions or a
defined trap policy for unaligned transfers. Do not treat the passing aligned
tests as proof of architectural behavior for every unaligned address.

Until exceptions exist, firmware should keep:

- words aligned to 4 bytes;
- halfwords aligned to 2 bytes;
- stack accesses aligned according to the chosen ABI.

## Memory-map assumptions

The current software tests use program ROM below `0x1000`, general RAM from
`0x1000`, scratch data near `0x1100`, and stack space higher in RAM. The CPU
still needs a frozen linker script and a final documented memory map before
freestanding C firmware becomes reproducible.

## Known implementation traps

1. Do not reintroduce read-modify-write for `STRB` or `STRH`; the byte-enable
   RAM already performs lane preservation.
2. A splitter that looks like a combiner may still have its fan order reversed.
   Verify byte ordering with all four lane tests, not only lane zero.
3. Replicating a byte by placing multiple splitter inputs on a visually shared
   net can create an undefined multi-driver net. The explicit fixed-shift/OR
   equation is deterministic.
4. Logisim component geometry changes when RAM attributes change. Re-run the
   graph and stage check after touching the RAM's byte-enable option.
5. A passing load/store pair is insufficient if both halves share the same
   mistake. The suite deliberately observes stores with a full-word load and
   initializes loads with a full-word store.

## Completion boundary

Byte access and halfword/signed transfer behavior are complete for the aligned,
user-mode cases covered above. This does **not** finish ARMv4T memory semantics:
`SWP`/`SWPB`, aborts, exception entry, and a deliberate unaligned-access policy
remain separate work.
