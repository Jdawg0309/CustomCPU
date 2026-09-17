#!/usr/bin/env python3
"""Discriminating byte/halfword transfer tests for the reorganized CPU.

The original 54-case suite checks one byte lane and one halfword address.  That
is not enough to prove byte enables, lane selection, preservation, or signed
extension.  Every case here initializes memory through a full-word store and
observes through a different access form so symmetric address bugs cannot pass.
"""
import os
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps

DEFAULT_CIRC = os.path.join(os.path.dirname(os.path.dirname(__file__)),
                            "debug_armv4t_2.circ")
RESULT = 0x1200


def make_case(name, body, expected):
    return name, body, expected & 0xFFFFFFFF


CASES = [
    make_case("STRB lane 0 preserves neighbors", [
        "ldr r2,=0x11223344", "str r2,[r1]", "mov r3,#0xaa",
        "strb r3,[r1]", "ldr r0,[r1]"], 0x112233AA),
    make_case("STRB lane 1 preserves neighbors", [
        "ldr r2,=0x11223344", "str r2,[r1]", "mov r3,#0xaa",
        "strb r3,[r1,#1]", "ldr r0,[r1]"], 0x1122AA44),
    make_case("STRB lane 2 preserves neighbors", [
        "ldr r2,=0x11223344", "str r2,[r1]", "mov r3,#0xaa",
        "strb r3,[r1,#2]", "ldr r0,[r1]"], 0x11AA3344),
    make_case("STRB lane 3 preserves neighbors", [
        "ldr r2,=0x11223344", "str r2,[r1]", "mov r3,#0xaa",
        "strb r3,[r1,#3]", "ldr r0,[r1]"], 0xAA223344),
    make_case("LDRB lane 0 zero extends", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldrb r0,[r1]"], 0x44),
    make_case("LDRB lane 1 zero extends", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldrb r0,[r1,#1]"], 0x33),
    make_case("LDRB lane 2 zero extends", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldrb r0,[r1,#2]"], 0x22),
    make_case("LDRB lane 3 zero extends", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldrb r0,[r1,#3]"], 0x11),
    make_case("STRH low preserves high half", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldr r3,=0xbeef",
        "strh r3,[r1]", "ldr r0,[r1]"], 0x1122BEEF),
    make_case("STRH high preserves low half", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldr r3,=0xbeef",
        "strh r3,[r1,#2]", "ldr r0,[r1]"], 0xBEEF3344),
    make_case("LDRH low zero extends", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldrh r0,[r1]"], 0x3344),
    make_case("LDRH high zero extends", [
        "ldr r2,=0x11223344", "str r2,[r1]", "ldrh r0,[r1,#2]"], 0x1122),
    make_case("LDRSB lane 0 negative", [
        "ldr r2,=0x7f0180ff", "str r2,[r1]", "ldrsb r0,[r1]"], 0xFFFFFFFF),
    make_case("LDRSB lane 1 negative", [
        "ldr r2,=0x7f0180ff", "str r2,[r1]", "ldrsb r0,[r1,#1]"], 0xFFFFFF80),
    make_case("LDRSB lane 2 positive", [
        "ldr r2,=0x7f0180ff", "str r2,[r1]", "ldrsb r0,[r1,#2]"], 0x1),
    make_case("LDRSB lane 3 positive", [
        "ldr r2,=0x7f0180ff", "str r2,[r1]", "ldrsb r0,[r1,#3]"], 0x7F),
    make_case("LDRSH low negative", [
        "ldr r2,=0x7fff8001", "str r2,[r1]", "ldrsh r0,[r1]"], 0xFFFF8001),
    make_case("LDRSH high positive", [
        "ldr r2,=0x7fff8001", "str r2,[r1]", "ldrsh r0,[r1,#2]"], 0x7FFF),
    make_case("LDRSH high negative", [
        "ldr r2,=0x80017fff", "str r2,[r1]", "ldrsh r0,[r1,#2]"], 0xFFFF8001),
]


def run_case(body):
    asm = "\n".join([
        ".syntax unified", ".arm", ".global _start", "_start:",
        "    mov r1,#0x1100",
    ] + ["    " + line for line in body] + [
        f"    mov r11,#{RESULT}", "    str r0,[r11]", "    bx lr",
    ]) + "\n"
    with tempfile.TemporaryDirectory(prefix="mem_lane_") as work:
        words = ps.assemble(asm, work)
        halted, oscillated, ram = ps.run_rom(words, work)
    got = int(ram.get((RESULT - ps.RAM_BASE) // 4, "00000000"), 16)
    return halted, oscillated, got, len(words)


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    ps.CIRC = argv[0] if argv else DEFAULT_CIRC
    failed = []
    for name, body, expected in CASES:
        halted, oscillated, got, words = run_case(body)
        ok = halted and not oscillated and got == expected
        print("[%s] %-36s got=%08x expected=%08x (%d words)" %
              ("PASS" if ok else "FAIL", name, got, expected, words))
        if not ok:
            failed.append(name)
    print("Memory lane checks: %d/%d passed" %
          (len(CASES) - len(failed), len(CASES)))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
