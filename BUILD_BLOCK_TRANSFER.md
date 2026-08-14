# Build Block Transfer

This milestone adds the ARM-state operations emitted by GCC as `PUSH` and
`POP`. They are aliases for block data transfer instructions:

```text
PUSH {r4,lr} = STMDB SP!,{r4,lr} = E92D4010
POP  {r4,lr} = LDMIA SP!,{r4,lr} = E8BD4010
```

The implementation is multi-cycle and transfers one selected register per
clock. It must hold the current instruction and PC until the complete register
list has been processed.

## Instruction Fields

```text
instr[27:25] = 100       block-transfer class
instr[24]    = P         pre/post indexing
instr[23]    = U         increment/decrement
instr[22]    = S         privileged/user-bank behavior; initially require 0
instr[21]    = W         base writeback
instr[20]    = L         0=store, 1=load
instr[19:16] = Rn        base register
instr[15:0]  = reg_list  one bit per register
```

Initial supported forms:

| Form | P | U | S | W | L | Rn |
|---|---:|---:|---:|---:|---:|---:|
| `STMDB SP!,reg_list` | 1 | 0 | 0 | 1 | 0 | D |
| `LDMIA SP!,reg_list` | 0 | 1 | 0 | 1 | 1 | D |

## Current Progress

Verified in `armv4t.circ` on 2026-08-14:

- class, condition, PUSH, POP, and SP-base detection
- `block_transfer.start`
- `pc_fetch.hold`
- `active` and one-cycle `done` state
- PUSH register-index scan from 15 through 0
- POP register-index scan from 0 through 15
- automatic terminal detection and exact PC release
- 16-bit register-list capture and indexed `reg_selected` output

The transfer-address register, RAM integration, POP register writeback, and
final SP writeback remain to be wired.

## Named Signals

```text
block_transfer.class
block_transfer.valid
block_transfer.is_push
block_transfer.is_pop
block_transfer.start
block_transfer.active
block_transfer.done
block_transfer.hold_pc
block_transfer.reg_list
block_transfer.reg_index
block_transfer.reg_selected
block_transfer.address
block_transfer.transfer_address
block_transfer.store_enable
block_transfer.load_enable
block_transfer.base_write_enable
```

## Sequencer Contract

On `block_transfer.start`, capture `instr[15:0]` and `RD_A` (`SP`).

For push, scan register numbers from 15 down to 0. When the current register-list
bit is one, decrement the address by four and store that register. This naturally
places lower-numbered registers at lower addresses without a popcount circuit.

For pop, scan register numbers from 0 up to 15. When the current register-list
bit is one, load that register from the current address and then increment the
address by four.

```text
PUSH {r4,lr}, initial SP=400
cycle for r14: RAM[FF] = R14, address=3FC
cycle for r4:  RAM[FE] = R4,  address=3F8
final SP=3F8

POP {r4,lr}, initial SP=3F8
cycle for r4:  R4  = RAM[FE], address becomes 3FC
cycle for r14: R14 = RAM[FF], address becomes 400
final SP=400
```

`block_transfer.hold_pc` must remain asserted from the start cycle through the
last transfer cycle. A one-cycle `done` state prevents the unchanged instruction
from restarting and allows `pc_fetch` to advance exactly once.

## Integration Points

```text
pc_fetch.hold = block_transfer.hold_pc

reg16x32_1.RB = mux(
    existing_RB,
    block_transfer.reg_index,
    block_transfer.active
)

main.memory_address = mux(
    existing_memory_address,
    block_transfer.transfer_address,
    block_transfer.active
)

main.data_ram_we = existing_data_ram_we OR block_transfer.store_enable

reg16x32_1.WA/WD/WE = existing write path OR block_transfer.load path
reg16x32_1.WA2/WD2/WE2 = existing base-writeback path OR block base writeback
```

Normal single-cycle register and RAM commits must be suppressed while a block
instruction is starting or active.

## Acceptance Test

Use `cpu/helper_block_transfer_detect.rom` for decoder bring-up. The final
functional test initializes SP, R4, and LR, pushes both registers, clears them,
pops them, and checks:

```text
R4       = 00000044
R14      = 00000088
R13      = 00000400
RAM[FE]  = 00000044
RAM[FF]  = 00000088
```

After this passes, run `c_tests/stress_call_rom`. Its nested GCC-generated call
is the practical-C acceptance test for block transfers.
