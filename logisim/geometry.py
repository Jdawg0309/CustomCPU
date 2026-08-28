"""Where each component's pins physically sit.

Logisim stores only a component's anchor (`loc`) and its attributes; the pin
positions are implied by the component type, its size/width attributes and its
facing.  This module reconstructs them.

Everything is defined in the EAST-facing frame as an offset from `loc`, then
rotated.  Rotation was confirmed against the design itself: a `kogge_stone_1b`
port at east-frame (0,20) appears at (-20,0) on every south-facing instance,
which is exactly (dx,dy) -> (-dy,dx).

Coverage is deliberately observable rather than assumed -- `logisim validate`
reports every wire endpoint that lands on no known pin, so gaps show up as a
number instead of as silently wrong netlists.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

from .model import Circuit, Component, Design, Point

Kind = str  # "in" | "out" | "inout"


@dataclass(frozen=True)
class Port:
    name: str
    dx: int
    dy: int
    kind: Kind = "inout"

    def at(self, comp: Component) -> Point:
        dx, dy = rotate(self.dx, self.dy, comp.facing)
        return comp.loc[0] + dx, comp.loc[1] + dy


def rotate(dx: int, dy: int, facing: str) -> Tuple[int, int]:
    if facing == "east" or not facing:
        return dx, dy
    if facing == "south":
        return -dy, dx
    if facing == "west":
        return -dx, -dy
    if facing == "north":
        return dy, -dx
    return dx, dy


# --- gates ------------------------------------------------------------------
# Default gate size in this design is 50: 2-input gates sit at (-50, +-20).
# A size=30 gate sits at (-30, +-10), so the input spread is (size/2 - 5) and
# XOR/XNOR bodies are drawn 10 units deeper than the AND/OR family.
_GATES = {"AND Gate", "OR Gate", "NAND Gate", "NOR Gate", "XOR Gate", "XNOR Gate"}
_EXTRA_DEPTH = {"XOR Gate": 10, "XNOR Gate": 20}   # drawn deeper than AND/OR


def _gate_ports(c: Component) -> List[Port]:
    size = int(c.attrs.get("size", 50))
    n = int(c.attrs.get("inputs", 2))
    depth = size + _EXTRA_DEPTH.get(c.name, 0)
    spread = size // 2 - 5
    if n == 1:
        ys = [0]
    elif n == 2:
        ys = [-spread, spread]
    elif n == 3:
        ys = [-spread, 0, spread]
    else:
        # a wide gate grows instead of squeezing: pins every 10 units,
        # centred on the axis and skipping it when the count is even
        half = n // 2
        ys = ([-10 * k for k in range(half, 0, -1)] + [10 * k for k in range(1, half + 1)]
              if n % 2 == 0 else [10 * k for k in range(-half, half + 1)])
    ports = [Port("in%d" % i, -depth, y, "in") for i, y in enumerate(ys)]
    ports.append(Port("out", 0, 0, "out"))
    return ports


def _not_ports(c: Component) -> List[Port]:
    size = int(c.attrs.get("size", 30))
    return [Port("in", -size, 0, "in"), Port("out", 0, 0, "out")]


# --- plexers ----------------------------------------------------------------
def _mux_ports(c: Component) -> List[Port]:
    sel = int(c.attrs.get("select", 1))
    n = 1 << sel
    if n == 2:
        return [Port("in0", -30, -10, "in"), Port("in1", -30, 10, "in"),
                Port("sel", -20, 20, "in"), Port("out", 0, 0, "out")]
    depth = 40 if n <= 4 else 40
    top = -(n // 2) * 10
    ports = [Port("in%d" % i, -depth, top + i * 10, "in") for i in range(n)]
    ports.append(Port("sel", -depth // 2, (n // 2) * 10, "in"))
    ports.append(Port("out", 0, 0, "out"))
    return ports


def _decoder_ports(c: Component) -> List[Port]:
    """Anchor is the bottom-left: select at loc, outputs climbing the east edge.
    Verified against the select=4 decoders in reg16x32 -- all 16 outputs land
    on (20, -10*(i+1))."""
    n = 1 << int(c.attrs.get("select", 1))
    ports = [Port("sel", 0, 0, "in"), Port("en", -10, 0, "in")]
    # Index 0 is the TOP output, not the bottom.  The positions were fitted
    # against real wire endpoints, which proves the SET of points and says
    # nothing about their order -- and a reversed order is invisible to every
    # coverage measurement.  Caught by writing 0xA0+n to register n through
    # reg16x32_1 and reading back register 15-n.
    ports += [Port("out%d" % i, 20, -10 * (n - i), "out") for i in range(n)]
    return ports


# --- arithmetic -------------------------------------------------------------
def _adder_ports(c: Component) -> List[Port]:
    return [Port("a", -40, -10, "in"), Port("b", -40, 10, "in"),
            Port("cin", -20, -20, "in"), Port("cout", -20, 20, "out"),
            Port("out", 0, 0, "out")]


def _multiplier_ports(c: Component) -> List[Port]:
    """Arithmetic-library multiplier, matching Logisim Evolution's symbol."""
    return [Port("a", -40, -10, "in"), Port("b", -40, 10, "in"),
            Port("cin", -20, -20, "in"), Port("cout", -20, 20, "out"),
            Port("out", 0, 0, "out")]


