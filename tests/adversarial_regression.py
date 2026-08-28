#!/usr/bin/env python3
"""Adversarial ARMv4T ARM-state regression suite.

Each ROM is deliberately small and tests one architectural promise.  This is
not a smoke test: failures are useful results.  The default target is the
debug circuit; pass a .circ path to test another copy.
"""
import os
import argparse
import subprocess
import sys
import tempfile
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps

DEFAULT_CIRC = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "debug_armv4t.circ")
RESULT = ps.RAM_BASE + 0x200

CASES = []

def case(group, name, lines, expected):
    CASES.append((group, name, lines, expected & 0xffffffff))


# Arithmetic boundaries.  These values force carries, borrows, sign changes,
# and signed overflow instead of only exercising friendly small integers.
# 0xffffffff + 2 == 1 modulo 2^32: the wrap is still what is being tested, but
# the answer is nonzero. The old form added #1 and expected 0 -- and 0 is also
# what this harness reports for a core that stored nothing at all, so that
# oracle could not fail.
case("alu", "ADD carry wraps", [
    "    mvn r1,#0", "    add r0,r1,#2"], 1)
case("alu", "ADC consumes carry=1", [
    "    mvn r1,#0", "    adds r2,r1,#1", "    mov r3,#7", "    adc r0,r3,#0"], 8)
case("alu", "ADC consumes carry=0", [
    "    mov r1,#1", "    adds r2,r1,#1", "    mov r3,#7", "    adc r0,r3,#0"], 7)
case("alu", "SBC consumes carry=1 (no borrow)", [
    "    mov r1,#9", "    cmp r1,#1", "    sbc r0,r1,#3"], 6)
case("alu", "SBC consumes carry=0 (borrow)", [
    "    mov r1,#1", "    cmp r1,#9", "    mov r2,#9", "    sbc r0,r2,#3"], 5)
case("alu", "RSB order", ["    mov r1,#3", "    rsb r0,r1,#10"], 7)
case("alu", "BIC inversion", [
    "    mov r1,#0xff", "    mov r2,#0x0f", "    bic r0,r1,r2"], 0xf0)

# Flag/condition matrix.  Each case uses conditional MOVs as an oracle.
for name, prep, cond, expected in [
    ("EQ", ["mov r1,#4", "cmp r1,#4"], "eq", 1),
    ("NE", ["mov r1,#4", "cmp r1,#5"], "ne", 1),
    ("CS", ["mov r1,#5", "cmp r1,#4"], "cs", 1),
    ("CC", ["mov r1,#4", "cmp r1,#5"], "cc", 1),
    ("MI", ["mov r1,#4", "cmp r1,#5"], "mi", 1),
    ("PL", ["mov r1,#5", "cmp r1,#4"], "pl", 1),
    ("VS", ["mov r1,#0x80000000", "subs r2,r1,#1"], "vs", 1),
    ("VC", ["mov r1,#5", "subs r2,r1,#1"], "vc", 1),
    ("HI", ["mov r1,#5", "cmp r1,#4"], "hi", 1),
    ("LS", ["mov r1,#4", "cmp r1,#5"], "ls", 1),
    # -1 CMP 1 leaves N=1, V=0, so GE (N==V) is FALSE and r0 must keep its
    # pre-set value. That value is 0x5a, not 0: an all-zero result is what the
    # harness also reports when nothing executed, so a 0 expectation here could
    # not distinguish "GE correctly did not fire" from "the core is dead".
    ("GE", ["mvn r1,#0", "cmp r1,#1"], "ge", 0x5a),
    ("LT", ["mvn r1,#0", "cmp r1,#1"], "lt", 1),
    ("GT", ["mov r1,#5", "cmp r1,#4"], "gt", 1),
    ("LE", ["mov r1,#4", "cmp r1,#5"], "le", 1),
]:
    body = ["    " + x for x in prep]
    body += ["    mov r0,#0x5a", f"    mov{cond} r0,#1"]
    case("conditions", name, body, expected)

# Shifter boundary semantics are a common decoder trap.  Register-specified
# shifts use Rs[7:0]; immediate #0 has special ARM meanings for LSR/ASR/ROR.
for name, setup, insn, expected in [
    ("LSL immediate 31", ["mov r1,#1"], "mov r0,r1,lsl #31", 0x80000000),
    ("LSR immediate 31", ["mov r1,#0x80000000"], "mov r0,r1,lsr #31", 1),
    ("ASR negative", ["mov r1,#0x80000000"], "mov r0,r1,asr #31", 0xffffffff),
    ("ROR immediate", ["mov r1,#1"], "mov r0,r1,ror #1", 0x80000000),
    ("LSL register 3", ["mov r1,#4", "mov r3,#3"], "mov r0,r1,lsl r3", 32),
    ("LSR register 3", ["mov r1,#32", "mov r3,#3"], "mov r0,r1,lsr r3", 4),
    ("ASR register 3", ["mvn r1,#7", "mov r3,#3"], "mov r0,r1,asr r3", 0xffffffff),
    ("ROR register 3", ["mov r1,#8", "mov r3,#3"], "mov r0,r1,ror r3", 1),
    # ARM LSL by a register amount of 32 yields 0 -- architecturally the answer
    # must be zero, which is also the harness's "nothing happened" reading, so
    # r0 is poisoned first: a shift that decoded to a NOP now leaves 0x5a.
    ("LSL register 32", ["mov r0,#0x5a", "mov r1,#1", "mov r3,#32"],
     "mov r0,r1,lsl r3", 0),
    ("LSR register zero", ["mov r1,#32", "mov r3,#0"], "mov r0,r1,lsr r3", 32),
]:
    case("shifter", name, ["    " + x for x in setup] + ["    " + insn], expected)

