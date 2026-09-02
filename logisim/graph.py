"""The circuit as a graph: what is connected to what, and how to say it.

A `.circ` file records components and wire segments.  Neither is the thing you
actually want to reason about.  What you want is "the output of this mux feeds
the carry-in of that adder", and getting from wire segments to that statement
is the whole job of this module.

Two graphs are built, because two different questions get asked:

**The port/net graph** is the honest one.  A net is a *hyperedge* -- it touches
any number of pins at once -- so the structure is bipartite: PORT nodes on one
side, NET nodes on the other, an edge wherever a pin sits on a net.  Nothing is
lost and nothing is invented.

**The signal graph** is the useful one.  Each net is collapsed into directed
edges from its driver(s) to its sinks, giving a plain digraph you can walk,
trace, and diff.  A net with no driver or several drivers is kept and flagged
rather than dropped, because those are exactly the defects worth finding.

Node identity is chosen so that two *different files* produce comparable
graphs.  That is the point: `diff()` between armv4t.circ and debug_armv4t.circ
turns "make main match debug" into a finite list of wires to add, expressed as
`source_node -> sink_node` rather than as raw coordinates.
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from typing import Dict, Iterable, List, Optional, Set, Tuple

from .model import Circuit, Component, Design, Point, load
from . import geometry as geo, netlist as nl

# ---------------------------------------------------------------- identity

def comp_id(c: Component) -> str:
    """A name for one component that survives being written into a report.

    Label first when there is one -- a labelled part keeps its name even if the
    user drags it -- otherwise type and location.  Location is included even for
    labelled parts because labels are not unique in this design (several nets
    carry the same label on purpose).
    """
    base = "%s@%d,%d" % (c.name, c.loc[0], c.loc[1])
    return "%s[%s]" % (base, c.label) if c.label else base


def port_id(c: Component, port: str) -> str:
    return "%s.%s" % (comp_id(c), port)


@dataclass
class Node:
    """One port of one component."""
    id: str
    comp: str                      # comp_id of the owner
    kind: str                      # component type, e.g. "Multiplexer"
    port: str                      # port name, e.g. "in1"
    loc: Point                     # where the component's anchor sits
    pin: Point                     # where THIS port physically sits (rotated)
    direction: str                 # "out" | "in" | "inout"
    label: str = ""
    bus_bit: Optional[int] = None  # splitter fans only: bit of the combined bus
    bus_bits: Tuple[int, ...] = ()  # every bit of the bus this fan carries

    def __repr__(self) -> str:
        return "<%s %s @%s>" % (self.id, self.direction, self.pin)


THROUGH = -1        # an edge that hops across a splitter, not through a net


@dataclass
class Edge:
    """A directed driver->sink hop through one net."""
    src: str                       # port node id
    dst: str                       # port node id
    net: int                       # index into Graph.nets
    def __repr__(self) -> str:
        return "%s -> %s" % (self.src, self.dst)


@dataclass
class NetNode:
    """One electrical net: a hyperedge over ports."""
    index: int
    ports: List[str] = field(default_factory=list)
    drivers: List[str] = field(default_factory=list)
    # drivers plus anything a splitter or an unmodelled part feeds in
    effective_drivers: List[str] = field(default_factory=list)
    points: Set[Point] = field(default_factory=set)
    labels: List[str] = field(default_factory=list)

    @property
    def name(self) -> str:
        if self.labels:
            return "net:" + "/".join(self.labels[:2])
        return "net#%d" % self.index

    @property
    def status(self) -> str:
        if not self.effective_drivers:
            return "undriven"
        if len(self.drivers) > 1:
            return "multi-driver"
        return "ok"


class Graph:
    """Ports, nets and the directed signal flow between them."""

    def __init__(self, design: Design, circuit: str):
        self.design = design
        self.circuit_name = circuit
        self.circ: Circuit = design[circuit]
        self.nodes: Dict[str, Node] = {}
        self.nets: List[NetNode] = []
        self.edges: List[Edge] = []
        self._succ: Dict[str, List[Edge]] = {}
        self._pred: Dict[str, List[Edge]] = {}
        self._net_of: Dict[str, int] = {}
        self._build()

    # ------------------------------------------------------------ building
    def _build(self) -> None:
        for i, net in enumerate(nl.build(self.design, self.circ)):
            nn = NetNode(index=i, points=set(net.points), labels=net.labels())
            for comp, port in net.pins:
                nid = port_id(comp, port)
                if nid not in self.nodes:
                    self.nodes[nid] = self._node(comp, port)
                nn.ports.append(nid)
                self._net_of[nid] = i
                if self.nodes[nid].direction == "out":
                    nn.drivers.append(nid)
            self.nets.append(nn)

        self._orient()

        # Collapse each net into driver->sink edges.  Multi-driver nets still
        # produce their edges (a short really does let every driver reach every
        # sink) so a trace through a broken net does not silently dead-end.
        for nn in self.nets:
            drivers = nn.effective_drivers or nn.drivers
            sinks = [p for p in nn.ports if p not in drivers]
            for d in drivers:
                for s in sinks:
                    self._add_edge(Edge(d, s, nn.index))

        # A splitter is not a component in the signal sense, it is a bundle of
        # wires -- but the file models its ports as `inout`, so without this the
        # signal stops dead at every splitter and two thirds of `main` looks
        # undriven.  Hop across it, in whichever direction it is actually
        # carrying, so `trace` follows a bit out of a bus and back into one.
        for comp, ports in self._splitters:
            ins = [p for p in ports if self._driven_port.get(p)]
            outs = [p for p in ports if not self._driven_port.get(p)]
            for a in ins:
                for b in outs:
                    self._add_edge(Edge(a, b, THROUGH))

    def _add_edge(self, e: Edge) -> None:
        self.edges.append(e)
        self._succ.setdefault(e.src, []).append(e)
        self._pred.setdefault(e.dst, []).append(e)

    def _orient(self) -> None:
        """Work out which end of each bidirectional part is the source.

        Splitters chain -- a bus is split, a slice re-split -- so this has to
        run to a fixpoint rather than in one pass.  A component whose outputs
        this model does not describe (ROM, RAM) counts as a driver of every net
        it touches; otherwise every net downstream of program memory would be
        reported as floating, which is a model gap, not a defect.
        """
        self._splitters = []
        for c in self.circ.components:
            if c.name == "Splitter":
                names = [p.name for p in geo._splitter_ports(c)]
                self._splitters.append((c, [port_id(c, n) for n in names]))

        self._driven_port: Dict[str, bool] = {}
        for nn in self.nets:
            nn.effective_drivers = list(nn.drivers)
            for p in nn.ports:
                if self.nodes[p].kind in geo.UNMODELLED:
                    nn.effective_drivers.append(p)

        changed = True
        while changed:
            changed = False
            driven_nets = {nn.index for nn in self.nets if nn.effective_drivers}
            for p, i in self._net_of.items():
                if i in driven_nets and not self._driven_port.get(p):
                    self._driven_port[p] = True
            for comp, ports in self._splitters:
                if not any(self._driven_port.get(p) for p in ports):
                    continue
                for p in ports:
                    nn = self.net_of(p)
                    if nn is None or self._driven_port.get(p):
                        continue
                    if p not in nn.effective_drivers:
                        nn.effective_drivers.append(p)
                        changed = True

    def _node(self, c: Component, port: str) -> Node:
        # Splitters MUST be handled first and separately.  _splitter_ports()
        # already bakes the facing into its offsets, so running them through
        # Port.at() rotates a second time -- a west-facing splitter then reports
        # its fans 40 units east of where they are, on the wrong side of the
        # part.  For everything else the opposite holds: Port.at() is required,
        # because loc + (dx,dy) ignores facing entirely.
        pin, bus_bit, bus_bits = c.loc, None, ()
        if c.name == "Splitter":
            sports = geo._splitter_ports(c)
            for i, (pt, sp) in enumerate(zip(geo._splitter_points(c), sports)):
                if sp.name == port:
                    pin = pt
                    if sp.name != "combined":
                        bus_bits = self._bus_bits(c, i - 1)
                        bus_bit = bus_bits[0] if len(bus_bits) == 1 else None
                    break
        else:
            for p in geo.ports(self.design, c):
                if p.name == port:
                    pin = p.at(c)
                    break
        return Node(id=port_id(c, port), comp=comp_id(c), kind=c.name,
                    port=port, loc=c.loc, pin=pin, bus_bit=bus_bit,
                    bus_bits=bus_bits,
                    direction=nl._kind(c, port, self.design), label=c.label)

    @staticmethod
    def _bus_bit(c: Component, fan: int) -> Optional[int]:
        """Which bit of the combined bus a fan actually carries.

        The `bitK` attributes are the INVERSE of what the name suggests: `bitK`
        holds the fan number that bus bit K is routed to, not the bus bit that
        fan K carries.  Reading it the forward way scrambles any splitter whose
        map is not an involution -- it reported all four CPSR flags as crossed
        when they round-trip perfectly.  Measured by driving one fan at a time
        on a splitter with the CPSR write map (3,0,1,2) and reading the whole
        combined bus.

        A fan may also carry several bus bits (a byte lane); those are reported
        as None rather than guessed at, since one number cannot describe them.
        """
        return None if not (b := Graph._bus_bits(c, fan)) or len(b) > 1 else b[0]

    @staticmethod
    def _bus_bits(c: Component, fan: int) -> Tuple[int, ...]:
        """Every bus bit routed to one fan, low bit first.

        A fan usually carries one bit, but a splitter used to peel a FIELD off
        a bus -- the Rn field, the register list, the 12-bit immediate -- sends
        a whole run of bits down a single fan.  Reporting only the first would
        make a field extraction look like a single-bit tap.
        """
        n = int(c.attrs.get("incoming", c.attrs.get("fanout", 2)))
        out = []
        for k in range(n):
            v = c.attrs.get("bit%d" % k, k)
            if v == "none":          # bus bit deliberately routed nowhere
                continue
            if int(v) == fan:
                out.append(k)
        return tuple(out)

    # ------------------------------------------------------------- queries
    def __contains__(self, nid: str) -> bool:
        return nid in self.nodes

    def __len__(self) -> int:
        return len(self.nodes)

    def succ(self, nid: str) -> List[str]:
        """Ports this one drives."""
        return [e.dst for e in self._succ.get(nid, ())]

    def pred(self, nid: str) -> List[str]:
        """Ports that drive this one."""
        return [e.src for e in self._pred.get(nid, ())]

    def net_of(self, nid: str) -> Optional[NetNode]:
        i = self._net_of.get(nid)
        return None if i is None else self.nets[i]

    def neighbours(self, nid: str) -> List[str]:
        """Everything on the same net, driver or not -- the undirected view."""
        nn = self.net_of(nid)
        return [] if nn is None else [p for p in nn.ports if p != nid]

    def ports_of(self, comp: str) -> List[Node]:
        return [n for n in self.nodes.values() if n.comp == comp]

    def find(self, needle: str) -> List[Node]:
        """Substring match over node ids and labels -- the way you actually
        look something up when you know it as 'the carry mux'."""
        q = needle.lower()
        return sorted((n for n in self.nodes.values()
                       if q in n.id.lower() or q in n.label.lower()),
                      key=lambda n: n.id)

    def trace(self, start: str, depth: int = 6, forward: bool = True) -> List[List[str]]:
        """Every path up to `depth` hops from `start`.

        Breadth-first with a visited set, so a combinational loop terminates
        instead of running forever.  Returns paths, not just reachable nodes,
        because the question is almost always "how does this get there".
        """
        step = self.succ if forward else self.pred
        out: List[List[str]] = []
        frontier = [[start]]
        seen = {start}
        for _ in range(depth):
            nxt = []
            for path in frontier:
                for n in step(path[-1]):
                    p = path + [n]
                    out.append(p)
                    if n not in seen:
                        seen.add(n)
                        nxt.append(p)
            if not nxt:
                break
            frontier = nxt
        return out

    def path(self, src: str, dst: str, depth: int = 12) -> Optional[List[str]]:
        """Shortest driver->sink path, or None if the signal never gets there."""
        if src == dst:
            return [src]
        prev: Dict[str, str] = {src: ""}
        frontier = [src]
        for _ in range(depth):
            nxt = []
            for n in frontier:
                for m in self.succ(n):
                    if m in prev:
                        continue
                    prev[m] = n
                    if m == dst:
                        path = [m]
                        while prev[path[-1]]:
                            path.append(prev[path[-1]])
                        return path[::-1]
                    nxt.append(m)
            if not nxt:
                return None
            frontier = nxt
        return None

    # -------------------------------------------------------------- health
    def problems(self) -> Dict[str, List[NetNode]]:
        """Nets that cannot be right, split by why.

        A net holding a ROM or RAM port is excluded from `undriven`: those
        components are in geometry.UNMODELLED, so their outputs are not in the
        port tables and the net only *looks* undriven.
        """
        undriven, multi = [], []
        for nn in self.nets:
            if any(self.nodes[p].kind in geo.UNMODELLED for p in nn.ports):
                continue
            if not nn.effective_drivers and len(nn.ports) > 1:
                undriven.append(nn)
            elif len(nn.drivers) > 1:
                multi.append(nn)
        singleton = [nn for nn in self.nets if len(nn.ports) == 1]
        return {"undriven": undriven, "multi_driver": multi, "dangling": singleton}

    def dead(self) -> List[str]:
        """Components whose every output goes nowhere.

        This is how you find logic left behind by a fix -- the comparators that
        used to gate PUSH, for instance, still sit in the file driving nothing.
        """
        out = []
        for comp in {n.comp for n in self.nodes.values()}:
            outs = [n for n in self.ports_of(comp) if n.direction == "out"]
            if outs and all(not self.succ(n.id) for n in outs):
                out.append(comp)
        return sorted(out)

    # ---------------------------------------------------------- serialising
    def to_dict(self) -> dict:
        return {
            "file": self.design.path,
            "circuit": self.circuit_name,
            "nodes": [dict(id=n.id, comp=n.comp, kind=n.kind, port=n.port,
                           loc=list(n.loc), pin=list(n.pin),
                           direction=n.direction, label=n.label,
                           bus_bit=n.bus_bit, bus_bits=list(n.bus_bits))
                      for n in sorted(self.nodes.values(), key=lambda n: n.id)],
            "nets": [dict(index=nn.index, name=nn.name, status=nn.status,
                          ports=sorted(nn.ports), drivers=sorted(nn.drivers),
                          labels=nn.labels)
                     for nn in self.nets],
            "edges": [dict(src=e.src, dst=e.dst, net=e.net)
                      for e in sorted(self.edges, key=lambda e: (e.src, e.dst))],
        }

    def save(self, path: str) -> None:
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(self.to_dict(), fh, indent=1)

    def to_dot(self, only: Optional[Iterable[str]] = None) -> str:
        """Graphviz, at component granularity -- port granularity on `main`
        produces a picture nobody can read."""
        keep = set(only) if only else None
        seen: Set[Tuple[str, str]] = set()
        lines = ["digraph %s {" % self.circuit_name.replace("-", "_"),
                 '  rankdir=LR; node [shape=box, fontsize=9];']
        for e in self.edges:
            a, b = self.nodes[e.src].comp, self.nodes[e.dst].comp
            if a == b or (keep and (a not in keep or b not in keep)):
                continue
            if (a, b) in seen:
                continue
            seen.add((a, b))
            lab = "" if e.net == THROUGH else self.nets[e.net].name
            lines.append('  "%s" -> "%s" [label="%s", fontsize=7];'
                         % (a, b, "" if lab.startswith("net#") else lab))
        lines.append("}")
        return "\n".join(lines)


# ------------------------------------------------------------------- diff

@dataclass
class Diff:
    """What the second graph has that the first does not, and vice versa."""
    circuit: str
    only_a_nodes: List[str] = field(default_factory=list)
    only_b_nodes: List[str] = field(default_factory=list)
    only_a_edges: List[Tuple[str, str]] = field(default_factory=list)
    only_b_edges: List[Tuple[str, str]] = field(default_factory=list)

    def summary(self) -> str:
        return ("%s: +%d nodes / -%d nodes, +%d connections / -%d connections"
                % (self.circuit, len(self.only_b_nodes), len(self.only_a_nodes),
                   len(self.only_b_edges), len(self.only_a_edges)))


def diff(a: Graph, b: Graph) -> Diff:
    """Connections present in `b` but missing from `a`, and the reverse.

    Comparison is by node id, which embeds the component's coordinates -- so
    this only means anything between two files whose shared parts sit at the
    same places.  For armv4t vs debug_armv4t that holds; a component that was
    MOVED will show up as one removal plus one addition rather than as a match.
    """
    ea = {(e.src, e.dst) for e in a.edges}
    eb = {(e.src, e.dst) for e in b.edges}
    return Diff(circuit=a.circuit_name,
                only_a_nodes=sorted(set(a.nodes) - set(b.nodes)),
                only_b_nodes=sorted(set(b.nodes) - set(a.nodes)),
                only_a_edges=sorted(ea - eb),
                only_b_edges=sorted(eb - ea))


def wiring_steps(a: Graph, b: Graph) -> List[str]:
    """Human wiring instructions to bring `a` up to `b`.

    Emitted as `source_node --wire--> sink_node`, with the physical pin
    coordinates of each end, grouped by the net they belong to in `b`.  Each
    group is one net, so the user wires one signal at a time instead of
    hopping around the canvas.
    """
    d = diff(a, b)
    by_net: Dict[int, List[Tuple[str, str]]] = {}
    for src, dst in d.only_b_edges:
        by_net.setdefault(b._net_of[src], []).append((src, dst))

    out: List[str] = []
    for ni in sorted(by_net):
        if ni == THROUGH:            # internal splitter hops are not wires
            continue
        nn = b.nets[ni]
        out.append("--- %s  (%d new connection%s)"
                   % (nn.name, len(by_net[ni]), "" if len(by_net[ni]) == 1 else "s"))
        for src, dst in sorted(by_net[ni]):
            s, t = b.nodes[src], b.nodes[dst]
            missing = " [NEW PART]" if src not in a else ""
            missing += " [NEW PART]" if dst not in a else ""
            out.append("    %-44s @%-14s --wire--> %-44s @%s%s"
                       % (src, "%d,%d" % s.pin, dst, "%d,%d" % t.pin, missing))
    return out


# ------------------------------------------------------------- convenience

def build(path: str, circuit: str = "main") -> Graph:
    return Graph(load(path), circuit)


def build_all(path: str) -> Dict[str, Graph]:
    d = load(path)
    return {name: Graph(d, name) for name in d.circuits}
