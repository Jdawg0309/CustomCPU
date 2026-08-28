# `pg_cell` delta — `armv4t.circ` → `debug_armv4t.circ`

## Result

There is no source-to-debug delta.

| Measurement | `armv4t.circ` | `debug_armv4t.circ` |
|---|---:|---:|
| Serialized circuit SHA-256 | `f3851d6accc1289b5270c9a3b72b1d91f54db10f623030676cd11d3610a6a769` | `f3851d6accc1289b5270c9a3b72b1d91f54db10f623030676cd11d3610a6a769` |
| Components | 9 | 9 |
| Raw wire segments | 10 | 10 |
| Modeled port nodes | 15 | 15 |
| Electrical nets | 7 | 7 |
| Directed edges | 8 | 8 |
| Parent instances | 138 | 138 |
| Undriven / multi-driver / dangling nets | 0 / 0 / 0 | 0 / 0 / 0 |

## Exact graph delta

- Added components: none.
- Removed components: none.
- Changed component attributes: none.
- Added ports or nodes: none.
- Removed ports or nodes: none.
- Added nets or directed connections: none.
- Removed nets or directed connections: none.
- Changed Boolean behavior: none.
- Changed hierarchy mapping: none.

Both copies implement:

```text
G_out = G OR (P AND G_prev)
P_out = P AND P_Prev
```

## Cross-links and confidence

- `kogge_stone_2b` uses only `G_out`; its unconnected `P_Prev` inputs cannot affect that output. This was coordinated with its auditor.
- `kogge_stone_1b` supplies the leaf generate/propagate signals used by parent prefix trees; parent reachability does not change across the two source files.
- All no-delta claims are **measured** from byte-identical circuit XML and identical generated graphs. Prefix terminology is **inferred**. There are no unresolved local discrepancies.
