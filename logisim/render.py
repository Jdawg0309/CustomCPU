"""Draw a circuit as standalone SVG.

Gates get their real schematic shapes rather than labelled boxes, so the output
reads like a schematic instead of a block diagram.  Every wire and pin carries
a `data-net` attribute, which is what makes net highlighting possible in the
HTML viewer without re-deriving connectivity in JavaScript.
"""
from __future__ import annotations

import html
from typing import Dict, List, Optional, Tuple

from .model import Circuit, Component, Design, Point
from . import geometry as geo
from . import netlist as nl

# Colours go out as CSS custom properties with literal fallbacks: a standalone
# .svg file still renders correctly, and the same markup inlined into a themed
# page follows that page's tokens instead of fighting them.
PALETTE = {
    "bg":     "var(--sch-bg, #fbfbfa)",
    "wire1":  "var(--sch-wire1, #3f7f47)",   # single-bit
    "wireN":  "var(--sch-wiren, #2b3a42)",   # bus
    "body":   "var(--sch-body, #ffffff)",
    "stroke": "var(--sch-stroke, #20303a)",
    "sub":    "var(--sch-sub, #eef4f8)",
    "pin":    "var(--sch-pin, #1d4f66)",
    "label":  "var(--sch-label, #20303a)",
    "dim":    "var(--sch-dim, #8a9aa4)",
}


# One stylesheet beats repeating paint on every element: it cuts a large
# schematic roughly in half, and the colours stay overridable per page.
_STYLE = (
    "<style>"
    ".bg{fill:%(bg)s}"
    ".w{stroke:%(wire1)s;stroke-width:1.6;stroke-linecap:round;fill:none}"
    ".w.b{stroke:%(wireN)s;stroke-width:2.4}"
    ".j{fill:%(wire1)s}"
    ".bd{fill:%(body)s;stroke:%(stroke)s;stroke-width:1.6}"
    ".ln{fill:none;stroke:%(stroke)s;stroke-width:1.6}"
    ".sp{stroke:%(dim)s;stroke-width:1.6}"
    ".sb{fill:%(sub)s;stroke:%(stroke)s;stroke-width:1.6}"
    ".pn{fill:%(body)s;stroke:%(pin)s;stroke-width:1.5}"
    ".pn.o{fill:%(sub)s}"
    ".t{font-size:9px;text-anchor:middle;fill:%(label)s}"
    ".tn{font-size:11px;text-anchor:middle;fill:%(label)s}"
    ".lab{font-size:10px;text-anchor:start;fill:%(label)s}"
    ".lab.e{text-anchor:end}"
    "</style>") % PALETTE


def _esc(s: str) -> str:
    return html.escape(str(s), quote=True)


# --- component shapes -------------------------------------------------------
def _gate_path(kind: str, x: int, y: int, depth: int, half: int) -> str:
    """Classic gate outlines, drawn in the east frame: the body sits left of
    the anchor and the output leaves at (x, y).  `depth` is the body length,
    `half` its half-height.  Inverting gates stop 10 short to leave room for
    the bubble."""
    nose = x - (10 if kind in ("NAND Gate", "NOR Gate", "XNOR Gate") else 0)
    left = x - depth
    top, bot = y - half, y + half
    if kind in ("AND Gate", "NAND Gate"):
        flat = nose - half                      # straight section before the cap
        if flat < left:
            flat = left
        return ("M%d,%d L%d,%d A%d,%d 0 0 1 %d,%d L%d,%d Z"
                % (left, top, flat, top, half, half, flat, bot, left, bot))
    # OR family: convex front, concave back
    ctrl = left + depth * 0.55
    return ("M%d,%d Q%.1f,%d %d,%d Q%.1f,%d %d,%d Q%.1f,%d %d,%d Z"
            % (left, top, ctrl, top, nose, y,
               ctrl, bot, left, bot,
               left + depth * 0.35, y, left, top))


def _bubble(kind: str, x: int, y: int) -> str:
    if kind in ("NAND Gate", "NOR Gate", "XNOR Gate", "NOT Gate"):
        return '<circle class="bd" cx="%d" cy="%d" r="5"/>' % (x - 5, y)
    return ""


