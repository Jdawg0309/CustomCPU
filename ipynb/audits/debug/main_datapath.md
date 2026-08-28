# `main` datapath/memory audit — `debug_armv4t.circ`

## 1. Identity and purpose

- **Source:** `debug_armv4t.circ`; **circuit:** `main`.
- **Scope:** PC/fetch boundary, instruction/data memories, register-file ports, operand selection, barrel shifter, ALU data and NZCV paths, address generation, load/store, block-transfer datapath, writeback, state holders, and diagnostic outputs.
- **Evidence convention:** raw XML/component/wire topology and graph counts are **measured**. Architectural names and purposes are **inferred** unless a component/pin label states them. Anything the geometry model cannot represent is **unresolved**, never silently treated as a circuit fault.
- **Representation:** the complete circuit is a graph, not a tree. The net ledger below is the lossless bipartite port/net view; endpoint paths are directed derived views.

## 2. Interface

| Interface pin | Dir | Width | Facing | Role / attached net | Confidence |
|---|---:|---:|---|---|---|
| `Pin@5930,8290.p` | out | 1 | west | block-transfer phase_reg_q diagnostic; n056 `net#56` | role: inferred |
| `Pin@9350,8660.p` | out | 32 | west | ALU result diagnostic; n108 `net#108` | role: inferred |
| `Pin@10280,8690[branch_taken].p` | out | 1 | west | branch_taken; n007 `net:branch_taken` | role: measured |
| `Pin@5050,8750.p` | in | 1 | east | RST input; n030 `net:CSPR/pc_pending` | role: inferred |
| `Pin@10020,8760[condition_pass].p` | out | 1 | west | condition_pass; n003 `net:CSPR_enable/bx_taken` | role: measured |
| `Pin@8530,8960.p` | out | 32 | west | R0_OUTPUT diagnostic; n240 `net#240` | role: inferred |
| `Pin@8530,8980.p` | out | 32 | west | R1_OUTPUT diagnostic; n241 `net#241` | role: inferred |
| `Pin@8530,9000.p` | out | 32 | west | R3_OUTPUT diagnostic; n242 `net#242` | role: inferred |
| `Pin@8530,9020.p` | out | 32 | west | R2_OUPUT diagnostic; n243 `net#243` | role: inferred |
| `Pin@8530,9040.p` | out | 32 | west | R5_OUTPUT diagnostic; n244 `net#244` | role: inferred |
| `Pin@8530,9060.p` | out | 32 | west | R4_OUTPUT diagnostic; n245 `net#245` | role: inferred |
| `Pin@9100,9060.p` | out | 32 | west | barrel-shifter output diagnostic; n190 `net#190` | role: inferred |
| `Pin@8770,9080[RD_A].p` | out | 32 | west | RD_A; n032 `net:RD_A` | role: measured |
| `Pin@8530,9100.p` | out | 32 | west | R7_OUTPUT diagnostic; n246 `net#246` | role: inferred |
| `Pin@8530,9120.p` | out | 32 | west | R6_OUTPUT diagnostic; n247 `net#247` | role: inferred |
| `Pin@8620,9140.p` | out | 32 | west | effective RD_B diagnostic; n044 `net:bx_arm_target` | role: inferred |
| `Pin@8530,9160.p` | out | 32 | west | R8_OUTPUT diagnostic; n248 `net#248` | role: inferred |
| `Pin@8530,9180.p` | out | 32 | west | R9_OUTPUT diagnostic; n249 `net#249` | role: inferred |
| `Pin@8530,9200.p` | out | 32 | west | R11_OUTPUT diagnostic; n250 `net#250` | role: inferred |
| `Pin@8530,9220.p` | out | 32 | west | R10_OUTPUT diagnostic; n251 `net#251` | role: inferred |
| `Pin@8530,9240.p` | out | 32 | west | R13_OUTPUT diagnostic; n252 `net#252` | role: inferred |
| `Pin@8530,9260.p` | out | 32 | west | R12_OUTPUT diagnostic; n253 `net#253` | role: inferred |
| `Pin@8530,9280.p` | out | 32 | west | R15_OUTPUT diagnostic; n254 `net#254` | role: inferred |
| `Pin@8530,9300.p` | out | 32 | west | R14_OUTPUT diagnostic; n255 `net#255` | role: inferred |
| `Pin@8060,9560[normal_reg_WE].p` | out | 1 | west | normal_reg_WE; n004 `net:final_reg_we/normal_reg_WE` | role: measured |
| `Pin@6180,9920.p` | out | 1 | west | unlabelled BX/decode diagnostic; n060 `net#60` | role: inferred |
| `Pin@6640,10040[is_BX].p` | out | 1 | west | is_BX; n051 `net:bx_taken/is_BX` | role: measured |
| `Pin@8860,10320[is_BL].p` | out | 1 | west | is_BL; n166 `net:is_BL/not_link` | role: measured |
| `Pin@9080,10370[bl_taken].p` | out | 1 | west | bl_taken; n080 `net:bl_taken/final_reg_we` | role: measured |
| `Pin@8110,10550[mem_class].p` | out | 1 | west | mem_class; n149 `net:mem_class` | role: measured |
| `Pin@8280,10640[is_STR].p` | out | 1 | west | is_STR; n148 `net:data_ram_we/is_STR` | role: measured |
| `Pin@8200,10720[is_LDR].p` | out | 1 | west | is_LDR; n112 `net:is_LDR` | role: measured |
| `Pin@9960,10780.p` | out | 32 | west | RAM data-out diagnostic; n061 `net#61` | role: inferred |
| `Pin@7890,10790[mem_offset].p` | out | 32 | west | mem_offset; n113 `net:mem_offset` | role: measured |
| `Pin@8670,10820[memory_address].p` | out | 32 | west | memory_address; n026 `net:memory_address` | role: measured |
| `Pin@7980,10940[memory_offset_effective].p` | out | 32 | west | memory_offset_effective; n134 `net:memory_offset_effective` | role: measured |
| `Pin@8950,10960[ldr_reg_we].p` | out | 1 | west | ldr_reg_we; n144 `net:ldr_reg_we` | role: measured |

## 3. Inventory

- **Measured:** 245 components, 1072 wire segments, 689 modeled port nodes, 283 electrical nets, 401 directed driver-to-sink edges.

| Component type | Count |
|---|---:|
| `Probe` | 53 |
| `Pin` | 37 |
| `Splitter` | 28 |
| `AND Gate` | 24 |
| `Constant` | 23 |
| `Multiplexer` | 20 |
| `OR Gate` | 16 |
| `NOT Gate` | 11 |
| `Comparator` | 8 |
| `Bit Extender` | 5 |
| `Adder` | 3 |
| `ROM` | 3 |
| `Register` | 3 |
| `Shifter` | 2 |
| `ALU` | 1 |
| `Clock` | 1 |
| `RAM` | 1 |
| `XOR Gate` | 1 |
| `barrel_32b` | 1 |
| `block_transfer_control` | 1 |
| `condition_checker` | 1 |
| `pc_fetch` | 1 |
| `reg16x32_1` | 1 |

## 4. Nets

Every modeled `main` net is listed. `Drivers` is the explicitly directed-output set; `Effective` also includes splitter propagation and unmodelled-memory placeholders. `Sinks/other` contains every remaining attached modeled port. A status of `undriven` around splitters or memories is a graph limitation until reconciled with the raw endpoints in §8.

