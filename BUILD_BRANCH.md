# Building ARM Branch — Offline Field Guide

> **Goal:** execute canonical ARM `B` instructions, including conditional
> branches.
>
> `instr[27:25]=101 + condition_pass -> pc_fetch.BRANCH`
>
> Everything here works offline. Every instruction word and expected PC value is
> included below.

## Current status

Already complete:

```text
pc_fetch.BRANCH=0 -> PC.next = PC.current + 4
pc_fetch.BRANCH=1 -> PC.next = PC.current + pc_fetch.IMM
condition_checker -> condition_pass
```

Completed and CPU-verified on 2026-07-28. Both an unconditional skip/self-loop
regression and a conditional backward `BNE` loop passed.

---

## 0. The offline toolkit

```bash
cd ~/Documents/CustomCPU

python3 armv4t_alu.py --test
```

Use manual ticking. Keep Auto-Tick off.

---

## 1. What you're building

Three signals:

```text
is_B
branch_delta
branch_taken
```

Final flow:

```text
instr[27:25] + instr[24] -> is_B
instr[23:0] -> sign extend -> <<2 -> +8 -> branch_delta
is_B AND condition_pass -> branch_taken

branch_taken -> pc_fetch.BRANCH
branch_delta -> pc_fetch.IMM
```

### What goes in

| component | purpose |
|---|---|
| one 3-bit equality path | detects `instr[27:25]=101` |
| one NOT gate | rejects `BL` while only `B` is implemented |
| one AND gate | `is_B AND condition_pass` |
| one instruction splitter | exposes `instr[23:0]` |
| one Sign Extender 24->32 | preserves negative offsets |
| one constant Shifter `<<2` | converts words to bytes |
| one 32-bit Adder + Constant `8` | ARM visible-PC correction |

### What you are deliberately NOT building yet

| skipped | reason |
|---|---|
| **BL** | Requires writing the return address into R14. |
| **BX** | Uses an absolute register target and changes ARM/Thumb state from bit 0. |
| **Thumb state** | Current instruction path is ARM-state 32-bit only. |
| **R15 as a normal register operand** | Separate architectural-PC cleanup. |

---

## 2. The invariant

For an ARM-state branch at instruction address `A`:

```text
architectural target = A + 8 + sign_extend(instr[23:0] << 2)
```

The existing `pc_fetch` branch adder computes:

```text
PC.next = PC.current + pc_fetch.IMM
```

Therefore this CPU must feed:

```text
pc_fetch.IMM = sign_extend(instr[23:0] << 2) + 8
```

The `+8` is not optional. It models the architecturally visible ARM PC value.

The commit invariant remains:

```text
branch_taken = is_B AND condition_pass
```

---

## 3. Build it in three stages. Verify each.

### STAGE A — Detect `B`

Use the existing three-bit output:

```text
instr[27:25]
```

Build:

```text
branch_class = instr[27] AND (NOT instr[26]) AND instr[25]
```

Extract `instr[24]`, the link bit, from the existing `instr[24:21]` strand:

```text
local bit 3 = instr[24]
local bits [2:0] = instr[23:21]
```

Then:

```text
is_B = branch_class AND (NOT instr[24])
branch_taken = is_B AND condition_pass
```

Rejecting `instr[24]=1` prevents `BL` from branching without writing R14.

Add probes:

```text
branch_class
is_B
branch_taken
```

**Verify A:**

| word | instruction | `instr[27:25]` | `instr[24]` | `is_B` | `branch_taken` |
|---:|---|---:|---:|---:|---:|
| `E3A00001` | `MOV R0,#1` | `001` | `1` | `0` | `0` |
| `EA000000` | `B` | `101` | `0` | `1` | `1` |
| `EB000000` | `BL` | `101` | `1` | `0` | `0` |
| `1A000000` with Z=1 | `BNE` | `101` | `0` | `1` | `0` |
| `1A000000` with Z=0 | `BNE` | `101` | `0` | `1` | `1` |

Do not connect `pc_fetch.BRANCH` yet.

---

### STAGE B — Build the signed branch delta

Split the full 32-bit instruction a second time:

```text
instr[23:0] -> branch_imm24
instr[31:24] -> unused by this offset path
```

Set the Bit Extender:

```text
Input width  = 24
Output width = 32
Extend type  = Sign
```

Wire:

```text
instr[23:0]
-> Sign Extend 24->32
-> Shifter Logical Left by constant 2
-> 32-bit Adder with Constant 8
-> branch_delta
```

Equivalent equation:

```text
branch_delta = (sign_extend(instr[23:0]) << 2) + 8
```

Add probes:

```text
branch_imm24
branch_shifted
branch_delta
```

**Verify B:**

| word | `imm24` | shifted signed offset | expected `branch_delta` |
|---:|---:|---:|---:|
| `EA000000` | `000000` | `00000000` | `00000008` |
| `EA000001` | `000001` | `00000004` | `0000000C` |
| `EAFFFFFF` | `FFFFFF` | `FFFFFFFC` | `00000004` |
| `EAFFFFFE` | `FFFFFE` | `FFFFFFF8` | `00000000` |
| `1AFFFFFD` | `FFFFFD` | `FFFFFFF4` | `FFFFFFFC` |

`EAFFFFFE` is the self-loop discriminator. Its adjusted delta is zero, so
`PC.next=PC.current`.

---

