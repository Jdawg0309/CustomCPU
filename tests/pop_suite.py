#!/usr/bin/env python3
"""POP discriminator suite. Most cases push one register set and pop into a
DIFFERENT set, which proves the destination is chosen by the pop list rather
than left over from before -- a same-register roundtrip cannot show that."""
import sys, os, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps
ps.CIRC = sys.argv[1] if len(sys.argv) > 1 else "/home/junaet/Documents/CustomCPU/debug_armv4t.circ"
# ROM owns 0x0000-0x0FFF, so both the stack and the result area have to sit
# above ps.RAM_BASE.  The dumper keys RAM by word index from that base.
BASE = ps.RAM_BASE + 0x200      # 0x1200
SP0  = ps.RAM_BASE + 0x100      # 0x1100

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
 ("two_low->two_other",  SP0, [0,1],       [0xAA,0xBB],           [2,3],       False),
 ("high->high",          SP0, [8,9],       [0x88,0x99],           [6,7],       False),
 ("scattered",           SP0, [0,5,9],     [0x11,0x55,0x99],      [1,6,10],    False),
 ("callee+LR",           SP0, [4,14],      [0x44,0x88],           [5,6],       False),
 ("five_regs",           SP0, [0,1,2,3,4], [0x10,0x11,0x12,0x13,0x14],[5,6,7,8,9],False),
 ("roundtrip_same",      SP0, [0,1],       [0xAA,0xBB],           [0,1],       True),
 ("roundtrip_high",      SP0, [9,10],      [0x99,0xA0],           [9,10],      True),
]

fails = 0
for name, sp, src, vals, dst, clear in TESTS:
    with tempfile.TemporaryDirectory() as wd:
        words = ps.assemble(build(sp, src, vals, dst, clear), wd)
        halted, osc, ram = ps.run_rom(words, wd)
        exp = dict(zip(sorted(dst), [v for _, v in sorted(zip(src, vals))]))
        bad = []
        for k, r in enumerate(sorted(dst)):
            got = ram.get((BASE - ps.RAM_BASE)//4 + k, "00000000"); want = "%08x" % exp[r]
            if got != want: bad.append(f"r{r}={got} want {want}")
        gotsp = ram.get((BASE - ps.RAM_BASE)//4 + len(dst), "00000000")
        if gotsp != "%08x" % sp: bad.append(f"sp={gotsp} want {sp:08x}")
        if not halted: bad.append("no clean halt")
        if osc: bad.append("OSCILLATION")
        ok = not bad
        fails += 0 if ok else 1
        print(f"[{'PASS' if ok else 'FAIL'}] {name:<22} ({len(words)} words)"
              + ("" if ok else "  " + "; ".join(bad)))
print(f"\n{len(TESTS)-fails}/{len(TESTS)} passed")
