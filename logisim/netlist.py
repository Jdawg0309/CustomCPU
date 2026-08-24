"""Nets: which pins are actually electrically connected.

The one rule that matters, and the one that is easy to get wrong: Logisim
joins two wires only where an ENDPOINT of one lies on the other.  Two wires
that merely cross, neither ending at the shared point, are NOT connected.
Treating any shared point as a join collapses a large design into a single
bogus net -- on this CPU it produced one 8674-point "net" spanning a whole
subcircuit.

A component pin joins a wire when the pin's point lies anywhere on it, and two
pins at the same point are connected by abutment with no wire at all.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, Iterable, List, Optional, Set, Tuple

from .model import Circuit, Component, Design, Point, Wire
from . import geometry as geo


@dataclass
class Net:
    points: Set[Point] = field(default_factory=set)
    wires: List[Wire] = field(default_factory=list)
    pins: List[Tuple[Component, str]] = field(default_factory=list)

    design: object = None

    @property
    def drivers(self) -> List[Tuple[Component, str]]:
        return [(c, n) for c, n in self.pins if _kind(c, n, self.design) == "out"]

    def labels(self) -> List[str]:
        return sorted({c.label for c, _ in self.pins if c.label})

    def __len__(self) -> int:
        return len(self.points)

    def __repr__(self) -> str:
        lab = "/".join(self.labels()[:3])
        return "<Net %d pts, %d pins%s>" % (len(self.points), len(self.pins),
                                            " " + lab if lab else "")


def _kind(c: Component, portname: str, design: Design = None) -> str:
    """Direction of one pin.  Taken from the geometry tables rather than a
    hand-written map, so a Register's Q counts as a driver and a mux's data
    inputs do not -- without this, `drivers` only ever saw Pin components and
    the multiple-driver check was toothless."""
    if c.name == "Pin":
        # a circuit input pin DRIVES the enclosing circuit
        return "out" if c.attrs.get("output") != "true" else "in"
    for p in geo.ports(design, c):
        if p.name == portname:
            return p.kind
    return "inout"


class _DSU:
    def __init__(self):
        self.p: Dict[int, int] = {}

    def find(self, x: int) -> int:
        while self.p.get(x, x) != x:
            self.p[x] = self.p.get(self.p[x], self.p[x]); x = self.p[x]
        return x

    def union(self, a: int, b: int) -> None:
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.p[ra] = rb


def build(design: Design, circ: Circuit) -> List[Net]:
    wires = circ.wires
    dsu = _DSU()
    for i in range(len(wires)):
        dsu.find(i)

    # index wire endpoints so the join test is not quadratic over long spans
    by_end: Dict[Point, List[int]] = {}
    for i, w in enumerate(wires):
        by_end.setdefault(w.a, []).append(i)
        by_end.setdefault(w.b, []).append(i)

    for i, w in enumerate(wires):
        for end in (w.a, w.b):
            for j in by_end.get(end, ()):        # shared endpoint
                if j != i:
                    dsu.union(i, j)
    # endpoint of one lying mid-span on another
    for pt, owners in by_end.items():
        for j, w in enumerate(wires):
            if w.contains(pt):
                for i in owners:
                    if i != j:
                        dsu.union(i, j)

    groups: Dict[int, Net] = {}
    for i, w in enumerate(wires):
        n = groups.setdefault(dsu.find(i), Net())
        n.design = design
        n.wires.append(w)
        n.points.update(w.points())

    # Attach pins.  A pin standing on a point where two wires merely cross
    # JOINS them -- the crossing is not a connection on its own, but a pin
    # there is.  So collect every net at the point and merge, rather than
    # picking one arbitrarily.
    index: Dict[Point, List[Net]] = {}
    for n in groups.values():
        for p in n.points:
            index.setdefault(p, []).append(n)

    def _merge(targets: List[Net]) -> Net:
        keep = targets[0]
        for other in targets[1:]:
            if other is keep:
                continue
            keep.points |= other.points
            keep.wires += other.wires
            keep.pins += other.pins
            for p in other.points:
                index[p] = [keep if x is other else x for x in index.get(p, [])]
            for key, val in list(groups.items()):
                if val is other:
                    groups[key] = keep
        return keep

    loose: Dict[Point, Net] = {}
    for c in circ.components:
        if c.name == "Splitter":
            named = list(zip(geo._splitter_points(c), [p.name for p in geo._splitter_ports(c)]))
        else:
            named = [(p.at(c), p.name) for p in geo.ports(design, c)]
        for pt, nm in named:
            here, seen_ids = [], set()
            for x in index.get(pt, []):
                if id(x) not in seen_ids:
                    seen_ids.add(id(x)); here.append(x)
            if here:
                n = _merge(here) if len(here) > 1 else here[0]
            else:
                n = loose.get(pt)
                if n is None:
                    n = Net(points={pt}); n.design = design; loose[pt] = n
            n.pins.append((c, nm))

    out, seen = [], set()
    for n in list(groups.values()) + list(loose.values()):
        if id(n) not in seen:
            seen.add(id(n)); out.append(n)
    return out


def net_at(design: Design, circ: Circuit, p: Point) -> Optional[Net]:
    for n in build(design, circ):
        if tuple(p) in n.points:
            return n
    return None


def coverage(design: Design, circ: Circuit) -> dict:
    """How much of the circuit the geometry model actually explains.

    A wire endpoint that lands on no known pin and on no other wire is either
    a dangling stub the designer left, or a pin this model does not know about.
    The two are separated so the number means something.
    """
    pinpts = set(geo.all_port_points(design, circ))
    ends: Dict[Point, int] = {}
    for w in circ.wires:
        ends[w.a] = ends.get(w.a, 0) + 1
        ends[w.b] = ends.get(w.b, 0) + 1
    on_wire = set()
    for pt in ends:
        for w in circ.wires:
            if w.contains(pt) and pt not in (w.a, w.b):
                on_wire.add(pt); break
    unmatched = [p for p in ends if p not in pinpts and p not in on_wire and ends[p] < 2]
    unmodelled = sorted({c.name for c in circ.components
                         if not c.is_subcircuit and c.name in geo.UNMODELLED})
    return {
        "endpoints": len(ends),
        "matched": len(ends) - len(unmatched),
        "unmatched": sorted(unmatched),
        "unmodelled_types": unmodelled,
    }
