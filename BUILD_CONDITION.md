# Building Condition Execution — Offline Field Guide

> **Goal:** make ARM's condition field real.
> `CPSR.N/Z/C/V + instr[31:28] -> condition_checker -> condition_pass`.
>
> A failed condition must become a one-cycle NOP: no register write and no CPSR
> update.
>
> Everything in this guide works with **no internet**. The test words and every
> expected probe value are included below.

## Current status

Completed and CPU-verified:

```text
ALU.N/Z/C/V -> CPSR[3:0] = NZCV
instr[20] (S) -> CPSR.enable
decode write-enable -> reg16x32.WE
```

The arithmetic CPSR regression produced:

```text
0 -> 6 -> 6 -> 9 -> 8 -> A
```

Completed and CPU-verified on 2026-07-28. `MI` and `EQ` committed their results;
false `PL` and `NE` instructions left their destination registers unchanged.

---

## 0. The offline toolkit

```bash
cd ~/Documents/CustomCPU

python3 armv4t_alu.py --decoder     # existing data-processing control words
python3 armv4t_alu.py --test        # sealed ALU/multiplier regression
```

Files to keep beside Logisim:

| file | what it proves |
|---|---|
| `CPSR_CPU_TEST.md` | CPSR storage and S-bit gating already work |
| `cpsr_rom` | arithmetic flag-storage regression |
| `BUILD_CONDITION.md` | this build and its condition regression |

The condition regression ROM image is printed in Stage C. You do not need the
assembler for this build.

---

## 1. What you're building

Create one subcircuit:

```text
condition_checker
```

Interface:

```text
cond[3:0], N, Z, C, V -> condition_pass
```

Then place it between the saved flags and the two architectural write enables:

```text
instr[31:28] ───────────────► condition_checker.cond
CPSR.N/Z/C/V ───────────────► condition_checker.N/Z/C/V

condition_checker.condition_pass ──┬──► gate reg16x32.WE
                                   └──► gate CPSR.enable
```

### What goes in

| component | quantity | purpose |
|---|---:|---|
| input Pin, width 4 | 1 | `cond` |
| input Pin, width 1 | 4 | `N`, `Z`, `C`, `V` |
| output Pin, width 1 | 1 | `condition_pass` |
| NOT gate | 5 | `!N`, `!Z`, `!C`, `!V`, and `!(N XOR V)` |
| XOR gate | 1 | `N XOR V` |
| AND gate | 2 | `HI` and `GT` |
| OR gate | 2 | `LS` and `LE` |
| Multiplexer, 16 inputs | 1 | selects the condition result |
| Constant, width 1 | 2 | `AL=1`, `NV=0` |
| top-level AND gate | 2 | final register and CPSR enables |

All gates are one bit. The condition multiplexer has:

```text
Data Bits   = 1
Select Bits = 4
Inputs      = 16
```

### What you are deliberately NOT building yet

| skipped | why it waits |
|---|---|
| **B / BL / BX** | Branch control consumes `condition_pass`; prove it first. |
| **LDR / STR** | Memory writes will use the same condition gate later. |
| **shifter carry** | This changes how logical instructions produce CPSR.C, not how conditions are evaluated. |
| **Thumb conditions** | This guide builds ARM-state `instr[31:28]`. |

---

## 2. The invariant

ARM conditions read the **stored CPSR**, not the flags currently appearing at the
ALU outputs:

```text
earlier instruction -> CPSR.N/Z/C/V
current instruction + CPSR -> condition_pass
```

The commit rule is:

```text
condition_pass = 0 -> no architectural state changes
```

For the blocks that exist today:

```text
final_reg_WE = decode.write_enable AND condition_pass
final_CPSR_enable = instr[20] AND condition_pass
```

Later this same signal gates:

```text
branch_taken
memory_write
R14_link_write
accelerator_start
```

The ALU may still calculate a result when the condition fails. That is legal.
The result simply cannot be stored.

---

## 3. Build it in three stages. Verify each.

### STAGE A — Build `condition_checker` standalone

Create the circuit and add its six pins:

```text
INPUT:  cond       Data Bits = 4
INPUT:  N          Data Bits = 1
INPUT:  Z          Data Bits = 1
INPUT:  C          Data Bits = 1
INPUT:  V          Data Bits = 1
OUTPUT: condition_pass
```

Build these shared expressions first:

```text
nN   = NOT N
nZ   = NOT Z
nC   = NOT C
nV   = NOT V

NxV  = N XOR V
NeqV = NOT NxV

HI   = C AND nZ
LS   = nC OR Z
GT   = nZ AND NeqV
LE   = Z OR NxV
```

Place the 16-input Multiplexer and wire:

```text
cond       ──► Multiplexer.select
Multiplexer.out ──► condition_pass
```

