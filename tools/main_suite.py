#!/usr/bin/env python3
"""Discriminators run through the REAL top level.

`tools/pysim.py` elaborates `main` out of the file, so what these exercise is
the wiring in `main` itself -- not a Python reconstruction of it.  Every
expected value is computed from the ARM ARM by hand here and never read off the
circuit, and each case is chosen so a crossed net changes the answer.

    python3 tools/main_suite.py [case-name-substring]
"""
import sys, os
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
import tools.pysim as P

CIRC = P.CIRC

CASES = []
def case(name, asm, regs=None, ram=None, cycles=None, note=""):
    CASES.append((name, asm, regs or {}, ram or {}, cycles, note))

# --- the ID->EX operand paths -------------------------------------------
case("dataproc_rd_a/rd_b", """
    mov r0,#20
    mov r1,#6
    sub r2,r0,r1
    rsb r3,r0,r1
    bx  lr
""", regs={2: 14, 3: 0xFFFFFFF2},
     note="SUB and RSB swap the operands: catches RD_A/RD_B transposed")

# --- ID.rs -> EX.rot : the one cross-named net --------------------------
case("imm_rotate", """
    mov r0,#0x1F000000
    mov r1,#0xFF
    bx  lr
""", regs={0: 0x1F000000, 1: 0xFF},
     note="0x1F000000 needs rot!=0; if ROT were tied low the value collapses")

# --- EX -> IF branch nets ----------------------------------------------
case("branch_forward", """
    mov r0,#1
    b   skip
    mov r0,#99
skip:
    mov r1,#2
    bx  lr
""", regs={0: 1, 1: 2},
     note="r0==99 means BR_TAKEN/BR_OFF never reached IF")

case("cond_branch_not_taken", """
    mov r0,#5
    cmp r0,#5
    bne away
    mov r1,#7
    bx  lr
away:
    mov r1,#99
    bx  lr
""", regs={1: 7},
     note="needs CPSR inside EX and CONDPASS; discriminates NE vs always")

case("cond_exec_suppressed", """
    mov r0,#0
    cmp r0,#1
    moveq r1,#0xAA
    movne r2,#0xBB
    bx  lr
""", regs={1: 0, 2: 0xBB},
     note="CONDPASS must gate the writeback, not just the branch")

# --- EX -> ID  BL_TAKEN, and WB -> ID  WD/WE ----------------------------
case("bl_link_and_return", """
    mov r0,#3
    bl  sub1
    mov r2,#9
    bx  lr
sub1:
    mov r1,#4
    mov pc,lr
""", regs={0: 3, 1: 4, 2: 9},
     note="r2==9 only if lr was written (BL_TAKEN->ID) and mov pc,lr returned")

# --- IF.pc_plus4 -> WB, and WB -> IF.wb_data ----------------------------
case("pc_reads_plus8", """
    mov r0,pc
    mov r1,pc
    bx  lr
""", regs={0: 8, 1: 12},
     note="PC reads as instr+8; catches PC_PLUS4/WD misrouting")

# --- MEM nets -----------------------------------------------------------
case("str_ldr_offset", """
    ldr r5,=0x1000
    mov r0,#0xAB
    str r0,[r5,#4]
    ldr r1,[r5,#4]
    ldr r2,[r5]
    bx  lr
""", regs={1: 0xAB, 2: 0},
     note="r2 must stay 0: proves the offset actually reached the address")

case("str_writeback_postindex", """
    ldr r5,=0x1000
    mov r0,#0x11
    mov r1,#0x22
    str r0,[r5],#4
    str r1,[r5],#4
    bx  lr
""", ram={0: 0x11, 1: 0x22},
     note="MEM_UP_BASE -> WB: base must advance between the two stores")

case("byte_access", """
    ldr r5,=0x1000
    mov r0,#0xFF
    orr r0,r0,#0x100
    strb r0,[r5]
    ldrb r1,[r5]
    bx  lr
""", regs={1: 0xFF},
     note="0x1FF truncates to 0xFF; a word path would give 0x1FF")

# --- block transfer: BT_ACTIVE / BT_REG_IDX / BT_DONE / HOLD_PC ---------
case("push_pop", """
    ldr sp,=0x1080
    mov r0,#0x11
    mov r1,#0x22
    mov r2,#0x33
    push {r0,r1,r2}
    mov r0,#0
    mov r1,#0
    mov r2,#0
    pop {r0,r1,r2}
    bx  lr
""", regs={0: 0x11, 1: 0x22, 2: 0x33},
     note="exercises every block-transfer net between MEM, ID, IF and WB")