# Addressing modes: distinguish plain register offsets (known to look healthy)
# from a shifted register offset, and independently check P/U/W behaviour.
case("memory", "word immediate offset", [
    "    mov r1,#0x1100", "    mov r2,#0xaa", "    str r2,[r1,#12]",
    "    ldr r0,[r1,#12]"], 0xaa)
case("memory", "word register offset", [
    "    mov r1,#0x1100", "    mov r3,#12", "    mov r2,#0xbb",
    "    str r2,[r1,r3]", "    ldr r0,[r1,r3]"], 0xbb)
case("memory", "shifted register offset", [
    "    mov r1,#0x1100", "    mov r3,#3", "    mov r2,#0xcc",
    "    str r2,[r1,#12]", "    ldr r0,[r1,r3,lsl #2]"], 0xcc)
case("memory", "pre-index down writeback", [
    "    mov r1,#0x1100", "    add r1,r1,#16", "    mov r2,#0xdd", "    str r2,[r1,#-16]!",
    "    ldr r0,[r1]"], 0xdd)
case("memory", "post-index writeback address", [
    "    mov r1,#0x1100", "    mov r2,#0xee", "    str r2,[r1],#4",
    "    mov r0,r1"], 0x1104)
case("memory", "byte lane 3", [
    "    mov r1,#0x1100", "    add r1,r1,#3", "    mov r2,#0xab", "    strb r2,[r1]",
    "    ldrb r0,[r1]"], 0xab)
case("memory", "halfword", [
    "    mov r1,#0x1100", "    mov r2,#0xab", "    strh r2,[r1]",
    "    ldrh r0,[r1]"], 0xab)
case("memory", "signed byte", [
    "    mov r1,#0x1100", "    mvn r2,#0", "    strb r2,[r1]",
    "    ldrsb r0,[r1]"], 0xffffffff)
case("memory", "literal pool", ["    ldr r0,=0xcafebabe"], 0xcafebabe)
case("memory", "program ROM through register base", [
    "    ldr r1,=table", "    ldr r0,[r1,#4]", "    b done",
    "table: .word 0x11111111", "    .word 0xcafebabe", "done:"], 0xcafebabe)

# Control-flow writes to r15.  The `b done` after the 0xee marker is what makes
# these discriminators: without it the fall-through path runs straight ON into
# the landing pad and executes the very instruction that produces the expected
# value, so a core that ignored the write to r15 entirely still reported PASS.
# With the branch, fall-through leaves 0xee and only a real redirect leaves the
# landing value.
case("pc", "MOV pc register return", [
    "    adr lr,target", "    mov pc,lr", "    mov r0,#0xee", "    b done",
    "target: mov r0,#0x55", "done:"], 0x55)
case("pc", "ADD pc computed jump", [
    "    adr r1,target", "    add pc,r1,#0", "    mov r0,#0xee", "    b done",
    "target: mov r0,#0x56", "done:"], 0x56)
case("pc", "LDR pc redirect", [
    "    mov r1,#0x1100", "    adr r2,target", "    str r2,[r1]",
    "    ldr pc,[r1]", "    mov r0,#0xee", "    b done",
    "target: mov r0,#0x57", "done:"], 0x57)
case("pc", "POP pc redirect", [
    "    mov sp,#0x1400", "    adr lr,target", "    push {lr}",
    "    pop {pc}", "    mov r0,#0xee", "    b done",
    "target: mov r0,#0x58", "done:"], 0x58)
# `sub r0,pc,#4` at address 0 gives 8-4 = 4: same claim (r15 reads as the
# address of this instruction plus 8), but a nonzero answer. Subtracting #8 and
# expecting 0 made the case unfalsifiable against a core that stored nothing.
case("pc", "PC reads as instruction+8", ["    sub r0,pc,#4"], 4)

# General block transfer, not merely PUSH/POP aliases.  The result tests data;
# writeback is checked in separate cases so symmetric mistakes cannot cancel.
case("block", "STMIA non-SP data", [
    "    mov r4,#0x1100", "    mov r1,#0x11", "    mov r2,#0x22",
    "    stmia r4!,{r1,r2}", "    mov r5,#0x1100", "    ldr r0,[r5,#4]"], 0x22)
