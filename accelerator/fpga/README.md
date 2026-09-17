# XC7K480T NPU implementation sweep

This directory measures the accelerator with a complete Vivado implementation
(synthesis, placement and routing), targeting the Kintex-7
`xc7k480t-ffg901-2` (Vivado may normalize this to
`xc7k480tffg901-2`). A routed result is required before quoting Fmax or GOPS.

## Run

If Vivado is already on `PATH`:

```bash
accelerator/fpga/sweep_fmax.sh
```

Otherwise point directly to it:

```bash
VIVADO_BIN=/path/to/Vivado/bin/vivado accelerator/fpga/sweep_fmax.sh
```

On the current development machine, Vivado was detected at:

```text
/mnt/storage/2026.1/Vivado/bin/vivado
```

Vivado 2026.1 launches, but implementation is currently blocked before Tcl is
evaluated because no valid license is found. Point `XILINXD_LICENSE_FILE` at a
license that includes the XC7K480T device, or configure that license in Vivado
License Manager, before running the sweep. The existing
`/mnt/storage/Downloads/Xilinx.lic` was tested and was not accepted.

The default sweep implements array sizes 1, 4, 8, 16 and 32 at clock periods
from 5.0 ns through 2.0 ns. Override either list without editing the scripts:

```bash
NPU_ARRAY_SIZES="4 16 32" NPU_PERIODS_NS="4.0 3.0 2.5" \
  accelerator/fpga/sweep_fmax.sh
```

Each run produces routed timing, utilization, DRC and checkpoint files. The
combined machine-readable table is `results/all_results.tsv`.

## Reading the result

The script calculates the single-run routed estimate as:

```text
critical-path delay = requested period - routed WNS
Fmax (MHz)          = 1000 / critical-path delay (ns)
peak GOPS           = 2 * ARRAY_SIZE^2 * Fmax(MHz) / 1000
```

The GOPS equation counts a multiply and an addition as two operations. It is a
peak compute rate and assumes every PE performs one useful MAC every cycle.
Real model throughput also depends on fill/drain cycles and memory bandwidth.

## Measurement boundary

Host configuration and memory-loading ports are false-pathed because the test
measures the autonomous accelerator core clock. Internal state, MAC and control
paths remain timed. `utilization_route.rpt` is authoritative for resource use.

The timed DUT is the registered neighbor-to-neighbor systolic fabric, not the
earlier behavioral parallel-memory model. Operand boundaries are registered,
every PE contains registered A/B movement and a local accumulator, and only
the top-level observation ports are false-pathed. This gives the meaningful
compute-fabric ceiling. A separate end-to-end result including scratchpads and
the autonomous controller should be reported before claiming application
throughput.
