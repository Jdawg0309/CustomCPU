# Euclidean GCD CPU Test

Load `gcd_rom`, reset the CPU, and use manual ticks.

The program computes `gcd(48,18)` using conditional subtraction:

```text
0: MOV   R0,#48
1: MOV   R1,#18
2: CMP   R0,R1
3: SUBGT R0,R0,R1
4: SUBLT R1,R1,R0
5: BNE   2
6: B     .
```

Expected values at the start of each loop:

```text
(R0,R1) = (48,18)
(R0,R1) = (30,18)
(R0,R1) = (12,18)
(R0,R1) = (12,6)
(R0,R1) = (6,6)
```

Expected final signature after 23 ticks:

```text
R0     = 00000006
R1     = 00000006
CPSR   = 6
pc_out = 6
```

This test exercises arithmetic, flags, conditional execution, and a backward
conditional branch. It does not require stack support.
