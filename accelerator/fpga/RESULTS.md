# XC7K480T routed NPU results

Measured with Vivado 2026.1 on `xc7k480tffg901-2`, slow timing corner,
synthesis followed by placement, physical optimization and routing.

## Timing-closed 32x32 compute fabric

| Metric | Routed result |
|---|---:|
| Array | 32 x 32 |
| Processing elements | 1,024 |
| Clock constraint | 4.300 ns / 232.558 MHz |
| Routed WNS | +0.064 ns |
| Critical-path-derived Fmax | **236.072 MHz** |
| DSP48E1 | **1,024 / 1,920** |
| LUTs | 3,897 |
| Flip-flops | 10,872 |
| BRAM in compute-fabric harness | 0 |
| Peak INT8 throughput | **483.475 GOPS** |

The GOPS convention counts one multiply and one addition as two operations:

```text
2 operations/MAC x 1,024 MACs/cycle x 236.072 MHz
= 483.475 GOPS peak
```

The routed checkpoint and reports for this run were generated at:

```text
/tmp/npu_vivado_32_closed/a32_p4_300/
```

## What the measurement includes

- 1,024 real DSP48E1 multiply-accumulators
- INT8 signed operand movement through neighbor-to-neighbor registers
- INT32 local output-stationary accumulators
- valid propagation and synchronous array clearing
- clock distribution and routed interconnect across the XC7K480T

It measures the registered compute fabric. Boundary traffic begins in
registers, so the critical path is not an unconstrained input-to-DSP path.

## What it excludes

- external DDR/PCIe bandwidth
- a deployable DMA engine
- BRAM scratchpad arbitration
- hardware im2col/window generation
- the autonomous controller's serial output-store loop

Consequently, 483.475 GOPS is the peak compute ceiling, not guaranteed YOLO
application throughput.

## Present autonomous-controller throughput

The functionally verified controller currently stores one output per cycle.
For one 32x32x32 GEMM tile it performs 65,536 useful operations in approximately
1,120 cycles:

```text
65,536 / 1,120 x 236.072 MHz = 13.81 GOPS
```

This is intentionally visible as the next architectural bottleneck. A
32-column banked accumulator drain reduces output storage from 1,024 cycles to
32 cycles. Double-buffering those banks permits output draining to overlap the
next tile and moves sustained throughput toward the 483.475-GOPS fabric limit.

## Rejected measurements

- A 3.000 ns route produced WNS = -1.292 ns. Its derived 232.992 MHz was useful
  for locating the closure boundary but did not meet the requested clock.
- Applying `DONT_TOUCH` to every accumulator prevented DSP inference, producing
  98,667 LUTs and zero DSP blocks. That run was rejected as the wrong hardware.

Only the +0.064 ns, 1,024-DSP route is the accepted result.
