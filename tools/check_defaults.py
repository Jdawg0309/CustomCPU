#!/usr/bin/env python3
"""Flag components that rely on a Logisim default this project has been bitten by.

Logisim Evolution writes only NON-DEFAULT attributes.  An absent attribute is
therefore not "unset", it is a silent commitment to a value -- and four of those
defaults are the opposite of what this design usually wants:

    Constant     value  defaults to 1   (not 0)
    Constant     width  defaults to 1   (a wider value is clamped)
    Bit Extender type   defaults to sign (not zero)
    Splitter     incoming/fanout default to 2

Two real bugs found this way, both invisible to every structural and semantic
check that existed at the time:

    K_BRCIN in stage_EX      -> every branch landed one word past its target
    the pc+8 adder in stage_ID -> `add r0,pc,#0` returned 9 instead of 8

usage: check_defaults.py <file.circ> [circuit ...]

ERRORs are cases where the default is never defensible.  REVIEW lines are
reported for a human to adjudicate -- a bare Constant driving a Shifter's `dist`
is how a shift-by-one stage is meant to be built, and is correct.
"""
import sys
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
from logisim import model, geometry

# Ports where a silently-defaulted 1 is always a bug: there is no design in
# which you reach for an untyped constant because you wanted a carry set.
HARD = {("Adder", "cin"), ("Subtractor", "bin")}

errors = review = 0


def sinks(design, circ, comp):
    app = geometry.all_port_points(design, circ)
    return [(cc, nm) for cc, nm in app.get(comp.loc, []) if cc is not comp]


def main():
    path = sys.argv[1]
    only = sys.argv[2:]
    d = model.load(path)
    global errors, review
    for circ in d:
        if only and circ.name not in only:
            continue
        for c in circ.components:
            if c.name == "Constant" and "value" not in c.attrs:
                sk = sinks(d, circ, c)
                hard = [(cc, nm) for cc, nm in sk if (cc.name, nm) in HARD]
                tag = "ERROR" if hard else "REVIEW"
                if hard:
                    errors += 1
                else:
                    review += 1
                print("%-6s %-22s Constant@%-14s no value attr -> Logisim uses 1"
                      % (tag, circ.name, "%d,%d" % c.loc))
                for cc, nm in sk:
                    print("            drives %s@%s.%s" % (cc.name, cc.loc, nm))
                if not sk:
                    print("            drives nothing at that point")
            if c.name == "Constant" and "width" not in c.attrs:
                v = c.attrs.get("value")
                if v is not None and int(v, 0) > 1:
                    errors += 1
                    print("ERROR  %-22s Constant@%-14s value=%s with no width -> "
                          "clamped to 1 bit" % (circ.name, "%d,%d" % c.loc, v))
            if c.name == "Bit Extender" and "type" not in c.attrs:
                review += 1
                print("REVIEW %-22s Bit Extender@%-14s no type attr -> SIGN extension"
                      % (circ.name, "%d,%d" % c.loc))
                for cc, nm in sinks(d, circ, c):
                    print("            near %s@%s.%s" % (cc.name, cc.loc, nm))
            if c.name == "Splitter" and ("incoming" not in c.attrs or "fanout" not in c.attrs):
                review += 1
                print("REVIEW %-22s Splitter@%-14s incoming=%s fanout=%s (absent -> 2)"
                      % (circ.name, "%d,%d" % c.loc,
                         c.attrs.get("incoming", "-"), c.attrs.get("fanout", "-")))
    print("\n%d ERROR, %d REVIEW" % (errors, review))
    return 1 if errors else 0


sys.exit(main())
