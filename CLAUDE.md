# CustomCPU — orientation for anyone (or any model) picking this up

A gate-level ARMv4T-subset CPU, hand-wired in Logisim Evolution by Junaet
Mahbub. It runs real `arm-none-eabi-as` output today. This file is the
on-ramp: what we're doing, the one rule you must not break, and the shape the
circuit is being rebuilt into.

---

## 1. The rule

**`armv4t.circ` is read-only. Never write to it.**

Read it for reference all you like. Do not patch it, do not run a script that
opens it for writing, do not "just fix one wire." The same now applies to
`armv4t_2.circ` — the user is hand-wiring that one and owns every wire in it.

Your writable file is `debug_armv4t.circ`.

This isn't bureaucracy. The user wires this CPU by hand on purpose; that is the
point of the project, and an agent silently editing the master destroys both
the provenance and the learning.

---

## 2. The goal, in two parts

**Near-term:** get the ARMv4T subset actually working — all 75 Grind-75-style
programs execute correctly. Current measured state is roughly 35 PASS / 9 WRONG
on the ISA suite (see §7).

**The reason for the current detour:** the CPU works well enough to be worth
finishing, but `main` had grown to 226 components and 882 wires on one
canvas in the master (416 and 1079 in the debug copy), with 27 nets spanning
more than 300 grid squares. It was unreadable — for the
user, and for every agent that tried to reason about it. So before adding
anything else, the whole design is being **reorganized into a recursive block
hierarchy**. Legibility first, then features.

The user is explicit that the second goal is about *understanding*, not just
tidiness. Guidance and explanation are part of the deliverable, not overhead.

---

## 3. The organizing principle: recursion all the way down

This is the heart of the current work. **Every level of the design is blocks
made of blocks.** No level shows both abstractions and loose gates.

The ALU already demonstrates it, and it's the model to copy:

```
pg_cell ──┐
          ├──► kogge_stone_1b ──► ks_4b / ks_32b ──┐
          │                                        ├──► ALU
pp_row_32 ──► partial_products ──► mul_32 ─────────┤
csa_3to_2 ────────────────────────┘                │
ALU_logic_engine ──────────────────────────────────┘

bs_stage_1 / _2 / _4 / _8 / _16 ──► barrel_32b
```

Look at `ALU` in `armv4t_2.circ`: 32 components, and four of them are whole
subcircuits. You can read it in ten seconds. That is the target for every
block.

**The CPU gets the same treatment.** `main` becomes five pipeline-stage blocks
and nothing else:

```
main
├── stage_IF   instruction fetch      ✅ built and verified
├── stage_ID   decode + register read  ✅ built and verified
├── stage_EX   execute                 ← next
├── stage_MEM  memory access
└── stage_WB   writeback
```

Three decisions the user made explicitly — honour them:

- **Strict top level.** `main` contains stage instances, the Clock, the reset
  pin, and output pins. **Zero logic gates.** If you find yourself wanting a
  gate in `main`, it belongs inside a stage.
- **Grouped by pipeline stage**, not by function. The stage boundaries are
  where the pipeline registers will go later, so this decomposition pays off
  twice.
- **Left-to-right dataflow** layout: IF on the left, WB on the right.

The stage boundaries are being drawn now even though the CPU is still
single-cycle. That's deliberate — it makes pipelining a later refactor of one
file instead of a rewrite.

### `stage_IF` is the worked example

It's built, hand-wired by the user, and verified: 25/25 connections, no
undriven inputs, no shorts, no dead parts, 100% endpoint coverage. Its
interface is the template for the rest:

```
in:  clk, rst, hold_pc, branch_taken, bx_taken, wb_writes_pc, bt_done,
     bx_target[32], branch_offset[32], wb_data[32]
out: instruction[32], pc_word_addr[10], pc_plus4[32]
```

Note what it does *not* take: the `Rd==15 AND WE` logic that produces
`wb_writes_pc` was deliberately assigned to **WB**, not IF. That kept IF at 10
inputs instead of 12. When you build WB, put it there.

---

## 4. File map

| file | what it is |
|---|---|
| `armv4t.circ` | **read-only master.** The hand-wired CPU. Reference only. |
| `armv4t_2.circ` | the reorganization, hand-built by the user. **Don't write.** |
| `debug_armv4t.circ` | your working file. Has the four fixes below; tests default here. |
| `ALU_modular_design.circ` | the ALU's own development file |
| `sandbox.circ`, `armv4t_ANNOTATED.circ` | scratch / annotated snapshots |
| `backups/` | timestamped snapshots — make one before any structural edit |

`debug_armv4t.circ` carries four fixes not yet in the master, all of which must
survive into the reorganized design:

1. **PC as a general operand** — `pc_zext32 → pc_byte_addr → pc_plus8`, feeding
   both register read ports through muxes gated by `rn_is_r15` / `rm_is_r15`.
