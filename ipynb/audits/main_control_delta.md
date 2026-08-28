# `main` control delta: `armv4t.circ` -> `debug_armv4t.circ`

## Scope and identity

This compares only the `main` decode/control partition, while retaining adjacent datapath connections whenever a control select changed. Inputs were read-only.

| Source | SHA-256 |
|---|---|
| `armv4t.circ` | `ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84` |
| `debug_armv4t.circ` | `eaaeadc774fa99daf6a304403b9c8556210b836b52b79de99bdea7d08ff225c9` |

The graph diff is **measured**: `+53/-0` modelled port nodes and `+42/-15` directed endpoint connections in debug. At whole-`main` level debug has 245 versus 226 components, 1,072 versus 882 wires, 283 versus 256 nets, and 401 versus 374 directed edges.

## Component inventory delta

Debug adds 19 components and removes none:

| Type | Delta | Added role |
|---|---:|---|
| Constant | +6 | block gate tie-highs, PC+8 constants, address comparisons |
| Multiplexer | +3 | two PC-read substitutions; memory-map read source |
| NOT Gate | +2 | `NOT L` block direction; memory-map region select |
| Comparator | +2 | RA==15 and RB==15 |
| AND Gate | +1 | `done AND W` block writeback |
| Adder | +1 | PC+8 construction |
| Bit Extender | +1 | zero-extend word PC |
| Shifter | +1 | word-PC to byte-PC (`<<2`) |
| Splitter | +1 | memory-address region/ROM index |
| ROM | +1 | program memory access from the data path |

The existing `block_transfer_control` instance also gains two port nodes, `P` and `U`, because its child interface was appended without shifting the prior ports.

## Functional control changes

### 1. Block launch generalized

Reference equations (**measured topology**):

```text
is_push = block_transfer_valid & (mode == 0x12) & (Rn == 13)
is_pop  = block_transfer_valid & (mode == 0x0b) & (Rn == 13)
```

Debug equations:

```text
is_push = block_transfer_valid & NOT L & 1
is_pop  = block_transfer_valid & L     & 1
```

Endpoint changes:

```text
- Comparator@7840,8250.eq.wire -> AND@8080,8040.in1
- Comparator@8260,8280.eq.wire -> AND@8080,8040.in2
+ NOT@8000,8420.out.wire       -> AND@8080,8040.in1
+ Constant@8030,8120.out.wire  -> AND@8080,8040.in2

- Comparator@7840,8320.eq.wire -> AND@8470,8040.in1
- Comparator@8260,8280.eq.wire -> AND@8470,8040.in2
+ instruction_L.wire           -> AND@8470,8040.in1
+ Constant@8420,8120.out.wire  -> AND@8470,8040.in2
```

The exact-mode and SP comparators remain in debug but only feed probes/unused outputs. They are residue, not active launch control.

### 2. P/U reach the controller

```text
+ instruction_U.wire -> block_transfer_control@5790,8110.U
+ instruction_P.wire -> block_transfer_control@5790,8110.P
```

This is the parent-side prerequisite for IA/IB/DA/DB addressing. Whether every address sequence is correct is delegated to the controller audit/tests.

### 3. Block base writeback respects W

Reference:

```text
block_transfer_control.done.wire -> OR@8090,9390.in0 -> regfile.WE2
```

Debug:

```text
block_transfer_control.done.wire -> AND@7820,9600.in0
instruction_W.wire               -> AND@7820,9600.in1
AND@7820,9600.out.wire            -> OR@8090,9390.in0 -> regfile.WE2
```

Thus debug writes the block base back only when W=1. Ordinary LDR/STR base writeback remains `condition & class & (W OR !P)` in both files.

### 4. Architectural R15 reads become PC+8

Reference sends raw regfile outputs directly to consumers. Debug interposes two muxes:

```text
pc_fetch.pc_out[9:0] -> zero_extend -> <<2 -> +8 -> pc_plus8
regfile.RD_A / pc_plus8 --(RA==15)--> effective_RD_A
regfile.RD_B / pc_plus8 --(RB==15)--> effective_RD_B
```

Every former raw-A consumer is moved behind `Mux@9480,11950`; every former raw-B consumer behind `Mux@9480,12190`. This is a datapath change controlled by the new RA/RB comparators. The main-datapath auditor independently measured raw debug nets `RD_A=#167`, `RD_B=#168`, effective nets `RD_A=#32`, `RD_B=#44`.

