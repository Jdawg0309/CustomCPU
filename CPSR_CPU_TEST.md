# CPSR CPU Test

Load `cpsr_rom`, reset the simulation, and leave every register at zero.

The four-bit flag register uses:

```text
CPSR[3:0] = NZCV
```

Read `ALU.N/Z/C/V` before each tick and `CPSR` after it.

| Tick | Instruction | S | `ALU.result` | `ALU.NZCV` | CPSR after tick |
|---:|---|---:|---:|---:|---:|
| 1 | `MVN R1,R0` | 0 | `FFFFFFFF` | ignore | `0` |
| 2 | `ADDS R2,R1,#1` | 1 | `00000000` | `0110` | `6` |
| 3 | `MVN R3,#80000000` | 0 | `7FFFFFFF` | ignore | `6` |
| 4 | `ADDS R4,R3,#1` | 1 | `80000000` | `1001` | `9` |
| 5 | `SUBS R5,R0,#1` | 1 | `FFFFFFFF` | `1000` | `8` |
| 6 | `SUBS R6,R1,#1` | 1 | `FFFFFFFE` | `1010` | `A` |

Expected CPSR sequence:

```text
0 -> 6 -> 6 -> 9 -> 8 -> A
```

Final register values:

```text
R1 = FFFFFFFF
R2 = 00000000
R3 = 7FFFFFFF
R4 = 80000000
R5 = FFFFFFFF
R6 = FFFFFFFE
```

The unchanged `6` on tick 3 proves `S=0` preserves CPSR. This regression verifies
arithmetic NZCV storage and S-bit gating. Logical instructions still need a
separate `shifter_carry` source for canonical CPSR.C behavior.
