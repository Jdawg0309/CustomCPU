#!/usr/bin/env python3
"""POP discriminator suite. Most cases push one register set and pop into a
DIFFERENT set, which proves the destination is chosen by the pop list rather
than left over from before -- a same-register roundtrip cannot show that."""
import sys, os, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps
ps.CIRC = "/home/junaet/Documents/CustomCPU/armv4t.circ"
BASE = 512   # 0x200 result area

def build(sp, src_regs, vals, dst_regs, clear):
    L = [".syntax unified", ".arm", ".global _start", "_start:", f"    mov sp, #{sp}"]
    for r, v in zip(src_regs, vals): L.append(f"    mov r{r}, #{v}")
    L.append("    push {" + ",".join(f"r{r}" for r in sorted(src_regs)) + "}")
    if clear:
        for r in src_regs: L.append(f"    mov r{r}, #0")
    L.append("    pop {" + ",".join(f"r{r}" for r in sorted(dst_regs)) + "}")
    L.append(f"    mov r11, #{BASE}")
    for k, r in enumerate(sorted(dst_regs)): L.append(f"    str r{r}, [r11, #{4*k}]")
    L.append(f"    str r13, [r11, #{4*len(dst_regs)}]")
    L.append("    bx lr")
    return "\n".join(L) + "\n"

TESTS = [
 ("two_low->two_other",  256, [0,1],       [0xAA,0xBB],           [2,3],       False),
 ("high->high",          256, [8,9],       [0x88,0x99],           [6,7],       False),
 ("scattered",           256, [0,5,9],     [0x11,0x55,0x99],      [1,6,10],    False),
 ("callee+LR",           256, [4,14],      [0x44,0x88],           [5,6],       False),
 ("five_regs",           256, [0,1,2,3,4], [0x10,0x11,0x12,0x13,0x14],[5,6,7,8,9],False),
 ("roundtrip_same",      256, [0,1],       [0xAA,0xBB],           [0,1],       True),
 ("roundtrip_high",      256, [9,10],      [0x99,0xA0],           [9,10],      True),
]

fails = 0
for name, sp, src, vals, dst, clear in TESTS:
    with tempfile.TemporaryDirectory() as wd:
        words = ps.assemble(build(sp, src, vals, dst, clear), wd)
        halted, osc, ram = ps.run_rom(words, wd)
        exp = dict(zip(sorted(dst), [v for _, v in sorted(zip(src, vals))]))
        bad = []
        for k, r in enumerate(sorted(dst)):
            got = ram.get(BASE//4 + k, "00000000"); want = "%08x" % exp[r]
            if got != want: bad.append(f"r{r}={got} want {want}")
        gotsp = ram.get(BASE//4 + len(dst), "00000000")
        if gotsp != "%08x" % sp: bad.append(f"sp={gotsp} want {sp:08x}")
        if not halted: bad.append("no clean halt")
        if osc: bad.append("OSCILLATION")
        ok = not bad
        fails += 0 if ok else 1
        print(f"[{'PASS' if ok else 'FAIL'}] {name:<22} ({len(words)} words)"
              + ("" if ok else "  " + "; ".join(bad)))
print(f"\n{len(TESTS)-fails}/{len(TESTS)} passed")
