# `kogge_stone_1b` delta — `armv4t.circ` vs `debug_armv4t.circ`

## Scope and identity

| Item | `armv4t.circ` | `debug_armv4t.circ` | Result |
|---|---|---|---|
| Whole-file SHA-256 | `ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84` | `eaaeadc774fa99daf6a304403b9c8556210b836b52b79de99bdea7d08ff225c9` | Source files differ globally. **[Measured]** |
| `kogge_stone_1b` subtree SHA-256 | `093cf41a5b1581956b578d1286e8e21a8d0f7820bee718d386008300c80ba81c` | `093cf41a5b1581956b578d1286e8e21a8d0f7820bee718d386008300c80ba81c` | Subcircuit is byte-for-byte identical. **[Measured]** |
| Components / raw wires | `9 / 14` | `9 / 14` | Identical. **[Measured]** |
| Port nodes / electrical nets / directed edges | `15 / 6 / 9` | `15 / 6 / 9` | Identical. **[Measured]** |
| Endpoint coverage | `20/20` | `20/20` | Identical; no unmodelled type. **[Measured]** |
| Direct parent instances | `38` | `38` | Identical: 2 in `kogge_stone_2b`, 4 in `ks_4b`, 32 in `ks_32b`. **[Measured]** |

## Internal delta

There is no internal delta:

- no component added, removed, moved, relabelled, or reconfigured;
- no interface pin name, direction, facing, or width changed;
- no raw wire segment, branch point, or electrical net changed;
- no directed driver-to-sink connection changed;
- no Boolean function, state element, SCC, or health result changed;
- no child hierarchy mapping exists in either version.

All statements are **[Measured by XML-subtree hash and generated graph comparison]**. The machine diff is:

```text
kogge_stone_1b: +0 nodes / -0 nodes, +0 connections / -0 connections
```

Both versions implement:

```text
g   = A & B
p   = A ^ B
sum = A ^ B ^ C_in
```

The equations are **[Measured topology; inferred standard gate semantics]**.

## Parent and reachability delta

The direct parent definitions and instance locations are also identical. In each file:

```text
kogge_stone_2b -> 2 × kogge_stone_1b
ks_4b          -> 4 × kogge_stone_1b
ks_32b         -> 32 × kogge_stone_1b
main -> ALU -> ks_32b -> kogge_stone_1b
```

The top-reachable `ALU.ks_32b` is part of the same dormant multiplier-finalization chain in both files:

```text
mul_32.sum.wire   -> ks_32b.A
mul_32.carry.wire -> ks_32b.B
undriven          -> ks_32b.Cin
ks_32b.sum*.wire  -> result_splitter.bit*    # combined result bus dangling
ks_32b.Cout.wire  -> no sink
```

Thus neither source uses this leaf for ordinary ALU arithmetic, and neither source carries its multiplier result to `ALU.result`. **[Measured parent connectivity; architectural consequence inferred]**

## Health delta

There is none inside the leaf: both have zero undriven multi-port nets, zero dangling singleton nets, zero multi-driver nets, zero dead-output components, all-one-bit paths, and 15 singleton SCCs. **[Measured]**

The dangling signals described above are in parent `ALU`, not defects in `kogge_stone_1b`. **[Measured boundary]**

## Handoff

- Use either leaf audit for wiring and behavior; they describe identical circuitry.
- Reconcile `g/p` consumption with the `pg_cell` and `ks_32b` audits.
- Reconcile the dormant top-reachable multiplier chain with the `ALU` audit and `main_datapath.md`.
- No source-circuit edits are implied or required by this delta report.

## Confidence

- **Measured:** all identity, graph, hierarchy-count, parent-connection, and health comparisons.
- **Inferred:** Boolean meaning from standard Logisim gates and the architectural consequence of the disconnected parent result bus.
- **Unresolved:** whether the dead multiplier path is intentionally reserved for future work.
