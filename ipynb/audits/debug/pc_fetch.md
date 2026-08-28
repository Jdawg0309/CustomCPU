# `pc_fetch` audit — `debug_armv4t.circ`

## 1. Identity and purpose

- **Source:** `debug_armv4t.circ`, whole-file SHA-256 `eaaeadc774fa99daf6a304403b9c8556210b836b52b79de99bdea7d08ff225c9`. **[Measured]**
- **Circuit:** `pc_fetch`; XML-subtree SHA-256 `a727a1d1451dcbb0ba72266b205da962792e20e6aadc03e8ce5ffb77b6b3fc7f`. **[Measured]**
- **Role:** holds the 32-bit PC, forms `PC+4` and `PC+IMM`, chooses relative/absolute redirect targets, freezes on `hold`, and exports the 10-bit ROM word address `PC[11:2]`. **[Measured structure; inferred role]**
- Circuit attributes: `appearance=logisim_evolution`, `circuit=pc_fetch`, `circuitnamedboxfixedsize=true`, `simulationFrequency=1000.0`. **[Measured]**

## 2. Interface

| Port | Dir. | Width | Facing | Electrical endpoint | Role |
|---|---:|---:|---|---|---|
| `pc_plus4` | out | 32 | west | `Pin@860,860[pc_plus4].p` | `PC_Q+4`. **[Measured]** |
| `pc_out` | out | 10 | west | `Pin@640,1030[pc_out].p` | `PC_Q[11:2]`. **[Measured]** |
| `CLK` | in | 1 | east | `Pin@420,860[CLK].p` | PC clock. **[Measured]** |
| `BRANCH` | in | 1 | north | `Pin@1130,860[BRANCH].p` | Sequential/redirect select. **[Measured]** |
| `hold` | in | 1 | east | `Pin@1230,880[hold].p` | Highest-priority freeze. **[Measured]** |
| `IMM` | in | 32 | east | `Pin@640,920[IMM].p` | Relative-target addend. **[Measured]** |
| `abs_target` | in | 32 | east | `Pin@970,930[abs_target].p` | Absolute target. **[Measured]** |
| `abs_select` | in | 1 | north | `Pin@1020,940[abs_select].p` | Absolute/relative select inside redirect path. **[Measured]** |
| `RST` | in | 1 | north | `Pin@460,970[RST].p` | Register clear. **[Measured structure; standard active-high behavior inferred]** |

Instance-port order is `pc_plus4`, `pc_out`, then `CLK`, `BRANCH`, `hold`, `IMM`, `abs_target`, `abs_select`, `RST`. **[Measured]**

## 3. Inventory

The block has **20 components**, **33 wire segments**, **27 nets**, **49 port nodes**, and **22 directed inter-component edges**. Geometry covers **47/47 endpoints**. **[Measured]**

| Type | Count | Instances and every explicit attribute |
|---|---:|---|
| Pin | 9 | `CLK@420,860 {appearance=NewPins,label=CLK}`; `BRANCH@1130,860 {appearance=NewPins,facing=north,label=BRANCH}`; `hold@1230,880 {appearance=NewPins,label=hold}`; `IMM@640,920 {appearance=NewPins,label=IMM,radix=16,width=32}`; `abs_target@970,930 {appearance=NewPins,label=abs_target,radix=16,width=32}`; `abs_select@1020,940 {appearance=NewPins,facing=north,label=abs_select}`; `RST@460,970 {appearance=NewPins,facing=north,label=RST}`; `pc_plus4@860,860 {appearance=NewPins,facing=west,label=pc_plus4,output=true,radix=16,width=32}`; `pc_out@640,1030 {appearance=NewPins,facing=west,label=pc_out,output=true,radix=16,width=10}`. **[Measured]** |
| Register | 1 | `Register@430,790[PC] {appearance=logisim_evolution,label=PC,width=32}`. **[Measured]** |
| Adder | 2 | `Adder@750,830 {width=32}`; `Adder@750,910 {width=32}`. **[Measured]** |
| Multiplexer | 3 | `Multiplexer@1040,920 {width=32}`; `Multiplexer@1150,840 {width=32}`; `Multiplexer@1250,850 {width=32}`. **[Measured]** |
| Constant | 4 | `Constant@370,840 {}`; `Constant@610,840 {value=0x4,width=32}`; `Constant@730,810 {facing=south,value=0x0}`; `Constant@730,890 {facing=south,value=0x0}`. Attribute-free constant value `1` is a Logisim-default inference. **[Measured attrs; inferred default]** |
| Splitter | 1 | `Splitter@500,970 {incoming=32,fanout=8,facing=south,spacing=2}`; explicit assignments: `bit1->fan0`, `bits2..11->fan1`, `bits12..15->fan3`, `bits16..19->fan4`, `bits20..23->fan5`, `bits24..27->fan6`, `bits28..31->fan7`. Absent `bit0` defaults to fan0; fan2 receives no bit. **[Measured attrs; inferred absent defaults]** |

## 4. Nets

