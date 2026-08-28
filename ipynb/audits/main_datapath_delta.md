# `main` datapath delta — `armv4t.circ` → `debug_armv4t.circ`

## Scope and evidence

- Both circuit files were treated as read-only.
- Component/XML/wire/graph differences are **measured**. Architectural interpretations are **inferred**. ROM/RAM full-pin geometry and two width questions remain **unresolved**.
- Whole-file SHA-256: arm `ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84`; debug `eaaeadc774fa99daf6a304403b9c8556210b836b52b79de99bdea7d08ff225c9`.

## Measured summary

| Metric | arm | debug | Delta |
|---|---:|---:|---:|
| Components | 226 | 245 | +19 |
| Wire segments | 882 | 1072 | +190 |
| Modeled port nodes | 636 | 689 | +53 |
| Electrical nets | 256 | 283 | +27 |
| Directed edges | 374 | 401 | +27 |
| Graph-only new directed connections | — | — | +42 |
| Graph-only removed directed connections | — | — | −15 |

## Exact component delta

No main-level component was removed or moved. The following 19 components exist only in debug:

| Added component | Attributes | Datapath role | Confidence |
|---|---|---|---|
| `Constant@8030,8120` | `{'facing': 'north'}` | constant-one input for generalized STM start | component measured; role inferred |
| `Constant@8420,8120` | `{'facing': 'north'}` | constant-one input for generalized LDM start | component measured; role inferred |
| `NOT Gate@8000,8420` | `{}` | derive store class from L | component measured; role inferred |
| `AND Gate@7820,9600` | `{}` | gate block final-address writeback with W | component measured; role inferred |
| `Bit Extender@8900,11780` | `{'in_width': '10', 'out_width': '32', 'type': 'zero'}` | zero-extend 10-bit PC word index | component measured; role inferred |
| `Shifter@9060,11820` | `{'width': '32'}` | convert word index to byte address | component measured; role inferred |
| `Constant@8900,11850` | `{'value': '0x2', 'width': '5'}` | support constant/control for the listed datapath overlay | component measured; role inferred |
| `Constant@8900,11950` | `{'value': '0x8', 'width': '32'}` | support constant/control for the listed datapath overlay | component measured; role inferred |
| `Adder@9220,11950` | `{'width': '32'}` | form reconstructed low-window PC+8 | component measured; role inferred |
| `Multiplexer@9480,11950` | `{'width': '32'}` | substitute PC+8 for RD_A | component measured; role inferred |
| `Constant@8900,12020` | `{'value': '0x0'}` | support constant/control for the listed datapath overlay | component measured; role inferred |
| `Constant@8900,12130` | `{'value': '0xf', 'width': '4'}` | support constant/control for the listed datapath overlay | component measured; role inferred |
| `Comparator@9220,12130` | `{'width': '4'}` | detect RA == r15 | component measured; role inferred |
| `Multiplexer@9480,12190` | `{'width': '32'}` | substitute PC+8 for RD_B | component measured; role inferred |
| `Comparator@9220,12250` | `{'width': '4'}` | detect RB == r15 | component measured; role inferred |
| `NOT Gate@5300,12470` | `{}` | invert address-map select | component measured; role inferred |
| `Splitter@5000,12600` | `{'bit1': '0', 'bit10': '1', 'bit11': '1', 'bit12': '2', 'bit13': '3', 'bit14': '3', 'bit15': '3', 'bit16': '3', 'bit17': '3', 'bit18': '3', 'bit19': '3', 'bit2': '1', 'bit20': '3', 'bit21': '3', 'bit22': '3', 'bit23': '3', 'bit24': '3', 'bit25': '3', 'bit26': '3', 'bit27': '3', 'bit28': '3', 'bit29': '3', 'bit3': '1', 'bit30': '3', 'bit31': '3', 'bit4': '1', 'bit5': '1', 'bit6': '1', 'bit7': '1', 'bit8': '1', 'bit9': '1', 'fanout': '4', 'incoming': '32', 'spacing': '4'}` | memory-address partition for mapped ROM/RAM | component measured; role inferred |
| `ROM@5400,12600` | `{'addrWidth': '10', 'appearance': 'logisim_evolution', 'contents': None, 'dataWidth': '32'}` | duplicate program ROM for literal/data reads | component measured; role inferred |
| `Multiplexer@6200,12600` | `{'width': '32'}` | mapped ROM-versus-RAM load-data select | component measured; role inferred |

