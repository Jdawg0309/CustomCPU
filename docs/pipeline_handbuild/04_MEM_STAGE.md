# Stage 4: MEM — loads, stores, memory lanes, and block transfers

## Purpose

MEM receives a condition-approved registered instruction, performs RAM/ROM
access, handles byte/halfword lanes and extension, and controls block transfer.

```text
EX/MEM -> address/lane/control -> RAM or ROM -> MEM/WB
```

## Inputs

The existing MEM logic consumes these values, but in the pipeline they must
come from EX/MEM rather than live ID/EX signals:

```text
rd_a, rd_b, rm_val
class_bits, opcode, s_bit, rn, instr_15_0
cond_pass/execute
shift_amount, shift_type, IS_HWXFER
effective address / ALU result
destination register and write intent
valid
```

Also connect `clk` and `rst` for RAM and block-transfer state.

## Address path

For ordinary loads/stores, use the effective address produced for the same
instruction. Keep base write-back separate from the actual memory address:

```text
memory_address = pre/post-index-selected effective address
updated_base   = base +/- offset
```

For register offsets, the offset shifter uses the registered `rm_val`,
`shift_amount`, and `shift_type` belonging to this memory instruction.

## Memory-map selection

Decode address ranges before selecting data:

```text
ROM range -> ROM output
RAM range -> RAM output
device/NPU range -> peripheral output
```

Only the selected writable target may receive a write enable.

```text
RAM_WE = EXMEM_VALID AND EXMEM_EXECUTE AND store AND address_is_RAM
```

When the NPU interface is added, create a separate `NPU_WE`; do not OR device
writes into RAM write-enable.

## Byte and halfword lane wiring

Use address bits `[1:0]` to select the byte lane and bit `[1]` to select the
halfword lane.

Loads:

```text
LDR   -> full 32-bit word
LDRB  -> selected byte, zero extend to 32
LDRSB -> selected byte, sign extend to 32
LDRH  -> selected halfword, zero extend to 32
LDRSH -> selected halfword, sign extend to 32
```

Stores require byte enables or read/merge/write logic:

```text
STR  -> enable all four byte lanes
STRB -> enable one lane selected by address[1:0]
STRH -> enable lower or upper two lanes selected by address[1]
```

Preserve the proven `load_data`, `data_ram_we`, `sbwe`, and halfword control
paths from the debug circuit.

## Block-transfer behavior

The existing `block_transfer_control` emits:

```text
hold_pc, bt_active, bt_done, bt_reg_idx
```

While active:

1. Stop IF and prevent IF/ID advancement.
2. Prevent a new instruction from entering ID/EX.
3. Let the block-transfer controller sequence one register/memory beat at a
   time.
4. Release the pipeline only after `bt_done`.

Do not allow a stalled instruction to repeat a store. Gate every memory write
with a one-cycle valid/beat-enable signal.

## MEM/WB pipeline register

Register:

```text
load_data
alu/multiply result carried through from EX/MEM
memory_up_base
mem_read / write-back source selection
destination register/wa
register-write enable
second write-port data/address/enable
BL/PC-write metadata and pc_plus4
class_bits
valid
```

Stores normally create no WB register write, but still advance a valid record
or bubble consistently.

## Load-use stall

If the instruction in ID needs the destination of a load currently in EX:

```text
hold PC
hold IF/ID
inject bubble into ID/EX
allow the load to advance into MEM
```

Then forward `MEMWB_load_data` to the dependent EX operand on the following
cycle.

## First tests

1. LDR/STR every aligned word lane.
2. LDRB/STRB at offsets 0, 1, 2, 3.
3. LDRH/STRH at lower and upper halfword.
4. Signed byte and halfword loads with negative values.
5. LDR immediately followed by dependent ADD.
6. ADD immediately followed by STR of the result.
7. Block transfer holds fetch and does not duplicate a memory write.