| Net | Width | Driver endpoint(s) | Sink endpoint(s) | Status / meaning |
|---|---:|---|---|---|
| `PF-N00` | 32 | `Multiplexer@1040,920.out` | `Multiplexer@1150,840.in1` | OK; redirect target. **[Measured]** |
| `PF-N01` | 32 | `Multiplexer@1150,840.out` | `Multiplexer@1250,850.in0` | OK; non-held next PC. **[Measured]** |
| `PF-N02` | 32 | `Register@430,790[PC].Q` | `Adder@750,830.a`, `Adder@750,910.a`, `Multiplexer@1250,850.in1`, `Splitter@500,970.combined` | OK; PC fanout. **[Measured]** |
| `PF-N03` | 1 | `Pin@1230,880[hold].p` | `Multiplexer@1250,850.sel` | OK. **[Measured]** |
| `PF-N04` | 32 | `Multiplexer@1250,850.out` | `Register@430,790[PC].D` | OK; state feedback. **[Measured]** |
| `PF-N05` | 1 | `Constant@370,840.p` | `Register@430,790[PC].en` | OK; inferred constant `1`. **[Measured/inferred]** |
| `PF-N06` | 1 | `Pin@420,860[CLK].p` | `Register@430,790[PC].clk` | OK. **[Measured]** |
| `PF-N07` | 1 | `Pin@460,970[RST].p` | `Register@430,790[PC].clr` | OK. **[Measured]** |
| `PF-N08` | 32 | `Constant@610,840.p` | `Adder@750,830.b` | OK; `4`. **[Measured]** |
| `PF-N09` | 10 | `Splitter@500,970.bit1` | `Pin@640,1030[pc_out].p` | OK; `PC[11:2]`. **[Measured]** |
| `PF-N10` | 32 | `Pin@640,920[IMM].p` | `Adder@750,910.b` | OK. **[Measured]** |
| `PF-N11` | 32 | `Adder@750,830.out` | `Pin@860,860[pc_plus4].p`, `Multiplexer@1150,840.in0` | OK; `PC+4`. **[Measured]** |
| `PF-N12` | 32 | `Adder@750,910.out` | `Multiplexer@1040,920.in0` | OK; `PC+IMM`. **[Measured]** |
| `PF-N13` | 32 | `Pin@970,930[abs_target].p` | `Multiplexer@1040,920.in1` | OK. **[Measured]** |
| `PF-N14` | 1 | `Pin@1020,940[abs_select].p` | `Multiplexer@1040,920.sel` | OK. **[Measured]** |
| `PF-N15` | 1 | `Pin@1130,860[BRANCH].p` | `Multiplexer@1150,840.sel` | OK. **[Measured]** |
| `PF-N16` | 2 | `Splitter@500,970.bit0` | none | Singleton; unused `PC[1:0]`. **[Measured]** |
| `PF-N17` | unresolved | `Splitter@500,970.bit2` | none | Singleton; no incoming bit assigned to fan2. **[Measured/unresolved]** |
| `PF-N18` | 4 | `Splitter@500,970.bit3` | none | Singleton; unused `PC[15:12]`. **[Measured]** |
| `PF-N19` | 4 | `Splitter@500,970.bit4` | none | Singleton; unused `PC[19:16]`. **[Measured]** |
| `PF-N20` | 4 | `Splitter@500,970.bit5` | none | Singleton; unused `PC[23:20]`. **[Measured]** |
| `PF-N21` | 4 | `Splitter@500,970.bit6` | none | Singleton; unused `PC[27:24]`. **[Measured]** |
| `PF-N22` | 4 | `Splitter@500,970.bit7` | none | Singleton; unused `PC[31:28]`. **[Measured]** |
| `PF-N23` | 1 | `Constant@730,810.p` | `Adder@750,830.cin` | OK; zero carry-in. **[Measured]** |
| `PF-N24` | 1 | `Constant@730,890.p` | `Adder@750,910.cin` | OK; zero carry-in. **[Measured]** |
| `PF-N25` | 1 | `Adder@750,830.cout` | none | Singleton; carry-out unused. **[Measured]** |
| `PF-N26` | 1 | `Adder@750,910.cout` | none | Singleton; carry-out unused. **[Measured]** |

## 5. Signal flow

```text
Register@430,790[PC].Q.wire -> Adder@750,830.a
Constant@610,840.p.wire -> Adder@750,830.b
Adder@750,830.out.wire -> Pin@860,860[pc_plus4].p
Adder@750,830.out.wire -> Multiplexer@1150,840.in0

Register@430,790[PC].Q.wire -> Adder@750,910.a
Pin@640,920[IMM].p.wire -> Adder@750,910.b
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

All connections are **[Measured]**. Mux and arithmetic interpretations are **[Inferred from standard Logisim semantics]**.

## 6. State and cycles

The sole state element is `Register@430,790[PC]`:

```text
PC_D = hold ? PC_Q
            : BRANCH ? (abs_select ? abs_target : PC_Q + IMM)
                     : PC_Q + 4
