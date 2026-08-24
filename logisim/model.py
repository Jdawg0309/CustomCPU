"""Object model for Logisim Evolution .circ files.

Parsing is deliberately text-preserving: `Design.text` keeps the original
source so surgical, byte-level edits stay possible (see logisim.edit).  The
parsed objects are a read-only view over that text.
"""
from __future__ import annotations

import re
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple

Point = Tuple[int, int]

_LOC = re.compile(r"\((-?\d+),(-?\d+)\)")


def _pt(s: str) -> Point:
    m = _LOC.match(s.strip())
    if not m:
        raise ValueError("bad point %r" % s)
    return int(m.group(1)), int(m.group(2))


@dataclass
class Component:
    name: str                       # "AND Gate", "Multiplexer", or a subcircuit name
    lib: Optional[str]              # library number; None for subcircuit instances
    loc: Point
    attrs: Dict[str, str] = field(default_factory=dict)

    @property
    def facing(self) -> str:
        return self.attrs.get("facing", "east")

    @property
    def label(self) -> str:
        return self.attrs.get("label", "")

    @property
    def width(self) -> int:
        return int(self.attrs.get("width", 1))

    @property
    def is_subcircuit(self) -> bool:
        return self.lib is None

    def __repr__(self) -> str:
        lab = " %r" % self.label if self.label else ""
        return "<%s @%s%s>" % (self.name, self.loc, lab)


@dataclass
class Wire:
    a: Point
    b: Point

    @property
    def vertical(self) -> bool:
        return self.a[0] == self.b[0]

    @property
    def diagonal(self) -> bool:
        return self.a[0] != self.b[0] and self.a[1] != self.b[1]

    def points(self, step: int = 10) -> List[Point]:
        """Every lattice point the wire passes through (axis-aligned only)."""
        (x1, y1), (x2, y2) = self.a, self.b
        if x1 == x2:
            lo, hi = sorted((y1, y2))
            return [(x1, y) for y in range(lo, hi + 1, step)]
        if y1 == y2:
            lo, hi = sorted((x1, x2))
            return [(x, y1) for x in range(lo, hi + 1, step)]
        return [self.a, self.b]      # diagonal: endpoints only

    def contains(self, p: Point) -> bool:
        (x1, y1), (x2, y2) = self.a, self.b
        x, y = p
        if x1 == x2:
            return x == x1 and min(y1, y2) <= y <= max(y1, y2)
        if y1 == y2:
            return y == y1 and min(x1, x2) <= x <= max(x1, x2)
        return p in (self.a, self.b)

    def __repr__(self) -> str:
        return "<wire %s-%s>" % (self.a, self.b)


@dataclass
class Circuit:
    name: str
    components: List[Component] = field(default_factory=list)
    wires: List[Wire] = field(default_factory=list)
    attrs: Dict[str, str] = field(default_factory=dict)

    def pins(self) -> List[Component]:
        """Interface pins, in Logisim's port order: sorted by (y, x)."""
        ps = [c for c in self.components if c.name == "Pin"]
        return sorted(ps, key=lambda c: (c.loc[1], c.loc[0]))

    def inputs(self) -> List[Component]:
        return [p for p in self.pins() if p.attrs.get("output") != "true"]

    def outputs(self) -> List[Component]:
        return [p for p in self.pins() if p.attrs.get("output") == "true"]

    def bbox(self) -> Tuple[int, int, int, int]:
        xs, ys = [], []
        for c in self.components:
            xs.append(c.loc[0]); ys.append(c.loc[1])
        for w in self.wires:
            xs += [w.a[0], w.b[0]]; ys += [w.a[1], w.b[1]]
        if not xs:
            return (0, 0, 100, 100)
        return min(xs), min(ys), max(xs), max(ys)

    def find(self, label: str) -> List[Component]:
        return [c for c in self.components if c.label == label]

    def at(self, p: Point) -> List[Component]:
        return [c for c in self.components if c.loc == tuple(p)]

    def __repr__(self) -> str:
        return "<Circuit %r %d comps %d wires>" % (self.name, len(self.components), len(self.wires))


@dataclass
class Design:
    path: str
    text: str
    circuits: Dict[str, Circuit]
    main: str

    def __getitem__(self, name: str) -> Circuit:
        return self.circuits[name]

    def __iter__(self):
        return iter(self.circuits.values())

    def subcircuit_names(self) -> List[str]:
        return list(self.circuits)

    def __repr__(self) -> str:
        return "<Design %s: %d circuits>" % (self.path, len(self.circuits))


def load(path: str) -> Design:
    with open(path, encoding="utf-8") as fh:
        text = fh.read()
    root = ET.fromstring(text)
    circuits: Dict[str, Circuit] = {}
    for ce in root.findall("circuit"):
        c = Circuit(name=ce.get("name", "?"))
        c.attrs = {a.get("name"): a.get("val") for a in ce.findall("a")}
        for e in ce:
            if e.tag == "comp":
                c.components.append(Component(
                    name=e.get("name"), lib=e.get("lib"), loc=_pt(e.get("loc")),
                    attrs={a.get("name"): a.get("val") for a in e.findall("a")}))
            elif e.tag == "wire":
                c.wires.append(Wire(_pt(e.get("from")), _pt(e.get("to"))))
        circuits[c.name] = c
    main = "main"
    mroot = root.find("main")
    if mroot is not None and mroot.get("name") in circuits:
        main = mroot.get("name")
    elif main not in circuits and circuits:
        main = next(iter(circuits))
    return Design(path=path, text=text, circuits=circuits, main=main)
