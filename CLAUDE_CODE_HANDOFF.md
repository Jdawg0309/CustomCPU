# Claude Code handoff — full CPU sandbox HDL/timing

Date: 2026-08-15 (America/New_York)

## Non-negotiable project contract

- Do **not** modify `armv4t.circ` unless the user explicitly authorizes that exact edit.
- The user's real CPU is `armv4t.circ`; experimentation and diagnosis belong in
  `debug_armv4t.circ` or `sandbox_armv4t.circ`.
- The user manually wires the real CPU. Demonstrate and test changes in the sandbox,
  then tell the user exactly what to reproduce.
- Preserve unrelated dirty worktree changes.

## Git state

- Current branch: `agent/wip-block-pop-timing`
- Current pushed commit: `55a1583 WIP block transfer POP timing`
- Remote branch at the same commit: `origin/agent/wip-block-pop-timing`
- `armv4t.circ` has not been changed during the full-CPU HDL/timing work described here.
- There are many pre-existing modified and untracked user files. Inspect `git status`
  and commit only intentionally selected files.

## Sandbox circuit change made in this session

Only one circuit edit was made, and only in untracked `sandbox_armv4t.circ`:

```xml
<wire from="(1280,980)" to="(1280,1000)"/>
```

was removed. After the new `pop_request` output was added to
`block_transfer_control`, component port positions shifted. That obsolete vertical
wire shorted `pop_request` to the adjacent transfer-address output and caused a
multiple-driven net. Removing it made full `main` DRC pass (89 nets, 72 buses).

Do not blindly apply this to `armv4t.circ`; the user must reproduce/approve real-CPU
wiring changes.

## Controller HDL result already measured

Files are under `hdl/artix7/`, including the controller RTL, testbench, timing
wrapper, XDC, and Makefile.

- Icarus tests passed for PUSH `{r4,lr}` and POP request/commit sequencing.
- PUSH addresses: `0x3fc`, then `0x3f8`; final SP `0x3f8`.
- POP holds request/commit addresses `0x3f8`, then `0x3fc`; final SP `0x400`.
- Routed controller-only result on `xc7a100tcsg324-1`: minimum period 7.89862 ns,
  or 126.604 MHz.
- This is **not** the full-CPU Fmax.

## Full CPU HDL export

The complete current sandbox `main` hierarchy was exported from Logisim and copied
to `hdl/logisim_full_cpu/` (90 generated VHDL files). GHDL/Yosys converted it to:

- `hdl/logisim_full_cpu/full_cpu.v`
- `hdl/logisim_full_cpu/full_cpu.json`

The full wrapper and Artix-7 build inputs are:

- `hdl/logisim_full_cpu/full_cpu_timing_top.v`
- `hdl/logisim_full_cpu/arty_a7_100t.xdc`
- `hdl/logisim_full_cpu/Makefile`

The wrapper instantiates the complete generated `main`, drives
`logisimClockTree0={clk,4'b1111}`, and XOR-folds wide CPU outputs into four signature
pins so synthesis cannot discard all observable logic.

Verified elaboration command:

```bash
iverilog -g2012 -s full_cpu_timing_top -o /tmp/full_cpu_check \
  hdl/logisim_full_cpu/full_cpu.v \
  hdl/logisim_full_cpu/full_cpu_timing_top.v
```

It exits successfully.

## Logisim exporter helper

The matching Logisim Evolution 3.8 source is in `.tools/logisim-evolution-3.8.0/`.
Its private working copy was patched so HDL-only export skips physical board mapping
and TTY DRC reports component objects. Built jar:

`.tools/logisim-evolution-3.8.0/build/libs/logisim-evolution-3.8.0-all.jar`

The export writes the useful hierarchy before a later board-wrapper NPE. The files
originally appeared under:

`/home/junaet/logisim_evolution_workspace/sandbox_armv4t/main/vhdl`

## Full Artix-7 place-and-route: exact current state

Target/image:

