# `debug_armv4t.circ` / `main` control audit

## 1. Identity and purpose

- **Source:** `debug_armv4t.circ`, SHA-256 `eaaeadc774fa99daf6a304403b9c8556210b836b52b79de99bdea7d08ff225c9`.
- **Circuit:** `main`.
- **Partition:** the same decode/control boundary as the reference audit: instruction fields, condition/class decode, ALU controls, P/U/B/W/L, enables and mux selects, branch/BX/BL/PC-write control, block transfers, flags, clock, and reset.
- **Role (inferred):** experimental superset of `armv4t.circ/main`, notably with general block-transfer launch/direction wiring, W-gated block writeback, architectural PC+8 operand substitution, and program-ROM loads.
- Both circuit sources were treated as strictly read-only.

## 2. Interface

The pin interface is structurally unchanged: one 1-bit reset input and 36 outputs. Every pin except reset faces west.

| Pin / position | Dir. | Width | Measured connection / debug-specific meaning |
|---|---:|---:|---|
| unlabeled `Pin@5050,8750` | in | 1 | common reset/clear |
| unlabeled `Pin@5930,8290` | out | 1 | `block_transfer_control.phase_reg_q` |
| unlabeled `Pin@9350,8660` | out | 32 | `ALU.result` |
| `branch_taken`, `condition_pass` | out | 1 each | branch condition result; general condition result |
| 16 register pins at `x=8530` | out | 32 each | `R0..R15`; drawn order R0,R1,R3,R2,R5,R4,R7,R6,R8,R9,R11,R10,R13,R12,R15,R14 |
| unlabeled `Pin@9100,9060` | out | 32 | barrel-shifter output |
| `RD_A` | out | 32 | **effective** A operand after `RA==15 ? PC+8 : raw_RD_A` |
| unlabeled `Pin@8620,9140` | out | 32 | **effective** B operand after `RB==15 ? PC+8 : raw_RD_B` |
| `normal_reg_WE` | out | 1 | condition-gated ordinary ALU register write |
| unlabeled `Pin@6180,9920` | out | 1 | link bit, likely instruction bit 24 (**inferred**) |
| `is_BX`, `is_BL`, `bl_taken` | out | 1 each | raw BX, raw BL, condition-passed BL |
| `mem_class`, `is_STR`, `is_LDR` | out | 1 each | single-transfer class, store, load |
| unlabeled `Pin@9960,10780` | out | 32 | raw RAM read data feeding memory-map read mux |
| `mem_offset`, `memory_address`, `memory_offset_effective` | out | 32 each | immediate offset, selected address, U-signed offset |
| `ldr_reg_we` | out | 1 | condition-gated LDR destination write |

All mappings above are **measured**, except the architectural labels explicitly marked inferred. The unchanged register-pin order is measured from subcircuit port endpoints, not assumed from vertical position.

## 3. Inventory

Full `main` inventory (**measured**): 245 components, 1,072 wires, 283 nets, 689 modelled ports, and 401 directed graph edges.

| Component type | Count | Component type | Count |
|---|---:|---|---:|
| Probe | 53 | Pin | 37 |
| Splitter | 28 | AND Gate | 24 |
| Constant | 23 | Multiplexer | 20 |
| OR Gate | 16 | NOT Gate | 11 |
| Comparator | 8 | Bit Extender | 5 |
| Register | 3 | ROM | 3 |
| Adder | 3 | Shifter | 2 |
| Clock | 1 | XOR Gate | 1 |
| RAM | 1 | `pc_fetch` | 1 |
| `block_transfer_control` | 1 | `reg16x32_1` | 1 |
| `barrel_32b` | 1 | `ALU` | 1 |
| `condition_checker` | 1 |  |  |

Control-specific additions relative to the reference are `NOT@8000,8420`, constants at `8030,8120` and `8420,8120`, `AND@7820,9600`, and appended P/U ports on `block_transfer_control`. Other additions implement PC+8 reads and the program-memory read map.

## 4. Nets

### 4.1 Instruction-field and decode ledger

The instruction bus is graph `net#42` (32 bits). It joins the unmodelled instruction-ROM data output to `Splitter@5580`, `@6590`, `@6600`, `@6950`, `@6990`, and `@7740` combined ports. The graph does not model ROM data pins, so its lack of an explicit driver is a **model limitation**.

