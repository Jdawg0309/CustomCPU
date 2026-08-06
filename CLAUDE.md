# CustomCPU Agent Guide

This file contains working rules and pointers only. Do not record progress or
future plans here; update the authoritative project documents listed below.

## Authoritative Documents

- `PROJECT_STATUS.md`: current hardware capability and immediate blocker
- `PROJECT_LOG.md`: completed milestones in chronological order
- `ROADMAP.md`: future implementation order and milestone definitions
- `RELEASE_CHECKLIST.md`: commands and checks required before a release
- `cpu/README.md`: canonical ROM catalog and exact expected results
- `docs/ARCHITECTURE_NOTES_LEGACY.md`: preserved detailed design history

## Project Rules

- `armv4t.circ` is the authoritative Logisim Evolution circuit.
- `cpu/` is the canonical, flat release bundle for ROMs and test sources.
- Update `PROJECT_STATUS.md` after a hardware capability changes.
- Append to `PROJECT_LOG.md` only after a test has passed.
- Keep current limitations explicit. Do not call the core fully ARMv4T,
  ARM7TDMI-compatible, or practical-C capable until the corresponding roadmap
  acceptance tests pass.
- Preserve user circuit changes. Never replace or regenerate `armv4t.circ`
  without inspecting the current file first.
- Use dot notation for named circuit signals, matching labels already present in
  the circuit whenever possible.

## Verification

Run the software and release-bundle checks with:

```text
make -C cpu verify
python3 build_regression_roms.py
```

Hardware regression tests are manual in Logisim Evolution. Load
`cpu/decode_opcode.rom` into the decoder and follow `cpu/README.md` for each
instruction ROM.

## Current Focus

Read `PROJECT_STATUS.md` before making a recommendation. Store-side stack
writeback is verified. The next hardware work is load-side base writeback and
the simultaneous `Rd`/`Rn` write problem, followed by a larger instruction ROM,
reset/startup, linker support, and an actual compiled C integration test.
