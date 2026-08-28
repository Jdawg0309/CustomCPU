# The `cond 000` class decoder — spec

**The highest-leverage work left in the project.** `stage_ID` never tests
`instr[7]` and `instr[4]`, and that single gap accounts for **10 of the 11**
remaining architectural failures:

| behind this gap | failures |
|---|---|
| register-specified shifts | 5 |
| MUL / MLA / SWP | 3 |
| halfword & signed transfer | 2 |

Only the scaled register offset is separate.

---

## 1. What the two bits do

When `instr[27:25] == 000`, the instruction is **not** necessarily
data-processing. Bits 7 and 4 split that space four ways:

```
instr[27:25] == 000
│
├─ instr[4] == 0 ──────────────────────► data-processing, immediate shift
│                                        (everything the CPU does today)
└─ instr[4] == 1
   ├─ instr[7] == 0 ───────────────────► data-processing, REGISTER shift
   └─ instr[7] == 1
      ├─ instr[6:5] == 00 ─────────────► multiply / swap      (instr[7:4] = 1001)
      └─ instr[6:5] != 00 ─────────────► halfword / signed transfer
                                          01 = LDRH/STRH
                                          10 = LDRSB
                                          11 = LDRSH
```

Today everything in that box is treated as immediate-shift data-processing.
That is why `mul r0,r1,r2` returns 0 and `mov r2,r0,lsl r1` shifts by the wrong
amount -- the CPU is executing them as if they were `AND`, `EOR` and friends
with a garbage shift field.

---

## 2. Every bit you need is already extracted

`stage_ID`'s `instr[11:4]` splitter already produces all three:

```
   fan0 = instr[4]      -> reg_shift      (an OUTPUT that nothing consumes)
   fan1 = instr[6:5]    -> shift_type
   fan2 = instr[11:7]   -> shift_amount   (its bit 0 IS instr[7])
```

plus `class_bits` = `instr[27:25]` and `opcode` = `instr[24:21]`.

So the only new extraction is **`instr[7]`**, which is bit 0 of
`shift_amount`.

> **Do not take `instr[7]` by re-fanning the 8-bit splitter.** A bus bit can
> route to exactly one fan, and `instr[7]` must stay inside `shift_amount` --
> it is the LSB of the immediate shift amount whenever `instr[4] == 0`. It does
> double duty, so it needs a second, independent tap.

---

## 3. This group is purely additive and cannot break anything

Every signal below is a **new output**. Nothing existing is rewired, no mux
gains an input, no net is cut. Until a consumer exists in EX or MEM, the CPU
behaves exactly as it does now.

That is deliberate: build and verify the decode on its own, then wire consumers
one feature at a time.

---

## 4. Components

| label | type | attributes |
|---|---|---|
| `S_I7` | Splitter | Bit Width In **5**, Fan Out **2** — Bit 0 → fan 0, Bits 1–4 → fan 1 |
| `NOT_I7` | NOT Gate | |
| `NOR_CLASS0` | NOR Gate | **3 inputs** |
| `AND_EXT` | AND Gate | 2 inputs |
| `AND_REGSHIFT` | AND Gate | 2 inputs |
| `NOR_HW00` | NOR Gate | 2 inputs |
| `AND_MULSWP` | AND Gate | 3 inputs |
| `OR_HW` | OR Gate | 2 inputs |
| `AND_HWXFER` | AND Gate | 3 inputs |
| `S_OPC` | Splitter | Bit Width In **4**, Fan Out **4**, one bit per fan |
| `NOT_O3`, `NOT_O2`, `NOT_O1` | NOT Gate | |
| `AND_SWP` | AND Gate | 3 inputs |
| `AND_MULFAM` | AND Gate | 3 inputs |
| `AND_MUL` | AND Gate | **3 inputs** |
| `AND_MLA` | AND Gate | **3 inputs** |

If `stage_ID` already has a splitter on `opcode` for another purpose, reuse it
rather than adding `S_OPC`.

---

## 5. Equations

```
instr_7      = shift_amount[0]                       via S_I7 fan 0

ext          = (class_bits == 000) AND instr[4]
             = NOR(class_bits[0], class_bits[1], class_bits[2]) AND reg_shift

is_regshift  = ext AND NOT instr_7

mulswp       = ext AND instr_7 AND NOR(shift_type[0], shift_type[1])
is_hwxfer    = ext AND instr_7 AND  OR(shift_type[0], shift_type[1])

is_swp       = mulswp AND     opcode[3] AND NOT opcode[2]     instr[27:23] = 00010
mulfam       = mulswp AND NOT opcode[3] AND NOT opcode[2]     instr[27:23] = 00000
is_mul       = mulfam AND NOT opcode[1] AND NOT opcode[0]     instr[23:21] = 000
is_mla       = mulfam AND NOT opcode[1] AND     opcode[0]     instr[23:21] = 001
```