| Net / width | Complete control attachments | Meaning / confidence |
|---|---|---|
| `net#42` / 32 | instruction ROM data (unmodelled); six instruction splitters listed above | instruction word, **measured/inferred driver** |
| `net#37` / 16 | `Splitter@6590.bit0 -> block_transfer_control.reg_list_in`, probe | register list `[15:0]`, **measured/inferred** |
| `net#65` / 4 | `Splitter@6600.bit0 -> Mux@8020.in0` | Rm `[3:0]`, **measured/inferred** |
| `net#66` / 8 | `Splitter@6600.bit1 -> Splitter@7800.combined` | operand/shifter `[11:4]`, **measured/inferred** |
| `net#67` / 4 | `Splitter@6600.bit2 -> Rd/link-address mux inputs` | Rd `[15:12]`, **measured/inferred** |
| `net#68` / 4 | `Splitter@6600.bit3 -> regfile.RA, Rn comparator, RA==15 comparator, mux input` | Rn `[19:16]`, **measured/inferred** |
| `net#69` / 1 | `Splitter@6600.bit4 -> LDR/STR inversion, CSPR S gate` | instruction bit 20, **measured/inferred** |
| `net#58` / 4 | `Splitter@6600.bit5 -> link split and ALU decode address` | instruction `[24:21]`, **measured/inferred** |
| `net#70` / 7 | `Splitter@6600.bit6 -> class/condition splits` | instruction `[31:25]`, **measured/inferred** |
| `net#63` / 3 | block-class slice -> `Comparator@7290.a` | instruction `[27:25]`, **measured/inferred** |
| `net#124` / 3 | class slice -> branch/memory gates | instruction `[27:25]`, **measured/inferred** |
| `net#130` / 4 | condition slice -> `condition_checker.cond` | instruction `[31:28]`, **measured/inferred** |
| `net#79` / 24 | branch-immediate slice -> sign extender | instruction `[23:0]`, **measured/inferred** |
| `net#43` / 24 | opcode slice -> BX comparator | instruction `[27:4]`, **measured/inferred** |
| `net#101` / 1 | `instruction[20] -> NOT@8000.in, is_pop.in1`, L probe | L for block transfer, **measured** |
| `net#1` / 1 | `instruction[21] -> OR@8240.in0, AND@7820.in1`, W probe | W, **measured** |
| `net#102` / 1 | instruction bit 22 and B probe | B, observed but not otherwise consumed here, **measured** |
| `net#40` / 1 | `instruction[23] -> block_control.U, NOT@7640.in`, U probe | U, **measured** |
| `net#41` / 1 | `instruction[24] -> block_control.P, pre/post mux/NOT`, P probe | P, **measured** |
| `net#105` / 5 | `{P,U,B,W,L}` -> legacy push/pop comparators, mode probe | raw block mode, **measured** |

The ALU-decode address is `Splitter@7850,8880.combined -> ROM@8230,8620.addr` (`net#137`, 16 bits), assembled from instruction `[24:21]` and zeros. The 10-bit ROM output terminates at `Splitter@8520,8680.combined` (`net#164`). Raw output slice nets `#169..175` and `#233..239` are reported undriven only because ROM output geometry is absent. Destinations identify write-enable, A/B invert, logic, carry-in, and engine-select groups; exact truth-table meanings remain **unresolved**.

### 4.2 Control-net ledger

