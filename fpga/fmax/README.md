# Measuring the real Fmax on the Kintex-7 board

`full_cpu.v` is a **frozen Yosys export taken 2026-08-20**, not the current
circuit. Against `armv4t.circ` as of 2026-08-25 it is stale in three ways:

- it still has a **256-word instruction ROM** (8-bit address); the circuit now
  has a 1024-word ROM, so ROM is `0x0000-0x0FFF` and RAM starts at `0x1000`
- `mul_32` is **still present** (`module mul_32`, instantiated in `main`),
  despite earlier notes to the contrary
- it predates the stack/POP-PC completion, the PC-as-operand read, and the
  literal-pool second ROM port

Re-export from Logisim Evolution before quoting any number as current.
Nothing here is board-specific — it measures what the core can clock, not a
bitstream.

## Run it

    vivado -mode batch -source find_fmax.tcl                        # XC7K480T (your board)
    vivado -mode batch -source find_fmax.tcl -tclargs xc7k160t-ffg676-2   # free Vivado

Results land in `vivado_out/FMAX.txt`, plus full utilization and timing reports.

Takes roughly 10-25 minutes depending on the part and machine.

## Which part to use

`xc7k480t` is your board and needs **Vivado ML Enterprise**. `xc7k160t` is
supported by **free Vivado ML Standard** and is the same Kintex-7 fabric at the
same speed grade — Fmax transfers closely, because frequency is set by logic
depth and local routing, not die size. Use 160T to get a number today; use
480T when you have the licence.

Confirm the exact part string with `get_parts` in Vivado; speed grade (`-1`,
`-2`, `-3`) matters more to the result than anything else here.

## How it measures

The clock is deliberately constrained faster than the design can run (4 ns =
250 MHz). Implementation runs, then:

    Fmax = 1 / (4 ns - WNS)

A **negative** worst negative slack is expected — that is the measurement, not
a failure. Constraining to something achievable would only tell you the design
meets that constraint, not what it can actually do.

## Check this before believing the number

The wrapper XOR-folds all 780 output bits into 4 registered signature bits so
synthesis cannot prove the core unobservable and delete it. An earlier attempt
at this flow reported a suspiciously good result from a netlist Yosys had
optimised down to **9 cells**.

So sanity-check `FMAX.txt`: expect roughly **1500-2000 LUTs** and **~646
registers** (figures for the frozen 2026-08-20 export; a re-export with the
1024-word ROM will differ). If the register count is near zero, the clock never
reached the logic and the number is meaningless.

## What to compare it against

**Stale baseline — old design, old part.** Measured on `xc7a100tcsg324-1`
(Artix-7, superseded by the purchased Kintex-7 XC7K480T) with F4PGA
(Yosys + VPR), routed, against an earlier netlist than even `full_cpu.v`:

| | Fmax | critical path |
|---|---|---|
| whole CPU | 58.31 MHz | 17.15 ns |
| ALU alone | 98.12 MHz | 10.19 ns |

VPR is pessimistic on routing and Artix-7 `-1` is the slowest 7-series part, so
the Kintex number should be meaningfully higher. My estimate was 93-157 MHz.
Treat the table above as history only: it does not describe the current CPU,
and no Fmax run has yet been done on the XC7K480T.

## The exported RAM does not match the circuit (found 2026-08-27)

`full_cpu.v:9760`, `module ramcontents_ram_1`:

```verilog
always @(posedge clock) _03_ <= _02_;                        // address registered
always @(posedge clock) _15_ <= s_memcontents[s_addressreg]; // read registered
always @(posedge clock) _12_ <= s_oe ? s_ramdataout : _12_;  // output registered
assign dataout = _12_;
```

Registered address, registered read, registered output, plus a three-stage
`tick` delay line -- so roughly three clock cycles of read latency. The Logisim
circuit assumes a **combinational** read: `oe = "Load: if 1, load memory to
output"`, no clock. `trigger` governs only the write edge.

So the netlist these numbers were measured on does not behave like the CPU.
Every `ldr` would read stale data in hardware.

**Consequence for the numbers here:** treat any Fmax from this flow as an
indicator of LOGIC DEPTH, not as a validated CPU clock, and do not quote it as
"the CPU runs at N MHz" until the memory model is reconciled. Reconciling it
means either a real synchronous-memory pipeline stage in the design, or an HDL
export whose RAM reads combinationally.

## What the 2026-08-25 measurement actually found

    part   : xc7k480t-ffg901-2       FMAX : 180-187 MHz
    source : pc_fetch/pc reg[8]      dest : reg16x32_1/r15 reg[4]/CE
    logic levels : 6
    data path    : 5.269 ns = logic 0.481 ns (9.1%) + route 4.788 ns (90.9%)

**91% of the critical path is routing.** The design fills 0.38% of a 298,600-LUT
die, so the placer had no reason to keep anything together. Before any
architectural work, constrain the core to a pblock and re-measure -- that
attacks the 4.8 ns, and nothing else on the list is as cheap.

Note also what the path IS: PC register to r15's clock enable, i.e. the
"does this instruction write the PC" decode. **The memory is not on the critical
path at all**, so memory-side changes will not move this number.

## Reachable clock, honestly

At 400 MHz the period is 2.5 ns; clk-to-Q + setup + clock uncertainty eat about
0.5 ns, leaving ~2.0 ns for logic and routing together. That is roughly four LUT
levels with well-behaved local routing. For scale: 7-series BRAM itself caps
near 450 MHz on a -2, and production soft CPUs on this fabric land at 200-350
MHz.

| step | expected |
|---|---|
| today, single-cycle, no floorplan | 187 MHz |
| + pblock floorplan | 250-300 MHz |
| + 5-stage pipeline with correct synchronous memory | 300-350 MHz |
| + deep pipelining, -3 part, hand tuning | 400 MHz, hard |
| 500 MHz | not on Kintex-7; needs UltraScale+ at 16nm |
