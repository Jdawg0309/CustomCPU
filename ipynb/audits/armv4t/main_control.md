# `armv4t.circ` / `main` control audit

## 1. Identity and purpose

- **Source:** `armv4t.circ`, SHA-256 `ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84`.
- **Circuit:** `main`.
- **Partition audited here:** instruction-field extraction, class/condition decode, ALU-control decode, P/U/B/W/L controls, register and memory enables, branch/BX/BL and PC-write redirection, block-transfer launch/control, CPSR flags, clock, and reset.
- **Role (inferred):** combinational control around the single-cycle datapath plus three parent-level state registers (`CSPR`, `pc_pending`, and `pc_target`). Stateful block-transfer and PC sequencing also lives in child circuits.
- The source circuit was treated as read-only. Counts and endpoints below are **measured** from the XML/graph model; architectural names are **inferred** where stated.

## 2. Interface

`main` has one input and 36 outputs. Every pin faces west except the east-facing reset input.

| Pin / position | Dir. | Width | Measured connection | Role / confidence |
|---|---:|---:|---|---|
| unlabeled `Pin@5050,8750` | in | 1 | common clear/RST net | reset, **measured** |
| unlabeled `Pin@5930,8290` | out | 1 | `block_transfer_control.phase_reg_q` | transfer phase, **measured** |
| unlabeled `Pin@9350,8660` | out | 32 | `ALU.result` | ALU result, **measured** |
| `branch_taken` | out | 1 | `AND Gate@10190,8690.out` | conditional B taken, **measured** |
| `condition_pass` | out | 1 | `condition_checker.out0` | ARM condition result, **measured** |
| `R0..R15` debug pins at `x=8530,y=8960..9300` | out | 32 each | corresponding `reg16x32_1.R*_OUTPUT` | register observability, **measured**; physical order is R0,R1,R3,R2,R5,R4,R7,R6,R8,R9,R11,R10,R13,R12,R15,R14 |
| unlabeled `Pin@9100,9060` | out | 32 | `barrel_32b.outp` | shifted operand, **measured** |
| `RD_A` | out | 32 | raw `reg16x32_1.RD_A` | read operand A, **measured** |
| unlabeled `Pin@8620,9140` | out | 32 | raw `reg16x32_1.RD_B` | read operand B, **measured** |
| `normal_reg_WE` | out | 1 | `AND Gate@9980,8710.out` | ordinary ALU write enable, **measured** |
| unlabeled `Pin@6180,9920` | out | 1 | instruction link-bit slice | likely instruction bit 24, **inferred** |
| `is_BX` | out | 1 | BX opcode comparator equality | raw BX decode, **measured** |
| `is_BL` | out | 1 | branch-class AND link bit | raw BL decode, **measured** |
| `bl_taken` | out | 1 | `condition_pass AND is_BL` | taken BL, **measured** |
| `mem_class` | out | 1 | instruction class `01x` gate | single-transfer class, **inferred from measured logic** |
| `is_STR` | out | 1 | `mem_class AND NOT L` | raw STR, **measured** |
| `is_LDR` | out | 1 | `mem_class AND L` | raw LDR, **measured** |
| unlabeled `Pin@9960,10780` | out | 32 | memory read-data path | RAM data output, **inferred**; RAM data pin is unmodelled |
| `mem_offset` | out | 32 | zero-extended instruction `[11:0]` | memory immediate offset, **measured/inferred** |
| `memory_address` | out | 32 | ordinary/block address mux | RAM address, **measured** |
| `memory_offset_effective` | out | 32 | U-controlled XOR result | signed add/sub offset encoding, **measured** |
| `ldr_reg_we` | out | 1 | `condition_pass AND is_LDR` | load destination enable, **measured** |

## 3. Inventory

Full `main` inventory (**measured**): 226 components, 882 wire segments, 256 electrical nets, 636 modelled ports, and 374 directed graph edges.

| Component type | Count | Component type | Count |
|---|---:|---|---:|
| Probe | 53 | Pin | 37 |
| Splitter | 27 | AND Gate | 23 |
| Constant | 17 | Multiplexer | 17 |
| OR Gate | 16 | NOT Gate | 9 |
| Comparator | 6 | Bit Extender | 4 |
| Register | 3 | ROM | 2 |
| Adder | 2 | Clock | 1 |
| XOR Gate | 1 | RAM | 1 |
| Shifter | 1 | `pc_fetch` | 1 |
| `block_transfer_control` | 1 | `reg16x32_1` | 1 |
| `barrel_32b` | 1 | `ALU` | 1 |
| `condition_checker` | 1 |  |  |