| Net | Name | Status | Drivers | Effective | Sinks / other attached ports | Confidence |
|---:|---|---|---|---|---|---|
| n000 | `net#0` | ok | `AND Gate@7820,9600.out` | `AND Gate@7820,9600.out` | `OR Gate@8090,9390.in0` | topology measured; direction model-derived |
| n001 | `net:W` | ok | — | `Splitter@6990,10790.bit21` | `AND Gate@7820,9600.in1`<br>`OR Gate@8240,11740.in0`<br>`Probe@7530,11640[W].p`<br>`Splitter@7440,11590.bit3` | topology measured; direction model-derived |
| n002 | `net:done_probe/pc_apply` | ok | `block_transfer_control@5790,8110.done` | `block_transfer_control@5790,8110.done` | `AND Gate@4960,9280[pc_apply].in1`<br>`AND Gate@7820,9600.in0`<br>`Multiplexer@7980,9190.sel`<br>`NOT Gate@4610,9170.in`<br>`OR Gate@6070,7790.in0`<br>`Probe@5990,8150[done_probe].p` | topology measured; direction model-derived |
| n003 | `net:CSPR_enable/bx_taken` | ok | `condition_checker@9860,8760.out0` | `condition_checker@9860,8760.out0` | `AND Gate@10190,8690.in0`<br>`AND Gate@6090,10200[bx_taken].in2`<br>`AND Gate@7430,8200.in1`<br>`AND Gate@8440,11720.in0`<br>`AND Gate@8500,11260.in1`<br>`AND Gate@8910,10780[data_ram_we].in0`<br>`AND Gate@8910,10960.in1`<br>`AND Gate@8950,10370.in0`<br>`AND Gate@9280,8520[CSPR_enable].in0`<br>`AND Gate@9980,8710.in2`<br>`Pin@10020,8760[condition_pass].p`<br>`Probe@8430,10980[condition_pass_probe].p` | topology measured; direction model-derived |
| n004 | `net:final_reg_we/normal_reg_WE` | ok | `AND Gate@9980,8710.out` | `AND Gate@9980,8710.out` | `OR Gate@7880,9410[final_reg_we].in1`<br>`Pin@8060,9560[normal_reg_WE].p` | topology measured; direction model-derived |
| n005 | `net:CSPR_enable` | ok | `NOT Gate@8880,10210.out` | `NOT Gate@8880,10210.out` | `AND Gate@9280,8520[CSPR_enable].in1`<br>`AND Gate@9980,8710.in1` | topology measured; direction model-derived |
| n006 | `net:is_B` | ok | `AND Gate@8910,10280[is_B].out` | `AND Gate@8910,10280[is_B].out` | `AND Gate@10190,8690.in1` | topology measured; direction model-derived |
| n007 | `net:branch_taken` | ok | `AND Gate@10190,8690.out` | `AND Gate@10190,8690.out` | `OR Gate@9280,10390.in1`<br>`Pin@10280,8690[branch_taken].p` | topology measured; direction model-derived |
| n008 | `net#8` | ok | `OR Gate@9280,10390.out` | `OR Gate@9280,10390.out` | `OR Gate@4830,8490.in0` | topology measured; direction model-derived |
| n009 | `net#9` | ok | `Multiplexer@7830,9060.out` | `Multiplexer@7830,9060.out` | `Multiplexer@4910,8690.in1`<br>`Probe@7940,9000.p`<br>`reg16x32_1@8530,8960.WD` | topology measured; direction model-derived |
| n010 | `net:pc_apply/pc_pending` | ok | `Register@4990,9090[pc_pending].Q` | `Register@4990,9090[pc_pending].Q` | `AND Gate@4670,9190.in1`<br>`AND Gate@4960,9280[pc_apply].in0` | topology measured; direction model-derived |
| n011 | `net:pc_defer/pc_target` | ok | `AND Gate@8190,8710.out` | `AND Gate@8190,8710.out` | `AND Gate@4700,9120[pc_defer].in0`<br>`Multiplexer@4910,8690.sel`<br>`OR Gate@4950,8560.in2`<br>`OR Gate@5010,8730.in2`<br>`Probe@4530,8560[pc_write].p`<br>`Probe@4760,8710.p`<br>`Register@5030,8940[pc_target].en` | topology measured; direction model-derived |
| n012 | `net:pc_defer` | ok | `block_transfer_control@5790,8110.hold_pc` | `block_transfer_control@5790,8110.hold_pc` | `AND Gate@4700,9120[pc_defer].in1`<br>`OR Gate@6070,7790.in1`<br>`pc_fetch@5780,8630.hold` | topology measured; direction model-derived |
| n013 | `net#13` | ok | `NOT Gate@4610,9170.out` | `NOT Gate@4610,9170.out` | `AND Gate@4670,9190.in0` | topology measured; direction model-derived |
| n014 | `net#14` | ok | `AND Gate@4670,9190.out` | `AND Gate@4670,9190.out` | `OR Gate@4780,9190.in1` | topology measured; direction model-derived |
| n015 | `net:pc_defer` | ok | `AND Gate@4700,9120[pc_defer].out` | `AND Gate@4700,9120[pc_defer].out` | `OR Gate@4780,9190.in0` | topology measured; direction model-derived |
| n016 | `net:bx_taken` | ok | `AND Gate@6090,10200[bx_taken].out` | `AND Gate@6090,10200[bx_taken].out` | `OR Gate@4830,8490.in1`<br>`OR Gate@5010,8730.in0` | topology measured; direction model-derived |
| n017 | `net:pc_pending` | ok | `OR Gate@4780,9190.out` | `OR Gate@4780,9190.out` | `Register@4990,9090[pc_pending].D` | topology measured; direction model-derived |
| n018 | `net:CSPR/pc_pending` | ok | `Clock@4990,8630.out` | `Clock@4990,8630.out`<br>`RAM@9620,10690.clk` | `Register@4990,9090[pc_pending].clk`<br>`Register@5030,8940[pc_target].clk`<br>`Register@9450,8720[CSPR].clk`<br>`block_transfer_control@5790,8110.clk`<br>`pc_fetch@5780,8630.CLK`<br>`reg16x32_1@8530,8960.CLK` | topology measured; direction model-derived |
| n019 | `net#19` | ok | `OR Gate@4830,8490.out` | `OR Gate@4830,8490.out` | `OR Gate@4950,8560.in0` | topology measured; direction model-derived |
| n020 | `net:pc_apply` | ok | `AND Gate@4960,9280[pc_apply].out` | `AND Gate@4960,9280[pc_apply].out` | `Multiplexer@5040,9360.sel`<br>`OR Gate@4950,8560.in1`<br>`OR Gate@5010,8730.in1` | topology measured; direction model-derived |
| n021 | `net:pc_target` | ok | `Register@5030,8940[pc_target].Q` | `Register@5030,8940[pc_target].Q` | `Multiplexer@5040,9360.in1` | topology measured; direction model-derived |
| n022 | `net:bx_arm_target` | ok | `AND Gate@6090,10270[bx_arm_target].out` | `AND Gate@6090,10270[bx_arm_target].out` | `Multiplexer@4910,8690.in0` | topology measured; direction model-derived |
| n023 | `net:pc_target` | ok | `Multiplexer@4910,8690.out` | `Multiplexer@4910,8690.out` | `Multiplexer@5040,9360.in0`<br>`Probe@5020,8970.p`<br>`Register@5030,8940[pc_target].D` | topology measured; direction model-derived |
| n024 | `net#24` | ok | `OR Gate@4950,8560.out` | `OR Gate@4950,8560.out` | `pc_fetch@5780,8630.BRANCH` | topology measured; direction model-derived |
| n025 | `net#25` | ok | `Adder@8640,10400.out` | `Adder@8640,10400.out` | `pc_fetch@5780,8630.IMM` | topology measured; direction model-derived |
| n026 | `net:memory_address` | ok | `Multiplexer@8660,10820.out` | `Multiplexer@8660,10820.out` | `Pin@8670,10820[memory_address].p`<br>`Splitter@5000,12600.combined`<br>`Splitter@8670,10750.combined` | topology measured; direction model-derived |
| n027 | `net#27` | ok | `OR Gate@5010,8730.out` | `OR Gate@5010,8730.out` | `pc_fetch@5780,8630.abs_select` | topology measured; direction model-derived |
| n028 | `net#28` | ok | — | `ROM@5400,12600.addr` | `Splitter@5000,12600.bit1` | topology measured; direction model-derived |
| n029 | `net#29` | ok | — | `Splitter@5000,12600.bit2` | `NOT Gate@5300,12470.in` | topology measured; direction model-derived |
| n030 | `net:CSPR/pc_pending` | ok | `Pin@5050,8750.p` | `Pin@5050,8750.p` | `Register@4990,9090[pc_pending].clr`<br>`Register@5030,8940[pc_target].clr`<br>`Register@9450,8720[CSPR].clr`<br>`block_transfer_control@5790,8110.rst`<br>`pc_fetch@5780,8630.RST`<br>`reg16x32_1@8530,8960.RST` | topology measured; direction model-derived |
| n031 | `net#31` | ok | `Multiplexer@5040,9360.out` | `Multiplexer@5040,9360.out` | `pc_fetch@5780,8630.abs_target` | topology measured; direction model-derived |
| n032 | `net:RD_A` | ok | `Multiplexer@9480,11950.out` | `Multiplexer@9480,11950.out` | `ALU@9190,8660.A`<br>`Adder@8450,10820.a`<br>`Multiplexer@8550,10810.in0`<br>`Pin@8770,9080[RD_A].p`<br>`Probe@8380,10730.p`<br>`block_transfer_control@5790,8110.base_value` | topology measured; direction model-derived |
| n033 | `net#33` | ok | `block_transfer_control@5790,8110.store_enable` | `block_transfer_control@5790,8110.store_enable` | `OR Gate@9080,11410.in1` | topology measured; direction model-derived |
| n034 | `net:active_probe` | ok | `block_transfer_control@5790,8110.active` | `block_transfer_control@5790,8110.active` | `Multiplexer@7870,8780.sel`<br>`Multiplexer@8070,8830.sel`<br>`Multiplexer@8660,10820.sel`<br>`Probe@5990,8130[active_probe].p` | topology measured; direction model-derived |
| n035 | `net#35` | ok | `block_transfer_control@5790,8110.transfer_address` | `block_transfer_control@5790,8110.transfer_address` | `Multiplexer@8660,10820.in1` | topology measured; direction model-derived |
| n036 | `net#36` | ok | `NOT Gate@5300,12470.out` | `NOT Gate@5300,12470.out` | `Multiplexer@6200,12600.sel` | topology measured; direction model-derived |
| n037 | `net#37` | ok | — | `Splitter@6590,8010.bit0` | `Probe@5350,8190.p`<br>`block_transfer_control@5790,8110.reg_list_in` | topology measured; direction model-derived |
| n038 | `net:is_pop` | ok | `AND Gate@8470,8040.out` | `AND Gate@8470,8040.out` | `OR Gate@8650,8060.in0`<br>`Probe@8540,8040[is_pop].p`<br>`block_transfer_control@5790,8110.is_pop` | topology measured; direction model-derived |
| n039 | `net:start` | ok | `OR Gate@8650,8060.out` | `OR Gate@8650,8060.out` | `Probe@8720,8060[start].p`<br>`block_transfer_control@5790,8110.start` | topology measured; direction model-derived |
| n040 | `net:U` | ok | — | `Splitter@6990,10790.bit23` | `NOT Gate@7640,11680.in`<br>`Probe@7530,11720[U].p`<br>`Splitter@7440,11590.bit1`<br>`block_transfer_control@5790,8110.U` | topology measured; direction model-derived |
| n041 | `net:P` | ok | — | `Splitter@6990,10790.bit24` | `Multiplexer@8550,10810.sel`<br>`NOT Gate@8170,11760.in`<br>`Probe@7530,11760[P].p`<br>`Splitter@7440,11590.bit0`<br>`block_transfer_control@5790,8110.P` | topology measured; direction model-derived |
| n042 | `net#42` | ok | — | `Splitter@6600,8680.combined`<br>`Splitter@7740,9970.combined` | `Splitter@5580,10000.combined`<br>`Splitter@6590,8010.combined`<br>`Splitter@6950,10430.combined`<br>`Splitter@6990,10790.combined` | topology measured; direction model-derived |
| n043 | `net#43` | ok | — | `Splitter@5580,10000.bit1` | `Comparator@5780,10040.a` | topology measured; direction model-derived |
| n044 | `net:bx_arm_target` | ok | `Multiplexer@9480,12190.out` | `Multiplexer@9480,12190.out`<br>`RAM@9620,10690.we` | `AND Gate@6090,10270[bx_arm_target].in0`<br>`Multiplexer@8820,9130.in0`<br>`Pin@8620,9140.p`<br>`Splitter@5660,10210.combined` | topology measured; direction model-derived |
| n045 | `net#45` | undriven | — | — | `Multiplexer@6200,12600.in1` | topology measured; direction model-derived |
| n046 | `net#46` | ok | — | `Splitter@5660,10210.bit0` | `NOT Gate@5770,10190.in` | topology measured; direction model-derived |
| n047 | `net#47` | ok | `Constant@5710,10050.p` | `Constant@5710,10050.p` | `Comparator@5780,10040.b` | topology measured; direction model-derived |
| n048 | `net#48` | ok | `pc_fetch@5780,8630.pc_out` | `ROM@5890,8620.addr`<br>`pc_fetch@5780,8630.pc_out` | `Bit Extender@8900,11780.in`<br>`Probe@5940,8530.p` | topology measured; direction model-derived |
| n049 | `net#49` | ok | `pc_fetch@5780,8630.pc_plus4` | `pc_fetch@5780,8630.pc_plus4` | `Multiplexer@7510,9000.in1`<br>`Probe@5760,8770.p` | topology measured; direction model-derived |
| n050 | `net:bx_taken` | ok | `NOT Gate@5770,10190.out` | `NOT Gate@5770,10190.out` | `AND Gate@6090,10200[bx_taken].in1` | topology measured; direction model-derived |
| n051 | `net:bx_taken/is_BX` | ok | `Comparator@5780,10040.eq` | `Comparator@5780,10040.eq` | `AND Gate@6090,10200[bx_taken].in0`<br>`OR Gate@8570,10210.in0`<br>`Pin@6640,10040[is_BX].p` | topology measured; direction model-derived |
| n052 | `net:reg_idx_probe` | ok | `block_transfer_control@5790,8110.reg_idx` | `block_transfer_control@5790,8110.reg_idx` | `Multiplexer@7870,8780.in1`<br>`Multiplexer@8070,8830.in1`<br>`Probe@5990,8170[reg_idx_probe].p` | topology measured; direction model-derived |
| n053 | `net:reg_selected_probe` | ok | `block_transfer_control@5790,8110.reg_selected` | `block_transfer_control@5790,8110.reg_selected` | `Probe@5990,8190[reg_selected_probe].p` | topology measured; direction model-derived |
| n054 | `net#54` | ok | `block_transfer_control@5790,8110.final_address` | `block_transfer_control@5790,8110.final_address` | `Multiplexer@7980,9190.in1` | topology measured; direction model-derived |
| n055 | `net:load_enable_probe` | ok | `block_transfer_control@5790,8110.load_enable` | `block_transfer_control@5790,8110.load_enable` | `Multiplexer@7890,9250.in1`<br>`OR Gate@7640,9560.in0`<br>`Probe@5970,8270[load_enable_probe].p` | topology measured; direction model-derived |
| n056 | `net#56` | ok | `block_transfer_control@5790,8110.phase_reg_q` | `block_transfer_control@5790,8110.phase_reg_q` | `Pin@5930,8290.p` | topology measured; direction model-derived |
| n057 | `net:bx_arm_target` | ok | `Constant@5850,10290.p` | `Constant@5850,10290.p` | `AND Gate@6090,10270[bx_arm_target].in1` | topology measured; direction model-derived |
| n058 | `net#58` | ok | — | `Splitter@7850,8880.bit2` | `Splitter@6090,9900.combined`<br>`Splitter@6600,8680.bit5` | topology measured; direction model-derived |
| n059 | `net#59` | ok | `OR Gate@6070,7790.out` | `OR Gate@6070,7790.out` | — | topology measured; direction model-derived |
| n060 | `net#60` | ok | — | `Splitter@6090,9900.bit1` | `AND Gate@8510,10300.in1`<br>`Pin@6180,9920.p` | topology measured; direction model-derived |
| n061 | `net#61` | undriven | — | — | `Multiplexer@6200,12600.in0`<br>`Pin@9960,10780.p` | topology measured; direction model-derived |
| n062 | `net#62` | ok | `Multiplexer@6200,12600.out` | `Multiplexer@6200,12600.out` | `Multiplexer@7670,9060.in1` | topology measured; direction model-derived |
| n063 | `net:block_class_bits` | ok | — | `Splitter@6940,8140.combined` | `Comparator@7290,8150.a`<br>`Probe@6380,8140[block_class_bits].p` | topology measured; direction model-derived |
| n064 | `net:sbwe` | ok | `AND Gate@8440,11720.out` | `AND Gate@8440,11720.out` | `Multiplexer@7800,8780.sel`<br>`Multiplexer@7830,9060.sel`<br>`OR Gate@7880,9300.in0`<br>`Probe@8530,11720[sbwe].p` | topology measured; direction model-derived |
| n065 | `net#65` | ok | — | `Splitter@6600,8680.bit0` | `Multiplexer@8020,8730.in0` | topology measured; direction model-derived |
| n066 | `net#66` | ok | — | `Splitter@6600,8680.bit1` | `Splitter@7800,9870.combined` | topology measured; direction model-derived |
| n067 | `net#67` | ok | — | `Splitter@6600,8680.bit2` | `Multiplexer@7710,8780.in0`<br>`Multiplexer@8020,8730.in1` | topology measured; direction model-derived |
| n068 | `net#68` | ok | — | `Splitter@6600,8680.bit3` | `Comparator@8260,8280.b`<br>`Comparator@9220,12130.a`<br>`Multiplexer@7800,8780.in1`<br>`Probe@7580,8810.p`<br>`Probe@7860,9080.p`<br>`reg16x32_1@8530,8960.RA` | topology measured; direction model-derived |
| n069 | `net:CSPR_enable` | ok | — | `Splitter@6600,8680.bit4` | `AND Gate@8170,10720.in1`<br>`AND Gate@9280,8520[CSPR_enable].in2`<br>`NOT Gate@7700,10660.in` | topology measured; direction model-derived |
| n070 | `net#70` | ok | — | `Splitter@6600,8680.bit6` | `Splitter@6670,8280.combined`<br>`Splitter@7810,10130.combined` | topology measured; direction model-derived |
| n071 | `net#71` | ok | — | `Splitter@6940,8200.combined` | `Probe@6650,8200.p` | topology measured; direction model-derived |
| n072 | `net#72` | ok | — | `Splitter@6670,8280.bit0` | `Splitter@6940,8140.bit2` | topology measured; direction model-derived |
| n073 | `net#73` | ok | — | `Splitter@6670,8280.bit1` | `Splitter@6940,8140.bit1` | topology measured; direction model-derived |
| n074 | `net#74` | ok | — | `Splitter@6670,8280.bit2` | `Splitter@6940,8140.bit0` | topology measured; direction model-derived |
| n075 | `net#75` | ok | — | `Splitter@6670,8280.bit3` | `Splitter@6940,8200.bit3` | topology measured; direction model-derived |
| n076 | `net#76` | ok | — | `Splitter@6670,8280.bit4` | `Splitter@6940,8200.bit2` | topology measured; direction model-derived |
| n077 | `net#77` | ok | — | `Splitter@6670,8280.bit5` | `Splitter@6940,8200.bit1` | topology measured; direction model-derived |
| n078 | `net#78` | ok | — | `Splitter@6670,8280.bit6` | `Splitter@6940,8200.bit0` | topology measured; direction model-derived |
| n079 | `net#79` | ok | — | `Splitter@6950,10430.bit0` | `Bit Extender@8150,10380.in`<br>`Probe@7820,10380.p` | topology measured; direction model-derived |
| n080 | `net:bl_taken/final_reg_we` | ok | `AND Gate@8950,10370.out` | `AND Gate@8950,10370.out` | `Multiplexer@7510,9000.sel`<br>`Multiplexer@7710,8780.sel`<br>`OR Gate@7880,9410[final_reg_we].in0`<br>`OR Gate@9280,10390.in0`<br>`Pin@9080,10370[bl_taken].p` | topology measured; direction model-derived |
| n081 | `net#81` | ok | — | `Splitter@6990,10790.bit0` | `Splitter@7170,10790.bit11` | topology measured; direction model-derived |
| n082 | `net#82` | ok | — | `Splitter@6990,10790.bit1` | `Splitter@7170,10790.bit10` | topology measured; direction model-derived |
| n083 | `net#83` | ok | — | `Splitter@6990,10790.bit2` | `Splitter@7170,10790.bit9` | topology measured; direction model-derived |
| n084 | `net#84` | ok | — | `Splitter@6990,10790.bit3` | `Splitter@7170,10790.bit8` | topology measured; direction model-derived |
| n085 | `net#85` | ok | — | `Splitter@6990,10790.bit4` | `Splitter@7170,10790.bit7` | topology measured; direction model-derived |
| n086 | `net#86` | ok | — | `Splitter@6990,10790.bit5` | `Splitter@7170,10790.bit6` | topology measured; direction model-derived |
| n087 | `net#87` | ok | — | `Splitter@6990,10790.bit6` | `Splitter@7170,10790.bit5` | topology measured; direction model-derived |
| n088 | `net#88` | ok | — | `Splitter@6990,10790.bit7` | `Splitter@7170,10790.bit4` | topology measured; direction model-derived |
| n089 | `net#89` | ok | — | `Splitter@6990,10790.bit8` | `Splitter@7170,10790.bit3` | topology measured; direction model-derived |
| n090 | `net#90` | ok | — | `Splitter@6990,10790.bit9` | `Splitter@7170,10790.bit2` | topology measured; direction model-derived |
| n091 | `net#91` | ok | — | `Splitter@6990,10790.bit10` | `Splitter@7170,10790.bit1` | topology measured; direction model-derived |
| n092 | `net#92` | ok | — | `Splitter@6990,10790.bit11` | `Splitter@7170,10790.bit0` | topology measured; direction model-derived |
| n093 | `net#93` | ok | — | `Splitter@6990,10790.bit12` | `Splitter@7170,11270.bit3` | topology measured; direction model-derived |
| n094 | `net#94` | ok | — | `Splitter@6990,10790.bit13` | `Splitter@7170,11270.bit2` | topology measured; direction model-derived |
| n095 | `net#95` | ok | — | `Splitter@6990,10790.bit14` | `Splitter@7170,11270.bit1` | topology measured; direction model-derived |
| n096 | `net#96` | ok | — | `Splitter@6990,10790.bit15` | `Splitter@7170,11270.bit0` | topology measured; direction model-derived |
| n097 | `net#97` | ok | — | `Splitter@6990,10790.bit16` | `Splitter@7170,11430.bit3` | topology measured; direction model-derived |
| n098 | `net#98` | ok | — | `Splitter@6990,10790.bit17` | `Splitter@7170,11430.bit2` | topology measured; direction model-derived |
| n099 | `net#99` | ok | — | `Splitter@6990,10790.bit18` | `Splitter@7170,11430.bit1` | topology measured; direction model-derived |
| n100 | `net#100` | ok | — | `Splitter@6990,10790.bit19` | `Splitter@7170,11430.bit0` | topology measured; direction model-derived |
| n101 | `net:L` | ok | — | `Splitter@6990,10790.bit20` | `AND Gate@8470,8040.in1`<br>`NOT Gate@8000,8420.in`<br>`Probe@7530,11600[L].p`<br>`Splitter@7440,11590.bit4` | topology measured; direction model-derived |
| n102 | `net:B` | ok | — | `Splitter@6990,10790.bit22` | `Probe@7530,11680[B].p`<br>`Splitter@7440,11590.bit2` | topology measured; direction model-derived |
| n103 | `net#103` | ok | — | `Splitter@7170,10790.combined` | `Bit Extender@7650,10790.in` | topology measured; direction model-derived |
| n104 | `net:memory_rn` | ok | — | `Splitter@7170,11430.combined` | `Probe@7370,11450[memory_rn].p`<br>`reg16x32_1@8530,8960.WA2` | topology measured; direction model-derived |
| n105 | `net:mode` | ok | — | `Splitter@7440,11590.combined` | `Comparator@7840,8250.b`<br>`Comparator@7840,8320.b`<br>`Probe@7710,8510[mode].p` | topology measured; direction model-derived |
| n106 | `net:block_transfer` | ok | `Comparator@7290,8150.eq` | `Comparator@7290,8150.eq` | `AND Gate@7430,8200.in0`<br>`Probe@7630,8180[block_transfer].p` | topology measured; direction model-derived |
| n107 | `net:block_transfer_valid` | ok | `AND Gate@7430,8200.out` | `AND Gate@7430,8200.out` | `AND Gate@8080,8040.in0`<br>`AND Gate@8470,8040.in0`<br>`Probe@7630,8230[block_transfer_valid].p` | topology measured; direction model-derived |
| n108 | `net#108` | ok | `ALU@9190,8660.result` | `ALU@9190,8660.result` | `Multiplexer@7510,9000.in0`<br>`Pin@9350,8660.p` | topology measured; direction model-derived |
| n109 | `net#109` | ok | `Multiplexer@7510,9000.out` | `Multiplexer@7510,9000.out` | `Multiplexer@7670,9060.in0`<br>`Probe@7610,9000.p` | topology measured; direction model-derived |
| n110 | `net#110` | ok | `NOT Gate@7640,11680.out` | `NOT Gate@7640,11680.out` | `Adder@8450,10820.cin`<br>`Bit Extender@7700,11030.in` | topology measured; direction model-derived |
| n111 | `net#111` | ok | `OR Gate@7640,9560.out` | `OR Gate@7640,9560.out` | `Multiplexer@7670,9060.sel` | topology measured; direction model-derived |
| n112 | `net:is_LDR` | ok | `AND Gate@8170,10720.out` | `AND Gate@8170,10720.out` | `AND Gate@8500,11260.in0`<br>`AND Gate@8910,10960.in0`<br>`OR Gate@7640,9560.in1`<br>`Pin@8200,10720[is_LDR].p` | topology measured; direction model-derived |
| n113 | `net:mem_offset` | ok | `Bit Extender@7650,10790.out` | `Bit Extender@7650,10790.out` | `Pin@7890,10790[mem_offset].p`<br>`XOR Gate@7830,10910.in0` | topology measured; direction model-derived |
| n114 | `net#114` | ok | `Constant@7670,8790.p` | `Constant@7670,8790.p` | `Multiplexer@7710,8780.in1` | topology measured; direction model-derived |
| n115 | `net#115` | ok | `Multiplexer@7670,9060.out` | `Multiplexer@7670,9060.out` | `Multiplexer@7830,9060.in0` | topology measured; direction model-derived |
| n116 | `net:memory_up_base` | ok | `Adder@8450,10820.out` | `Adder@8450,10820.out` | `Multiplexer@7830,9060.in1`<br>`Multiplexer@7980,9190.in0`<br>`Multiplexer@8550,10810.in1`<br>`Probe@8460,10660[memory_up_base].p` | topology measured; direction model-derived |
| n117 | `net#117` | ok | `NOT Gate@7700,10660.out` | `NOT Gate@7700,10660.out` | `AND Gate@8170,10640.in1` | topology measured; direction model-derived |
| n118 | `net#118` | ok | `Bit Extender@7700,11030.out` | `Bit Extender@7700,11030.out` | `XOR Gate@7830,10910.in1` | topology measured; direction model-derived |
| n119 | `net#119` | ok | `Multiplexer@7710,8780.out` | `Multiplexer@7710,8780.out` | `Multiplexer@7800,8780.in0` | topology measured; direction model-derived |
| n120 | `net#120` | ok | — | `Splitter@7910,10030.bit0` | `Splitter@7740,9970.bit1` | topology measured; direction model-derived |
| n121 | `net#121` | ok | — | `Splitter@7740,9970.bit2` | `Multiplexer@8120,10040.sel`<br>`Multiplexer@8660,10040.sel`<br>`Multiplexer@8820,9130.sel` | topology measured; direction model-derived |
| n122 | `net#122` | ok | `Multiplexer@7800,8780.out` | `Multiplexer@7800,8780.out` | `Multiplexer@7870,8780.in0` | topology measured; direction model-derived |
| n123 | `net#123` | ok | `Bit Extender@7800,9980.out` | `Bit Extender@7800,9980.out` | `Multiplexer@8820,9130.in1` | topology measured; direction model-derived |
| n124 | `net#124` | ok | — | `Splitter@7810,10130.bit0` | `Splitter@7810,10230.combined` | topology measured; direction model-derived |
| n125 | `net#125` | ok | `Constant@7810,8930.p` | `Constant@7810,8930.p` | `Splitter@7850,8880.bit1` | topology measured; direction model-derived |
| n126 | `net#126` | ok | `Constant@7810,8970.p` | `Constant@7810,8970.p` | `Splitter@7850,8880.bit0` | topology measured; direction model-derived |
| n127 | `net#127` | ok | — | `Splitter@7800,9870.bit0` | `Probe@7850,9860.p` | topology measured; direction model-derived |
| n128 | `net#128` | ok | — | `Splitter@7800,9870.bit1` | `Multiplexer@8660,10040.in0`<br>`Probe@7870,9910.p` | topology measured; direction model-derived |
| n129 | `net#129` | ok | — | `Splitter@7800,9870.bit2` | `Multiplexer@8120,10040.in0`<br>`Probe@7930,9940.p` | topology measured; direction model-derived |
| n130 | `net#130` | ok | — | `Splitter@7810,10130.bit1` | `Probe@9630,8890.p`<br>`condition_checker@9860,8760.cond` | topology measured; direction model-derived |
| n131 | `net:branch_class` | ok | — | `Splitter@7810,10230.bit0` | `AND Gate@8390,10260[branch_class].in0` | topology measured; direction model-derived |
| n132 | `net#132` | ok | — | `Splitter@7810,10230.bit1` | `AND Gate@8010,10550.in0`<br>`NOT Gate@8070,10260.in`<br>`Probe@8010,10260.p` | topology measured; direction model-derived |
| n133 | `net:branch_class` | ok | — | `Splitter@7810,10230.bit2` | `AND Gate@8390,10260[branch_class].in2`<br>`NOT Gate@7910,10310.in`<br>`Probe@8110,10280.p` | topology measured; direction model-derived |
| n134 | `net:memory_offset_effective` | ok | `XOR Gate@7830,10910.out` | `XOR Gate@7830,10910.out` | `Adder@8450,10820.b`<br>`Pin@7980,10940[memory_offset_effective].p` | topology measured; direction model-derived |
| n135 | `net:push_mode` | ok | `Comparator@7840,8250.eq` | `Comparator@7840,8250.eq` | `Probe@7930,8250[push_mode].p` | topology measured; direction model-derived |
| n136 | `net:pop_mode` | ok | `Comparator@7840,8320.eq` | `Comparator@7840,8320.eq` | `Probe@7930,8320[pop_mode].p` | topology measured; direction model-derived |
| n137 | `net#137` | ok | — | `ROM@8230,8620.addr` | `Splitter@7850,8880.combined` | topology measured; direction model-derived |
| n138 | `net#138` | ok | `Multiplexer@7870,8780.out` | `Multiplexer@7870,8780.out` | `Comparator@8110,8700.b`<br>`Probe@7880,8910.p`<br>`Probe@8120,8980.p`<br>`reg16x32_1@8530,8960.WA` | topology measured; direction model-derived |
| n139 | `net#139` | ok | `OR Gate@7880,9300.out` | `OR Gate@7880,9300.out` | `Multiplexer@7890,9250.in0` | topology measured; direction model-derived |
| n140 | `net:final_reg_we` | ok | `OR Gate@7880,9410[final_reg_we].out` | `OR Gate@7880,9410[final_reg_we].out` | `OR Gate@7900,9350.in0` | topology measured; direction model-derived |
| n141 | `net#141` | ok | `Multiplexer@7890,9250.out` | `Multiplexer@7890,9250.out` | `AND Gate@8190,8710.in1`<br>`reg16x32_1@8530,8960.WE` | topology measured; direction model-derived |
| n142 | `net#142` | ok | — | `Splitter@7910,10030.combined` | `Multiplexer@8120,10040.in1` | topology measured; direction model-derived |
| n143 | `net#143` | ok | `NOT Gate@7910,10310.out` | `NOT Gate@7910,10310.out` | `AND Gate@8010,10550.in1` | topology measured; direction model-derived |
| n144 | `net:ldr_reg_we` | ok | `AND Gate@8910,10960.out` | `AND Gate@8910,10960.out` | `OR Gate@7900,9350.in1`<br>`Pin@8950,10960[ldr_reg_we].p` | topology measured; direction model-derived |
| n145 | `net:rn_is_sp` | ok | `Comparator@8260,8280.eq` | `Comparator@8260,8280.eq` | `Probe@8400,8280[rn_is_sp].p` | topology measured; direction model-derived |
| n146 | `net#146` | ok | `Multiplexer@7980,9190.out` | `Multiplexer@7980,9190.out` | `Probe@8130,9060.p`<br>`reg16x32_1@8530,8960.WD2` | topology measured; direction model-derived |
| n147 | `net#147` | ok | `NOT Gate@8000,8420.out` | `NOT Gate@8000,8420.out` | `AND Gate@8080,8040.in1` | topology measured; direction model-derived |
| n148 | `net:data_ram_we/is_STR` | ok | `AND Gate@8170,10640.out` | `AND Gate@8170,10640.out` | `AND Gate@8440,11720.in1`<br>`AND Gate@8910,10780[data_ram_we].in1`<br>`Multiplexer@8020,8730.sel`<br>`Pin@8280,10640[is_STR].p` | topology measured; direction model-derived |
| n149 | `net:mem_class` | ok | `AND Gate@8010,10550.out` | `AND Gate@8010,10550.out` | `AND Gate@8170,10640.in0`<br>`AND Gate@8170,10720.in0`<br>`OR Gate@8730,10210.in1`<br>`Pin@8110,10550[mem_class].p` | topology measured; direction model-derived |
| n150 | `net#150` | ok | `Multiplexer@8020,8730.out` | `Multiplexer@8020,8730.out` | `Multiplexer@8070,8830.in0` | topology measured; direction model-derived |
| n151 | `net#151` | ok | `Constant@8030,8120.p` | `Constant@8030,8120.p` | `AND Gate@8080,8040.in2` | topology measured; direction model-derived |
| n152 | `net:branch_class` | ok | `NOT Gate@8070,10260.out` | `NOT Gate@8070,10260.out` | `AND Gate@8390,10260[branch_class].in1` | topology measured; direction model-derived |
| n153 | `net#153` | ok | `Multiplexer@8070,8830.out` | `Multiplexer@8070,8830.out` | `Comparator@9220,12250.a`<br>`reg16x32_1@8530,8960.RB` | topology measured; direction model-derived |
| n154 | `net:is_push` | ok | `AND Gate@8080,8040.out` | `AND Gate@8080,8040.out` | `OR Gate@8650,8060.in1`<br>`Probe@8200,8040[is_push].p` | topology measured; direction model-derived |
| n155 | `net#155` | ok | `OR Gate@8090,9390.out` | `OR Gate@8090,9390.out` | `reg16x32_1@8530,8960.WE2` | topology measured; direction model-derived |
| n156 | `net#156` | ok | `Comparator@8110,8700.eq` | `Comparator@8110,8700.eq` | `AND Gate@8190,8710.in0` | topology measured; direction model-derived |
| n157 | `net:load_base_write_enable` | ok | `AND Gate@8500,11260.out` | `AND Gate@8500,11260.out` | `OR Gate@8090,9390.in1`<br>`Probe@8620,11260[load_base_write_enable].p` | topology measured; direction model-derived |
| n158 | `net#158` | ok | `Multiplexer@8120,10040.out` | `Multiplexer@8120,10040.out` | `barrel_32b@9100,9130.amnt` | topology measured; direction model-derived |
| n159 | `net#159` | ok | `Bit Extender@8150,10380.out` | `Bit Extender@8150,10380.out` | `Shifter@8500,10390.in` | topology measured; direction model-derived |
| n160 | `net#160` | ok | `NOT Gate@8170,11760.out` | `NOT Gate@8170,11760.out` | `OR Gate@8240,11740.in1` | topology measured; direction model-derived |
| n161 | `net:wb_requested` | ok | `OR Gate@8240,11740.out` | `OR Gate@8240,11740.out` | `AND Gate@8440,11720.in2`<br>`AND Gate@8500,11260.in2`<br>`Probe@8320,11740[wb_requested].p` | topology measured; direction model-derived |
| n162 | `net:branch_class/is_B` | ok | `AND Gate@8390,10260[branch_class].out` | `AND Gate@8390,10260[branch_class].out` | `AND Gate@8510,10300.in0`<br>`AND Gate@8910,10280[is_B].in0`<br>`OR Gate@8570,10210.in1` | topology measured; direction model-derived |
| n163 | `net#163` | ok | `Constant@8420,8120.p` | `Constant@8420,8120.p` | `AND Gate@8470,8040.in2` | topology measured; direction model-derived |
| n164 | `net#164` | undriven | — | — | `Splitter@8520,8680.combined` | topology measured; direction model-derived |
| n165 | `net#165` | ok | `Shifter@8500,10390.out` | `Shifter@8500,10390.out` | `Adder@8640,10400.a` | topology measured; direction model-derived |
| n166 | `net:is_BL/not_link` | ok | `AND Gate@8510,10300.out` | `AND Gate@8510,10300.out` | `AND Gate@8950,10370.in1`<br>`NOT Gate@8740,10300[not_link].in`<br>`Pin@8860,10320[is_BL].p` | topology measured; direction model-derived |
| n167 | `net#167` | ok | `reg16x32_1@8530,8960.RD_A` | `reg16x32_1@8530,8960.RD_A` | `Multiplexer@9480,11950.in0` | topology measured; direction model-derived |
| n168 | `net#168` | ok | `reg16x32_1@8530,8960.RD_B` | `reg16x32_1@8530,8960.RD_B` | `Multiplexer@9480,12190.in0` | topology measured; direction model-derived |
| n169 | `net#169` | undriven | — | — | `ALU@9190,8660.write_enable`<br>`Splitter@8520,8680.bit0` | topology measured; direction model-derived |
| n170 | `net#170` | undriven | — | — | `ALU@9190,8660.b_inv`<br>`Splitter@8520,8680.bit6` | topology measured; direction model-derived |
| n171 | `net#171` | undriven | — | — | `ALU@9190,8660.a_inv`<br>`Splitter@8520,8680.bit7` | topology measured; direction model-derived |
| n172 | `net#172` | ok | `Multiplexer@8550,10810.out` | `Multiplexer@8550,10810.out` | `Multiplexer@8660,10820.in0` | topology measured; direction model-derived |
| n173 | `net#173` | undriven | — | — | `ALU@9190,8660.logic_sel`<br>`Splitter@8560,8760.combined` | topology measured; direction model-derived |
| n174 | `net#174` | undriven | — | — | `ALU@9190,8660.cin_sel`<br>`Splitter@8560,8800.combined` | topology measured; direction model-derived |
| n175 | `net#175` | undriven | — | — | `ALU@9190,8660.engine_sel`<br>`Probe@8930,8940.p`<br>`Splitter@8560,8880.combined` | topology measured; direction model-derived |
| n176 | `net#176` | ok | `OR Gate@8570,10210.out` | `OR Gate@8570,10210.out` | `OR Gate@8730,10210.in0` | topology measured; direction model-derived |
| n177 | `net#177` | ok | `Multiplexer@8660,10040.out` | `Multiplexer@8660,10040.out` | `barrel_32b@9100,9130.typ` | topology measured; direction model-derived |
| n178 | `net#178` | ok | — | `Splitter@8670,10750.bit0` | `Probe@8820,10660.p` | topology measured; direction model-derived |
| n179 | `net#179` | ok | — | `RAM@9620,10690.addr` | `Probe@8890,10700.p`<br>`Splitter@8670,10750.bit1` | topology measured; direction model-derived |
| n180 | `net#180` | ok | — | `Splitter@8670,10750.bit2` | `Probe@8880,10740.p` | topology measured; direction model-derived |
| n181 | `net#181` | ok | `OR Gate@8730,10210.out` | `OR Gate@8730,10210.out` | `NOT Gate@8880,10210.in` | topology measured; direction model-derived |
| n182 | `net:is_B/not_link` | ok | `NOT Gate@8740,10300[not_link].out` | `NOT Gate@8740,10300[not_link].out` | `AND Gate@8910,10280[is_B].in1` | topology measured; direction model-derived |
| n183 | `net#183` | ok | `Multiplexer@8820,9130.out` | `Multiplexer@8820,9130.out` | `barrel_32b@9100,9130.input_32b` | topology measured; direction model-derived |
| n184 | `net#184` | ok | `Bit Extender@8900,11780.out` | `Bit Extender@8900,11780.out` | `Shifter@9060,11820.in` | topology measured; direction model-derived |
| n185 | `net#185` | ok | `Constant@8900,11850.p` | `Constant@8900,11850.p` | `Shifter@9060,11820.dist` | topology measured; direction model-derived |
| n186 | `net#186` | ok | `Constant@8900,11950.p` | `Constant@8900,11950.p` | `Adder@9220,11950.b` | topology measured; direction model-derived |
| n187 | `net#187` | ok | `Constant@8900,12020.p` | `Constant@8900,12020.p` | `Adder@9220,11950.cin` | topology measured; direction model-derived |
| n188 | `net#188` | ok | `Constant@8900,12130.p` | `Constant@8900,12130.p` | `Comparator@9220,12130.b`<br>`Comparator@9220,12250.b` | topology measured; direction model-derived |
| n189 | `net:data_ram_we` | ok | `AND Gate@8910,10780[data_ram_we].out` | `AND Gate@8910,10780[data_ram_we].out` | `OR Gate@9080,11410.in0` | topology measured; direction model-derived |
| n190 | `net#190` | ok | `barrel_32b@9100,9130.outp` | `barrel_32b@9100,9130.outp` | `ALU@9190,8660.B`<br>`Pin@9100,9060.p` | topology measured; direction model-derived |
| n191 | `net#191` | ok | `Shifter@9060,11820.out` | `Shifter@9060,11820.out` | `Adder@9220,11950.a` | topology measured; direction model-derived |
| n192 | `net#192` | ok | `OR Gate@9080,11410.out` | `OR Gate@9080,11410.out`<br>`RAM@9620,10690.data_in` | — | topology measured; direction model-derived |
| n193 | `net#193` | ok | `ALU@9190,8660.C` | `ALU@9190,8660.C` | `Splitter@9390,8750.bit3` | topology measured; direction model-derived |
| n194 | `net#194` | ok | `ALU@9190,8660.Z` | `ALU@9190,8660.Z` | `Splitter@9390,8750.bit2` | topology measured; direction model-derived |
| n195 | `net#195` | ok | `ALU@9190,8660.N` | `ALU@9190,8660.N` | `Splitter@9390,8750.bit1` | topology measured; direction model-derived |
| n196 | `net#196` | ok | `ALU@9190,8660.V` | `ALU@9190,8660.V` | `Splitter@9390,8750.bit0` | topology measured; direction model-derived |
| n197 | `net#197` | ok | `ALU@9190,8660.write_enable_out` | `ALU@9190,8660.write_enable_out` | `AND Gate@9980,8710.in0` | topology measured; direction model-derived |
| n198 | `net#198` | ok | `Adder@9220,11950.out` | `Adder@9220,11950.out` | `Multiplexer@9480,11950.in1`<br>`Multiplexer@9480,12190.in1` | topology measured; direction model-derived |
| n199 | `net#199` | ok | `Comparator@9220,12130.eq` | `Comparator@9220,12130.eq` | `Multiplexer@9480,11950.sel` | topology measured; direction model-derived |
| n200 | `net#200` | ok | `Comparator@9220,12250.eq` | `Comparator@9220,12250.eq` | `Multiplexer@9480,12190.sel` | topology measured; direction model-derived |
| n201 | `net:CSPR/CSPR_enable` | ok | `AND Gate@9280,8520[CSPR_enable].out` | `AND Gate@9280,8520[CSPR_enable].out` | `Register@9450,8720[CSPR].en` | topology measured; direction model-derived |
| n202 | `net:CSPR` | ok | — | `Splitter@9390,8750.combined` | `Register@9450,8720[CSPR].D` | topology measured; direction model-derived |
| n203 | `net:CSPR` | ok | `Register@9450,8720[CSPR].Q` | `Register@9450,8720[CSPR].Q` | `Splitter@9570,8750.combined` | topology measured; direction model-derived |
| n204 | `net#204` | ok | `Constant@9560,10750.p` | `Constant@9560,10750.p`<br>`RAM@9620,10690.sel` | — | topology measured; direction model-derived |
| n205 | `net#205` | ok | — | `Splitter@9570,8750.bit0` | `condition_checker@9860,8760.N` | topology measured; direction model-derived |
| n206 | `net#206` | ok | — | `Splitter@9570,8750.bit1` | `condition_checker@9860,8760.Z` | topology measured; direction model-derived |
| n207 | `net#207` | ok | — | `Splitter@9570,8750.bit2` | `condition_checker@9860,8760.C` | topology measured; direction model-derived |
| n208 | `net#208` | ok | — | `Splitter@9570,8750.bit3` | `condition_checker@9860,8760.V` | topology measured; direction model-derived |
| n209 | `net#209` | ok | — | `Splitter@5000,12600.bit0` | — | topology measured; direction model-derived |
| n210 | `net#210` | ok | — | `Splitter@5000,12600.bit3` | — | topology measured; direction model-derived |
| n211 | `net#211` | ok | — | `Splitter@5580,10000.bit0` | — | topology measured; direction model-derived |
| n212 | `net#212` | ok | — | `Splitter@5580,10000.bit2` | — | topology measured; direction model-derived |
| n213 | `net#213` | ok | — | `Splitter@5660,10210.bit1` | — | topology measured; direction model-derived |
| n214 | `net#214` | ok | — | `Splitter@6090,9900.bit0` | — | topology measured; direction model-derived |
| n215 | `net#215` | ok | — | `Splitter@6590,8010.bit1` | — | topology measured; direction model-derived |
| n216 | `net#216` | ok | — | `Splitter@6950,10430.bit1` | — | topology measured; direction model-derived |
| n217 | `net#217` | ok | — | `Splitter@6990,10790.bit25` | — | topology measured; direction model-derived |
| n218 | `net#218` | ok | — | `Splitter@6990,10790.bit26` | — | topology measured; direction model-derived |
| n219 | `net#219` | ok | — | `Splitter@6990,10790.bit27` | — | topology measured; direction model-derived |
| n220 | `net#220` | ok | — | `Splitter@6990,10790.bit28` | — | topology measured; direction model-derived |
| n221 | `net#221` | ok | — | `Splitter@6990,10790.bit29` | — | topology measured; direction model-derived |
| n222 | `net#222` | ok | — | `Splitter@6990,10790.bit30` | — | topology measured; direction model-derived |
| n223 | `net#223` | ok | — | `Splitter@6990,10790.bit31` | — | topology measured; direction model-derived |
| n224 | `net#224` | ok | — | `Splitter@7170,11270.combined` | `Probe@7170,11270.p` | topology measured; direction model-derived |
| n225 | `net#225` | ok | `Constant@7250,8160.p` | `Constant@7250,8160.p` | `Comparator@7290,8150.b` | topology measured; direction model-derived |
| n226 | `net#226` | ok | — | `Splitter@7740,9970.bit0` | `Bit Extender@7800,9980.in` | topology measured; direction model-derived |
| n227 | `net#227` | ok | `Constant@7800,8240.p` | `Constant@7800,8240.p` | `Comparator@7840,8250.a` | topology measured; direction model-derived |
| n228 | `net#228` | ok | `Constant@7800,8310.p` | `Constant@7800,8310.p` | `Comparator@7840,8320.a` | topology measured; direction model-derived |
| n229 | `net#229` | ok | `Constant@7890,10000.p` | `Constant@7890,10000.p` | `Splitter@7910,10030.bit1` | topology measured; direction model-derived |
| n230 | `net#230` | ok | `Constant@8070,8690.p` | `Constant@8070,8690.p` | `Comparator@8110,8700.a` | topology measured; direction model-derived |
| n231 | `net#231` | ok | `Constant@8220,8270.p` | `Constant@8220,8270.p` | `Comparator@8260,8280.a` | topology measured; direction model-derived |
| n232 | `net#232` | ok | `Constant@8460,10400.p` | `Constant@8460,10400.p` | `Shifter@8500,10390.dist` | topology measured; direction model-derived |
| n233 | `net#233` | undriven | — | — | `Splitter@8520,8680.bit1`<br>`Splitter@8560,8760.bit2` | topology measured; direction model-derived |
| n234 | `net#234` | undriven | — | — | `Splitter@8520,8680.bit2`<br>`Splitter@8560,8760.bit1` | topology measured; direction model-derived |
| n235 | `net#235` | undriven | — | — | `Splitter@8520,8680.bit3`<br>`Splitter@8560,8760.bit0` | topology measured; direction model-derived |
| n236 | `net#236` | undriven | — | — | `Splitter@8520,8680.bit4`<br>`Splitter@8560,8800.bit1` | topology measured; direction model-derived |
| n237 | `net#237` | undriven | — | — | `Splitter@8520,8680.bit5`<br>`Splitter@8560,8800.bit0` | topology measured; direction model-derived |
| n238 | `net#238` | undriven | — | — | `Splitter@8520,8680.bit8`<br>`Splitter@8560,8880.bit1` | topology measured; direction model-derived |
| n239 | `net#239` | undriven | — | — | `Splitter@8520,8680.bit9`<br>`Splitter@8560,8880.bit0` | topology measured; direction model-derived |
| n240 | `net#240` | ok | `reg16x32_1@8530,8960.R0_OUTPUT` | `reg16x32_1@8530,8960.R0_OUTPUT` | `Pin@8530,8960.p` | topology measured; direction model-derived |
| n241 | `net#241` | ok | `reg16x32_1@8530,8960.R1_OUTPUT` | `reg16x32_1@8530,8960.R1_OUTPUT` | `Pin@8530,8980.p` | topology measured; direction model-derived |
| n242 | `net#242` | ok | `reg16x32_1@8530,8960.R3_OUTPUT` | `reg16x32_1@8530,8960.R3_OUTPUT` | `Pin@8530,9000.p` | topology measured; direction model-derived |
| n243 | `net#243` | ok | `reg16x32_1@8530,8960.R2_OUPUT` | `reg16x32_1@8530,8960.R2_OUPUT` | `Pin@8530,9020.p` | topology measured; direction model-derived |
| n244 | `net#244` | ok | `reg16x32_1@8530,8960.R5_OUTPUT` | `reg16x32_1@8530,8960.R5_OUTPUT` | `Pin@8530,9040.p` | topology measured; direction model-derived |
| n245 | `net#245` | ok | `reg16x32_1@8530,8960.R4_OUTPUT` | `reg16x32_1@8530,8960.R4_OUTPUT` | `Pin@8530,9060.p` | topology measured; direction model-derived |
| n246 | `net#246` | ok | `reg16x32_1@8530,8960.R7_OUTPUT` | `reg16x32_1@8530,8960.R7_OUTPUT` | `Pin@8530,9100.p` | topology measured; direction model-derived |
| n247 | `net#247` | ok | `reg16x32_1@8530,8960.R6_OUTPUT` | `reg16x32_1@8530,8960.R6_OUTPUT` | `Pin@8530,9120.p` | topology measured; direction model-derived |
| n248 | `net#248` | ok | `reg16x32_1@8530,8960.R8_OUTPUT` | `reg16x32_1@8530,8960.R8_OUTPUT` | `Pin@8530,9160.p` | topology measured; direction model-derived |
| n249 | `net#249` | ok | `reg16x32_1@8530,8960.R9_OUTPUT` | `reg16x32_1@8530,8960.R9_OUTPUT` | `Pin@8530,9180.p` | topology measured; direction model-derived |
| n250 | `net#250` | ok | `reg16x32_1@8530,8960.R11_OUTPUT` | `reg16x32_1@8530,8960.R11_OUTPUT` | `Pin@8530,9200.p` | topology measured; direction model-derived |
| n251 | `net#251` | ok | `reg16x32_1@8530,8960.R10_OUTPUT` | `reg16x32_1@8530,8960.R10_OUTPUT` | `Pin@8530,9220.p` | topology measured; direction model-derived |
| n252 | `net#252` | ok | `reg16x32_1@8530,8960.R13_OUTPUT` | `reg16x32_1@8530,8960.R13_OUTPUT` | `Pin@8530,9240.p` | topology measured; direction model-derived |
| n253 | `net#253` | ok | `reg16x32_1@8530,8960.R12_OUTPUT` | `reg16x32_1@8530,8960.R12_OUTPUT` | `Pin@8530,9260.p` | topology measured; direction model-derived |
| n254 | `net#254` | ok | `reg16x32_1@8530,8960.R15_OUTPUT` | `reg16x32_1@8530,8960.R15_OUTPUT` | `Pin@8530,9280.p` | topology measured; direction model-derived |
| n255 | `net#255` | ok | `reg16x32_1@8530,8960.R14_OUTPUT` | `reg16x32_1@8530,8960.R14_OUTPUT` | `Pin@8530,9300.p` | topology measured; direction model-derived |
| n256 | `net#256` | ok | `Constant@8600,10410.p` | `Constant@8600,10410.p` | `Adder@8640,10400.b` | topology measured; direction model-derived |
| n257 | `net#257` | ok | `Constant@8630,10050.p` | `Constant@8630,10050.p` | `Multiplexer@8660,10040.in1` | topology measured; direction model-derived |
| n258 | `net#258` | ok | `Constant@8970,8760.p` | `Constant@8970,8760.p` | `ALU@9190,8660.Cflag` | topology measured; direction model-derived |
| n259 | `net#259` | ok | `Constant@8970,8780.p` | `Constant@8970,8780.p` | `ALU@9190,8660.unused` | topology measured; direction model-derived |
| n260 | `net#260` | ok | `OR Gate@7900,9350.out` | `OR Gate@7900,9350.out` | `OR Gate@7880,9300.in1` | topology measured; direction model-derived |
| n261 | `net:pc_pending` | undriven | — | — | `Register@4990,9090[pc_pending].en` | topology measured; direction model-derived |
| n262 | `net#262` | undriven | — | — | `Multiplexer@7890,9250.sel` | topology measured; direction model-derived |
| n263 | `net#263` | ok | `Comparator@5780,10040.gt` | `Comparator@5780,10040.gt` | — | topology measured; direction model-derived |
| n264 | `net#264` | ok | `Comparator@5780,10040.lt` | `Comparator@5780,10040.lt` | — | topology measured; direction model-derived |
| n265 | `net#265` | ok | `Comparator@7290,8150.gt` | `Comparator@7290,8150.gt` | — | topology measured; direction model-derived |
| n266 | `net#266` | ok | `Comparator@7290,8150.lt` | `Comparator@7290,8150.lt` | — | topology measured; direction model-derived |
| n267 | `net#267` | ok | `Comparator@7840,8250.gt` | `Comparator@7840,8250.gt` | — | topology measured; direction model-derived |
| n268 | `net#268` | ok | `Comparator@7840,8250.lt` | `Comparator@7840,8250.lt` | — | topology measured; direction model-derived |
| n269 | `net#269` | ok | `Comparator@7840,8320.gt` | `Comparator@7840,8320.gt` | — | topology measured; direction model-derived |
| n270 | `net#270` | ok | `Comparator@7840,8320.lt` | `Comparator@7840,8320.lt` | — | topology measured; direction model-derived |
| n271 | `net#271` | ok | `Comparator@8110,8700.gt` | `Comparator@8110,8700.gt` | — | topology measured; direction model-derived |
| n272 | `net#272` | ok | `Comparator@8110,8700.lt` | `Comparator@8110,8700.lt` | — | topology measured; direction model-derived |
| n273 | `net#273` | ok | `Comparator@8260,8280.gt` | `Comparator@8260,8280.gt` | — | topology measured; direction model-derived |
| n274 | `net#274` | ok | `Comparator@8260,8280.lt` | `Comparator@8260,8280.lt` | — | topology measured; direction model-derived |
| n275 | `net#275` | ok | `Adder@8450,10820.cout` | `Adder@8450,10820.cout` | — | topology measured; direction model-derived |
| n276 | `net#276` | undriven | — | — | `Adder@8640,10400.cin` | topology measured; direction model-derived |
| n277 | `net#277` | ok | `Adder@8640,10400.cout` | `Adder@8640,10400.cout` | — | topology measured; direction model-derived |
| n278 | `net#278` | ok | `Adder@9220,11950.cout` | `Adder@9220,11950.cout` | — | topology measured; direction model-derived |
| n279 | `net#279` | ok | `Comparator@9220,12130.gt` | `Comparator@9220,12130.gt` | — | topology measured; direction model-derived |
| n280 | `net#280` | ok | `Comparator@9220,12130.lt` | `Comparator@9220,12130.lt` | — | topology measured; direction model-derived |
| n281 | `net#281` | ok | `Comparator@9220,12250.gt` | `Comparator@9220,12250.gt` | — | topology measured; direction model-derived |
| n282 | `net#282` | ok | `Comparator@9220,12250.lt` | `Comparator@9220,12250.lt` | — | topology measured; direction model-derived |