- FPGA: `xc7a100tcsg324-1`
- Docker image: `hdlc/conda:f4pga--xc7--a100t`
- Build command:

```bash
docker run --rm \
  -v /home/junaet/Documents/CustomCPU:/wrk \
  -w /wrk/hdl/logisim_full_cpu \
  hdlc/conda:f4pga--xc7--a100t bash -lc 'make all'
```

Full synthesis completed and Yosys reported zero structural problems. Peak memory
was about 931 MB. The first pack attempt failed because the auto-generated SDC chose
an optimized-away clock alias:

```tcl
create_clock -period 2 -waveform {0 1} cpu.cspr._0_
```

The synthesized EBLIF shows the actual post-IBUF clock net as:

`cpu.reg16x32_1_1.r9.s_clock`

The generated build SDC was temporarily corrected to:

```tcl
create_clock -period 2 -waveform {0 1} cpu.reg16x32_1_1.r9.s_clock
```

Then `make all` was resumed. That second pack attempt also failed: VPR did not accept
`cpu.reg16x32_1_1.r9.s_clock` as an SDC-visible net, despite its appearance in the
EBLIF. Therefore the remaining blocker is specifically choosing/retaining a valid
VPR clock target (likely the top-level `clk` port or an explicitly preserved clock
net), not synthesis or CPU elaboration. No build process remains running. A clean
synthesis may regenerate the original bad SDC, so make the correction reproducible
in the Makefile/script before final commit.

After route, extract the actual minimum period and Fmax from:

- `hdl/logisim_full_cpu/build/arty_100/route.log`
- `hdl/logisim_full_cpu/build/arty_100/report_timing.setup.rpt`

Do not call the 2 ns XDC target an achieved frequency. Report only routed timing.

## Known design caveats

- The generated HDL exactly represents the current sandbox after the one DRC wiring
  correction; it does not prove that stack/POP behavior is complete.
- Current stack wiring remains WIP: full POP main-register writeback, SP writeback,
  and suppression of normal commit paths still need end-to-end verification.
- Logisim warned about a gated/internal clock in `block_transfer_control`; the user
  already knows there is an extra clock and intended to fix it.
- GHDL warned that `s_logisimBus42` in `ALU_behavior.vhd` is never assigned.
- The generated RAM was recognized as 32-bit by 257 words.

## Update 2026-08-15 (Claude Code session) — real root cause found and fixed

The SDC-net blocker above was a red herring; the actual bug is in
`hdl/logisim_full_cpu/full_cpu_timing_top.v`. Logisim's exported `main` module
takes a 5-bit `logisimClockTree0` bus, not a plain `clk` pin. Different
sub-blocks read different bits of it:

- Raw Logisim-register primitives (`.clock(...)`) read **bit 4**.
- `block_transfer_control`, `pc_fetch`, and `reg16x32_1_1` — anything with its
  own explicit `clk`/`clock` port — read **bit 0** (traced via
  `s_logisimnet48 = logisimClockTree0[0]` in `full_cpu.v`, then fanned into
  `.clk(s_logisimnet48)` at `full_cpu.v:6416/6614/6716`).

The previous wrapper wired `.logisimClockTree0({clk, 4'b1111})` — real clock
on bit 4, **constant 1 on bits 3:0**. Bit 0 is one of those constant bits, so
every block that reads bit 0 for its clock never sees an edge and stays
latched at reset forever. Yosys correctly proved the entire CPU was constant
and deleted it: post-synthesis cell count was **9** (just the 4 output
buffers), and `symbiflow_pack` reported `Netlist Clocks: 0` / a 14-block, 10-net
circuit. That's why the SDC clock-name games in the section above never
worked — there was nothing left to time.

(In principle bit 0 should carry Logisim's phase-derived tick clock from
`LogisimClockComponent_behavior.vhd`, which needs a real counter to generate —
that generator was never instantiated because Logisim's board-wrapper export
crashed with the NPE noted above. Rather than reimplement that counter, the
fix ties **all 5 bits of `logisimClockTree0` to the same real `clk`**, which
is not phase-accurate to Logisim's internal multi-tick simulation model but is
the correct steady-state behavior for a single-clock-domain FPGA target.)

