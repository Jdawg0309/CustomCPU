# Autonomous INT8 accelerator

This directory contains a standalone, CPU-independent accelerator baseline.
The host loads matrices and configuration, pulses `start` once, and waits for
`done`. No CPU instruction is required for individual multiply-accumulates.

## Implemented

- Parameterized `ARRAY_SIZE x ARRAY_SIZE` parallel MAC fabric
- Signed INT8 activation and weight memories
- Signed INT32 accumulators and output memory
- Autonomous M/N tiling for matrices larger than the physical array
- Per-output-channel INT32 bias
- Optional ReLU
- Arithmetic power-of-two requantization
- Saturating INT8 output
- Busy, done and invalid-dimension error reporting
- Direct host/testbench loading ports
- Self-checking tiled test with negative operands

The default synthesis configuration is 32x32. The testbench instantiates 4x4
and computes a 5x7 by 7x6 product, forcing multiple M and N tiles while keeping
simulation fast.

## Test without the CPU

```bash
cd accelerator
make test
```

The expected final line is:

```text
PASS autonomous tiled GEMM 5x7 * 7x6, bias, ReLU, requant
```

## Routed FPGA result

The registered 32x32 compute fabric closes timing on the XC7K480T at a
critical-path-derived **236.072 MHz**, giving **483.475 peak INT8 GOPS** with
1,024 DSP48E1 blocks. See `fpga/RESULTS.md` for the measurement boundary,
utilization and present sustained-throughput limitation.

## Convolution

A convolution is executed by converting its input patches into matrix A and
its filters into matrix B (im2col). This first baseline deliberately keeps
im2col outside the hardware so the MAC fabric can be validated independently.
An address-generation frontend can later stream convolution windows without
materializing the expanded matrix.

## Important physical limitation

The current scratchpads are behavioral register arrays with massively parallel
reads. They are excellent for functional testing and provide a 1024-MAC/cycle
comparison point, but they are not yet a bandwidth-realistic BRAM subsystem.
The FPGA RTL revision must bank the memories and pipeline operand movement
through a true systolic network before its Fmax and utilization are meaningful.
