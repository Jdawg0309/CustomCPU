# Building Operand2 — Offline Field Guide

> **Goal:** make ARM data-processing operand2 real.
> `Rm LSL #0` was a wire for M1. Now operand2 becomes:
> register-shifted `Rm`, or ARM's rotated immediate.
>
> Everything in this guide works with **no internet**. All values here can be
> checked from the local Python oracle and the instruction words listed below.

## Current status

Completed and CPU-verified on 2026-07-27:

```text
I=0: reg16x32.RD_B -> register shift -> barrel_32b -> ALU.B
I=1: zext(imm8) -> ROR by (rotate*2) -> barrel_32b -> ALU.B
```

Verified regression:

```text
MOV R3,#0xFF                 -> R3 = 0x000000FF
MOV R4,#0x80000000           -> R4 = 0x80000000
ADD R5,R3,#0x80000000        -> R5 = 0x800000FF
```

The next CPU block is CPSR plus condition execution.

---

## 0. The offline toolkit

```bash
cd ~/Documents/CustomCPU

python3 armv4t_alu.py --shift 0x9E3779B9     # barrel_32b reference values
python3 armv4t_alu.py --shiftproof           # proves staged shifter composition
python3 armv4t_alu.py --decoder              # opcode -> control ROM word
python3 armv4t_alu.py --test                 # ALU/mul golden tests
```

**Diagrams on disk**:

| file | what it shows |
|---|---|
| `cpu_datapath.svg` | whole current CPU datapath |
| `barrel_chain.svg` | `barrel_32b` internals |
| `bs_stage.svg` | one fixed-shift stage |

**Important:** `asm.py` currently assembles only `Rm LSL #0`. For the shifted and
immediate tests in this guide, use the machine words printed here.

---

## 1. What you're building

M1 used:

```
reg16x32.RD_B ──► ALU.B
```

Real ARM data-processing uses:

```
reg16x32.RD_B ──► barrel_32b ──┐
                               ├──► operand2 mux ──► ALU.B
imm8 zext ─────► barrel_32b ───┘
```

This is still mostly plumbing. `barrel_32b` is already built and verified.

### What goes in

| block | status |
|---|---|
| `barrel_32b` | ✅ built, standalone-verified |
| instruction splitter | exists, but shift field must be used now |
| one 2:1 mux | new — selects register operand2 vs immediate operand2 |
| one 8→32 zero extension path | new — for `imm8` |
| one small `rot4 << 1` wiring path | new — immediate rotate amount |

### What you are deliberately NOT building yet

| skipped | why it's safe |
|---|---|
| **register-specified shifts** | ARM uses bit4=1 and Rs in bits 11..8. Build immediate-shift form first. |
| **`shifter_carry`** | Separate block. Needed for C flag on logic ops, not for operand value. |
| **RRX / LSR #0 / ASR #0 quirks** | Encoding fixes. The data barrel takes amount 0..31 literally. |
| **CPSR + condition check** | Next guide. For now flags can still be observed directly from ALU outputs. |
| **memory/branch** | Not needed to prove operand2. |

---

## 2. The invariant

Operand2 must be the exact value the ALU sees on `B`.

For register form:

```
operand2 = shift(Rm, instr[11:7], instr[6:5])
```

For immediate form:

```
operand2 = ROR(zero_extend(instr[7:0]), 2 * instr[11:8])
```

That second line is the whole ARM immediate trick. The immediate is only 8 bits,
but it can be rotated to hit useful bit positions like `0x80000000` and
`0xFF000000`.

---

## 3. Build it in three stages. Verify each.

### STAGE A — Register-shifted operand2

Wire the existing CPU path through `barrel_32b`:

```
reg16x32.RD_B        ──► barrel_32b.input_32b
instr[11:7]          ──► barrel_32b.amnt
instr[6:5]           ──► barrel_32b.typ
barrel_32b.outp      ──► ALU.B
```

Keep everything else exactly as M1:

```
reg16x32.RD_A        ──► ALU.A
decode_rom controls  ──► ALU controls
ALU.result           ──► reg16x32.WD
ALU.write_enable_out ──► reg16x32.WE
```

**Splitter detail:** the old `instr_fields` strand `11..4` was intentionally
unconnected during M1. Now split it:

| instruction bits | width | goes to |
|---|---:|---|
| `11..7` | 5 | `barrel_32b.amnt` |
| `6..5` | 2 | `barrel_32b.typ` |
| `4` | 1 | leave `0` path only for now; register-specified shifts are later |

**✅ Verify A0 — old code still works**

Load `boot_rom` and run the M1 program again. Every old instruction has shift
field `00000000`, so:

```
amnt = 0
typ  = 00
barrel_32b.outp == RD_B
```

Final result must still include `R3 = 0x00000008`. If M1 breaks, the barrel
insert is wrong.

**✅ Verify A1 — shifted register instruction**

Use this one-word ROM image:

```text
v3.0 hex words plain
e0813202
```

Instruction:

```text
ADD R3, R1, R2, LSL #4    word = 0xE0813202
```

Poke:

```text
R1 = 0x00000005
R2 = 0x00000003
```

Expect before the tick:

```text
RD_B             = 0x00000003
barrel_32b.amnt  = 0x04
barrel_32b.typ   = 00
barrel_32b.outp  = 0x00000030
ALU.result       = 0x00000035
```

After one tick:

```text
R3 = 0x00000035
```

That proves the register-shifted path is real.

---

### STAGE B — Immediate operand value

Build the immediate path standalone before adding the mux.