2. **A real memory map** — ROM `0x0000-0x0FFF` (1024 words), RAM based at
   `0x1000`. Loads decode on `addr[12]`. They used to overlap at zero, which
   made address decode impossible.
3. **Literal pools** — a second ROM read port so `ldr rD,=const` works. Both
   ROMs must hold the identical image.
4. **ADC carry-in** — `ALU.Cflag` was tied to a constant `0`. Now driven from
   the CPSR C flag.

---

## 5. The Python toolkit — use it, don't eyeball XML

`logisim/` is a real backend for `.circ` files: it reconstructs where every pin
physically sits, derives the netlist, lints, renders, and routes wires without
shorting anything.

```bash
python -m logisim ls       armv4t.circ                 # every circuit + size
python -m logisim show     armv4t.circ pc_fetch        # ports and part counts
python -m logisim nets     armv4t.circ main            # nets, largest first
python -m logisim net      armv4t.circ main 1040,1530  # what is on this net
python -m logisim graph    armv4t.circ main --node ALU # connectivity graph
python -m logisim diff     a.circ b.circ main --wiring # what changed, as steps
python -m logisim validate armv4t.circ                 # lint the whole design
python -m logisim viewer   armv4t.circ -o circuits.html
python -m unittest discover -s tests -p test_logisim.py # 18 tests, keep them green
```

`logisim/README.md` explains why this is not a thin XML wrapper. Read it before
touching `geometry.py`.

**Connectivity is deterministic.** Everything needed to derive it is in the
file. Never guess at a connection or infer one from a label — derive it. The
user has called this out directly.

---

## 6. Traps that have each cost real time

- **Crossing ≠ connection.** Wires join where an *endpoint* touches another
  wire's endpoint or lands mid-span. A plain crossing is not a join — *but a
  pin or probe placed on a crossing joins it*, which is how 13 nets once got
  silently shorted by "inert" debug probes.
- **Subcircuit ports are positional**, sorted by `(y, x)`. Adding a pin above
  existing pins silently shifts every downstream port on every instance. When
  you must add one, place it *below* the existing pins.
- **Splitter `bitK` attributes are the inverse map.** `bitK` = which fan bus
  bit K routes to, *not* which bit fan K carries. One fan may carry several
  bits. `"none"` means routed nowhere.
- **Splitter fan order** is a screen convention, not derivable from `appear`:
  facing east/west, fan 0 is topmost, indices run down; facing north/south,
  fan 0 is rightmost, indices run left. Measured against live Logisim for all
  eight combinations.
- **Splitters are the exception in `geometry`.** `_splitter_ports()` already
  bakes in facing; running them through `Port.at()` rotates twice.
- **`route.route()` bounds are `(x0, x1, y0, y1)`** — not `(xmin,ymin,xmax,ymax)`.
- **Logisim Evolution has no cursor coordinate readout.** No ruler, no status
  bar position. Verified by inspecting the jar. Don't tell the user to "check
  the coordinates" — give names, or give a landmark.
- **Clear `__pycache__` after editing `logisim/`.** A stale `geometry.pyc` once
  produced a confident, entirely false "the ALU control bus is dangling."
- **A splitter's absent `bitK` is `min(K, fanout-1)`** -- the identity map
  saturating at the last fan. It is NOT fan 0, and it is NOT Logisim's even
  distribution. The design's own `<tool name="Splitter">` default block
  disagrees and is wrong; ignore it. Measured against Logisim 3.8.0, and
  confirmed by `Sim.width_conflicts()` reporting 0 conflicts design-wide.
- **Port POSITIONS being verified proves nothing about port ORDER.** Endpoint
  coverage counts points, not indices. `_decoder_ports` had its 16 outputs
  reversed behind a docstring saying they were "verified"; the register file
  wrote register `15-n` when asked for `n`. Any array of ports needs a
  behavioural test that only its first or last element can pass.
- **Subcircuit instance ports bind by position, never by label.** Some pins have
  no label at all -- `condition_checker`'s only output is unnamed.
- **ROM/RAM images live in the XML element's TEXT, not a `val` attribute.**

---

## 7. Testing

```bash
python3 tests/push_suite.py [circuit.circ]      # 10/10 expected
python3 tests/pop_suite.py                      #  7/7
python3 tests/stack_stress.py                   #  8/8
python3 tests/isa_coverage.py                   # ~35 PASS / 9 WRONG
python3 tests/adversarial_regression.py         # 43/54
```

All suites run headless via `xvfb-run` + the Logisim jar, assemble real ARM
with `arm-none-eabi-as`, patch every 32-bit ROM in the file, run to a halt pin,
and dump RAM. They search the **whole file** for ROMs, not just `main` — which
matters now that the instruction ROM lives inside `stage_IF`.