Control-owned state: `Register@9450,8720[CSPR]`, `Register@4990,9090[pc_pending]`, `Register@5030,8940[pc_target]`. The instruction ROM is `ROM@5890,8620`; the 10-bit ALU-decode ROM is `ROM@8230,8620`.

## 4. Nets

### 4.1 Instruction and decode net ledger

The instruction bus is the electrical net joining the instruction ROM's unmodelled data output to the combined ends of the splitters below. Because ROM data geometry is intentionally absent, the graph calls this `net#34` and does not list a driver. That is a **graph limitation, not a circuit defect**.

| Graph net / width | Complete attached control endpoints | Meaning / status |
|---|---|---|
| `net#34` / 32 | `ROM@5890,8620.data(unmodelled)`; `Splitter@5580,10000.combined`; `Splitter@6590,8010.combined`; `Splitter@6600,8680.combined`; `Splitter@6950,10430.combined`; `Splitter@6990,10790.combined`; `Splitter@7740,9970.combined` | instruction word, **measured with inferred ROM endpoint** |
| `net#31` / 16 | `Splitter@6590,8010.bit0`; `block_transfer_control.reg_list_in`; probe | instruction `[15:0]` register list, **measured/inferred** |
| `net#54` / 4 | `Splitter@6600,8680.bit0`; `Mux@8020,8730.in0` | instruction `[3:0]` / Rm, **measured/inferred** |
| `net#55` / 8 | `Splitter@6600,8680.bit1`; `Splitter@7800,9870.combined` | instruction `[11:4]`, **measured/inferred** |
| `net#56` / 4 | `Splitter@6600,8680.bit2`; `Mux@7710.in0`; `Mux@8020.in1` | instruction `[15:12]` / Rd, **measured/inferred** |
| `net#57` / 4 | `Splitter@6600,8680.bit3`; `reg16x32_1.RA`; `Comparator@8260.b`; write-address mux input; probes | instruction `[19:16]` / Rn, **measured/inferred** |
| `net#58` / 1 | `Splitter@6600,8680.bit4`; `NOT@7700.in`; `AND@8170,10720.in1`; `CSPR_enable.in2` | instruction bit 20 (`L` for transfer, `S` for data-processing), **measured/inferred** |
| `net#49` / 4 | `Splitter@6600,8680.bit5`; `Splitter@6090,9900.combined`; `Splitter@7850,8880.bit2` | instruction `[24:21]`, **measured/inferred** |
| `net#59` / 7 | `Splitter@6600,8680.bit6`; `Splitter@6670,8280.combined`; `Splitter@7810,10130.combined` | instruction `[31:25]`, **measured/inferred** |
| `net#52` / 3 | `Splitter@6940,8140.combined`; `Comparator@7290.a`; probe | instruction `[27:25]`, block-class compare operand, **measured/inferred** |
| `net#60` / 4 | `Splitter@6940,8200.combined`; probe only | instruction `[31:28]` mirror, **inferred** |
| `net#117` / 3 | `Splitter@7810,10130.bit0`; `Splitter@7810,10230.combined` | instruction `[27:25]`, branch/memory class field, **measured/inferred** |
| `net#123` / 4 | `Splitter@7810,10130.bit1`; `condition_checker.cond`; probe | instruction `[31:28]` condition, **measured/inferred** |
| `net#68` / 24 | `Splitter@6950,10430.bit0`; `Bit Extender@8150.in`; probe | branch immediate `[23:0]`, **measured/inferred** |
| `net#35` / 24 | `Splitter@5580,10000.bit1`; `Comparator@5780.a` | BX compare instruction `[27:4]`, **measured/inferred** |
| `net#93` / 1 | `Splitter@6990.bit23`; `Splitter@7440.bit1`; `NOT@7640.in`; `U` probe | U bit, **measured** |
| `net#94` / 1 | `Splitter@6990.bit24`; `Splitter@7440.bit0`; `NOT@8170.in`; address pre/post mux select; `P` probe | P bit, **measured** |
| `net#91` / 1 | `Splitter@6990.bit21`; `Splitter@7440.bit3`; `OR@8240.in0`; `W` probe | W bit, **measured** |
| `net#92` / 1 | `Splitter@6990.bit22`; `Splitter@7440.bit2`; `B` probe | B bit; observed but not consumed by this control, **measured** |
| `net#90` / 1 | `Splitter@6990.bit20`; `Splitter@7440.bit4`; `L` probe | L bit mirror; load/store decode instead uses equivalent `net#58`, **measured** |
| `net#97` / 5 | `Splitter@7440.combined`; push/pop comparators; mode probe | `{P,U,B,W,L}`, **measured** |