case("stmia_ldmia", """
    ldr r5,=0x1000
    mov r0,#0xA
    mov r1,#0xB
    stmia r5!,{r0,r1}
    mov r0,#0
    mov r1,#0
    ldr r5,=0x1000
    ldmia r5!,{r0,r1}
    bx  lr
""", regs={0: 0xA, 1: 0xB, 5: 0x1008},
     note="r5==0x1008 proves the ! writeback came back through WA2/WD2/WE2")

# --- shifts: SH_AMT / SH_TYP / reg_shift / rs_value --------------------
case("shift_immediate", """
    mov r0,#1
    mov r1,r0,lsl #4
    mov r2,#0x80
    mov r3,r2,lsr #3
    bx  lr
""", regs={1: 0x10, 3: 0x10},
     note="two different shift types to the same answer: catches SH_TYP stuck")

case("shift_register", """
    mov r0,#1
    mov r4,#5
    mov r1,r0,lsl r4
    bx  lr
""", regs={1: 0x20},
     note="needs reg_shift AND rs_value, the two newest main nets")


# --- instr[4] must not reach the shifter for an IMMEDIATE operand ----------
# `add r2,r1,#0x10` encodes as e2802010: instr[25]=1 (immediate), yet
# instr[4]=1 because 0x10 has bit 4 set.  r0 is never named by the
# instruction, so changing it must not change the answer.
case("imm_bit4_not_a_shift", """
    mov r0,#40
    mov r1,#1
    add r2,r1,#0x10
    bx  lr
""", regs={2: 0x11},
     note="r0>=32 wrongly triggers the register-shift override; r0<32 hides it")


def _regs(s):
    return {n: s.find("reg16x32_1:R%d.Q" % n)[0][1] for n in range(16)}


def check(name, asm, want_r, want_ram, cycles, note):
    try:
        rows, words, s = P.run(asm, max_cycles=300, path=CIRC)
    except Exception as e:
        return False, "EXCEPTION %s" % e, None
    halted = bool(s.peek("EX.bx_taken"))
    r = _regs(s)
    ram = s.ram_dump()
    bad = []
    if not halted:
        bad.append("never halted (%d cycles)" % len(rows))
    for k, v in sorted(want_r.items()):
        if r.get(k) != v:
            bad.append("r%d=%08x want %08x" % (k, r.get(k, -1) & 0xFFFFFFFF, v))
    for k, v in sorted(want_ram.items()):
        if ram.get(k) != v:
            bad.append("ram[%d]=%s want %08x"
                       % (k, "%08x" % ram[k] if k in ram else "--", v))
    return not bad, "; ".join(bad), (rows, words, s)


def main():
    global CIRC
    args = [a for a in sys.argv[1:]]
    only = None
    for a in args:
        if a.endswith(".circ"):
            CIRC = a
        else:
            only = a
    print("circuit: %s\n" % os.path.basename(CIRC))
    npass = 0
    fails = []
    for name, asm, wr, wm, cy, note in CASES:
        if only and only not in name:
            continue
        ok, msg, ctx = check(name, asm, wr, wm, cy, note)
        print("[%s] %-26s %s" % ("PASS" if ok else "FAIL", name, "" if ok else msg))
        if ok:
            npass += 1
        else:
            fails.append((name, note, asm, ctx))
    print("\n%d/%d passed" % (npass, npass + len(fails)))
    for name, note, asm, ctx in fails:
        print("\n--- %s ---\n  %s" % (name, note))
        if ctx:
            rows, words, s = ctx
            print("  cy  pc   instr     wd        wa we pass bl bx")
            for i, r in enumerate(rows):
                pc = r["pc_word_addr"]
                print("  %2d  %-3d  %08x  %08x  %-2d %d  %d    %d  %d"
                      % (i, pc, words[pc] if pc < len(words) else 0, r["wd"],
                         r["wa"], r["we"], r["cond_pass"], r["bl_taken"], r["bx_taken"]))

    # A suite that reports failures and still exits 0 is a suite a script will
    # read as green.  Codex caught this one on me.
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