Width warning: `pc_fetch.pc_out` is 10 bits. The new zero extender therefore drops PC `[31:12]`; architectural R15 reads are correct only within the current 4 KiB fetch window. This is a **measured debug limitation**.

### 5. Program memory is readable by loads

Debug adds:

```text
memory_address[11:2].wire -> ROM@5400,12600.addr
memory_address[12].wire -> NOT@5300,12470.in
RAM_read_data / ROM_read_data --NOT address[12]--> Mux@6200,12600
Mux@6200.out.wire -> Mux@7670,9060.in1
```

This selects program ROM below `0x1000` and RAM at/above `0x1000` (**inferred from measured mux polarity**). RAM store enable is not range-gated, so stores below `0x1000` still reach RAM while reads there select ROM.

## Unchanged control

Measured unchanged at the endpoint/component level:

- condition field -> `condition_checker` and global `condition_pass` fanout;
- branch-class `101`, memory-class `01x`, B/BL gates, BX opcode/alignment gate;
- relative branch offset sign-extension, shift-left-two, and `+8`;
- PC-write detection `WA==15 & WE`;
- `pc_defer`, `pc_pending`, `pc_target`, and `pc_apply` network;
- `pc_fetch` branch/absolute-target interface and hold priority;
- ALU-control ROM, ALU flag D wiring, CSPR enable equation;
- ordinary LDR/STR write enables and `W OR !P` base-write request;
- common clock and reset distribution.

Saved carry also remains unchanged: `ALU.Cflag` is constant zero in both audited files.

## Complete mechanical endpoint diff

The following is the lossless graph connection delta. Splitter-through edges and memory-output limitations explain some low-level entries; the functional grouping above is authoritative.

### Removed endpoint edges (15)

```text
Comparator@7840,8250.eq -> AND Gate@8080,8040.in1
Comparator@7840,8320.eq -> AND Gate@8470,8040.in1
Comparator@8260,8280.eq -> AND Gate@8080,8040.in2
Comparator@8260,8280.eq -> AND Gate@8470,8040.in2
block_transfer_control@5790,8110.done -> OR Gate@8090,9390.in0
reg16x32_1@8530,8960.RD_A -> ALU@9190,8660.A
reg16x32_1@8530,8960.RD_A -> Adder@8450,10820.a
reg16x32_1@8530,8960.RD_A -> Multiplexer@8550,10810.in0
reg16x32_1@8530,8960.RD_A -> Pin@8770,9080[RD_A]
reg16x32_1@8530,8960.RD_A -> Probe@8380,10730
reg16x32_1@8530,8960.RD_A -> block_transfer_control@5790,8110.base_value
reg16x32_1@8530,8960.RD_B -> AND Gate@6090,10270[bx_arm_target].in0
reg16x32_1@8530,8960.RD_B -> Multiplexer@8820,9130.in0
reg16x32_1@8530,8960.RD_B -> Pin@8620,9140
reg16x32_1@8530,8960.RD_B -> Splitter@5660,10210.combined
```

### Added endpoint edges (42)