The ALU-decode address is assembled into `Splitter@7850,8880.combined -> ROM@8230,8620.addr` (`net#130`, 16 bits) from instruction `[24:21]` plus two zero constants. Exact bit placement inside that 16-bit word is **unresolved** because the ROM truth-table format, not connectivity, defines its semantics.

`ROM@8230,8620` produces a 10-bit control word into `Splitter@8520,8680.combined` (`net#154`). The following raw nets are all real ROM-output slices but appear undriven in the graph: `net#157` (ALU write enable), `net#158` (B invert), `net#159` (A invert), `net#161` (logic select), `net#162` (carry-in select), `net#163` (engine select), and raw slice nets `net#211..217`. Status: **measured topology; ROM driver inferred; bit semantics inferred from destination names**.

### 4.2 Named control-net ledger

| Signal (graph net) | Driver -> all control sinks | Width/status |
|---|---|---|
| `condition_pass` (`net#0`) | `condition_checker.out0 -> branch_taken.in0, bx_taken.in2, block_valid.in1, CSPR_enable.in0, normal_WE.in2, bl_taken.in0, data_ram_we.in0, ldr_we.in1, store_base_we.in0, load_base_we.in1`, probes/pin | 1, **measured** |
| `block_transfer` (`net#98`) | `Comparator@7290.eq -> AND@7430.in0`, probe | 1, **measured** |
| `block_transfer_valid` (`net#99`) | `AND@7430.out -> is_push.in0, is_pop.in0`, probe | 1, **measured** |
| `push_mode` (`net#128`) | `Comparator@7840,8250.eq -> AND@8080.in1`, probe | 1, **measured** |
| `pop_mode` (`net#129`) | `Comparator@7840,8320.eq -> AND@8470.in1`, probe | 1, **measured** |
| `rn_is_sp` (`net#138`) | `Comparator@8260.eq -> both push/pop gates.in2`, probe | 1, **measured** |
| `is_push` (`net#145`) | `AND@8080.out -> OR@8650.in1`, probe | 1, **measured** |
| `is_pop` (`net#32`) | `AND@8470.out -> OR@8650.in0, block_transfer_control.is_pop`, probe | 1, **measured** |
| `start` (`net#33`) | `OR@8650.out -> block_transfer_control.start`, probe | 1, **measured** |
| `active` (`net#29`) | `block_transfer_control.active -> WA mux.sel, RB mux.sel, address mux.sel`, probe | 1, **measured** |
| `done` (`net#9`) | `block_transfer_control.done -> pc_apply.in1, pending NOT.in, WD2 mux.sel, WE2 OR.in0`, plus dead `OR@6070.in0` | 1, **measured** |
| `hold_pc` (`net#10`) | `block_transfer_control.hold_pc -> pc_fetch.hold, pc_defer.in1`, plus dead `OR@6070.in1` | 1, **measured** |
| `load_enable` (`net#46`) | `block_transfer_control.load_enable -> register-WE mux.in1, load-data select OR.in0`, probe | 1, **measured** |
| `branch_class/is_B` (`net#153`) | `AND@8390.out -> is_BL.in0, is_B.in0, special-class OR.in1` | 1, **measured** |
| `is_BL` (`net#156`) | `AND@8510.out -> bl_taken.in1, not_link.in`, output pin | 1, **measured** |
| `is_B` (`net#3`) | `AND@8910.out -> branch_taken.in1` | 1, **measured** |
| `branch_taken` (`net#4`) | `AND@10190.out -> branch redirect OR@9280.in1`, output pin | 1, **measured** |
| `bl_taken` (`net#69`) | `AND@8950.out -> branch redirect OR, link-register address/result mux selects, final register WE`, output pin | 1, **measured** |
| `is_BX` (`net#41`) | `Comparator@5780.eq -> bx_taken.in0, special-class OR.in0`, output pin | 1, **measured** |
| `bx_taken` (`net#14`) | `AND@6090.out -> PC BRANCH OR path and abs_select OR` | 1, **measured** |
| `mem_class` (`net#141`) | `AND@8010.out -> STR/LDR gates and special-class OR` | 1, **measured** |
| `is_STR` (`net#140`) | `AND@8170,10640.out -> data_ram_we, store-base-WE, address/register mux selects`, output pin | 1, **measured** |
| `is_LDR` (`net#105`) | `AND@8170,10720.out -> ldr_we, load-base-WE, load-data select`, output pin | 1, **measured** |
| `data_ram_we` (`net#173`) | `AND@8910,10780.out -> OR@9080.in0` | 1, **measured topology**; actual RAM pin mapping unmodelled |
| `ldr_reg_we` (`net#137`) | `AND@8910,10960.out -> normal-WE OR chain`, output pin | 1, **measured** |
| `wb_requested` (`net#152`) | `OR@8240.out -> store/load base-write gates.in2` | 1, **measured**; equation `W OR NOT P` |
| `sbwe` (`net#53`) | `AND@8440.out -> Rn/updated-base mux selects and normal-WE OR` | 1, **measured** |
| `load_base_write_enable` (`net#148`) | `AND@8500.out -> WE2 OR.in1` | 1, **measured** |
| `normal_reg_WE` (`net#1`) | `AND@9980.out -> final_reg_we.in1`, output pin | 1, **measured** |
| `final_reg_we` (`net#133`) | `OR@7880,9410.out -> normal WE OR chain` | 1, **measured** |
| clock (`net#16`) | `Clock@4990.out -> pc_fetch.CLK, block controller.clk, regfile.CLK, CSPR.clk, pc_pending.clk, pc_target.clk, RAM.clk` | 1, **measured** |
| reset (`net#25`) | `Pin@5050 -> pc_fetch.RST, block controller.rst, regfile.RST, CSPR.clr, pc_pending.clr, pc_target.clr` | 1, **measured** |