def _comparator_ports(c: Component) -> List[Port]:
    return [Port("a", -40, -10, "in"), Port("b", -40, 10, "in"),
            Port("gt", 0, -10, "out"), Port("eq", 0, 0, "out"), Port("lt", 0, 10, "out")]


def _shifter_ports(c: Component) -> List[Port]:
    return [Port("in", -40, -10, "in"), Port("dist", -40, 10, "in"), Port("out", 0, 0, "out")]


# --- memory -----------------------------------------------------------------
def _register_ports(c: Component) -> List[Port]:
    return [Port("D", 0, 30, "in"), Port("en", 0, 50, "in"), Port("clk", 0, 70, "in"),
            Port("clr", 30, 90, "in"), Port("Q", 60, 30, "out")]


# ROM/RAM evolution-appearance geometry comes from RamAppearance.java.  The
# symbol width is fixed at 200 and the separated-bus data output is 40 pixels
# beyond it.  The current design uses one data line, separated input/output
# buses, and byte-enable style controls, so its control block is 60 pixels for
# ROM and 90 pixels for synchronous RAM.
def _rom_ports(c: Component) -> List[Port]:
    return [Port("addr", 0, 10, "in"), Port("data_out", 240, 60, "out")]


def _ram_ports(c: Component) -> List[Port]:
    return [Port("addr", 0, 10, "in"), Port("we", 0, 50, "in"),
            Port("oe", 0, 60, "in"), Port("clk", 0, 70, "in"),
            Port("data_in", 0, 90, "in"), Port("data_out", 240, 90, "out")]


# --- trivial ----------------------------------------------------------------
def _single(kind: Kind = "inout"):
    return lambda c: [Port("p", 0, 0, kind)]


def _clock_ports(c: Component) -> List[Port]:
    return [Port("out", 0, 0, "out")]


# --- splitter ---------------------------------------------------------------
def _splitter_ports(c: Component) -> List[Port]:
    """Combined end at loc; fan ends one step along the facing direction,
    spread along the other axis starting 10 out, `spacing`*10 apart."""
    fanout = int(c.attrs.get("fanout", 2))
    spacing = int(c.attrs.get("spacing", 1))
    appear = c.attrs.get("appear", "left")
    d = {"east": (1, 0), "west": (-1, 0),
         "south": (0, 1), "north": (0, -1)}.get(c.facing, (1, 0))
    # "left"/"right" are relative to the direction of travel, not to the screen:
    # right of d is (-dy, dx), left is (dy, -dx).  Fitting both against real
    # wire endpoints picks these unambiguously for every facing in this design.
    if appear == "right":
        perp = (-d[1], d[0])
    else:
        perp = (d[1], -d[0])
    # `appear` picks which SIDE the fans sit on.  It does not set the index
    # order -- that is a fixed screen convention, and getting it from `appear`
    # is wrong for half the facings.  Measured against live Logisim for all
    # eight facing/appear combinations by feeding a known 4-bit value through a
    # splitter with an identity bit map and reading which fan carried bit 3:
    #
    #     facing east/west   -> fan 0 is the TOPMOST fan, indices run down (+y)
    #     facing north/south -> fan 0 is the RIGHTMOST fan, indices run left (-x)
    #
    # Only fan 0 or the last fan can tell two orderings apart, so a spot check
    # on a middle fan proves nothing -- an earlier version of this function
    # passed exactly such a check while being backwards for west and north.
    slots = [(d[0] * 20 + perp[0] * (10 + 10 * spacing * k),
              d[1] * 20 + perp[1] * (10 + 10 * spacing * k))
             for k in range(fanout)]
    if d[1] == 0:                       # east / west: top to bottom
        slots.sort(key=lambda o: o[1])
    else:                               # north / south: right to left
        slots.sort(key=lambda o: -o[0])
    ports = [Port("combined", 0, 0, "inout")]
    for i, (dx, dy) in enumerate(slots):
        ports.append(Port("bit%d" % i, dx, dy, "inout"))
    return ports