A suite that passes doesn't always prove what you think. Two examples worth
internalizing: SBC and RSC passed for months only because their tests forced
C=0 — exactly the value of the stuck constant that was breaking them. And a
test that can pass with the feature removed is not a test. Build
discriminators: a single input that uniquely exposes the bug.

---

## 8. Known-broken, in rough priority order

1. **Decoder never tests instruction bits 7 and 4.** Whole-class decode is two
   comparisons: `instr[27:4]==0x12FFF1` (BX) and `instr[27:25]==0b100` (block
   transfer). This single gap causes 8 of the 9 ISA failures — MUL/MLA/SWP and
   the halfword transfers all live in the `cond 000` space that bits 7 and 4
   split. **Highest leverage fix in the project.**
2. **The multiplier is connected at neither end.** `mul_32` is instantiated but
   `A`/`B` float, its product bus goes nowhere, and the engine mux inputs 2/3
   are unconnected. Internally the CSA chain has two breaks, so partial
   products p29 and p31 are never summed. Three separate fixes plus decoder
   support.
3. **MSR/MRS unimplemented.** CPSR is a 4-bit NZCV register with no datapath
   port in either direction.
4. **`ks_32b` is not in the CPU's add path** — it's only the multiplier's final
   adder. The live arithmetic engine uses a plain Logisim `Adder`.
5. **12 dead circuits** unreachable from `main` (295 components):
   `ALU_arithmetic_engine_1`, `reg16x32`, `a_invert`, `kogge_stone_2b`,
   `ks_4b`, `csa_16`, `mul_8`, `pp_8`, `pp_row_16`, `PE_cell`, `systolic_4x4`,
   `matmul4x4`. Delete during the reorganization.
6. **`block_transfer_control` in `armv4t_2.circ` is the old version** — needs
   pins `U` @(280,2600) and `P` @(280,2700) plus a NOT @(600,2700). Those y
   values are load-bearing: they place the new pins *last* in port order so no
   existing instance port shifts.

Deeper detail: `HANDOFF.md` (session log, root-cause analysis) and
`ARM_STATE_AUDIT.md` (empirical ARM-compliance audit).

---

## 9. How to work with this user

- **The user wires by hand.** Your job is usually to *specify and verify*, not
  to build. When told "stop doing work, guide me," that is literal.
- **Mechanism first, then diagram, then brief prose.** Explain how a thing
  works before what to do about it.
- **Be adversarial about your own results.** The user would rather hear "this
  test can't fail" than get a green checkmark. Report failures with output.
- **Derive, never guess.** If you catch yourself inferring a connection from a
  name, stop and read the file.
- **A good stage spec** — the format that worked for IF — is: which subcircuits
  to copy from `armv4t.circ`, the port list with widths, the component list
  with attributes, and the connections listed **by name**, not coordinate.

Longer-lived context lives in the user's memory directory, indexed at
`~/.claude/projects/-home-junaet-Documents-CustomCPU/memory/MEMORY.md`.

---

## 10. Handoff — 2026-08-26, `stage_ID` complete

The user hand-built `stage_ID` in `armv4t_2.circ`. Codex only inspected the
file and supplied wiring instructions; it did not write either protected
circuit. All four groups from `specs/stage_ID.md` are now electrically
complete:

- **A — instruction fields:** five splitters extract Rm, Rd, Rn, S, opcode,
  condition, class, immediate, Rs, shift type/amount, register-shift bit and
  `instr[27:4]`.
- **B — register indices:** `WA = sbwe ? Rn : (bl_taken ? R14 : Rd)` and
  `RB = data_ram_we ? Rd : Rm`; every primary and secondary register-file
  write port is connected.
- **C — R15 reads:** `pc_plus8 = (zext(pc_word_addr) << 2) + 8`; both register
  read ports substitute PC+8 when their *selected* address is R15. A real bug
  was caught and fixed by hand: the B-port comparator initially examined Rm
  directly; it now examines `M_RB.out`, so `STR r15,[...]` is handled.
- **D — control ROM:** opcode is zero-extended through a 16-bit combining
  splitter and addresses the 16×10 ALU-control ROM. The 17 words match
  `specs/stage_ID.md`; `alu_ctrl` is driven.

Deterministic semantic checker added:

```bash
python3 tools/check_stage_id.py armv4t_2.circ --through D
```

Current measured result:

```text
PASS  Group A  (37 deterministic checks)
PASS  Group B  (24 deterministic checks)
PASS  Group C  (27 deterministic checks)
PASS  Group D  (9 deterministic checks)
RESULT: PASS
```

The generic structural check is also clean:

```bash
python3 tests/check_stage.py armv4t_2.circ stage_ID
```

No floating inputs, undriven nets, multiple drivers, dead components or
unmatched wire endpoints were reported. The underlying `logisim` suite remains
18/18.

