# Project Log

## 2026-08-20 (FPGA timing)

- Replaced the ALU's hand-built Kogge-Stone adder with a rebuilt
  `ALU_arithmetic_engine` using Logisim's built-in `Adder`. Measured effect on
  routed Artix-7 timing:

  | | Fmax | critical path | LUTs | CARRY4 |
  |---|---|---|---|---|
  | ALU before | 63.37 MHz | 15.78 ns | 321 | 0 |
  | ALU after  | 98.12 MHz | 10.19 ns | 176 | 9 |
  | CPU before | 45.34 MHz | 22.06 ns | 1559 | 26 |
  | CPU after  | 58.31 MHz | 17.15 ns | 1605 | 34 |

  +55% on the ALU and +29% on the whole CPU, while *shrinking* the ALU by 45%.
  Cause: a hand-built parallel-prefix adder cannot use the FPGA's dedicated
  carry chain, so it maps entirely to LUTs and MUXF6. `CARRY4` going 0 -> 9 in
  the ALU is the whole effect. Correct on an ASIC, wrong on an FPGA.
- Isolated component A/B measurements, identical harness and flow:
  - 32-bit adder: `ks_32b` 86.64 MHz / 128 LUT / 0 CARRY4 versus plain `+`
    151.71 MHz / 45 LUT / 9 CARRY4. Built-in wins 1.75x on a third of the area.
  - 32-bit shifter: `barrel_32b` 101.9 MHz / 290 LUT versus built-in operators
    104.9 MHz / 582 LUT. Effectively a tie on speed at half the area, so the
    hand-built barrel shifter is kept. The rule is not "built-ins are faster",
    it is "built-ins win when they map to dedicated silicon" (CARRY4, DSP48).
- Re-established the FPGA timing flow, which had been lost with the deleted
  `.tools/` directory. It is F4PGA (Yosys + VPR) in Docker, not Vivado.
  Blockers found and fixed:
  - `main` contains an orphaned splitter at `(2650,4090)` whose bus end drives
    nothing; Logisim's HDL exporter rejects the entire design for it. Confirmed
    pre-existing against a pristine checkout. Still present in `armv4t.circ`.
  - Stock Logisim 3.8 cannot export HDL headless: it aborts on an incomplete
    board IO map, and the design has ~640 bits of top-level IO so a complete
    map is impossible. Patched 3.8.0 source so an incomplete map is tolerated
    only when `generateHdlOnly` is set; real board downloads still refuse.
  - Logisim's `--test-fpga` arg parser ignores `HDLONLY` if a tick frequency
    was parsed first, contrary to its own docstring. Order must be
    `<circ> main <board> HDLONLY <freq>`.
- All timing numbers are F4PGA/VPR on `xc7a100tcsg324-1`, which is pessimistic
  on routing. Ratios are reliable; absolute MHz figures are not, and none of
  this is the XCKU5P target part.
- The synthesised design is not functionally identical to the simulation:
  Logisim's exporter emits a rising-edge RAM with input registers, a tick
  pipeline and an output register regardless of the circuit's RAM settings.
  These are datapath timing numbers, not a validated CPU.

## 2026-08-20

- Wired SP writeback through the register file's secondary port
  (`WA2`/`WD2`/`WE2`): an OR gate feeding `WE2` from the existing base
  writeback path OR `done`, and a 32-bit mux feeding `WD2` with
  `final_address`. The mux select had to be `done`, not `active`: both are
  registered, and `active` falls on the same tick `done` rises, so an
  `active`-selected mux presented the stale pre-transfer base at write time.
- Root-caused a whole-simulation oscillation that had been blamed on the
  block-transfer datapath. It is **not** a block-transfer bug. Minimal repro
  is three ROM words with no memory access and no block transfer:
  `e3a0107f e0810001 e12fff1e` (`mov r1,#0x7F; add r0,r1,r1; bx lr`).
  It reproduces identically on commit `ef985e6`, so it predates all
  block-transfer work.
- Localized it by forcing signals to constants in a scratch copy. Pinning
  `ks_32b`'s operands changed nothing; pinning `mul_32`'s operands removed
  the oscillation in every failing case; pinning `partial_products`' 32
  outputs also removed it. Minimizing the live partial-product set gives
  `p2,p3,p4,p5,p6`, all five required. The defect is a combinational cycle
  in `mul_32`'s CSA reduction tree — a `csa_3to_2` output reaching an input
  at or above its own level — among the cells fed by those partial products.
- `mul_32` is ungated and recomputes on every instruction regardless of
  opcode, so the cycle fired on ordinary `ADD` and `STR` as well as on
  block transfers. Block transfer only made it constant: with `hold_pc`
  asserted, `RB` is driven by `reg_idx` and the ALU sees sixteen new operand
  pairs per push, so almost every push hit an exciting combination.
- Non-oscillating arithmetic was checked separately and is correct: 24 sums
  compared against expected values, zero wrong. The adder is not at fault.
- Disconnected `mul_32` in `armv4t.circ` at both ends — operands cut at the
  `A`/`B` pins in `ALU`, and the multiplier result cut out of the out-mux
  `in2` input. No ROM in `cpu/` exercises multiply, so this costs no current
  coverage.
- With the multiplier out, the 10-ROM PUSH discriminator suite passes 10/10
  on a scratch copy of the circuit, including `sp_continuity`, which had been
  the one expected failure. PUSH plus SP writeback is now verified end to end.
- POP is confirmed incomplete. A single-register POP restores the register and
  SP correctly, but a multi-register POP is broken: SP over-advances by `4n`
  (`0x208` and `0x20C` instead of `0x200` for two- and three-register pops),
  the first register receives the transfer address instead of the loaded data,
  and later registers are never written. The single-register case passing is a
  trap — it is the one case where the terminal condition fires before the
  broken stepping accumulates.

