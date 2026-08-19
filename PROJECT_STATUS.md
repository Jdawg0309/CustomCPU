# Project Status

Last updated: 2026-08-19

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
- asynchronous data-RAM reads for correct single-cycle LDR timing
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
- verified single-instruction PUSH against a 10-ROM discriminator suite (9/10
  passed), covering low/high/scattered/consecutive register sets, a full
  14-register push, zero and all-ones values, and callee-saved+LR sets; the
  one failure (two sequential `push` instructions) is expected because SP
  writeback to the register file is not yet wired

All twelve canonical regression images and the math pack are cataloged in
`cpu/README.md`.

## Practical-C Status

The first practical freestanding-C acceptance image passed the actual Logisim
CPU on 2026-08-14. It includes a reset entry point, a fixed memory map, stack
initialization, a GCC-compiled conditional loop with a stack-backed local,
`BL`/`BX LR`, and a compiler-generated RAM result store.

Completed practical-C infrastructure:

- 256-word instruction ROM addressed by `PC[9:2]`
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

PUSH (store side) is wired and verified for single instructions. Remaining
block-transfer work: write the final address back to SP (secondary write
port, needed before POP or multi-push sequences work), then wire POP's
primary write port (WA/WD/WE) so scanned registers load back from RAM. Then
replace asynchronous LDR behavior with a synchronous memory wait state and
freeze the gate-level practical-C release.

## Known Limits

- ARM state only; no Thumb execution
- no exception or interrupt handling
- no verified privileged modes or banked registers
- no byte or halfword load/store path
- multiply detection exists in prior decode work but is not a completed,
  top-level verified instruction path
- no MMIO input, UART, PS/2, timer, or external bus
- data RAM currently uses asynchronous reads for the single-cycle datapath;
  FPGA block RAM will require a load wait state or pipelined memory stage
- no FPGA timing result; Logisim simulation frequency is not Fmax