`tools/check_stage_id.py` is deliberately **location-independent**. It derives
roles from electrical behavior (for example, “the mux whose output drives
`rd_a`”) and checks actual shared nets, splitter inverse bit maps, widths,
constants and ROM contents. Moving parts or rerouting equivalent wires does
not invalidate it. `--json` emits machine-readable results.

The user's priority is electrical correctness over matching the spec's visual
layout. In particular, the Group-D address splitter uses Appearance Right
rather than Left; its fan mapping and nets are equivalent and therefore pass.
The stage's interface pins are also organized differently from the suggested
vertical order. Do not treat that as a defect: derive the real instance ports
when wiring `main`.

Progress is now two of five stage blocks: IF and ID are complete. This is
roughly 35–40% of the hierarchy refactor, but `main` is still empty, so the new
file has no end-to-end execution yet. Next work is to derive and hand-wire
`stage_EX` (barrel shifter, ALU, carry/NZCV, condition checker and branch/BX/BL
execution), following the same cycle: write a named electrical spec, guide the
user, and extend the semantic checker after each group.

---

## 11. Protections — enforced, not just requested

Section 1's rule is machine-enforced. Install or update with
`./install_protections.sh`; it tests the candidate guard against 32 cases
before installing anything and refuses to install one that fails.

| layer | file | covers |
|---|---|---|
| permission deny list | `.claude/settings.json` | `Edit` / `Write` on the protected paths |
| PreToolUse hook | `.claude/hooks/protect_files.py` | the same files via **Bash** — `sed -i`, redirects, `tee`, `cp`, `mv`, `rm`, `git checkout`, `open(...,'w')` |
| PostToolUse hook | `.claude/hooks/audit_log.py` | records what actually changed, after every tool call |
| ledger | `.audit/ledger.jsonl` | HMAC hash chain, sealed with a key outside the repo |
| regression test | `tests/test_protect_hook.py` | 15 cases that must block, 17 that must not |

**What is protected:** `armv4t.circ` and `armv4t_2.circ` — the two hand-wired
masters — plus the monitor's own files (the guard, the ledger, `audit.py`,
`settings.json`). An agent that can rewrite the monitor is not being monitored.
`CLAUDE.md`, `debug_armv4t.circ` and `sandbox.circ` are **not** protected; those
are the agent's to edit.

**Reads stay allowed, deliberately.** `cat`, `grep`, `python3 -m logisim show`,
and `open(path).read()` on the masters all work. Every stage is checked against
`armv4t.circ`, so blocking reads would break the work the guard exists to
protect.

The deny list alone is not enough: an agent working through Bash never touches
`Edit` or `Write`, so a one-line `sed -i` walks straight past it. The hook is
what closes that path. It exits 2, which returns the refusal to the model.

### The ALLOW half of the test suite is the important half

Three false positives were caught only by cases asserting the guard stays out
of the way, and every one of them was silent:

- filenames matched as substrings, and `debug_armv4t.circ` *ends with*
  `armv4t.circ` — the guard locked agents out of the working circuit;
- `open\([^)]*['"][wax]` matched the opening quote of `open('armv4t.circ')`
  followed by the `a` of armv4t, so every plain read looked like a write;
- a bare `>` in the write pattern matched the `2>&1` in a read piped to `head`,
  and a variable named `dd` matched the `dd` command.

All three came from asking *"does this command contain a write pattern
anywhere?"* The right question is *"is the protected name itself in a write
position?"* — which is why `cp armv4t.circ /tmp/ref` (reading it) is allowed
and `cp sandbox.circ armv4t.circ` (overwriting it) is not.

Run `python3 tests/test_protect_hook.py` after any change to `PROTECTED`.

### The ledger

Content-addressed, not intent-addressed: after every tool call the watched
files are hashed and compared to the last recorded state. Nothing parses a
command to guess what it meant to do, so `Edit`, a heredoc, `sed -i`, a Python
script and Logisim's own save are all recorded identically.

```bash
python3 tools/audit.py verify   # chain intact? anything changed since you approved?
python3 tools/audit.py log      # recent history
python3 tools/audit.py accept   # "that change was me"
```

`verify` calls out unapproved changes to the two masters specifically. Logisim's
own saves are logged too, so run `accept` after a wiring session to checkpoint.

Every entry is HMAC-chained to the one before it, so one altered line breaks
every signature after it. Re-sealing needs the key at
`~/.config/customcpu/audit.key` (mode 600), which the guard blocks agents from
reading at all. That makes it tamper-**evident**, not tamper-proof: anything
running as Junaet could reach the key if it set out to. The guarantee is
narrower and still worth having — nothing can quietly alter the record.

To undo everything: `rm .claude/settings.json` disables both hooks;
`rm -rf .audit ~/.config/customcpu` removes the ledger.
