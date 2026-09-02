#!/usr/bin/env python3
"""The adversarial regression cases, run on the Python engine.

Same 54 cases as `tests/adversarial_regression.py`, same expected values --
imported from it, not copied, so the two can never disagree about what is being
asked.  What differs is the engine: this elaborates `main` out of the file and
evaluates it here, with no jar, no xvfb and no copy on disk.

Run both.  Where they agree the result is worth trusting; where they disagree
one of the two engines is wrong and that is worth knowing before believing
either.
"""
import os, sys, time

ROOT = "/home/junaet/Documents/CustomCPU"
sys.path.insert(0, ROOT)
sys.path.insert(0, os.path.join(ROOT, "tests"))

import tools.pysim as P
from tests import adversarial_regression as AR

RESULT_WORD = (AR.RESULT - 0x1000) // 4


def run_case(lines, expected, path, max_cycles=4000):
    asm = "\n".join([".syntax unified", ".arm", ".global _start", "_start:"]
                    + list(lines)
                    + ["    mov r11,#%d" % AR.RESULT, "    str r0,[r11]",
                       "    bx lr"]) + "\n"
    try:
        words = P.assemble(asm)
    except Exception:
        return "ASM", None, 0
    s = P.cpu(path)
    s.load_rom(words, 32)
    s.reset()
    s.settle()
    halted = False
    for _ in range(max_cycles):
        if s.peek("EX.bx_taken"):
            halted = True
            break
        s.tick("IF.clk")
    if not halted:
        return "HANG", None, len(words)
    got = s.ram_dump().get(RESULT_WORD, 0)
    return ("PASS" if got == expected else "WRONG"), got, len(words)


def main(argv):
    path = argv[0] if argv else P.CIRC
    s = P.cpu(path)
    if not getattr(s, "top_from_main", False):
        print("refusing to run: `main` is not wired in %s, so this would be "
              "testing a reconstruction rather than the circuit" % path)
        return 2
    print("engine=python  circuit=%s  top=main\n" % os.path.basename(path))
    started, cur, totals, failures = time.monotonic(), None, {}, []
    for group, name, lines, expected in AR.CASES:
        if group != cur:
            print("\n--- %s ---" % group)
            cur = group
        status, got, words = run_case(lines, expected, path)
        totals[status] = totals.get(status, 0) + 1
        detail = ""
        if got is not None and status != "PASS":
            detail = " got=%08x expected=%08x" % (got, expected)
        print("[%s] %-39s (%2d words)%s" % (status.center(7), name, words, detail))
        if status != "PASS":
            failures.append((group, name, status, got, expected))
    print("\n" + "  ".join("%s=%d" % kv for kv in sorted(totals.items())))
    ran = sum(totals.values())
    print("Architectural checks: %d/%d passed" % (ran - len(failures), ran))
    print("Elapsed: %.1fs" % (time.monotonic() - started))
    if failures:
        print("\nfailing, by group:")
        bg = {}
        for g, n, st, got, exp in failures:
            bg.setdefault(g, []).append(n)
        for g in sorted(bg):
            print("  %-10s %s" % (g, ", ".join(bg[g])))
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
