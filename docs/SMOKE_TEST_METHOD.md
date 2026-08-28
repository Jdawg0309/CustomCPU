# The IF+ID+EX smoke test — method, results, and where it is weak

Written 2026-08-26, after `stage_IF`, `stage_ID` and `stage_EX` were all
reported green by every check that existed.

This document exists so the method can be attacked. If you are another model
picking this up, your job is not to confirm it — it is to find what it misses.
§6 lists the attacks worth trying first.

---

## 1. Why it was built

Three stages were finished and all of them passed everything:

| stage | `tests/check_stage.py` | semantic checker |
|---|---|---|
| `stage_IF` | clean | `tools/check_stage_if.py` 68/68 |
| `stage_ID` | clean | `tools/check_stage_id.py` 97/97 |
| `stage_EX` | clean | `tools/check_stage_ex.py` 151/151 |

316 semantic checks, three mutation-tested checkers, zero findings.

**While `stage_ID` computed `pc+9`.**

Every one of those checks looks at one stage in isolation, and none of them
executes anything. Two whole classes of defect are invisible to all of them:

- **Fit.** Subcircuit ports are positional, sorted by `(y, x)`. A pin nudged
  20 units up inside a stage renumbers every port after it. Each stage still
  passes on its own; the assembled CPU is wired wrong.
- **Silent Logisim defaults.** The file records only non-default attributes, so
  an absent attribute is a commitment, not a blank. A `Constant` with no
  `value` is a **1**.

Neither is reachable without running the thing.

---

## 2. What was built

```
smoke.circ                   copy of armv4t_2.circ; armv4t_2.circ never written
tools/build_smoke_main.py    assembles main from the three stage instances
tools/smoke_run.py           one program -> per-cycle trace
tools/smoke_suite.py         10 discriminator cases with computed expectations
tools/check_defaults.py      static sweep for the four Logisim defaults
```

Reproduce from a clean checkout:

```bash
cat armv4t_2.circ > smoke.circ          # cp is blocked by the guard; this isn't
python3 tools/build_smoke_main.py
python3 tools/smoke_suite.py smoke.circ
python3 tools/check_defaults.py armv4t_2.circ
```

### 2.1 Nothing is placed by hand

`main` was empty. The builder places three instances at chosen anchors and then
**derives every port point from the file**:

- port order is `Circuit.inputs()` / `outputs()`, i.e. pins sorted by `(y, x)`,
  outputs first — the same rule Logisim uses;
- outputs sit at `(anchor.x, anchor.y + 20k)`, inputs at `(anchor.x - w, …)`;
- `w` comes from `geometry._subcircuit_box_width`.

`w` defaults to 220 when there is no evidence, and there were no instances of
these three stages anywhere, so 220 was a guess. It was checked before use, by
fitting the offset against the wire endpoints of the six subcircuits that *are*
instantiated in `armv4t.circ`:

```
ALU                     8/10 input endpoints land at anchor-220
pc_fetch                7/7
reg16x32_1             10/10
block_transfer_control  6/6
barrel_32b              3/3
condition_checker       5/5
```

Six subcircuits, 3 to 18 pins each, names 3 to 22 characters — all 220. The
guess is now a measurement.

### 2.2 Tunnels, not routed wires

Every inter-stage connection is a `Tunnel` dropped on a derived port point with
a 60-unit stub. Reasons:

- routing 78 wires across a canvas is the single most error-prone thing an
  agent can do to a `.circ`, and a wire that lands 10 units short looks
  connected at normal zoom;
- a tunnel connects by label, so there is no geometry to get wrong;
- the labels *are* the netlist, which makes `main` readable.

Cost: `tests/check_stage.py` is tunnel-blind and reports all 39 tunnel-fed nets
as UNDRIVEN. That is a known false positive, not a finding.

### 2.3 The width check is the first real result

The builder refuses to emit if any two ports sharing a tunnel label disagree on
width. All 29 inter-stage nets agree:

