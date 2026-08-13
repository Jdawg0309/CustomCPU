# Project Status

Last updated: 2026-08-13

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
- a 16-word Fibonacci integration program covering compute, shifts, flags,
  conditional looping, STR/LDR, RAM readback, and a self-checking signature
- a verified 47-iteration loop that fills RAM word addresses 0x00 through 0x2E
  with F0 through F46 while preserving RAM from 0x2F onward
- verified STR pre-index and post-index base writeback, including R13 stack
  decrement/increment and a no-writeback discriminator
- verified post-index LDR with simultaneous destination-register and R13 base
  writeback through the rebuilt dual-write register file
- asynchronous data-RAM reads for correct single-cycle LDR timing

All twelve canonical regression images and the math pack are cataloged in
`cpu/README.md`.

## Practical-C Status

The CPU is capable of general finite-state computation and can execute useful
hand-assembled algorithms. It is not yet a practical compiled-C target.

Load-side stack addressing and simultaneous `Rd`/`Rn` writeback are complete.
The remaining practical-C work is:

- register-offset LDR/STR needed by some compiler output
- sufficiently large instruction memory for startup and nontrivial programs
- reset/startup code, linker script, and a stable memory map
- an end-to-end test built by `arm-none-eabi-gcc`, not manually translated

Estimated completion toward the first practical freestanding C milestone is
about 85-90 percent by feature count. Compatibility with a complete ARM7TDMI is
substantially lower because exceptions, privileged modes, Thumb, byte/halfword
accesses, multiply integration, and architectural edge cases remain.

## Immediate Next Step

Expand instruction memory and add the startup/linker build needed for a compiled
function that creates a stack frame, accesses a local variable, restores R13,
and returns through LR.

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
