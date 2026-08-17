#!/usr/bin/env python3
"""Netlist graph reader for armv4t.circ (Logisim Evolution XML).

Resolves wire connectivity per circuit into nets (union-find over exact
coordinate coincidence, which is how Logisim actually connects wires/pins),
and associates non-Pin/Probe components with the nets touching their
footprint so components without known exact pin offsets are still queryable.

Usage:
  python3 tools/circuit_graph.py nets <circuit_name>            # list all nets
  python3 tools/circuit_graph.py near <circuit_name> <x> <y> [r]  # what's near a point
  python3 tools/circuit_graph.py touch <circuit_name> <label_or_loc>  # nets touching a component
  python3 tools/circuit_graph.py same <circuit_name> <x1,y1> <x2,y2>  # are two points connected?
"""
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

CIRC = Path(__file__).resolve().parent.parent / "armv4t.circ"


class UF:
    def __init__(self):
        self.parent = {}

    def find(self, x):
        self.parent.setdefault(x, x)
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]
            x = self.parent[x]
        return x

    def union(self, a, b):
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.parent[ra] = rb


def parse_pt(s):
    return tuple(map(int, re.findall(r"-?\d+", s)))


def load_circuit(name):
    root = ET.parse(CIRC).getroot()
    circ = next(c for c in root.findall("circuit") if c.get("name") == name)
    comps = []
    for c in circ.findall("comp"):
        a = {x.get("name"): x.get("val") for x in c.findall("a")}
        comps.append({"loc": parse_pt(c.get("loc")), "lib": c.get("lib"),
                      "name": c.get("name"), "attrs": a})
    wires = [(parse_pt(w.get("from")), parse_pt(w.get("to"))) for w in circ.findall("wire")]
    return comps, wires


def build_nets(wires):
    uf = UF()
    for a, b in wires:
        uf.union(a, b)
    nets = {}
    for a, b in wires:
        r = uf.find(a)
        nets.setdefault(r, set()).update([a, b])
    return uf, nets


def bbox_touches(comp, pt, pad=60):
    cx, cy = comp["loc"]
    px, py = pt
    # generous default footprint; subcircuit instances / registers are wider,
    # so this is intentionally loose (a "does this wire endpoint plausibly
    # belong to this component" filter, not exact pin geometry)
    w = pad if comp["name"] not in ("Register", "RAM") else pad * 4
    return abs(px - cx) <= w and abs(py - cy) <= w


def cmd_nets(circuit):
    comps, wires = load_circuit(circuit)
    uf, nets = build_nets(wires)
    print(f"{circuit}: {len(comps)} comps, {len(wires)} wire segments, {len(nets)} nets")
    for root, pts in sorted(nets.items(), key=lambda kv: -len(kv[1]))[:20]:
        print(f"  net@{root} size={len(pts)}")


def cmd_near(circuit, x, y, r=80):
    x, y, r = int(x), int(y), int(r)
    comps, wires = load_circuit(circuit)
    print(f"components within {r}px of ({x},{y}):")
    for c in comps:
        cx, cy = c["loc"]
        if abs(cx - x) <= r and abs(cy - y) <= r:
            lbl = c["attrs"].get("label", "")
            print(f"  {c['loc']} {c['name']} label={lbl!r} attrs={c['attrs']}")
    print(f"wires with an endpoint within {r}px of ({x},{y}):")
    for a, b in wires:
        for p in (a, b):
            if abs(p[0] - x) <= r and abs(p[1] - y) <= r:
                print(f"  {a} -> {b}")
                break


def cmd_touch(circuit, label_or_loc):
    comps, wires = load_circuit(circuit)
    uf, nets = build_nets(wires)
    target = None
    if "," in label_or_loc:
        loc = parse_pt(label_or_loc)
        target = min(comps, key=lambda c: (c["loc"][0]-loc[0])**2 + (c["loc"][1]-loc[1])**2)
    else:
        for c in comps:
            if c["attrs"].get("label") == label_or_loc:
                target = c
                break
    if not target:
        print("component not found")
        return
    print("target:", target["loc"], target["name"], target["attrs"])
    touched = set()
    for a, b in wires:
        if bbox_touches(target, a) or bbox_touches(target, b):
            touched.add(uf.find(a))
            touched.add(uf.find(b))
    if not touched:
        print("  -> NO wires found near this component's footprint (likely unconnected)")
        return
    for root in touched:
        pts = nets.get(root, {root})
        print(f"  net@{root}: {sorted(pts)}")
        # which other components sit on this net
        for c in comps:
            if c["loc"] in pts or any(bbox_touches(c, p) for p in pts):
                if c is not target:
                    print(f"      touches: {c['loc']} {c['name']} label={c['attrs'].get('label','')!r}")


def cmd_same(circuit, p1, p2):
    comps, wires = load_circuit(circuit)
    uf, nets = build_nets(wires)
    a, b = parse_pt(p1), parse_pt(p2)
    print("connected" if uf.find(a) == uf.find(b) else "NOT connected")


if __name__ == "__main__":
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        sys.exit(1)
    cmd, rest = args[0], args[1:]
    {"nets": cmd_nets, "near": cmd_near, "touch": cmd_touch, "same": cmd_same}[cmd](*rest)
