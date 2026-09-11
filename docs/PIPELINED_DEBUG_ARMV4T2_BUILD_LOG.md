# Pipelined debug ARMv4T2 — build log and reproduction guide

## Protected source and working copy

The known-good source is:

```text
snapshots/debug_armv4t_2.ba1e97f.circ
```

Its SHA-256 before pipeline work was:

```text
06c9cd57ca626957157a818bd1ed4acadccc2b0d14d34040f3b91a72523c6e9c
```

The pipeline-development copy is:

```text
pipelined_debug_armv4t_2.circ
```

Never modify the source snapshot or the user's hand-edited circuits while
developing the pipeline. All automatic edits in this effort target only
`pipelined_debug_armv4t_2.circ`.

The older `pipeline_armv4subset.circ` is not a real pipeline. Structural
comparison found no pipeline registers and only a small memory-load wiring
difference from the snapshot. Do not use it as the pipeline reference.

## Baseline functionality

Before copying, the source snapshot passed all 22 cases in:

```text
python3 -u claude_breaking_cpu_tests/run_battery.py \
  snapshots/debug_armv4t_2.ba1e97f.circ
```

This includes the tested shift family, RRX, short and long multiply, memory
edges, conditional execution, block transfers, and PC behavior.

## RRX register-shift decode correction

### Problem

The original RRX detector could confuse a register-specified rotate using
`r0` as the shift-amount register with immediate `ROR #0` (RRX). These are
different ARM encodings:

```text
ROR Rm, Rs       register-specified rotate; never RRX
ROR Rm, #0       immediate encoding; means RRX
```

Therefore, RRX must be disabled whenever `reg_shift == 1`.

### Implemented equation

The old detector output was renamed internally:

```text
RRX_ACTIVE_RAW = existing RRX detector
```

A new 1-bit, 2-input mux produces the corrected signal:

```text
RRX_ACTIVE = reg_shift ? 0 : RRX_ACTIVE_RAW
```

Mux wiring:

```text
input 0 = RRX_ACTIVE_RAW
input 1 = constant 0
select  = REG_SHIFT_SHIFT32 (the existing reg_shift net)
output  = RRX_ACTIVE
```

All existing RRX consumers continue to use the `RRX_ACTIVE` tunnel. No RRX
result or carry consumer was otherwise changed.

The reproducible editing script is:

```text
tools/fix_rrx_register_decode.py
```

### Verification after the correction

The modified pipeline-development copy passed:

```text
python3 -u claude_breaking_cpu_tests/run_battery.py \
  pipelined_debug_armv4t_2.circ
```

Result:

```text
PASS=22  FAIL=0  ERROR=0
```

The dedicated `tests/regress_ror_r0.py` currently cannot be used as acceptance
evidence: every batch reports `did not halt` on both the untouched source
snapshot and the corrected copy. That is a pre-existing test-harness problem,
not a difference introduced by the correction. Repair this harness and rerun
it before calling the corner case independently proven.

## Pipeline target

Use a classic five-stage organization:

```text
IF -> IF/ID -> ID -> ID/EX -> EX -> EX/MEM -> MEM -> MEM/WB -> WB
```

The existing circuits named `stage_IF`, `stage_ID`, `stage_EX`, `stage_MEM`,
and `stage_WB` are functional partitions, but the top-level connections are
mostly direct. Their names alone do not make the CPU pipelined.

Detailed hand-wiring guides:

1. [`pipeline_handbuild/01_IF_STAGE.md`](pipeline_handbuild/01_IF_STAGE.md)
2. [`pipeline_handbuild/02_ID_STAGE.md`](pipeline_handbuild/02_ID_STAGE.md)
3. [`pipeline_handbuild/03_EX_STAGE.md`](pipeline_handbuild/03_EX_STAGE.md)
4. [`pipeline_handbuild/04_MEM_STAGE.md`](pipeline_handbuild/04_MEM_STAGE.md)
5. [`pipeline_handbuild/05_WB_STAGE.md`](pipeline_handbuild/05_WB_STAGE.md)

## Implementation order

### Checkpoint 1 — IF/ID register

Register together:

```text
instruction       32 bits
pc_word_addr      32 bits
valid              1 bit
```

