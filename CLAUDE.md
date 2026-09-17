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

## 6b. The harness must read the circuit, never a copy of it

`tools/pysim.py` used to rebuild the top level from a hand-typed `WIRING`
table. The table went stale silently and the failures it produced looked
exactly like CPU bugs:

| net the user wired | what the stale harness did |
|---|---|
| `MEM.bt_active -> WB.bt_active` | ran every block transfer with the write suppress **disconnected** — 15 corrupted registers per LDM/STM |
| `ID.reg_shift -> EX.reg_shift` | variable shifts untested |
| `ID.rs_value -> EX.rs_value` | same |

`main` now exists, so `cpu()` elaborates it out of the file — stage instances,
tunnels and all. Rewiring in Logisim changes what runs, immediately, with
nothing to edit. `s.top_from_main` says which path was taken.

The same failure mode in the other direction: `smoke_suite.py` attached
`KNOWN_GAPS["shift_reg"]` **unconditionally**, so it kept reporting
"register-specified shift amount is not decoded" for weeks after the register
shifts were wired and working. A note in `KNOWN_GAPS` now only prints on a case
that actually fails.

```bash
python3 tools/check_harness.py     # is the harness testing the real file?
python3 tools/main_suite.py        # discriminators through the real `main`
```

`check_harness.py` fails if `main` is wired and something still used the table,
and lists any drift between the two. Run it before believing a failure.

**A harness that keeps its own copy of the netlist cannot know its copy is
wrong.** Derive the top level; never declare it.

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

---

## 12. Handoff — 2026-08-31, fix 1 and fix 2 landed in the reorganization master

The user hand-wired both fixes from `docs/CPU_DEFECTS.md`'s priority list
directly into the reorganization master (`armv4t` + `_2.circ`). Codex only
inspected the file, derived what changed structurally, and ran the test
suites — it did not write the protected circuit.

### Fix 1 — block-transfer write suppress (`stage_WB`)

Per `specs/fix_1_block_suppress.md`. A new `class_bits` input (width 3, placed
below `bt_active` so no existing port shifted) feeds a Comparator against
`Constant 0x4`; the result became the 7th input on what was a 6-input OR
gate producing `suppress`. `main` carries the new pin over the existing
`CLASS` tunnel — no new net was needed, just a third destination for one that
already existed.

**Verified:** `check_stage.py stage_WB` clean. `deep_matrix` block group
4/7 -> **7/7** (both "does not clobber Rd-field reg" cases now pass — instr[15:12]
no longer strays into a live register on STM/LDM). `main_suite` 12/15 -> 13/15.

### Fix 2 — logical ops must not write C/V (`stage_EX`)

Per `specs/fix_2_logical_flags.md`. Two 1-bit, select-2 Multiplexers were
inserted into the CPSR flag path, gated by `ALU.engine_sel` (probe `S_eng`):

```
MUX_C:  in0/in2/in3 = CUR_C (CPSR_reg.Q's C, same net as ALU.Cflag/condition_checker.C)
        in1         = ALU.C
        sel         = S_eng
        out         -> CPSR-write splitter's C fan (was ALU.C directly)

MUX_V:  in0/in2/in3 = CUR_V (CPSR_reg.Q's V, off the read splitter)
        in1         = ALU.V
        sel         = S_eng
        out         -> CPSR-write splitter's V fan (was ALU.V directly)
        condition_checker.V rewired from a direct splitter tap onto CUR_V's
        own net -- now symmetric with condition_checker.C
```

Both engine_sel=0 (logical) and engine_sel=1 (arithmetic) paths were measured
directly off the file, not inferred from labels: `and eor tst teq orr mov bic
mvn` all decode to `S_eng=0`, `sub rsb add adc sbc rsc cmp cmn` to `S_eng=1`.
N and Z were left untouched — both engines compute them correctly already.

**One wiring pass needed a second look.** The first save put `MUX_V.out` only
onto `condition_checker.V`, leaving the CPSR-write splitter's V fan still
wired straight to `ALU.V` — the write path (the actual point of the fix) was
still unfixed even though the read path looked right. A discriminator caught
it: `adds` an overflow, then `ands`, then `movvs` — flips to `0` only when V
survived the `ands`. The user re-wired it in the same session; the corrected
version routes `MUX_V.out` to the write splitter and `condition_checker.V` to
the *read*-splitter's own V fan (CUR_V), matching the pattern already
established for C. Re-traced from the file after the fix — confirmed correct
both electrically and behaviourally.

**Verified:** `check_stage.py stage_EX` clean (105 comps, 293 wires, 0
floating/multi-drive/width-mismatch). Discriminators:

```
C preserved across ands (after cmp sets C)                       -> PASS
C still updates on arithmetic (subs producing a borrow)          -> PASS
V still updates on arithmetic (0x7FFFFFFF + 1, true 32-bit ovf)   -> PASS
V preserved across ands (after that same overflow)                -> PASS
```

`deep_matrix` flags-logical **5/19 -> 19/19**; flags-adds/subs/cmp/cmn held at
196/196 (no regression in the paths the fix didn't touch). `main_suite`
holds 13/15 -- neither remaining failure (`byte_access`, `imm_bit4_not_a_shift`)
touches the flag path. `regression_py` holds 48/54, identical failing set
(MUL/MLA/SWP decode-only, register-offset addressing, halfword/signed loads)
-- fix 2 changed nothing outside its own scope.

### State after both fixes

```
deep_matrix   233/244   (block 7/7, control 7/7, flags-* all 196/196+19/19,
                          memory 4/15 unchanged -- fix 3's target)
main_suite     13/15    (byte lanes, imm-bit-4-not-a-shift remain)
regression_py  48/54    (MUL/MLA/SWP, register-offset addressing, halfword/signed)
check_stage    stage_WB and stage_EX both clean
```

The reorganization master is now ahead of the debug copy on block transfer
*and* flags, but still behind it on the `imm_bit4_not_a_shift` gap — the
debug copy's `IMM_BIT_REGSHIFT`/`SHIFT_TYPE_DECODE` family of nets
(`stage_ID` + `stage_EX`) has no equivalent here yet. Not ported or specced
against the master.

### Next

`specs/fix_3_register_offset.md` -- register offsets on LDR/STR
(`ldr r0,[r1,r3]` currently reads the shift:Rm bit pattern as a 12-bit
immediate). Larger than fixes 1/2: a third register read port in `stage_ID`
plus a 32-bit mux and a `barrel_32b` instance in `stage_MEM`. `main` needs one
new tunnel (`rm_value`); `stage_MEM` needs two new pins below `cond_pass`.

Also still open, in the order `docs/CPU_DEFECTS.md` gives: byte lanes and
halfword/signed loads, then the multiplier (decode is done, only EX/WB
integration remains).

---

## 13. Handoff — 2026-09-01, halfword transfer in progress; two false alarms and one real hazard found

Long session, hand-wiring `specs/fix_5_halfword.md` (STRH/LDRH/LDRSB/LDRSH)
into `armv4t_2.circ`. Fix 3 (register offsets) from the prior handoff is
confirmed landed and stable throughout everything below. Current verified
state, **on the real Logisim engine, not the Python model**:

```
python3 tests/adversarial_regression.py armv4t_2.circ
PASS=49  WRONG=5   (halfword, signed byte, MUL, MLA, SWP -- all pre-existing,
                     none of tonight's work broke anything else)
```

### A real bug in the verification tooling itself — read this before trusting `check_stage.py`

`logisim/geometry.py`'s `_mux_ports()` computes the wrong absolute position
for a 2-input Multiplexer's `sel` pin whenever the component is rotated to
face **north** (confirmed only for that facing; east-facing muxes, the
overwhelming majority in this design, are unaffected). This produced a
recurring, convincing-looking false positive: `check_stage.py` and every
render built on `netlist.build()` reported the fix-3 offset-select mux's
`sel` pin as permanently disconnected, across multiple independent-looking
checks (structural trace, a browser render with computed markers, even a
*second* browser render with no markers at all — all three shared the same
underlying geometry bug, so agreeing with each other proved nothing). The
circuit was correct the entire time; confirmed by running the real jar
directly. **`logisim/geometry.py` is not yet fixed.** Any future session
hitting a "disconnected sel pin" report on a north-facing 2-input mux should
distrust the static checker first and verify with
`tests/adversarial_regression.py` or `tests/push_suite.py` (both drive the
actual jar) before touching any wire.

**The standing rule going forward, agreed with the user tonight:** trust the
real Logisim engine over any Python model for anything behavioral. Use
`netlist.build()`/`check_stage.py` for structural sanity only, and re-verify
anything it flags as broken against the real jar before reporting it as a
defect.

### Two real, no-fault regressions found and fixed tonight — both are worth remembering

1. **`DATA_RAM`'s `trigger` attribute got silently removed** during
   experimentation with the write-hazard below, defaulting away from its
   documented, load-bearing `falling` setting (see §6, the "half-cycle
   memory" trap). With it missing, *nearly every* memory operation in the
   CPU broke — not just halfword ones. Restored to `trigger=falling`; full
   regression came back clean. **If RAM behavior ever looks broken CPU-wide,
   check this attribute first** — it's easy to lose track of during
   unrelated experiments and the failure mode (everything returns 0) doesn't
   obviously point at it.
2. **`bt_active` and `data_ram_we` were swapped** somewhere in the day's
   wiring — found by the user cross-checking with Codex, not by this session.
   Confirmed and fixed; restored ordinary memory operations that had gone to
   0/54 in that group. Worth a general lesson: two same-width, same-timing
   control signals sitting near each other are an easy accidental swap, and
   the failure mode (everything reads back 0) looks identical to the trigger
   bug above. Check both before assuming a deeper redesign is needed.

### The halfword/signed-transfer feature — real progress, one open architectural question

Per `specs/fix_5_halfword.md`, sections 1 and 2 are **built and verified
correct on the real engine**:

- **Decode (`is_hwxfer`)** — comparator-based, matching the style already
  established for MUL/MLA decode (`instr_7_4` against `0xB`/`0xD`/`0xF`, OR'd,
  AND'd with a `class_bits==0` check). Discriminator run: `and`, `mul`, `swp`
  (the adjacent false-positive risks, since they share the `SH=00` pattern)
  all correctly stay `0`; `ldrh`/`strh`/`ldrsb`/`ldrsh` all correctly read `1`.
- **Address offset** — the `immH:immL` / `Rm` offset mux, spliced in after
  (not inside) fix 3's existing offset-select mux, confirmed not to disturb
  any ordinary LDR/STR addressing mode.
- **Register-B select fix** — a real defect found mid-session, *not* originally
  in the spec: the mux choosing `Rd` vs `Rm` for the store-data register port
  had its `sel` wired straight to `data_ram_we`, which has never heard of this
  instruction class. `strh` was reading `Rm` (nonsensical for this encoding,
  resolves to `r0`) instead of `Rd`, silently storing `0` every time. Fixed
  with three new gates (`NOT(s_bit) AND is_hwxfer`, OR'd into `data_ram_we`)
  feeding that mux's `sel` — deliberately **local to that one mux**, not a
  change to the `data_ram_we` pin itself, because that pin fans out to the
  RAM write-enable and WB suppress logic, and broadening it there would wrongly
  suppress writeback on the three *load* variants this same decode covers.

**Section 3 (the write path) hit a real hardware hazard, not a wiring bug:**
reading `RAM.data_out` for the "old half" while `RAM.we` is asserted the same
cycle doesn't give reliable pre-write data with this RAM component — its
output reflects the in-flight write, so `MUX_HI`/`MUX_LO`'s "preserve the
untouched half" input sees garbage instead of the prior word. Confirmed on
the real engine (`strh` after a known word produces neither the correct
merge nor either of the two plausible wrong-but-explicable results — the
combinational network just settles to something self-consistent and wrong).
Changing the RAM's trigger edge does not fix this — it's not about *when*
the write commits, but about `data_out` following `data_in` combinationally
whenever `we=1`, independent of clock edge.

**Recommended fix, not yet attempted:** Logisim Evolution's `RAM` component
has a genuine hardware byte-enable mode — confirmed present in the jar
(`ATTR_ByteEnables`, UI label **"Use byte enables"**), which adds one
write-enable line per byte. Turning it on and driving those lines directly
from `is_hwxfer`/`ADDR_1`/`ADDR_0` would let the hardware do the partial-word
write and **eliminate the merge muxes, the combiner, and the whole hazard**
outright — no read-modify-write needed at all. This is a smaller change than
it sounds (delete `MUX_HI`, `MUX_LO`, the combiner, and `MUX_DATAIN`; wire
byte-enable pins instead) and is the recommended next step over a multi-cycle
read-modify-write state machine, which would also work but is considerably
more design effort for the same result.

**Section 4 (LDRH/LDRSB/LDRSH read path)** is fully specced
(`specs/fix_5_halfword.md` §5) but not started. It has none of the §3 hazard
— loads never assert `we`, so `RAM.data_out` is trustworthy throughout. Good
next place to spend time once §3 is resolved by whichever path is chosen.

### State right now

```
armv4t_2.circ          49/54 real-Logisim regression, 0 new breakage
debug_armv4t_2.circ     STALE -- last synced hours before tonight's halfword
                        work; does not reflect any of it. Re-sync with
                        `cat armv4t_2.circ > debug_armv4t_2.circ` before using
                        it for anything, or it will report false regressions.
specs/fix_5_halfword.md  §1 decode: done+verified. §2 address: done+verified.
                         §3 write: blocked on the RAM hazard above.
                         §4 read: specced, not started.
```