Connect the mux inputs by their **numbered input**, not by visual position:

| mux input | cond | name | connect |
|---:|---:|---|---|
| `0` | `0000` | EQ | `Z` |
| `1` | `0001` | NE | `nZ` |
| `2` | `0010` | CS/HS | `C` |
| `3` | `0011` | CC/LO | `nC` |
| `4` | `0100` | MI | `N` |
| `5` | `0101` | PL | `nN` |
| `6` | `0110` | VS | `V` |
| `7` | `0111` | VC | `nV` |
| `8` | `1000` | HI | `HI` |
| `9` | `1001` | LS | `LS` |
| `A` | `1010` | GE | `NeqV` |
| `B` | `1011` | LT | `NxV` |
| `C` | `1100` | GT | `GT` |
| `D` | `1101` | LE | `LE` |
| `E` | `1110` | AL | Constant `1` |
| `F` | `1111` | NV | Constant `0` |

For canonical ARMv4T ARM-state execution, `1111` is never/reserved here.

**Verify A — standalone discriminator**

Poke:

```text
N=1 Z=0 C=0 V=0
```

| `cond` | name | expected `condition_pass` |
|---:|---|---:|
| `0` | EQ | `0` |
| `1` | NE | `1` |
| `4` | MI | `1` |
| `5` | PL | `0` |
| `A` | GE | `0` |
| `B` | LT | `1` |
| `C` | GT | `0` |
| `D` | LE | `1` |
| `E` | AL | `1` |
| `F` | NV | `0` |

Now poke:

```text
N=0 Z=1 C=0 V=0
```

Required discriminator:

```text
cond=0 EQ -> 1
cond=1 NE -> 0
cond=C GT -> 0
cond=D LE -> 1
```

Do not continue until all fourteen real conditions, `AL`, and `NV` match.

---

### STAGE B — Feed it the instruction and stored CPSR

At the CPU top level, split the instruction condition:

```text
instr[31:28] ──► condition_checker.cond
```

Split the existing four-bit CPSR register:

```text
CPSR[3] ──► condition_checker.N
CPSR[2] ──► condition_checker.Z
CPSR[1] ──► condition_checker.C
CPSR[0] ──► condition_checker.V
```

The packing invariant is:

```text
CPSR[3:0] = N Z C V
```

So:

```text
CPSR=8 -> N=1 Z=0 C=0 V=0
CPSR=4 -> N=0 Z=1 C=0 V=0
CPSR=A -> N=1 Z=0 C=1 V=0
```

Add probes:

```text
instr_cond
condition_pass
```

Do not change either write-enable path yet. Stage B proves only that the checker
sees the right instruction and stored flags.

**Verify B — checker inside the CPU**

Load these first four words into `instr_rom`:

```text
v3.0 hex words plain
e3a00000 e2501001 43a02022 53a03033
```

Reset and tick manually:

| before tick | instruction | `instr_cond` | CPSR | `condition_pass` |
|---:|---|---:|---:|---:|
| 1 | `MOV R0,#0` | `E` | `0` | `1` |
| 2 | `SUBS R1,R0,#1` | `E` | `0` | `1` |
| 3 | `MOVMI R2,#0x22` | `4` | `8` | `1` |
| 4 | `MOVPL R3,#0x33` | `5` | `8` | `0` |

At this stage `R3` may still incorrectly become `33`, because writeback has not
been gated yet. Only the `condition_pass` column is under test.

---

### STAGE C — Gate architectural commit

Find the existing wire that drives `reg16x32.WE`. Break that direct connection
and insert a two-input AND gate:

```text
decode.write_enable ──┐
                      AND ──► reg16x32.WE
condition_pass ───────┘
```

Find the existing `instr[20] -> CPSR.enable` wire. Break it and insert the second
AND gate:

```text
instr[20] ────────────┐
                      AND ──► CPSR.enable
condition_pass ───────┘
```

Label or probe the two final signals:

```text
final_reg_WE
final_CPSR_enable
```

Do **not** gate the clock. Only gate the register enable pins.

**Verify C — full CPU regression**

Load:

```text
v3.0 hex words plain
e3a00000 e2501001 43a02022 53a03033 e2904000 03a05055 13a06066 e3a07077
```

This program is:

```asm
MOV   R0,#0
SUBS  R1,R0,#1
MOVMI R2,#0x22
MOVPL R3,#0x33
ADDS  R4,R0,#0
MOVEQ R5,#0x55
MOVNE R6,#0x66
MOV   R7,#0x77
```

Reset the CPU and leave every register at zero:

| Tick | instruction | CPSR before | pass | `final_reg_WE` | result after tick | CPSR after |
|---:|---|---:|---:|---:|---|---:|
| 1 | `MOV R0,#0` | `0` | `1` | `1` | `R0=00000000` | `0` |
| 2 | `SUBS R1,R0,#1` | `0` | `1` | `1` | `R1=FFFFFFFF` | `8` |
| 3 | `MOVMI R2,#0x22` | `8` | `1` | `1` | `R2=00000022` | `8` |
| 4 | `MOVPL R3,#0x33` | `8` | `0` | `0` | `R3=00000000` | `8` |
| 5 | `ADDS R4,R0,#0` | `8` | `1` | `1` | `R4=00000000` | `4` |
| 6 | `MOVEQ R5,#0x55` | `4` | `1` | `1` | `R5=00000055` | `4` |
| 7 | `MOVNE R6,#0x66` | `4` | `0` | `0` | `R6=00000000` | `4` |
| 8 | `MOV R7,#0x77` | `4` | `1` | `1` | `R7=00000077` | `4` |

Final signature:

```text
R0 = 00000000
R1 = FFFFFFFF
R2 = 00000022
R3 = 00000000
R4 = 00000000
R5 = 00000055
R6 = 00000000
R7 = 00000077
CPSR = 4
```

The discriminator is:

```text
R2=22 and R5=55 -> passing conditions commit
R3=00 and R6=00 -> failing conditions suppress writeback
```

---

## 4. If it fails — debug in this exact order

Stop at the first mismatch:

| step | probe | expected |
|---:|---|---|
| 1 | `instr[31:28]` on `43A02022` | `4` |
| 2 | CPSR before tick 3 | `8` |
| 3 | checker `N/Z/C/V` before tick 3 | `1/0/0/0` |
| 4 | `condition_pass` before tick 3 | `1` |
| 5 | `condition_pass` before tick 4 | `0` |
| 6 | decode write-enable before tick 4 | `1` |
| 7 | `final_reg_WE` before tick 4 | `0` |
| 8 | CPSR before tick 6 | `4` |
| 9 | `condition_pass` before ticks 6/7 | `1/0` |

Diagnostic signatures:

| observed result | likely fault |
|---|---|
| `R2=0`, `R3=33` | MI/PL inputs reversed, or `N` inverted |
| `R5=0`, `R6=66` | EQ/NE inputs reversed, or `Z` inverted |
| `R3=33` and `R6=66` | `condition_pass` does not gate `reg16x32.WE` |
| every AL instruction stops | mux input `E` is not Constant `1` |
| standalone checker passes, CPU checker fails | instruction or CPSR splitter mapping |
| failed flag-setting instruction changes CPSR | CPSR enable is still only `instr[20]` |

---

## 5. What to avoid

### 🔴 Do not use `ALU.N/Z/C/V` as condition inputs

Conditions read flags from an **earlier** instruction:

```text
CPSR.N/Z/C/V -> condition_checker
```

Using current `ALU.N/Z/C/V` creates the wrong dependency and can create a
combinational feedback path once CPSR control is integrated.

### 🔴 Do not gate the clock

Use:

```text
condition_pass -> enable logic
```

Do not AND `condition_pass` with the clock. Derived clocks introduce glitches
and skew on an FPGA.

### 🔴 Do not gate only register writeback

A failed conditional instruction must not update flags either:

```text
reg16x32.WE = decode.write_enable AND condition_pass
CPSR.enable = instr[20] AND condition_pass
```

Branch and memory enables will receive the same treatment later.

### 🔴 `N XOR V` and `N XNOR V` are opposites

```text
GE = N XNOR V
LT = N XOR V
GT = NOT Z AND (N XNOR V)
LE = Z OR (N XOR V)
```

### 🔴 Trust numbered mux inputs, not top-versus-bottom

Logisim orientation can visually reverse a multiplexer. Confirm input numbers
with the standalone MI/PL and EQ/NE tests before integrating it.

### 🔴 `cond=1111` is not AL

```text
1110 = AL -> 1
1111 = NV/reserved -> 0
```

---

## 6. When it works

The CPU can now make every current ARM data-processing instruction conditional:

```text
CMP/SUBS/ADDS -> CPSR
CPSR + instr.cond -> condition_pass
condition_pass -> architectural commit
```

That completes the control signal needed by the next block:

```text
SUBS R0,R0,#1
BNE  loop
```

Next build:

```text
B and BX control flow
```

Then:

```text
BL -> LDR/STR + data RAM -> stack/ABI -> freestanding C
```

---

## 7. The honest scoreboard

```text
Compute core (ALU + mul + decode)  ████████████████████  100%
Operand2                           ████████████████████  100%
CPSR storage                       ████████████████████  100%
Condition execution                ████████████████████  100%
Minimum C-capable machine          ███████████████░░░░░   75%
```

**One invariant:** `condition_pass=0` means no architectural state changes.
