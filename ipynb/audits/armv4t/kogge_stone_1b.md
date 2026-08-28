# `kogge_stone_1b` audit — `armv4t.circ`

## 1. Identity and purpose

- **Source:** `armv4t.circ`, whole-file SHA-256 `ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84`. **[Measured]**
- **Circuit:** `kogge_stone_1b`; XML-subtree SHA-256 `093cf41a5b1581956b578d1286e8e21a8d0f7820bee718d386008300c80ba81c`. **[Measured]**
- **Role:** one bit of the hand-built prefix adder. It forms bit generate `g=A AND B`, XOR-propagate `p=A XOR B`, and the final sum bit `sum=p XOR C_in`. It does not itself calculate a carry-out; the parent prefix network calculates carries from `g` and `p` and returns the appropriate carry as `C_in`. **[Measured topology; inferred prefix-adder role]**
- Circuit attributes are `appearance=logisim_evolution`, `circuit=kogge_stone_1b`, `circuitnamedboxfixedsize=true`, and `simulationFrequency=1000.0`; bounding box is `(140,140)..(510,330)`. **[Measured]**

## 2. Interface

All ports are one bit wide. “Dir.” is the subcircuit interface direction; the graph correctly models an input Pin as an electrical driver and an output Pin as an electrical sink. **[Measured]**

| Port | Dir. | Width | Pin facing | Electrical endpoint | Semantic role |
|---|---:|---:|---|---|---|
| `A` | in | 1 | east | `Pin@140,140[A].p` | Operand-A bit; fans out to generate and propagate gates. **[Measured]** |
| `B` | in | 1 | east | `Pin@140,180[B].p` | Operand-B bit; fans out to generate and propagate gates. **[Measured]** |
| `C_in` | in | 1 | east | `Pin@140,330[C_in].p` | Carry entering this bit after parent prefix resolution; affects `sum` only. **[Measured topology; role inferred]** |
| `g` | out | 1 | west | `Pin@510,160[g].p` | Bit generate, `A AND B`. **[Measured/inferred gate semantics]** |
| `p` | out | 1 | west | `Pin@510,240[p].p` | XOR-propagate, `A XOR B`. **[Measured/inferred gate semantics]** |
| `sum` | out | 1 | west | `Pin@510,310[sum].p` | Sum bit, `A XOR B XOR C_in`. **[Measured/inferred gate semantics]** |

## 3. Inventory

The circuit contains **9 components** and **14 raw wire segments**. The extracted forms contain **15 component-port nodes**, **6 electrical-net nodes**, **9 directed signal edges**, and **9 component-to-component edges**. Endpoint coverage is **20/20 (100%)**. **[Measured]**

| Type | Count | Instances and explicit attributes |
|---|---:|---|
| Pin | 6 | `Pin@140,140[A] {appearance=NewPins,label=A}`; `Pin@140,180[B] {appearance=NewPins,label=B}`; `Pin@140,330[C_in] {appearance=NewPins,label=C_in}`; `Pin@510,160[g] {appearance=NewPins,facing=west,label=g,output=true}`; `Pin@510,240[p] {appearance=NewPins,facing=west,label=p,output=true}`; `Pin@510,310[sum] {appearance=NewPins,facing=west,label=sum,output=true}`. **[Measured]** |
| AND Gate | 1 | `AND Gate@260,160[a_and_b] {label=a_and_b}`; absent width and input-count attributes use the one-bit, two-input defaults represented by the generated graph. **[Measured attrs/model ports]** |
| XOR Gate | 2 | `XOR Gate@270,240[a_xor_b] {label=a_xor_b}`; `XOR Gate@450,310[p_xor_cin] {label=p_xor_cin}`; both use one-bit, two-input defaults. **[Measured attrs/model ports]** |

Raw XML wire segments, retained here so every geometric branch is recoverable:

| Wire | From -> to | Electrical net |
|---|---|---|
| `w0` | `(140,140) -> (180,140)` | `KS1-N0` |
| `w1` | `(140,180) -> (170,180)` | `KS1-N1` |
| `w2` | `(140,330) -> (390,330)` | `KS1-N2` |
| `w3` | `(170,180) -> (170,260)` | `KS1-N1` |
| `w4` | `(170,180) -> (210,180)` | `KS1-N1` |
| `w5` | `(170,260) -> (210,260)` | `KS1-N1` |
| `w6` | `(180,140) -> (180,220)` | `KS1-N0` |
| `w7` | `(180,140) -> (210,140)` | `KS1-N0` |
| `w8` | `(180,220) -> (210,220)` | `KS1-N0` |
| `w9` | `(260,160) -> (510,160)` | `KS1-N3` |
| `w10` | `(270,240) -> (390,240)` | `KS1-N4` |
| `w11` | `(390,240) -> (390,290)` | `KS1-N4` |
| `w12` | `(390,240) -> (510,240)` | `KS1-N4` |
| `w13` | `(450,310) -> (510,310)` | `KS1-N5` |