## 5. Signal flow

### Fetch and instruction delivery

- `Clock@4990,8630.out.wire -> pc_fetch@5780,8630.CLK` (**measured**).
- `pc_fetch@5780,8630.pc_out.wire -> ROM@5890,8620.addr` (**measured**); `pc_out` is the 10-bit bundle PC[11:2].
- `ROM@5890,8620.data_output(raw endpoint 6130,8680).wire -> Splitter@6600,8680.combined` (**measured raw wire + inferred pin identity**). The geometry table intentionally does not model this ROM output.
- `pc_fetch@5780,8630.pc_plus4.wire -> Multiplexer@7510,9000.in1` (**measured**); this is selected into normal writeback for BL (**inferred from control labels**).
- `pc_fetch@5780,8630.pc_out.wire -> Bit Extender@8900,11780.in -> Shifter@9060,11820.in -> Adder@9220,11950.a` (**measured**). Zero extension, left shift by 2, then +8 reconstructs a low-12-bit architectural PC+8 candidate (**inferred**).
- `Adder@9220,11950.out.wire -> Multiplexer@9480,11950.in1` and `-> Multiplexer@9480,12190.in1` (**measured**). RA/RB comparators select this when the corresponding read address is r15.

### Register operands, shifter, ALU, and flags

- `reg16x32_1@8530,8960.RD_A.wire -> Multiplexer@9480,11950.in0 -> Multiplexer@9480,11950.out -> ALU@9190,8660.A` (**measured**).
- `reg16x32_1@8530,8960.RD_B.wire -> Multiplexer@9480,12190.in0 -> Multiplexer@9480,12190.out -> Multiplexer@8820,9130.in0` (**measured**).
- `Multiplexer@8820,9130.out.wire -> barrel_32b@9100,9130.input_32b -> barrel_32b@9100,9130.outp -> ALU@9190,8660.B` (**measured**). The other mux input is the extended immediate.
- `ALU@9190,8660.result.wire -> Multiplexer@7510,9000.in0 -> Multiplexer@7670,9060.in0 -> Multiplexer@7830,9060.in0 -> reg16x32_1@8530,8960.WD` (**measured topology**; select semantics inferred).
- `ALU@9190,8660.{N,Z,C,V}.wire -> Splitter@9390,8750 -> Register@9450,8720[CSPR].D` (**measured**).
- `Register@9450,8720[CSPR].Q.wire -> Splitter@9570,8750 -> condition_checker@9860,8760.{N,Z,C,V}` (**measured**).
- `Constant@8970,8760.p.wire -> ALU@9190,8660.Cflag` (**measured**). Both audited files therefore hardwire arithmetic carry-in state to zero; the later `sandbox.circ` carry repair is not present here.

