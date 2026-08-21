# AI Contributions

An exhaustive audit of AI-assisted file writing in this repository, produced by
scanning every Claude Code session transcript on the author's machine. It is
generated, not asserted:

```bash
python3 tools/ai_audit.py
```

The scan covers all transcripts in `~/.claude/projects/`, filters to paths under
this repository, and records every `Write`, `Edit`, and `MultiEdit` call. Scratch
files outside the repository are excluded. **`new`** means the file was created
by that call; **`edit`** means an existing file was modified.

## The circuit

| file | new | edit | dates | what |
|---|---:|---:|---|---|
| `armv4t.circ` | 0 | **2** | 2026-08-17 | one output pin (`final_address`) and one wire attaching it to a pre-existing net |
| `debug_armv4t.circ` | 0 | 7 | 2026-08-17 | scratch copy for diagnosis; not part of the design |

`armv4t.circ` is the CPU. Across 24 revisions and 1,261 components, AI wrote
**two** things into it, both on 2026-08-17: the `final_address` output pin at
`(1550,2700)` in `block_transfer_control`, and the wire `(1550,2560) →
(1550,2700)` connecting it.

That wire attached a new port to a net that already existed — the edit's anchor
was the author's own `(1550,2560) → (1780,2560)` wire. **No AI-made connection
joins two pieces of logic in this design.** Every signal path between logic
elements was wired by hand.

Everything else — all 33 subcircuits, the adder hierarchy, ALU, multiplier tree,
barrel shifter, register file, fetch unit, block-transfer controller — was
designed and wired by the author in Logisim Evolution.

## Tooling

Written by AI. These analyse and test the circuit; none of them modify it.

| file | new | edit | dates |
|---|---:|---:|---|
| `tools/circuit_model.py` | 1 | 12 | 2026-08-19 |
| `tools/circuit_graph.py` | 2 | 1 | 2026-08-15 → 08-17 |
| `tools/provenance.py` | 1 | 0 | 2026-08-21 |
| `tools/vestigial.py` | 1 | 0 | 2026-08-21 |
| `tools/ai_audit.py` | 1 | 0 | 2026-08-21 |

## Test programs

| file | new | edit | dates |
|---|---:|---:|---|
| `stack_recursion_tests/01_push_pop_single.S` | 1 | 0 | 2026-08-17 |
| `stack_recursion_tests/02_push_pop_multi.S` | 1 | 0 | 2026-08-17 |
| `stack_recursion_tests/03_fib_recursive.S` | 1 | 0 | 2026-08-17 |

## Documentation

| file | new | edit | dates |
|---|---:|---:|---|
| `PROJECT_STATUS.md` | 0 | 12 | 2026-08-19 → 08-20 |
| `PROJECT_LOG.md` | 0 | 4 | 2026-08-19 → 08-20 |
| `CLAUDE.md` | 0 | 2 | 2026-08-16 |
| `CLAUDE_CODE_HANDOFF.md` | 0 | 2 | 2026-08-15 |
| `stack_recursion_tests/README.md` | 1 | 2 | 2026-08-17 |
| `docs/ARM_STATE_COMPLETION_CHECKLIST.md` | 1 | 0 | 2026-08-16 |
| `docs/DESIGN_NARRATIVE.md` | 1 | 0 | 2026-08-21 |
| `PROVENANCE.md` | 1 | 2 | 2026-08-21 |

`docs/DESIGN_NARRATIVE.md` is a skeleton of prompts only; the narrative itself
is to be written by the author.

## FPGA / HDL scaffolding

On branch `agent/wip-block-pop-timing` and in `fpga/`. These are synthesis
wrappers and build scripts around HDL *exported from the author's circuit* by
Logisim; they contain no hand-authored logic.

| file | new | edit | dates |
|---|---:|---:|---|
| `hdl/alu_modular/alu_modular_timing_top.v` | 1 | 2 | 2026-08-16 |
| `hdl/alu_modular/alu32_timing_top.v` | 1 | 0 | 2026-08-16 |
| `hdl/alu_modular/Makefile`, `alu32/Makefile` | 2 | 0 | 2026-08-16 |
| `hdl/alu_modular/arty_a7_100t.xdc`, `alu32/…` | 2 | 0 | 2026-08-16 |
| `hdl/logisim_full_cpu/full_cpu_timing_top.v` | 0 | 1 | 2026-08-15 |
| `hdl/logisim_full_cpu/Makefile` | 0 | 1 | 2026-08-15 |
| `fpga/fmax/*` | 4 | 0 | 2026-08-21 |
| `.gitignore` | 0 | 2 | 2026-08-15 |

## Summary

```
25 distinct repo files ever written by AI
   CIRCUIT      9 tool calls across 2 files
   tooling     18 tool calls across 4 files
   test/ROM     3 tool calls across 3 files
   docs        25 tool calls across 7 files
   other       12 tool calls across 9 files
```

The division is consistent: **AI wrote tooling, tests and documentation. The
author designed and wired the CPU.** The two exceptions in `armv4t.circ` are
listed above rather than omitted.

Debugging and diagnosis were also AI-assisted throughout — localising the
combinational cycle in `mul_32`, the block-transfer address stepping, the
`WD2` mux select timing. That analysis informed wiring the author then performed.
