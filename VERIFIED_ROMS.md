# Verified ROM Index

All instruction images below use Logisim's `v3.0 hex words plain` format and
load into the top-level `instr_rom`. Reset before each test and use manual ticks.

## CPU Instruction ROMs

| File | Test | Pass signature |
|---|---|---|
| `boot_rom` | Base ALU integration | After 16 ticks: R3=8, R5=5, R8=6, R13=FFFFFFFE |
| `instr_rom` | Register Operand2 barrel shifts | After 16 ticks: R8=80000000, R9=1, R10=FFFFFFFF, R13=2 |
| `operand2_rom` | Rotated immediate Operand2 | After 3 ticks: R3=FF, R4=80000000, R5=800000FF |
| `cpsr_rom` | Arithmetic NZCV and S gating | CPSR sequence 0,6,6,9,8,A |
| `condition_rom` | Conditional execution | R2=22, R3=0, R5=55, R6=0, CPSR=4 |
| `branch_rom` | Forward B and self-loop | R0=1, R1=5, pc_out=4 |
| `branch_cond_rom` | Backward BNE loop | R0=0, R1=55, CPSR=6, pc_out=4 |
| `bx_rom` | BX register target | R2=10, R3=33, pc_out=5 |
| `bx_lr_rom` | BX LR | R14=10, R3=33, pc_out=5 |
| `bl_rom` | BL call and BX LR return | R0=6, R1=33, R14=8, pc_out=3 |
| `c_tests/add_rom` | GCC-generated C leaf function | R0=8, R1=3, R14=14, pc_out=5 |

`instr_rom` and `boot_rom` contain 16 instructions with no terminating loop.
Stop after tick 16; another tick wraps the four-bit ROM address.

## Decoder ROM

Load `opcode` into the 64K x 10-bit decode ROM. Do not load it into
`instr_rom`.

```text
v3.0 hex words addressed
0000: 001 003 151 191 101 121 161 1a1 000 002 150 100 005 007 009 00b
0010: 201 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000
```

## Exact Instruction Images

```text
boot_rom:
e1e01000 e0402001 e0823002 e0834002 e0835003 e0855002 e0853004 e1450004
e0056004 e1857004 e0258004 e1c59004 e1a0a005 e1e0b004 e064c005 e044d005

instr_rom:
e1e01000 e0402001 e1a03082 e1a04102 e1a05202 e1a06402 e1a07802 e1a08f82
e1a09fa8 e1a0afc8 e1a0b0e2 e1a0c862 e1a0dfe2 e082e202 e02130a1 e1c140a1

operand2_rom:
e3a030ff e3a04102 e2835102

cpsr_rom:
e1e01000 e2912001 e3e03102 e2934001 e2505001 e2516001

condition_rom:
e3a00000 e2501001 43a02022 53a03033 e2904000 03a05055 13a06066 e3a07077

branch_rom:
e3a00001 ea000000 e3a00002 e2801004 eafffffe

branch_cond_rom:
e3a00002 e2500001 1afffffd e3a01055 eafffffe

bx_rom:
e3a02010 e12fff12 e3a00001 e3a01002 e3a03033 eafffffe

bx_lr_rom:
e3a0e010 e12fff1e e3a00001 e3a01002 e3a03033 eafffffe

bl_rom:
e3a00005 eb000001 e3a01033 eafffffe e2800001 e12fff1e

c_tests/add_rom:
e3a00005 e3a01003 e3a0e014 e0800001 e12fff1e eafffffe
```