def _draw_component(design: Design, c: Component, netid: Dict[Point, int]) -> str:
    x, y = c.loc
    f = c.facing
    rot = {"east": 0, "south": 90, "west": 180, "north": 270}.get(f, 0)
    inner: List[str] = []
    name = c.name
    st = PALETTE["stroke"]

    if name in geo._GATES:
        size = int(c.attrs.get("size", 50))
        depth = size + geo._EXTRA_DEPTH.get(name, 0)
        n = int(c.attrs.get("inputs", 2))
        half = max(size // 2, (n * 10) // 2 + 5)
        inner.append('<path class="bd" d="%s"/>' % _gate_path(name, 0, 0, depth, half))
        if name in ("XOR Gate", "XNOR Gate"):
            inner.append('<path class="ln" d="M%d,%d Q%.1f,%d %d,%d"/>'
                         % (-depth - 8, -half, -depth + depth * 0.35 - 8, 0, -depth - 8, half))
        inner.append(_bubble(name, 0, 0))
    elif name == "NOT Gate":
        size = int(c.attrs.get("size", 30))
        inner.append('<path class="bd" d="M%d,%d L%d,%d L%d,%d Z"/>' % (-size, -12, -10, 0, -size, 12))
        inner.append(_bubble(name, 0, 0))
    elif name in ("Multiplexer", "Demultiplexer"):
        inner.append('<path class="bd" d="M-30,-20 L0,-10 L0,10 L-30,20 Z"/>')
    elif name == "Splitter":
        pts = geo._splitter_ports(c)
        comb = pts[0]
        spine = "".join(
            '<line class="sp" x1="%d" y1="%d" x2="%d" y2="%d"/>'
            % (x + comb.dx, y + comb.dy, x + p.dx, y + p.dy)
            for p in pts[1:])
        return '<g class="comp" data-name="%s">%s</g>' % (_esc(name), spine)
    elif name in ("Pin", "Probe"):
        w = int(c.attrs.get("width", 1))
        is_out = c.attrs.get("output") == "true" or name == "Probe"
        fill = PALETTE["sub"] if is_out else PALETTE["body"]
        cls = "pn" + (" o" if is_out else "")
        if w > 1:
            inner.append('<rect class="%s" x="-8" y="-8" width="16" height="16" rx="2"/>' % cls)
        else:
            inner.append('<circle class="%s" r="7"/>' % cls)
        rot = 0
    elif name == "Constant":
        inner.append('<rect class="bd" x="-16" y="-9" width="16" height="18" rx="2"/>')
        inner.append('<text class="t" x="-8" y="4">%s</text>' % _esc(c.attrs.get("value", "0")))
        rot = 0
    elif c.is_subcircuit:
        w = geo._subcircuit_box_width(design, c.name)
        sub = design.circuits.get(c.name)
        nrows = max(len(sub.inputs()), len(sub.outputs())) if sub else 1
        h = max(20 * nrows, 30)
        inner.append('<rect class="sb" x="%d" y="-10" width="%d" height="%d" rx="3"/>' % (-w, w, h))
        inner.append('<text class="tn" x="%d" y="%d">%s</text>'
                     % (-w // 2, h // 2 - 6, _esc(c.name)))
    else:
        pts = geo.port_points(design, c)
        if pts:
            xs = [p[0] - x for p in pts]; ys = [p[1] - y for p in pts]
            x0, x1 = min(xs) - 4, max(xs) + 4
            y0, y1 = min(ys) - 8, max(ys) + 8
        else:
            x0, x1, y0, y1 = -40, 10, -20, 20
        inner.append('<rect class="bd" x="%d" y="%d" width="%d" height="%d" rx="3"/>'
                     % (x0, y0, x1 - x0, y1 - y0))
        inner.append('<text class="t" x="%d" y="%d">%s</text>'
                     % ((x0 + x1) // 2, (y0 + y1) // 2 + 3, _esc(name[:14])))
        rot = 0

    g = '<g class="comp" data-name="%s" data-label="%s" transform="translate(%d,%d) rotate(%d)">%s</g>' % (
        _esc(name), _esc(c.label), x, y, rot, "".join(inner))
    return g


def _labels(design: Design, c: Component) -> str:
    if not c.label:
        return ""
    x, y = c.loc
    dx = 12 if c.facing != "west" else -12
    anchor = "start" if c.facing != "west" else "end"
    return ('<text class="lab%s" x="%d" y="%d">%s</text>'
            % ("" if anchor == "start" else " e", x + dx, y - 10, _esc(c.label)))


def svg(design: Design, circ: Circuit, width_px: int = 1600,
        show_labels: bool = True, bbox=None) -> str:
    """`bbox` crops the view to (x0, y0, x1, y1) in circuit coordinates;
    the whole circuit is still drawn, so wires leaving the crop read correctly."""
    nets = nl.build(design, circ)
    netid: Dict[Point, int] = {}
    netwidth: Dict[int, int] = {}
    for i, n in enumerate(nets):
        w = 1
        for c, pname in n.pins:
            try:
                w = max(w, int(c.attrs.get("width", 1)))
            except ValueError:
                pass
        netwidth[i] = w
        for p in n.points:
            netid[p] = i

    x0, y0, x1, y1 = bbox if bbox else circ.bbox()
    pad = 20 if bbox else 60
    x0 -= pad; y0 -= pad; x1 += pad; y1 += pad
    w, h = x1 - x0, y1 - y0

    parts: List[str] = []
    parts.append(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="%d %d %d %d" '
        'width="100%%" preserveAspectRatio="xMidYMid meet" '
        'font-family="ui-monospace,SFMono-Regular,Menlo,monospace">' % (x0, y0, w, h))
    parts.append(_STYLE)
    parts.append('<rect class="bg" x="%d" y="%d" width="%d" height="%d"/>' % (x0, y0, w, h))

    for wire in circ.wires:
        nid = netid.get(wire.a, netid.get(wire.b, -1))
        cls = "w b" if netwidth.get(nid, 1) > 1 else "w"
        parts.append('<line class="%s" data-net="%d" x1="%d" y1="%d" x2="%d" y2="%d"/>'
                     % (cls, nid, wire.a[0], wire.a[1], wire.b[0], wire.b[1]))

    for c in circ.components:
        parts.append(_draw_component(design, c, netid))

    # junction dots where three or more wire ends meet
    deg: Dict[Point, int] = {}
    for wire in circ.wires:
        deg[wire.a] = deg.get(wire.a, 0) + 1
        deg[wire.b] = deg.get(wire.b, 0) + 1
    for p, d in deg.items():
        if d >= 3:
            parts.append('<circle class="j" cx="%d" cy="%d" r="3" data-net="%d"/>'
                         % (p[0], p[1], netid.get(p, -1)))

    if show_labels:
        for c in circ.components:
            parts.append(_labels(design, c))

    parts.append("</svg>")
    return "".join(parts)