The IF/ID block also needs:

```text
clk
rst
enable             allow normal advance; low during a stall
flush              replace instruction with an ARM NOP and clear valid
```

Use ARM `MOV r0,r0` (`0xE1A00000`) as the injected NOP until a dedicated
pipeline-valid gate is carried through every later stage.

Do not connect this boundary permanently until its clock, reset, enable, and
flush behavior has a small direct Logisim test.

### Checkpoint 2 — ID/EX register

Register every value consumed by EX, not only the register operands. At
minimum this includes:

```text
rd_a, rd_b, rs_value, mul_acc_value
alu_ctrl, opcode, class_bits, cond, s_bit
imm_bit, imm8, shift_amount, shift_type, reg_shift
branch_imm24, instr_27_4
multiply decode/control signals
destination register number and write-enable intent
valid
```

The instruction's data and control signals must cross the same boundary on
the same clock. Mixing registered operands with live decode control will
execute portions of two different instructions together.

### Checkpoint 3 — EX/MEM register

Register:

```text
ALU/result value
store data
effective memory address
load/store size and sign controls
destination register
register-write intent
memory-write intent
condition result
multiply high/low results and write controls
valid
```

Memory writes must be gated by the registered `valid` and condition result.

### Checkpoint 4 — MEM/WB register

Register:

```text
loaded memory value
ALU/multiply value
write-back source select
destination register
register-write enable
PC-write information
valid
```

Register-file writes must be gated by `valid`.

### Checkpoint 5 — pipeline control

Add control only after all four boundaries exist:

1. EX/MEM and MEM/WB forwarding into EX operands.
2. Store-data forwarding.
3. A one-cycle load-use stall: hold PC and IF/ID, inject a bubble into ID/EX.
4. Branch/BX/PC-write flushing of younger instructions.
5. CPSR dependency handling. Initially stall flag-consuming instructions
   until the producing instruction's flags are architecturally available;
   add flag forwarding later if useful.
6. Multi-cycle/block-transfer interlock using the existing `hold_pc`,
   `bt_active`, and `bt_done` behavior.

## Required test checkpoints

At every completed boundary:

1. Validate the Logisim XML and component geometry.
2. Run a minimal direct test for reset, advance, hold, and flush.
3. Run the 22-case adversarial battery.
4. Run ISA coverage and memory-lane regressions.
5. Add dependency tests for the newly exposed pipeline hazards.

Important dependency programs include:

```text
ADD -> dependent ADD             EX forwarding
LDR -> dependent ADD             load-use stall
ADD -> STR                       store-data forwarding
CMP -> conditional instruction  CPSR hazard
taken branch -> visible store    wrong-path flush
MUL -> dependent ADD             multiply forwarding/interlock
```

## Current status

Completed:

- Created `pipelined_debug_armv4t_2.circ` from the proven snapshot.
- Added the `reg_shift` guard to the RRX decoder.
- Revalidated the full 22-case adversarial battery: 22/22 passed.
- Mapped the current top-level IF-to-ID connections.
- Added an isolated `pipe_if_id` subcircuit containing registered instruction,
  PC word address, PC+4, and valid fields with shared reset/enable and flush.
- Structurally traced every IF/ID register port and corrected the valid
  register to an explicit 1-bit width.

In progress / not yet completed:

- IF/ID integration. The isolated block is intentionally not connected until
  its sequential behavior is run through a compatible clocked testbench.
- ID/EX, EX/MEM, or MEM/WB boundaries.
- Forwarding, stalls, or flushing.
- Pipeline-specific functional verification.

Therefore the working copy has the corrected RRX decode but is not yet a
functioning pipelined processor.

### Local test-runner limitation discovered

The installed runner is Logisim Evolution v3.8.0 (2023-03-02). It does not
support the newer `<set>`/`<seq>` sequential test-vector columns, and ordinary
test-vector rows reset state between rows. A manual `0 -> 1` clock listing in
that format is therefore not a valid register test on this installation.
Use a clocked Logisim testbench for pipeline registers, or rerun
`tests/pipe_if_id_vector.txt` with a newer Logisim version that supports
sequential test sets.
