# BL CPU Test

Verified in `armv4t.circ` on 2026-08-02.

Load `bl_rom`.

```text
0: MOV R0,#5
1: BL  function
2: MOV R1,#0x33
3: B   .
4: ADD R0,R0,#1
5: BX  LR
```

Expected trace:

```text
tick 1: pc_out=1  R0=00000005
tick 2: pc_out=4  R14=00000008
tick 3: pc_out=5  R0=00000006
tick 4: pc_out=2
tick 5: pc_out=3  R1=00000033
tick 6: pc_out=3
```

Final signature:

```text
R0     = 00000006
R1     = 00000033
R14    = 00000008
pc_out = 3
```

This proves conditional BL detection, relative redirection, `PC+4` link value,
R14 write override, and `BX LR` return to the caller.
