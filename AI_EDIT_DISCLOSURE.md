# Disclosure: two AI edits to `armv4t.circ`

The standing rule on this project has been that `armv4t.circ` — the CPU itself —
is hand-wired by the author, and that AI assistance operates only on copies,
tooling and tests. That rule was broken once. This document records exactly how,
because a specific disclosure is worth more than a general assurance.

## What happened

On **2026-08-17 at 20:04 UTC**, an AI assistant (Claude) made two direct edits
to `armv4t.circ` instead of working in `debug_armv4t.circ` as instructed. Twelve
seconds apart:

| time (UTC) | change | location |
|---|---|---|
| 20:04:02 | added an output pin, `final_address`, 32-bit, radix 16 | `block_transfer_control` at `(1550,2700)` |
| 20:04:14 | added one wire | `(1550,2560)` → `(1550,2700)` |

Both were committed, unnoticed, in `ef985e6`. They are still in the circuit.

## What the change does

`final_address` is the port that carries the post-transfer stack pointer out of
`block_transfer_control` to `main`, where it feeds the `WD2` mux for stack-pointer
writeback.

The wire does **not** join two pieces of logic. Its edit anchored on an existing
wire — the author's own `(1550,2560) → (1780,2560)`, which already carried the
address register's output to the adders and address muxes. The new wire branched
that existing net out to the new pin. No AI-made connection links logic elements
in this design; the signal path was already there, and the edit exposed it as a
port.

## Scale

Two components out of **1,261**, across 33 subcircuits built over roughly eight
weeks: **0.16%** of the circuit. Every other component and every connection
between logic elements was placed by the author in Logisim Evolution.

## How this was established

Every Claude Code session transcript on the author's machine was searched — all
projects, all sessions, including copies of this repository at other paths. The
scan covered file-editing tool calls (`Write`, `Edit`, `MultiEdit`) and shell
commands capable of writing the file (`>`, `>>`, `tee`, `sed -i`, `cp`, `mv`).

Result: **two** edits, both listed above. Zero shell commands wrote to the file;
every apparent match was `cp armv4t.circ debug_armv4t.circ`, copying *from* it.
Claude Code's own pre-edit backup store holds no entries for the file.

The tooling that produced this audit is on the `archive/full-2026-08-21` branch
as `tools/ai_audit.py`, and it reproduces the same result on demand.

## What was not affected

Work completed after 2026-08-17 contains no AI edits to the circuit. That
includes the entire block-transfer datapath, the `PHASE_REG` state element
(first appearing 2026-08-19 in `ff09434`), the register write-enable
suppression, the address hold-mux fix, the load-data path, the built-in adder
swap, the 1024-word fetch path, and the program-counter write logic. All of it
was wired by the author; AI involvement was limited to diagnosis, test
harnesses and verification.

## Why disclose something this small

Because it happened, and because the alternative is a blanket claim that a
single `git log` could falsify. An audited, specific number is a stronger
statement than an absolute one: the circuit is the author's work, and here is
precisely the extent to which that is qualified.
