# `pg_cell` audit — `armv4t.circ`

## 1. Identity and purpose

- **Source:** `armv4t.circ`; **circuit:** `pg_cell`.
- **Measured identity:** SHA-256 of the serialized circuit XML is `f3851d6accc1289b5270c9a3b72b1d91f54db10f623030676cd11d3610a6a769`.
- **Inferred purpose:** one black prefix-combine cell for a Kogge–Stone carry tree. It combines a current group `(G,P)` with a less-significant predecessor group `(G_prev,P_Prev)`.
- This report treats the raw net graph as canonical. The Boolean equations and prefix interpretation are derived from that measured topology.

## 2. Interface

All ports are one bit wide.

| Stable endpoint | Direction | Facing | Role | Confidence |
|---|---:|---|---|---|
| `Pin@170,180[G].p` | input | east | Current-group generate | label measured; role inferred |
| `Pin@170,200[P].p` | input | east | Current-group propagate | label measured; role inferred |
| `Pin@170,240[G_prev].p` | input | east | Predecessor-group generate | label measured; role inferred |
| `Pin@170,310[P_Prev].p` | input | east | Predecessor-group propagate | label measured; role inferred |
| `Pin@470,200[G_out].p` | output | west | Combined-group generate | label measured; role inferred |
| `Pin@380,290[P_out].p` | output | west | Combined-group propagate | label measured; role inferred |

Logisim interface order, measured by sorted `(y,x)`, is: outputs `G_out`, `P_out`; inputs `G`, `P`, `G_prev`, `P_Prev`.

## 3. Inventory

| Component type | Count | Stable identities |
|---|---:|---|
| `Pin` | 6 | the six interface endpoints in §2 |
| `AND Gate` | 2 | `AND Gate@320,220[PandG_prev]`; `AND Gate@320,290[P_and_P_prev]` |
| `OR Gate` | 1 | `OR Gate@430,200[G_or_PandG_prev]` |

**Measured totals:** 9 components, 10 raw wire segments, 15 modeled port nodes, 7 electrical nets, and 8 directed driver-to-sink edges. Bounding box: `(170,180)` through `(470,310)`.

## 4. Nets

Every electrical net is listed; there are no omitted raw nets.

| Net | Driver | Sinks / attached ports | Width | Status | Confidence |
|---:|---|---|---:|---|---|
| `n0` `net:G/G_or_PandG_prev` | `Pin@170,180[G].p` | `OR Gate@430,200[G_or_PandG_prev].in0` | 1 | ok | measured |
| `n1` `net:P/P_and_P_prev` | `Pin@170,200[P].p` | `AND Gate@320,220[PandG_prev].in0`; `AND Gate@320,290[P_and_P_prev].in0` | 1 | ok | measured |
| `n2` `net:G_prev/PandG_prev` | `Pin@170,240[G_prev].p` | `AND Gate@320,220[PandG_prev].in1` | 1 | ok | measured |
| `n3` `net:P_Prev/P_and_P_prev` | `Pin@170,310[P_Prev].p` | `AND Gate@320,290[P_and_P_prev].in1` | 1 | ok | measured |
| `n4` `net:G_or_PandG_prev/PandG_prev` | `AND Gate@320,220[PandG_prev].out` | `OR Gate@430,200[G_or_PandG_prev].in1` | 1 | ok | measured |
| `n5` `net:P_and_P_prev/P_out` | `AND Gate@320,290[P_and_P_prev].out` | `Pin@380,290[P_out].p` | 1 | ok | measured |
| `n6` `net:G_or_PandG_prev/G_out` | `OR Gate@430,200[G_or_PandG_prev].out` | `Pin@470,200[G_out].p` | 1 | ok | measured |

## 5. Signal flow

Every directed connection is listed in endpoint-first form.

1. `Pin@170,180[G].p.wire -> OR Gate@430,200[G_or_PandG_prev].in0`
2. `Pin@170,200[P].p.wire -> AND Gate@320,220[PandG_prev].in0`
3. `Pin@170,240[G_prev].p.wire -> AND Gate@320,220[PandG_prev].in1`
4. `AND Gate@320,220[PandG_prev].out.wire -> OR Gate@430,200[G_or_PandG_prev].in1`
5. `OR Gate@430,200[G_or_PandG_prev].out.wire -> Pin@470,200[G_out].p`
6. `Pin@170,200[P].p.wire -> AND Gate@320,290[P_and_P_prev].in0`
7. `Pin@170,310[P_Prev].p.wire -> AND Gate@320,290[P_and_P_prev].in1`
8. `AND Gate@320,290[P_and_P_prev].out.wire -> Pin@380,290[P_out].p`

