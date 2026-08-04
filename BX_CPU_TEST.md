# BX CPU Test

Verified in `armv4t.circ` on 2026-08-02.

## BX R2

Load `bx_rom`.

```text
MOV R2,#0x10
BX  R2
MOV R0,#1       ; skipped
MOV R1,#2       ; skipped
MOV R3,#0x33
B   .
```

Expected `pc_out`:

```text
0 -> 1 -> 4 -> 5 -> 5 ...
```

Final signature:

```text
R0 = 00000000
R1 = 00000000
R2 = 00000010
R3 = 00000033
pc_out = 5
```

## BX LR

Load `bx_lr_rom`.

Expected final signature:

```text
R14 = 00000010
R0  = 00000000
R1  = 00000000
R3  = 00000033
pc_out = 5
```

This proves exact BX detection, register-target selection, ARM target alignment,
absolute PC redirection, control-flow write suppression, and `BX LR` return.
