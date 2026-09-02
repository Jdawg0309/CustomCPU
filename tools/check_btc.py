#!/usr/bin/env python3
"""Is block_transfer_control electrically identical to the working version?

The copy in armv4t_2.circ is an older revision: it lacks the `U` and `P` inputs,
so LDM/STM cannot see the up/down and pre/post bits.  The working revision lives
in debug_armv4t.circ.

This compares the two by NET MEMBERSHIP -- for every net, the set of component
ports on it -- so layout, wire routing and probe placement are all irrelevant.
Only the electrical structure is compared.

usage: check_btc.py [candidate.circ] [reference.circ]
"""
import sys
from collections import Counter
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
from logisim import model, geometry, netlist

CIRC = "block_transfer_control"


def nets_of(path):
    d = model.load(path)
    if CIRC not in d.circuits:
        raise SystemExit("%s has no circuit named %s" % (path, CIRC))
    c = d.circuits[CIRC]
    app = geometry.all_port_points(d, c)
    out = []
    for n in netlist.build(d, c):
        mem = set()
        for q in n.points:
            for cc, nm in app.get(q, []):
                if cc.name == "Probe":       # debug clutter, not structure
                    continue
                lb = cc.attrs.get("label", "")
                # A Pin keeps its label (it is the interface); a gate does not,
                # because labels differ between the two revisions.
                key = "Pin[%s]" % lb if cc.name == "Pin" else cc.name
                mem.add("%s.%s" % (key, nm))
        if mem:
            out.append(frozenset(mem))
    return d.circuits[CIRC], out


def main():
    cand = sys.argv[1] if len(sys.argv) > 1 else "armv4t_2.circ"
    ref = sys.argv[2] if len(sys.argv) > 2 else "debug_armv4t.circ"
    cc, cn = nets_of(cand)
    rc, rn = nets_of(ref)

    print("candidate : %s" % cand)
    print("reference : %s\n" % ref)

    ok = True
    warn = []

    def pinset(circ, out):
        return {(p.label, int(p.attrs.get("width", 1)))
                for p in (circ.outputs() if out else circ.inputs())}

    for out, what in ((False, "input"), (True, "output")):
        cs, rs = pinset(cc, out), pinset(rc, out)
        if cs != rs:
            ok = False
            print("%s PINS differ" % what.upper())
            for m in sorted(rs - cs):
                print("   MISSING  %s pin `%s` (%d bits)" % (what, m[0], m[1]))
            for m in sorted(cs - rs):
                print("   EXTRA    %s pin `%s` (%d bits)" % (what, m[0], m[1]))
            print()
        else:
            cl = [p.label for p in (cc.outputs() if out else cc.inputs())]
            rl = [p.label for p in (rc.outputs() if out else rc.inputs())]
            if cl != rl:
                # Not an electrical difference.  Instance ports bind by
                # POSITION, so this only matters once something instantiates
                # this circuit -- and then only for wires already drawn.
                warn.append("%s pin ORDER differs (same pins, same widths):\n"
                            "     yours    : %s\n     reference: %s" % (what, cl, rl))

    pc = Counter(x.name for x in cc.components if x.name != "Probe")
    pr = Counter(x.name for x in rc.components if x.name != "Probe")
    if pc != pr:
        ok = False
        print("PART COUNTS differ (probes ignored)")
        for k in sorted(set(pc) | set(pr)):
            if pc[k] != pr[k]:
                print("   %-14s candidate %d, reference %d" % (k, pc[k], pr[k]))
        print()

    sc, sr = Counter(cn), Counter(rn)
    extra = sc - sr
    missing = sr - sc
    print("nets: %d identical, %d only in the candidate, %d only in the reference"
          % (sum((sc & sr).values()), sum(extra.values()), sum(missing.values())))
    if extra or missing:
        ok = False
        if extra:
            print("\nNETS TO REMOVE OR REWIRE (present in your version, not the reference):")
            for n in sorted(extra, key=lambda s: sorted(s)[0]):
                print("   {%s}" % ", ".join(sorted(n)))
        if missing:
            print("\nNETS TO BUILD (present in the reference, not yours):")
            for n in sorted(missing, key=lambda s: sorted(s)[0]):
                print("   {%s}" % ", ".join(sorted(n)))

    if warn:
        insts = [(x.name, circ.name) for circ in model.load(cand)
                 for x in circ.components
                 if x.is_subcircuit and x.name == CIRC]
        print()
        for w in warn:
            print("WARN  %s" % w)
        print("      Nothing electrical depends on this.  Instance ports bind by\n"
              "      position, so it would only matter for wires already drawn to\n"
              "      an existing instance -- and there %s."
              % ("are %d" % len(insts) if insts else "are none"))

    print("\nRESULT: %s" % ("PASS -- electrically identical" if ok else "differs"))
    return 0 if ok else 1


sys.exit(main())