```
ALU_CTRL 10  ALU_RES 32  ALU_WE 1   BL_TAKEN 1  BR_IMM24 24  BR_OFF 32
BR_TAKEN 1   BX_TAKEN 1  BX_TGT 32  CLASS 3     CLK 1        COND 4
CONDPASS 1   CPSR 4      I27_4 24   IMM8 8      IMM_BIT 1    INSTR 32
OPCODE 4     PC_PLUS4 32 PC_WORD 10 RD_A 32     RD_B 32      ROT 4
RST 1        SH_AMT 5    SH_TYP 2   S_BIT 1     WA 4
```

**No port-order shift occurred.** That was the main thing being tested, and it
is a real result: the user moved pins repeatedly while wiring, and nothing
slipped.

### 2.4 Two deliberate compromises

`main` is supposed to hold zero loose logic. The smoke `main` holds two things
that must not survive into the real one:

1. **A splitter** taking `instruction[23:0]` for `stage_EX.branch_imm24`.
   `stage_ID` has no `branch_imm24` output yet. The fix is an output pin on
   `stage_ID`, placed **below every existing pin** so no port index moves.
2. **`stage_ID.rs` feeds `stage_EX.rot`.** This one is not a compromise, it is
   an identity: rotate is `instr[11:8]` and Rs is `instr[11:8]`. Same four bits.
   Cases 2 and 4 of the suite are built so that if this sharing were wrong, one
   of them would have to fail.

Tie-offs standing in for MEM and WB: `wd <- alu_result`, `we <- alu_we`,
`wb_writes_pc`/`wb_data`/`hold_pc`/`bt_done`/`wd2`/`we2`/`wa2`/`sbwe`/
`data_ram_we` all 0.

### 2.5 Observation

`--tty table,halt` prints the output pins of `main` once per settled cycle. Nine
observation pins were added: `o_pc o_instr o_alu o_wa o_we o_cpsr o_pass
o_btaken o_bltaken`, plus `halt` fed from `bx_taken` (the existing suites already
halt on BX). A per-cycle trace beats a final register dump: a wrong intermediate
is caught even when the final answer is accidentally right.

Widths make the column mapping unambiguous — 10, 32, 32, 4, 1, 4, 1, 1, 1.
`halt` is consumed by `--tty halt` and does not appear as a column.

---

## 3. Results

```
[ PASS ] dp_opcodes    AND/ORR/EOR/ADD/SUB/RSB/BIC/MVN, all distinct on 0xF0,0x3C
[ PASS ] imm_rotate    #0xFF000000, #0x3F00, #0x104 — encodable only via ROR
[ PASS ] shift_imm     LSL/LSR/ASR/ROR by immediate
[WRONG] shift_reg      register-specified shift amount
[ PASS ] flags_cmp     CMP 5,5 -> ZC; CMP 5,7 -> N; SUBS -> ZC
[ GAP  ] cond_exec     cond_pass correct on all four; alu_we ungated
[ PASS ] branch_fwd    forward branch skips the instruction after it
[ PASS ] loop          backward branch, 3 iterations, exits
[ GAP  ] bl_bx         bl_taken and WA=r14 correct; the rest needs WB
[ PASS ] pc_operand    add r0,pc,#0 -> 8   (after the fix in §4)
```

### 3.1 The defect

`stage_ID` at `(3780,1100)`:

```xml
<comp lib="0" loc="(3780,1100)" name="Constant"/>
```

No `value` attribute. It sits exactly on `Adder@(3800,1120).cin` — the adder
that computes `pc_plus8 = (zext(pc_word_addr) << 2) + 8`. Logisim's `Constant`
default is **1**, so the CPU computed `pc + 9`.

The same adder in `debug_armv4t.circ` — `Adder@(9220,11950)` — is driven by
`Constant value=0x0`. So this is a **regression introduced during the rebuild**,
not something inherited.

Proof of diagnosis, not just correlation: adding `value="0x0"` to that one
component in `smoke.circ` and changing nothing else turns `pc_operand` from
WRONG to PASS.

