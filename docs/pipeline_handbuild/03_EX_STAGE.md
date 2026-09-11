# Stage 3: EX — condition check, shift, ALU, multiply, and branch resolution

## Purpose

EX receives one registered instruction bundle, evaluates its condition,
forms Operand2, executes arithmetic/logic or multiplication, updates flags,
and resolves branch/BX targets.

```text
ID/EX -> forwarding -> shifter/ALU/multiplier/branch -> EX/MEM
```

## Inputs from ID/EX

Use the registered versions of the existing `stage_EX` inputs:

```text
rd_a, rd_b, rs_value, mul_acc_value
alu_ctrl, cond, class_bits, opcode
imm_bit, imm8, shift_amount, shift_type, reg_shift
s_bit, branch_imm24, instr_27_4
is_mult, is_mla, mul_long, mul_signed, mul_long_acc
destination register, store data, PC metadata, valid
```

Do not connect live outputs from ID directly to EX after ID/EX exists.

## Forwarding muxes

Place forwarding muxes before EX's operand consumers, not after the ALU:

```text
EX_A  = selected(IDEX_rd_a, EXMEM_result, MEMWB_write_data)
EX_RM = selected(IDEX_rd_b, EXMEM_result, MEMWB_write_data)
EX_RS = selected(IDEX_rs_value, EXMEM_result, MEMWB_write_data)
```

Use destination-register comparisons plus valid/write-enable gating. Never
forward register 15/PC through the ordinary general-register path unless the
instruction rules explicitly require it.

## Operand2 and shifter

The proven stage contains the complete ARM Operand2 path:

```text
register operand -> Rm shifted by immediate amount or Rs[7:0]
immediate operand -> zeroExtend(imm8) ROR (2 * rot)
```

Preserve these fixes:

- LSL/LSR/ASR/ROR amounts 0, 32, and greater than 32.
- Logical-operation shifter carry into CPSR.C.
- Rotated-immediate carry.
- RRX result `(old_C << 31) | (Rm >> 1)`.
- Corrected RRX enable:

```text
RRX_ACTIVE = reg_shift ? 0 : RRX_ACTIVE_RAW
```

The corrected mux is already in `pipelined_debug_armv4t_2.circ`.

## Condition and side-effect gating

Compute:

```text
EXECUTE = IDEX_VALID AND condition_checker(cond, CPSR)
```

All side effects derived in EX must be gated by `EXECUTE`:

```text
register write intent
flag write intent
memory write intent
branch/BX taken
multiply write intent
```

## ALU and flags

Feed forwarded `EX_A` and final Operand2 into the existing ALU. Arithmetic
operations use ALU carry/overflow. Logical S operations use shifter carry.

Keep the C-source mux semantics:

```text
logical engine    -> final shifter carry
arithmetic engine -> ALU adder carry
preserve paths    -> current CPSR.C
```

Initially keep CPSR in EX. A following conditional instruction creates a flag
hazard. The simplest correct first implementation stalls it until the flag
producer reaches the point where CPSR has updated. Flag forwarding can replace
the stall later.

## Multiply path

Preserve the proven short and long multiply controls and outputs:

```text
MUL/MLA result
long result low word
mul_hi
mul_long_we
signed/unsigned selection
accumulate selection
```

If multiplication becomes multi-cycle, hold ID/EX and younger stages until
`mul_done`. With the current combinational multiplier, treat it as one EX stage
but expect it to dominate timing.

## Branch handling

EX produces:

```text
branch_taken, branch_offset
bx_taken, bx_target
bl_taken
```

Gate taken signals with `EXECUTE`. Feed redirect signals to IF and flush both
younger instructions:

```text
flush IF/ID
flush ID/EX
```

## EX/MEM pipeline register

Register:

```text
alu_result, mul_hi
store_data/rm_val, effective address operands
cond_pass/execute
class_bits, opcode, s_bit, instr_15_0, rn
shift_amount, shift_type, IS_HWXFER
destination register/wa
register-write intent, memory-write intent
mul_long_we and second-destination information
pc_plus4 and BL information
valid
```

Do not send raw EX results directly to WB. They must pass EX/MEM and MEM/WB so
they remain aligned with the destination and write-enable.

## First tests

1. Independent ALU operations without dependencies.
2. ADD followed immediately by dependent ADD: forwarding.
3. MOVS/LSRS/ASRS followed by conditional execution: flag dependency.
4. Taken/not-taken B, BL, and BX: redirect and two-stage flush.
5. MUL followed by dependent ADD.
6. RRX and register-controlled `ROR r0` remain distinct.