def _splitter_points(c: Component) -> List[Point]:
    """Splitters carry their own rotation, so bypass the generic rotate()."""
    return [(c.loc[0] + p.dx, c.loc[1] + p.dy) for p in _splitter_ports(c)]


BUILTIN = {
    "Pin": _single(), "Probe": _single("in"), "Constant": _single("out"),
    "Tunnel": _single(), "Clock": _clock_ports,
    "Bit Extender": lambda c: [Port("in", -40, 0, "in"), Port("out", 0, 0, "out")],
    "Power": _single("out"), "Ground": _single("out"),
    "NOT Gate": _not_ports, "Buffer": _not_ports,
    "Multiplexer": _mux_ports, "Demultiplexer": _mux_ports, "Decoder": _decoder_ports,
    "Adder": _adder_ports, "Subtractor": _adder_ports,
    "Multiplier": _multiplier_ports, "Comparator": _comparator_ports,
    "Shifter": _shifter_ports,
    "Register": _register_ports, "ROM": _rom_ports, "RAM": _ram_ports,
    "Splitter": None,
}
for g in _GATES:
    BUILTIN[g] = _gate_ports

# Component types intentionally omitted from the geometry model.  The memory
# appearances used by this project are now fully represented above.
UNMODELLED = set()


def _subcircuit_box_width(design: Design, name: str) -> int:
    """Distance from an instance's anchor to its input column.

    Logisim derives this from the drawn appearance, which is not recorded in
    the file, so it is recovered by finding the offset at which the most
    existing wire endpoints line up with the input pins.  Cached per subcircuit.
    """
    cache = getattr(design, "_boxw", None)
    if cache is None:
        cache = {}
        setattr(design, "_boxw", cache)
    if name in cache:
        return cache[name]
    sub = design.circuits.get(name)
    nin = len(sub.inputs()) if sub else 0
    best, bestn = 220, 0
    if nin:
        for circ in design:
            ends = set()
            for w in circ.wires:
                ends.add(w.a); ends.add(w.b)
            for c in circ.components:
                if c.name != name or c.is_subcircuit is False:
                    continue
                for d in range(10, 601, 10):
                    hit = 0
                    for k in range(nin):
                        dx, dy = rotate(-d, 20 * k, c.facing)
                        if (c.loc[0] + dx, c.loc[1] + dy) in ends:
                            hit += 1
                    if hit > bestn:
                        best, bestn = d, hit
    cache[name] = best
    return best


def subcircuit_ports(design: Design, c: Component) -> List[Port]:
    sub = design.circuits.get(c.name)
    if sub is None:
        return []
    w = _subcircuit_box_width(design, c.name)
    ports: List[Port] = []
    for k, p in enumerate(sub.outputs()):
        ports.append(Port(p.label or "out%d" % k, 0, 20 * k, "out"))
    for k, p in enumerate(sub.inputs()):
        ports.append(Port(p.label or "in%d" % k, -w, 20 * k, "in"))
    return ports


def ports(design: Design, c: Component) -> List[Port]:
    if c.is_subcircuit:
        return subcircuit_ports(design, c)
    fn = BUILTIN.get(c.name)
    if c.name == "Splitter":
        return _splitter_ports(c)
    if fn is None:
        return []
    return fn(c)


def port_points(design: Design, c: Component) -> List[Point]:
    if c.name == "Splitter":
        return _splitter_points(c)
    return [p.at(c) for p in ports(design, c)]


def all_port_points(design: Design, circ: Circuit) -> Dict[Point, List[Tuple[Component, str]]]:
    out: Dict[Point, List[Tuple[Component, str]]] = {}
    for c in circ.components:
        if c.name == "Splitter":
            named = list(zip(_splitter_points(c), [p.name for p in _splitter_ports(c)]))
        else:
            named = [(p.at(c), p.name) for p in ports(design, c)]
        for pt, nm in named:
            out.setdefault(pt, []).append((c, nm))
    return out
