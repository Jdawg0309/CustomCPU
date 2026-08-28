"""Command line: python -m logisim <command> <file.circ> [...]"""
from __future__ import annotations

import argparse
import os
import sys

from .model import load
from . import (geometry as geo, netlist as nl, lint as lintmod,
               render as rendermod, graph as graphmod)


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


def cmd_graph(a):
    """The circuit as a graph: ports, nets, and driver->sink edges."""
    g = graphmod.build(a.file, a.circuit)
    if a.json:
        g.save(a.json); print("wrote %s" % a.json)
    if a.dot:
        with open(a.dot, "w") as fh:
            fh.write(g.to_dot())
        print("wrote %s" % a.dot)
    if a.node:
        hits = g.find(a.node)
        if not hits:
            print("no node matching %r" % a.node); return 1
        for n in hits[:a.limit]:
            print("%s  [%s] @%s" % (n.id, n.direction, "%d,%d" % n.pin))
            if n.bus_bit is not None:
                print("    carries bus bit %d" % n.bus_bit)
            for src in g.pred(n.id):
                print("    <- %s" % src)
            for dst in g.succ(n.id):
                print("    -> %s" % dst)
        return 0
    if a.trace:
        for path in g.trace(a.trace, depth=a.depth)[:a.limit]:
            print("  " + " -> ".join(path))
        return 0
    print("%s: %d ports, %d nets, %d connections"
          % (g.circuit_name, len(g.nodes), len(g.nets), len(g.edges)))
    pr = g.problems()
    for kind in ("undriven", "multi_driver"):
        for nn in pr[kind][:a.limit]:
            print("  %-13s %s: %s" % (kind.upper(), nn.name,
                                      ", ".join(sorted(nn.ports)[:4])))
    dangling = [nn for nn in pr["dangling"]
                if g.nodes[nn.ports[0]].kind not in ("Pin", "Constant", "Probe")]
    for nn in dangling[:a.limit]:
        print("  DANGLING      %s" % nn.ports[0])
    dead = g.dead()
    for c in dead[:a.limit]:
        print("  DEAD          %s drives nothing" % c)
    if not pr["undriven"] and not pr["multi_driver"] and not dangling and not dead:
        print("  no undriven nets, no shorts, nothing dangling, nothing dead")
    return 0


def cmd_diff(a):
    """Connections one file has that the other does not."""
    ga = graphmod.build(a.file, a.circuit)
    gb = graphmod.build(a.other, a.circuit)
    d = graphmod.diff(ga, gb)
    print("%s  vs  %s" % (a.file, a.other))
    print("  " + d.summary())
    if a.wiring:
        print()
        for line in graphmod.wiring_steps(ga, gb):
            print(line)
    else:
        for src, dst in d.only_b_edges[:a.limit]:
            print("  ONLY IN %s: %s -> %s" % (a.other, src, dst))
        for src, dst in d.only_a_edges[:a.limit]:
            print("  ONLY IN %s: %s -> %s" % (a.file, src, dst))
    return 0


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
    p = add("graph", cmd_graph, "required")
    p.add_argument("--json"); p.add_argument("--dot")
    p.add_argument("--node", help="show one node's neighbours (substring match)")
    p.add_argument("--trace", help="every path out of this node id")
    p.add_argument("--depth", type=int, default=4)
    p.add_argument("--limit", type=int, default=20)
    # positionals land in declaration order, so `other` is declared before
    # `circuit` to give the natural `diff <a.circ> <b.circ> <circuit>`
    p = add("diff", cmd_diff, circuit=None)
    p.add_argument("other", help="the .circ to compare against")
    p.add_argument("circuit")
    p.add_argument("--wiring", action="store_true",
                   help="emit source -> sink wiring steps grouped by net")
    p.add_argument("--limit", type=int, default=40)
    p.add_argument("-o", "--output", default="circuits.html")
    p.add_argument("--title", default=None)

    a = ap.parse_args(argv)
    return a.func(a) or 0


if __name__ == "__main__":
    sys.exit(main())
