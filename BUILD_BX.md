# Building BX — Offline Field Guide

> **Goal:** execute `BX Rm`, including `BX LR`, for ARM-state function returns.
>
> `BX` is an absolute register branch. Unlike `B`, it does not contain a relative
> offset.

## Current status

Completed:

```text
B/BNE -> relative branch target -> pc_fetch
instr[3:0] -> reg16x32.RB
reg16x32.RD_B -> current Rm value
```

Completed and CPU-verified on 2026-08-02. Both `BX R2` and `BX LR` redirected to
an absolute register target, skipped two instructions, and reached the expected
self-loop.

---

## 0. The offline toolkit

```bash
cd ~/Documents/CustomCPU
```

Use manual ticking with Auto-Tick disabled.

---

## 1. What you're building

```text
instr[27:4] == 0x12FFF1 -> is_BX
is_BX AND condition_pass AND NOT Rm[0] -> bx_taken
Rm AND 0xFFFFFFFC -> bx_arm_target
```

Then:

```text
B relative target ──┐
                    mux selected by bx_taken -> branch target
BX absolute target ─┘

branch_taken OR bx_taken -> pc_fetch.BRANCH
```

### What goes in

| component | purpose |
|---|---|
| 24-bit instruction splitter | exposes `instr[27:4]` |
| 24-bit Comparator and Constant `12FFF1` | exact BX detection |
| NOT and AND gates | condition and ARM-state target gating |
| 32-bit AND with `FFFFFFFC` | word-aligns ARM target |
| two new `pc_fetch` inputs | `ABS_SELECT`, `ABS_TARGET` |
| 32-bit 2:1 mux inside `pc_fetch` | relative versus absolute target |
| OR gate | combines `B` and `BX` redirects |

### What you are deliberately NOT building yet

| skipped | reason |
|---|---|
| Thumb execution | `Rm[0]=1` requests Thumb state; reject it for now. |
| BL | Separate R14 link-write path. |
| exception return | Requires full CPSR/SPSR and processor modes. |

---

## 2. The invariant

BX encoding:

```text
instr[27:4] = 0001 0010 1111 1111 1111 0001
            = 0x12FFF1
instr[3:0]  = Rm
```

ARM-state target:

```text
bx_arm_target = reg16x32.RD_B AND 0xFFFFFFFC
```

For now:

```text
bx_taken = is_BX AND condition_pass AND NOT reg16x32.RD_B[0]
```

When Thumb is added:

```text
Rm[0]=1 -> CPSR.T=1 and target bit0 cleared
Rm[0]=0 -> CPSR.T=0 and target bits1:0 cleared
```

---

## 3. Build it in three stages. Verify each.

### STAGE A — Detect BX

Add a splitter on the full instruction:

```text
instr[27:4] -> 24-bit strand
```

Use a Comparator:

```text
Data Bits = 24
```

Connect:

```text
instr[27:4] -> Comparator.A
Constant 0x12FFF1, width 24 -> Comparator.B
Comparator.A=B -> is_BX
```

Add probes:

```text
instr[27:4]
is_BX
```

**Verify A:**

| word | instruction | `[27:4]` | `is_BX` |
|---:|---|---:|---:|
| `E12FFF10` | `BX R0` | `12FFF1` | `1` |
| `E12FFF12` | `BX R2` | `12FFF1` | `1` |
| `E12FFF1E` | `BX LR` | `12FFF1` | `1` |
| `E1A0F00E` | `MOV PC,LR` | `1A0F00` | `0` |
| `EA000000` | `B` | `A00000` | `0` |

Then split `reg16x32.RD_B[0]` and build:

```text
is_BX ──────────────┐
condition_pass ─────┼-> AND -> bx_taken
NOT RD_B[0] ────────┘
```

An odd `Rm` must produce `bx_taken=0` until Thumb exists.

---

### STAGE B — Build the absolute target and extend pc_fetch

At the CPU top level:

```text
reg16x32.RD_B AND Constant FFFFFFFC -> bx_arm_target
```

Add two input pins inside `pc_fetch`:

```text
ABS_SELECT  width 1
ABS_TARGET  width 32
```

Inside `pc_fetch`, find the output of the branch adder:

```text
relative_target = PC.current + IMM
```

Insert a 32-bit 2:1 Multiplexer before the existing final PC mux:

```text
relative_target -> new mux input 0
ABS_TARGET      -> new mux input 1
ABS_SELECT      -> new mux select
new mux output  -> existing final PC mux branch input
```

At top level:

```text
bx_taken      -> pc_fetch.ABS_SELECT
bx_arm_target -> pc_fetch.ABS_TARGET
```

Combine redirects:

```text
branch_taken ──┐
               OR -> pc_fetch.BRANCH
bx_taken ──────┘
```

---

### STAGE C — Suppress writeback and test

Create:

```text
control_flow = branch_class OR is_BX
not_control_flow = NOT control_flow
```

Replace `not_branch_class` on both commit gates:

```text
ALU.write_enable AND condition_pass AND not_control_flow -> reg16x32.WE
instr[20] AND condition_pass AND not_control_flow -> CPSR.enable
```

Load:

```text
v3.0 hex words plain
e3a02010 e12fff12 e3a00001 e3a01002 e3a03033 eafffffe
```

Expected:

| Tick | `pc_out` before | instruction | `pc_out` after | result |
|---:|---:|---|---:|---|
| 1 | `0` | `MOV R2,#0x10` | `1` | `R2=10` |
| 2 | `1` | `BX R2` | `4` | addresses 2 and 3 skipped |
| 3 | `4` | `MOV R3,#0x33` | `5` | `R3=33` |
| 4+ | `5` | `B .` | `5` | self-loop |

Final:

```text
R0 = 00000000
R1 = 00000000
R2 = 00000010
R3 = 00000033
pc_out = 5
```

BX LR test:

```text
v3.0 hex words plain
e3a0e010 e12fff1e e3a00001 e3a01002 e3a03033 eafffffe
```

Expected same control flow, with:

```text
R14 = 00000010
R3  = 00000033
pc_out = 5
```

---

## 4. If it fails — debug in this exact order

| step | probe | expected on `E12FFF12` |
|---:|---|---:|
| 1 | `instr[27:4]` | `12FFF1` |
| 2 | `is_BX` | `1` |
| 3 | regfile `RB` | `2` |
| 4 | `RD_B` | `00000010` |
| 5 | `RD_B[0]` | `0` |
| 6 | `bx_arm_target` | `00000010` |
| 7 | `bx_taken` | `1` |
| 8 | `pc_fetch.ABS_SELECT` | `1` |
| 9 | PC after tick | byte `10`, `pc_out=4` |

---

## 5. What to avoid

### Do not compare the condition nibble

The fixed BX pattern is `instr[27:4]`. Bits `31:28` remain available for normal
conditional execution.

### Do not feed BX through branch_delta

`B` is PC-relative. `BX` is an absolute register target.

### Do not execute odd BX targets as ARM

An odd target requests Thumb state. Until Thumb exists, suppress `bx_taken`.

### Do not let BX write an ordinary destination register

BX has no Rd. Include `is_BX` in the control-flow write-suppression path.

---

## 6. When it works

The CPU can return from an ARM-state function:

```asm
BX LR
```

Next:

```text
BL -> R14 link write -> LDR/STR + data RAM
```

---

## 7. The honest scoreboard

```text
B branch                           100%
BX return path                     100%
Minimum C-capable machine          ~83%
```