```

All additions wrap modulo `2^32`. Priority is `hold` first, then `BRANCH`, then `abs_select`; `abs_select` is ignored when `BRANCH=0`. **[Measured topology; inferred component truth semantics]**

The component graph's one nontrivial SCC is `{PC Register, both Adders, all three Multiplexers}`. It is sequential feedback cut by the PC register, not a combinational loop. The condensation graph is acyclic. **[Measured/inferred]**

Clock-trigger and clear timing are inherited from Logisim defaults because the Register has no local trigger attributes; this audit did not dynamically probe those defaults. **[Unresolved locally]**

## 7. Hierarchy

`pc_fetch` has no child instances. Parent `main` has one `pc_fetch@5780,8630` instance. **[Measured]**

| Port | Parent `debug` endpoint map |
|---|---|
| `pc_plus4` | `pc_fetch.pc_plus4.wire -> Probe@5760,8770.p`; same wire -> `Multiplexer@7510,9000.in1`. **[Measured]** |
| `pc_out` | `pc_fetch.pc_out.wire -> Probe@5940,8530.p`; same wire -> instruction `ROM@5890,8620.addr`; same wire -> `Bit Extender@8900,11780.in`. **[Measured]** |
| `CLK` | `Clock@4990,8630.out.wire -> pc_fetch.CLK`; shared clock. **[Measured]** |
| `BRANCH` | `OR Gate@4950,8560.out.wire -> pc_fetch.BRANCH`. **[Measured]** |
| `hold` | `block_transfer_control@5790,8110.hold_pc.wire -> pc_fetch.hold`. **[Measured]** |
| `IMM` | `Adder@8640,10400.out.wire -> pc_fetch.IMM`. **[Measured]** |
| `abs_target` | `Multiplexer@5040,9360.out.wire -> pc_fetch.abs_target`. **[Measured]** |
| `abs_select` | `OR Gate@5010,8730.out.wire -> pc_fetch.abs_select`. **[Measured]** |
| `RST` | `Pin@5050,8750.p.wire -> pc_fetch.RST`; shared reset. **[Measured]** |

The debug-only `pc_out` consumer reconstructs a low-12-bit byte PC:

```text
pc_fetch.pc_out[9:0].wire -> Bit Extender@8900,11780.in
Bit Extender@8900,11780.out.wire -> Shifter@9060,11820.in
Shifter@9060,11820.out.wire -> Adder@9220,11950.a
```

The parent shifts left by two, adds eight, and conditionally substitutes this value when operand register A or B is `r15`. This implements architectural `PC+8` reads inside the current 4-KiB program window. Since `pc_out` has already discarded `PC[31:12]`, it is not a full 32-bit PC reconstruction. **[Measured endpoints; parent behavior reconciled with main-datapath audit]**

## 8. Health

- Endpoint coverage is **47/47**; no types are unmodelled. **[Measured]**
- No undriven multi-pin or multi-driver nets exist. **[Measured]**
- The nine singleton nets are unused splitter fans and adder carry-outs, not proven circuit faults. **[Measured; classification inferred]**
- Empty splitter fan2 has no effect on fan1/`pc_out`; its exact width semantics are unresolved. **[Measured/unresolved]**
- `pc_out[9:0]` matches the parent instruction ROM's `addrWidth=10`. It aliases instruction addresses every 4 KiB. **[Measured]**
- The debug PC+8 reconstruction inherits that 4-KiB truncation. It is correct for the current ROM window but is a width risk if code is remapped above it. **[Measured/inferred]**
- The apparent graph cycle is sequential state feedback, not a combinational defect. **[Measured/inferred]**

## 9. Debug delta

There is **no internal delta**: this `pc_fetch` XML subtree is byte-for-byte identical to `armv4t.circ`. Parent `main` adds one consumer to `pc_out`, described above and in `../pc_fetch_delta.md`. **[Measured]**

## 10. Human map

Normal cycles increment PC by four. A redirect cycle chooses `PC+IMM` or `abs_target`. A held cycle feeds PC back to itself and suppresses either redirect. Outputs expose full `PC+4` and the instruction ROM's truncated word address. Debug additionally uses that word address to synthesize the ARM-visible `PC+8` operand. **[Measured topology; inferred narration]**

## 11. Cross-circuit links

- Parent control asserts `BRANCH` for relative branch/BL, BX, deferred-PC apply, and writes to register 15; it asserts `abs_select` for all but relative branch/BL. **[Reconciled with main-control audit]**
- Parent `pc_defer` saves a redirect while `block_transfer_control.hold_pc` freezes this block, then reapplies the saved target with `BRANCH=abs_select=1`. **[Reconciled]**
- Parent datapath owns the debug-only r15-read muxes and instruction/data memory map. **[Reconciled]**
- The block-transfer controller owns the timing of `hold_pc`; this block gives it unconditional top priority. **[Measured]**

## 12. Confidence

- **Measured:** all XML/component attributes, every endpoint and net, graph counts, splitter bit assignments, SCC membership, parent direct port mappings, and byte identity with the arm block.
- **Inferred:** standard mux/adder/Register functional semantics, the attribute-free constant's default `1`, and narrative roles.
- **Unresolved:** exact Register trigger/clear timing defaults and the formal width of empty splitter fan2. The debug parent PC+8 path is statically measured, but its full dynamic behavior belongs to the parent-main audit/tests.