## 2026-08-19

- Wired `main`'s RAM/register-file datapath for block-transfer stores: a RAM
  address override mux (`sel=active`, `in1=transfer_address`), an OR gate
  feeding `store_enable` into the RAM write-enable path, and a 4-bit mux
  selecting `reg_idx` onto `reg16x32_1.RB` so the scanned register's value
  reaches `RD_B`. `block_transfer_control.base_value` reads `RD_A` directly.
- Found and fixed two bugs in `block_transfer_control`'s address stepping:
  the `base_or_step` mux select was wired to raw `start` instead of the
  one-cycle `accept_start` pulse, and `base_or_step.in0` fed `stepped_addr`
  directly with no hold path, so the address advanced every scan cycle
  instead of only on `reg_selected`. Fixed by rewiring select to
  `accept_start` and inserting a hold mux (`sel=reg_selected`) between
  `stepped_addr` and `base_or_step.in0`.
- Built a 10-ROM PUSH discriminator suite (two/high/scattered/consecutive
  register sets, callee-saved+LR, a full 14-register push, zero-value and
  all-ones values, and a two-push SP-continuity case), each program fit to
  the 16-word instruction ROM limit.
- 9/10 passed on the real circuit, including the 14-register case (ascending
  register number to ascending address, lowest register at final SP). The
  10th (`sp_continuity`, two sequential `push` instructions) failed as
  expected: SP writeback to the register file is not yet wired, so the
  second push re-read the stale pre-push SP instead of the address left by
  the first push. Single-instruction PUSH is verified correct; SP writeback
  is the next required step before POP or multi-push sequences can work.

## 2026-08-14

- Expanded instruction fetch from 16 to 256 words using `PC[9:2]`.
- Added the first complete freestanding build: ARM startup, linker script,
  GCC-compiled stack-backed loop, ROM generation, and exact-image checks.
- Built a 22-word practical-C acceptance image with an ABI argument, stack
  local, conditional loop, C pointer store, function return, and stable halt.
- Ran it headlessly on the real Logisim circuit to `BX LR`; verified
  RAM[40]=18 and RAM[FF]=1.
- Added canonical ARM-state PUSH/POP form detection for `STMDB SP!` and
  `LDMIA SP!`.
- Added `pc_fetch.hold` and integrated a multi-cycle block-transfer controller.
- Verified controller start, active, done, PC hold/release, PUSH countdown
  `F..0`, POP count-up `0..F`, and automatic terminal detection in `main`.
- Added and verified 16-bit block-transfer register-list capture and indexed
  selection; `0x4010` selects only R14 and R4 during either scan direction.
- Integrated `instr[15:0]` and `reg_selected` through the controller instance in
  `main`; the full register-list path now operates on fetched instructions.
- Preserved the gate-level circuit as the reference implementation; the planned
  next-generation RTL will retain its adder, ALU, shifter, decode, control, and
  memory behavior before manual pipelining.

## 2026-08-13

- Completed load-side stack base writeback with simultaneous `Rd` and `Rn`
  writes through the rebuilt dual-write register file.
- Found the LDR timing failure: synchronous `RAM.out` changed only after the
  register-write edge, so a post-index load wrote stale data.
- Proved the diagnosis with a sacrificial-load ROM under synchronous-read RAM.
- Enabled asynchronous RAM reads for the current single-cycle datapath.
- Verified the final stack signature: R1=AA, R2=100, R13=100, RAM[3F]=AA.

## 2026-08-06

- Verified store-side stack base writeback.
- `STR R0,[SP,#-4]!` produced SP=FC and RAM[3F]=AA.
- `STR R0,[SP],#4` produced SP=104 and RAM[40]=55.
- Confirmed `STR R0,[SP,#4]` writes RAM without changing SP.

## 2026-08-05

- Added the 16-word Fibonacci RAM integration milestone ROM.
- Added a ROM that populates RAM[0..46] with every 32-bit signed Fibonacci value.
- Manually verified the complete F0..F46 RAM dump: all 47 words matched and
  RAM[0x2F] onward remained unchanged at zero.
- Added a 64-generation Rule 30 cellular-automaton ROM as a visual bitwise and
  RAM stress test.
- Created the flat `cpu/` release bundle with canonical ROM names.
- Added ten matching freestanding C reference implementations and host tests.
- Added reproducible math-ROM assembly and bundle validation.
- Split current status, roadmap, release procedure, and historical notes.

## 2026-08-04

- Verified STR writes to data RAM.
- Verified word LDR and STR with positive and negative immediate offsets.
- Passed the memory regression signature: R2=AA, R4=55, R5=33,
  RAM[07]=55, RAM[09]=AA.

## 2026-08-02

- Completed the memory-class decode and effective-address datapath.
- Added memory write suppression to the register-write control path.

## 2026-07-28

- Verified compiled leaf C addition and BX LR return behavior.
- Established the first compiler-produced machine-code regression.

## 2026-07-27

- Completed B, conditional B, BL, BX, and BX LR tests.
- Verified link-register and PC redirection behavior.

## 2026-07-26

- Completed CPSR N/Z/C/V storage and ARM condition checking.
- Gated architectural register writes with `condition_pass`.

## 2026-07-14

- Completed the initial ALU and carry-select adder work.
- Added the staged 32-bit barrel shifter and Operand2 immediate rotation path.

Detailed historical wiring notes were preserved in
`docs/ARCHITECTURE_NOTES_LEGACY.md`.
