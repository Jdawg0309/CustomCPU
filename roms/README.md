# CustomCPU Flat ROM Bundle

Author: Junaet Mahbub. All ROM programs in this directory were written by the
author, in assembly or C, and are built reproducibly by `build/build.py`.

This directory is the canonical loadable test bundle for `../armv4t.circ`. It is
intentionally flat: every ROM, assembly source, C reference, build tool, and
expected result is directly inside `cpu/`.

## Quick Start

1. Open `armv4t.circ` in Logisim Evolution.
2. Load `decode_opcode.rom` into the 64K x 10-bit decoder ROM.
3. Load one `regression_*.rom` or `math_*.rom` file into `instr_rom`.
4. Reset the simulation and tick the clock manually.
5. Compare registers, CPSR, PC, and RAM with the tables below.

The instruction ROM is 256 words and is addressed by `PC[9:2]`. Regression
tests 01 and 02 still contain exactly 16 sequential instructions and should be
stopped after tick 16. Control-flow, memory, and math programs end in a stable
branch-to-self loop.

## Decoder ROM

| File | Load into | Purpose |
|---|---|---|
| `decode_opcode.rom` | 64K x 10-bit decoder ROM | Current instruction-class and control-word lookup table |

## CPU Regression ROMs

| File | Ticks | Expected final signature |
|---|---:|---|
| `regression_01_compute.rom` | 16 | R1=FFFFFFFF R2=1 R3=8 R4=3 R5=5 R6=1 R7=7 R8=6 R9=4 R10=5 R11=FFFFFFFC R12=2 R13=FFFFFFFE R14=11 |
| `regression_02_barrel.rom` | 16 | R3=80000000 R4=80000000 R8=80000000 R9=1 R10=FFFFFFFF R11=80000000 R12=00010000 R13=2 R14=11 |
| `regression_03_immediate.rom` | 3 | R3=FF R4=80000000 R5=800000FF |
| `regression_04_cpsr.rom` | 6 | R1=FFFFFFFF R2=0 R3=7FFFFFFF R4=80000000 R5=FFFFFFFF R6=FFFFFFFE CPSR=A |
| `regression_05_condition.rom` | 8 | R1=FFFFFFFF R2=22 R3=0 R4=0 R5=55 R6=0 R7=77 CPSR=4 |
| `regression_06_branch.rom` | 4 | R0=1 R1=5 pc_out=4 |
| `regression_07_branch_cond.rom` | 7 | R0=0 R1=55 CPSR=6 pc_out=4 |
| `regression_08_bx.rom` | 4 | R0=0 R1=0 R2=10 R3=33 pc_out=5 |
| `regression_09_bx_lr.rom` | 4 | R0=0 R1=0 R14=10 R3=33 pc_out=5 |
| `regression_10_bl.rom` | 6 | R0=6 R1=33 R14=8 pc_out=3 |
| `regression_11_compiled_c.rom` | 6 | R0=8 R1=3 R14=14 pc_out=5 |
| `regression_12_memory.rom` | 12 | R2=AA R4=55 R5=33 CPSR=2 RAM[07]=55 RAM[09]=AA pc_out=B |

`regression_11_compiled_c.rom` is compiler-produced leaf C. It proves the
register calling convention and return path, not full stack-capable C.

## Memory Bring-Up ROMs

These shorter images isolate one stage of the memory datapath. The full release
test is `regression_12_memory.rom`.

| File | Purpose | Expected observation |
|---|---|---|
| `helper_memory_detect.rom` | Identify STR and LDR instruction classes | memory class asserts only for the first two instructions |
| `helper_memory_address.rom` | Exercise +4 and -4 effective addresses | accesses word addresses 9 and 7 from byte base 0x20 |
| `helper_memory_store_source.rom` | Verify STR source selection | RAM word address 9 becomes AA |
| `helper_memory_store_load.rom` | Verify one STR/LDR round trip | R2 becomes AA and RAM word address 9 is AA |
| `helper_memory_regression.rom` | Original complete memory test | same signature as `regression_12_memory.rom` |
| `helper_stack_address_mux.rom` | Test pre-index and post-index address selection before base writeback is connected | pre-index address=FC; post-index address=100; RAM[3F]=AA; RAM[40]=AA |
| `helper_stack_store_writeback.rom` | Verify pre-index, post-index, and suppressed store base writeback | R5=FC R13=104 RAM[3F]=AA RAM[40]=55 RAM[42]=33 |
| `helper_stack_load_writeback.rom` | Verify simultaneous post-index LDR destination and stack-base writeback | R0=0 R1=AA R2=100 R13=100 RAM[3F]=AA |
| `diagnostic_sync_ram_workaround.rom` | Prove synchronous-read latency with a sacrificial LDR before the real load | R1=AA R2=100 R12=0 R13=100 RAM[3F]=AA |
| `helper_block_transfer_detect.rom` | Decode canonical `STMDB`/`LDMIA` used as GCC `PUSH`/`POP` | words 0/1: class=4; P/U/W/L fields match `BUILD_BLOCK_TRANSFER.md` |

