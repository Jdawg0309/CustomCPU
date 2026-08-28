# CustomCPU circuit atlas

This directory documents every circuit in `armv4t.circ` and
`debug_armv4t.circ` without modifying either source file.

## Start here

Open `notebooks/00_architecture_overview.ipynb`, then open the notebook named
for the circuit you want to understand. There is one comparative notebook for
each of the 33 circuits.

Regenerate and validate everything from the repository root:

```bash
python3 -m ipynb.build_atlas
python3 -m ipynb.validate_atlas
```

Execute every notebook and save its outputs:

```bash
python3 -m ipynb.build_atlas --execute
```

Dependencies used by the notebooks are Python 3, NetworkX, pandas,
Matplotlib, nbformat, and nbclient.

## Directory map

```text
ipynb/
├── AUDIT_SCHEMA.md          Human/agent audit contract
├── circuit_atlas.py         NetworkX conversion and lossless exports
├── build_atlas.py           Reproducible data/notebook generator
├── validate_atlas.py        Coverage and round-trip validation
├── notebooks/               Overview plus one notebook per circuit
├── audits/
│   ├── armv4t/              Semantic audits of the reference file
│   ├── debug/               Semantic audits of the debug file
│   └── *_delta.md           Human explanations of file differences
└── data/
    ├── armv4t/              JSON and GraphML for `armv4t.circ`
    ├── debug/               JSON and GraphML for `debug_armv4t.circ`
    └── diff/                Node and connection deltas
```

## Graph representations

Each circuit has four complementary graphs:

1. **Port/net graph** — a bipartite `networkx.MultiGraph`. Electrical nets are
   hyperedges in reality, so representing each net as a node preserves every
   attached port without inventing pairwise connections.
2. **Signal graph** — a `networkx.MultiDiGraph` from modeled drivers to sinks.
   This supports forward/backward tracing and exact endpoint-first instructions.
3. **Component graph** — a readable `networkx.MultiDiGraph` collapsed to
   component instances while retaining source/destination port attributes.
4. **Condensation graph** — a DAG formed by collapsing strongly connected
   components. This is the safe tree-like view of state feedback and cycles.

The design hierarchy is a fifth graph connecting parent circuits to instantiated
child circuits.

## Connection language

Human instructions lead with endpoints:

```text
source_component.output.wire -> destination_component.input_pin
```

Coordinates are stored for stable machine identity and optional searching, but
they are never the primary wiring instruction.

## Completeness and limitations

The JSON records every parsed component, explicit attribute, raw wire segment,
modeled component port, electrical net, and directed signal edge. Validation
checks the generated counts against both source files and round-trips every
GraphML file.

Logisim ROM and RAM graphical pin placement is not fully encoded by the source
format. Known pins are represented, while unmodelled endpoints remain visible in
coverage results. Such entries are graph-model limitations until independently
verified; they are not automatically circuit defects.

Circuits contain feedback, so a single tree cannot represent the complete
machine. The full graph is canonical; hierarchy and condensation trees are
derived navigation aids.
