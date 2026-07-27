# Barrel Shifter CPU Test

Load `instr_rom`, reset the simulation, and leave every register at zero.

Read `barrel_32b.outp` before each tick. Read the destination register after
the tick.

| Tick | `instr[11:4]` | Amount | Type | Barrel output | Register after tick |
|---:|---:|---:|---|---:|---|
| 1 | `00` | 0 | LSL | `00000000` | `R1 = FFFFFFFF` |
| 2 | `00` | 0 | LSL | `FFFFFFFF` | `R2 = 00000001` |
| 3 | `08` | 1 | LSL | `00000002` | `R3 = 00000002` |
| 4 | `10` | 2 | LSL | `00000004` | `R4 = 00000004` |
| 5 | `20` | 4 | LSL | `00000010` | `R5 = 00000010` |
| 6 | `40` | 8 | LSL | `00000100` | `R6 = 00000100` |
| 7 | `80` | 16 | LSL | `00010000` | `R7 = 00010000` |
| 8 | `F8` | 31 | LSL | `80000000` | `R8 = 80000000` |
| 9 | `FA` | 31 | LSR | `00000001` | `R9 = 00000001` |
| 10 | `FC` | 31 | ASR | `FFFFFFFF` | `R10 = FFFFFFFF` |
| 11 | `0E` | 1 | ROR | `80000000` | `R11 = 80000000` |
| 12 | `86` | 16 | ROR | `00010000` | `R12 = 00010000` |
| 13 | `FE` | 31 | ROR | `00000002` | `R13 = 00000002` |
| 14 | `20` | 4 | LSL | `00000010` | `R14 = 00000011` |
| 15 | `0A` | 1 | LSR | `7FFFFFFF` | `R3 = 80000000` |
| 16 | `0A` | 1 | LSR | `7FFFFFFF` | `R4 = 80000000` |

Type encoding: `00=LSL`, `01=LSR`, `10=ASR`, `11=ROR`.
