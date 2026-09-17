# What this CPU still gets wrong — 2026-08-30

Measured against `debug_armv4t_2.circ` (Codex's `reg_shift` + `LSR/ASR #32`
fix applied). `armv4t_2.circ` differs only by those two fixes.

Everything here is reproducible:

```bash
python3 tools/deep_matrix.py   debug_armv4t_2.circ   # 216/244
python3 tools/edge_matrix.py   debug_armv4t_2.circ   # 1563/1563
python3 tools/regression_py.py debug_armv4t_2.circ   # 48/54
python3 tools/main_suite.py    debug_armv4t_2.circ   # 12/15
```

---

## What is solid

**Arithmetic flags: 196/196.** `adds` / `subs` / `cmp` / `cmn` over 7x7 operand
pairs, every N Z C V, including `0x7FFFFFFF+1`, `0x80000000-1` and the
C-is-NOT-borrow convention for subtraction. This is the foundation every
conditional rests on and it is correct.

Also verified: all 14 condition codes, register-form data processing, the
barrel shifter (immediate and register, amounts 0/1/31/32/33/255/256), B / BL /
BX, PC as operand reading +8, MOV/ADD/LDR writes to PC, word LDR/STR with
*immediate* offsets, pre- and post-index writeback, `push_suite` 10/10,
literal pools, and the whole hierarchy structurally clean with 0 width
conflicts.

---

## Defect 1 — register offsets on LDR/STR are ignored entirely

```
str r2,[r1,r3]   r1=0x1100 r3=16   ->  writes 0x1100, not 0x1110
ldr r0,[r1,r3]   r1=0x1100 r3=16   ->  reads  0x1100
```

The offset register is dropped and the access silently hits the base.
`[Rn,Rm]`, `[Rn,-Rm]` and `[Rn,Rm,lsl #n]` are all non-functional, so the
regression's "shifted register offset" failure is this, not a shift problem.

**Why nothing caught it.** `tests/adversarial_regression.py`'s `word register
offset` case stores *and* loads through the register-offset form. With the
offset dropped, both hit the base and the round-trip still succeeds. The test
cannot fail. `tools/deep_matrix.py` now stores through one addressing mode and
reads back through another.

## Defect 2 — block transfer corrupts a register on 11 of 14 forms

Two independent things decide the damage, neither related to block transfer:

* **Whether it fires** is `instr[24:21]` (the P/U/S/W bits) read as an ALU
  opcode and looked up in the control ROM. `push` and `stmdb` encode `op=9`,
  which lands on `TEQ` with write-enable 0, so they escape by luck. Every
  other addressing mode hits a word with write-enable 1.
* **Which register dies** is `instr[15:12]` — the high nibble of the register
  *list*. `pop {r4,pc}` therefore kills **r8**, a register the instruction
  never names.

```
push {r0,r1}        op= 9  clean          pop  {r0,r1}    op= 5  corrupts r0,r1
push {r4,lr}        op= 9  clean          pop  {r4,pc}    op= 5  corrupts r8
stmdb r12!,{r1,r2}  op= 9  clean          ldmia r12!,..   op= 5  corrupts r0,r1,r2
                                          stmib r12!,..   op=13  corrupts r0
                                          ldmda r12!,..   op= 1  corrupts r0,r1,r2
```

Root cause: `block_transfer_control.active` is driven by `ACTIVE_REG.Q`, a
*register*, so `bt_active` is necessarily low on the transfer's first and last
cycle. On those two cycles all six of `stage_WB`'s suppress terms are 0:

```
we = sbwe | bl_taken | (cond_pass & mem_read)
   | (alu_we & cond_pass & !(mem_read | data_ram_we | bl_taken
                             | branch_taken | bx_taken | bt_active))
```

**Fix:** `stage_WB` needs a *combinational* block-transfer signal. Add
`class_bits` as an input (below every existing pin — ports bind by position),
compare against `0b100`, and add that to the 6-input suppress OR. In `main`
that is one more `CLASS` tunnel; the net already exists. Legitimate LDM writes
arrive through the separate `cond_pass & mem_read` term and the `!` writeback
through the secondary port, so neither is affected.

## Defect 3 — logical operations with `S` corrupt C and V

ARM: `ANDS`/`ORRS`/`EORS`/`BICS`/`TST`/`TEQ` set N and Z, take C from the
**shifter**, and leave V untouched. This CPU takes both from the arithmetic
unit.

```
cmp r0,r1  (9,1)             NZCV = 0,0,1,0     C=1, correct
  then ands r2,r0,r1         NZCV = 0,0,0,0     C destroyed
  then and  r2,r0,r1  (no S) NZCV = 0,0,1,0     correctly preserved

cmp r0,r1 ; movhi r5,#1                  -> r5=1   HI taken
cmp r0,r1 ; ands r2,r0,r1 ; movhi r5,#1  -> r5=0   HI not taken
```

Any logical op between a compare and a conditional silently changes the
branch. 14 of 19 cases fail; `eors` and `bics` also set V spuriously.

## Defect 4 — byte and halfword memory

* `STRB` does not truncate: storing `0x1FF` writes the full word
* `LDRB` does not zero-extend
* Byte lanes alias — writing lane 1 changes lane 0
* `STRH`/`LDRH`, `LDRSB`, `LDRSH` all absent; they return the base address
* The RAM has no byte-enable wiring

## Defect 5 — multiply decoded but not executed

Decode is **correct and verified**: `is_mul` is 0 on every non-multiply
instruction and 1 only on `mul`, and `wa` takes `instr[19:16]` (multiply's Rd
field is swapped relative to data processing). What is missing is execute:

```
mul_32.A / .B              -> NOTHING          engine mux in2 / in3 -> NOTHING
ks_32b product bus         -> NOTHING          ks_32b.Cin           -> NOTHING
mul_32 csa@(7100,370)      sum + carry go nowhere
mul_32 csa@(940,370)       X, Y, Z all unconnected
```

## Defect 6 — smaller confirmed gaps

* `RRX` behaves as no shift
* `SWP` / `SWPB` absent
* `MRS` returns 0; `MSR` does not alter NZCV; CPSR is a bare 4-bit NZCV
  register with no datapath port either direction
* `SWI` falls through instead of vectoring to 0x08
* Thumb absent — `BX` to an odd target is suppressed by `NOT_THUMB`

---

## Suggested order

1. **Register offsets** — silently wrong addresses, no existing test catches it
2. **Block-transfer suppress** — 11/14 forms, silent, hits unnamed registers
3. **Logical-op flags** — C and V must not come from the adder
4. Byte lanes and halfword/signed loads
5. The multiplier — decode is done, only EX/WB integration remains

The first three are decode/control fixes inside stages that already exist, not
new datapath. Doing them before the multiplier matters: block transfer
corrupts a register on almost every LDM/STM, so any multiplier misbehaviour
debugged on top of it is indistinguishable from it.

---

## Tests that could not fail

Recorded because each one reported green over a real defect:

| suite | case | why it could not fail |
|---|---|---|
| `adversarial_regression` | word register offset | stores and loads through the same broken form |
| `adversarial_regression` | all 5 `block` cases | overwrite the victim register after the transfer |
| `smoke_suite` | `shift_reg` | carried a `KNOWN_GAPS` note unconditionally |
| `deep_matrix` (mine) | 196 flag cases | hardcoded a pc; `ldr rN,=const` expands to two words |
| `deep_matrix` (mine) | add-to-pc jump | my expectation ignored that pc reads +8 |

Build discriminators, not plausible passes.
