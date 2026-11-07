#!/usr/bin/env python3
"""Aggressive differential stress: the real Logisim jar vs Unicorn, in volume.

Adds a "chaos" category to tests/unicorn_diff.py -- long random instruction
streams where every implemented class interleaves: conditional execution on
~40% of instructions, S on half the data-processing ops, every shifter form
including register shifts, byte/half/word loads and stores in every addressing
mode (with shifted register offsets), LDM/STM in all four modes, conditional
branches and calls. Then runs batch after batch of programs (all categories)
until a time budget runs out, saving every failing program for replay.

Deliberately NOT generated, so known bugs cannot mask new ones:
  unaligned word/half access         (D2; Unicorn doesn't rotate either)
  register offsets LSR/ASR #32, RRX  (B2, stage_MEM barrel)
  halfword loads from ROM            (B1)
  MUL/MLA/SWP/MSR/MRS, BX            (unimplemented / BX halts the bench)

    python tests/stress_chaos.py CIRC [--minutes 120] [--batch 24] [--jobs 4] [--seed 1]

Needs Unicorn (pip install unicorn) in the interpreter that runs it.
"""
import argparse
import os
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
_argv, sys.argv = sys.argv, sys.argv[:1]
import unicorn_diff as ud          # noqa: E402
sys.argv = _argv

DP_REGS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 14]   # r9/r10 belong to the memory ops
BASE = "0x1140"                                    # +-64 bytes stays in 0x1100-0x11FF


_NO_LR = [False]      # inside a subroutine body, lr must survive to `mov pc, lr`


def _dest():
    return [r for r in DP_REGS if r != 14] if _NO_LR[0] else DP_REGS


def _o2(rng):
    r = rng.choice(DP_REGS + [9, 10])
    f = rng.random()
    if f < 0.25:
        return "#0x%x" % ud.ror32(rng.getrandbits(8), 2 * rng.randrange(16))
    if f < 0.40:
        return "r%d" % r
    if f < 0.75:
        t = rng.choice(["lsl", "lsr", "asr", "ror", "rrx"])
        if t == "rrx":
            return "r%d, rrx" % r
        lim = 32 if t in ("lsl", "ror") else 33
        return "r%d, %s #%d" % (r, t, rng.randrange(1, lim))
    return "r%d, %s r%d" % (r, rng.choice(["lsl", "lsr", "asr", "ror"]), rng.choice(DP_REGS))


def _dp(rng):
    op, c = rng.choice(ud.DP), ud.cond(rng, 0.4)
    rd, rn = rng.choice(_dest()), rng.choice(DP_REGS + [9, 10])
    s = "s" if rng.random() < 0.5 and op not in ud.NOWRITE else ""
    if op in ud.NOWRITE:
        return ["%s%s r%d, %s" % (op, c, rn, _o2(rng))]
    if op in ud.ONEOP:
        return ["%s%s%s r%d, %s" % (op, s, c, rd, _o2(rng))]
    return ["%s%s%s r%d, r%d, %s" % (op, s, c, rd, rn, _o2(rng))]