### Boolean behavior

```text
G_out = G OR (P AND G_prev)
P_out = P AND P_Prev
```

This is the associative prefix operation:

```text
(G,P) ∘ (G_prev,P_Prev)
  = (G OR (P AND G_prev), P AND P_Prev)
```

Complete truth table:

| G | P | G_prev | P_Prev | G_out | P_out |
|---:|---:|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 0 | 1 | 0 | 0 |
| 0 | 0 | 1 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 | 0 |
| 0 | 1 | 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 | 1 | 0 |
| 1 | 0 | 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 | 0 |
| 1 | 0 | 1 | 1 | 1 | 0 |
| 1 | 1 | 0 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 | 1 | 1 |
| 1 | 1 | 1 | 0 | 1 | 0 |
| 1 | 1 | 1 | 1 | 1 | 1 |

## 6. State and cycles

- The circuit is purely combinational: no register, clock, RAM, ROM, latch, or feedback edge exists (**measured**).
- Longest `G_out` logic depth is two gates: `P/G_prev -> AND -> OR`. The direct `G -> OR -> G_out` path is one gate (**measured topology**).
- `P_out` has one AND-gate level (**measured**).
- The directed signal graph is acyclic; every strongly connected component is a singleton, so its condensation graph is identical to the signal DAG (**measured/model-derived**).

## 7. Hierarchy

- `pg_cell` instantiates no child subcircuits (**measured**).
- It is instantiated 138 times in the design: 2 in `kogge_stone_2b`, 6 in `ks_4b`, and 130 in `ks_32b` (**measured**).
- Parent port mapping is positional: parent instances expose outputs `G_out`, `P_out` and inputs `G`, `P`, `G_prev`, `P_Prev` in the interface order recorded in §2.

## 8. Health

- Endpoint coverage is 17/17; there are no unmatched raw wire endpoints and no unmodelled component types (**measured**).
- Graph checks report zero undriven multi-port nets, zero multi-driver nets, zero singleton/dangling nets, and zero dead-output components (**measured/model-derived**).
- All six pins and all three gates participate in a complete input-to-output path.
- No width ambiguity exists: all nodes and nets are one bit.

## 9. Debug delta

None. The serialized `pg_cell` circuit XML is byte-identical in `armv4t.circ` and `debug_armv4t.circ`; counts, nodes, nets, edges, equations, truth table, and hierarchy instance counts match.

## 10. Human map

This cell answers two carry-lookahead questions for a combined bit group. `G_out` says the combined group definitely generates a carry, either because the current group generates one itself or because it propagates a carry generated by the predecessor. `P_out` says every bit across both groups propagates a carry. Repeating this operation as a tree lets Kogge–Stone logic calculate many carries in logarithmic depth.

## 11. Cross-circuit links

- `kogge_stone_1b` produces per-bit `g` and `p`, which become `pg_cell.G` and `pg_cell.P` in parent prefix networks.
- In `kogge_stone_2b`, `pg1.G_out` drives bit 1 `C_in` and `pg2.G_prev`; `pg2.G_out` becomes `Cout`. Both parent `P_Prev` inputs and both `P_out` outputs are unconnected there. This is harmless to `G_out` because `G_out` is mathematically and electrically independent of `P_Prev`; only the unused `P_out` branch is affected.
- In `ks_4b` and `ks_32b`, both generate and propagate outputs are chained across prefix-tree stages.
- The `kogge_stone_1b` audit reports that the `ks_32b` tree currently belongs to the multiplier carry-propagate path rather than the CPU’s normal arithmetic result path; that parent-level reachability does not alter this cell’s local correctness.

## 12. Confidence

- **Measured:** all components, interface attributes, raw wires, port/net membership, directions, graph health, hierarchy instance counts, and source/debug identity.
- **Derived with exact Boolean equivalence:** equations, truth table, path depths, acyclicity, and independence of `G_out` from `P_Prev`.
- **Inferred:** prefix-adder terminology and parent architectural intent.
- **Unresolved:** none inside `pg_cell`.
