# Stage 2: ID — decode and register read

## Purpose

ID splits the instruction into ARM fields, decodes its class/control signals,
reads the register file, and packages everything EX or later stages need.

```text
IF/ID -> instruction split/decode + register file -> ID/EX
```

## Inputs

Instruction-side inputs come only from IF/ID:

| Signal | Width |
|---|---:|
| `instruction` | 32 |
| `pc_word_addr` | 32 |
| `pc_plus4` | 32 |
| `valid` | 1 |

Write ports come from WB:

| Signal | Width |
|---|---:|
| `wd`, `wa`, `we` | 32, 4, 1 |
| `wd2`, `wa2`, `we2` | 32, 4, 1 |

The second port is needed by long multiply, block transfer, and other
two-register write behavior in the proven CPU.

## Instruction split

Use one 32-bit splitter and expose:

| Field | ARM bits | Width |
|---|---:|---:|
| `cond` | 31:28 | 4 |
| `class_bits` | 27:26 | 2 |
| `imm_bit` | 25 | 1 |
| `opcode` | 24:21 | 4 |
| `s_bit` | 20 | 1 |
| `rn` | 19:16 | 4 |
| `rd` | 15:12 | 4 |
| `rs` | 11:8 | 4 |
| `shift_amount` | 11:7 | 5 |
| `shift_type` | 6:5 | 2 |
| `reg_shift` | 4 | 1 |
| `rm` | 3:0 | 4 |
| `imm8` | 7:0 | 8 |
| `branch_imm24` | 23:0 | 24 |
| `instr_27_4` | 27:4 | 24 |
| `instr_15_0` | 15:0 | 16 |

Do not attempt to make these fields mutually exclusive. The opcode/class
decoder decides which fields are meaningful for the current instruction.

## Register-file read wiring

Read at least these values combinationally:

```text
rd_a     = register[rn]
rd_b     = register[rm]
rs_value = register[rs]
```

For PC reads, supply the architectural PC value expected by the proven CPU
(normally current instruction address + 8), not the raw fetch PC.

Long multiply/MLA also needs the old destination/accumulator value. Preserve
the proven circuit's selection into `mul_acc_value` and `rm_val`.

## Decode outputs to preserve

The proven ID stage emits these control groups:

- ALU: `alu_ctrl`, `opcode`, `s_bit`, `cond`.
- Operand 2: `imm_bit`, `imm8`, `shift_amount`, `shift_type`, `reg_shift`,
  `rs_value`, `instr_27_4`.
- Instruction class: `class_bits`, `IS_HWXFER`, `instr_15_0`.
- Multiply: `is_mult`, `is_long_mul`/MLA, `mul_long`, `mul_signed`,
  `mul_long_acc`, `mul_acc_value`.
- Destination: `rd`/`wa` and any second destination information.

## ID/EX pipeline register

Register all data and controls for the same instruction together:

```text
rd_a[31:0], rd_b[31:0], rs_value[31:0], rm_val[31:0]
mul_acc_value[31:0]
alu_ctrl, cond, class_bits, opcode
imm_bit, imm8, shift_amount, shift_type, reg_shift
s_bit, branch_imm24, instr_27_4, instr_15_0
rn, rd/wa
is_mult, is_mla, mul_long, mul_signed, mul_long_acc, IS_HWXFER
pc_plus4, pc_plus8
valid
```

Every ID signal currently wired directly to MEM or WB must instead travel
through ID/EX and EX/MEM. In particular, do not leave live bypasses for
`class_bits`, `opcode`, `instr_15_0`, `rn`, `rm_val`, or `wa`.

Bubble behavior:

```text
IDEX_VALID = 0
all write enables = 0
all memory enables = 0
all branch/multiply enables = 0
```

Data fields may be zero during a bubble, but side-effect controls must be zero.

## Hazard information ID must expose

The hazard unit needs:

```text
ID_RN, ID_RM, ID_RS
ID_USES_RN, ID_USES_RM, ID_USES_RS
ID_DEST
ID_VALID
```

`USES_*` must come from instruction decoding; comparing every encoded field
unconditionally creates false stalls.

## First tests

1. Verify each splitter field with a known assembled instruction.
2. Verify R0, R15/PC, and two write-port behavior.
3. Hold ID/EX during a stall and confirm every field stays aligned.
4. Inject a bubble and prove no register, RAM, flags, or PC state changes.

