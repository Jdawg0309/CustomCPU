# NPU reference architecture

## Fixed contract

| Property | Value |
|---|---|
| Target array | 32 x 32 processing elements |
| Activation | signed INT8 |
| Weight | signed INT8 |
| Product | signed INT16 mathematically |
| Accumulator | signed INT32, wrapping on overflow |
| Dataflow | output-stationary |
| FPGA target | XC7K480T |
| Intended workload | quantized convolution / object detection |

`npu_reference.circ` begins with one inspectable processing element. It is the
golden arithmetic definition, not the final 1024-PE physical implementation.
The full array will be generated structurally in synthesizable SystemVerilog;
manually copying 1024 Logisim cells would add visual bulk without improving
the reference model.

## Processing-element operation

On an enabled rising clock edge:

```text
accumulator <- psum_in + signed(activation) * signed(weight)
```

When `clear` is asserted, the accumulator becomes zero. The circuit explicitly
sign-extends both INT8 operands before the built-in multiplier so negative
operands have the same meaning in Logisim, the behavioral HDL, and the RTL.

## Implementation sequence

1. Verify the single-PE Logisim truth table, including negative products.
2. Write a behavioral SystemVerilog matrix-multiply model.
3. Produce shared deterministic vectors for both models.
4. Write a synthesizable pipelined PE that infers DSP48E1 resources.
5. Generate 4x4 and 32x32 arrays from the same PE.
6. Compare behavioral and RTL outputs cycle-for-cycle.
7. Synthesize and obtain utilization/Fmax for XC7K480T.

Behavioral SystemVerilog and synthesizable RTL are both HDL. In this project,
"behavioral HDL" means the simple correctness oracle, while "RTL" means the
clocked, pipelined implementation intended for FPGA synthesis.