| Signal | Endpoint-first fanout / expression | Status |
|---|---|---|
| `condition_pass` (`net#3`) | `condition_checker.out0 -> branch, BX, BL, block-valid, CSPR, normal-WE, memory-WE, LDR-WE, base-WE gates` | **measured** |
| `block_transfer` (`net#106`) | `Comparator@7290.eq -> AND@7430.in0` | class `100`, **measured/inferred** |
| `block_transfer_valid` (`net#107`) | `AND@7430.out -> is_push.in0, is_pop.in0` | block class and condition, **measured** |
| `L` (`net#101`) | `instruction[20] -> is_pop.in1, NOT@8000.in` | **measured** |
| `NOT L` (`net#147`) | `NOT@8000.out -> is_push.in1` | **measured** |
| `is_push` (`net#154`) | `AND@8080.out -> start OR` | `valid & !L & 1`, **measured/inferred default constant** |
| `is_pop` (`net#38`) | `AND@8470.out -> start OR, block_control.is_pop` | `valid & L & 1`, **measured/inferred default constant** |
| `start` (`net#39`) | `OR@8650.out -> block_control.start` | **measured** |
| `P`, `U` (`net#41`, `net#40`) | `instruction splitters -> block_control.P/U` and ordinary addressing logic | **measured** |
| `active` (`net#34`) | `block_control.active -> WA mux, RB mux, memory-address mux selects` | **measured** |
| `done` (`net#2`) | `block_control.done -> pending logic, PC apply, WD2 select, AND@7820.in0` | **measured** |
| block-WB request (`net#0`) | `AND@7820.out -> WE2 OR@8090.in0` | `done & W`, **measured** |
| `hold_pc` (`net#12`) | `block_control.hold_pc -> pc_fetch.hold, pc_defer.in1` | **measured** |
| `load_enable` (`net#55`) | `block_control.load_enable -> normal WE/load-data selection` | **measured** |
| `branch_class` (`net#162`) | class gate output -> B/BL/special-class gates | class `101`, **measured/inferred** |
| `is_BL`, `is_B` (`net#166`, `net#6`) | link-bit gate / inverted-link gate | **measured** |
| `branch_taken`, `bl_taken` (`net#7`, `net#80`) | condition-gated B and BL -> relative branch OR | **measured** |
| `is_BX`, `bx_taken` (`net#51`, `net#16`) | BX comparator; then alignment+condition gate -> redirect | **measured** |
| `mem_class` (`net#149`) | `!instruction[27] & instruction[26]` -> LDR/STR gates | class `01x`, **measured/inferred** |
| `is_STR`, `is_LDR` (`net#148`, `net#112`) | memory class with `!L` or `L` | **measured** |
| `data_ram_we` (`net#189`) | `condition_pass & is_STR -> store OR` | **measured topology**; RAM pin geometry unresolved |
| `ldr_reg_we` (`net#144`) | `condition_pass & is_LDR -> register-WE OR` | **measured** |
| `wb_requested` (`net#161`) | `W OR !P -> load/store base-write gates` | **measured** |
| `sbwe` (`net#64`) | `condition_pass & is_STR & wb_requested -> address/data/WE muxes` | **measured** |
| load-base-WE (`net#157`) | `condition_pass & is_LDR & wb_requested -> WE2 OR` | **measured** |
| normal-WE (`net#4`) | `ALU.write_enable_out & condition_pass & !special_class` | **measured** |
| clock (`net#18`) | `Clock.out -> every parent register, RAM clock, pc_fetch, block controller, regfile` | **measured** |
| reset (`net#30`) | reset pin -> every parent register clear and child reset | **measured** |

Raw nets retained although semantics are unclear or unused: legacy `push_mode` `net#135`, `pop_mode` `net#136`, and `rn_is_sp` `net#145` now drive only probes; comparator `gt/lt` outputs are singleton `net#263..274`; block/branch adders' unused carry outputs are `#275`, `#277`, `#278`; branch-adder `cin` is undriven `#276`; `OR@6070.out` is singleton `#59`; `pc_pending.en` is singleton `#261`; north-facing `Mux@7890.sel` is singleton `#262`. The last two are **unresolved** pending live Logisim semantics/geometry validation.

## 5. Signal flow

### Condition and class decode

```text
instruction[31:28].wire -> condition_checker.cond
CSPR.Q.wire -> condition_checker.N/Z/C/V
condition_checker.out0.wire -> condition_pass fanout

instruction[27:25].wire -> ==100 -> block_transfer
instruction[27:25].wire -> ==101 -> branch_class
instruction[27:25].wire -> class 01x -> mem_class
branch_class + instruction[24] -> is_BL
branch_class + NOT instruction[24] -> is_B
mem_class + instruction[20] -> is_LDR
mem_class + NOT instruction[20] -> is_STR
```

### General block-transfer launch

```text
block_transfer & condition_pass -> block_transfer_valid
block_transfer_valid & NOT L & 1 -> is_push
block_transfer_valid & L     & 1 -> is_pop
is_push OR is_pop -> block_transfer_control.start
instruction.P -> block_transfer_control.P
instruction.U -> block_transfer_control.U
block_transfer_control.done & instruction.W -> regfile.WE2
```

This no longer requires Rn==SP or exact PUSH/POP mode constants. The old mode/SP comparators remain physically present as probe-only residue. P and U select the controller's pre/post and direction paths; those internals belong to the controller audit.

### PC and redirect path