```
instr[7:0]      ──► zero-extend 8→32 ──► barrel_32b.input_32b
instr[11:8]     ──► shift-left-by-1 wiring ──► barrel_32b.amnt
Constant 3      ──► barrel_32b.typ          (11 = ROR)
barrel_32b.outp ──► imm_operand2 probe
```

The rotate amount is:

```
amnt[0] = 0
amnt[4:1] = instr[11:8]
```

Do not use arithmetic for this. It is wire placement.

**✅ Verify B — immediate constants**

Use these instruction words as probes:

| instruction | word | imm8 | rot4 | expected immediate |
|---|---:|---:|---:|---:|
| `MOV R3,#0xFF` | `0xE3A030FF` | `0xFF` | `0` | `0x000000FF` |
| `ADD R3,R1,#0x80000000` | `0xE2813102` | `0x02` | `1` | `0x80000000` |
| `ORR R3,R1,#0xFF000000` | `0xE38134FF` | `0xFF` | `4` | `0xFF000000` |

For the second row:

```
zero_extend(0x02) = 0x00000002
amnt = 2 * rot4 = 2
ROR #2 = 0x80000000
```

That is the discriminator for the immediate rotate wiring.

---

### STAGE C — Operand2 mux

Now add one 2:1 mux before `ALU.B`.

```
register_shifted_operand ──► mux input 0
immediate_operand        ──► mux input 1
instr[25] I-bit          ──► mux select
mux output               ──► ALU.B
```

Set the mux:

| attribute | value |
|---|---|
| Data Bits | 32 |
| Select Bits | 1 |
| Include Enable? | No |

**Invariant:**

```
I = 0 -> ALU.B = shifted register operand
I = 1 -> ALU.B = rotated immediate operand
```

**✅ Verify C0 — register path still works**

Run `ADD R3,R1,R2,LSL #4` again:

```text
word = 0xE0813202
I    = 0
R1   = 5
R2   = 3
R3   = 0x00000035
```

**✅ Verify C1 — immediate path works**

Use this one-word ROM image:

```text
v3.0 hex words plain
e2813102
```

Instruction:

```text
ADD R3, R1, #0x80000000    word = 0xE2813102
```

Poke:

```text
R1 = 0x00000005
```

Expect before the tick:

```text
I-bit             = 1
imm_operand2      = 0x80000000
ALU.B             = 0x80000000
ALU.result        = 0x80000005
```

After one tick:

```text
R3 = 0x80000005
```

That proves the I-bit mux is choosing the immediate path.

---

## 4. If it fails — debug in this exact order

| # | probe | expect | if wrong |
|---|---|---|---|
| 1 | `boot_rom` after barrel insert | still ends `R3=8` | `amnt=0` bypass path or mux select wrong |
| 2 | `instr[11:7]` on `0xE0813202` | `0x04` | shift field splitter wrong |
| 3 | `instr[6:5]` on `0xE0813202` | `00` | type bits swapped |
| 4 | `barrel_32b.outp` for R2=3, LSL #4 | `0x30` | barrel input or amount path wrong |
| 5 | `instr[25]` on `0xE2813102` | `1` | I-bit not split correctly |
| 6 | immediate `amnt` on `0xE2813102` | `0x02` | forgot `rot4 << 1` wiring |
| 7 | immediate operand for `0xE2813102` | `0x80000000` | imm8 zero-extend or ROR path wrong |
| 8 | `ALU.B` | selected operand2 | final operand2 mux input order wrong |

The seam is step 8. If both candidate operands are correct but `ALU.B` is wrong,
the mux select or input order is wrong.

---

## 5. What to avoid

### 🔴 Do not feed `instr[11:4]` directly to `amnt`

ARM's register immediate-shift field is 8 bits, but the amount is only:

```
instr[11:7]
```

The type is:

```
instr[6:5]
```

Bit 4 is the register-shift selector. Leave it for later.

### 🔴 Immediate rotate is `2 × rot4`

Do not send `instr[11:8]` directly as the amount. It must become:

```
amnt = {rot4, 0}
```

Equivalently:

```
amnt[0] = 0
amnt[4:1] = rot4
```

### 🔴 Immediate input is zero-extended

`imm8` is a value, not a mask:

```
0xFF -> 0x000000FF
```

Use Zero extension, not Sign extension.

### 🔴 Keep `shifter_carry` out of this block

This guide proves operand values. Carry-out is a separate parallel block. Mixing
it in now creates two unknowns at once.

### 🔴 `asm.py` does not parse these instructions yet

Use the exact machine words in this guide until the assembler is extended.

---

## 6. When it works

The CPU can execute real ARM register-shifted and immediate data-processing
operands:

```asm
ADD R3, R1, R2, LSL #4
MOV R3, R2, ASR #31
ADD R3, R1, #0x80000000
ORR R3, R1, #0xFF000000
```

Then the next block is **CPSR + condition check**:

```
ALU.N/Z/C/V ──► CPSR register ──► condition checker ──► execute
```

That is the block that turns `CMP` into useful control flow and opens the path to
branches and loops.

---

## 7. The honest scoreboard

```
Compute core (ALU + mul + decode)  ████████████████████  100%
Datapath                           ████████████████░░░░   85%   ← operand2: → ~90%
Memory & control flow              ░░░░░░░░░░░░░░░░░░░░    0%
Pipeline                           ░░░░░░░░░░░░░░░░░░░░    0%
NPU (gate-level 4×4, separate)     ████████░░░░░░░░░░░░   35%
```

**One invariant:** `ALU.B` must equal the architected operand2. If it does, the
ALU does not care whether that value came from a register shift or a rotated
immediate.