For `helper_stack_address_mux.rom`, stop after verifying the first four
instructions. This test assumes stack base writeback is not connected yet, so
R13 remains `0x100` for both stores. Once writeback is added, use the dedicated
writeback regression that follows it instead.

For `helper_stack_store_writeback.rom`, the three cases are independent:

```text
STR R0,[SP,#-4]!  -> RAM[3F]=AA, SP=FC, copied into R5
STR R0,[SP],#4    -> RAM[40]=55, SP=104
STR R0,[SP,#4]    -> RAM[42]=33, SP remains 104
```

This complete signature was manually verified on the Logisim CPU on
2026-08-06.

`diagnostic_sync_ram_workaround.rom` is a timing discriminator, not the normal
execution model. With synchronous RAM reads, its first `LDR R12,[SP]` primes
`RAM.out` and the following `LDR R1,[SP],#4` succeeds. The ordinary
`helper_stack_load_writeback.rom` succeeds after enabling asynchronous RAM reads,
which the current single-cycle datapath requires. Keep RAM writes rising-edge
triggered. A future FPGA implementation must replace this with a load wait state
or pipelined synchronous-memory stage.

## Math ROMs

Every math ROM has a same-numbered `.S` source and `.c` semantic reference. The
assembly is the executable image for the current CPU.

| File | Algorithm | Expected CPU result |
|---|---|---|
| `math_01_gcd.rom` | subtraction Euclid GCD(48,18) | R0=6 R1=6 |
| `math_02_fibonacci.rom` | Fibonacci through F(10) | R0=55 R1=89 |
| `math_03_factorial.rom` | 5! with repeated-add multiplication | R1=120 |
| `math_04_integer_sqrt.rom` | floor(sqrt(81)) by odd subtraction | R1=9 R0=0 |
| `math_05_collatz.rom` | Collatz sequence from 13 | R0=1 R1=9 |
| `math_06_popcount.rom` | population count of B5 | R1=5 |
| `math_07_array_sum_ram.rom` | store and sum {3,5,7} in RAM | R2=15 |
| `math_08_derivative_x2.rom` | central difference of x^2 at x=5 | R5=10 |
| `math_09_taylor_e_q8_8.rom` | e through 1/5! in Q8.8 | R0=2B8 (2.71875) |
| `math_10_relu_perceptron.rom` | ReLU(3x0+2x1-x2-10) | R3=3 |
| `math_11_fibonacci_ram_integration.rom` | Fibonacci, RAM round trip, shifted checksum | R0=37 R1=59 R5=37 R6=59 R7=E9 RAM[08]=37 RAM[09]=59 CPSR.Z=1 |
| `math_12_fibonacci_ram_0_to_46.rom` | Fill RAM words 0 through 46 with F0 through F46 | RAM[00]=0 RAM[01]=1 RAM[0A]=37 RAM[2E]=6D73E55F |
| `math_13_rule30_ram.rom` | Generate 64 rows of a Rule 30 cellular automaton | RAM[00]=00010000 RAM[3F]=44955555 |

The derivative uses `(f(6)-f(4))/2`; squares are formed by repeated addition.
The Taylor image adds fixed, rounded Q8.8 terms. It is a numerical demonstration,
not a general exponential function.

### Full Integration Milestone

`math_11_fibonacci_ram_integration.rom` is the current end-to-end milestone.
Run it for 64 ticks; after the Fibonacci loop it remains at instruction address
15 while Z stays set. Verify all of the following:

```text
R0       = 00000037
R1       = 00000059
R2       = 00000000
R4       = 00000020
R5       = 00000037
R6       = 00000059
R7       = 000000E9
RAM[08]  = 00000037
RAM[09]  = 00000059
CPSR.Z   = 1
pc_out   = 0000000F
```