All segments are axis-aligned. **[Measured]**

## 4. Nets

These six rows are the complete lossless electrical-net ledger. Each net is one bit wide. **[Measured]**

| Net | Driver endpoint | Sink endpoint(s) | Status / meaning |
|---|---|---|---|
| `KS1-N0` (`net:A/a_and_b`) | `Pin@140,140[A].p` | `AND Gate@260,160[a_and_b].in0`; `XOR Gate@270,240[a_xor_b].in0` | OK; A fanout. |
| `KS1-N1` (`net:B/a_and_b`) | `Pin@140,180[B].p` | `AND Gate@260,160[a_and_b].in1`; `XOR Gate@270,240[a_xor_b].in1` | OK; B fanout. |
| `KS1-N2` (`net:C_in/p_xor_cin`) | `Pin@140,330[C_in].p` | `XOR Gate@450,310[p_xor_cin].in1` | OK; carry-to-sum path. |
| `KS1-N3` (`net:a_and_b/g`) | `AND Gate@260,160[a_and_b].out` | `Pin@510,160[g].p` | OK; generate output. |
| `KS1-N4` (`net:a_xor_b/p`) | `XOR Gate@270,240[a_xor_b].out` | `Pin@510,240[p].p`; `XOR Gate@450,310[p_xor_cin].in0` | OK; propagate output and sum intermediate share one net. |
| `KS1-N5` (`net:p_xor_cin/sum`) | `XOR Gate@450,310[p_xor_cin].out` | `Pin@510,310[sum].p` | OK; final sum output. |

## 5. Signal flow

The following is the complete set of nine directed connections in endpoint-first notation. “Wire” means tap/extend the named source net; it does not imply cutting any branch. **[Measured]**

```text
Pin@140,140[A].p.wire -> AND Gate@260,160[a_and_b].in0
Pin@140,140[A].p.wire -> XOR Gate@270,240[a_xor_b].in0

Pin@140,180[B].p.wire -> AND Gate@260,160[a_and_b].in1
Pin@140,180[B].p.wire -> XOR Gate@270,240[a_xor_b].in1

Pin@140,330[C_in].p.wire -> XOR Gate@450,310[p_xor_cin].in1

AND Gate@260,160[a_and_b].out.wire -> Pin@510,160[g].p

XOR Gate@270,240[a_xor_b].out.wire -> Pin@510,240[p].p
XOR Gate@270,240[a_xor_b].out.wire -> XOR Gate@450,310[p_xor_cin].in0

XOR Gate@450,310[p_xor_cin].out.wire -> Pin@510,310[sum].p
```

Derived fanout tree (a readable view, not the canonical electrical representation):

```text
A ─┬─> a_and_b ─> g
   └─> a_xor_b ─┬─> p
B ─┬─> a_and_b  └─> p_xor_cin ─> sum
   └─> a_xor_b             ^
C_in ──────────────────────┘
```

## 6. State and cycles

There are no registers, latches, RAMs, ROMs, counters, clocks, feedback edges, or stateful child circuits. All outputs are combinational:

```text
g   = A & B
p   = A ^ B
sum = p ^ C_in = A ^ B ^ C_in
```

The `sum` path from A or B crosses two XOR gates; `p` crosses one XOR; `g` crosses one AND. `C_in` crosses one XOR. **[Measured topology; inferred gate-delay depth]**

The signal graph has **15 strongly connected components**, all singletons; the condensation graph is therefore the same acyclic 15-node/9-edge structure. There is no combinational loop. **[Measured]**

## 7. Hierarchy

`kogge_stone_1b` instantiates no child subcircuits. **[Measured]**

It is directly instantiated **38 times per design definition**: twice in `kogge_stone_2b`, four times in `ks_4b`, and 32 times in `ks_32b`. The two audited source files have the same counts and instance locations. **[Measured]**

| Parent | Instances | Parent-side mapping |
|---|---:|---|
| `kogge_stone_2b` | `bit0@690,180`, `bit1@690,390` | Each `A/B` receives its scalar operand bit; each `g/p` feeds a `pg_cell`; `sum` feeds `SUM0/SUM1`. `bit0.C_in` receives parent `CIN`; `bit1.C_in` receives `pg1.G_out`. **[Measured]** |
| `ks_4b` | `@1660,350[bit0]`, `@1270,350[bit1]`, `@880,340[bit2]`, `@490,340` | Each `A/B` receives a scalar parent bit; `g/p` enter the staged `pg_cell` prefix network; `sum` feeds its scalar parent output. Carry inputs come from parent `Cin` for bit 0 and prefix `G_out` nets for higher bits. **[Measured topology; bit roles inferred]** |
| `ks_32b` | 32 south-facing instances spanning bit 31 at `@640,2660` through bit 0 at `@6680,2660` | Each instance receives one split A bit, one split B bit, and either external `Cin` or a resolved prefix `G_out`; `g/p` feed the 130-cell prefix tree; `sum` feeds one scalar `sum0/SUM1..SUM31` output. **[Measured topology; bit ordering inferred from labels/output pins]** |