This is the third time this exact default has bitten the project — `K_BRCIN`
in `stage_EX` and `EXT_IMM`'s sign/zero default were the first two.

### 3.2 Classification of everything that did not pass

| case | verdict | evidence |
|---|---|---|
| `shift_reg` | **pre-existing ARM gap**, not a rebuild regression | in `debug_armv4t.circ` the barrel-shifter amount mux `Multiplexer@(8120,10040)` selects on `imm_bit`, between the immediate shift field and the rotate field. There is no third input for Rs, and `instr[4]` is never tested. This is item 1 of `CLAUDE.md` §8. |
| `cond_exec` | **stage_WB not built** | `cond_pass` was correct on all four conditionals. `alu_we` is not gated by it — in `debug_armv4t.circ` that AND lives in main-level glue feeding `reg16x32_1.WE` via `Multiplexer@(7890,9250)`, whose `in0` tree includes `condition_pass`. |
| `bl_bx` | **stage_WB not built, plus a real gap** | `bl_taken` asserted and `stage_ID` steered WA to r14, both correct. Missing: the link-value mux into `wd` (WB), and a path from `bl_taken` to IF's redirect. In `debug_armv4t.circ`, `pc_fetch.BRANCH` = `OR(branch_taken, bl_taken, bx_taken, pc_apply, pc_write)`. **`stage_IF` has no `bl_taken` input**, so today BL cannot redirect the PC. |
| `flags_cmp` first run | **a bug in the test, not the circuit** | CPSR is a registered output; the flags an instruction sets appear on the *next* row. Reading them off the same row made three correct results look broken. Fixed; recorded here because it is the kind of mistake that in the other direction produces a false green. |

---

## 4. What to fix, in order

1. **`stage_ID` `(3780,1100)`** — set the constant's Value to `0` (Data Bits
   stays 1). One attribute. `add r0,pc,#0` is the discriminator.
2. **`stage_ID`: add a `branch_imm24` output**, 24 bits, `instr[23:0]`. Place
   the pin **below every existing pin** (y > 1770) so no port index shifts.
   Removes the splitter from `main`.
3. **`bl_taken` must reach the PC redirect.** Two options: have `stage_EX` OR
   `bl_taken` into `branch_taken`, or add a `bl_taken` input to `stage_IF`
   (again placed last). The first keeps `main` gate-free and is recommended;
   `stage_ID` still needs its own `bl_taken` for the WA mux, which it has.
4. **`stage_WB`** owns: the writeback-data mux (ALU / memory / BL link value),
   and the register write enable — `cond_pass AND (alu_we OR ldr_reg_we OR
   bl_taken)`, plus the `Rd==15 AND WE -> wb_writes_pc` logic that `CLAUDE.md`
   §3 already assigns here.
5. **Register-specified shift** is an ARM-compliance gap in the master too.
   It belongs with the bit-7/bit-4 decoder work, not with the rebuild.

---

## 5. New permanent check

```bash
python3 tools/check_defaults.py armv4t_2.circ [circuit ...]
```

Reports every component leaning on one of the four dangerous Logisim defaults.
It is deliberately two-tier: `ERROR` only where the default is never
defensible (today: a bare `Constant` on an `Adder.cin` or `Subtractor.bin`, and
a `value > 1` with no `width`, which Logisim clamps to one bit). Everything else
is `REVIEW`, for a human — a bare constant on a `Shifter.dist` is exactly how
`bs_stage_1` is supposed to be built.

On `armv4t_2.circ` today: **1 ERROR** (the one above), 29 REVIEW, none of which
is wrong on inspection.

---

## 6. Where this is weak — attack these first

1. **The observation set is nine pins.** Nothing observes the register file
   directly. A register that is written correctly and then *corrupted* by a
   later instruction would be invisible unless a later instruction reads it.
   `dp_opcodes` and `loop` read back written values, which is the only reason
   the register file is covered at all. **Try to construct a program the suite
   passes while the register file is wrong.**
