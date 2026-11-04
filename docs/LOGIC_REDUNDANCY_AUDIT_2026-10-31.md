# Read-only logic redundancy audit

Source: `arm_custom_subset.circ` at commit `550515e`.
SHA-256: `59bd2ea775fa52e50fd0379e528e4de5dac893f4b97556eba7848d9ebca108ba`.
The master was not edited. This is a structural audit, not a new Logisim regression pass or an exhaustive proof of minimal hardware.

## Concrete opportunities

| Circuit / visual landmark | Evidence | Possible cleanup |
| --- | --- | --- |
| `stage_EX`: immediate-shift repair near `IMM_SHIFT32_ACTIVE` | NOT gates at (1370,3730) and (2650,2700) both invert the same `imm_b` / `imm_bit` net. | Share one inverted signal through a named tunnel, retaining both consumers. Saves one NOT. |
| `stage_EX`: same repair group | NOT gates at (1370,3750) and (2620,2650) both invert `reg_shift` / `reg_shift_edge`. The repair copy feeds the four-input AND through the wire ending at (1410,3750). | Share one inverted register-shift signal. Saves one NOT. |
| `stage_EX`: `RS_EQ_0` probe versus `REG_ZERO` | Comparators at (810,2900) and (1490,3190) receive the same `RS_AMOUNT8` net and equal-width zero constants. The first equality output feeds only the `RS_EQ_0` probe; the second feeds `REG_ZERO` and functional mux selections. Both other comparator outputs are unused. | Feed the diagnostic probe from `REG_ZERO`; remove its duplicate comparator and zero constant. Keep the functional comparison. |
| `stage_MEM`: `s_bit` / `s_b` control | NOT gates at (1050,2180) and (840,1100) invert the same input net and feed different AND gates. | Share one inversion, retaining all consumers. Saves one NOT. |
| `stage_EX`: probes `IS_LSR`, `IS_ASR`, OR `IS_LSR_OR_ASR` | Two 2-bit comparators test `s_type == 1` and `s_type == 2`; only equality outputs are consumed, by probes and the OR. | For the functional OR result, use `s_type[1] XOR s_type[0]`. This replaces two comparators, two constants and an OR with a splitter and XOR, if the individual debug predicates are no longer needed. |

The final identity was checked over all four two-bit inputs: 00 -> 0, 01 -> 1, 10 -> 1, 11 -> 0. This proves the local Boolean replacement only. Sharing inversions preserves Boolean values, but changes fanout and transient propagation; validate the edited circuit before accepting it.

The first four opportunities remove three NOT gates and one diagnostic comparator plus its constant. These are modest savings, not evidence of a fundamentally wasteful datapath. Keeping local inversions can also improve diagram readability. No FPGA resource saving is measured here.

## Library clutter versus instantiated logic

There are 43 circuit definitions; 27 are reachable through subcircuit instances starting at `main`. These 16 are not reachable:

`ALU_arithmetic_engine_1`, `PE_cell_32`, `PE_cell_8`, `PE_cell_FP`, `a_invert`, `csa_16`, `kogge_stone_2b`, `ks_4b`, `mul_8`, `pp_8`, `pp_row_16`, `reg16x32`, `systolic_16x16_int8`, `systolic_4x4`, `systolic_4x4_int8`, `systolic_int8_8x8`.

They are candidates for a separate archive/library, not automatically mistakes. Some represent accelerator work. Removing unused definitions cleans the project browser but does not remove hardware instantiated by `main`.

Repeated register read muxes implement separate read ports; do not merge them merely because their circuits match. Similarly, fetching instructions and reading program literals require separate access paths. Unused exported pins do not establish that the internal logic producing them is dead. Incomplete multiplier wiring must be treated as unfinished functionality rather than removed as redundant logic.

## Method and limits

Parsed the saved XML, walked the instance graph, and compared simple gates/comparators by operation, attributes and connected input nets, including tunnel equivalence and equal constants. Traced consumers of the reported candidates. This was connectivity analysis, not Python CPU simulation.

The local geometry helper has known limitations, especially four-input gates. In particular, its missing consumer on the repair NOT output must not be interpreted as a disconnected gate: the XML wire reaches the actual four-input AND input. No general dead-wire claim is made from this helper.

Next priority: establish the current flag-fix regression result and resolve remaining functional defects before simplifying the layout. For any later cleanup, use a disposable copy and rerun direct Logisim shift boundary/carry tests and memory/flag tests before making equivalent manual changes to the master.
