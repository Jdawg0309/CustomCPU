#!/usr/bin/env python3
"""Structural report on one hand-wired stage. The "is it good?" check, automated.

    python3 tests/check_stage.py armv4t_2.circ stage_ID
    python3 tests/check_stage.py armv4t_2.circ stage_ID --expect specs/stage_ID.json

Read-only. It never writes the circuit -- it is safe to point at armv4t_2.circ.

What it reports, in the order that matters when a stage is freshly wired:

  floating inputs     an input port on no net at all. Almost always the wire
                      that stops 10 units short: it looks connected at normal
                      zoom and is not.
  undriven nets       a net with sinks and no driver. The other half of the
                      same mistake, seen from the net's side.
  multiple drivers    two outputs on one net. Logisim shows this as an error
                      value only when the two disagree, so it can hide for a
                      long time behind agreeing constants.
  dead components     nothing reaches them and nothing leaves. Usually a part
                      pasted in and forgotten.
  endpoint coverage   fraction of wire endpoints landing on a known pin.
                      Below 100% means wires ending in space.

With --expect, also diffs the actual connections against a spec file, so a
stage can be checked against what it was supposed to be rather than only
against internal consistency.
"""
import argparse, json, os, sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from logisim import graph as G


def netname(net):
    if net is None:
        return None
    labs = [l for l in (net.labels or []) if l]
    return labs[0] if labs else "net#%d" % net.index


def tag(node):
    return "%s@%d,%d.%s" % (node.kind, node.loc[0], node.loc[1], node.port)


def report(path, circuit, expect_path=None):
    g = G.build(path, circuit)
    problems = 0

    print("== %s :: %s ==" % (os.path.basename(path), circuit))
    kinds = {}
    for c in g.circ.components:
        kinds[c.name] = kinds.get(c.name, 0) + 1
    print("%d components, %d wires, %d nets"
          % (len(g.circ.components), len(g.circ.wires), len(g.nets)))
    print("   " + ", ".join("%s x%d" % (k, v) for k, v in sorted(kinds.items())))
    print()

    # --- ports on no net at all -------------------------------------------
    floating = [n for n in g.nodes.values()
                if n.direction == "in" and g.net_of(n.id) is None]
    if floating:
        problems += len(floating)
        print("FLOATING INPUTS (%d)" % len(floating))
        for n in sorted(floating, key=lambda n: (n.kind, n.loc)):
            print("   %s" % tag(n))
        print()

    # --- nets with sinks and no source ------------------------------------
    undriven, multi = [], []
    for net in g.nets:
        drivers = [g.nodes[p] for p in net.ports
                   if g.nodes[p].direction == "out" and g.nodes[p].kind != "Probe"]
        sinks = [g.nodes[p] for p in net.ports
                 if g.nodes[p].direction == "in" and g.nodes[p].kind != "Probe"]
        eff = getattr(net, "effective_drivers", None)
        eff = eff if eff is not None else drivers
        if sinks and not eff:
            undriven.append((net, sinks))
        if len(drivers) > 1:
            multi.append((net, drivers))

    if undriven:
        problems += len(undriven)
        print("UNDRIVEN NETS (%d)" % len(undriven))
        for net, sinks in undriven:
            print("   %-22s feeds %s"
                  % (netname(net), ", ".join(tag(s) for s in sinks[:4])))
        print()

    if multi:
        problems += len(multi)
        print("MULTIPLE DRIVERS (%d)" % len(multi))
        for net, drivers in multi:
            print("   %-22s driven by %s"
                  % (netname(net), ", ".join(tag(d) for d in drivers)))
        print()

    # --- parts nothing reaches --------------------------------------------
    dead = []
    for c in g.circ.components:
        if c.name in ("Pin", "Probe", "Constant", "Clock", "Text"):
            continue
        pids = [n.id for n in g.nodes.values() if n.comp == G.comp_id(c)]
        if pids and all(g.net_of(p) is None for p in pids):
            dead.append(c)
    if dead:
        problems += len(dead)
        print("DEAD COMPONENTS (%d)" % len(dead))
        for c in dead:
            print("   %s@%d,%d" % (c.name, c.loc[0], c.loc[1]))
        print()

    # --- wire endpoints landing on nothing --------------------------------
    try:
        from logisim import netlist as nl
        cov = nl.coverage(g.design, g.circ)
        hit, total = cov.get("hit", 0), cov.get("total", 0)
        if total:
            pct = 100.0 * hit / total
            flag = "" if hit == total else "   <-- wires ending in space"
            print("endpoint coverage: %d/%d (%.1f%%)%s" % (hit, total, pct, flag))
            if hit != total:
                problems += 1
    except Exception as e:
        print("endpoint coverage: unavailable (%s)" % e)

    # --- diff against a spec ----------------------------------------------
    if expect_path:
        print()
        problems += diff_spec(g, expect_path)

    print()
    print("RESULT: %s" % ("clean" if not problems else "%d issue(s)" % problems))
    return 1 if problems else 0


def diff_spec(g, expect_path):
    """Compare actual connectivity against specs/<stage>.json.

    Spec format -- a list of nets, each naming the endpoints that must share it:

        {"ports": {"instruction": {"dir": "in", "width": 32}, ...},
         "nets":  [{"name": "rm", "endpoints": ["Splitter@6600,8680.bit0",
                                                "Multiplexer@8020,8730.in0"]}]}

    Endpoint syntax is exactly what this tool prints, so a report can be edited
    into a spec.
    """
    spec = json.load(open(expect_path))
    problems = 0

    actual = {}                              # endpoint tag -> net index
    for n in g.nodes.values():
        net = g.net_of(n.id)
        if net is not None:
            actual[tag(n)] = net.index

    print("== against %s ==" % os.path.basename(expect_path))

    for want in spec.get("nets", []):
        eps = want["endpoints"]
        missing = [e for e in eps if e not in actual]
        if missing:
            problems += len(missing)
            print("   %-20s NOT CONNECTED: %s" % (want["name"], ", ".join(missing)))
            continue
        idx = {actual[e] for e in eps}
        if len(idx) > 1:
            problems += 1
            groups = {}
            for e in eps:
                groups.setdefault(actual[e], []).append(e)
            print("   %-20s SPLIT into %d nets:" % (want["name"], len(idx)))
            for k, v in groups.items():
                print("        net#%-5s %s" % (k, ", ".join(v)))

    pins = {}
    for c in g.circ.components:
        if c.name == "Pin":
            pins[c.attrs.get("label", "")] = (
                "out" if c.attrs.get("output") == "true" else "in",
                int(c.attrs.get("width", 1)))
    for name, want in (spec.get("ports") or {}).items():
        got = pins.get(name)
        if got is None:
            problems += 1
            print("   port %-16s MISSING" % name)
        elif got != (want["dir"], want["width"]):
            problems += 1
            print("   port %-16s is %s/%d, spec says %s/%d"
                  % (name, got[0], got[1], want["dir"], want["width"]))
    extra = set(pins) - set(spec.get("ports") or {})
    if extra:
        print("   extra ports (not in spec): %s" % ", ".join(sorted(extra)))

    if not problems:
        print("   every specified net and port matches")
    return problems


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("circ")
    ap.add_argument("circuit")
    ap.add_argument("--expect", default=None)
    a = ap.parse_args()
    return report(a.circ, a.circuit, a.expect)


if __name__ == "__main__":
    sys.exit(main())
