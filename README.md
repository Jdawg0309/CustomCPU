# Custom 32-bit Logisim CPU

This repository contains a custom 32-bit CPU built in Logisim-style digital logic. The CPU includes a program counter, ROM instruction memory, 16-register file, ALU, RAM, load/store datapath, branch control using the ALU zero flag, and a small custom instruction set architecture.

![CPU datapath](./image.png)

## Current Status

The CPU currently supports:

```text
NOP
ADD
ADDI
SUB
AND
OR
XOR
LOAD
STORE
BRZ
```

Confirmed features:

```text
32-bit instructions
16 general-purpose registers
32-bit ALU
16 x 32-bit RAM
ROM-based program execution
word-addressed memory
conditional branching through saved ALU zero flag
custom machine-code instruction format
```

This is not a RISC-V, ARM, or x86 CPU. It uses a custom ISA designed and tested directly against the datapath.

## CPU Datapath Overview

The CPU has the following major blocks:

```text
PC_fetch        - program counter and instruction fetch logic
ROM 16 x 32     - instruction memory
reg16x32        - 16-register file, 32 bits per register
ALU_32bit       - arithmetic and logic unit
RAM 16 x 32     - data memory
writeback mux   - selects ALU result or RAM output for register writeback
zero flag regs  - stores ALU flags for branch decisions
```

The high-level datapath is:

```text
ROM instruction
      ↓
instruction split into opcode / registers / control / immediate
      ↓
register file reads RA and RB
      ↓
ALU computes arithmetic, logic, or memory address
      ↓
result either writes back to register file or addresses RAM
      ↓
RAM output can write back through the writeback mux
```

## Instruction Format

Every instruction is 32 bits.

```text
[ opcode ][ WA ][ RA ][ RB ][ ctrl ][ imm12 ]
   4 bits  4b   4b   4b    4b     12 bits
```

Bit layout:

|    Bits | Field    | Meaning                                           |
| ------: | -------- | ------------------------------------------------- |
| `31:28` | `opcode` | main operation/control opcode                     |
| `27:24` | `WA`     | destination register / write address              |
| `23:20` | `RA`     | source A / base register                          |
| `19:16` | `RB`     | source B / store-data register / immediate marker |
| `15:12` | `ctrl`   | control nibble                                    |
|  `11:0` | `imm12`  | immediate / address offset / branch field         |

Example:

```text
963f2800
```

Decodes as:

```text
9    6    3    f    2       800
op   WA   RA   RB   ctrl    imm12
```

Meaning:

```text
opcode = 9
WA     = 6
RA     = 3
RB     = f
ctrl   = 2
imm12  = 800
```

For this CPU, that instruction means:

```text
R6 = RAM[(R3 + 0x800) >> 2]
```

## Control Nibble

The fifth hex digit is the control nibble.

```text
bits 15:12 = ctrl
```

| ctrl hex | bits `15:12` | Meaning                                                  |
| -------: | ------------ | -------------------------------------------------------- |
|      `0` | `0000`       | normal ALU / ADDI mode                                   |
|      `1` | `0001`       | RAM write enable / STORE mode                            |
|      `2` | `0010`       | RAM output enable + MemToReg / LOAD mode                 |
|      `4` | `0100`       | branch checks saved ALU zero flag                        |
|      `8` | `1000`       | branch XOR/invert-side control, reserved/experimental    |
|      `c` | `1100`       | possible inverted branch behavior, reserved/experimental |

The confirmed control nibbles are:

```text
0 = normal ALU/ADDI
1 = STORE
2 = LOAD
4 = BRZ
```

## Memory Addressing

RAM is `16 x 32`, so each RAM slot stores one 32-bit word.

The CPU computes a byte-style address:

```text
address = R[RA] + imm12
```

But RAM uses word addressing:

```text
RAM slot = ALU_result[5:2]
```

So addresses advance by 4 bytes per RAM word.

| Address | RAM slot |
| ------: | -------: |
| `0x800` |      `0` |
| `0x804` |      `1` |
| `0x808` |      `2` |
| `0x80c` |      `3` |
| `0x810` |      `4` |

This means:

```text
STORE r1, 0x800(r3)  -> RAM[0]
STORE r1, 0x804(r3)  -> RAM[1]
STORE r1, 0x808(r3)  -> RAM[2]
STORE r1, 0x80c(r3)  -> RAM[3]
```