def _mem(rng):
    kind = rng.choice(["w", "w", "b", "b", "h", "sb", "sh"])
    ld = kind in ("sb", "sh") or rng.random() < 0.5
    al = {"w": 4, "b": 1, "h": 2, "sb": 1, "sh": 2}[kind]
    mn = {"w": "ldr" if ld else "str", "b": "ldrb" if ld else "strb",
          "h": "ldrh" if ld else "strh", "sb": "ldrsb", "sh": "ldrsh"}[kind]
    mn += ud.cond(rng, 0.4)
    rd = rng.choice(_dest())
    k = rng.randrange(0, 8)
    pre = ["mov r9, #%d" % (al * k)]
    sign = rng.choice(["", "-"])
    modes = ["off", "pre", "post", "reg", "regpre", "regpost"]
    if kind in ("w", "b"):
        modes += ["shreg", "shreg"]           # scaled register offsets: word/byte only
    m = rng.choice(modes)
    off = al * rng.randrange(0, 16)
    if m == "off":
        x = "%s r%d, [r10, #%s%d]" % (mn, rd, sign, off)
    elif m == "pre":
        x = "%s r%d, [r10, #%s%d]!" % (mn, rd, sign, off)
    elif m == "post":
        x = "%s r%d, [r10], #%s%d" % (mn, rd, sign, off)
    elif m == "reg":
        x = "%s r%d, [r10, %sr9]" % (mn, rd, sign)
    elif m == "regpre":
        x = "%s r%d, [r10, %sr9]!" % (mn, rd, sign)
    elif m == "regpost":
        x = "%s r%d, [r10], %sr9" % (mn, rd, sign)
    else:
        # pick the final offset first (a multiple of 4, so aligned for every
        # size), then the r9 that this shift turns into it
        off = 4 * rng.randrange(0, 8)
        sh, r9 = rng.choice([("lsl #1", off // 2), ("lsl #2", off // 4), ("lsr #1", off * 2),
                             ("lsr #2", off * 4), ("asr #1", off * 2), ("asr #2", off * 4),
                             ("ror #31", off // 2)])       # ror #31 == rotate left 1
        if sh == "lsl #2" and off % 4:
            sh, r9 = "lsl #1", off // 2
        pre = ["mov r9, #%d" % r9]
        x = "%s r%d, [r10, %sr9, %s]" % (mn, rd, sign, sh)
    return pre + [x, "ldr r10, =%s" % BASE]


def _block(rng):
    regs = sorted(rng.sample(DP_REGS, rng.randrange(1, 9)))
    rl = ",".join("lr" if r == 14 else "r%d" % r for r in regs)
    mn = rng.choice(["ldm", "stm"]) + rng.choice(["ia", "ib", "da", "db"]) + ud.cond(rng, 0.3)
    return ["%s r10%s, {%s}" % (mn, rng.choice(["", "!"]), rl), "ldr r10, =%s" % BASE]


def _flow(rng):
    c = ud.cond(rng, 0.8) or "eq"
    if rng.random() < 0.5:
        return ["b%s 1f" % c] + _dp(rng) + _dp(rng) + ["1:"]
    # a conditional call into a subroutine that does real work, then returns
    _NO_LR[0] = True
    body = _dp(rng) + _mem(rng)
    _NO_LR[0] = False
    return ["bl%s 3f" % c, "b 4f", "3:"] + body + ["mov pc, lr", "4:"]


def gen_chaos(rng):
    out = ["ldr r10, =%s" % BASE]
    while len(out) < rng.randrange(15, 31):
        out += rng.choice([_dp, _dp, _dp, _mem, _mem, _block, _flow])(rng)
    return out


ud.CATEGORIES["chaos"] = gen_chaos


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("circuit")
    ap.add_argument("--minutes", type=float, default=120)
    ap.add_argument("--batch", type=int, default=24)
    ap.add_argument("--jobs", type=int, default=4)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--category", default="chaos,mixed,dp,mem,block,pc,branch,cond")
    a = ap.parse_args()
    py = sys.executable
    t_end = time.time() + 60 * a.minutes
    seed, batches, tests, failed = a.seed, 0, 0, []
    cats = a.category.split(",")
    while time.time() < t_end:
        cat = cats[batches % len(cats)]
        cmd = [py, "-c", "import sys; sys.argv=sys.argv[1:]; sys.path.insert(0, %r); "
               "import stress_chaos, unicorn_diff; sys.exit(unicorn_diff.main())" % HERE,
               "x", a.circuit, "--category", cat, "--programs", str(a.batch),
               "--seed", str(seed), "--jobs", str(a.jobs)]
        p = subprocess.run(cmd, capture_output=True, text=True)
        out = p.stdout + p.stderr
        batches += 1
        tests += a.batch * ud.TESTS_PER_PROGRAM
        last = [l for l in out.splitlines() if l.startswith("programs:")]
        print("[%s] batch %d seed %d %-6s %s" % (time.strftime("%H:%M"), batches, seed, cat,
                                                last[0] if last else "ERROR " + out[-400:]),
              flush=True)
        if p.returncode:
            failed.append((seed, cat))
            print(out[out.find("== localising"):] if "== localising" in out else out[-3000:],
                  flush=True)
        seed += 1
    print("\nTOTAL: %d batches, %d tests, %d failing batches %s"
          % (batches, tests, len(failed), failed))
    print("replay one: python tests/unicorn_diff.py CIRC --category CAT --seed SEED "
          "--programs %d  (with `import stress_chaos` for chaos)" % a.batch)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
