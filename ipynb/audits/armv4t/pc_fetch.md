# `pc_fetch` audit — `armv4t.circ`

## 1. Identity and purpose

- **Source:** `armv4t.circ`, whole-file SHA-256 `ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84`. **[Measured]**
- **Circuit:** `pc_fetch`; XML-subtree SHA-256 `a727a1d1451dcbb0ba72266b205da962792e20e6aadc03e8ce5ffb77b6b3fc7f`. **[Measured]**
- **Role:** owns the 32-bit program-counter register, forms `PC+4` and `PC+IMM`, selects relative or absolute redirects, freezes the PC on `hold`, and exports the ROM word address `PC[11:2]`. **[Measured structure; inferred role]**
- Circuit attributes: `appearance=logisim_evolution`, `circuit=pc_fetch`, `circuitnamedboxfixedsize=true`, `simulationFrequency=1000.0`. **[Measured]**

## 2. Interface

Logisim instance-port order is outputs first (sorted by pin `(y,x)`), then inputs in the same order. **[Measured against `logisim.model.Circuit.pins`]**

| Port | Dir. | Width | Pin facing | Electrical endpoint | Role |
|---|---:|---:|---|---|---|
| `pc_plus4` | out | 32 | west | `Pin@860,860[pc_plus4].p` | Full-width `PC_Q + 4`. **[Measured]** |
| `pc_out` | out | 10 | west | `Pin@640,1030[pc_out].p` | Instruction-ROM word address `PC_Q[11:2]`. **[Measured]** |
| `CLK` | in | 1 | east | `Pin@420,860[CLK].p` | PC-register clock. **[Measured]** |
| `BRANCH` | in | 1 | north | `Pin@1130,860[BRANCH].p` | Enables the redirect path instead of sequential `PC+4`. **[Measured]** |
| `hold` | in | 1 | east | `Pin@1230,880[hold].p` | Highest-priority PC freeze. **[Measured]** |
| `IMM` | in | 32 | east | `Pin@640,920[IMM].p` | Addend for the relative target `PC_Q+IMM`. **[Measured]** |
| `abs_target` | in | 32 | east | `Pin@970,930[abs_target].p` | Absolute redirect target. **[Measured]** |
| `abs_select` | in | 1 | north | `Pin@1020,940[abs_select].p` | Chooses `abs_target` over `PC_Q+IMM`, but only inside the `BRANCH=1` path. **[Measured]** |
| `RST` | in | 1 | north | `Pin@460,970[RST].p` | PC-register clear. **[Measured structure; active-high clear inferred from standard Register semantics]** |

## 3. Inventory

There are **20 components** and **33 wire segments**. The extracted model forms **27 electrical nets**, **49 port nodes**, and **22 directed inter-component edges**. Endpoint coverage is **47/47 (100%)**; this circuit contains no unmodelled component type. **[Measured]**

| Type | Count | Instances and every explicit attribute |
|---|---:|---|
| Pin | 9 | `CLK@420,860 {appearance=NewPins,label=CLK}`; `BRANCH@1130,860 {appearance=NewPins,facing=north,label=BRANCH}`; `hold@1230,880 {appearance=NewPins,label=hold}`; `IMM@640,920 {appearance=NewPins,label=IMM,radix=16,width=32}`; `abs_target@970,930 {appearance=NewPins,label=abs_target,radix=16,width=32}`; `abs_select@1020,940 {appearance=NewPins,facing=north,label=abs_select}`; `RST@460,970 {appearance=NewPins,facing=north,label=RST}`; `pc_plus4@860,860 {appearance=NewPins,facing=west,label=pc_plus4,output=true,radix=16,width=32}`; `pc_out@640,1030 {appearance=NewPins,facing=west,label=pc_out,output=true,radix=16,width=10}`. **[Measured]** |
| Register | 1 | `Register@430,790[PC] {appearance=logisim_evolution,label=PC,width=32}`. **[Measured]** |
| Adder | 2 | `Adder@750,830 {width=32}`; `Adder@750,910 {width=32}`. **[Measured]** |
| Multiplexer | 3 | `Multiplexer@1040,920 {width=32}`; `Multiplexer@1150,840 {width=32}`; `Multiplexer@1250,850 {width=32}`. Their absent `select` attribute means the standard one-bit/two-input mux default. **[Measured attrs; default inferred]** |
| Constant | 4 | `Constant@370,840 {}`; `Constant@610,840 {value=0x4,width=32}`; `Constant@730,810 {facing=south,value=0x0}`; `Constant@730,890 {facing=south,value=0x0}`. The attribute-free constant is the standard one-bit value `1`, used as `PC.en`. **[Measured attrs; value 1 inferred from Logisim default]** |
| Splitter | 1 | `Splitter@500,970 {incoming=32,fanout=8,facing=south,spacing=2}` with explicit incoming-bit assignments `bit1->fan0`, `bits2..11->fan1`, `bits12..15->fan3`, `bits16..19->fan4`, `bits20..23->fan5`, `bits24..27->fan6`, `bits28..31->fan7`; absent `bit0` takes default fan0, so fan0 is `PC[1:0]`; fan2 has no assigned bit. **[Measured attrs; absent-attribute defaults inferred]** |