The only instantiated path from the CPU top is:

```text
main -> ALU -> ks_32b -> kogge_stone_1b
```

Within `ALU`, however, this `ks_32b` belongs to the currently dead multiplier-finalization chain: `mul_32.sum -> ks_32b.A`, `mul_32.carry -> ks_32b.B`, while `ks_32b.Cin`, `ks_32b.Cout`, and the combined output of its result splitter are dangling. The hand-built Kogge-Stone network therefore does **not** feed the current `ALU.result`; normal arithmetic is handled by `ALU_arithmetic_engine`. **[Measured parent connectivity; role inferred/reconciled with main datapath audit]**

Other circuit definitions also contain `ks_32b`—including `PE_cell`, `mul_8`, `ALU_arithmetic_engine_1`, and `a_invert`—but none provides a second instantiated route from `main` to this leaf in the hierarchy graph. **[Measured hierarchy]**

## 8. Health

- Endpoint coverage is **20/20**, with no unmodelled component type. **[Measured]**
- There are no undriven multi-port nets, dangling singleton nets, multi-driver nets, dead-output components, width mismatches, or ambiguous-direction findings inside this subcircuit. **[Measured]**
- Every internal and interface signal is one bit wide. **[Measured]**
- The lack of a local carry-out is intentional prefix-adder structure: `g/p` are exported so a parent tree can compute carries. Treating this block as a standalone full adder would be a model/usage mistake, not an internal wiring defect. **[Inferred]**
- XOR-propagate (`A XOR B`) is a valid prefix convention. It must stay consistent with the `pg_cell` equations in the parent; that cross-block semantic check belongs to the `pg_cell`/`ks_32b` audits. **[Inferred; unresolved here]**
- The active top-level reachability issue described in Hierarchy is outside this internally healthy leaf. **[Measured boundary]**

## 9. Debug delta

The `kogge_stone_1b` XML subtree is byte-for-byte identical in `armv4t.circ` and `debug_armv4t.circ`: same subtree hash, components, attributes, ports, raw wire segments, nets, directed connections, hierarchy instances, SCCs, and health results. The generated diff reports `+0/-0` nodes and `+0/-0` connections. **[Measured]**

The complete comparison is in `../kogge_stone_1b_delta.md`.

## 10. Human map

This is the “prepare one bit” cell at the bottom of the hand-built Kogge-Stone hierarchy. A and B are evaluated in parallel: the AND says whether this bit generates a carry regardless of any incoming carry, and the first XOR says whether an incoming carry propagates through the bit. The large parent prefix tree uses all 32 `g/p` pairs to calculate each bit's carry quickly. Once the parent returns this bit's resolved carry on `C_in`, the second XOR produces the sum bit. **[Measured topology; inferred architectural narration]**

## 11. Cross-circuit links

- `ks_32b` owns the 32 instance mappings, prefix stages, and proof that each `C_in` is the correct resolved lower-bit carry. **[Measured ownership boundary]**
- `pg_cell` owns the group-generate/group-propagate equation that consumes `g/p`. **[Measured hierarchy; behavior to reconcile]**
- `kogge_stone_2b` and `ks_4b` reuse the same leaf but are not on the top-level CPU path. **[Measured hierarchy]**
- `ALU` owns the parent multiplier chain. This audit found that its Kogge result bus and carry-out do not reach `ALU.result`; the finding was sent to the main-datapath auditor. **[Measured/communicated]**
- `main` only sees the enclosing `ALU`; its direct operand and result nets are documented in `main_datapath.md`. **[Measured/reconciled]**

## 12. Confidence

- **Measured:** file/subtree identity, attributes, component and wire inventory, all port positions and widths, all six electrical nets, all nine directed connections, graph sizes, SCCs, health results, direct-parent instance counts/locations, hierarchy path, and the dead parent multiplier-result termination.
- **Inferred from standard gate/prefix semantics:** Boolean equations, gate-depth description, generate/propagate terminology, and the intended parent-prefix division of work.
- **Unresolved in this leaf audit:** whether every `pg_cell` stage in each larger adder implements the matching XOR-propagate prefix equation and whether the dormant multiplier path is intended for future use. Neither uncertainty changes this leaf's complete connectivity map.
