# Pre-Memory CPU Regression

Run this entire pack before adding LDR/STR or data RAM.

## Setup

1. Load `opcode` into the 64K x 10-bit decoder ROM.
2. Turn automatic ticking off.
3. Load one regression image into the top-level `instr_rom`.
4. Reset the entire simulation so PC, registers, and CPSR are zero.
5. Tick only the number shown below.
6. Compare the final signature before loading the next image.

## Tests

| ROM | Ticks | Expected final signature |
|---|---:|---|
| `01_compute_rom` | 16, then stop | R1=FFFFFFFF R2=1 R3=8 R4=3 R5=5 R6=1 R7=7 R8=6 R9=4 R10=5 R11=FFFFFFFC R12=2 R13=FFFFFFFE R14=11 |
| `02_barrel_rom` | 16, then stop | R8=80000000 R9=1 R10=FFFFFFFF R11=80000000 R12=00010000 R13=2 R14=11 R3=80000000 R4=80000000 |
| `03_immediate_rom` | 3 | R3=FF R4=80000000 R5=800000FF |
| `04_cpsr_rom` | 6 | R1=FFFFFFFF R2=0 R3=7FFFFFFF R4=80000000 R5=FFFFFFFF R6=FFFFFFFE CPSR=A |
| `05_condition_rom` | 8 | R1=FFFFFFFF R2=22 R3=0 R4=0 R5=55 R6=0 R7=77 CPSR=4 |
| `06_branch_rom` | 4 | R0=1 R1=5 pc_out=4 |
| `07_branch_cond_rom` | 7 | R0=0 R1=55 CPSR=6 pc_out=4 |
| `08_bx_rom` | 4 | R0=0 R1=0 R2=10 R3=33 pc_out=5 |
| `09_bx_lr_rom` | 4 | R0=0 R1=0 R14=10 R3=33 pc_out=5 |
| `10_bl_rom` | 6 | R0=6 R1=33 R14=8 pc_out=3 |
| `11_compiled_c_rom` | 6 | R0=8 R1=3 R14=14 pc_out=5 |

The first two ROMs fill all 16 addresses and therefore have no self-loop. Stop
after tick 16 or the ROM address wraps to zero. The other control-flow tests end
in stable self-loops.

## Coverage

```text
01  arithmetic + logic + write suppression
02  LSL + LSR + ASR + ROR register Operand2
03  rotated-immediate Operand2 and instr[25] selection
04  arithmetic N/Z/C/V and S-bit gating
05  condition checker and failed-condition commit suppression
06  unconditional relative B
07  conditional backward BNE
08  absolute BX Rm
09  BX LR
10  BL link write to R14 and BX LR return
11  GCC ARMv4T leaf C execution
```

Regenerate the pack with:

```text
python3 build_regression_roms.py
```