Raw control endpoints deliberately retained: comparator `gt/lt` nets `#241..252` are singleton unused outputs; branch-adder `cin` `net#254` is unconnected; branch-adder `cout` `net#255` is unused; `OR@6070.out` is singleton `net#50`; `pc_pending.en` is singleton `net#239`; and north-facing `Mux@7890,9250.sel` is singleton `net#240`. Their electrical status is **measured**; functional consequences of the last two are **unresolved** because Logisim's omitted/floating control semantics and north-facing mux geometry need live confirmation.

## 5. Signal flow

Endpoint-first paths; coordinates are stable identifiers only.

```text
ROM@5890,8620.data(unmodelled).wire -> instruction_splitters.combined
Splitter@7810,10130.cond.wire -> condition_checker@9860,8760.cond
CSPR.Q.wire -> condition_checker.N/Z/C/V
condition_checker.out0.wire -> every condition-gated architectural enable
```

Class equations (**inferred from measured gates**):

```text
instruction[27:25].wire -> block comparator == 0b100 -> block_transfer
instruction[27:25].wire -> branch gate == 0b101 -> branch_class
instruction[27:25].wire -> (!bit27 & bit26) -> mem_class   # 01x
instruction[24].wire + branch_class -> is_BL
NOT instruction[24].wire + branch_class -> is_B
instruction[20].wire + mem_class -> is_LDR
NOT instruction[20].wire + mem_class -> is_STR
```

Block transfer in this file (**measured**):

```text
mode[4:0].wire -> (==0x12) -> push_mode
mode[4:0].wire -> (==0x0b) -> pop_mode
Rn.wire -> (==13) -> rn_is_sp
block_transfer & condition_pass & push_mode & rn_is_sp -> is_push
block_transfer & condition_pass & pop_mode  & rn_is_sp -> is_pop
is_push OR is_pop -> block_transfer_control.start
```

Thus only exact SP-based `STMDB ...!` and `LDMIA ...!` launch the controller; general LDM/STM forms do not.

PC paths (**measured topology, architectural role inferred**):

