# CustomCPU circuit-atlas audit schema

The source circuits `armv4t.circ` and `debug_armv4t.circ` are read-only inputs.
Auditors must not edit either file.

Each subcircuit audit records the following sections in this order:

1. **Identity and purpose** — inferred role, source file, and circuit name.
2. **Interface** — every input/output/inout pin, width, facing, and semantic role.
3. **Inventory** — component counts grouped by type, including subcircuit instances.
4. **Nets** — every electrical net with all attached component ports, drivers,
   sinks, labels, bit width when known, and graph status.
5. **Signal flow** — named paths written as
   `source_component.output.wire -> destination_component.input_pin`.
6. **State and cycles** — registers, RAM/ROM, counters, feedback edges, and
   strongly connected components.
7. **Hierarchy** — child-subcircuit instances and their port mappings.
8. **Health** — undriven, dangling, multi-driver, dead-output, width-risk, and
   ambiguous-direction findings. A graph-model limitation must not be called a
   circuit defect.
9. **Debug delta** — nodes, components, attributes, and connections that differ
   between `armv4t.circ` and `debug_armv4t.circ`.
10. **Human map** — concise explanation of how the block participates in the CPU.
11. **Cross-circuit links** — producers/consumers or parent instances that another
    auditor should reconcile.
12. **Confidence** — measured, inferred, or unresolved for every non-obvious claim.

## Canonical graph forms

- `port_net_graph`: bipartite `networkx.MultiGraph`; port and electrical-net nodes.
- `signal_graph`: directed `networkx.MultiDiGraph`; driver-port to sink-port edges.
- `component_graph`: directed `networkx.MultiDiGraph`; component-to-component flow.
- `hierarchy_tree`: directed `networkx.DiGraph`; circuit to instantiated subcircuits.
- `condensation_graph`: acyclic graph of signal-graph strongly connected components.

Circuits can contain feedback, so the complete electrical representation is a graph,
not a tree. Trees are derived views and must never replace the lossless graphs.

## Stable identity

Use `component_type@x,y[label].port_name` for ports. Coordinates are identifiers in
machine data only. Human wiring prose must lead with named endpoints and use
coordinates only as optional search hints.

## Audit coordination

Agents write only their assigned audit files. They may read every previously written
audit and must record relevant cross-circuit links. Conflicts are listed explicitly;
they are not silently resolved.
