#!/usr/bin/env python3
"""Is the harness actually testing the circuit in the file?

This exists because it once was not.  `tools/pysim.py` used to rebuild the top
level from a hand-typed WIRING table, and the table silently fell three nets
behind the file:

    ID.reg_shift  -> EX.reg_shift
    ID.rs_value   -> EX.rs_value
    MEM.bt_active -> WB.bt_active     <- the block-transfer write suppress

Running with that last one missing corrupted 15 registers on every block
transfer.  The circuit was fine; the harness was broken.  Nothing reported it,
because a harness that keeps its own copy of the netlist has no way to know
its copy is wrong.

Two checks, both derived from the file:

  1. cpu() elaborates `main` -- it does not consult the table at all.
  2. every net in `main` is one the table would also have made, and vice
     versa.  A difference here is not automatically a bug now that check 1
     holds, but it is exactly the drift that used to be invisible.
"""
import collections, re, sys

sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
import logisim
from logisim import netlist
import tools.pysim as P

ABBR = P.ABBR


def real_nets(path):
    """(producer, consumer) pairs actually present in `main`."""
    d = logisim.load(path)
    main = d.circuits.get("main")
    if main is None:
        return None
    by_label = collections.defaultdict(list)
    for n in netlist.build(d, main):
        for c, _ in n.pins:
            if c.name == "Tunnel":
                by_label[c.attrs.get("label", "")].append(n)
    out = set()
    for lbl, group in by_label.items():
        drv, snk = [], []
        for n in group:
            for c, pn in n.pins:
                if c.name in ABBR:
                    outs = {p.attrs.get("label") for p in d.circuits[c.name].outputs()}
                    (drv if pn in outs else snk).append("%s.%s" % (ABBR[c.name], pn))
        for a in drv:
            for b in snk:
                out.add((a, b))
    return out


def declared():
    s = set(P.WIRING) | set(P.WB_WIRING) | set(P.MEM_WIRING)
    return {(a, b) for a, b in s if not a.endswith(("clk", "rst"))}


def main(path=P.CIRC):
    bad = 0

    s = P.cpu(path)
    from_main = getattr(s, "top_from_main", False)
    print("check 1: top level elaborated from `main`")
    if from_main:
        print("  ok      cpu() built the top from the file")
    else:
        m = logisim.load(path).circuits.get("main")
        n = len([c for c in m.components if c.name in ABBR]) if m else 0
        if n:
            print("  FAIL    `main` has %d stage instances but cpu() used the "
                  "hardcoded table" % n)
            bad += 1
        else:
            print("  n/a     `main` is empty; the table is the only option")

    print("\ncheck 2: the hardcoded table against the file")
    real = real_nets(path)
    if real is None:
        print("  n/a     no `main` in this design")
    else:
        real = {(a, b) for a, b in real if not a.endswith(("clk", "rst"))}
        decl = declared()
        missing, extra = sorted(real - decl), sorted(decl - real)
        print("  %d nets in the file, %d in the table" % (len(real), len(decl)))
        for a, b in missing:
            print("  DRIFT   in the file, not in the table:  %-22s -> %s" % (a, b))
        for a, b in extra:
            print("  DRIFT   in the table, not in the file:  %-22s -> %s" % (a, b))
        if not missing and not extra:
            print("  ok      they agree")
        elif from_main:
            print("  (harmless: the table is unused while `main` is wired)")
        else:
            bad += 1

    print("\nRESULT: %s" % ("PASS" if not bad else "FAIL"))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else P.CIRC))
