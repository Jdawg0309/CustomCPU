#!/usr/bin/env python3
"""End-to-end ARM multiply-family discriminator for debug_armv4t_2.circ."""
import os, re, subprocess, tempfile, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps

CIRC = sys.argv[1] if len(sys.argv) > 1 else "debug_armv4t_2.circ"

ASM = r"""
.syntax unified
.arm
.global _start
_start:
    mov r14,#0x1000
    mvn r1,#0
    mov r2,#2
    mov r4,#3

    mul r0,r1,r2
    str r0,[r14,#0]

    mla r3,r1,r2,r4
    str r3,[r14,#4]

    umull r5,r6,r1,r2
    str r5,[r14,#8]
    str r6,[r14,#12]

    mov r7,#5
    mov r8,#7
    umlal r7,r8,r1,r2
    str r7,[r14,#16]
    str r8,[r14,#20]

    smull r9,r10,r1,r2
    str r9,[r14,#24]
    str r10,[r14,#28]

    mov r11,#5
    mov r12,#7
    smlal r11,r12,r1,r2
    str r11,[r14,#32]
    str r12,[r14,#36]

    @ MULS negative: MI must execute, EQ must not.
    mov r0,#0
    muls r3,r1,r2
    movmi r0,#0x55
    moveq r0,#0xee
    str r0,[r14,#40]

    @ MULS zero: EQ must execute.
    mov r1,#0
    muls r3,r1,r2
    moveq r0,#0x66
    str r0,[r14,#44]

    @ SMULLS -1*2 has bit63 set, so MI must execute.
    mvn r1,#0
    mov r0,#0
    smulls r5,r6,r1,r2
    movmi r0,#0x77
    str r0,[r14,#48]
    bx lr
"""

EXPECT = [
    0xFFFFFFFE, 0x00000001,
    0xFFFFFFFE, 0x00000001,
    0x00000003, 0x00000009,
    0xFFFFFFFE, 0xFFFFFFFF,
    0x00000003, 0x00000007,
    0x00000055, 0x00000066, 0x00000077,
]


def run(words, wd):
    body = open(CIRC).read()
    pos = 0
    while True:
        m = re.search(r'<comp lib="2"[^>]*name="ROM">.*?</comp>', body[pos:], re.S)
        if not m:
            break
        a, z = pos + m.start(), pos + m.end()
        rom = body[a:z]
        if 'val="32"' in rom:
            aw = int(re.search(r'addrWidth" val="(\d+)"', rom).group(1))
            new = re.sub(r'<a name="contents">.*?</a>',
                         '<a name="contents">addr/data: %d 32\n%s\n</a>'
                         % (aw, " ".join(words)), rom, flags=re.S)
            body = body[:a] + new + body[z:]
            pos = a + len(new)
        else:
            pos = z
    circ = os.path.join(wd, "debug_multiply_test.circ")
    ram = os.path.join(wd, "debug_multiply_ram.txt")
    open(circ, "w").write(body)
    cmd = ["xvfb-run", "-a", "java", "-jar", ps.JAR, "--tty", "halt",
           "--save", ram, "--toplevel-circuit", "main", circ]
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
    data = []
    if os.path.exists(ram):
        toks = []
        for line in open(ram):
            if line.startswith(("v2.0", "v3.0", "addr/data")):
                continue
            toks += line.split()
        data = [int(x, 16) for x in toks]
    return "halted due to halt pin" in (p.stdout+p.stderr), data, p.stdout+p.stderr


def main():
    with tempfile.TemporaryDirectory(prefix="debug_mul_") as wd:
        words = ps.assemble(ASM, wd)
        halted, ram, log = run(words, wd)
    bad = []
    if not halted:
        bad.append("did not halt cleanly")
    for k, want in enumerate(EXPECT):
        got = ram[k] if k < len(ram) else 0
        if got != want:
            bad.append("RAM[%02x] got %08x expected %08x" % (k, got, want))
    if bad:
        print("[FAIL] multiply family")
        for x in bad: print("   ", x)
        if "error" in log.lower() or "oscillation" in log.lower(): print(log[-3000:])
        return 1
    print("[PASS] MUL MLA UMULL UMLAL SMULL SMLAL")
    print("[PASS] 64-bit accumulate carry and signed high halves")
    print("[PASS] MULS/SMULLS N/Z condition behavior")
    print("13/13 result words correct")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
