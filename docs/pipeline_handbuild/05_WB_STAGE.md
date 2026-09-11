# Stage 5: WB — architectural write-back

## Purpose

WB selects the final result for an instruction and commits it to the register
file or PC. It is the final stage and the only ordinary GPR commit point.

```text
MEM/WB -> result selection + commit gating -> register file / PC
```

## Inputs from MEM/WB

The existing stage has these functional inputs; use registered equivalents:

```text
alu_result, alu_we
load_data, mem_read
memory_up_base
cond_pass
bl_taken, branch_taken, bx_taken
pc_plus4
sbwe, data_ram_we
wa/destination register
bt_active, class_bits
valid
```

Also carry long-multiply high/second-write information when applicable.

## Write-data selection

Build the final result mux from the registered sources:

```text
ordinary ALU or MUL -> alu_result
load                -> load_data
base write-back     -> memory_up_base
BL link write       -> saved return address
long multiply high  -> mul_hi on the second write port
```

Call the ordinary selected output `WB_DATA`.

## Destination selection

Carry the destination register with the instruction. Do not use the live `rd`
field from ID.

Examples:

```text
data processing -> encoded Rd
load            -> encoded Rd
base write-back -> encoded Rn
BL              -> R14
PC destination  -> redirect path, not ordinary GPR write
```

## Commit gating

The final register-file write enable must include validity and condition:

```text
WB_WE = MEMWB_VALID AND MEMWB_COND_PASS AND requested_register_write
```

Suppress ordinary GPR writes when the destination is PC and instead assert:

```text
wb_writes_pc = WB_WE AND (destination == 15)
```

Feed `WB_DATA` and `wb_writes_pc` back to IF's redirect mux. Flush younger
pipeline stages when this redirect occurs.

For a second write port:

```text
WB_WE2 = MEMWB_VALID AND MEMWB_COND_PASS AND requested_second_write
```

Keep both writes aligned to the same MEM/WB instruction.

## Register-file connection

Wire outputs back to ID:

```text
WB_DATA -> stage_ID.wd
WB_WA   -> stage_ID write address
WB_WE   -> stage_ID.we

WB_DATA2 -> stage_ID.wd2
WB_WA2   -> stage_ID.wa2
WB_WE2   -> stage_ID.we2
```

If the register file writes and ID reads on the same edge, add WB-to-ID read
bypass so a value committed this cycle is visible to the instruction decoding
in the same cycle:

```text
ID_READ = (WB_WE AND WB_WA == ID_READ_ADDR) ? WB_DATA : register_file_output
```

Repeat for all read ports and the second WB port, with a documented priority.

## Forwarding outputs

Expose to the EX forwarding unit:

```text
MEMWB_VALID
WB_WE / WB_WE2
WB_WA / WB_WA2
WB_DATA / WB_DATA2
```

WB forwarding is lower priority than EX/MEM forwarding because EX/MEM holds
the newer producer.

## Halt behavior

The existing harness treats an appropriate `BX`/PC behavior as halt. In the
pipeline, halt must occur only when the halting instruction reaches its commit
or resolved control point. Flush younger instructions and prevent later stores
or register writes after halt.

## First tests

1. ALU result commits to the encoded destination.
2. Load data, not the address, commits for LDR.
3. BL writes the correct link value to R14.
4. Writing R15 redirects IF and flushes younger work.
5. Long multiply writes low and high destinations correctly.
6. A failed condition produces no register or PC write.
7. WB-to-ID same-cycle dependency receives the new value.

## End-to-end pipeline acceptance

After WB is connected, run in this order:

1. Independent instructions separated by NOPs.
2. ALU dependency chains with no NOPs.
3. Load-use dependencies.
4. Stores fed by immediately preceding producers.
5. CMP/flags followed by conditional instructions.
6. Taken branches with visible wrong-path stores.
7. MUL/MLA and long-multiply dependencies.
8. The complete existing CPU regression suites.

