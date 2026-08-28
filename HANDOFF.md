# CustomCPU handoff — 2026-08-25

State at the end of a long session. Everything below was measured, not inferred;
where something is unverified it says so.

## Rule that governs this project

**`armv4t.circ` is hand-wired by the user and is never modified by Claude.**
Read it freely; all experiments happen in `debug_armv4t.circ`, which may be
overwritten at will. Every agent spawned this session was given that rule.

## Where things stand

| file | md5 | state |
|---|---|---|
| `armv4t.circ` | `8b565e9e` | user's master; being actively edited in the GUI |
| `debug_armv4t.circ` | `458a7eb5` | armv4t layout + all fixes below |
| git | `36c4b4f` | **commit still pending** — see below |

`backups/` holds four recovery snapshots taken during the session.

### The commit never landed

`git commit` fails with `agent refused operation`. Cause: `commit.gpgsign=true`
with `gpg.format=ssh` and a signing key that requires interactive confirmation;
Claude's shell is sandboxed so the prompt cannot appear. The key IS loaded and
DOES match `user.signingkey` — this is not a misconfiguration. Everything is
staged. Run this yourself so the prompt reaches you:

```
git commit -F /tmp/.../scratchpad/commitmsg.txt && git push
```

An earlier `git push` created `origin/pc-read-and-memory-map` pointing at the
OLD commit `36c4b4f`. Nothing of this session's work is on GitHub yet.

## What was fixed (all in debug_armv4t.circ)

