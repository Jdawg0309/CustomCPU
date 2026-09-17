# CustomCPU Ultimate Completion Checklist

Locked: 2026-09-02

This is the project acceptance roadmap. Percentages from the 54-case
adversarial suite are regression coverage, not formal ARMv4T conformance.
The ARM-state target intentionally excludes Thumb until explicitly reopened.

## Gate 0 — preserve the known-good machine

- [x] Establish a reproducible 53/54 baseline on the real Logisim engine
      (`SWP` is the one known failure).
- [x] Ordinary word loads/stores pass at every addressing mode covered by the
      adversarial suite.
- [x] Byte loads/stores pass on all four byte lanes without corrupting neighbors
      (19/19 focused memory-lane checks, including halfwords and signed loads).
- [x] PUSH/POP and the general block-transfer cases in the adversarial suite
      remain green.
- [x] PC writes, literal pools, conditions, flags, and the shifter cases in the
      adversarial suite remain green.

## Priorities 1–7 — tonight's architectural target

- [x] 1. Stable word/byte RAM behavior, including lane-preservation tests.
- [ ] 2. `LDRH` and `STRH`, both aligned halfword lanes and offset forms.
      Aligned low/high immediate-offset lanes pass; add a dedicated
      register-offset discriminator before checking off the complete item.
- [x] 3. `LDRSB` and `LDRSH`, including positive/negative sign-extension cases.
- [x] 4. `MUL` and `MLA`, using FPGA-inferred multiplier hardware.
- [x] 5. `UMULL`, `UMLAL`, `SMULL`, and `SMLAL`, with correct 64-bit results,
      accumulate behavior, destination ordering, and optional flag updates.
- [ ] 6. All ARM-state `LDM`/`STM` IA/IB/DA/DB forms, load/store direction,
      writeback on/off, non-SP bases, register ordering, and documented edge cases.
- [ ] 7. Complete shifter semantics: immediate/register amounts 0, 1, 31, 32,
      greater than 32, low-byte register amount, `RRX`, and correct carry-out.
- [ ] Expand the regression suite so every behavior above has a discriminator.
- [ ] Pass the original adversarial suite 54/54 on the real Logisim engine.
- [ ] Pass the expanded edge suite with no known failures.

## Remaining ARM-state architecture

- [ ] `SWP` and `SWPB` or a documented deliberate omission.
- [ ] CPSR reads/writes with `MRS` and `MSR`.
- [ ] Exception vectors and entry/return behavior.
- [ ] ARM modes and banked registers.
- [ ] SPSR per exception mode.
- [ ] Undefined-instruction handling.
- [ ] Data/prefetch abort behavior and alignment policy.
- [ ] Coprocessor instruction handling or defined-undefined behavior.
- [ ] Comprehensive condition-code and flag validation.
- [ ] Thumb state only if full ARMv4T, rather than ARM-state-only, becomes the goal.

## Microcontroller platform

- [ ] Stable memory map and linker script.
- [ ] Reset/startup code (`SP`, `.data`, `.bss`).
- [ ] Memory-mapped GPIO direction, output, and input registers.
- [ ] Timer/counter.
- [ ] Interrupt controller.
- [ ] UART.
- [ ] NPU command/status/address/length registers.
- [ ] Freestanding-GCC compile-and-run regression suite.

## Pipeline and implementation

- [ ] Freeze and document the correct single-cycle architectural behavior.
- [ ] Extract synthesizable HDL and compare it against the Logisim reference.
- [ ] Record logic equations and state transitions for each stage from the ground up.
- [ ] Add explicit IF/ID and ID/EX or EX/WB pipeline boundaries for a three-stage core.
- [ ] Implement forwarding, stalls, load-use interlock, branch/PC-write flushes,
      and multi-cycle multiply/block-transfer control.
- [ ] Prove pipelined behavior against the single-cycle architectural oracle.
- [ ] Measure post-route Fmax on the target XC7K480T in Vivado.

## Definition of done

The project is finished when the implemented ISA is explicitly declared,
every declared behavior has an automated discriminator, freestanding GCC
programs and peripheral firmware run on hardware, exported HDL agrees with
the Logisim reference, and timing is measured post-route on the target FPGA.