## 4. Nets

The net IDs below are local stable names for this audit. “Driver” and “sink” are electrical directions after splitter orientation. A singleton is an intentionally observable graph leaf, not automatically a defect.

| Net | Width | Driver endpoint(s) | Sink endpoint(s) | Status / meaning |
|---|---:|---|---|---|
| `PF-N00` | 32 | `Multiplexer@1040,920.out` | `Multiplexer@1150,840.in1` | OK; selected relative/absolute target. **[Measured]** |
| `PF-N01` | 32 | `Multiplexer@1150,840.out` | `Multiplexer@1250,850.in0` | OK; selected sequential/redirect next PC. **[Measured]** |
| `PF-N02` | 32 | `Register@430,790[PC].Q` | `Adder@750,830.a`, `Adder@750,910.a`, `Multiplexer@1250,850.in1`, `Splitter@500,970.combined` | OK; current PC feedback/fanout. **[Measured]** |
| `PF-N03` | 1 | `Pin@1230,880[hold].p` | `Multiplexer@1250,850.sel` | OK; hold select. **[Measured]** |
| `PF-N04` | 32 | `Multiplexer@1250,850.out` | `Register@430,790[PC].D` | OK; next-PC feedback. **[Measured]** |
| `PF-N05` | 1 | `Constant@370,840.p` | `Register@430,790[PC].en` | OK; always-enable, assuming default constant is 1. **[Measured connection; inferred value]** |
| `PF-N06` | 1 | `Pin@420,860[CLK].p` | `Register@430,790[PC].clk` | OK; clock. **[Measured]** |
| `PF-N07` | 1 | `Pin@460,970[RST].p` | `Register@430,790[PC].clr` | OK; reset/clear. **[Measured]** |
| `PF-N08` | 32 | `Constant@610,840.p` | `Adder@750,830.b` | OK; constant `4`. **[Measured]** |
| `PF-N09` | 10 | `Splitter@500,970.bit1` | `Pin@640,1030[pc_out].p` | OK; fan1 is `PC[11:2]`. **[Measured]** |
| `PF-N10` | 32 | `Pin@640,920[IMM].p` | `Adder@750,910.b` | OK; relative displacement. **[Measured]** |
| `PF-N11` | 32 | `Adder@750,830.out` | `Pin@860,860[pc_plus4].p`, `Multiplexer@1150,840.in0` | OK; `PC+4`. **[Measured]** |
| `PF-N12` | 32 | `Adder@750,910.out` | `Multiplexer@1040,920.in0` | OK; `PC+IMM`. **[Measured]** |
| `PF-N13` | 32 | `Pin@970,930[abs_target].p` | `Multiplexer@1040,920.in1` | OK; absolute target. **[Measured]** |
| `PF-N14` | 1 | `Pin@1020,940[abs_select].p` | `Multiplexer@1040,920.sel` | OK; relative/absolute select. **[Measured]** |
| `PF-N15` | 1 | `Pin@1130,860[BRANCH].p` | `Multiplexer@1150,840.sel` | OK; sequential/redirect select. **[Measured]** |
| `PF-N16` | 2 | `Splitter@500,970.bit0` | none | Singleton; unused `PC[1:0]`. **[Measured mapping]** |
| `PF-N17` | unresolved | `Splitter@500,970.bit2` | none | Singleton; fan2 has no incoming bit assigned. Exact zero-width/default rendering semantics are unresolved; it has no functional consumer. **[Measured endpoint; unresolved width]** |
| `PF-N18` | 4 | `Splitter@500,970.bit3` | none | Singleton; unused `PC[15:12]`. **[Measured mapping]** |
| `PF-N19` | 4 | `Splitter@500,970.bit4` | none | Singleton; unused `PC[19:16]`. **[Measured mapping]** |
| `PF-N20` | 4 | `Splitter@500,970.bit5` | none | Singleton; unused `PC[23:20]`. **[Measured mapping]** |
| `PF-N21` | 4 | `Splitter@500,970.bit6` | none | Singleton; unused `PC[27:24]`. **[Measured mapping]** |
| `PF-N22` | 4 | `Splitter@500,970.bit7` | none | Singleton; unused `PC[31:28]`. **[Measured mapping]** |
| `PF-N23` | 1 | `Constant@730,810.p` | `Adder@750,830.cin` | OK; carry-in `0`. **[Measured]** |
| `PF-N24` | 1 | `Constant@730,890.p` | `Adder@750,910.cin` | OK; carry-in `0`. **[Measured]** |
| `PF-N25` | 1 | `Adder@750,830.cout` | none | Singleton; sequential-adder carry-out intentionally unused. **[Measured endpoint; intent inferred]** |
| `PF-N26` | 1 | `Adder@750,910.cout` | none | Singleton; target-adder carry-out intentionally unused. **[Measured endpoint; intent inferred]** |

