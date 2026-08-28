#!/usr/bin/env python3
"""Hard regression suite for the block-transfer stack.

Goes after cases the earlier suites never touched: LIFO nesting, interleaving
with ordinary LDR/STR, three-deep sequential push/pop, register preservation
outside the list, LR save/restore, boundary values, and stray RAM writes.

Every program is checked for (a) the exact expected result words, (b) SP, and
(c) that NO RAM word outside the declared allow-set was written.
"""
import sys, os, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps

ps.CIRC = sys.argv[1] if len(sys.argv) > 1 else "/home/junaet/Documents/CustomCPU/debug_armv4t.circ"
# Every address here is a REAL byte address in the new memory map: ROM owns
# 0x0000-0x0FFF and RAM starts at ps.RAM_BASE (0x1000).  The dumper keys RAM
# by word index from the base, so w() has to subtract it.
STACK_TOP = ps.RAM_BASE + 0x100      # 0x1100
RAM_TOP   = ps.RAM_BASE + 0x400      # 0x1400, one past the last RAM word
SCRATCH   = ps.RAM_BASE + 0x300      # 0x1300, clear of stack and results
R = ps.RAM_BASE + 0x200              # result area, 0x1200
def w(byte_addr): return (byte_addr - ps.RAM_BASE) // 4

TESTS = []
def T(name, lines, expect, allow_extra=()):
    TESTS.append((name, lines, expect, set(allow_extra)))

# --- LIFO nesting: inner pop must return the inner push -----------------
T("nested_lifo", [
    "    mov sp, #0x1100", "    mov r0, #17", "    mov r1, #34", "    push {r0,r1}",
    "    mov r2, #51", "    mov r3, #68", "    push {r2,r3}",
    "    pop {r4,r5}", "    pop {r6,r7}", "    mov r11, #0x1200",
    "    str r4, [r11]", "    str r5, [r11, #4]",
    "    str r6, [r11, #8]", "    str r7, [r11, #12]", "    str r13, [r11, #16]"],
  {w(R):0x33, w(R+4):0x44, w(R+8):0x11, w(R+12):0x22, w(R+16):STACK_TOP},
  allow_extra=[w(STACK_TOP-8), w(STACK_TOP-4), w(STACK_TOP-16), w(STACK_TOP-12)])

# --- ordinary loads/stores interleaved with a live stack frame ----------
T("interleave_mem", [
    "    mov sp, #0x1100", "    mov r0, #170", "    push {r0}",
    "    mov r1, #0x1300", "    mov r2, #85", "    str r2, [r1]", "    ldr r3, [r1]",
    "    pop {r4}", "    mov r11, #0x1200",
    "    str r3, [r11]", "    str r4, [r11, #4]", "    str r13, [r11, #8]"],
  {w(R):0x55, w(R+4):0xAA, w(R+8):STACK_TOP, w(SCRATCH):0x55},
  allow_extra=[w(STACK_TOP-4)])

# --- three sequential single pushes, then three pops --------------------
T("triple_sequential", [
    "    mov sp, #0x1100", "    mov r0, #1", "    push {r0}",
    "    mov r0, #2", "    push {r0}", "    mov r0, #3", "    push {r0}",
    "    pop {r1}", "    pop {r2}", "    pop {r3}", "    mov r11, #0x1200",
    "    str r1, [r11]", "    str r2, [r11, #4]",
    "    str r3, [r11, #8]", "    str r13, [r11, #12]"],
  {w(R):3, w(R+4):2, w(R+8):1, w(R+12):STACK_TOP},
  allow_extra=[w(STACK_TOP-4), w(STACK_TOP-8), w(STACK_TOP-12)])

