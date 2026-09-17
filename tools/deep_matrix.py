#!/usr/bin/env python3
"""The areas nothing else covers.

`tools/edge_matrix.py` is 82% one instruction form and checks no flags, no
memory, no block transfer and no control flow.  `tests/adversarial_regression`
checks condition EVALUATION but never whether NZCV were set correctly to begin
with.  This fills those gaps.

Every expected value is computed from the ARM ARM here, by hand.  Flags are
read one cycle after the instruction that sets them, because CPSR is a
REGISTERED output -- reading them on the same row was a real bug in an earlier
suite and made three correct results look broken.

    python3 tools/deep_matrix.py [circuit.circ]
"""
import os, sys

ROOT = "/home/junaet/Documents/CustomCPU"
sys.path.insert(0, ROOT)
import tools.pysim as P

CIRC = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "debug_armv4t_2.circ")
MASK = 0xFFFFFFFF
counts, failures = {}, []


def record(group, name, got, want, note=""):
    p, t = counts.get(group, (0, 0))
    ok = got == want
    counts[group] = (p + int(ok), t + 1)
    if not ok:
        failures.append((group, name, got, want, note))
    return ok


def run(lines, cycles=400):
    asm = ".syntax unified\n.arm\n" + "\n".join(lines) + "\n    bx lr\n"
    rows, words, s = P.run(asm, max_cycles=cycles, path=CIRC)
    return rows, words, s


def regs(s):
    return {n: s.find("reg16x32_1:R%d.Q" % n)[0][1] & MASK for n in range(16)}


def flags_after(lines):
    """NZCV one cycle after the LAST instruction in `lines`.

    Located by position, not by a hardcoded pc: `ldr rN,=const` expands to an
    instruction PLUS a literal-pool word, so instruction addresses do not
    match source line numbers.  Hardcoding the pc made all 196 flag cases
    return None -- a defect in this file, not in the CPU.

    The program is always `setup..., <flag op>, bx lr`, so the flag op is the
    second-to-last executed row and its flags land on the last one.
    """
    rows, words, s = run(lines)
    if len(rows) < 2:
        return None
    v = rows[-1]["cpsr"]
    return ((v >> 3) & 1, (v >> 2) & 1, (v >> 1) & 1, v & 1)


def lit(rd, value):
    return "    ldr r%d, =0x%08x" % (rd, value & MASK)


# ---------------------------------------------------------------- 1. FLAGS
# ARM: C is the carry OUT of the adder for ADD/CMN, and NOT-borrow for
# SUB/CMP.  V is signed overflow.  Z is result==0.  N is result[31].
def add_flags(a, b, cin=0):
    r = (a + b + cin) & MASK
    c = 1 if (a + b + cin) > MASK else 0
    v = 1 if (((a ^ r) & (b ^ r)) >> 31) & 1 else 0
    return ((r >> 31) & 1, int(r == 0), c, v)


def sub_flags(a, b):
    r = (a - b) & MASK
    c = 1 if a >= b else 0                       # NOT borrow
    v = 1 if (((a ^ b) & (a ^ r)) >> 31) & 1 else 0
    return ((r >> 31) & 1, int(r == 0), c, v)


FLAG_VALS = [0, 1, 2, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 0x55555555]

for a in FLAG_VALS:
    for b in FLAG_VALS:
        got = flags_after([lit(0, a), lit(1, b), "    adds r2,r0,r1"])
        record("flags-adds", "adds %08x,%08x" % (a, b), got, add_flags(a, b))
        got = flags_after([lit(0, a), lit(1, b), "    subs r2,r0,r1"])
        record("flags-subs", "subs %08x,%08x" % (a, b), got, sub_flags(a, b))
        got = flags_after([lit(0, a), lit(1, b), "    cmp r0,r1"])
        record("flags-cmp", "cmp %08x,%08x" % (a, b), got, sub_flags(a, b))
        got = flags_after([lit(0, a), lit(1, b), "    cmn r0,r1"])
        record("flags-cmn", "cmn %08x,%08x" % (a, b), got, add_flags(a, b))

