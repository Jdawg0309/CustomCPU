#!/usr/bin/env python3
import os
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "tests"))
import push_suite as ps

ps.CIRC = sys.argv[1] if len(sys.argv) > 1 else "armv4t_2.circ"
RESULT = ps.RAM_BASE + 0x200

CASES = [
    ("ADD carry", ["mvn r1,#0", "add r0,r1,#2"], 1),
    ("LSL immediate", ["mov r1,#4", "mov r0,r1,lsl #4"], 0x40),
    ("LSL register", ["mov r1,#4", "mov r3,#3", "mov r0,r1,lsl r3"], 0x20),
]

for name, body, expected in CASES:
    asm = "\n".join(
        [".syntax unified", ".arm", ".global _start", "_start:"]
        + ["    " + line for line in body]
        + [f"    mov r11,#{RESULT}", "    str r0,[r11]", "    bx lr"]
    ) + "\n"
    with tempfile.TemporaryDirectory() as wd:
        words = ps.assemble(asm, wd)
        halted, osc, ram = ps.run_rom(words, wd)
    got = int(ram.get((RESULT - ps.RAM_BASE) // 4, "00000000"), 16)
    status = "PASS" if halted and not osc and got == expected else "OSC" if osc else "HANG" if not halted else "WRONG"
    print(f"{status:5} {name}: halted={halted} osc={osc} got={got:08x} expected={expected:08x}", flush=True)