## Opcode Table

| Opcode / Pattern           | Operation | Meaning                              |
| -------------------------- | --------- | ------------------------------------ |
| `0`                        | NOP       | no visible state change              |
| `1`                        | AND       | `R[WA] = R[RA] & R[RB]`              |
| `5`                        | OR        | `R[WA] = R[RA] \| R[RB]`             |
| `9`, `RB != f`, `ctrl = 0` | ADD       | `R[WA] = R[RA] + R[RB]`              |
| `9`, `RB = f`, `ctrl = 0`  | ADDI      | `R[WA] = R[RA] + imm12`              |
| `9`, `RB = f`, `ctrl = 2`  | LOAD      | `R[WA] = RAM[(R[RA] + imm12) >> 2]`  |
| `b`                        | SUB       | `R[WA] = R[RA] - R[RB]`              |
| `d`                        | XOR       | `R[WA] = R[RA] ^ R[RB]`              |
| `8`, `ctrl = 1`            | STORE     | `RAM[(R[RA] + imm12) >> 2] = R[RB]`  |
| `8`, `ctrl = 4`            | BRZ       | branch if saved ALU zero flag is `1` |

Unused or unconfirmed opcodes:

```text
2, 3, 4, 6, 7, a, c, e, f
```

## Confirmed Instruction Examples

| Instruction | opcode |  WA |  RA |  RB | ctrl | imm12 | Meaning                       |
| ----------- | -----: | --: | --: | --: | ---: | ----: | ----------------------------- |
| `00000000`  |    `0` | `0` | `0` | `0` |  `0` | `000` | NOP                           |
| `d0000000`  |    `d` | `0` | `0` | `0` |  `0` | `000` | `R0 = R0 ^ R0`                |
| `d1110000`  |    `d` | `1` | `1` | `1` |  `0` | `000` | `R1 = R1 ^ R1`                |
| `d3330000`  |    `d` | `3` | `3` | `3` |  `0` | `000` | `R3 = R3 ^ R3`                |
| `d6660000`  |    `d` | `6` | `6` | `6` |  `0` | `000` | `R6 = R6 ^ R6`                |
| `900f0005`  |    `9` | `0` | `0` | `f` |  `0` | `005` | `R0 = R0 + 5`                 |
| `911f0003`  |    `9` | `1` | `1` | `f` |  `0` | `003` | `R1 = R1 + 3`                 |
| `911f002a`  |    `9` | `1` | `1` | `f` |  `0` | `02a` | `R1 = R1 + 0x2a`              |
| `14010000`  |    `1` | `4` | `0` | `1` |  `0` | `000` | `R4 = R0 & R1`                |
| `56010000`  |    `5` | `6` | `0` | `1` |  `0` | `000` | `R6 = R0 \| R1`               |
| `d5010000`  |    `d` | `5` | `0` | `1` |  `0` | `000` | `R5 = R0 ^ R1`                |
| `92010000`  |    `9` | `2` | `0` | `1` |  `0` | `000` | `R2 = R0 + R1`                |
| `b3010000`  |    `b` | `3` | `0` | `1` |  `0` | `000` | `R3 = R0 - R1`                |
| `80311800`  |    `8` | `0` | `3` | `1` |  `1` | `800` | `RAM[(R3 + 0x800) >> 2] = R1` |
| `963f2800`  |    `9` | `6` | `3` | `f` |  `2` | `800` | `R6 = RAM[(R3 + 0x800) >> 2]` |
| `80004ffc`  |    `8` | `0` | `0` | `0` |  `4` | `ffc` | BRZ using saved zero flag     |

## Control Logic

The ALU-B mux chooses either `RD_B` or `imm12`.

Confirmed equation:

```text
ALUSrcImm = (RB == f) OR bit12 OR bit13
```

So:

| Instruction type | ALU input B |
| ---------------- | ----------- |
| register ALU     | `RD_B`      |
| ADDI             | `imm12`     |
| STORE            | `imm12`     |
| LOAD             | `imm12`     |

Important STORE split:

```text
RD_A = R[RA]  -> ALU input A
imm12         -> ALU input B
ALU result    -> RAM address

RD_B = R[RB]  -> RAM data input
```

Important LOAD path:

```text
RD_A + imm12  -> ALU result
ALU[5:2]      -> RAM address
RAM output    -> writeback mux
writeback mux -> register file WD
```