# Logical ops: N and Z from the result, V unchanged, C from the shifter.
# Set C=1 first with a known CMP, then check the logical op preserves it.
for a, b in [(0xF0F0F0F0, 0x0F0F0F0F), (0xFFFFFFFF, 0xFFFFFFFF),
             (0, 0xFFFFFFFF), (0x80000000, 0xFFFFFFFF)]:
    for op, fn in (("ands", lambda x, y: x & y), ("orrs", lambda x, y: x | y),
                   ("eors", lambda x, y: x ^ y), ("bics", lambda x, y: x & ~y)):
        r = fn(a, b) & MASK
        got = flags_after([lit(3, 5), "    cmp r3,#1",          # C=1, V=0
                           lit(0, a), lit(1, b), "    %s r2,r0,r1" % op])
        record("flags-logical", "%s %08x,%08x" % (op, a, b), got,
               ((r >> 31) & 1, int(r == 0), 1, 0),
               "C must be preserved (no shift), V unchanged")

# TST / TEQ set N,Z only
for a, b in [(0xF0, 0x0F), (0xFF, 0xFF), (0x80000000, 0x80000000)]:
    r = a & b
    got = flags_after([lit(3, 5), "    cmp r3,#1", lit(0, a), lit(1, b),
                       "    tst r0,r1"])
    record("flags-logical", "tst %08x,%08x" % (a, b), got,
           ((r >> 31) & 1, int(r == 0), 1, 0))

# ------------------------------------------------------- 2. MEMORY EDGES
MEM = []
def mem(name, lines, want_reg, want, note=""):
    MEM.append((name, lines, want_reg, want, note))

mem("byte lane 0", [lit(1, 0x1100), "    mov r2,#0xAB", "    strb r2,[r1]",
                    "    ldrb r0,[r1]"], 0, 0xAB)
mem("byte lane 1 isolated", [lit(1, 0x1100), "    mov r2,#0x11", "    strb r2,[r1]",
     "    mov r2,#0x22", "    strb r2,[r1,#1]", "    ldrb r0,[r1]"], 0, 0x11,
    "writing lane 1 must not disturb lane 0")
mem("strb truncates", [lit(1, 0x1100), lit(2, 0x1FF), "    strb r2,[r1]",
                       "    ldrb r0,[r1]"], 0, 0xFF)
mem("ldrb zero-extends", [lit(1, 0x1100), lit(2, 0xFFFFFF80), "    str r2,[r1]",
                          "    ldrb r0,[r1]"], 0, 0x80)
mem("halfword store/load", [lit(1, 0x1100), lit(2, 0xABCD), "    strh r2,[r1]",
                            "    ldrh r0,[r1]"], 0, 0xABCD)
mem("ldrsb sign-extends", [lit(1, 0x1100), lit(2, 0xFF), "    strb r2,[r1]",
                           "    ldrsb r0,[r1]"], 0, 0xFFFFFFFF)
mem("ldrsh sign-extends", [lit(1, 0x1100), lit(2, 0x8000), "    strh r2,[r1]",
                           "    ldrsh r0,[r1]"], 0, 0xFFFF8000)
mem("reg offset LOAD is not ignored", [lit(1, 0x1100), lit(4, 0x1110),
     lit(2, 0xAA), "    str r2,[r1]", lit(2, 0xBB), "    str r2,[r4]",
     "    mov r3,#16", "    ldr r0,[r1,r3]"], 0, 0xBB,
    "0xAA here means the offset was dropped and the base was used")
mem("reg offset STORE is not ignored", [lit(1, 0x1100), "    mov r3,#16",
     lit(2, 0xCC), "    str r2,[r1,r3]", "    ldr r0,[r1,#16]"], 0, 0xCC,
    "read back through the IMMEDIATE form, so a dropped offset shows up")