### Address, memory, block-transfer, and writeback

- `Bit Extender@7650,10790.out.wire -> XOR Gate@7830,10910.in0 -> Adder@8450,10820.b` (**measured**). `NOT U` is extended into the XOR and adder carry-in, implementing add/subtract offset by two’s complement (**inferred**).
- `Adder@8450,10820.out.wire -> Multiplexer@8550,10810.in1`; effective RD_A feeds `.in0`; P selects pre/post address (**measured topology, inferred semantics**).
- `Multiplexer@8550,10810.out.wire -> Multiplexer@8660,10820.in0`; `block_transfer_control@5790,8110.transfer_address.wire -> Multiplexer@8660,10820.in1`; controller `active` selects the block-transfer address (**measured**).
- `Multiplexer@8660,10820.out.wire -> RAM@9620,10690.address_pin(raw endpoint 9620,10700)` (**measured raw topology; RAM port identity inferred**).
- `effective_RD_B.wire -> RAM@9620,10690.data_input_pin(raw endpoint 9620,10780)` (**measured raw topology; the current geometry model incorrectly calls this port `we`**).
- `AND Gate@8910,10780[data_ram_we].out.wire -> OR Gate@9080,11410.in0`; `block_transfer_control@5790,8110.store_enable.wire -> OR Gate@9080,11410.in1`; `OR Gate@9080,11410.out.wire -> RAM@9620,10690.write_enable_pin(raw endpoint 9620,10740)` (**measured topology, pin identity inferred**).
- `RAM@9620,10690.data_output(raw endpoint 9860,10780).wire -> load-data selection path` (**measured raw wire, inferred pin identity**).
- `block_transfer_control@5790,8110.final_address.wire -> Multiplexer@7980,9190.in1 -> reg16x32_1@8530,8960.WD2` (**measured**).
- `Multiplexer@8660,10820.out.wire -> Splitter@5000,12600.combined`; its address slice drives `ROM@5400,12600.addr` (**measured**).
- `RAM.data_output.wire -> Multiplexer@6200,12600.in0`; `ROM@5400,12600.data_output(raw endpoint 5640,12660).wire -> Multiplexer@6200,12600.in1`; `NOT address[12]` selects ROM below 0x1000 and RAM at/above 0x1000 (**measured topology, inferred memory-map semantics**).
- `Multiplexer@6200,12600.out.wire -> Multiplexer@7670,9060.in1` (**measured**), placing mapped load data into normal writeback.

