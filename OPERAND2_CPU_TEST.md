# Operand2 Immediate CPU Test

Load `operand2_rom`, reset the simulation, and leave every register at zero.

Read combinational probes before each tick. Read the destination register after
the tick.

| Probe | Clock 1 | Clock 2 | Clock 3 |
|---|---:|---:|---:|
| `instr_rom.data` | `E3A030FF` | `E3A04102` | `E2835102` |
| `instr[25]` | `1` | `1` | `1` |
| `instr[7:0]` | `FF` | `02` | `02` |
| `instr[11:8]` | `0` | `1` | `1` |
| `imm_zext.out` | `000000FF` | `00000002` | `00000002` |
| `imm_rotate_amount.out` | `00` | `02` | `02` |
| `operand2_data_mux.out` | `000000FF` | `00000002` | `00000002` |
| `operand2_amount_mux.out` | `00` | `02` | `02` |
| `operand2_type_mux.out` | `11` | `11` | `11` |
| `barrel_32b.outp` | `000000FF` | `80000000` | `80000000` |
| `ALU.result` | `000000FF` | `80000000` | `800000FF` |
| Register after tick | `R3=000000FF` | `R4=80000000` | `R5=800000FF` |

Final register values:

```text
R3 = 000000FF
R4 = 80000000
R5 = 800000FF
```

Failure signature:

```text
R4 = 00000002
R5 = 00000101
```

That signature means immediate data selection works, but the final immediate
rotation-amount wires are missing or stuck at zero.