# --- registers NOT in the list must survive untouched -------------------
T("preserves_others", [
    "    mov sp, #0x1100", "    mov r5, #90", "    mov r0, #1", "    mov r1, #2",
    "    push {r0,r1}", "    pop {r2,r3}", "    mov r11, #0x1200",
    "    str r5, [r11]", "    str r2, [r11, #4]",
    "    str r3, [r11, #8]", "    str r13, [r11, #12]"],
  {w(R):0x5A, w(R+4):1, w(R+8):2, w(R+12):STACK_TOP},
  allow_extra=[w(STACK_TOP-8), w(STACK_TOP-4)])

# --- function prologue/epilogue shape: callee-saved + LR -----------------
T("lr_call_pattern", [
    "    mov sp, #0x1100", "    mov r14, #153", "    mov r4, #68",
    "    push {r4,r14}", "    mov r4, #0", "    mov r14, #0",
    "    pop {r4,r14}", "    mov r11, #0x1200",
    "    str r4, [r11]", "    str r14, [r11, #4]", "    str r13, [r11, #8]"],
  {w(R):0x44, w(R+4):0x99, w(R+8):STACK_TOP},
  allow_extra=[w(STACK_TOP-8), w(STACK_TOP-4)])

# --- boundary values through the whole path -----------------------------
T("zero_and_all_ones", [
    "    mov sp, #0x1100", "    mov r0, #0", "    mvn r1, #0",
    "    push {r0,r1}", "    pop {r2,r3}", "    mov r11, #0x1200",
    "    str r2, [r11]", "    str r3, [r11, #4]", "    str r13, [r11, #8]"],
  {w(R+4):0xFFFFFFFF, w(R+8):STACK_TOP},          # r2==0 is omitted by the dumper
  allow_extra=[w(STACK_TOP-8), w(STACK_TOP-4)])

# --- stack at the very top of RAM ---------------------------------------
T("stack_at_ram_top", [
    "    mov sp, #0x1400", "    mov r0, #119", "    mov r14, #187",
    "    push {r0,r14}", "    pop {r1,r2}", "    mov r11, #0x1200",
    "    str r1, [r11]", "    str r2, [r11, #4]", "    str r13, [r11, #8]"],
  {w(R):0x77, w(R+4):0xBB, w(R+8):RAM_TOP},
  allow_extra=[w(RAM_TOP-8), w(RAM_TOP-4)])

# --- high registers only -------------------------------------------------
T("high_regs_only", [
    "    mov sp, #0x1100", "    mov r8, #136", "    mov r9, #153",
    "    mov r10, #160", "    push {r8,r9,r10}", "    pop {r5,r6,r7}",
    "    mov r11, #0x1200", "    str r5, [r11]", "    str r6, [r11, #4]",
    "    str r7, [r11, #8]", "    str r13, [r11, #12]"],
  {w(R):0x88, w(R+4):0x99, w(R+8):0xA0, w(R+12):STACK_TOP},
  allow_extra=[w(STACK_TOP-12), w(STACK_TOP-8), w(STACK_TOP-4)])

fails = 0
for name, lines, expect, allow in TESTS:
    asm = "\n".join([".syntax unified", ".arm", ".global _start", "_start:"]
                    + lines + ["    bx lr"]) + "\n"
    with tempfile.TemporaryDirectory() as wd:
        words = ps.assemble(asm, wd)
        halted, osc, ram = ps.run_rom(words, wd)
    bad = []
    for a, v in sorted(expect.items()):
        got = ram.get(a, "00000000")
        if got != "%08x" % v: bad.append(f"RAM[{a:02x}]={got} want {v:08x}")
    stray = [a for a in ram if a not in expect and a not in allow]
    for a in sorted(stray): bad.append(f"stray write RAM[{a:02x}]={ram[a]}")
    if not halted: bad.append("no clean halt")
    if osc: bad.append("OSCILLATION")
    ok = not bad
    fails += 0 if ok else 1
    print(f"[{'PASS' if ok else 'FAIL'}] {name:<20} ({len(words)} words)"
          + ("" if ok else "\n        " + "\n        ".join(bad)))
print(f"\n{len(TESTS)-fails}/{len(TESTS)} passed")
sys.exit(1 if fails else 0)
