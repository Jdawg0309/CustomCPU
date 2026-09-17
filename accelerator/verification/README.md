# NPU independent verification

This directory is the arithmetic ground truth for the autonomous NPU. It has no
dependency on the DUT implementation or NumPy.

## Arithmetic contract

1. `A` and `B` are signed INT8, row-major.
2. Each product is accumulated in wrapping signed INT32 arithmetic.
3. Optional signed INT32 bias is per output column/channel.
4. Optional ReLU happens before requantization.
5. Requantization is a signed arithmetic right shift by 0–31.
6. The INT8 result saturates to `[-128, 127]`.

## Recommended autonomous DUT interface

Keep CPU traffic outside the compute loop. While idle, a host writes local A, B
and bias memories through address/data/write-enable ports. It then holds the
configuration stable and pulses `start` for one cycle. The NPU raises `busy`,
runs without host instructions, pulses `done`, and exposes indexed C reads.

Required configuration: `M`, `N`, `K`, bias enable, ReLU enable, INT8 enable,
and requant shift. Required status: `busy`, `done`, and dimension/config error.

The physical array may use valid/ready edge streams internally; the test-vector
format intentionally does not constrain its latency, pipeline depth, banking,
or tiling implementation.

## Run

```bash
cd accelerator/verification
python3 -m unittest -v test_golden_npu.py
python3 golden_npu.py --output /tmp/npu_vectors.json --count 25 --max-dim 40
```

The JSON contains operands, configuration, full INT32 results, and saturated
INT8 results. Dimensions include 31/32/33 boundaries to catch tiling defects.

When binding to RTL, the driver must:

- load each row-major memory only when `busy == 0`;
- pulse `start` for exactly one accepted cycle;
- allow arbitrary `busy` duration and wait for `done`;
- compare every C element, not just a checksum;
- enforce a timeout derived from `M`, `N`, `K`, and the implementation latency;
- repeat with backpressure if the physical array exposes ready/valid streams.

The public autonomous RTL is also exercised with 30 deterministic-random cases:

```bash
iverilog -g2012 -s tb_random_autonomous -o /tmp/npu_random \
  accelerator/rtl/systolic_pe_int8.sv \
  accelerator/rtl/systolic_array_int8.sv \
  accelerator/rtl/autonomous_systolic_npu.sv \
  accelerator/verification/tb_random_autonomous.sv
vvp /tmp/npu_random
```