The `block_transfer_control@5790,8110` instance is not a new component, but its child interface grows by measured input ports `U` and `P`, yielding two of the 53 new modeled nodes.

## Semantic datapath deltas

### 1. Architectural PC reads

- Arm: `reg16x32_1.RD_A -> ALU.A/address base` and `reg16x32_1.RD_B -> operand/store path` directly.
- Debug: `pc_fetch.pc_out -> zero-extend -> <<2 -> +8`; RA/RB comparators select that value when the corresponding source address is r15.
- **Unresolved limitation:** `pc_out` exports only PC[11:2]. Debug reconstructs `(zeroextend(PC[11:2]) << 2) + 8`, losing PC[31:12]. This is valid only inside the current 4 KiB code window.

### 2. Literal/program-memory reads without another fetch port

- Arm load data comes directly from the data RAM output.
- Debug fans the computed memory address into a second 1024×32 ROM, selects ROM below 0x1000 and RAM at/above 0x1000, then feeds the existing load-data mux.
- This is functionally a literal-pool/program-memory read overlay but physically duplicates the ROM LUT/select tree (**inferred from topology and attributes**).
- **Unresolved width risk:** the new address splitter appears to group bits 1..11 into an 11-bit slice while the mapped ROM declares `addrWidth=10`.

### 3. Block transfer

- Arm recognizes only exact PUSH/POP encodings and its controller interface has no P/U.
- Debug generalizes start from class-valid plus L/!L, wires P/U into the child controller, and changes secondary-port base writeback from `done` to `done AND W`.
- Store/load data and transfer-address main paths otherwise remain structurally shared.

### 4. Unchanged carry defect

- Both files contain `Constant@8970,8760.p.wire -> ALU@9190,8660.Cflag` with value zero. Debug therefore does not include the later sandbox ADC/SBC carry fix.

## Raw directed graph delta

Coordinates below are stable machine identities, not human wiring instructions. Edges through unmodelled memories can be absent or misnamed.

### Removed arm-directed edges

| Source port | Destination port |
|---|---|
| `Comparator@7840,8250.eq` | `AND Gate@8080,8040.in1` |
| `Comparator@7840,8320.eq` | `AND Gate@8470,8040.in1` |
| `Comparator@8260,8280.eq` | `AND Gate@8080,8040.in2` |
| `Comparator@8260,8280.eq` | `AND Gate@8470,8040.in2` |
| `block_transfer_control@5790,8110.done` | `OR Gate@8090,9390.in0` |
| `reg16x32_1@8530,8960.RD_A` | `ALU@9190,8660.A` |
| `reg16x32_1@8530,8960.RD_A` | `Adder@8450,10820.a` |
| `reg16x32_1@8530,8960.RD_A` | `Multiplexer@8550,10810.in0` |
| `reg16x32_1@8530,8960.RD_A` | `Pin@8770,9080[RD_A].p` |
| `reg16x32_1@8530,8960.RD_A` | `Probe@8380,10730.p` |
| `reg16x32_1@8530,8960.RD_A` | `block_transfer_control@5790,8110.base_value` |
| `reg16x32_1@8530,8960.RD_B` | `AND Gate@6090,10270[bx_arm_target].in0` |
| `reg16x32_1@8530,8960.RD_B` | `Multiplexer@8820,9130.in0` |
| `reg16x32_1@8530,8960.RD_B` | `Pin@8620,9140.p` |
| `reg16x32_1@8530,8960.RD_B` | `Splitter@5660,10210.combined` |

### Added debug-directed edges

