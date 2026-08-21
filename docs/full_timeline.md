date        commit     circ  comps  wires  what changed
------------------------------------------------------------------------------------------------------------
2026-06-28  05674909      6    264   1578  initial import
2026-06-28  ffa4b136      7    271   1585  +circuit ks_32_sub; ks_32b (+1 comps, +5 wires); main (-4 comps, -41 w
2026-07-05  357fc09e     11    333   1789  +circuit ALU; +circuit ALU_airthmetic_engine; +circuit ALU_logic_engin
2026-07-08  1c23bdfb     14    519   2063  +circuit csa_3to_2; +circuit csa_reduction_chain; +circuit pp_row … +2
2026-07-09  4aa79644     16    592   2557  +circuit pc_fetch; +circuit reg16x32
2026-07-09  87c8cdae     19    699   2882  +circuit PE_cell; +circuit matmul4x4; +circuit pp_row_32 … +2 more
2026-07-09  9e894419     23    769   2981  +circuit csa_16; +circuit mul_32; +circuit mul_8 … +4 more
2026-07-14  76d14f15     23    798   3028  main (+29 comps, +47 wires)
2026-08-04  e9f429c1     30    945   3581  +circuit barrel_32b; +circuit bs_stage_1; +circuit bs_stage_16 … +11 m
2026-08-04  3a291291     30    982   3740  main (+37 comps, +159 wires)
2026-08-05  362f3e0f     30    990   3763  main (+8 comps, +23 wires)
2026-08-05  ae6e944d     30    996   3777  main (+6 comps, +14 wires)
2026-08-06  dc538afa     30   1001   3783  main (+5 comps, +6 wires)
2026-08-10  fc592da2     31   1073   4315  +circuit reg16x32_2
2026-08-13  d32765df     31   1101   4491  +circuit reg16x32_1; -circuit reg16x32_2; main (+4 comps, +28 wires)
2026-08-14  e2ca2fda     32   1187   4763  +circuit block_transfer_control; main (+31 comps, +124 wires); pc_fetc
2026-08-14  6b6814e5     32   1195   4802  block_transfer_control (+7 comps, +39 wires); main (+1 comps)
2026-08-14  73a6174e     32   1197   4810  main (+2 comps, +8 wires)
2026-08-17  593a2cba     32   1197   4808  main (-2 wires)
2026-08-17  ef985e6d     32   1218   4884  block_transfer_control (+21 comps, +76 wires)
2026-08-19  ff094345     32   1230   4985  block_transfer_control (+9 comps, +57 wires); main (+3 comps, +44 wire
2026-08-20  f8234263     32   1235   5002  ALU (-4 wires); block_transfer_control (+2 comps); main (+3 comps, +21
2026-08-20  852bfe14     33   1257   5034  +circuit ALU_arithmetic_engine; +circuit ALU_arithmetic_engine_1; -cir
2026-08-20  bd794b0b     33   1261   5065  block_transfer_control (+2 comps, +20 wires); main (+2 comps, +11 wire
------------------------------------------------------------------------------------------------------------
24 revisions of armv4t.circ from 2026-06-28 to 2026-08-20
grew from 264 to 1261 components (+997), 1578 to 5065 wires (+3487), 6 to 33 subcircuits
