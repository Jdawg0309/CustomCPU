# Project Status

Last updated: 2026-08-20

## Current CPU

The authoritative design is `armv4t.circ`, a single-cycle ARM-state educational
CPU built in Logisim Evolution. The following behavior has been tested manually:

- data-processing instructions with register and immediate Operand2
- barrel shifts used by the current regression programs
- CPSR N/Z/C/V storage, S-bit updates, and ARM condition execution
- B, conditional B, BL, BX, and BX LR control flow
- word STR and LDR with tested positive and negative immediate offsets
- 1 KiB data RAM through the current memory datapath
- one compiled leaf C function that performs register-only addition and returns
- ten hand-assembled math programs, including RAM, loops, and conditional code
- a Fibonacci integration program covering compute, shifts, flags,
  conditional looping, STR/LDR, RAM readback, and a self-checking signature
- a verified 47-iteration loop that fills RAM word addresses 0x00 through 0x2E
  with F0 through F46 while preserving RAM from 0x2F onward
- verified STR pre-index and post-index base writeback, including R13 stack
  decrement/increment and a no-writeback discriminator
- verified post-index LDR with simultaneous destination-register and R13 base
  writeback through the rebuilt dual-write register file
- falling-edge synchronous data RAM, whose read completes mid-cycle ahead of
  the rising-edge register write, giving correct single-cycle LDR timing
- integrated block-transfer detection and a verified multi-cycle controller
  with PC hold/release, PUSH `F..0` scanning, POP `0..F` scanning, and automatic
  terminal detection
- verified block-transfer register-list capture and per-index selection using
  the GCC test list `0x4010` for R4 and LR
- connected fetched `instr[15:0]` to the block-transfer controller in `main`
  and exposed the active `reg_selected` result
- wired and verified the block-transfer RAM/register-file store datapath:
  address override mux, write-enable OR gate, and `reg_idx`-selected `RD_B`
  source, with two address-stepping bugs found and fixed in
  `block_transfer_control`
- wired SP writeback through the register file's secondary write port
  (`WA2`/`WD2`/`WE2`), with the `WD2` mux selected by `done` rather than
  `active` so the mux does not present the stale pre-transfer base
- a complete, verified block-transfer stack: PUSH and POP both working in
  `armv4t.circ`, covering the register write-enable suppression, single-step
  address advance, and the RAM-to-register load path
- verified POP against a 7-ROM discriminator suite (7/7), five cases popping
  into different registers than were pushed, plus an 8-case stress suite
  (LIFO nesting, interleaved LDR/STR, three-deep sequential push/pop,
  preservation of registers outside the list, LR save/restore, boundary
  values, stack at the top of RAM, high-register lists), each also asserting
  no RAM word outside its declared write-set was touched
- verified PUSH against a 10-ROM discriminator suite (10/10 passed), covering
  low/high/scattered/consecutive register sets, a full 14-register push, zero
  and all-ones values, callee-saved+LR sets, and two sequential `push`
  instructions exercising SP continuity; re-run directly against
  `armv4t.circ` on 2026-08-20 with the same 10/10 result

- an ALU arithmetic engine rebuilt on Logisim's built-in `Adder`, replacing the
  hand-built Kogge-Stone prefix adder, which raised routed ALU Fmax from
  63.37 MHz to 98.12 MHz and whole-CPU Fmax from 45.34 MHz to 58.31 MHz while
  reducing ALU LUT count by 45%

All twelve canonical regression images and the math pack are cataloged in
`cpu/README.md`.

## Measured FPGA Timing

Routed on `xc7a100tcsg324-1` with F4PGA (Yosys + VPR) in Docker, not Vivado and
not the XCKU5P target part. VPR is pessimistic on routing, so treat the ratios
as reliable and the absolute frequencies as indicative only.

| block | Fmax | critical path |
|---|---|---|
| ALU | 98.12 MHz | 10.19 ns |
| whole CPU | 58.31 MHz | 17.15 ns |

