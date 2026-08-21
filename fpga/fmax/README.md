# Measuring the real Fmax on the Kintex-7 board

This is the current CPU (stack fixes in, 256-word ROM, `mul_32` removed)
exported to Verilog and ready for Vivado. Nothing here is board-specific —
it measures what the core can clock, not a bitstream.

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
registers**. If the register count is near zero, the clock never reached the
logic and the number is meaningless.

## What to compare it against

Measured on `xc7a100tcsg324-1` with F4PGA (Yosys + VPR), routed:

| | Fmax | critical path |
|---|---|---|
| whole CPU | 58.31 MHz | 17.15 ns |
| ALU alone | 98.12 MHz | 10.19 ns |

VPR is pessimistic on routing and Artix-7 `-1` is the slowest 7-series part, so
the Kintex number should be meaningfully higher. My estimate was 93-157 MHz —
this run replaces that guess with a fact.
