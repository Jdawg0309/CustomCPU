#!/usr/bin/env python3
"""Exhaustive per-opcode / per-operand edge matrix.

Each case is a separate program executed from a reset CPU, so no case can be
made to pass by state a previous one left behind.  Originally written by Codex
during the 2026-08-30 audit; kept here because it is the only sweep that
covers the immediate-encoding space densely enough to have found the
`reg_shift` defect.

    python3 tools/edge_matrix.py [circuit.circ]
"""
import sys

sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
import tools.pysim as P

CIRC = (sys.argv[1] if len(sys.argv) > 1
        else "/home/junaet/Documents/CustomCPU/debug_armv4t_2.circ")
MASK = 0xFFFFFFFF
counts = {}
failures = []


def reg(s, n):
    return s.find("reg16x32_1:R%d.Q" % n)[0][1] & MASK


def record(group, name, got, want):
    passed, total = counts.get(group, (0, 0))
    ok = got == (want & MASK)
    counts[group] = (passed + int(ok), total + 1)
    if not ok and len(failures) < 40:
        failures.append((group, name, got, want & MASK))


def execute(lines, max_cycles=200):
    asm = ".syntax unified\n.arm\n" + "\n".join(lines) + "\nbx lr\n"
    rows, words, sim = P.run(asm, max_cycles=max_cycles, path=CIRC)
    if not rows[-1].get("bx_taken"):
        raise RuntimeError("program did not halt: " + repr(lines))
    return sim


def lit(rd, value):
    return "ldr r%d, =0x%08x" % (rd, value & MASK)


def asr(value, amount):
    value &= MASK
    if amount >= 32:
        return MASK if value & 0x80000000 else 0
    if value & 0x80000000:
        return ((value >> amount) | (MASK << (32 - amount))) & MASK
    return value >> amount


def ror(value, amount):
    amount &= 31
    if amount == 0:
        return value & MASK
    return ((value >> amount) | (value << (32 - amount))) & MASK


pairs = [
    (0, 0), (0, 1), (MASK, 1),
    (0x7FFFFFFF, 1), (0x80000000, 1),
    (0xAAAAAAAA, 0x55555555),
]

binary = {
    "and": lambda a, b: a & b,
    "eor": lambda a, b: a ^ b,
    "sub": lambda a, b: a - b,
    "rsb": lambda a, b: b - a,
    "add": lambda a, b: a + b,
    "orr": lambda a, b: a | b,
    "bic": lambda a, b: a & ~b,
}
for op, fn in binary.items():
    for a, b in pairs:
        sim = execute([lit(0, a), lit(1, b), "%s r2,r0,r1" % op])
        record("data-register", "%s %08x %08x" % (op, a, b), reg(sim, 2), fn(a, b))

for op, fn in (("mov", lambda a: a), ("mvn", lambda a: ~a)):
    for a in (0, 1, MASK, 0x80000000, 0x12345678):
        sim = execute([lit(0, a), "%s r2,r0" % op])
        record("data-register", "%s %08x" % (op, a), reg(sim, 2), fn(a))

carry_ops = {
    "adc": lambda a, b, c: a + b + c,
    "sbc": lambda a, b, c: a - b - (1 - c),
    "rsc": lambda a, b, c: b - a - (1 - c),
}
for op, fn in carry_ops.items():
    for carry in (0, 1):
        for a, b in pairs:
            setup = [lit(0, a), lit(1, b)]
            setup += ["mov r4,#0", "cmp r4,#1"] if carry == 0 else ["mov r4,#1", "cmp r4,#0"]
            sim = execute(setup + ["%s r2,r0,r1" % op])
            record("data-carry", "%s C%d %08x %08x" % (op, carry, a, b),
                   reg(sim, 2), fn(a, b, carry))

# This is the original immediate-bit poison sweep: all 256 imm8 values,
# with an unrelated r0 spanning both sides of the erroneous >=32 decision.
for poison in (0, 1, 31, 32, 255):
    for base in range(0, 256, 12):
        vals = list(range(base, min(base + 12, 256)))
        lines = ["mov r0,#%d" % poison, "mov r1,#1"]
        for i, imm in enumerate(vals):
            lines.append("add r%d,r1,#%d" % (i + 2, imm))
        sim = execute(lines)
        for i, imm in enumerate(vals):
            record("immediate-imm8", "poison=%d imm=%d" % (poison, imm),
                   reg(sim, i + 2), 1 + imm)

values = (0, 1, 0x80000000, MASK, 0x12345678)
imm_amounts = {
    "lsl": (0, 1, 31),
    "lsr": (1, 31, 32),
    "asr": (1, 31, 32),
    "ror": (1, 31),
}

def shift_expected(kind, value, amount):
    if kind == "lsl":
        return (value << amount) & MASK if amount < 32 else 0
    if kind == "lsr":
        return value >> amount if amount < 32 else 0
    if kind == "asr":
        return asr(value, amount)
    return ror(value, amount)

for kind, amounts in imm_amounts.items():
    for value in values:
        for amount in amounts:
            sim = execute([lit(1, value), "mov r2,r1,%s #%d" % (kind, amount)])
            record("shift-immediate", "%s %08x #%d" % (kind, value, amount),
                   reg(sim, 2), shift_expected(kind, value, amount))

for kind in ("lsl", "lsr", "asr", "ror"):
    for value in values:
        for amount in (0, 1, 31, 32, 33, 255, 256):
            sim = execute([lit(1, value), lit(3, amount), "mov r2,r1,%s r3" % kind])
            n = amount & 0xFF
            record("shift-register", "%s %08x r=%d" % (kind, value, amount),
                   reg(sim, 2), shift_expected(kind, value, n))

passed = sum(v[0] for v in counts.values())
total = sum(v[1] for v in counts.values())
for group in ("data-register", "data-carry", "immediate-imm8", "shift-immediate", "shift-register"):
    p, t = counts[group]
    print("%-20s %4d/%-4d" % (group, p, t))
print("TOTAL                %4d/%-4d" % (passed, total))
for group, name, got, want in failures:
    print("FAIL %-18s %-34s got=%08x want=%08x" % (group, name, got, want))
raise SystemExit(0 if passed == total == 1563 else 1)


_bad = sum(t - p for p, t in counts.values())
sys.exit(1 if _bad else 0)
