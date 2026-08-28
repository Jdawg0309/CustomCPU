#!/usr/bin/env python3
"""Do the Python simulator and Logisim Evolution agree, cycle by cycle?

Neither engine checks the other by construction: one is a from-scratch
evaluator over the netlist, the other is the program that defines what a .circ
means.  Agreement on every observable of every cycle of real ARM programs is
the strongest evidence either of them is right.

A disagreement is not automatically a Python bug -- Logisim is the authority on
.circ semantics, so a mismatch means STOP and find out which one is wrong.
"""
import sys
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
import tools.smoke_suite as S

FIELDS = ["pc", "instr", "alu", "wa", "we", "cpsr", "pass", "btaken", "bltaken"]


def main():
    total = diffs = 0
    for name, asm, _expect, _note in S.CASES:
        S.ENGINE, S.CIRC = "python", "armv4t_2.circ"
        prows, _, pwords = S.run(asm)
        S.ENGINE, S.CIRC = "logisim", "smoke.circ"
        lrows, _, lwords = S.run(asm)
        total += 1
        bad = []
        if pwords != lwords:
            bad.append("different program image")
        n = min(len(prows), len(lrows))
        if len(prows) != len(lrows):
            bad.append("cycle count %d (python) vs %d (logisim)"
                       % (len(prows), len(lrows)))
        for i in range(n):
            for f in FIELDS:
                a, b = prows[i].get(f), lrows[i].get(f)
                if a != b:
                    bad.append("cycle %d %s: python=%s logisim=%s" % (i, f, a, b))
        if bad:
            diffs += 1
            print("[DIFFER] %-14s %d cycles compared" % (name, n))
            for x in bad[:8]:
                print("           ! %s" % x)
        else:
            print("[ AGREE ] %-14s %d cycles x %d fields = %d observables"
                  % (name, n, len(FIELDS), n * len(FIELDS)))
    print("\n%d/%d programs agree on every cycle" % (total - diffs, total))
    return 1 if diffs else 0


sys.exit(main())