## Pseudoinstructions

The hardware does not currently have a true `LI` instruction. It is better implemented as an assembler pseudoinstruction.

### CLEAR

```asm
CLEAR rd
```

Expands to:

```asm
XOR rd, rd, rd
```

Example:

```asm
CLEAR r1
```

Machine code:

```text
d1110000
```

### LI

```asm
LI rd, imm12
```

Expands to:

```asm
XOR  rd, rd, rd
ADDI rd, rd, imm12
```

Example:

```asm
LI r1, 0x02a
```

Machine code:

```text
d1110000
911f002a
```

### BEQ

There is no native BEQ instruction yet. It can be simulated with `SUB + BRZ`.

```asm
BEQ ra, rb, label
```

Expands to:

```asm
SUB temp, ra, rb
BRZ label
```

Example:

```asm
SUB r5, r0, r1
BRZ target
```

## Test ROMs

### Store + Load Test

```text
d0000000 d1110000 d3330000 d6660000 911f002a 80311800 963f2800 00000000
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
```

Expected:

```text
R0 = 00000000
R1 = 0000002a
R3 = 00000000
R6 = 0000002a
RAM[0] = 0000002a
```

### Sequential Store Test

```text
d1110000 d2220000 d3330000 d4440000 d5550000 911f0011 922f0022 944f0033
955f0044 80311800 80321804 80341808 8035180c 00000000 00000000 00000000
```

Expected:

```text
RAM[0] = 00000011
RAM[1] = 00000022
RAM[2] = 00000033
RAM[3] = 00000044
```

### Full Core Regression Test

```text
d0000000 d1110000 d8880000 d9990000 900f0005 911f0003 92010000 b4010000
15010000 d6010000 57010000 80821800 998f2800 00000000 00000000 00000000
```

Expected final registers:

| Register |   Expected |
| -------- | ---------: |
| `R0`     | `00000005` |
| `R1`     | `00000003` |
| `R2`     | `00000008` |
| `R4`     | `00000002` |
| `R5`     | `00000001` |
| `R6`     | `00000006` |
| `R7`     | `00000007` |
| `R8`     | `00000000` |
| `R9`     | `00000008` |

Expected RAM:

```text
RAM[0] = 00000008
```

### Branch Not Taken Test

```text
d0000000 d1110000 d5550000 d6660000 900f0001 911f0002 b5010000 80004ffc
966f00cc 00000000 00000000 00000000 00000000 00000000 00000000 00000000
```

Expected:

```text
R6 = 000000cc
```

### Branch Taken Test

```text
d0000000 d5550000 d6660000 900f0001 b5000000 80004ffc 966f00cc 00000000
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
```

Expected:

```text
R6 = 00000000
```

## Assembly Syntax Draft

A simple assembler can use this syntax:

```asm
ADD   rd, ra, rb
ADDI  rd, ra, imm12
SUB   rd, ra, rb
AND   rd, ra, rb
OR    rd, ra, rb
XOR   rd, ra, rb

LOAD  rd, offset(ra)
STORE rb, offset(ra)

BRZ   label
NOP
```

Suggested pseudoinstructions:

```asm
CLEAR rd
LI    rd, imm12
BEQ   ra, rb, label
JMP   label
```

## Limitations

Current limitations:

```text
No hardware LI instruction
No hardware BEQ instruction
No stack pointer convention yet
No call/return convention yet
No interrupts
No memory-mapped I/O yet
No assembler yet
No existing operating system support
```

The CPU can support a small custom monitor or toy operating system, but it cannot run Linux, xv6, FreeRTOS, RISC-V binaries, ARM binaries, or x86 binaries.

## Next Steps

Planned next steps:

```text
1. Write an assembler for this ISA
2. Add labels for BRZ
3. Define calling convention
4. Define stack pointer register
5. Add memory-mapped I/O
6. Write a tiny boot monitor
7. Add example assembly programs
```

Potential future instructions:

```text
JMP
BNZ
SLT
SHL
SHR
CALL
RET
HALT
```

## Project Goal

The goal of this project is to build a CPU from the datapath up: instruction encoding, register file, ALU, memory system, branching, assembly language, and eventually a tiny software stack.

This CPU is intentionally minimal, but it now has the core ingredients of a real programmable machine:

```text
arithmetic
logic
memory load/store
conditional branching
word-addressed RAM
repeatable machine-code tests
```
