# Compiled C Leaf Test

This is the first compiler-generated C test for `armv4t.circ`.

## Build

```text
make -C c_tests
```

The compiler target is ARM7TDMI in ARM state (`-mcpu=arm7tdmi -marm`), which
generates ARMv4T code. Load `c_tests/add_rom` into `instr_rom`.

## Register Setup

```text
R0  = 00000000
R1  = 00000000
R14 = 00000000
```

No register poking is required. Reset the CPU, load the ROM, and start at
`pc_out = 0`. The first three instructions load the function inputs and LR.

## Generated Instructions

```text
ROM 0: e3a00005    MOV R0,#5
ROM 1: e3a01003    MOV R1,#3
ROM 2: e3a0e014    MOV R14,#0x14
ROM 3: e0800001    ADD R0,R0,R1    compiler-generated C
ROM 4: e12fff1e    BX  R14          compiler-generated return
ROM 5: eafffffe    B   .
```

## Expected Clocks

```text
initial: pc_out=0  R0=00000000  R1=00000000  R14=00000000
tick 1:  pc_out=1  R0=00000005  R1=00000000  R14=00000000
tick 2:  pc_out=2  R0=00000005  R1=00000003  R14=00000000
tick 3:  pc_out=3  R0=00000005  R1=00000003  R14=00000014
tick 4:  pc_out=4  R0=00000008  R1=00000003  R14=00000014
tick 5:  pc_out=5  R0=00000008  R1=00000003  R14=00000014
tick 6:  pc_out=5  R0=00000008  R1=00000003  R14=00000014
```

`R0 = 8` proves the compiled C function executed. `pc_out = 5` proves the
compiler-generated `BX LR` returned to the supplied address.

This is a leaf-function milestone, not general C support. Calls, automatic
stack variables, globals, and pointers still require BL, data memory, LDR/STR,
and stack wiring.
