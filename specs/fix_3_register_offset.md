# Fix 3 — LDR/STR register offsets

**Effort:** one new read port in `stage_ID`, three new pins on `stage_MEM`,
one `barrel_32b` instance and one mux inside it, three tunnels in `main`.
The largest of the three fixes, and the only one that adds datapath.

## Mechanism

`stage_MEM` computes its address as:

```
mem_offset          = zeroExtend( instr_15_0[11:0] )        <- ALWAYS
memory_address_pre  = P ? rd_a + (mem_offset XOR sign) : rd_a
```

The offset is **always** the 12-bit immediate field. But for LDR/STR the
`instr[25]` bit is the I bit and its meaning is **inverted** relative to data
processing:

| `instr[25]` | `class_bits` | offset form |
|---|---|---|
| 0 | `0b010` | immediate — `instr[11:0]` |
| 1 | `0b011` | register — `shift(Rm, type, amount)` |

So for a register-offset access the CPU reads the `shift:Rm` bit pattern as if
it were a number:

```
ldr r0,[r1,r3]          = e7910003   offset used = 3     (should be r3)
ldr r0,[r1,r10]         = e791000a   offset used = 10    (should be r10)
ldr r0,[r1,r3,lsl #2]   = e7910103   offset used = 259   (should be r3<<2)
```

With `r3` the low two bits are dropped by the word addressing, so the access
lands back on the base and the error is invisible. With a scaled offset it
lands somewhere arbitrary.

**Why no suite caught it.** `tests/adversarial_regression.py`'s `word register
offset` case stores *and* loads through the register-offset form. If the offset
is wrong in the same way both times, the round trip still succeeds. The test
cannot fail. `tools/deep_matrix.py` now stores through one addressing mode and
reads back through another.

## The register file already exposes what is needed

`reg16x32_1` outputs **all sixteen** register values (`R0_OUTPUT` …
`R15_OUTPUT`) alongside `RD_A` and `RD_B`, and `reg_read_mux_16x32` is a ready
made 16:1 read mux — `stage_ID` already instantiates two of them, one of which
produces `rs_value` for register-controlled shifts. Adding a third read port is
a copy of an existing block, not new design.

`stage_ID` already emits `rm` (the 4-bit index) and it currently drives
nothing.

The other two `reg_read_mux_16x32` instances are already spoken for — one
produces `rs_value` (register-controlled shift amount), the other now
produces `mul_acc_value` (selected by `rd`, built since this spec was first
written, for the multiplier's accumulate operand). Neither is free; a third
instance is genuinely needed.

## Steps

**1. Third read port in `stage_ID`.**
Add a `reg_read_mux_16x32` instance. Wire its sixteen data inputs from the same
`R0_OUTPUT`…`R15_OUTPUT` nets the existing two use, and its select from the
`rm` net. Add an output pin `rm_value`, width **32**, placed **below
`mul_acc_value`** — re-measured against the file (2026-08-31): `mul_acc_value`
is now the last *output* pin (y=2140), added since this spec was first
written. `bt_active` is an *input* pin (y=1400) — it sits on the other side of
the port-binding order entirely (outputs are bound first, then inputs), so
anchoring a new output to it would have inserted `rm_value` in the middle of
the existing output list and silently shifted `alu_ctrl`, `rs_value`,
`is_long_mul`, `is_mult` and `mul_acc_value` down one position each in every
instance in `main`. Anchor to `mul_acc_value`, not `bt_active`.

**2. New inputs on `stage_MEM`.**
Three pins, all placed **below `cond_pass`** (currently the last):

| name | width |
|---|---|
| `rm_value` | 32 |
| `shift_amount` | 5 |
| `shift_type` | 2 |

**3. Scale the register offset.**
Inside `stage_MEM`, add a `barrel_32b` instance: value ← `rm_value`,
amount ← `shift_amount`, type ← `shift_type`.

**4. Select which offset to use.**
Insert a 32-bit Multiplexer immediately **before** the Bit Extender that
currently produces `mem_offset`, or replace that extender's output net:

- `in0` ← the existing zero-extended `instr_15_0[11:0]` (immediate form)
- `in1` ← the `barrel_32b` output (register form)
- `sel` ← `class_bits[0]`, i.e. `instr[25]`

`stage_MEM` already has `class_bits` as an input, so the select needs only a
splitter fan, no new pin.

Everything downstream — the XOR/carry-in that implements the U bit, the P mux,
the writeback path — is unchanged and already correct. It is only the *source*
of `mem_offset` that is wrong.

**5. Wire the three nets in `main`.**
- `rm_value` — new tunnel, `stage_ID.rm_value → stage_MEM.rm_value`
- `SH_AMT` — the net already exists (`stage_ID.shift_amount → stage_EX`);
  add `stage_MEM.shift_amount` as a second destination
- `SH_TYP` — likewise, add `stage_MEM.shift_type`

Only one genuinely new net.

## A caution about stores

`str r2,[r1,r3]` needs **three** register reads in one cycle: `Rn` (base),
`Rd` (data) and `Rm` (offset). Today `stage_ID` routes
`RB = data_ram_we ? Rd : Rm`, so a store's B port is already taken by the data.
The third read mux added in step 1 is what makes the store case work — do not
try to reuse `rd_b` for it.

## Verify

```bash
python3 tests/check_stage.py     armv4t_2.circ stage_ID
python3 tests/check_stage.py     armv4t_2.circ stage_MEM
python3 tests/check_stage.py     armv4t_2.circ main
python3 tools/deep_matrix.py     armv4t_2.circ   # memory 4/15 -> 8/15 (2 scaled/negative cases need barrel_32b's shift-32 handling, not just the mux)
python3 tools/regression_py.py   armv4t_2.circ   # 'shifted register offset' passes
```

Discriminators, both failing today, both immune to the round-trip trap:

```
    ldr r1,=0x1100          @ LOAD: two different values, offset must pick one
    ldr r4,=0x1110
    ldr r2,=0xAA
    str r2,[r1]
    ldr r2,=0xBB
    str r2,[r4]
    mov r3,#16
    ldr r0,[r1,r3]          @ must be 0xBB.  0xAA means the offset was wrong.
```

```
    ldr r1,=0x1100          @ STORE: written by register offset,
    mov r3,#16              @        read back by immediate offset
    ldr r2,=0xCC
    str r2,[r1,r3]
    ldr r0,[r1,#16]         @ must be 0xCC
```
