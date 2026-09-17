# Fix: `LSR #32` and `ASR #32`

## Status

Verified in `debug_armv4t_2.circ`.

This fix corrects the ARM immediate-shift encodings for:

- `LSR #32`
- `ASR #32`

It does not modify `armv4t_2.circ`. The working reference circuit is the
debug circuit.

## Why the original circuit was wrong

An ARM data-processing instruction has only five bits for its immediate shift
amount (`instruction[11:7]`). Five bits can represent 0 through 31, so ARM
uses an encoded value of zero specially:

| Shift encoding | Encoded amount | Architectural operation |
|---|---:|---|
| `LSL` immediate | 0 | no shift |
| `LSR` immediate | 0 | shift right by 32 |
| `ASR` immediate | 0 | arithmetic shift right by 32 |
| `ROR` immediate | 0 | RRX (separate behavior; not fixed here) |

Passing the five-bit zero directly into `barrel_32b` therefore makes
`LSR #32` and `ASR #32` behave like a zero-distance shift.

Register-specified shifts are different. A register shift whose `Rs[7:0]` is
zero really does perform no shift. Consequently, the correction must check
that the instruction uses an **immediate** shift.

## Required detection logic

The verified implementation is in `stage_EX` and uses these existing signals:

- `SHIFT_AMOUNT_DECODE[4:0]`: decoded shift amount
- `SHIFT_TYPE_DECODE[1:0]`: `00=LSL`, `01=LSR`, `10=ASR`, `11=ROR`
- `IMM_BIT_SHIFT32`: immediate/register form selector
- `REG_SHIFT_SHIFT32`: register-specified-shift indicator

Create the following logic:

```text
shift_amount_zero = NOT(OR all five bits of SHIFT_AMOUNT_DECODE)

lsr_or_asr = SHIFT_TYPE_DECODE[1] XOR SHIFT_TYPE_DECODE[0]

imm_lsr_asr_32 = shift_amount_zero
                 AND lsr_or_asr
                 AND NOT(IMM_BIT_SHIFT32)
                 AND NOT(REG_SHIFT_SHIFT32)

large_shift_select = REG_LARGE_SHIFT OR imm_lsr_asr_32
```

The debug circuit labels the corresponding components:

- `SHIFT_AMOUNT_NONZERO`: five-input OR
- `SHIFT_AMOUNT_ZERO`: inverter
- `SHIFT_TYPE_LSR_OR_ASR`: XOR
- `NOT_IMM_SHIFT32`: inverter used by the immediate-form qualification
- `NOT_REG_SHIFT32`: inverter
- `IMM_LSR_ASR_32`: four-input AND
- `LARGE_SHIFT_OR`: OR
- `LARGE_SHIFT_SELECT`: resulting control tunnel

`LARGE_SHIFT_SELECT` selects the existing large-shift result instead of the
ordinary barrel-shifter output.

## Required results

For an immediate amount encoded as zero:

| Operation | Result |
|---|---|
| `LSR #32` | `0x00000000` |
| `ASR #32`, input bit 31 = 0 | `0x00000000` |
| `ASR #32`, input bit 31 = 1 | `0xFFFFFFFF` |

The ASR result is therefore 32 copies of the input sign bit. The LSR result is
always zero.

Here `IMM_BIT_SHIFT32` is ARM instruction bit 25: it distinguishes an immediate
Operand2 from the register Operand2 format that contains immediate shifts.
Thus the immediate-shift form requires `NOT(IMM_BIT_SHIFT32)`.

Do **not** turn every zero shift amount into 32. That would break `LSL #0` and
register-specified shifts by zero.

## Discriminator tests

These cases distinguish the fix from a pass-through or blanket `0 -> 32`
conversion:

```armasm
mov r1, #0x80000000
mov r0, r1, lsr #32       @ expected 0x00000000

mov r1, #0x80000000
mov r0, r1, asr #32       @ expected 0xFFFFFFFF

mov r1, #1
mov r0, r1, lsl #0        @ expected 0x00000001

mov r1, #32
mov r3, #0
mov r0, r1, lsr r3        @ expected 0x00000020
```

Run the exhaustive shifter edge matrix:

```bash
python3 tools/edge_matrix.py debug_armv4t_2.circ
```

Expected result:

```text
TOTAL                1563/1563
```

Also run the broader regressions to ensure the special decoder did not alter
ordinary shifts or unrelated instructions:

```bash
python3 tools/deep_matrix.py debug_armv4t_2.circ
python3 tools/regression_py.py debug_armv4t_2.circ
python3 tools/main_suite.py debug_armv4t_2.circ
```

## Remaining related work

- `RRX` (`ROR` immediate with encoded amount zero) needs its own carry-in
  datapath and is not part of this fix.
- Flag-setting logical instructions still need the barrel shifter's carry-out
  for architecturally correct CPSR `C` behavior.
- Register-specified shifts use `Rs[7:0]`, with separate rules for amounts
  equal to 32, greater than 32, and multiples of 32 for `ROR`.
