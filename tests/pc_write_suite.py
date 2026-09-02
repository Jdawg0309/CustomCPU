#!/usr/bin/env python3
"""PC-write discriminator suite: `pop {..., pc}` and friends.

Two independent things can go wrong on a block transfer that writes r15, and
each test here pins down both:

  1. Did the PC actually redirect?  A landing pad stores marker 2; the
     fall-through path stores marker 1.  The stored VALUE names the path taken
     -- nothing is inferred from register state.

  2. Did SP write back correctly?  Both paths store to [sp,#-64], so the
     ADDRESS of the marker reports the final SP.  A stack that over-steps by
     one word moves the marker from 0xc0 to 0xc4, and the test fails.

The landing-pad address is materialised with MOV-immediate, never `ldr =label`:
PC-relative literal loads are a known-broken path in this core and would
confound the result.  Its value comes from a first assembly pass and is patched
in; `mov rX,#N` is one word for any N, so instruction offsets do not shift.
"""
import os, subprocess, sys, tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from push_suite import assemble, run_rom

AS = "arm-none-eabi-as"
NM = "arm-none-eabi-nm"
SP_INIT      = 256          # 0x100
MARKER_SLOT  = SP_INIT - 64 # 0xc0 -- only correct if SP is restored exactly


def template(setup, pushlist, poplist, land):
    return """.syntax unified
.arm
.global _start
_start:
    mov sp, #%d
    mov lr, #%d
%s    push {%s}
    pop  {%s}
    mov r7, #1
    str r7, [sp, #-64]
    bx  lr
LAND:
    mov r7, #2
    str r7, [sp, #-64]
    bx  lr
""" % (SP_INIT, land, setup, pushlist, poplist)


def land_addr(asm, wd):
    src = os.path.join(wd, "p.S"); obj = os.path.join(wd, "p.o")
    open(src, "w").write(asm)
    subprocess.run([AS, "-march=armv4t", "-o", obj, src], check=True)
    for line in subprocess.run([NM, obj], capture_output=True, text=True).stdout.splitlines():
        val, _, name = line.split()
        if name == "LAND":
            return int(val, 16)
    raise RuntimeError("no LAND symbol")


CASES = [
    ("pop {pc}",       "",                                    "lr",             "pc"),
    ("pop {r2,pc}",    "    mov r2, #0x22\n",                 "r2,lr",          "r2,pc"),
    ("pop {r1,r2,pc}", "    mov r1, #0x11\n    mov r2, #0x22\n",
                                                              "r1,r2,lr",       "r1,r2,pc"),
    ("pop {r0-r3,pc}", "".join("    mov r%d, #0x1%d\n" % (i, i) for i in range(4)),
                                                              "r0,r1,r2,r3,lr", "r0,r1,r2,r3,pc"),
]


def main():
    npass = 0
    for name, setup, pushl, popl in CASES:
        with tempfile.TemporaryDirectory() as wd:
            addr = land_addr(template(setup, pushl, popl, 0), wd)
            words = assemble(template(setup, pushl, popl, addr), wd)
            halted, osc, ram = run_rom(words, wd)

        markers = {a * 4: int(v, 16) for a, v in ram.items() if int(v, 16) in (1, 2)}
        notes = []
        if not halted: notes.append("no clean halt")
        if osc:        notes.append("OSCILLATION")
        if not markers:
            notes.append("marker never stored")
        else:
            addr_got = sorted(markers)[0]
            if markers[addr_got] != 2:
                notes.append("fell through (PC never redirected)")
            if addr_got != MARKER_SLOT:
                notes.append("SP wrong: marker at %#x, expected %#x (SP off by %+d)"
                             % (addr_got, MARKER_SLOT, addr_got - MARKER_SLOT))
        ok = not notes
        npass += ok
        print("[%s] %-16s %s" % ("PASS" if ok else "FAIL", name, "; ".join(notes)))
    print("\n%d/%d passed" % (npass, len(CASES)))
    return 0 if npass == len(CASES) else 1


if __name__ == "__main__":
    sys.exit(main())
