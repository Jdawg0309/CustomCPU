# Roadmap

## Milestone 1: Practical Freestanding C

1. Complete LDR/STR P/U/W addressing and Rn writeback.
2. Validate R13 stack allocation, local-variable access, and restoration.
3. Expand instruction ROM beyond the current 16-word test limit.
4. Define reset vector, memory map, stack top, and program entry.
5. Add an ARM linker script and startup assembly.
6. Run a GCC-built C program with loops, local variables, calls, and RAM.

Acceptance: a reproducible build loads a compiler-generated ROM, runs without
manual instruction translation, stores a known result in RAM, and halts in a
documented loop.

## Milestone 2: Stable ARM-State Core

1. Integrate and verify MUL/MLA.
2. Add byte and halfword transfers.
3. Cover missing Operand2 and PC edge cases.
4. Add SWI/undefined-instruction handling and basic exceptions.
5. Expand automated architectural regression coverage.

## Milestone 3: Keyboard and Serial I/O

1. Define a memory-mapped I/O region.
2. Add a UART receiver first, or a PS/2 receiver for a direct keyboard.
3. Expose data-ready/status and received-byte registers to LDR.
4. Add an interrupt later; polling is sufficient for the first test.
5. Run C that reads bytes, decodes ASCII or PS/2 scan codes, and echoes them.

Keyboard decoding becomes practical immediately after Milestone 1 plus a small
MMIO input peripheral. USB keyboards require a USB host controller and stack;
UART or PS/2 is the much shorter first path.

## Milestone 4: FPGA RTL and Pipeline

1. Freeze the single-cycle architectural behavior and regression suite.
2. translate the circuit into maintainable Verilog or SystemVerilog.
3. Synthesize on a selected FPGA and record area and timing reports.
4. Add pipeline stages, forwarding, stalls, flushes, and hazard tests.
5. Re-run the same architectural ROM suite at each stage.

## Milestone 5: Math/NPU Toolchain

1. Define an accelerator instruction or MMIO command interface.
2. Add fixed-point vector and matrix kernels with DMA-capable local memory.
3. Build a tiny runtime that dispatches CPU control code and NPU kernels.
4. Lower a constrained ONNX operator subset into that runtime.
5. Integrate CVLA only after the operator contracts and memory model are stable.

ONNX is a model interchange format, not an instruction set. Support requires a
compiler/lowering layer and implemented kernels; it cannot be provided by ROMs
alone.