Recall `opcode` is `instr[24:21]`, so `opcode[3]` = `instr[24]`, `opcode[2]` =
`instr[23]`, `opcode[1]` = `instr[22]`, `opcode[0]` = `instr[21]`.

`mulswp` and `mulfam` are internal; the rest become pins.

---

## 6. Connections, by name

- `shift_amount` → `S_I7.combined`; `S_I7` fan 0 (1 bit) = **`instr_7`**;
  fan 1 (4 bits) leave unconnected
- `instr_7` → `NOT_I7.in` and to `AND_MULSWP.in1`, `AND_HWXFER.in1`
- `class_bits` → `S_CLASS` (the existing 3-bit splitter, if there is one) or a
  new one; its three fans → `NOR_CLASS0.in0/in1/in2`
- `NOR_CLASS0.out` → `AND_EXT.in0`; `reg_shift` → `AND_EXT.in1`
- `AND_EXT.out` = **ext** → `AND_REGSHIFT.in0`, `AND_MULSWP.in0`, `AND_HWXFER.in0`
- `NOT_I7.out` → `AND_REGSHIFT.in1`; `AND_REGSHIFT.out` → pin **`is_regshift`**
- `shift_type` → a 2-bit splitter; both fans → `NOR_HW00` and → `OR_HW`
- `NOR_HW00.out` → `AND_MULSWP.in2`; `OR_HW.out` → `AND_HWXFER.in2`
- `AND_HWXFER.out` → pin **`is_hwxfer`**
- `opcode` → `S_OPC.combined`; fans give `opcode[3:0]`
- `AND_SWP` ← `AND_MULSWP.out`, `opcode[3]`, `NOT_O2.out` → pin **`is_swp`**
- `AND_MULFAM` ← `AND_MULSWP.out`, `NOT_O3.out`, `NOT_O2.out`
- `AND_MUL` ← `AND_MULFAM.out`, `NOT_O1.out`, `NOT_O0.out` → pin **`is_mul`**
- `AND_MLA` ← `AND_MULFAM.out`, `NOT_O1.out`, `opcode[0]` → pin **`is_mla`**

---

## 7. New `stage_ID` outputs

Place **all five below every existing pin.** After `main` is wired, pin order
is append-only; this is the last comfortable moment to add a batch.

| name | width | consumer |
|---|---|---|
| `is_regshift` | 1 | `stage_EX` — shift-amount source |
| `is_mul` | 1 | `stage_EX`, and `stage_ID`'s own operand routing |
| `is_mla` | 1 | `stage_EX` / `stage_ID` |
| `is_swp` | 1 | `stage_MEM` |
| `is_hwxfer` | 1 | `stage_MEM` |

`shift_type` already carries `instr[6:5]`, which is the halfword *type* — no
separate output needed.

---

## 8. Traps

1. **`instr[7]` must stay in `shift_amount`.** Section 2. Tap it, do not move
   it.
2. **`NOR_CLASS0` is 3 inputs, `AND_MULSWP` / `AND_HWXFER` / `AND_SWP` /
   `AND_MULFAM` / `AND_MUL` / `AND_MLA` are 3 inputs.** Logisim defaults to 2
   and the missing input is silent.
3. **`opcode` is `instr[24:21]`, not `instr[27:24]`.** Off by one here makes
   SWP decode as MUL.
4. **Nothing is rewired.** If you find yourself cutting an existing net, stop —
   this group is additive only.
5. Watch for a **1-bit comparator** if you use comparators instead of gate
   trees; that was the `CMP_BLOCK` defect in `stage_MEM`, and
   `Sim.width_conflicts()` will catch it again.

---

## 9. Verifying

Structural, and the interface:

```bash
python3 tests/check_stage.py armv4t_2.circ stage_ID
python3 tools/check_stage_fit.py armv4t_2.circ
```

The five new outputs will show as "outputs with no consumer in the contract"
until EX and MEM use them. That is correct at this stage.

Behavioural — tell me when it is in and I will drive each class through the
simulator and check the four signals are mutually exclusive and correct:

```asm
    and  r0, r1, r2          @ ext=0  -> all four low
    mov  r2, r0, lsl r1      @ is_regshift only
    mul  r0, r1, r2          @ is_mul only
    mla  r0, r1, r2, r3      @ is_mla only
    swp  r0, r1, [r2]        @ is_swp only
    ldrh r0, [r1]            @ is_hwxfer only, shift_type = 01
    ldrsb r0, [r1]           @ is_hwxfer only, shift_type = 10
```

**The discriminator that matters: `and r0,r1,r2` must leave all four low.** An
`ext` term that forgets `instr[4]` decodes every ordinary data-processing
instruction as an extension, and the CPU stops working entirely — that is the
one way this additive change can break something.
