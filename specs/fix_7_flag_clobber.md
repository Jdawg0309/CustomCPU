# Fix 7 — halfword/signed loads and LDM overwrite the flags (`arm_custom_subset.circ`)

Found 2026-10-24 by `tests/unicorn_diff.py` (Logisim circuit vs Unicorn ARM925T,
an ARMv4T core). Nothing here was written to the master.

## The defect

`cmp r0,#1` then `ldrh r2,[r10]` then a conditional instruction: the hardware
sees different flags than ARM does.

| instruction | flags after it |
|---|---|
| `ldr` `ldrb` `str` `strb` `strh` `stm` | preserved (correct) |
| `ldrh` `ldrsb` `ldrsh` `ldm` (all modes) | **overwritten from the ALU output** |

Also true on the committed circuit before repair 3 — it predates that repair.

Evidence it is the only cause: 56/56 single load/store forms match Unicorn;
the random load/store programs fail 0/8 with conditions and pass 8/8 without;
with conditions kept but `ldrh/ldrsb/ldrsh` removed they pass 10/10.

## Root cause (derived from the file, stage_EX)

```text
CPSR write enable : AND_CPSRW = cond_pass AND NOT_DP AND s_bit
NOT_DP            = NOT( OR_NOFLAG2 )
OR_NOFLAG2        = OR_NOFLAG OR AND_MEMCLASS
OR_NOFLAG         = branch_class OR CMP_BX
AND_MEMCLASS      = class[1] AND NOT class[2]        (instr[27:25] = 01x, LDR/STR)
```

`s_bit` is instruction bit 20. In load/store forms bit 20 is **L (load)**, not S.
The no-flag list excludes branches, BX and plain LDR/STR only. It misses:

* **block transfer**, `instr[27:25] = 100` (`class_bits == 4`): LDM has L = 1.
* **halfword/signed transfer**, `class_bits == 0` with `instr[7] = 1`,
  `instr[4] = 1` and `instr[6:5] != 00`: LDRH/LDRSB/LDRSH have L = 1.

`instr[6:5] = 00` is MUL/MLA/SWP, where bit 20 really is S (MULS sets N, Z), so it
must stay out of the exclusion. Data-processing register-shifted-by-register has
`instr[7] = 0`, so it is never caught by the new term either.

## Everything needed is already on stage_EX pins

`class_bits` (3 bits, pin y=960) and `instr_27_4` (24 bits, pin y=2350) are
both existing inputs. **No new pin and no change to `main`**, so no port shifts.

`class_bits` bits: `[0] = instr[25]`, `[1] = instr[26]`, `[2] = instr[27]`.
`instr_27_4` bits: `[0] = instr[4]`, `[1] = instr[5]`, `[2] = instr[6]`,
`[3] = instr[7]`.

## New parts (8)

1. Comparator `BLOCK_CLASS`: 3-bit, unsigned. a = `class_bits`, b = Constant `0x4`.
   Use its `eq` output.
2. Comparator `CLASS0`: 3-bit, unsigned. a = `class_bits`, b = Constant `0x0`.
   Use its `eq` output.
3. Splitter `INSTR_LOW`: Bit Width In 24, Fan Out 4. Map bits 0, 1, 2, 3 to fans
   0, 1, 2, 3 (one bit each). Map bits 4–23 to **none**. Input = `instr_27_4`.
   Fan 0 = `instr[4]`, fan 1 = `instr[5]`, fan 2 = `instr[6]`, fan 3 = `instr[7]`.
4. OR (2 inputs) `SH_NOT00`: in0 = `instr[5]` (fan 1), in1 = `instr[6]` (fan 2).
5. AND (4 inputs) `HW_CLASS`: `CLASS0`, `instr[7]` (fan 3), `instr[4]` (fan 0),
   `SH_NOT00`.
6. OR (3 inputs) `OR_NOFLAG3`: in0 = `OR_NOFLAG2`.out, in1 = `BLOCK_CLASS`.eq,
   in2 = `HW_CLASS`.out.

(Counts: 2 comparators + their 2 constants, 1 splitter, 3 gates = 8 parts.)

## The one rewire

The NOT gate that makes `NOT_DP` (the one whose output is the `NOT_DP` probe and
feeds `AND_CPSRW`) currently takes its input from `OR_NOFLAG2`.out.
**Disconnect that input from `OR_NOFLAG2`.out and connect it to `OR_NOFLAG3`.out.**

`OR_NOFLAG2` itself, `OR_NOFLAG`, `AND_MEMCLASS` and `AND_CPSRW` stay as they are.

## Acceptance (real engine)

```bash
python3 tests/unicorn_diff.py arm_custom_subset.circ --category mem   --programs 16 --seed 11
python3 tests/unicorn_diff.py arm_custom_subset.circ --category block --programs 12 --seed 11
```

Both must report every program identical **without** `--mask-flags`. Then re-run
the regression table (register-offset 15/15, memory-lane 19/19, shifter 204/204,
extra 34/34, deep 243/244, adversarial 51/54): nothing may regress.

Directed discriminator (flags N=1 before; expected 8, currently 0):
`cmp r0,#1` / `ldrh r2,[r10]` / capture flags.
Must also stay correct: `ldr`, `ldrb`, `str`, `strh`, `stm` (already 8).