## 5. Signal flow

Endpoint-first paths, with the wire action made explicit:

```text
Register@430,790[PC].Q.wire -> Adder@750,830.a
Constant@610,840.p.wire -> Adder@750,830.b
Constant@730,810.p.wire -> Adder@750,830.cin
Adder@750,830.out.wire -> Pin@860,860[pc_plus4].p
Adder@750,830.out.wire -> Multiplexer@1150,840.in0

Register@430,790[PC].Q.wire -> Adder@750,910.a
Pin@640,920[IMM].p.wire -> Adder@750,910.b
Constant@730,890.p.wire -> Adder@750,910.cin
Adder@750,910.out.wire -> Multiplexer@1040,920.in0
Pin@970,930[abs_target].p.wire -> Multiplexer@1040,920.in1
Pin@1020,940[abs_select].p.wire -> Multiplexer@1040,920.sel
Multiplexer@1040,920.out.wire -> Multiplexer@1150,840.in1

Pin@1130,860[BRANCH].p.wire -> Multiplexer@1150,840.sel
Multiplexer@1150,840.out.wire -> Multiplexer@1250,850.in0
Register@430,790[PC].Q.wire -> Multiplexer@1250,850.in1
Pin@1230,880[hold].p.wire -> Multiplexer@1250,850.sel
Multiplexer@1250,850.out.wire -> Register@430,790[PC].D

Pin@420,860[CLK].p.wire -> Register@430,790[PC].clk
Pin@460,970[RST].p.wire -> Register@430,790[PC].clr
Constant@370,840.p.wire -> Register@430,790[PC].en
Register@430,790[PC].Q.wire -> Splitter@500,970.combined
Splitter@500,970.bit1.wire -> Pin@640,1030[pc_out].p
```

All paths above are **[Measured]**. Arithmetic and mux meanings follow standard Logisim semantics **[Inferred]**.

## 6. State and cycles

`Register@430,790[PC]` is the only state element. Its data equation is:

```text
relative_target = PC_Q + IMM                    (mod 2^32)
redirect_target = abs_select ? abs_target : relative_target
running_target  = BRANCH ? redirect_target : (PC_Q + 4)
PC_D            = hold ? PC_Q : running_target
```

Equivalently:

| `hold` | `BRANCH` | `abs_select` | Value captured by PC on the active clock edge |
|---:|---:|---:|---|
| 1 | X | X | `PC_Q` (freeze) |
| 0 | 0 | X | `PC_Q + 4` |
| 0 | 1 | 0 | `PC_Q + IMM` |
| 0 | 1 | 1 | `abs_target` |

The priority is therefore **hold > redirect vs sequential > absolute vs relative**. `abs_select=1` does nothing by itself when `BRANCH=0`. **[Measured topology; inferred mux truth semantics]**

The component graph has one nontrivial strongly connected component:

```text
{ PC register, both adders, all three multiplexers }
```

That SCC contains sequential feedback through the PC register; it is not a combinational loop. The register is the state boundary. The condensation graph is acyclic after this SCC is collapsed. **[Measured graph; inferred sequential interpretation]**

The register has no explicit trigger attribute, so the active clock edge and clear timing use Logisim Register defaults. They are not encoded locally in this XML and were not dynamically probed in this audit. **[Unresolved locally]**

## 7. Hierarchy

`pc_fetch` instantiates no child subcircuits. **[Measured]**

Parent `main` contains one `pc_fetch@5780,8630` instance. Its exact direct net mappings are:

