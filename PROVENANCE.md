# Provenance

`armv4t.circ` is a Logisim Evolution circuit — a single large XML file. Git
tracks it faithfully, but a textual diff of it is thousands of lines of
`<wire from="(x,y)" to="(x,y)"/>` and tells a reader nothing. This document
exists so the construction history is legible rather than merely present.

Everything here is generated from the repository itself. Nothing is asserted
that you cannot re-derive:

```bash
python3 tools/provenance.py                    # the timeline below
python3 tools/provenance.py --diff <A> <B>     # semantic diff of two revisions
python3 tools/provenance.py --csv out.csv      # metrics per revision
```

`--diff` reports structural change instead of XML noise, e.g.

```
=== f823426 -> bd794b0 ===
    +circuit ALU_arithmetic_engine
    -circuit ALU_airthmetic_engine
    block_transfer_control (+3 comps, +20 wires)
    main (+6 comps, +22 wires)

    block_transfer_control       AND Gate               +1
    block_transfer_control       OR Gate                +1
    main                         Multiplexer            +2
    main                         OR Gate                +2
```

## Construction timeline

Each row is one commit that modified the circuit.

```
date        commit     circ  comps  wires  what changed
------------------------------------------------------------------------------------------------------------
2026-06-28  05674909      6    264   1578  initial import
2026-06-28  ffa4b136      7    271   1585  +circuit ks_32_sub; ks_32b (+1 comps, +5 wires); main (-4 comps, -41 w
2026-07-05  357fc09e     11    333   1789  +circuit ALU; +circuit ALU_airthmetic_engine; +circuit ALU_logic_engin
2026-07-08  1c23bdfb     14    519   2063  +circuit csa_3to_2; +circuit csa_reduction_chain; +circuit pp_row … +2
2026-07-09  4aa79644     16    592   2557  +circuit pc_fetch; +circuit reg16x32
2026-07-09  87c8cdae     19    699   2882  +circuit PE_cell; +circuit matmul4x4; +circuit pp_row_32 … +2 more
2026-07-09  9e894419     23    769   2981  +circuit csa_16; +circuit mul_32; +circuit mul_8 … +4 more
2026-07-14  76d14f15     23    798   3028  main (+29 comps, +47 wires)
2026-08-04  e9f429c1     30    945   3581  +circuit barrel_32b; +circuit bs_stage_1; +circuit bs_stage_16 … +11 m
2026-08-04  3a291291     30    982   3740  main (+37 comps, +159 wires)
2026-08-05  362f3e0f     30    990   3763  main (+8 comps, +23 wires)
2026-08-05  ae6e944d     30    996   3777  main (+6 comps, +14 wires)
2026-08-06  dc538afa     30   1001   3783  main (+5 comps, +6 wires)
2026-08-10  fc592da2     31   1073   4315  +circuit reg16x32_2
2026-08-13  d32765df     31   1101   4491  +circuit reg16x32_1; -circuit reg16x32_2; main (+4 comps, +28 wires)
2026-08-14  e2ca2fda     32   1187   4763  +circuit block_transfer_control; main (+31 comps, +124 wires); pc_fetc
2026-08-14  6b6814e5     32   1195   4802  block_transfer_control (+7 comps, +39 wires); main (+1 comps)
2026-08-14  73a6174e     32   1197   4810  main (+2 comps, +8 wires)
2026-08-17  593a2cba     32   1197   4808  main (-2 wires)
2026-08-17  ef985e6d     32   1218   4884  block_transfer_control (+21 comps, +76 wires)
2026-08-19  ff094345     32   1230   4985  block_transfer_control (+9 comps, +57 wires); main (+3 comps, +44 wire
2026-08-20  f8234263     32   1235   5002  ALU (-4 wires); block_transfer_control (+2 comps); main (+3 comps, +21
2026-08-20  852bfe14     33   1257   5034  +circuit ALU_arithmetic_engine; +circuit ALU_arithmetic_engine_1; -cir
2026-08-20  bd794b0b     33   1261   5065  block_transfer_control (+2 comps, +20 wires); main (+2 comps, +11 wire
------------------------------------------------------------------------------------------------------------
24 revisions of armv4t.circ from 2026-06-28 to 2026-08-20
grew from 264 to 1261 components (+997), 1578 to 5065 wires (+3487), 6 to 33 subcircuits
```

## What the record shows

The design was built incrementally over roughly eight weeks, growing from 264
components in 6 subcircuits to 1,261 components in 33. The order of
construction is visible and follows a coherent engineering sequence:

| when | what appeared |
|---|---|
| 2026-06-28 | Kogge-Stone adder hierarchy (`ks_32b`, `pg_cell`, `kogge_stone_*`) |
| 2026-07-05 | `ALU`, arithmetic and logic engines |
| 2026-07-08 | multiplier partial-product and CSA reduction tree |
| 2026-07-09 | `pc_fetch`, `reg16x32`, and the systolic `PE_cell` / `matmul4x4` |
| 2026-08-04 | staged barrel shifter (`bs_stage_1` … `bs_stage_16`) |
| 2026-08-10 → 08-13 | register file rebuilt for dual writes (`reg16x32_2` → `reg16x32_1`) |
| 2026-08-14 | `block_transfer_control` |
| 2026-08-20 | `ALU_arithmetic_engine` replaces the hand-built Kogge-Stone adder |

Two properties of this record are difficult to fabricate after the fact.

**The design carries its own scar tissue.** A misspelled `ALU_airthmetic_engine`
survived from July until 2026-08-20. An orphaned splitter in `main` drives
nothing. A superseded `reg16x32` sits beside the live `reg16x32_1`, and
`ALU_arithmetic_engine_1` is a duplicate left from an edit. `mul_32` is still
instantiated inside `a_invert` and `PE_cell` where it is unused. These are the
residue of a thing that grew, not of a thing that was transcribed.

**The commit log records failures, not just features.** `PROJECT_LOG.md`
documents the diagnostic path for each: a combinational cycle in `mul_32`'s CSA
reduction tree localised to partial products `p2`–`p6`; a block-transfer address
that advanced twice per register; an exported netlist that synthesised to nine
cells because one clock-tree bit was tied constant. Working designs are easy to
copy; the archaeology of how they broke is not.

## Verifying independently

- **Run it.** Load `armv4t.circ` in Logisim Evolution and execute any ROM in
  `cpu/`. The gate-level circuit is the artifact.
- **Test it.** The regression suites are reproducible and documented in
  `cpu/README.md` and `PROJECT_LOG.md`.
- **Walk any revision.** `git show <rev>:armv4t.circ` opens in Logisim, so every
  historical version is executable, not merely readable.
- **Ask about the failure modes.** Why the `WD2` mux select had to be `done`
  rather than `active`; why dropping the `OR terminal` term breaks PUSH rather
  than POP; why PUSH was immune to the register clobber that affected POP. The
  answers are specific and are recorded in `PROJECT_LOG.md`.

## What the automated checks find

`tools/vestigial.py` scans the circuit for structure left behind by earlier
attempts. Full output in `docs/vestigial_report.txt`; the reliable findings:

**Circuits defined but never instantiated** — `ALU_arithmetic_engine_1`,
`a_invert`, `kogge_stone_2b`, `ks_4b`, `matmul4x4`, `mul_8`, `reg16x32`.

**Splitters whose bus end drives nothing** — seven, including the one in `main`
at `(2650,4090)` that blocks HDL export entirely.

**A superseded circuit left beside its replacement** — `reg16x32` next to
`reg16x32_1` (the dual-write rebuild), and `ALU_arithmetic_engine` next to
`ALU_arithmetic_engine_1`.

The tool separates reliable checks from a geometry-based heuristic that is known
to produce false positives, and says so in its own output. That distinction
matters: it flagged `bs_stage_16` as unwired, which prompted a test of shift
amounts above 4 for the first time. All six passed — the shifter is correct and
the finding was spurious. The check is retained as a source of leads, clearly
labelled, rather than removed or dressed up as fact.

## On hand-wiring and tooling

All circuit design and wiring was performed by the author, by hand, in Logisim
Evolution. Every architectural decision, subcircuit boundary, and gate placement
in `armv4t.circ` is the author's.

AI assistance was used for verification tooling, test-harness construction, and
debugging analysis. The harnesses in this repository operate on temporary copies
and assert that `armv4t.circ` is byte-identical after every run.

One point of precision, since the imprecise version is checkable in a single
command: circuit commits are **not** cleanly separated from tooling commits.
Several touch `armv4t.circ` alongside scripts, ROMs and documentation —
`ff09434` includes `tools/circuit_model.py`, `593a2cb` includes
`tools/circuit_graph.py`, and `e2ca2fd` touches sixty files. Five of the
twenty-four circuit commits carry `Co-Authored-By` trailers, reflecting AI
assistance with the documentation and tooling in those commits.

Going forward, circuit edits are committed separately from tooling, so the
distinction is visible in the log rather than merely stated here.

## Verification of authorship by signature

Commits from 2026-08-20 onward are signed with the author's SSH key
(`gpg.format = ssh`). Verify with:

```bash
git log --show-signature -5
```

Commits before that date are unsigned; the signing was adopted partway through
and is not retroactive.

## Tooling disclosure

The circuit is hand-designed and hand-wired. AI assistance (Claude) was used for
verification tooling, test-harness construction, and debugging analysis, and is
disclosed in commit trailers as `Co-Authored-By`. Commits that modify
`armv4t.circ` reflect wiring performed by the author in Logisim; the automated
test harnesses in this repository operate on temporary copies and assert that
`armv4t.circ` is byte-identical after every run.
