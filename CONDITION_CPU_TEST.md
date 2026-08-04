# Condition Execution CPU Test

Verified in `armv4t.circ` on 2026-07-28.

Load `condition_rom`, reset the simulation, and leave every register at zero.

```text
CPSR[3:0] = NZCV
final_reg_WE  = ALU.write_enable AND condition_pass
CPSR.enable   = instr[20] AND condition_pass
```

| Tick | Instruction | CPSR before | Pass | Register after tick | CPSR after |
|---:|---|---:|---:|---|---:|
| 1 | `MOV R0,#0` | `0` | `1` | `R0=00000000` | `0` |
| 2 | `SUBS R1,R0,#1` | `0` | `1` | `R1=FFFFFFFF` | `8` |
| 3 | `MOVMI R2,#0x22` | `8` | `1` | `R2=00000022` | `8` |
| 4 | `MOVPL R3,#0x33` | `8` | `0` | `R3=00000000` | `8` |
| 5 | `ADDS R4,R0,#0` | `8` | `1` | `R4=00000000` | `4` |
| 6 | `MOVEQ R5,#0x55` | `4` | `1` | `R5=00000055` | `4` |
| 7 | `MOVNE R6,#0x66` | `4` | `0` | `R6=00000000` | `4` |
| 8 | `MOV R7,#0x77` | `4` | `1` | `R7=00000077` | `4` |

Final signature:

```text
R1 = FFFFFFFF
R2 = 00000022
R3 = 00000000
R4 = 00000000
R5 = 00000055
R6 = 00000000
R7 = 00000077
CPSR = 4
```

`R2=22` and `R5=55` prove passing conditions commit. `R3=0` and `R6=0`
prove failed conditions suppress register writes.