case("block", "STMIA non-SP writeback", [
    "    mov r4,#0x1100", "    mov r1,#0x11", "    mov r2,#0x22",
    "    stmia r4!,{r1,r2}", "    mov r0,r4"], 0x1108)
case("block", "LDMIA non-SP", [
    "    mov r4,#0x1100", "    mov r1,#0x31", "    mov r2,#0x32",
    "    str r1,[r4]", "    str r2,[r4,#4]", "    ldmia r4!,{r6,r7}",
    "    mov r0,r7"], 0x32)
case("block", "STMDB non-SP", [
    "    mov r4,#0x1100", "    add r4,r4,#8", "    mov r1,#0x41", "    mov r2,#0x42",
    "    stmdb r4!,{r1,r2}", "    mov r5,#0x1100", "    ldr r0,[r5,#4]"], 0x42)
case("block", "LDMDB non-SP", [
    "    mov r4,#0x1100", "    mov r1,#0x51", "    mov r2,#0x52",
    "    str r1,[r4]", "    str r2,[r4,#4]", "    add r4,r4,#8",
    "    ldmdb r4!,{r6,r7}", "    mov r0,r7"], 0x52)

# Major ARM-state classes still likely to be absent or disconnected.
case("extension", "MUL", ["    mov r1,#7", "    mov r2,#6", "    mul r0,r1,r2"], 42)
case("extension", "MLA", [
    "    mov r1,#7", "    mov r2,#6", "    mov r3,#2", "    mla r0,r1,r2,r3"], 44)
case("extension", "SWP", [
    "    mov r1,#0x1100", "    mov r2,#0xaa", "    str r2,[r1]",
    "    mov r3,#0xbb", "    swp r0,r3,[r1]"], 0xaa)


def run(lines, expected):
    asm = "\n".join([".syntax unified", ".arm", ".global _start", "_start:"]
                    + lines
                    + [f"    mov r11,#{RESULT}", "    str r0,[r11]", "    bx lr"]) + "\n"
    with tempfile.TemporaryDirectory() as wd:
        try:
            words = ps.assemble(asm, wd)
        except subprocess.CalledProcessError:
            return "ASM", None, 0
        try:
            halted, oscillated, ram = ps.run_rom(words, wd)
        except subprocess.TimeoutExpired:
            return "TIMEOUT", None, len(words)
        except AssertionError:
            return "TOOBIG", None, len(words)
    if oscillated:
        return "OSC", None, len(words)
    if not halted:
        return "HANG", None, len(words)
    got = int(ram.get((RESULT - ps.RAM_BASE) // 4, "00000000"), 16)
    return ("PASS" if got == expected else "WRONG"), got, len(words)


def parse_args(argv=None):
    parser = argparse.ArgumentParser(
        description="Run ARM-state architectural checks against a circuit.")
    parser.add_argument("circuit", nargs="?", default=DEFAULT_CIRC)
    parser.add_argument(
        "--group", action="append", default=[], metavar="NAME",
        help="run only this group; repeat for more than one group")
    parser.add_argument(
        "--case", action="append", default=[], metavar="NAME",
        help="run only this exact case name; repeat for more than one case")
    parser.add_argument(
        "--list", action="store_true", help="list selectable cases and exit")
    parser.add_argument(
        "--fail-fast", action="store_true", help="stop after the first failure")
    return parser.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)
    ps.CIRC = args.circuit
    selected = list(CASES)
    if args.group:
        groups = {x.casefold() for x in args.group}
        selected = [x for x in selected if x[0].casefold() in groups]
    if args.case:
        names = {x.casefold() for x in args.case}
        selected = [x for x in selected if x[1].casefold() in names]
    if args.list:
        for group, name, _, _ in selected:
            print(f"{group}: {name}")
        return 0
    if not selected:
        print("No cases matched the requested filters.", file=sys.stderr)
        return 2

    started = time.monotonic()
    current = None
    totals = {}
    failures = []
    for group, name, lines, expected in selected:
        if group != current:
            print(f"\n--- {group} ---")
            current = group
        status, got, words = run(lines, expected)
        totals[status] = totals.get(status, 0) + 1
        detail = ""
        if got is not None and status != "PASS":
            detail = f" got={got:08x} expected={expected:08x}"
        print(f"[{status:^7}] {name:<39} ({words:2d} words){detail}")
        if status != "PASS":
            failures.append((group, name, status, got, expected))
            if args.fail_fast:
                break
    print("\n" + "  ".join(f"{k}={v}" for k, v in sorted(totals.items())))
    ran = sum(totals.values())
    print(f"Architectural checks: {ran-len(failures)}/{ran} passed")
    print(f"Elapsed: {time.monotonic()-started:.1f}s")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