```text
instruction[23:0] -> sign_extend -> <<2 -> +8 -> pc_fetch.IMM
relative B/BL OR bx_taken OR pc_apply OR pc_write -> pc_fetch.BRANCH
bx_taken OR pc_apply OR pc_write -> pc_fetch.abs_select
effective_RD_B & 0xfffffffc -> BX target
WA == 15 & regfile.WE -> pc_write
BX_target / WD --pc_write--> current_target
pc_write & block_hold -> pc_defer
pc_defer OR (pc_pending.Q & !done) -> pc_pending.D
pc_pending.Q & done -> pc_apply
current_target / pc_target.Q --pc_apply--> pc_fetch.abs_target
```

The audited `pc_fetch` child gives `hold` highest priority. Therefore the apparently simultaneous `pc_write` redirect during a transfer is suppressed, while `pc_target` and `pc_pending` capture it; `pc_apply` repeats BRANCH+abs_select on completion.

### Architectural PC reads added in debug

```text
pc_fetch.pc_out[9:0] -> zero_extend -> <<2 -> +8 -> pc_plus8_value
regfile.RD_A / pc_plus8_value --(RA==15)--> effective_RD_A
regfile.RD_B / pc_plus8_value --(RB==15)--> effective_RD_B
```

These effective outputs feed ALU A, base addressing, block base, barrel/BX input, and the debug output pins. This is a datapath addition but its RA/RB comparators and mux selects are control boundaries.

`pc_fetch.pc_out` is only 10 bits. Zero-extension therefore discards architectural PC bits `[31:12]`; the substitution produces the expected PC+8 only while execution remains inside the 4 KiB fetch window. This is a **measured width limitation**, not merely a graph artifact.

### Memory-map read selection added in debug

```text
memory_address[11:2].wire -> ROM@5400,12600.addr
memory_address[12].wire -> NOT@5300 -> read_source_mux.sel
RAM_read_data / program_ROM_data --NOT address[12]--> Mux@6200.out
Mux@6200.out -> load-data writeback mux
```

Thus reads below `0x1000` select program ROM and reads at/above it select data RAM (**inferred from measured mux polarity**). Store enable is not gated by address bit 12 in this parent control, so read/write behavior below `0x1000` is asymmetric.

### Enables and flags

```text
ALU.write_enable_out & condition_pass & NOT(BX|branch|memory) -> normal_reg_WE
normal_reg_WE OR bl_taken OR ldr_reg_we OR sbwe -> regfile.WE
condition_pass & is_STR & (W | !P) -> sbwe
condition_pass & is_LDR & (W | !P) -> load_base_write_enable
(done & W) OR load_base_write_enable -> regfile.WE2

ALU.{N,Z,C,V} -> CSPR.D
condition_pass & instruction_bit20 & NOT(BX|branch|memory) -> CSPR.en
CSPR.Q -> condition_checker flags
```

`ALU.Cflag` remains tied to constant zero in this file; the carry-arithmetic correction exists elsewhere, not in this measured debug source.

## 6. State and cycles

| State | Measured next-state/control | Role |
|---|---|---|
| `CSPR` 4-bit | ALU flags, gated by decoded S/condition/class | current N/Z/C/V flags |
| `pc_pending` 1-bit | `pc_defer OR (Q & !done)` | holds a delayed PC redirect request |
| `pc_target` 32-bit | effective BX/WD target, enabled by pc_write | delayed absolute target |
| `block_transfer_control` | start, is_pop/L, P, U, register list/base, clock/reset | multi-cycle LDM/STM sequencing |
| `pc_fetch` | hold/branch/targets/clock/reset | PC register and PC+4 |
| `reg16x32_1` | normal and secondary write ports | architectural integer register state |

Measured feedback: `pc_pending.Q -> AND@4670 -> OR@4780 -> pc_pending.D`. Cross-instruction flag dependency: `CSPR.Q -> condition_checker -> condition-gated execution -> ALU flags -> CSPR.D`. The port graph omits component-internal arcs, so its SCC result is not a complete circuit-cycle detector.

## 7. Hierarchy

| Instance | Parent control mapping |
|---|---|
| `pc_fetch@5780,8630` | `CLK<-clock`, `RST<-reset`, `hold<-block.hold_pc`, `BRANCH<-OR@4950.out`, `IMM<-branch adder`, `abs_target<-Mux@5040.out`, `abs_select<-OR@5010.out`; outputs `pc_out[9:0]`, `pc_plus4[31:0]` |
| `block_transfer_control@5790,8110` | original `clk/rst/start/is_pop/reg_list/base` plus appended `P<-instruction[24]`, `U<-instruction[23]`; all controller outputs mapped in the net ledger |
| `reg16x32_1@8530,8960` | control ports RA/RB/WA/WE/WA2/WE2/CLK/RST; raw RD_A/RD_B pass through PC-read muxes before use |
| `ALU@9190,8660` | 10-bit decode ROM controls write/invert/select pins; flags return to CSPR; saved carry is not connected |
| `condition_checker@9860,8760` | condition field plus CSPR flags -> global `condition_pass` |
| `barrel_32b@9100,9130` | input/type/amount mux controls from instruction fields |