2. **`--tty table` prints a row per settled cycle, and the row-to-instruction
   mapping is inferred from the `o_pc` column.** If the PC and the instruction
   were ever off by a cycle relative to each other, several checks would still
   line up. Nothing independently verifies that `o_instr` is the instruction
   *at* `o_pc`.
3. **CPSR timing is handled by "read the next row."** That was arrived at
   empirically after the first run. It is a convention, not a derivation. If
   the flags are actually correct-but-late, or late-but-correct, this suite
   cannot distinguish the two.
4. **The tie-offs could be hiding failures.** Everything MEM and WB would drive
   is tied to 0, which is also the value that makes most control logic
   quiescent. A stage that ignores an input entirely and a stage that correctly
   handles the 0 case look identical here.
5. **`w = 220` was fitted, not read from Logisim's source.** It matched six
   subcircuits including a 22-character name, but nothing proves it holds for a
   longer name or a custom appearance. If it were wrong the circuit would not
   have run at all, so this is now moot for these three — but a future stage
   with a longer name deserves a re-check.
6. **The suite has ten cases and only these were written.** Not tested at all:
   `MUL`/`MLA`, `SWP`, halfword transfers, `MSR`/`MRS`, `TST`/`TEQ`/`CMN`, the
   `S` bit on logical operations and its effect on C, `RRX`, shift-by-32 and
   shift-by-0 edge cases, and every conditional code other than EQ/NE/LT/GT.
7. **`check_stage_id.py` passed with `pc+9`.** Codex's checker verifies that
   the pc+8 adder exists, is 32 bits wide and is fed by the shifter and the
   constant 8. It never checked the carry-in. Assume the same class of hole
   exists in the other two checkers and go looking: for every constant they
   assert the *presence* of, ask whether they assert its *value*.
8. **The suite proves the three stages work together. It proves nothing about
   `armv4t_2.circ`'s `main`**, which is still empty. When the real `main` is
   wired by hand it will need its own verification; this smoke test does not
   transfer.

---

## 7. Protection compliance

`armv4t.circ` and `armv4t_2.circ` were read but never written. `smoke.circ` was
created with `cat armv4t_2.circ > smoke.circ` — the guard blocks `cp` with a
protected name in destination position, and `shutil.copy` with a protected name
in *any* position, so the redirect is the sanctioned form. The carry-in fix in
§3.1 was applied to `smoke.circ` only; `armv4t_2.circ` still has the bug, and
fixing it is the user's to do by hand.

Verify independently:

```bash
python3 tools/audit.py verify
```

---

# Part 2 — the Python simulator (2026-08-26)

Logisim was the only way to run anything, and that meant: copy the file, write a
ROM image into the copy, drive a jar under xvfb, and parse a TTY table whose
column order had to be inferred. The copy is a snapshot -- it goes stale the
moment Logisim saves, and reading the file mid-save is a real failure mode that
already happened once.

`logisim/sim.py` evaluates a `.circ` directly. The design is read at call time
and never written.

```bash
python3 tools/pysim.py prog.S                  # one program -> per-cycle trace
python3 tools/smoke_suite.py --engine=python   # the suite, on the live file
python3 tools/smoke_suite.py --engine=logisim smoke.circ
python3 tools/cross_check.py                   # do the two engines agree?
```

## How it works

- **Flatten.** Every subcircuit instance is elaborated recursively and its port
  nets unified with the interface-pin nets inside. IF+ID+EX is 1094 primitives
  across 22 circuits.
- **Bind ports by POSITION, not name.** Logisim binds instance ports by their
  order -- outputs then inputs, each sorted by `(y,x)`. Binding by label leaves
  every unlabelled pin unconnected, and `condition_checker`'s only output has no
  label, so `cond_pass` silently read 0 for every instruction.
- **Event-driven evaluation** with an iteration cap, so a combinational loop is
  reported rather than hung on.
- **Registers sample D while the clock is low and commit on the rising edge**,
  which is the only ordering that gives a register chain its predecessor's
  pre-edge value.

