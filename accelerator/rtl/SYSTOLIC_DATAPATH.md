# Timing-realistic systolic datapath

`systolic_pe_int8.sv` is the physical unit of replication. Each PE registers
the activation moving east and weight moving south, while retaining a signed
32-bit output-stationary accumulator. A MAC occurs only when both valid inputs
are asserted. `step=0` freezes movement, valid bits, and accumulation together;
`clear` has priority over `step`.

`systolic_array_int8.sv` composes an `N x N` mesh without broadcasts inside
the array. At `N=32` it contains 1,024 signed INT8 MACs. Inputs and results are
flat packed buses so the modules work with Icarus Verilog and Vivado.

The driving controller must skew matrix operands. For reduction index `k`,
row `r` injects `A[r,k]` at cycle `k+r`; column `c` injects `B[k,c]` at cycle
`k+c`. Invalid cycles are bubbles. After the final injection, allow the
wavefront to drain before sampling all accumulators. Pulse `clear` for one
cycle between output tiles; do not assert it during useful data.

This layer intentionally contains no scratchpad or combinational N-way memory
read. Its routed timing is therefore representative of the array datapath,
although full-accelerator Fmax must also include its feeder and result path.