## 8. Health

- Graph health (**measured**): 14 apparent undriven nets, zero multi-driver nets, 40 singleton/dangling nets, and three reported dead-output components.
- Thirteen apparent undriven ALU-control nets are the unmodelled data output of `ROM@8230`; not a circuit defect.
- `Pin@9960,10780` and the program ROM data input of `Mux@6200` are unmodelled memory outputs; not floating hardware by inspection.
- `OR@6070.out` is genuinely unconsumed. It computes `done OR hold_pc` and has no effect.
- Legacy exact-PUSH/POP comparators and Rn==SP comparator are dead functional residue, though their equality outputs remain connected to probes.
- `pc_pending.en` and rotated `Mux@7890.sel` appear dangling; classification is **unresolved**, not a confirmed circuit fault.
- `OR@9080` and `Constant@9560` appear dead only because RAM geometry is incomplete; datapath inspection assigns them to the store/RAM path.
- The B bit is extracted and probed but does not control byte-lane behavior in this visible parent control. Whether byte transfers are implemented inside another datapath path is **unresolved here**.
- Program-ROM reads and RAM writes are asymmetrical below `0x1000`; store enable lacks an address-range gate (**measured/inferred consequence**).
- PC+8 operand substitution starts from 10-bit `pc_out`; R15 reads lose PC bits `[31:12]` and are only correct within the current 4 KiB instruction window (**measured width risk**).
- Saved CPSR carry is not wired into `ALU.Cflag`; ADC/SBC carry behavior is a real measured gap in this source.

## 9. Debug delta

The complete structured comparison is in `../main_control_delta.md`. Control delta in one sentence: exact SP PUSH/POP recognition became class+L recognition, P/U reach the controller, W gates block base writeback, and PC+8/memory-map selection layers were added without changing branch/condition/CPSR structure.

## 10. Human map

This debug parent behaves like the reference CPU's control shell with three important generalizations. Any condition-passed block-transfer instruction launches the multi-cycle controller; L chooses load versus store, P/U determine addressing, and W determines final base writeback. Reads of R15 are replaced with the current word PC plus eight before operands enter the datapath. Loads select instruction ROM or data RAM by address region, allowing literal-pool reads. Everything else—condition gating, the small ALU-control ROM, B/BL/BX redirects, deferred PC writes, ordinary LDR/STR writeback, and flag storage—retains the original structure.

## 11. Cross-circuit links

- **`pc_fetch` reconciliation:** child equation is `PC_D = hold ? PC_Q : (BRANCH ? (abs_select ? abs_target : PC_Q+IMM) : PC_Q+4)`. Main intentionally drives BRANCH and abs_select together for BX, PC writes, and deferred PC writes.
- **Main datapath reconciliation:** raw regfile nets are RD_A `net#167` and RD_B `net#168`; effective PC-substituted nets are RD_A `net#32` and RD_B `net#44`. Control comparisons use RA/RB==15 to select PC+8.
- **Shared PC-width warning:** the datapath auditor independently confirmed the PC+8 construction loses PC bits `[31:12]`; both reports classify it as a real 4 KiB-range limitation.
- **RAM graph limitation:** generated `RAM.we` naming at the RD_B/store-data endpoint is wrong because the memory box geometry is incomplete. This audit uses raw topology and the datapath auditor's reconciliation instead.
- **Controller dependency:** P/U parent wires are measured, but proof of all IA/IB/DA/DB sequences belongs to `block_transfer_control`'s audit/tests.

## 12. Confidence

- **Measured:** all components, attributes, endpoints, graph nets, constants, gate connections, P/U appended ports, W writeback gate, PC-read comparator/mux endpoints, memory-map selector endpoints, state feedback, and health counts.
- **Inferred:** ARM field names, class equations, default unlabeled constants as logic one, PC+8 and memory-map architectural intent, and semantics of unlabeled top-level outputs.
- **Unresolved:** ALU decode-ROM truth table; floating/omitted register-enable and rotated-mux-select semantics; exact unmodelled ROM/RAM output-pin coordinates; B/byte-lane implementation outside this control partition.