Fix applied in `hdl/logisim_full_cpu/full_cpu_timing_top.v`:
`.logisimClockTree0({clk, clk, clk, clk, clk})`. Also removed the stray
`SDC := full_cpu_timing_top.sdc` line from `hdl/logisim_full_cpu/Makefile` —
it routed a hand-authored SDC through `-s` that fought the tool's own
XDC-derived constraint and isn't needed (matches the working pattern in
`hdl/artix7/Makefile`, which only sets `XDC` and gets 126.604 MHz for the
controller-only test).

Post-fix synthesis sanity check (`docker run ... symbiflow_synth ...`,
log in `/tmp/.../scratchpad/synth_fixed.log` if still present) now reports
**2830 cells**: 1259 `$lut`, 620 `FDRE_ZINI` flip-flops, 14 `CARRY4_VPR`
chains, 1 `RAMB18E1_VPR` (Yosys inferred a real BRAM for the RAM), 292
`MUXF6`. This is a plausible non-degenerate CPU netlist, unlike the earlier 9
cells.

A full `make all` (clean synth → pack → place → route) completed against this
fixed netlist. **Result: routed Fmax = 42.9314 MHz, critical path = 23.293 ns**
(`hdl/logisim_full_cpu/build/arty_100/route.log:1925`). This is the first
real, routed number for the *whole exported CPU* — not to be confused with
the earlier 126.604 MHz figure, which was for a hand-written clean-room
mirror of just `block_transfer_control`, not the actual circuit.

Detail: `symbiflow_synth`'s own auto-SDC-writer (`OUT_SDC="${TOP}.sdc"` inside
`synth.f4pga.sh`) picked a real surviving net this time
(`cpu.block_transfer_control_1._18_`) since the clock-tree fix means the
design isn't provably constant anymore — `Netlist Clocks: 1` in pack.log
confirms it's timing a real clock domain now. No manual SDC patching was
needed. Resources: 620 FF, 1259 LUT, 292 MUXF6, 14 CARRY4, 1 RAMB18E1;
device utilization ~5-8% of the xc7a100t slices, so logic depth (not area) is
the constraint. The worst path chains ~10 LUT+MUXF6 stages (~2.2 ns each)
between two flip-flops with zero pipeline registers between them — matches
the fully-combinational single-cycle datapath (decode → barrel shift → ALU →
condition → writeback, all in one edge). Post-techmap signal names in the
critical path are ABC-mangled (`$auto$ff.cc:262:slice$4595` etc.) so it isn't
cleanly attributable to one named CPU signal without deeper digging (e.g.
`report_timing` against `full_cpu.json` before ABC remapping, or cross-
referencing against `full_cpu.v`'s hierarchy).

If re-deriving this number later: `rm -rf build && docker run --rm -v
/home/junaet/Documents/CustomCPU:/wrk -w /wrk/hdl/logisim_full_cpu hdlc/
conda:f4pga--xc7--a100t bash -lc 'make all'`, then read
`build/arty_100/route.log` (search "Final critical path delay").

Also noted this session: the user made a real edit to `armv4t.circ` directly
in Logisim (removing the debug internal Clock/OR-gate and repositioning the
`clk` pin — exactly what they said they'd do) — this is their own change, not
an agent edit, and was left as-is/uncommitted for them to commit when ready.

## Recommended immediate next actions

1. Fix the SDC-visible clock target. Try constraining the top-level `clk`, or modify
   the wrapper/synthesis attributes so a stable named clock net survives into VPR.
2. If route completes, report the exact full-CPU routed minimum period/Fmax and
   resource utilization, explicitly distinguishing it from controller-only timing.
3. Make the SDC clock-net correction reproducible.
4. Run/extend functional stack regressions on `sandbox_armv4t.circ` only.
5. Before any commit, carefully select files; never stage all of the dirty tree.