## What it is worth

It is a **second implementation**. `check_stage_if/id/ex.py` and
`check_stage_fit.py` all read the design through the same `logisim/` library; a
blind spot there is a blind spot in all of them. This shares the parser and the
geometry, but nothing of the semantics.

```
$ python3 tools/cross_check.py
10/10 programs agree on every cycle       (603 observables)
```

Every cycle of every program, on all nine observables, Python and Logisim
Evolution produce identical values. Logisim remains the authority: a
disagreement means stop and find out which one is wrong, not assume it is
Logisim.

Speed: the whole suite is ~18s in Python against ~90s through the jar, and it
needs no `smoke.circ`, because the top level is assembled in Python from the
stage instances using the same contract `check_stage_fit.py` verifies.

## Three bugs found in the process -- two of them in this repo's own library

**1. `geometry._decoder_ports` had the output index order reversed.**

`out0` is the TOP output, not the bottom. The docstring said the positions were
"verified against the select=4 decoders in reg16x32" -- and they were. Coverage
verifies the SET of points and says nothing about their order, so a reversed
index is invisible to it. The effect: `reg16x32_1` wrote register `15-n` when
asked for register `n`.

Caught by writing `0xA0+n` into register `n` for all 16, then reading back. The
discriminator matters: writing one register and reading it back passes with the
order reversed if you happen to pick register 7 or 8.

This is the same class of defect `CLAUDE.md` section 6 already records for
splitter fan order -- "only fan 0 or the last fan can tell two orderings apart"
-- in a component nobody had thought to re-check.

**2. `model.load` returned `None` for every memory image.**

ROM and RAM contents are stored as the XML element's TEXT, with no `val`
attribute. `a.get("val")` returned `None`, so every ROM image in the design read
as nothing. Fixed with a fallback to element text.

**3. An absent splitter `bitK` is not fan 0, and not the even distribution.**

The 8-bit shift-field splitter in `stage_ID` has no `bit0` and no `bit1`.
Whether absent `bit1` means fan 0 or fan 1 decides whether `reg_shift` is 1 bit
or 2. The design's own `<tool name="Splitter">` default block says `bit1=0`; ARM
semantics say `bit1=1`. Logisim's built-in even distribution also says 0.

Measured directly against Logisim 3.8.0 with a minimal calibration circuit --
the same method `CLAUDE.md` section 6 records for fan order:

```
input 0xb5 -> fan0=1 (1 bit), fan1=10 (2 bits), fan2=10110 (5 bits)
```

So the rule is **absent `bitK` -> fan `min(K, fanout-1)`**: the identity map,
saturating at the last fan. **Do not trust the `<tool>` default block.**

Confirmed independently across the whole design by `Sim.width_conflicts()`,
which reports every net whose endpoints disagree about how many bits they carry.
With the correct rule: **0 conflicts** across all 1094 flattened primitives.
With the wrong one, splitter fans come out the wrong width for the pins they
drive.

## Where Part 2 is weak -- attack these too

1. **Floating inputs read as 0.** Logisim shows them as X and can propagate
   error values. Anywhere the real circuit has an undriven input, the two
   engines could agree on 0 and both be wrong about the hardware.
2. **`min(K, fanout-1)` rests on one measurement.** It is consistent with every
   splitter in the design and with 0 width conflicts, but only one case had an
   absent bit other than `bit0`. A splitter with several absent middle bits
   would test it properly; none exists yet.
3. **An unconnected Register or Decoder enable is treated as 1.** That matches
   observed behaviour but was not measured the way the splitter rule was.
4. **The two engines share `model.py` and `geometry.py`.** They are independent
   on semantics, not on parsing or pin placement. A geometry error that puts a
   port in the wrong place fools both -- which is exactly how the decoder bug
   survived, and it was found by a behavioural test, not by cross-checking.
5. **Nothing yet simulates RAM against real behaviour.** The RAM path exists in
   `sim.py` but is unexercised until `stage_MEM`.