| Source port | Destination port |
|---|---|
| `AND Gate@7820,9600.out` | `OR Gate@8090,9390.in0` |
| `Adder@9220,11950.out` | `Multiplexer@9480,11950.in1` |
| `Adder@9220,11950.out` | `Multiplexer@9480,12190.in1` |
| `Bit Extender@8900,11780.out` | `Shifter@9060,11820.in` |
| `Comparator@9220,12130.eq` | `Multiplexer@9480,11950.sel` |
| `Comparator@9220,12250.eq` | `Multiplexer@9480,12190.sel` |
| `Constant@8030,8120.p` | `AND Gate@8080,8040.in2` |
| `Constant@8420,8120.p` | `AND Gate@8470,8040.in2` |
| `Constant@8900,11850.p` | `Shifter@9060,11820.dist` |
| `Constant@8900,11950.p` | `Adder@9220,11950.b` |
| `Constant@8900,12020.p` | `Adder@9220,11950.cin` |
| `Constant@8900,12130.p` | `Comparator@9220,12130.b` |
| `Constant@8900,12130.p` | `Comparator@9220,12250.b` |
| `Multiplexer@6200,12600.out` | `Multiplexer@7670,9060.in1` |
| `Multiplexer@8070,8830.out` | `Comparator@9220,12250.a` |
| `Multiplexer@8660,10820.out` | `Splitter@5000,12600.combined` |
| `Multiplexer@9480,11950.out` | `ALU@9190,8660.A` |
| `Multiplexer@9480,11950.out` | `Adder@8450,10820.a` |
| `Multiplexer@9480,11950.out` | `Multiplexer@8550,10810.in0` |
| `Multiplexer@9480,11950.out` | `Pin@8770,9080[RD_A].p` |
| `Multiplexer@9480,11950.out` | `Probe@8380,10730.p` |
| `Multiplexer@9480,11950.out` | `block_transfer_control@5790,8110.base_value` |
| `Multiplexer@9480,12190.out` | `AND Gate@6090,10270[bx_arm_target].in0` |
| `Multiplexer@9480,12190.out` | `Multiplexer@8820,9130.in0` |
| `Multiplexer@9480,12190.out` | `Pin@8620,9140.p` |
| `Multiplexer@9480,12190.out` | `Splitter@5660,10210.combined` |
| `NOT Gate@5300,12470.out` | `Multiplexer@6200,12600.sel` |
| `NOT Gate@8000,8420.out` | `AND Gate@8080,8040.in1` |
| `ROM@5400,12600.addr` | `Splitter@5000,12600.bit1` |
| `ROM@5890,8620.addr` | `Bit Extender@8900,11780.in` |
| `Shifter@9060,11820.out` | `Adder@9220,11950.a` |
| `Splitter@5000,12600.bit2` | `NOT Gate@5300,12470.in` |
| `Splitter@6600,8680.bit3` | `Comparator@9220,12130.a` |
| `Splitter@6990,10790.bit20` | `AND Gate@8470,8040.in1` |
| `Splitter@6990,10790.bit20` | `NOT Gate@8000,8420.in` |
| `Splitter@6990,10790.bit21` | `AND Gate@7820,9600.in1` |
| `Splitter@6990,10790.bit23` | `block_transfer_control@5790,8110.U` |
| `Splitter@6990,10790.bit24` | `block_transfer_control@5790,8110.P` |
| `block_transfer_control@5790,8110.done` | `AND Gate@7820,9600.in0` |
| `pc_fetch@5780,8630.pc_out` | `Bit Extender@8900,11780.in` |
| `reg16x32_1@8530,8960.RD_A` | `Multiplexer@9480,11950.in0` |
| `reg16x32_1@8530,8960.RD_B` | `Multiplexer@9480,12190.in0` |

## Cross-agent reconciliation

- `pc_fetch` audit confirms no internal child delta and confirms hold priority. The PC+8 behavior is exclusively the debug main-side overlay described here.
- `main_control` audit owns the generalized block start, P/U control, and W-gated write enable; this report owns the addresses/data that those controls select.
- Both auditors agree the control-ROM and data-memory port graphs are incomplete because `geometry.py` intentionally does not model ROM/RAM far-edge data pins.
- **Resolved graph contradiction:** the current RAM geometry labels y=10740 as `data_in` and y=10780 as `we`; raw fan-in proves y=10740 is write-enable and y=10780 is write-data for this appearance. The RAM data output is the unmodelled far-edge endpoint `(9860,10780)`.
- **Unresolved:** mapped-ROM address slice width and PC+8 behavior outside the low 4 KiB window.

## Confidence

- **Measured:** component/wire/node/net counts, exact component additions, exact model-derived edge set, child port additions, constant-tied ALU carry input.
- **Inferred:** architectural role of PC+8 substitution, memory-map select polarity, block-transfer intent.
- **Unresolved:** full ROM/RAM geometry, mapped-ROM slice width, high-PC behavior.

