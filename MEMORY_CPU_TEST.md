# Basic Memory CPU Test

Load `memory_regression_rom`, reset the simulation, and use manual ticks.

Coverage:

```text
STR/LDR positive immediate offset
STR/LDR negative immediate offset
failed-condition STR suppression
failed-condition LDR suppression
```

Expected final signature after 12 ticks:

```text
R0     = 000000AA
R1     = 00000020
R2     = 000000AA
R3     = 00000055
R4     = 00000055
R5     = 00000033
CPSR   = 2
pc_out = B

RAM[07] = 00000055    byte address 0000001C
RAM[09] = 000000AA    byte address 00000024
```

At ROM addresses 9 and A, `condition_pass=0`. Therefore both
`data_ram.write_enable` and `ldr_reg_WE` must be zero. R5 remaining `33` proves
the failed LDR did not commit; RAM address `0A` must not be changed by the
failed STR.
