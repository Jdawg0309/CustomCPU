README — ALU CONTROL & OPERATION NOTES (CORRECTED)
=================================================

This ALU supports logical operations and arithmetic using a shared adder.
Subtraction is implemented using two’s complement.

CONTROL SIGNALS
---------------
OP1 OP0 : Opcode (selects logic operation)
SUB     : Arithmetic control bit
          0 = ADD
          1 = SUB

OPERATION TABLE
---------------
OP1 OP0 SUB | OPERATION | DESCRIPTION
---------------------------------------------
 0   0   X  | AND       | A AND B
 1   0   X  | OR        | A OR B
 1   1   X  | XOR       | A XOR B
 X   X   0  | ADD       | A + B
 X   X   1  | SUB       | A + (~B) + 1

NOTE:
- Logical operations ignore SUB
- Arithmetic ignores OP1 OP0

ADDER IMPLEMENTATION
--------------------
B_eff      = B XOR SUB
Cin(bit 0) = SUB
Cin(i)     = Cout(i-1)

SUM        = A XOR B_eff XOR Cin
Cout       = (A AND B_eff) OR (Cin AND (A XOR B_eff))

DESIGN RULES / INVARIANTS
------------------------
- OP1 OP0 select logic operation
- SUB controls arithmetic mode
- ADD and SUB reuse the same adder
- Logical ops bypass the adder
- Carry-out is only meaningful for arithmetic

SANITY CHECKS
-------------
0010 AND 0010        -> 0010
0110 OR  0010        -> 0110
0110 XOR 0010        -> 0100
0010 - 0010 (SUB=1)  -> 0000
0010 + 0010 (SUB=0)  -> 0100

NOTES
-----
This design scales directly to 32 bits using a ripple-carry adder.
Only bit 0 receives Cin = SUB.