```text
AND Gate@7820,9600.out -> OR Gate@8090,9390.in0
Adder@9220,11950.out -> Multiplexer@9480,11950.in1
Adder@9220,11950.out -> Multiplexer@9480,12190.in1
Bit Extender@8900,11780.out -> Shifter@9060,11820.in
Comparator@9220,12130.eq -> Multiplexer@9480,11950.sel
Comparator@9220,12250.eq -> Multiplexer@9480,12190.sel
Constant@8030,8120.out -> AND Gate@8080,8040.in2
Constant@8420,8120.out -> AND Gate@8470,8040.in2
Constant@8900,11850.out -> Shifter@9060,11820.dist
Constant@8900,11950.out -> Adder@9220,11950.b
Constant@8900,12020.out -> Adder@9220,11950.cin
Constant@8900,12130.out -> Comparator@9220,12130.b
Constant@8900,12130.out -> Comparator@9220,12250.b
Multiplexer@6200,12600.out -> Multiplexer@7670,9060.in1
Multiplexer@8070,8830.out -> Comparator@9220,12250.a
Multiplexer@8660,10820.out -> Splitter@5000,12600.combined
Multiplexer@9480,11950.out -> ALU@9190,8660.A
Multiplexer@9480,11950.out -> Adder@8450,10820.a
Multiplexer@9480,11950.out -> Multiplexer@8550,10810.in0
Multiplexer@9480,11950.out -> Pin@8770,9080[RD_A]
Multiplexer@9480,11950.out -> Probe@8380,10730
Multiplexer@9480,11950.out -> block_transfer_control@5790,8110.base_value
Multiplexer@9480,12190.out -> AND Gate@6090,10270[bx_arm_target].in0
Multiplexer@9480,12190.out -> Multiplexer@8820,9130.in0
Multiplexer@9480,12190.out -> Pin@8620,9140
Multiplexer@9480,12190.out -> Splitter@5660,10210.combined
NOT Gate@5300,12470.out -> Multiplexer@6200,12600.sel
NOT Gate@8000,8420.out -> AND Gate@8080,8040.in1
ROM@5400,12600.addr <-> Splitter@5000,12600.bit1
Shifter@9060,11820.out -> Adder@9220,11950.a
Splitter@5000,12600.bit2 -> NOT Gate@5300,12470.in
Splitter@6600,8680.bit3 -> Comparator@9220,12130.a
Splitter@6990,10790.bit20 -> AND Gate@8470,8040.in1
Splitter@6990,10790.bit20 -> NOT Gate@8000,8420.in
Splitter@6990,10790.bit21 -> AND Gate@7820,9600.in1
Splitter@6990,10790.bit23 -> block_transfer_control@5790,8110.U
Splitter@6990,10790.bit24 -> block_transfer_control@5790,8110.P
block_transfer_control@5790,8110.done -> AND Gate@7820,9600.in0
pc_fetch@5780,8630.pc_out -> Bit Extender@8900,11780.in
reg16x32_1@8530,8960.RD_A -> Multiplexer@9480,11950.in0
reg16x32_1@8530,8960.RD_B -> Multiplexer@9480,12190.in0
ROM@5890,8620.addr-net -> Bit Extender@8900,11780.in
```

The last line is the graph's same-net representation of `pc_fetch.pc_out`, the instruction-ROM address, and the new extender input; it is not a ROM-data flow.

## Health delta

- No multi-driver nets in either graph.
- Apparent undriven nets remain 14 in each; these are dominated by unmodelled ROM/RAM outputs.
- Dangling/singleton nets increase 32 -> 40, largely from added comparator `gt/lt`, adder carry, and address-splitter unused outputs.
- `OR@6070.out`, `pc_pending.en`, and north-facing load-WE mux select remain unresolved/unused in both.
- Debug intentionally leaves exact push/pop and SP comparators as inactive probe logic.
- Debug's PC+8 path adds a real width risk: zero-extending 10-bit `pc_out` loses PC bits `[31:12]`.

## Cross-agent reconciliation and contradictions

- **PC fetch:** no contradiction. The pc-fetch auditor confirmed hold priority and the main-side protocol: OR@4950 drives BRANCH, OR@5010 drives abs_select, Mux@5040 drives abs_target, and pending logic reapplies an absolute redirect after block completion.
- **Main datapath:** no contradiction. The datapath auditor confirmed effective debug RD_A/RD_B PC+8 mux layers and control boundaries.
- **PC read width:** both auditors independently identify the 10-bit `pc_out` source as limiting PC+8 substitution to the 4 KiB fetch region.
- **RAM geometry:** shared known model limitation. The graph-generated `RAM.we` name on the RD_B/store-data endpoint is not semantically reliable; neither audit treats it as a circuit short.
- **Unresolved:** exact ALU control-ROM truth-table meanings; omitted enable/select semantics for `pc_pending` and the rotated WE mux; live proof of every P/U addressing sequence.

## Confidence

- **Measured:** every count, node/edge diff, endpoint line, component attribute, and unchanged/changed topology claim.
- **Inferred:** ARM semantics, PC+8 and memory-region intent, default unlabeled constants as one, and consequences of mux polarity.
- **Unresolved:** the explicit items in the reconciliation section; no disagreement between the main-control, main-datapath, and pc-fetch auditors remains.