## 6. State and cycles

- `Register@9450,8720[CSPR]`: 4-bit NZCV state; clocked by the common clock, cleared by RST, enabled by `CSPR_enable` (**measured topology; CPSR semantic name inferred despite the label spelling `CSPR`**).
- `Register@5030,8940[pc_target]` and `Register@4990,9090[pc_pending]`: deferred-PC redirect state (**measured labels; behavior belongs to control audit**).
- `pc_fetch`, `reg16x32_1`, and `block_transfer_control` contain child state and are opaque component nodes in this main-level graph.
- `RAM@9620,10690` is falling-edge-triggered mutable data memory (**measured attribute**); ROMs are combinational state tables.
- The main-level directed signal graph contains no trustworthy combinational SCC claim because component input-to-output transfer arcs and memory output pins are intentionally incomplete. Child feedback must be read from the child audits; this is a graph-model limitation, not evidence that feedback is absent.

## 7. Hierarchy

| Child instance | Port | Dir | Parent net | Confidence |
|---|---|---:|---|---|
| `pc_fetch@5780,8630` | `BRANCH` | in | n024 `net#24` | measured/model-derived |
| `pc_fetch@5780,8630` | `CLK` | in | n018 `net:CSPR/pc_pending` | measured/model-derived |
| `pc_fetch@5780,8630` | `IMM` | in | n025 `net#25` | measured/model-derived |
| `pc_fetch@5780,8630` | `RST` | in | n030 `net:CSPR/pc_pending` | measured/model-derived |
| `pc_fetch@5780,8630` | `abs_select` | in | n027 `net#27` | measured/model-derived |
| `pc_fetch@5780,8630` | `abs_target` | in | n031 `net#31` | measured/model-derived |
| `pc_fetch@5780,8630` | `hold` | in | n012 `net:pc_defer` | measured/model-derived |
| `pc_fetch@5780,8630` | `pc_out` | out | n048 `net#48` | measured/model-derived |
| `pc_fetch@5780,8630` | `pc_plus4` | out | n049 `net#49` | measured/model-derived |
| `block_transfer_control@5790,8110` | `P` | in | n041 `net:P` | measured/model-derived |
| `block_transfer_control@5790,8110` | `U` | in | n040 `net:U` | measured/model-derived |
| `block_transfer_control@5790,8110` | `active` | out | n034 `net:active_probe` | measured/model-derived |
| `block_transfer_control@5790,8110` | `base_value` | in | n032 `net:RD_A` | measured/model-derived |
| `block_transfer_control@5790,8110` | `clk` | in | n018 `net:CSPR/pc_pending` | measured/model-derived |
| `block_transfer_control@5790,8110` | `done` | out | n002 `net:done_probe/pc_apply` | measured/model-derived |
| `block_transfer_control@5790,8110` | `final_address` | out | n054 `net#54` | measured/model-derived |
| `block_transfer_control@5790,8110` | `hold_pc` | out | n012 `net:pc_defer` | measured/model-derived |
| `block_transfer_control@5790,8110` | `is_pop` | in | n038 `net:is_pop` | measured/model-derived |
| `block_transfer_control@5790,8110` | `load_enable` | out | n055 `net:load_enable_probe` | measured/model-derived |
| `block_transfer_control@5790,8110` | `phase_reg_q` | out | n056 `net#56` | measured/model-derived |
| `block_transfer_control@5790,8110` | `reg_idx` | out | n052 `net:reg_idx_probe` | measured/model-derived |
| `block_transfer_control@5790,8110` | `reg_list_in` | in | n037 `net#37` | measured/model-derived |
| `block_transfer_control@5790,8110` | `reg_selected` | out | n053 `net:reg_selected_probe` | measured/model-derived |
| `block_transfer_control@5790,8110` | `rst` | in | n030 `net:CSPR/pc_pending` | measured/model-derived |
| `block_transfer_control@5790,8110` | `start` | in | n039 `net:start` | measured/model-derived |
| `block_transfer_control@5790,8110` | `store_enable` | out | n033 `net#33` | measured/model-derived |
| `block_transfer_control@5790,8110` | `transfer_address` | out | n035 `net#35` | measured/model-derived |
| `reg16x32_1@8530,8960` | `CLK` | in | n018 `net:CSPR/pc_pending` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R0_OUTPUT` | out | n240 `net#240` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R10_OUTPUT` | out | n251 `net#251` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R11_OUTPUT` | out | n250 `net#250` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R12_OUTPUT` | out | n253 `net#253` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R13_OUTPUT` | out | n252 `net#252` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R14_OUTPUT` | out | n255 `net#255` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R15_OUTPUT` | out | n254 `net#254` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R1_OUTPUT` | out | n241 `net#241` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R2_OUPUT` | out | n243 `net#243` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R3_OUTPUT` | out | n242 `net#242` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R4_OUTPUT` | out | n245 `net#245` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R5_OUTPUT` | out | n244 `net#244` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R6_OUTPUT` | out | n247 `net#247` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R7_OUTPUT` | out | n246 `net#246` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R8_OUTPUT` | out | n248 `net#248` | measured/model-derived |
| `reg16x32_1@8530,8960` | `R9_OUTPUT` | out | n249 `net#249` | measured/model-derived |
| `reg16x32_1@8530,8960` | `RA` | in | n068 `net#68` | measured/model-derived |
| `reg16x32_1@8530,8960` | `RB` | in | n153 `net#153` | measured/model-derived |
| `reg16x32_1@8530,8960` | `RD_A` | out | n167 `net#167` | measured/model-derived |
| `reg16x32_1@8530,8960` | `RD_B` | out | n168 `net#168` | measured/model-derived |
| `reg16x32_1@8530,8960` | `RST` | in | n030 `net:CSPR/pc_pending` | measured/model-derived |
| `reg16x32_1@8530,8960` | `WA` | in | n138 `net#138` | measured/model-derived |
| `reg16x32_1@8530,8960` | `WA2` | in | n104 `net:memory_rn` | measured/model-derived |
| `reg16x32_1@8530,8960` | `WD` | in | n009 `net#9` | measured/model-derived |
| `reg16x32_1@8530,8960` | `WD2` | in | n146 `net#146` | measured/model-derived |
| `reg16x32_1@8530,8960` | `WE` | in | n141 `net#141` | measured/model-derived |
| `reg16x32_1@8530,8960` | `WE2` | in | n155 `net#155` | measured/model-derived |
| `barrel_32b@9100,9130` | `amnt` | in | n158 `net#158` | measured/model-derived |
| `barrel_32b@9100,9130` | `input_32b` | in | n183 `net#183` | measured/model-derived |
| `barrel_32b@9100,9130` | `outp` | out | n190 `net#190` | measured/model-derived |
| `barrel_32b@9100,9130` | `typ` | in | n177 `net#177` | measured/model-derived |
| `ALU@9190,8660` | `A` | in | n032 `net:RD_A` | measured/model-derived |
| `ALU@9190,8660` | `B` | in | n190 `net#190` | measured/model-derived |
| `ALU@9190,8660` | `C` | out | n193 `net#193` | measured/model-derived |
| `ALU@9190,8660` | `Cflag` | in | n258 `net#258` | measured/model-derived |
| `ALU@9190,8660` | `N` | out | n195 `net#195` | measured/model-derived |
| `ALU@9190,8660` | `V` | out | n196 `net#196` | measured/model-derived |
| `ALU@9190,8660` | `Z` | out | n194 `net#194` | measured/model-derived |
| `ALU@9190,8660` | `a_inv` | in | n171 `net#171` | measured/model-derived |
| `ALU@9190,8660` | `b_inv` | in | n170 `net#170` | measured/model-derived |
| `ALU@9190,8660` | `cin_sel` | in | n174 `net#174` | measured/model-derived |
| `ALU@9190,8660` | `engine_sel` | in | n175 `net#175` | measured/model-derived |
| `ALU@9190,8660` | `logic_sel` | in | n173 `net#173` | measured/model-derived |
| `ALU@9190,8660` | `result` | out | n108 `net#108` | measured/model-derived |
| `ALU@9190,8660` | `unused` | in | n259 `net#259` | measured/model-derived |
| `ALU@9190,8660` | `write_enable` | in | n169 `net#169` | measured/model-derived |
| `ALU@9190,8660` | `write_enable_out` | out | n197 `net#197` | measured/model-derived |
| `condition_checker@9860,8760` | `C` | in | n207 `net#207` | measured/model-derived |
| `condition_checker@9860,8760` | `N` | in | n205 `net#205` | measured/model-derived |
| `condition_checker@9860,8760` | `V` | in | n208 `net#208` | measured/model-derived |
| `condition_checker@9860,8760` | `Z` | in | n206 `net#206` | measured/model-derived |
| `condition_checker@9860,8760` | `cond` | in | n130 `net#130` | measured/model-derived |
| `condition_checker@9860,8760` | `out0` | out | n003 `net:CSPR_enable/bx_taken` | measured/model-derived |

