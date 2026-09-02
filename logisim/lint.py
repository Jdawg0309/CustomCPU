"""Checks that catch the mistakes this file format makes easy.

The important one is the near miss: a wire that stops 10 units short of a pin
looks connected at normal zoom and is not.  Logisim will not tell you; the
circuit just behaves as if the pin were floating.
"""
from __future__ import annotations

from typing import Dict, List, Tuple

from .model import Circuit, Design, Point
from . import geometry as geo
from . import netlist as nl


def near_misses(design: Design, circ: Circuit, radius: int = 20) -> List[dict]:
    pinpts = geo.all_port_points(design, circ)
    cov = nl.coverage(design, circ)
    out = []
    for pt in cov["unmatched"]:
        best = None
        for q, owners in pinpts.items():
            d = abs(q[0] - pt[0]) + abs(q[1] - pt[1])
            if d and d <= radius and (best is None or d < best[0]):
                best = (d, q, owners)
        if best:
            d, q, owners = best
            comp, port = owners[0]
            out.append({"endpoint": pt, "pin": q, "distance": d,
                        "component": comp.name, "label": comp.label, "port": port})
    return sorted(out, key=lambda r: r["distance"])


def floating_inputs(design: Design, circ: Circuit) -> List[dict]:
    """Input pins on a net with no driver at all."""
    out = []
    for net in nl.build(design, circ):
        if net.drivers:
            continue
        for comp, port in net.pins:
            if comp.name in ("Probe", "Pin"):
                continue
            out.append({"component": comp.name, "label": comp.label,
                        "port": port, "at": comp.loc})
    return out


def multiple_drivers(design: Design, circ: Circuit) -> List[dict]:
    out = []
    for net in nl.build(design, circ):
        drv = net.drivers
        if len(drv) > 1:
            out.append({"drivers": [(c.name, c.label, c.loc, p) for c, p in drv],
                        "points": len(net.points)})
    return out


def diagonal_wires(circ: Circuit) -> List[Tuple[Point, Point]]:
    return [(w.a, w.b) for w in circ.wires if w.diagonal]


def report(design: Design, circ: Circuit) -> dict:
    cov = nl.coverage(design, circ)
    nm = near_misses(design, circ)
    nm_pts = {tuple(r["endpoint"]) for r in nm}
    return {
        "circuit": circ.name,
        "components": len(circ.components),
        "wires": len(circ.wires),
        "nets": len(nl.build(design, circ)),
        "coverage": (cov["matched"], cov["endpoints"]),
        "near_misses": nm,
        "isolated_stubs": [p for p in cov["unmatched"] if tuple(p) not in nm_pts],
        "diagonal_wires": diagonal_wires(circ),
        "unmodelled_types": cov["unmodelled_types"],
    }