The checksum is `R5 + (R6 << 1) = 0xE9`. This one image exercises immediate
decode, register arithmetic, flags, conditional looping, the barrel shifter,
effective-address generation, STR, LDR, RAM, conditional execution, and PC
redirection. It does not exercise BL/BX, multiply, or unfinished stack modes;
those remain covered separately or incomplete.

### Fibonacci RAM Table

`math_12_fibonacci_ram_0_to_46.rom` writes one unsigned 32-bit Fibonacci number
to every RAM word address from `00` through `2E` (decimal 46). Run at least 400
ticks; the program then remains in its final branch-to-self loop.

This complete RAM signature was manually verified on the Logisim CPU on
2026-08-05.

```text
RAM[00]=00000000  RAM[01]=00000001  RAM[02]=00000001  RAM[03]=00000002
RAM[04]=00000003  RAM[05]=00000005  RAM[06]=00000008  RAM[07]=0000000D
RAM[08]=00000015  RAM[09]=00000022  RAM[0A]=00000037  RAM[0B]=00000059
RAM[0C]=00000090  RAM[0D]=000000E9  RAM[0E]=00000179  RAM[0F]=00000262
RAM[10]=000003DB  RAM[11]=0000063D  RAM[12]=00000A18  RAM[13]=00001055
RAM[14]=00001A6D  RAM[15]=00002AC2  RAM[16]=0000452F  RAM[17]=00006FF1
RAM[18]=0000B520  RAM[19]=00012511  RAM[1A]=0001DA31  RAM[1B]=0002FF42
RAM[1C]=0004D973  RAM[1D]=0007D8B5  RAM[1E]=000CB228  RAM[1F]=00148ADD
RAM[20]=00213D05  RAM[21]=0035C7E2  RAM[22]=005704E7  RAM[23]=008CCCC9
RAM[24]=00E3D1B0  RAM[25]=01709E79  RAM[26]=02547029  RAM[27]=03C50EA2
RAM[28]=06197ECB  RAM[29]=09DE8D6D  RAM[2A]=0FF80C38  RAM[2B]=19D699A5
RAM[2C]=29CEA5DD  RAM[2D]=43A53F82  RAM[2E]=6D73E55F
```

Final register signature:

```text
R0=00000000?  No: R0=B11924E1 (F47, computed after storing F46)
R1=1E8D0A40   (low 32 bits of F48)
R2=00000000
R3=1E8D0A40
R4=000000BC   (47 words x 4 bytes)
```

### Rule 30 Cellular Automaton

`math_13_rule30_ram.rom` starts with one live cell and writes 64 generations to
RAM word addresses `00` through `3F`. Run at least 700 ticks. Each generation is:

```text
next = (row << 1) XOR (row OR (row >> 1))
```

Interpret a set bit as `#` and a clear bit as a space to display the RAM words
as rows. The program exercises register shifts, ORR, EOR, a counted conditional
loop, pointer arithmetic, STR, and sustained RAM writes. Expected endpoints:

```text
RAM[00] = 00010000
RAM[01] = 00038000
RAM[02] = 0004C000
RAM[3F] = 44955555
R1      = 00000100
R2      = 00000000
```

## C Sources

`math_01_gcd.c` through `math_10_relu_perceptron.c` are freestanding C versions
of the algorithms. They contain no library calls. Their expected outputs can be
verified on the workstation with:

```text
make -C cpu verify-host
```

These C files are legitimate ARM target inputs, but compiler output must remain
inside the implemented ARM-state subset. The first linked startup plus GCC test
is `../c_tests/practical_rom`; its exact acceptance procedure is documented in
`../PRACTICAL_C_CPU_TEST.md`. The matching hand-assembled ROMs remain the
canonical algorithm regressions.

## Rebuild and Verify

Requirements: Python 3, a host C compiler, and the GNU Arm Embedded tools
`arm-none-eabi-as` and `arm-none-eabi-objcopy`.

```text
make -C cpu clean verify
make -C cpu manifest
```

`build.py` rebuilds all thirteen math images and rejects programs larger than
the 256-word instruction ROM. `--check` verifies generated images without
changing them. `MANIFEST.sha256` fingerprints the release bundle.

## Keyboard Input Milestone

The core currently has no input peripheral. After stack-capable C and a stable
memory map, add memory-mapped UART receive registers or a PS/2 receiver. C can
poll a status address, load a byte, and decode ASCII or scan codes. That is a
small peripheral milestone after practical C. A USB keyboard is a separate,
much larger USB-host project.
