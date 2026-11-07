# D2 master verification

The user manually completed D2 in `arm_custom_subset.circ`.

Tested SHA-256: `0cff847845b6d324276c266dbff70c3b2d833c647a4be7b92bc2ff3e9236eea1`. The master was read-only throughout testing.

Direct Logisim results: **53/53 regression programs pass** and **33/33 pattern checks pass** (32 data/address checks plus completion marker). Patterns cover six RAM values at all four offsets, ROM loads at all four offsets, and pre/post-index writeback. Regression covers byte/halfword accesses, flags and PC/stack returns.

Evidence: `build/d2_2026-11-07/manual_verified/`, including frozen source, assembly, logs, RAM dumps and JSON results.

D2 is verified in the saved master for this coverage. The separate RAM/VHDL byte-enable issue remains; VHDL was not rerun here. Multiply, swap and broader ARMv4T coverage are not certified by these tests.