```text
instruction[23:0] -> sign_extend -> shift_left_2 -> add_8 -> pc_fetch.IMM
branch_taken OR bl_taken -> relative_redirect
RD_B & 0xfffffffc -> bx_arm_target
is_BX & NOT RD_B[0] & condition_pass -> bx_taken
WA == 15 & regfile.WE -> pc_write
bx_arm_target / WD --pc_write--> current_pc_target
pc_write & block_transfer_control.hold_pc -> pc_defer
pc_defer OR (pc_pending.Q & NOT done) -> pc_pending.D
pc_pending.Q & done -> pc_apply
current_pc_target / pc_target.Q --pc_apply--> pc_fetch.abs_target
bx_taken OR pc_apply OR pc_write -> pc_fetch.abs_select
relative_redirect OR bx_taken OR pc_apply OR pc_write -> pc_fetch.BRANCH
```

Per the independently audited child, `pc_fetch` applies `hold` first, then `BRANCH`; therefore an in-transfer PC write is ignored immediately, saved in `pc_target`, then reapplied when `done` asserts. `abs_select` only matters while `BRANCH=1`.

Write-enable paths (**measured**):

```text
ALU.write_enable_out & condition_pass & NOT(BX|branch|memory class) -> normal_reg_WE
normal_reg_WE OR bl_taken -> final_reg_we
final_reg_we OR ldr_reg_we OR sbwe -> regfile.WE    # via ORs/mux
condition_pass & is_STR & (W | !P) -> sbwe
condition_pass & is_LDR & (W | !P) -> load_base_write_enable
done OR load_base_write_enable -> regfile.WE2
```

The block-transfer `done -> WE2` path is unconditional in this file; W is not consulted.

CPSR path (**measured**):

```text
ALU.{N,Z,C,V}.wire -> CSPR.D
CSPR.Q -> condition_checker.{N,Z,C,V}
condition_pass & instruction_bit20 & NOT(BX|branch|memory class) -> CSPR.en
```

`ALU.Cflag` is tied to `Constant@8970,8760 = 0`, so ADC/SBC do not receive saved C from CSPR in this file (**measured**).

## 6. State and cycles

| State element | D/control | Q consumers | Cycle role |
|---|---|---|---|
| `CSPR` 4-bit | ALU N/Z/C/V; gated by `CSPR_enable` | condition checker | stores current arithmetic flags, **measured** |
| `pc_pending` 1-bit | `pc_defer OR (Q & !done)` | `pc_apply`, feedback | remembers a PC write that occurred during block hold, **measured/inferred** |
| `pc_target` 32-bit | selected BX/WD target; enabled by `pc_write` | deferred target mux | remembers deferred absolute PC target, **measured/inferred** |
| `block_transfer_control` | start, L/pop mode, reglist, base | active/done/index/address/enables | multi-cycle controller; internal state belongs to its own audit |
| `pc_fetch` | branch/hold/targets | PC/PC+4 | PC state; internal state belongs to its own audit |
| `reg16x32_1` | three write ports/control groups | operands/register pins | architectural registers; datapath audit owns internals |

The explicit feedback edge is `pc_pending.Q -> AND@4670 -> OR@4780 -> pc_pending.D`. The CSPR participates in a cycle across instructions (`CSPR.Q -> condition_checker -> condition-gated execute -> ALU flags -> CSPR.D`) but not a same-cycle combinational SCC. The port-only signal graph has no meaningful internal-component SCCs because it intentionally does not add input-to-output arcs through components; absence of SCCs there is a **model limitation**.

## 7. Hierarchy

| Child instance | Control port mapping in `main` |
|---|---|
| `pc_fetch@5780,8630` | `CLK<-clock`; `RST<-reset`; `hold<-block.hold_pc`; `BRANCH<-OR@4950.out`; `IMM<-branch adder`; `abs_target<-Mux@5040.out`; `abs_select<-OR@5010.out`; outputs `pc_out`, `pc_plus4` |
| `block_transfer_control@5790,8110` | `clk`, `rst`, `start`, `is_pop`, `reg_list_in`, `base_value`; outputs `hold_pc`, `active`, `done`, `reg_idx`, `load_enable`, `store_enable`, `transfer_address`, `final_address`, `reg_selected`, `phase_reg_q` |
| `reg16x32_1@8530,8960` | control boundaries `RA`, `RB`, `WA`, `WE`, `WA2`, `WE2`, `CLK`, `RST`; data boundaries documented by datapath audit |
| `ALU@9190,8660` | control ROM drives `write_enable`, `a_inv`, `b_inv`, `logic_sel`, `cin_sel`, `engine_sel`; CSPR carry input is constant zero; ALU returns `write_enable_out` and flags |
| `condition_checker@9860,8760` | `cond<-instruction[31:28]`; flags `<-CSPR.Q`; `out0->condition_pass` |
| `barrel_32b@9100,9130` | immediate/register shift muxes drive `amnt`, `typ`, and input select; no control state |