mem("scaled reg offset lsl#2", [lit(1, 0x1100), "    mov r3,#3", lit(2, 0xCC),
     "    str r2,[r1,#12]", "    ldr r0,[r1,r3,lsl #2]"], 0, 0xCC)
mem("negative reg offset", [lit(1, 0x1110), "    mov r3,#16", lit(2, 0x5A),
     lit(4, 0x1100), "    str r2,[r4]", "    ldr r0,[r1,-r3]"], 0, 0x5A)
mem("pre-index writeback", [lit(1, 0x1100), lit(2, 0x77),
     "    str r2,[r1,#8]!", "    mov r0,r1"], 0, 0x1108)
mem("post-index leaves base then adds", [lit(1, 0x1100), lit(2, 0x88),
     "    str r2,[r1],#4", lit(3, 0x1100), "    ldr r0,[r3]"], 0, 0x88)
mem("swp word", [lit(1, 0x1100), lit(2, 0xAA), "    str r2,[r1]",
                 lit(3, 0xBB), "    swp r0,r3,[r1]"], 0, 0xAA)
mem("ldr/str round trip 0xFFFFFFFF", [lit(1, 0x1100), lit(2, 0xFFFFFFFF),
     "    str r2,[r1]", "    ldr r0,[r1]"], 0, 0xFFFFFFFF)

for name, lines, wr, want, note in MEM:
    try:
        rows, words, s = run(lines)
        got = regs(s)[wr]
    except Exception as e:
        got = -1
    record("memory", name, got, want, note)

# ------------------------------------------------- 3. BLOCK TRANSFER EDGES
BLK = []
def blk(name, lines, checks, note=""):
    BLK.append((name, lines, checks, note))

blk("stm does not clobber Rd-field reg",
    [lit(4, 0x1100), "    mov r1,#0x11", "    mov r2,#0x22", "    mov r0,#0x99",
     "    stmia r4!,{r1,r2}"], {0: 0x99},
    "instr[15:12]=0, so a boundary write lands on r0")
blk("ldm does not clobber Rd-field reg",
    [lit(4, 0x1100), "    mov r1,#0x31", "    mov r2,#0x32", "    str r1,[r4]",
     "    str r2,[r4,#4]", "    mov r0,#0x99", "    ldmia r4!,{r6,r7}"],
    {0: 0x99, 6: 0x31, 7: 0x32})
blk("single register stm/ldm",
    [lit(4, 0x1100), "    mov r1,#0x5A", "    stmia r4!,{r1}", "    mov r1,#0",
     lit(5, 0x1100), "    ldmia r5!,{r1}"], {1: 0x5A, 4: 0x1104, 5: 0x1104})
blk("base register inside the list (store)",
    [lit(4, 0x1100), "    mov r1,#0x11", "    stmia r4!,{r1,r4}",
     lit(5, 0x1100), "    ldr r0,[r5,#4]"], {0: 0x1100},
    "STM with base in list stores the ORIGINAL base")
blk("all low registers round trip",
    [lit(8, 0x1100)] + ["    mov r%d,#%d" % (i, i) for i in range(8)] +
    ["    stmia r8!,{r0-r7}"] + ["    mov r%d,#0" % i for i in range(8)] +
    [lit(9, 0x1100), "    ldmia r9!,{r0-r7}"],
    {i: i for i in range(8)})
blk("stmdb/ldmdb pair",
    [lit(4, 0x1120), "    mov r1,#0x41", "    mov r2,#0x42", "    stmdb r4!,{r1,r2}",
     "    mov r1,#0", "    mov r2,#0", "    ldmia r4!,{r1,r2}"],
    {1: 0x41, 2: 0x42})
blk("conditional block transfer suppressed",
    [lit(4, 0x1100), "    mov r1,#0x11", "    mov r0,#0", "    cmp r0,#1",
     "    stmiaeq r4!,{r1}", "    mov r0,r4"], {0: 0x1100},
    "EQ is false, so the base must NOT advance")