### 1. pc as a general operand
`pc_fetch.pc_out` is **10 bits** (PC[11:2], the ROM word address), not a 32-bit
PC. Feeding it to a 32-bit adder left 22 bits undefined, which Logisim could
never converge on — it presented as a silent hang with no error. Fix: rebuild
the 32-bit value (bit-extend → shift left 2 → +8 for ARM's read convention) and
mux it into the register file's read ports when the register number is 15.
11 components, 57/57 net checks.

### 2. A real memory map
ROM (`0x0000-0x0FFF`) and RAM (`0x0000-0x03FF`) were **both mapped at zero**, so
an address decode was impossible. That is why an earlier attempt keyed on "base
register is r15" — an instruction-form test that fixed `ldr rD,=const` and
nothing else in its class.

RAM moved to `0x1000`; loads now decode on `addr[12]`. A second ROM holding the
same image serves the load path. `.rodata`, jump tables and switch tables now
work through **any** base register.

- Programs must place data at or above `0x1000`.
- Suites use stack `0x1400`, scratch `0x1100`, `push_suite.RAM_BASE = 0x1000`.
- RAM dump indices are `(byte_addr - RAM_BASE) // 4`.

Discriminating test (`program memory via register base`): `ldr r1,=tbl` then
`ldr r0,[r1,#4]`. An `Rn==r15` select cannot route it — old build returned
`00000000`, new returns `cafebabe`.

### 3. Block transfer — partially done, LDM still broken

Three separate gates each independently prevented general LDM/STM:

1. **`rn_is_sp`** was ANDed into both `is_push` and `is_pop`, so `start` could
   only fire when the base register was r13. Replaced with tie-high constants.
2. **`push_mode`/`pop_mode`** were 5-bit equality matches against the two
   literal encodings — `mode==0x12` (STMDB,W=1) and `mode==0x0B` (LDMIA,W=1).
   Everything else failed the compare. Generalised to `is_push = valid AND NOT L`,
   `is_pop = valid AND L`.
3. **`is_pop` was the sole select for every direction mux AND the scan
   terminators**, conflating "is a load" with "count upwards". Added `P` and `U`
   input pins to `block_transfer_control` and repointed:
   - reg-index direction, reg-index init, address step → `U`
   - pre/post address → `NOT P`
   - scan terminators at `(1760,1590)` and `(1680,1780)` → `U`
   - pre-indexed path was hardwired to `dec4`; now takes the U-selected
     `stepped_addr` so IB gets `base+4`
   - the NOT at `(1580,2790)` and AND at `(1670,2880)` drive load/store enable
     and correctly stay on `L`

`U` and `P` were added BELOW `base_value` in the subcircuit so they append at
port indices 6–7. Verified: existing instance ports did not move.

**Result: all four STM modes pass.**

```
STMIA r1@0x1200 r2@0x1204  PASS      STMDA r1@0x11fc r2@0x1200  PASS
STMIB r1@0x1204 r2@0x1208  PASS      STMDB r1@0x11f8 r2@0x11fc  PASS
```

> **CORRECTION 2026-08-27:** this section is stale. All five block-transfer
> cases now pass with a non-SP base -- STMIA data, STMIA writeback, LDMIA,
> STMDB and LDMDB -- measured with `tests/adversarial_regression.py`. The
> `ldr_reg_we` and scan-termination problems described below were fixed after
> this was written. One caveat found while re-measuring: LDM's register write
> arrives through a multiplexer with a **floating select**, so it depends on
> undefined behaviour; `specs/stage_WB.md` section 1 has the evidence and the
> fix.

**LDM was NOT done when this was written.** With a non-SP base it now *hangs* instead of returning a
wrong value. Trace of `ldmia r4,{r0}`:

```
cyc 5  is_pop=1 start=1                      LDM recognised
cyc 6  active=1 reg_selected=1
cyc 7  load_enable=1 reg_selected=1          the load fires
cyc 8+ active=1, scan never terminates, 42+ rows, done never asserts
       ldr_reg_we stays 0 throughout         loaded data never reaches the regfile
```

Two things to chase: `ldr_reg_we` never asserting for block loads, and the scan
not terminating. POP still works (`push_suite` 10/10), so the working path is
SP-specific somewhere not yet found.

**Also unresolved:** `stmia r4,{r1}` with W=0 leaves **r4 = 0**. The base is
being clobbered — writeback is not gated on `W`.

## Current measured status

```
push_suite            10/10
isa_coverage          PASS=32  RAN=2  WRONG=10
adversarial           41/54            (was 36 — improved by the fixes above)
```

`STMIA non-SP base` and `LDMDB` flipped to PASS. The total did not move because
two stricter tests exposed genuine new bugs — see ADC below.

### The 10 failures, by root cause

**Instruction bit 4 is never examined** (8 of 10). The decoder classifies on
bits[27:25] only, so the whole `000`-space family with bits 7 and 4 set is
misdecoded as data-processing:

| test | got | want |
|---|---|---|
| MUL | `00000000` | `2a` |
| MLA | `00000000` | `2c` |
| UMULL | `000000e0` | `2a` |
| STRH/LDRH | `00001100` | `aa` |
| LDRSB | `00001100` | `ffffffff` |
| SWP | `00000000` | `aa` |
| LSL reg | `00000100` | `20` |
| LSR reg | `00000000` | `4` |

The shift pair is confirmed arithmetically: `mov r0,r1,lsl r3` with r1=4, r3=3
gives `0x100` = 4≪6, which is bits[11:7] read as an immediate shift amount. Bit
4 alone selects register-vs-immediate shift. One decode change unlocks all eight.

**Newly exposed genuine bugs** (better tests, not new breakage):
- **ADC drops the carry-in.** With C forced to 1, ADC returns the same value as
  ADD. `got 1ef00000 want 1ef00001`.
- **MSR** `got 00000000 want 00000001`.

**No test at all:** `LDRSH`.

## Immediate next steps, in order

1. **Commit** (blocked on your signing prompt).
2. **Finish LDM** — `ldr_reg_we` and scan termination; then W-gated writeback.
3. **Decoder bits 7/4 split** — one change, unlocks 8 failures.
4. **Wire `mul_32` into `main`** (36 components, built, never instantiated).
5. Hand-wire the fixes into `armv4t.circ` — instructions published, regenerated
   against your live layout.

## Traps that cost real time — read before debugging

- **`--tty table` is TAB-separated**, but one field can contain internal spaces
  (wide values print as space-separated 4-bit groups). Always `.split("\t")`.
- **Map columns by the Pin's `label`** with a `(y,x)` sort, never by position.
- **No row is emitted before the first clock edge.** Pad programs with leading
  `nop`s or the first instruction is invisible. This produced a completely false
  "`is_LDR` never asserts" diagnosis.
- **Splitter fan 0 is FURTHEST from the combined end** under the default
  `appear`, nearest under `appear="right"`. `fan1` of a fanout-3 splitter is at
  the same point under both orderings, so only fan 0 or the last fan can
  discriminate. Fixed in `logisim/geometry.py`. Changing `fanout` **relocates
  every existing fan**.
- **A 32-bit mux's inputs are 30 units back from the anchor, not 20.** A route
  stopping at 20 looks connected and carries nothing.
- **A tie-high constant placed on the net you just cut reconnects it.** Place it
  clear and route in.
- **A debug Pin with the wrong width hangs the simulation.** Probes carry no
  `width` attribute, so copying it gives you 1 bit on a 4-bit net.
- **A freshly created ROM has no `contents` element** until something is stored
  in it, so contents-by-substitution patching silently no-ops and reads return 0.
- **ROM costs `words/2` LUTs** — it packs into distributed ROM at 64 bits per
  LUT6 (measured: 256×32 → exactly 128 LUTs). A duplicate ROM for a 16 KB program
  is ~2048 LUTs, 0.7% of the XC7K480T's 298,600. An earlier claim that this was
  a "LUT catastrophe" was wrong.
- **RAM cannot be preloaded.** `CONTENTS_ATTR` exists only on `Rom.java`; RAM
  contents are runtime state, never serialised. Program memory must be a ROM.
- **Pipelining does not fix the memory port conflict** — IF and MEM run in the
  same cycle, so it increases pressure. Multi-cycle is what time-shares a port.

## Agent results

Three cleanup agents ran. **Two died on the session limit** (`logisim` bug audit,
test-suite audit) — their work is partial and unreviewed. The test agent HAD
already improved several tests before dying; those edits are unstaged and are
good (they poison results with `0x5a` so "nothing executed" cannot pass, and
force C before ADC/SBC/RSC). **Re-run both agents.**

The repo-hygiene agent completed. Headlines:
- `c_tests/Makefile` is fully orphaned — every prerequisite moved in the Aug-21
  flatten. `make -C c_tests all` fails immediately.
- `build/verify_practical.py` crashes and asserts the OLD memory map
  (`addrWidth==8`, `pc_out` width 8; both are 10 now).
- `build/run_logisim_test.sh:27` has the wrong ROM directory.
- `build/MANIFEST.sha256` is unverifiable — all 69 paths are pre-flatten.
- **`tests/pop_suite.py`, `tests/sp_probe.py`, `tests/stack_stress.py` still use
  `mov sp,#256`** — inside ROM space under the new map. They can pass or fail
  for the wrong reason. Not yet fixed.
- Many ROM sources in `src/` still target `0x20`/`0x100` bases, now ROM.
- It corrected `README.md`, `roms/README.md`, `fpga/fmax/README.md` and rewrote
  `.gitignore` (adds `backups/`). Nothing was untracked or deleted.
- The committed Fmax figure is **58.31 MHz** on `xc7a100t`, from a frozen
  2026-08-20 export — stale design, superseded part. No Kintex run exists.

---

# Session 2026-08-26 — graph tooling, ADC fix, deterministic decode map

## New tool: `logisim/graph.py`

The circuit as a graph, so connectivity questions are answered by query rather
than by squinting at coordinates.

```
python -m logisim graph debug_armv4t.circ main
python -m logisim graph debug_armv4t.circ main --node 8520,8680
python -m logisim graph debug_armv4t.circ main --trace <node-id> --depth 4
python -m logisim graph debug_armv4t.circ main --json g.json --dot g.dot
python -m logisim diff  armv4t.circ debug_armv4t.circ main --wiring
```

Two structures. The **port/net graph** is bipartite and lossless: a net is a
hyperedge over ports. The **signal graph** collapses each net into driver->sink
edges so it can be walked, traced and diffed. Splitters are hopped across in
whichever direction they actually carry, so a trace follows a bit out of a bus
and back into one instead of stopping dead.

`diff()` compares two files by node id (which embeds coordinates), and
`wiring_steps()` turns the difference into `source --wire--> sink` instructions
grouped one net at a time. That is the mechanism for bringing `armv4t.circ` up
to `debug_armv4t.circ` without copy/paste and without raw coordinate lists.

## Two real tool bugs found and fixed

**Splitter fan ordering was inverted for `west` and `north` facings.** The
index order is a fixed screen convention, not a function of `appear`: fan 0 is
the topmost fan for east/west, the rightmost for north/south. Measured against
live Logisim for all eight facing/appear combinations. Only fan 0 or the last
fan can distinguish two orderings, which is why an earlier spot check on a
middle fan passed while the function was backwards.

**The `bitK` splitter attributes are the inverse map of what their name
suggests.** `bitK` holds the fan number that bus bit K is routed to, not the
bus bit that fan K carries. Read forwards, it reported all four CPSR flags as
crossed when they round-trip perfectly. Verified by driving one fan at a time
through a splitter carrying the CPSR write map and reading the combined bus.

`geometry.UNMODELLED` is now empty -- ROM and RAM ports are modelled
(`data_out` at +240,+60 for ROM, +240,+90 for RAM), so nets they drive no
longer look floating.

## Fixed: ADC dropped its carry-in

`ALU.Cflag` was tied to a `Constant 0x0`. The control ROM at (8230,8620) is
entirely correct -- decoding all sixteen entries shows ADC/SBC/RSC each select
`cin_sel=2` (Cflag) -- so the flag simply never arrived.

Routed the CPSR readback splitter's C fan at (9590,8800) to `ALU.Cflag` at
(8970,8760), 7 segments, and deleted the constant.

**PASS 32 -> 33, WRONG 10 -> 9.**

SBC and RSC were passing only by luck: their cases force C=0, which is exactly
the value the stuck constant supplied. `tests/isa_coverage.py` now also runs
both with C=1, where a dropped carry-in gives A-B-1 instead of A-B.

## Decode map, established by enumeration

The whole class decode is two comparisons:

| comparator | test | meaning |
|---|---|---|
| `Comparator@5780,10040` | `instr[27:4] == 0x12FFF1` | BX |
| `Comparator@7290,8150`  | `instr[27:25] == 0b100`  | block transfer |

Everything else falls through. Instruction bits 7 and 4 reach the decoder only
inside the 12-bit immediate field; no gate examines them as opcode
discriminators. That single gap is the root cause of MUL, MLA, UMULL, LSL reg,
LSR reg, STRH/LDRH, LDRSB and SWP.

Three comparators are dead, driving only Probes, and are safe to delete:
`@7840,8250` (push_mode 0x12), `@7840,8320` (pop_mode 0x0b),
`@8260,8280` (rn_is_sp 0xd).

## The multiplier is connected at neither end

`ALU` instantiates `mul_32@540,1220` -> `ks_32b@760,1220`. But `mul_32.A` and
`mul_32.B` are driven by nothing, the product bus out of `Splitter@780,1210`
goes nowhere, and the ALU engine mux `Multiplexer@900,430` has `in2`/`in3`
unconnected. MUL therefore needs three things, not one: operands in, result
into the engine mux, and a decoder that can emit `engine_sel=2`.

`ks_32b` is used **only** as the multiplier's final adder. The live
`ALU_arithmetic_engine` uses a plain Logisim `Adder`, so the Kogge-Stone tree
is not in the CPU's add path at all.

## Twelve circuits are unreachable from `main`

`ALU_arithmetic_engine_1`, `reg16x32`, `a_invert`, `kogge_stone_2b`, `ks_4b`,
`csa_16`, `mul_8`, `pp_8`, `pp_row_16`, `PE_cell`, `systolic_4x4`,
`matmul4x4`. They cost LUTs on HDL export and nothing at simulation time; the
four `PE_cell.a_out` disconnections reported earlier are harmless.

## Not a defect, despite appearances

`Multiplexer@7890,9250` (facing north) drives the register-file write enable.
Its `sel` is unconnected, and a 329-point net carrying
`block_transfer.done OR hold_pc` stops 40 units short of it at (7870,9270).
That looks like an unfinished wire, but `in0` already ORs in every write-enable
source including the block-transfer path, so connecting `sel` would *break*
writeback. The mux and its feeder OR gate at (6070,7790) are vestigial.

## Tests rebased onto the 0x1000 memory map

`pop_suite.py`, `sp_probe.py` and `stack_stress.py` still placed the stack and
result areas inside ROM. All three now derive their addresses from
`ps.RAM_BASE`, and all three default to `debug_armv4t.circ`.
