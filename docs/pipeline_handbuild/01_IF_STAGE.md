# Stage 1: IF — instruction fetch

## Purpose

IF owns the program counter, chooses the next PC, reads instruction ROM, and
hands one instruction plus its address to IF/ID.

```text
next-PC selection -> PC register -> instruction ROM -> IF/ID
```

## Existing `stage_IF` ports

Inputs:

| Signal | Width | Source |
|---|---:|---|
| `clk` | 1 | system clock |
| `rst` | 1 | reset |
| `hold_pc` | 1 | hazard/block-transfer controller |
| `branch_taken` | 1 | EX redirect |
| `branch_offset` | 32 | EX branch target/offset path |
| `bx_taken` | 1 | EX redirect |
| `bx_target` | 32 | EX register branch target |
| `wb_writes_pc` | 1 | WB redirect |
| `wb_data` | 32 | value written to PC by WB |
| `bt_done` | 1 | block-transfer controller |

Outputs:

| Signal | Width | Destination |
|---|---:|---|
| `instruction` | 32 | IF/ID instruction input |
| `pc_word_addr` | 32 | IF/ID PC input |
| `pc_plus4` | 32 | IF/ID PC+4 input |

## Hand wiring inside IF

1. Place a 32-bit PC register. Connect `clk` and `rst`.
2. Feed PC into a 32-bit adder with constant `4`; label the result `PC_PLUS4_IF`.
3. Feed PC to instruction ROM address logic. If the ROM is word addressed,
   use `PC[31:2]` or the existing `pc_fetch` conversion.
4. Build the next-PC priority chain. Highest priority must win:

```text
wb_writes_pc -> wb_data
bx_taken     -> bx_target
branch_taken -> branch target
otherwise    -> PC + 4
```

5. Put `hold_pc` on the PC register enable:

```text
PC_ENABLE = NOT(hold_pc)
```

6. A redirect must override a hold caused by a younger instruction:

```text
PC_ENABLE = redirect OR NOT(hold_pc)
redirect = wb_writes_pc OR bx_taken OR branch_taken
```

7. Connect the PC register output to the ROM and expose the fetched
   instruction. Do not wire it directly into ID in the pipelined version.

## IF/ID pipeline register

Create one subcircuit named `pipe_if_id`. Register this bundle together:

| Field | Width |
|---|---:|
| `instruction` | 32 |
| `pc_word_addr` | 32 |
| `pc_plus4` | 32 |
| `valid` | 1 |

Set every register's Data Bits explicitly, including `valid` as **1 bit**;
do not rely on Logisim's component default width.

Control ports:

| Port | Meaning |
|---|---|
| `enable` | advance when 1; retain all fields when 0 |
| `flush` | write a bubble/NOP and clear valid |
| `rst` | clear valid and stored fields |

For the first hand build, use `0xE1A00000` (`MOV r0,r0`) as the instruction
written during a flush.

```text
IFID_D_INSTR = flush ? 0xE1A00000 : IF_instruction
IFID_D_VALID = flush ? 0 : 1
IFID_ENABLE  = NOT(stall_if_id)
```

Connect IF/ID outputs—not raw IF outputs—to `stage_ID.instruction` and
`stage_ID.pc_word_addr`.

## Flush sources

At minimum:

```text
IFID_FLUSH = branch_taken OR bx_taken OR wb_writes_pc
```

Later, include exception/interrupt redirects if implemented.

## First tests

1. Reset: PC and IF/ID valid clear.
2. Advance: successive ROM words appear one clock apart at IF/ID.
3. Hold: PC and every IF/ID field remain unchanged.
4. Flush: IF/ID emits NOP and `valid=0`.
5. Redirect: PC loads the target and the younger fetched instruction flushes.

The installed Logisim Evolution is v3.8.0. Its `--test-vector` runner resets
state before every row and does not support the newer `<set>/<seq>` sequential
columns. Therefore, test this block with a clocked Logisim testbench (or update
Logisim) rather than interpreting an ordinary combinational vector as a
register test. The vector file remains useful on a newer runner.