### STAGE C — Connect `pc_fetch`

Remove the two top-level constants currently driving:

```text
pc_fetch.BRANCH
pc_fetch.IMM
```

Replace them:

```text
branch_taken -> pc_fetch.BRANCH
branch_delta -> pc_fetch.IMM
```

Do not modify the inside of `pc_fetch`.

Also suppress ordinary register writeback for branch-class instructions. The
current data-processing decoder can produce meaningless controls for a branch
encoding:

```text
final_reg_WE =
    ALU.write_enable
    AND condition_pass
    AND (NOT branch_class)
```

For now, also suppress CPSR writes on branch-class instructions:

```text
final_CPSR_enable =
    instr[20]
    AND condition_pass
    AND (NOT branch_class)
```

**Verify C1 — unconditional branch skips one instruction**

The tables below show the internal byte-addressed PC. The existing top-level
`pc_fetch.pc_out` is `PC[5:2]`, so its probe displays word addresses:

```text
byte PC 00,04,0C,10 -> pc_out 0,1,3,4
```

Load:

```text
v3.0 hex words plain
e3a00001 ea000000 e3a00002 e2801004 eafffffe
```

| Tick | byte PC before (`pc_out`) | instruction | byte PC after (`pc_out`) | result |
|---:|---:|---|---:|---|
| 1 | `00` (`0`) | `MOV R0,#1` | `04` (`1`) | `R0=1` |
| 2 | `04` (`1`) | `B 0x0C` | `0C` (`3`) | no register write |
| 3 | `0C` (`3`) | `ADD R1,R0,#4` | `10` (`4`) | `R1=5` |
| 4 | `10` (`4`) | `B 0x10` | `10` (`4`) | self-loop |

Required final signature:

```text
R0 = 00000001
R1 = 00000005
PC = 00000010
```

The instruction at address `08`, `MOV R0,#2`, must never execute.

**Verify C2 — conditional loop terminates**

Load:

```text
v3.0 hex words plain
e3a00002 e2500001 1afffffd e3a01055 eafffffe
```

| Tick | byte PC before (`pc_out`) | instruction | pass | byte PC after (`pc_out`) | result |
|---:|---:|---|---:|---:|---|
| 1 | `00` (`0`) | `MOV R0,#2` | `1` | `04` (`1`) | `R0=2` |
| 2 | `04` (`1`) | `SUBS R0,R0,#1` | `1` | `08` (`2`) | `R0=1`, CPSR=`2` |
| 3 | `08` (`2`) | `BNE 0x04` | `1` | `04` (`1`) | branch |
| 4 | `04` (`1`) | `SUBS R0,R0,#1` | `1` | `08` (`2`) | `R0=0`, CPSR=`6` |
| 5 | `08` (`2`) | `BNE 0x04` | `0` | `0C` (`3`) | fall through |
| 6 | `0C` (`3`) | `MOV R1,#0x55` | `1` | `10` (`4`) | `R1=55` |
| 7 | `10` (`4`) | `B 0x10` | `1` | `10` (`4`) | self-loop |

Required final signature:

```text
R0 = 00000000
R1 = 00000055
CPSR = 6
PC = 00000010
```

---

## 4. If it fails — debug in this exact order

| step | probe | expected |
|---:|---|---|
| 1 | `instr[27:25]` on `EA000000` | `5` |
| 2 | `instr[24]` on `EA000000` | `0` |
| 3 | `is_B` on `EA000000` | `1` |
| 4 | `branch_delta` on `EA000000` | `00000008` |
| 5 | `branch_taken` on `EA000000` | `1` |
| 6 | PC after branch at address `04` | `0C` |
| 7 | `branch_delta` on `1AFFFFFD` | `FFFFFFFC` |
| 8 | failed BNE with CPSR=`6` | `branch_taken=0` |

| observed result | likely fault |
|---|---|
| branch lands four bytes early | missing ARM `+8` correction |
| backward branch becomes a huge forward branch | used Zero Extend instead of Sign Extend |
| every branch goes forward | sign bit lost before `<<2` |
| `BL` branches without setting R14 | `instr[24]` is not excluding BL |
| branch changes a register | branch class does not suppress `reg16x32.WE` |
| BNE loops forever at R0=0 | `condition_pass` is not gating `branch_taken` |

---

## 5. What to avoid

### 🔴 Do not use `PC+4` as the ARM branch base

The encoded offset is relative to `A+8`, where `A` is the current instruction
address.

### 🔴 Sign-extend before or after shifting without losing bit 23

The branch immediate is signed. `imm24=FFFFFF` means `-1`, not a large positive
number.

### 🔴 Do not let branch encodings reach ordinary writeback

The existing decode ROM was built around data-processing opcodes. Explicitly
suppress register and CPSR writes for `branch_class`.

### 🔴 Do not implement BL as B

`BL` must save a return address in R14. Reject it until link writeback exists.

---

## 6. When it works

The CPU has real conditional control flow:

```asm
loop:
    SUBS R0,R0,#1
    BNE  loop
```

Next:

```text
BX -> BL -> LDR/STR + data RAM
```

---

## 7. The honest scoreboard

```text
Compute core                       100%
Condition execution               100%
B branch                           100%
Minimum C-capable machine          ~80%
```

**One invariant:** a taken ARM branch at address `A` loads
`A + 8 + sign_extend(imm24 << 2)`.