## 8. Health

- Graph health (**measured**): 14 reported undriven nets, zero multi-driver nets, 32 singleton/dangling nets, and three reported dead-output components.
- All 13 ALU-control “undriven” groups (`net#157..163`, `#211..217`) are downstream of `ROM@8230`; ROM output geometry is not modelled. **Do not treat these as floating hardware.**
- `Pin@9960,10780 -> Mux@7670.in1` is RAM read data; RAM output geometry is unmodelled.
- `OR@6070,7790.out` is genuinely unconsumed in the measured graph. Its inputs are `done` and `hold_pc`; it has no functional effect.
- `pc_pending.en` and `Mux@7890.sel` appear dangling. This is **unresolved**, not declared a defect, until Logisim omitted-enable behavior and rotated mux geometry are tested live.
- Comparator `gt/lt`, adder carry-outs, unused high instruction bits, and unused splitter branches are intentional observability/dead outputs unless a future feature consumes them.
- The graph reports `OR@9080,11410` and `Constant@9560,10750` as dead because RAM port geometry is incomplete. Datapath inspection identifies the OR as part of the store-write path; this is a **graph limitation**.
- `ALU.Cflag=0` is a real measured architectural weakness for carry arithmetic.
- P/U/B/W/L decode exists at parent level, but P/U/W do not enter `block_transfer_control`; exact PUSH/POP comparators collapse block transfer to two modes. This is a real measured feature gap.

## 9. Debug delta

See `../main_control_delta.md`. In summary, debug generalizes block launch using L rather than exact PUSH/POP patterns, appends P/U controller inputs, gates block base writeback with W, adds PC+8 operand substitution, and adds a program-memory load path. This file retains exact-SP PUSH/POP-only control and unconditional block `done -> WE2`.

## 10. Human map

The instruction ROM fans one 32-bit instruction into four kinds of control. The condition field and stored CSPR flags decide whether any architectural side effect may occur. Bits `[27:25]` select data-processing, branch, single-transfer, or block-transfer behavior. A small ROM converts the data-processing opcode group into ALU control wires. Branch/BX/PC-write logic converts relative or absolute destinations into the `pc_fetch` interface, with two registers preserving a PC write while PUSH/POP holds the PC. Load/store gates generate memory and register enables; the block controller temporarily overrides read addresses, write addresses, memory addresses, and enables while active.

## 11. Cross-circuit links

- **`pc_fetch` audit reconciliation:** measured interface is `pc_plus4[31:0]`, `pc_out[9:0]`; inputs `CLK`, `BRANCH`, `hold`, `IMM[31:0]`, `abs_target[31:0]`, `abs_select`, `RST`. Internal priority is `hold` over branch over `PC+4`. The parent deferral network deliberately asserts `BRANCH` and `abs_select` together for BX, PC writes, and deferred application.
- **Main datapath reconciliation:** this file exposes raw regfile `RD_A`/`RD_B`; the debug-only PC+8 read substitution is absent. Control-owned write ports are `WA`, `WE`, `WA2`, and `WE2`; data selection is documented in the datapath audit.
- **RAM model conflict resolved:** the graph currently labels the endpoint at the apparent RAM write-data location as `RAM.we`; raw circuit topology and datapath inspection show this is store data. No control conclusion is based on that generated port name.
- `block_transfer_control` needs a separate internal audit to establish address sequencing and the semantics of `active`, `done`, `load_enable`, and `store_enable`; this document records every parent attachment.

## 12. Confidence

- **Measured:** component/net counts, XML attributes, all stated endpoint attachments, constants, gate topology, register feedback, graph health, and parent/child port mapping.
- **Inferred:** ARM field names, class meanings, PC+8 interpretation, equations translated from gates, and architectural purpose of unlabeled outputs.
- **Unresolved:** exact ALU control-ROM truth-table semantics; omitted `pc_pending.en`; rotated `Mux@7890.sel`; ROM/RAM unmodelled physical output pins; whether unused `OR@6070` is intentional residue.
