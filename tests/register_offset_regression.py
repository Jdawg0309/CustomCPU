#!/usr/bin/env python3
"""Direct-Logisim checks for register-offset load/store encodings."""

import os
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps


RESULT = 0x1200


CASES = [
    ("LDR word register offset", [
        "mov r1,#0x1100", "ldr r2,=0xcafebabe", "str r2,[r1,#12]",
        "mov r3,#12", "ldr r0,[r1,r3]"], 0xCAFEBABE),
    ("LDR word shifted register offset", [
        "mov r1,#0x1100", "ldr r2,=0xcafebabe", "str r2,[r1,#12]",
        "mov r3,#3", "ldr r0,[r1,r3,lsl #2]"], 0xCAFEBABE),
    ("LDRB register offset lane 3", [
        "mov r1,#0x1100", "ldr r2,=0x81223344", "str r2,[r1]",
        "mov r3,#3", "ldrb r0,[r1,r3]"], 0x81),
    ("STRB register offset preserves neighbors", [
        "mov r1,#0x1100", "ldr r2,=0x11223344", "str r2,[r1]",
        "mov r3,#2", "mov r4,#0xaa", "strb r4,[r1,r3]", "ldr r0,[r1]"],
     0x11AA3344),
    ("LDRH register offset high lane", [
        "mov r1,#0x1100", "ldr r2,=0x81223344", "str r2,[r1]",
        "mov r3,#2", "ldrh r0,[r1,r3]"], 0x8122),
    ("STRH register offset preserves neighbors", [
        "mov r1,#0x1100", "ldr r2,=0x11223344", "str r2,[r1]",
        "mov r3,#2", "ldr r4,=0xbeef", "strh r4,[r1,r3]", "ldr r0,[r1]"],
     0xBEEF3344),
    ("LDRSB register offset sign extends", [
        "mov r1,#0x1100", "ldr r2,=0x7f0180ff", "str r2,[r1]",
        "mov r3,#1", "ldrsb r0,[r1,r3]"], 0xFFFFFF80),
    ("LDRSH register offset sign extends", [
        "mov r1,#0x1100", "ldr r2,=0x80017fff", "str r2,[r1]",
        "mov r3,#2", "ldrsh r0,[r1,r3]"], 0xFFFF8001),
    ("LDRH subtract register offset", [
        "mov r1,#0x1100", "ldr r2,=0x11223344", "str r2,[r1]",
        "add r1,r1,#4", "mov r3,#4", "ldrh r0,[r1,-r3]"], 0x3344),
    ("LDRH register pre-index writeback", [
        "mov r1,#0x1100", "ldr r2,=0x11223344", "str r2,[r1]",
        "sub r1,r1,#2", "mov r3,#2", "ldrh r4,[r1,r3]!", "mov r0,r1"],
     0x1100),
    ("STRH register post-index writeback", [
        "mov r1,#0x1100", "mov r2,#0x55", "mov r3,#2",
        "strh r2,[r1],r3", "mov r0,r1"], 0x1102),
    ("conditional-false STRH suppresses memory", [
        "mov r1,#0x1100", "ldr r2,=0x11223344", "str r2,[r1]",
        "cmp r1,r1", "mov r3,#2", "mov r4,#0xaa", "strhne r4,[r1],r3",
        "ldr r0,[r1]"], 0x11223344),
    ("conditional-false STRH suppresses writeback", [
        "mov r1,#0x1100", "cmp r1,r1", "mov r2,#0xaa", "mov r3,#2",
        "strhne r2,[r1],r3", "mov r0,r1"], 0x1100),
    ("conditional-false LDRH preserves destination", [
        "mov r1,#0x1100", "mov r0,#0x5a", "cmp r1,r1", "mov r3,#2",
        "ldrhne r0,[r1],r3"], 0x5A),
    ("conditional-false LDRH suppresses writeback", [
        "mov r1,#0x1100", "cmp r1,r1", "mov r3,#2", "ldrhne r4,[r1],r3",
        "mov r0,r1"], 0x1100),
]


def run_case(lines):
    asm = "\n".join([
        ".syntax unified", ".arm", ".global _start", "_start:",
        *["    " + line for line in lines],
        f"    mov r11,#{RESULT}", "    str r0,[r11]", "    bx lr",
    ]) + "\n"
    with tempfile.TemporaryDirectory(prefix="reg_offset_") as work:
        words = ps.assemble(asm, work)
        halted, oscillated, ram = ps.run_rom(words, work)
    got = int(ram.get((RESULT - ps.RAM_BASE) // 4, "00000000"), 16)
    return halted, oscillated, got


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    if not argv:
        raise SystemExit("usage: register_offset_regression.py CIRCUIT")
    ps.CIRC = argv[0]
    selected = CASES
    if len(argv) > 1:
        needle = argv[1].casefold()
        selected = [case for case in CASES if needle in case[0].casefold()]
        if not selected:
            raise SystemExit(f"no case matched: {argv[1]}")
    failures = []
    for name, lines, expected in selected:
        halted, oscillated, got = run_case(lines)
        passed = halted and not oscillated and got == expected
        print(f"[{'PASS' if passed else 'FAIL'}] {name:<42} "
              f"got={got:08x} expected={expected:08x} "
              f"halted={halted} oscillated={oscillated}")
        if not passed:
            failures.append(name)
    print(f"Register-offset checks: {len(selected) - len(failures)}/{len(selected)} passed")
    return int(bool(failures))


if __name__ == "__main__":
    raise SystemExit(main())
