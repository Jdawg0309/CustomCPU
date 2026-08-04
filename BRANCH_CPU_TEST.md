# ARM Branch CPU Test

Verified in `armv4t.circ` on 2026-07-28.

## Unconditional branch

Load `branch_rom`.

```text
MOV R0,#1
B   0x0C
MOV R0,#2       ; skipped
ADD R1,R0,#4
B   0x10        ; self-loop
```

Expected `pc_out`:

```text
0 -> 1 -> 3 -> 4 -> 4 -> 4 ...
```

Final signature:

```text
R0 = 00000001
R1 = 00000005
pc_out = 4
```

## Conditional backward branch

Load `branch_cond_rom`.

```text
MOV  R0,#2
loop:
SUBS R0,R0,#1
BNE  loop
MOV  R1,#0x55
B    .
```

Expected `pc_out`:

```text
0 -> 1 -> 2 -> 1 -> 2 -> 3 -> 4 -> 4 ...
```

Final signature:

```text
R0 = 00000000
R1 = 00000055
CPSR = 6
pc_out = 4
```

This proves forward and backward signed offsets, ARM's `PC+8` branch base,
condition gating, fall-through, and a stable self-loop.