## 8. Health

- **Coverage (measured):** 1271/1282 raw wire endpoints matched by the current geometry model; unmatched endpoints: `[(5640, 12660), (6130, 8680), (7570, 8820), (7870, 9270), (7930, 8040), (7980, 8060), (8070, 9520), (8270, 8040), (8400, 8060), (8470, 8680), (9860, 10780)]`.
- **Graph flags (model-derived):** 14 multi-port undriven nets, 0 multi-driver nets, 40 singleton nets. None is promoted to a circuit defect without raw reconciliation.
- **Dead-output heuristic (model-derived):** `['Constant@9560,10750', 'OR Gate@6070,7790', 'OR Gate@9080,11410']`. The RAM/ROM port-name limitation makes at least the memory-adjacent results false positives.
- **Recovered memory endpoints (measured raw wires):** instruction ROM data `(6130,8680)`; control ROM data `(8470,8680)`; RAM data output `(9860,10780)`; RAM address `(9620,10700)`; RAM write-enable `(9620,10740)`; RAM clock `(9620,10760)`; RAM write-data `(9620,10780)`.
- **Confirmed datapath issue:** `ALU.Cflag` is tied to constant zero in both source files. ADC/SBC carry dependence cannot be architecturally correct here.
- **Width risk:** the PC-read reconstruction begins with only `pc_out = PC[11:2]`; upper PC bits are irrecoverable, so the derived PC+8 operand is valid only inside the 4 KiB PC window.
- **Width risk:** `Splitter@5000,12600.bit1` appears to group address bits 1..11 (11 bits) into a ROM whose `addrWidth` is 10. This is unresolved and should be checked in live Logisim before treating the mapping as exact.
- **Additional unmodelled endpoint:** mapped ROM data output `(5640,12660)` feeds the lower memory-data mux.
- **No halfword datapath observed (inferred):** there is no visible byte-lane select, halfword merge/extract, or sign-extension path around the 32-bit RAM. This does not by itself audit decode behavior.