The CPU is single-cycle and fully combinational between register boundaries, so
the critical path is essentially one whole instruction: decode, shift, ALU,
condition, writeback. The ALU alone is 59% of it. Pipelining, not logic tuning,
is the only route to the 150-200 MHz goal; even a zero-cost surround would cap
the current ALU at 98 MHz.

Two caveats on every number above. The measured design has `mul_32` removed, so
a restored multiplier will add to the critical path. And Logisim's HDL exporter
emits a rising-edge RAM with input registers, a tick pipeline and an output
register regardless of the circuit's RAM configuration, so the synthesised
netlist is a valid timing model of the datapath but is not functionally the
simulated CPU.

## Practical-C Status

The first practical freestanding-C acceptance image passed the actual Logisim
CPU on 2026-08-14. It includes a reset entry point, a fixed memory map, stack
initialization, a GCC-compiled conditional loop with a stack-backed local,
`BL`/`BX LR`, and a compiler-generated RAM result store.

Completed practical-C infrastructure:

- an instruction ROM addressed by the low PC word bits; note this was 256
  words on 2026-08-14 but the circuit today has only 16, which is the
  current blocker (see Immediate Next Step)
- 1 KiB RAM at byte addresses `0x000` through `0x3FF`
- descending stack initialized one byte beyond RAM at `0x400`
- ARM linker script and startup assembly
- reproducible `arm-none-eabi-gcc` build and exact machine-image verification
- automated headless Logisim execution to `BX LR`
- documented 35-clock manual acceptance signature in `PRACTICAL_C_CPU_TEST.md`

The verified signature is `RAM[40]=00000018` and `RAM[FF]=00000001`.
Register-offset LDR/STR is not required by this image and remains a later
compiler-coverage improvement.

## Immediate Next Step

Enlarge the instruction ROM. It is currently `addrWidth=4`, i.e. **16 words**,
which is now the binding constraint on everything: `c_tests/stress_call_rom` is
31 words and the practical-C acceptance image is 22, so no compiled program can
run at all, and several canonical ROMs in `cpu/` no longer fit either. The
earlier 256-word fetch path described under Practical-C Status is not what the
circuit currently implements.

After that, two stack gaps that need a larger ROM to exercise:

- `pop {pc}`, the function-return form GCC actually emits, is untested.
- Register lists longer than five cannot be round-tripped in 16 words; the
  14-register case is PUSH-only.

Also delete the orphaned splitter at `(2650,4090)` in `main`: it drives nothing
and it blocks HDL export entirely, so every future timing run needs it gone.


## Known Limits

- ARM state only; no Thumb execution
- no exception or interrupt handling
- no verified privileged modes or banked registers
- no byte or halfword load/store path
- multiply detection exists in prior decode work but is not a completed,
  top-level verified instruction path
- `mul_32` is disconnected in `armv4t.circ`: operands cut at the `A`/`B` pins
  in `ALU`, and the multiplier result cut out of the out-mux `in2` input. MUL
  therefore does not execute at all. Cause: a combinational cycle in `mul_32`'s
  CSA reduction tree, among the `csa_3to_2` cells fed by partial products
  `p2`-`p6`, which oscillated the entire simulation on ordinary `ADD`/`STR` and
  on block transfers because `mul_32` is ungated and recomputes on every
  instruction. Minimal repro on the connected circuit is three ROM words:
  `e3a0107f e0810001 e12fff1e`. Restoring MUL requires reconnecting both ends
  and fixing the CSA cycle; gating the operands with `engine_sel` is a valid
  alternative that confines the fault without repairing it.
- no MMIO input, UART, PS/2, timer, or external bus
- data RAM currently uses asynchronous reads for the single-cycle datapath;
  FPGA block RAM will require a load wait state or pipelined memory stage
- no FPGA timing result; Logisim simulation frequency is not Fmax
