# logisim — a Python backend for Logisim Evolution `.circ` files

Parses a `.circ`, reconstructs where every pin physically sits, derives the
netlist, draws the schematic, checks for the mistakes this format makes easy,
and routes new wires without silently shorting anything.

```
python -m logisim ls       armv4t.circ                 # every circuit + size
python -m logisim show     armv4t.circ pc_fetch        # ports and part counts
python -m logisim nets     armv4t.circ main            # nets, largest first
python -m logisim net      armv4t.circ main 1040,1530  # what is on this net
python -m logisim validate armv4t.circ                 # lint the whole design
python -m logisim render   armv4t.circ --out svg       # one SVG per circuit
python -m logisim viewer   armv4t.circ -o circuits.html
```

## Why it is not a thin XML wrapper

A `.circ` records a component's anchor and attributes, not its pin positions —
those are implied by type, size and facing, and are the only thing that turns
the file into a circuit. Three rules carry most of the weight:

**Wires join only where an endpoint touches.** A perpendicular crossing with
no endpoint at the crossing is *not* a connection. Treating any shared point as
a join collapses a real design into one enormous bogus net.

**Subcircuit instance pins are invisible to a component scan.** An instance is
a single `<comp>`; its pins are implied by the subcircuit's own pin list sorted
by `(y, x)`. Anything that reasons about geometry — routing especially — has to
put them back, or it will run a wire straight over one and connect to it.

**Rotation is about the anchor.** Ports are defined east-facing and rotated:
`south` maps `(dx,dy) → (-dy,dx)`.

## Geometry coverage

Port positions were fitted against a real design rather than assumed, and the
result is measurable: `validate` reports how many wire endpoints land on a
known pin. On `armv4t.circ` that is **99.1% of 6,453 endpoints**. The residue is
reported, never hidden — ROM and RAM use the `logisim_evolution` appearance,
whose box size is not recorded in the file, so only their confirmed pins are
modelled and both types stay in `geometry.UNMODELLED`.

Some findings are real: a wire that stops 10 units short of a pin looks
connected at normal zoom and is not. `validate` calls those out by name.

## Modules

| module | does |
|---|---|
| `model` | load `.circ` into circuits, components, wires; keeps the source text |
| `geometry` | pin positions per type, facing, and subcircuit instance |
| `netlist` | nets, drivers, and geometry-coverage measurement |
| `lint` | near misses, floating inputs, multiple drivers, diagonal wires |
| `render` | schematic SVG; colours are CSS variables so pages can theme it |
| `viewer` | one self-contained HTML browser for every circuit in a design |
| `route` | crossing-aware wire routing that will not touch a pin it wasn't sent to |
| `edit` | byte-level add/remove of wires and components, plus a deletion safety check |

Tests: `python -m unittest discover -s tests -p test_logisim.py`
