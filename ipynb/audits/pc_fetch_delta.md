# `pc_fetch` delta — `armv4t.circ` vs `debug_armv4t.circ`

## Scope and identity

| Item | `armv4t.circ` | `debug_armv4t.circ` | Result |
|---|---|---|---|
| Whole-file SHA-256 | `ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84` | `eaaeadc774fa99daf6a304403b9c8556210b836b52b79de99bdea7d08ff225c9` | Files differ globally. **[Measured]** |
| `pc_fetch` XML SHA-256 | `a727a1d1451dcbb0ba72266b205da962792e20e6aadc03e8ce5ffb77b6b3fc7f` | `a727a1d1451dcbb0ba72266b205da962792e20e6aadc03e8ce5ffb77b6b3fc7f` | Subcircuit is byte-for-byte identical. **[Measured]** |
| Components / wires / nets | `20 / 33 / 27` | `20 / 33 / 27` | Identical. **[Measured]** |
| Port nodes / directed edges | `49 / 22` | `49 / 22` | Identical. **[Measured]** |
| Endpoint coverage | `47/47` | `47/47` | Identical, no unmodelled type. **[Measured]** |

## Internal delta

There is no internal delta:

- no component added, removed, or moved;
- no component attribute changed;
- no pin/port changed;
- no wire segment or electrical net changed;
- no state element or feedback edge changed;
- no graph-health result changed.

All are **[Measured by XML-subtree hash and graph comparison]**.

Both versions implement the same next-PC function:

```text
PC_D = hold ? PC_Q
            : BRANCH ? (abs_select ? abs_target : PC_Q + IMM)
                     : PC_Q + 4
pc_plus4 = PC_Q + 4
pc_out   = PC_Q[11:2]
```

This equation is **[Measured topology; inferred standard mux/adder semantics]**.

## Parent-`main` instance delta

Both parent circuits use `pc_fetch@5780,8630` and have the same direct drivers/consumers on eight of its nine ports:

| Port | Same direct parent connection in both files |
|---|---|
| `pc_plus4` | `pc_fetch.pc_plus4.wire -> Probe@5760,8770.p`; same wire -> `Multiplexer@7510,9000.in1`. **[Measured]** |
| `CLK` | `Clock@4990,8630.out.wire -> pc_fetch.CLK`. **[Measured]** |
| `BRANCH` | `OR Gate@4950,8560.out.wire -> pc_fetch.BRANCH`. **[Measured]** |
| `hold` | `block_transfer_control@5790,8110.hold_pc.wire -> pc_fetch.hold`. **[Measured]** |
| `IMM` | `Adder@8640,10400.out.wire -> pc_fetch.IMM`. **[Measured]** |
| `abs_target` | `Multiplexer@5040,9360.out.wire -> pc_fetch.abs_target`. **[Measured]** |
| `abs_select` | `OR Gate@5010,8730.out.wire -> pc_fetch.abs_select`. **[Measured]** |
| `RST` | `Pin@5050,8750.p.wire -> pc_fetch.RST`. **[Measured]** |

The only immediate parent-interface difference is one extra debug consumer of `pc_out`:

| File | `pc_out` consumers |
|---|---|
| `armv4t.circ` | `pc_fetch.pc_out.wire -> Probe@5940,8530.p`; same wire -> `ROM@5890,8620.addr`. **[Measured]** |
| `debug_armv4t.circ` | Both arm consumers, plus `pc_fetch.pc_out.wire -> Bit Extender@8900,11780.in`. **[Measured]** |

The added debug path continues:

```text
pc_fetch.pc_out[9:0].wire -> Bit Extender@8900,11780.in
Bit Extender@8900,11780.out.wire -> Shifter@9060,11820.in
Shifter@9060,11820.out.wire -> Adder@9220,11950.a
Adder@9220,11950.out.wire -> r15-read selection muxes
```

The shifter reconstructs the low 12 PC byte-address bits and the adder adds 8. Comparators on register-address A/B select that value when the source register is `r15`. Therefore debug supports ARM-visible `PC+8` reads through this parent layer, while arm does not contain that layer. **[Measured/reconciled with main-datapath audit]**

## Control-protocol reconciliation

Sibling `main` control audit established:

- `OR Gate@4950,8560.out` asserts `BRANCH` for relative branch/BL, BX, deferred-PC application, and register-file writes to `r15`;
- `OR Gate@5010,8730.out` asserts `abs_select` for BX, deferred-PC application, and register-file writes to `r15`, but not for ordinary relative branch/BL;
- `Multiplexer@5040,9360.out` selects a live target or saved `pc_target.Q` during deferred application;
- when block transfer asserts `hold`, parent `pc_defer` saves an attempted PC redirect, then reapplies it after completion with both `BRANCH=1` and `abs_select=1`.

This agrees with `pc_fetch`'s mux priority: `hold` suppresses the live redirect and the later application takes the absolute path. **[Measured/reconciled]**

## Architectural consequence

| Behavior | `armv4t.circ` | `debug_armv4t.circ` |
|---|---|---|
| Fetch address | `PC[11:2]` | `PC[11:2]` |
| Sequential, relative, absolute, hold behavior | Same | Same |
| Architectural reads of source `r15` | Parent lacks debug reconstruction layer | Parent substitutes reconstructed `PC+8` |
| PC+8 reconstruction width | N/A | Only low 12 byte-address bits survive because source is 10-bit `pc_out` |

The debug reconstruction is therefore suitable for the current 4-KiB ROM window but would lose nonzero `PC[31:12]`. That is a width risk if instruction memory is ever mapped above/expanded beyond that window. **[Measured width; inferred consequence]**

## Contradictions and unresolved items

- **No sibling-audit contradiction:** main datapath and main control auditors independently reported endpoints consistent with this audit. **[Reconciled]**
- The name `pc_out` can be mistaken for a full PC; it is explicitly a 10-bit word address. **[Measured]**
- `Graph` represents built-in `Pin.p` geometry as `inout`; interface direction comes from the Pin's `output=true` attribute and circuit pin classification. This is a graph-model detail, not a circuit defect. **[Measured/model limitation]**
- Splitter fan2 has no assigned incoming bit and no consumer. Its exact formal width under Logisim defaults is unresolved, but it is electrically irrelevant to fan1/`pc_out`. **[Measured/unresolved]**
- The PC Register omits explicit trigger/clear-mode attributes. Its exact default edge/clear timing was not dynamically measured in this audit. **[Unresolved locally]**
- Parent `OR Gate@6070,7790.out` was reported dangling by the main-control auditor. It is adjacent to shared hold/done logic but does not drive a `pc_fetch` port, so no fault is assigned to this subcircuit. **[Sibling-measured]**

## Confidence summary

- **Measured:** byte identity of both `pc_fetch` definitions, all internal components/attributes/nets, direct parent mappings, graph counts, and the extra debug `pc_out` consumer.
- **Inferred:** standard Logisim functional truth tables and the architectural interpretation of the parent PC+8 substitution.
- **Unresolved:** Register default timing details and empty splitter fan2 width semantics.