for name, lines, checks, note in BLK:
    try:
        rows, words, s = run(lines)
        R = regs(s)
        ok = all(R[k] == v for k, v in checks.items())
        bad = next(("r%d=%08x want %08x" % (k, R[k], v)
                    for k, v in checks.items() if R[k] != v), "")
    except Exception as e:
        ok, bad = False, str(e)[:40]
    p, t = counts.get("block", (0, 0))
    counts["block"] = (p + int(ok), t + 1)
    if not ok:
        failures.append(("block", name, bad, "", note))

# ------------------------------------------------- 4. CONTROL FLOW EDGES
CF = []
def cf(name, lines, checks, note=""):
    CF.append((name, lines, checks, note))

cf("backward branch loop x3",
   ["    mov r0,#0", "    mov r1,#3", "lp:", "    add r0,r0,#10",
    "    subs r1,r1,#1", "    bne lp"], {0: 30, 1: 0})
cf("nested bl / lr save",
   ["    mov r0,#0", "    bl f1", "    add r0,r0,#1", "    b done",
    "f1:", "    push {lr}", "    bl f2", "    pop {lr}", "    add r0,r0,#10",
    "    mov pc,lr",
    "f2:", "    add r0,r0,#100", "    mov pc,lr",
    "done:"], {0: 111}, "requires lr save/restore across a nested call")
cf("conditional branch not taken falls through",
   ["    mov r0,#5", "    cmp r0,#5", "    bne away", "    mov r1,#7",
    "    b end", "away:", "    mov r1,#99", "end:"], {1: 7})
cf("b to the very next instruction",
   ["    mov r0,#1", "    b nxt", "nxt:", "    add r0,r0,#1"], {0: 2})
cf("ldr pc redirect",
   ["    mov r0,#1", lit(1, 0x1100), "    adr r2,tgt", "    str r2,[r1]",
    "    ldr pc,[r1]", "    mov r0,#99", "tgt:", "    mov r0,#7"], {0: 7})
cf("pc as operand reads +8",
   ["    mov r0,pc", "    mov r1,pc"], {0: 8, 1: 12})
cf("add to pc computed jump",
   ["    mov r0,#1", "    add pc,pc,#4", "    mov r0,#99", "    mov r0,#5",
    "    mov r0,#7"], {0: 7},
   "pc reads +8, so at word 1 the target is word (1*4+8+4)/4 = 4")

for name, lines, checks, note in CF:
    try:
        rows, words, s = run(lines)
        R = regs(s)
        ok = all(R[k] == v for k, v in checks.items())
        bad = next(("r%d=%08x want %08x" % (k, R[k], v)
                    for k, v in checks.items() if R[k] != v), "")
        if not rows[-1]["bx_taken"]:
            ok, bad = False, "never halted"
    except Exception as e:
        ok, bad = False, str(e)[:40]
    p, t = counts.get("control", (0, 0))
    counts["control"] = (p + int(ok), t + 1)
    if not ok:
        failures.append(("control", name, bad, "", note))

# --------------------------------------------------------- 5. REPORT
print("deep matrix   circuit=%s\n" % os.path.basename(CIRC))
tot_p = tot_t = 0
for g in sorted(counts):
    p, t = counts[g]
    tot_p += p; tot_t += t
    print("  %-16s %4d/%-4d %s" % (g, p, t, "" if p == t else "<-- %d failing" % (t - p)))
print("  %-16s %4d/%-4d" % ("TOTAL", tot_p, tot_t))

if failures:
    print("\nfailures (first 40):")
    cur = None
    for g, name, got, want, note in failures[:40]:
        if g != cur:
            print("\n  --- %s ---" % g); cur = g
        if want == "":
            print("    %-42s %s" % (name, got))
        else:
            print("    %-42s got=%s want=%s" % (name, got, want))
        if note:
            print("        %s" % note)

sys.exit(1 if tot_p != tot_t else 0)