## 9. Debug delta

- **Measured additions versus `armv4t.circ`:** 19 components and 190 wire segments at main level; graph delta +53 modeled port nodes, +42 directed connections, −15 directed connections.
- Added PC+8 reconstruction plus RA/RB==15 substitution, an address-mapped second instruction ROM/load-data mux, P/U wires to the block controller, and W-gated block base writeback.
- The block controller child itself has two added inputs (`U`, `P`); its internal audit owns direction/address sequencing.
- Carry input remains tied to zero; debug does not contain the later sandbox carry fix.

## 10. Human map

The PC block fetches a 32-bit ARM word, the instruction splitters form register indices/immediates/control-ROM addresses, the register file supplies two operands, and the barrel shifter feeds ALU operand B. ALU results, BL link values, loads, and base-update addresses converge on the primary write port. A secondary write port handles memory/block-transfer base updates. The memory address unit performs ARM pre/post and up/down offset arithmetic, while the block controller temporarily owns register indices and memory addresses. NZCV is stored in the four-bit `CSPR` register and fed back to conditional execution.
Debug additionally substitutes PC+8 when either source index is r15 and maps loads below 0x1000 to a duplicate instruction ROM. Both features are combinational main-side overlays.

## 11. Cross-circuit links

- `pc_fetch` auditor owns internal PC priority and confirms: `hold` has highest priority; `abs_select` matters only while `BRANCH=1`; `pc_out=PC_Q[11:2]`.
- `main_control` auditor owns instruction decode, mux selects/write enables, branch/BX/BL, deferred PC control, CPSR enable, memory controls, and block start/done policy.
- `reg16x32_1` audit must reconcile WA/WD/WE and WA2/WD2/WE2 plus raw-versus-effective RD_A/RD_B in debug.
- `block_transfer_control` audit must reconcile `transfer_address`, `final_address`, `load_enable`, `store_enable`, `active`, `done`, and debug-only P/U.
- `barrel_32b`, `ALU`, and `condition_checker` audits own child-internal combinational paths; this report owns only their main-level port nets.
- **Shared contradiction resolved:** geometry.py names RAM y=10740 as `data_in` and y=10780 as `we`, but raw fan-in semantics and the unmodelled output prove those names are reversed/incomplete for this Logisim appearance. Reports must describe raw endpoints until geometry is corrected.
- **Unresolved with pc_fetch:** main reconstructs PC+8 from only ten exported PC word-address bits, so behavior above the 4 KiB window is not represented.

## 12. Confidence

- **Measured:** component attributes/counts; wire/net membership; child port order; raw endpoint coordinates; graph inventory; exact debug component delta.
- **Inferred:** architectural purpose of muxes/gates, pre/post and up/down address equations, RAM pin identities recovered from fan-in semantics, mapped-ROM select polarity.
- **Unresolved:** Logisim ROM/RAM full pin geometry; every singleton output’s intent; debug mapped-ROM address-slice width; architectural behavior above the exported 10-bit PC window.