| `pc_fetch` port | Parent `main` connection |
|---|---|
| `pc_plus4` | `pc_fetch.pc_plus4.wire -> Probe@5760,8770.p`; same wire -> `Multiplexer@7510,9000.in1`. **[Measured]** |
| `pc_out` | `pc_fetch.pc_out.wire -> Probe@5940,8530.p`; same wire -> instruction `ROM@5890,8620.addr` (`addrWidth=10`, `dataWidth=32`). **[Measured]** |
| `CLK` | `Clock@4990,8630.out.wire -> pc_fetch.CLK`; shared CPU clock net. **[Measured]** |
| `BRANCH` | `OR Gate@4950,8560.out.wire -> pc_fetch.BRANCH`. That OR combines relative branch/BL, BX, deferred-PC apply, and register-file writes to `r15`. **[Measured endpoint; producer semantics reconciled with main-control audit]** |
| `hold` | `block_transfer_control@5790,8110.hold_pc.wire -> pc_fetch.hold`; the same net also reaches `pc_defer` and another main OR input. **[Measured]** |
| `IMM` | `Adder@8640,10400.out.wire -> pc_fetch.IMM`. **[Measured endpoint; detailed immediate formation belongs to `main`]** |
| `abs_target` | `Multiplexer@5040,9360.out.wire -> pc_fetch.abs_target`; this selects live versus saved deferred target. **[Measured endpoint; semantics reconciled with main-control audit]** |
| `abs_select` | `OR Gate@5010,8730.out.wire -> pc_fetch.abs_select`; main asserts it for BX, deferred-PC apply, and register-file PC writes. **[Measured endpoint; semantics reconciled with main-control audit]** |
| `RST` | `Pin@5050,8750.p.wire -> pc_fetch.RST`; shared CPU reset. **[Measured]** |

During block transfer, `hold` wins inside `pc_fetch`; parent `main` separately saves a requested absolute redirect and later asserts both `BRANCH` and `abs_select` when applying it. **[Measured/reconciled across audits]**

## 8. Health

- Geometry coverage is **47/47 endpoints**, with no unmodelled types. **[Measured]**
- There are **no undriven multi-pin nets** and **no multi-driver nets** in the extracted graph. **[Measured]**
- Nine singleton nets are reported: six unused splitter fans (`fan0`, `fan2`, `fan3..7`) plus two unused adder carry-outs; these are leaves, not evidence of an electrical fault. **[Measured; classification inferred]**
- The splitter's fan2 has no assigned incoming bit. This is unusual but does not affect `pc_out`, which uses fan1. Exact empty-fan width semantics remain unresolved. **[Measured/unresolved]**
- Both additions discard carry-out and naturally wrap at 32 bits. **[Measured topology; inferred arithmetic result]**
- `pc_out` discards `PC[31:12]` and `PC[1:0]`; instruction fetch therefore aliases every 4 KiB and enforces word-addressed ROM access. The parent ROM width matches at 10 bits. **[Measured]**
- No component has all of its functional outputs dead according to `Graph.dead()`. **[Measured]**
- The graph's SCC includes the state register and must not be misreported as a combinational-cycle defect. **[Measured graph-model limitation]**

## 9. Debug delta

The `pc_fetch` subcircuit itself is byte-for-byte identical to the one in `debug_armv4t.circ`; there are no component, attribute, node, net, or wire deltas inside this block. The parent `main` delta is documented in `../pc_fetch_delta.md`. **[Measured]**

## 10. Human map

On each normal clock, the PC advances by four bytes. When `BRANCH` is asserted, the same state register instead receives either `PC+IMM` or `abs_target`. When `hold` is asserted, the outermost mux feeds the old PC back into its D input, so no redirect can take effect that cycle. The full PC also feeds the `PC+4` output, while a splitter exports only bits 11 through 2 to address the 1024-word instruction ROM. **[Measured topology; inferred cycle narration]**

## 11. Cross-circuit links

- The `main` control audit owns the producers of `BRANCH`, `abs_select`, `abs_target`, and the deferred-PC protocol. Its reconciled result agrees with the internal priority documented here. **[Measured/reconciled]**
- The `block_transfer_control` audit owns `hold_pc`; `pc_fetch` treats it as an unconditional highest-priority freeze. **[Measured]**
- The `main` datapath audit owns the consumer of `pc_plus4` and instruction ROM. **[Measured]**
- `OR Gate@6070,7790.out` in parent `main` was reported dangling by the main-control auditor. It shares an input source with the `hold` net but is not part of `pc_fetch`; no contradiction is attributed to this subcircuit. **[Measured by sibling audit]**

## 12. Confidence

- **Measured:** XML identity and attributes, all component/port locations, all wire connectivity, net drivers/sinks, splitter assignments, parent direct endpoints, graph counts, SCC membership, and absence of multi-driver/undriven multi-pin nets.
- **Inferred from standard Logisim semantics:** mux select polarity (`0->in0`, `1->in1`), modulo-32-bit adder behavior, default constant value `1`, normal register capture behavior, and human-readable signal roles.
- **Unresolved:** exact timing/edge defaults for the attribute-free Register configuration and the formal width/rendering semantics of the splitter's empty fan2. Neither uncertainty changes the extracted connectivity or next-PC mux equation.
