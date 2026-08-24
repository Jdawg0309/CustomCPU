"""Command line: python -m logisim <command> <file.circ> [...]"""
from __future__ import annotations

import argparse
import os
import sys

from .model import load
from . import geometry as geo, netlist as nl, lint as lintmod, render as rendermod


def cmd_ls(a):
    d = load(a.file)
    print("%s  (%d circuits, main=%s)" % (a.file, len(d.circuits), d.main))
    for c in d:
        print("  %-26s %4d comps  %5d wires  %2d in  %2d out"
              % (c.name, len(c.components), len(c.wires), len(c.inputs()), len(c.outputs())))


def cmd_show(a):
    d = load(a.file); c = d[a.circuit]
    print(c)
    print("  inputs :", ", ".join(p.label or "?" for p in c.inputs()) or "-")
    print("  outputs:", ", ".join(p.label or "?" for p in c.outputs()) or "-")
    counts = {}
    for comp in c.components:
        counts[comp.name] = counts.get(comp.name, 0) + 1
    print("  parts  :")
    for k in sorted(counts, key=lambda k: -counts[k]):
        print("      %-24s x%d" % (k, counts[k]))


def cmd_nets(a):
    d = load(a.file); c = d[a.circuit]
    nets = sorted(nl.build(d, c), key=lambda n: -len(n.points))
    print("%d nets in %s" % (len(nets), c.name))
    for n in nets[:a.limit]:
        drv = n.drivers
        who = ", ".join("%s%s.%s" % (x.name, "[%s]" % x.label if x.label else "", p)
                        for x, p in drv[:2]) or "-"
        print("  %5d pts  %2d pins  driver: %s" % (len(n.points), len(n.pins), who))


def cmd_net(a):
    d = load(a.file); c = d[a.circuit]
    pt = tuple(int(v) for v in a.point.replace("(", "").replace(")", "").split(","))
    n = nl.net_at(d, c, pt)
    if n is None:
        print("no net at %s" % (pt,)); return 1
    print("net at %s: %d points, %d pins" % (pt, len(n.points), len(n.pins)))
    for comp, port in sorted(n.pins, key=lambda t: t[0].loc):
        print("   %-22s %-10s @%s %s" % (comp.name, port, comp.loc,
                                         "[%s]" % comp.label if comp.label else ""))


def cmd_validate(a):
    d = load(a.file)
    names = [a.circuit] if a.circuit else list(d.circuits)
    tot_m = tot_e = 0
    for name in names:
        r = lintmod.report(d, d[name])
        m, e = r["coverage"]; tot_m += m; tot_e += e
        issues = r["near_misses"] or r["diagonal_wires"]
        if not issues and not a.verbose:
            continue
        print("== %s == %d comps, %d wires, %d nets, pins explain %d/%d endpoints"
              % (name, r["components"], r["wires"], r["nets"], m, e))
        for x in r["near_misses"][:a.limit]:
            print("   NEAR MISS  wire ends %s, %d away from %s%s.%s at %s"
                  % (x["endpoint"], x["distance"], x["component"],
                     "[%s]" % x["label"] if x["label"] else "", x["port"], x["pin"]))
        for w in r["diagonal_wires"][:5]:
            print("   DIAGONAL   %s -> %s" % w)
    print("\ngeometry explains %d/%d wire endpoints (%.2f%%)"
          % (tot_m, tot_e, 100.0 * tot_m / max(1, tot_e)))


def cmd_render(a):
    d = load(a.file)
    names = [a.circuit] if a.circuit else list(d.circuits)
    os.makedirs(a.out, exist_ok=True)
    for name in names:
        svg = rendermod.svg(d, d[name])
        p = os.path.join(a.out, "%s.svg" % name.replace("/", "_"))
        open(p, "w").write(svg)
        print("  %-26s -> %s  (%d KB)" % (name, p, len(svg) // 1024))


def cmd_viewer(a):
    from .viewer import build
    html = build(load(a.file), title=a.title)
    open(a.output, "w").write(html)
    print("wrote %s (%d KB)" % (a.output, len(html) // 1024))


def main(argv=None):
    ap = argparse.ArgumentParser(prog="logisim", description="Read, check and draw Logisim .circ files")
    sub = ap.add_subparsers(dest="cmd", required=True)

    def add(name, fn, circuit="optional"):
        p = sub.add_parser(name)
        p.add_argument("file")
        if circuit == "required":
            p.add_argument("circuit")
        elif circuit == "optional":
            p.add_argument("circuit", nargs="?")
        p.set_defaults(func=fn)
        return p

    add("ls", cmd_ls, circuit=None)
    add("show", cmd_show, "required")
    p = add("nets", cmd_nets, "required"); p.add_argument("--limit", type=int, default=20)
    p = add("net", cmd_net, "required");   p.add_argument("point")
    p = add("validate", cmd_validate);     p.add_argument("--limit", type=int, default=20); p.add_argument("-v", "--verbose", action="store_true")
    p = add("render", cmd_render);         p.add_argument("--out", default="svg")
    p = add("viewer", cmd_viewer, circuit=None)
    p.add_argument("-o", "--output", default="circuits.html")
    p.add_argument("--title", default=None)

    a = ap.parse_args(argv)
    return a.func(a) or 0


if __name__ == "__main__":
    sys.exit(main())
