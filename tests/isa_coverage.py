#!/usr/bin/env python3
"""Empirical ARMv4T ARM-state coverage probe.

Each case runs a tiny program that exercises one instruction and stores the
result to RAM, then checks the value. A case can come back:
  PASS  - executed and produced the architecturally correct result
  WRONG - executed but produced the wrong value
  HANG  - did not halt (usually: PC never reached the terminating BX)
  ASM   - the assembler rejected it (not a CPU result)
"""
import sys, os, subprocess, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps

ps.CIRC = sys.argv[1] if len(sys.argv) > 1 else "/home/junaet/Documents/CustomCPU/debug_armv4t.circ"
BASE = ps.RAM_BASE + 0x200      # a word well inside RAM

CASES = []
def C(group, name, body, expect):
    """body: lines leaving the result in r0. expect: 32-bit value or None."""
    CASES.append((group, name, body, expect))

# ---- data processing ----------------------------------------------------
# The ARM ARM leaves the CPSR condition flags UNPREDICTABLE coming out of
# reset, so a case whose architectural result contains a carry-in term has no
# defined expected value until it sets C itself. These two prologues do that
# using a scratch register (r12) whose own result is discarded, so the operands
# under test are untouched. `mov`/`mvn` without S do not disturb the flags, so
# the C set here survives to the instruction under test.
SETC1 = ["    mvn r12, #0", "    adds r12, r12, #1"]   # 0xFFFFFFFF + 1 -> C=1
SETC0 = ["    mov r12, #1", "    adds r12, r12, #1"]   # 1 + 1          -> C=0
dp = [("AND","and r0, r1, r2", 0x0F00_0000 & 0x0FF0_0000, []),
      ("EOR","eor r0, r1, r2", 0x0F00_0000 ^ 0x0FF0_0000, []),
      ("SUB","sub r0, r2, r1", 0x0FF0_0000 - 0x0F00_0000, []),
      ("RSB","rsb r0, r1, r2", 0x0FF0_0000 - 0x0F00_0000, []),
      ("ADD","add r0, r1, r2", 0x0F00_0000 + 0x0FF0_0000, []),
      # ADC = Rn + Op2 + C. With C=0 that is bit-for-bit ADD, so a core that
      # drops the carry-in entirely would pass an ADC case run with C=0. C is
      # forced to 1 here: the +1 is the ONLY thing separating ADC from ADD.
      ("ADC","adc r0, r1, r2", 0x0F00_0000 + 0x0FF0_0000 + 1, SETC1),
      # SBC/RSC compute Rn - Op2 - NOT(C). C is forced to 0, so NOT(C)=1 and
      # the -1 term below is what the case actually pins down.
      ("SBC","sbc r0, r2, r1", 0x0FF0_0000 - 0x0F00_0000 - 1, SETC0),
      ("RSC","rsc r0, r1, r2", 0x0FF0_0000 - 0x0F00_0000 - 1, SETC0),
      # The C=0 cases above cannot fail on a core that drops carry-in: with
      # NOT(C)=1 the answer is A-B-1 either way.  Repeat them with C=1, where
      # the correct answer is A-B and a dropped carry-in gives A-B-1.
      ("SBC C=1","sbc r0, r2, r1", 0x0FF0_0000 - 0x0F00_0000, SETC1),
      ("RSC C=1","rsc r0, r1, r2", 0x0FF0_0000 - 0x0F00_0000, SETC1),
      ("ORR","orr r0, r1, r2", 0x0F00_0000 | 0x0FF0_0000, []),
      ("BIC","bic r0, r2, r1", 0x0FF0_0000 & ~0x0F00_0000 & 0xFFFFFFFF, []),
      ("MOV","mov r0, r2",     0x0FF0_0000, []),
      ("MVN","mvn r0, r1",     (~0x0F00_0000) & 0xFFFFFFFF, [])]
for nm, ins, exp, setflags in dp:
    C("data-processing", nm,
      ["    mov r1, #0x0F000000", "    mov r2, #0x0FF00000"] + setflags + ["    " + ins], exp)
for nm, ins in [("CMP","cmp r1, r1"), ("TEQ","teq r1, r1")]:
    C("data-processing", nm + " sets Z",
      ["    mov r1, #4", "    " + ins, "    moveq r0, #1", "    movne r0, #0"], 1)
# CMN r1,r1 with r1=4 computes 4 + 4 = 8 (nonzero) -- Z is CLEARED, unlike
# CMP/TEQ above where r1 op r1 is always 0 regardless of r1's value. CMN
# needs an operand whose SUM with itself is 0: r1=0 does that trivially.
C("data-processing", "CMN sets Z",
  ["    mov r1, #0", "    cmn r1, r1", "    moveq r0, #1", "    movne r0, #0"], 1)
# TST r1,r1 with r1=4 computes 4 AND 4 = 4 (nonzero) -- Z is CLEARED, unlike
# CMP/TEQ above where r1 op r1 is always 0. Needs an operand whose AND
# with itself is 0: r1=0 does that trivially.
C("data-processing", "TST sets Z",
  ["    mov r1, #0", "    tst r1, r1", "    moveq r0, #1", "    movne r0, #0"], 1)

# ---- shifts -------------------------------------------------------------
# Shared setup is r1=4, r3=3; a row may override it. "LSR reg" must: with
# r1=4 the architectural result of 4 LSR 3 is 0, and 0 is also what a core
# that never executed the shift (or never stored anything) reports, so that
# oracle cannot fail. r1=32 makes the correct answer 4 -- a value only a
# working register-specified LSR can produce. (The previous expectation of 2
# was simply wrong: 2 is 4 LSR 1, not 4 LSR r3 with r3=3.)
SH = ["    mov r1, #4", "    mov r3, #3"]
for nm, ins, exp, setup in [("LSL imm","mov r0, r1, lsl #4", 0x40, SH),
                     ("LSR imm","mov r0, r1, lsr #2", 0x1, SH),
                     ("ASR imm","mov r0, r1, asr #1", 0x2, SH),
                     ("ROR imm","mov r0, r1, ror #4", 0x40000000, SH),
                     ("LSL reg","mov r0, r1, lsl r3", 0x20, SH),
                     ("LSR reg","mov r0, r1, lsr r3", 0x4,
                      ["    mov r1, #32", "    mov r3, #3"])]:
    C("shifter", nm, setup + ["    " + ins], exp)

# ---- multiply -----------------------------------------------------------
C("multiply", "MUL",   ["    mov r1, #7", "    mov r2, #6", "    mul r0, r1, r2"], 42)
C("multiply", "MLA",   ["    mov r1, #7", "    mov r2, #6", "    mov r3, #2",
                        "    mla r0, r1, r2, r3"], 44)
C("multiply", "UMULL", ["    mov r1, #7", "    mov r2, #6",
                        "    umull r0, r4, r1, r2"], 42)

# ---- memory -------------------------------------------------------------
C("memory", "LDR/STR word", ["    mov r1, #0x1100", "    mov r2, #170",
                             "    str r2, [r1]", "    ldr r0, [r1]"], 0xAA)
C("memory", "STRB/LDRB",    ["    mov r1, #0x1100", "    mov r2, #170",
                             "    strb r2, [r1]", "    ldrb r0, [r1]"], 0xAA)
C("memory", "STRH/LDRH",    ["    mov r1, #0x1100", "    mov r2, #170",
                             "    strh r2, [r1]", "    ldrh r0, [r1]"], 0xAA)
C("memory", "LDRSB",        ["    mov r1, #0x1100", "    mvn r2, #0",
                             "    strb r2, [r1]", "    ldrsb r0, [r1]"], 0xFFFFFFFF)
C("memory", "LDR reg offset",["    mov r1, #0x1100", "    mov r3, #4", "    mov r2, #170",
                             "    str r2, [r1, r3]", "    ldr r0, [r1, r3]"], 0xAA)
C("memory", "SWP",          ["    mov r1, #0x1100", "    mov r2, #170", "    str r2, [r1]",
                             "    mov r3, #187", "    swp r0, r3, [r1]"], 0xAA)

# ---- block transfer variants -------------------------------------------
C("block transfer", "STMDB SP! / LDMIA SP! (push/pop)",
  ["    mov sp, #0x1400", "    mov r1, #170", "    push {r1}", "    pop {r0}"], 0xAA)
C("block transfer", "STMIA non-SP base",
  ["    mov r4, #0x1100", "    mov r1, #170", "    mov r2, #187",
   "    stmia r4!, {r1,r2}", "    mov r5, #0x1100", "    ldr r0, [r5]"], 0xAA)
C("block transfer", "LDMDB",
  ["    mov r4, #0x1100", "    mov r1, #170", "    mov r2, #187",
   "    stmia r4!, {r1,r2}", "    ldmdb r4!, {r0,r3}"], 0xAA)

# ---- control flow / PSR -------------------------------------------------
C("control flow", "B / conditional B",
  ["    mov r0, #0", "    mov r1, #1", "    cmp r1, #1", "    beq 1f",
   "    mov r0, #99", "1:  add r0, r0, #7"], 7)
# The harness halts on the FIRST `bx` it sees (see push_suite.run_rom), so a
# test can't contain a mid-program `bx lr` followed by more code -- that isn't
# a CPU limitation, it's how the halt probe works. This checks the same thing
# (does bl jump to the target and set lr to the return address) without
# needing an internal return: it never executes bx until the very end.
C("control flow", "BL sets lr and jumps",
  # bl is the first instruction here (address 0x0), so lr = 0x0 + 4 = 0x4 --
  # not a value to guess, verified directly against a standalone run before
  # writing this in.
  ["    bl 1f", "    mov r0, #99", "    b 2f",
   "1:  mov r0, #5", "    mov r1, lr", "    cmp r1, #4",
   "    moveq r0, #5", "    movne r0, #0", "2:"], 5)
# The `b 2f` matters: without it the fall-through path runs on into the landing
# instruction `mov r0,#5` and produces the expected answer anyway, so a core
# that treated `mov pc,lr` as a no-op still passed. `add lr,lr,#12` keeps the
# landing pad on `mov r0,#5` now that the branch sits between them.
C("control flow", "MOV PC, LR (PC write via reg file)",
  ["    mov r0, #0", "    mov lr, pc", "    add lr, lr, #12", "    mov pc, lr",
   "    mov r0, #99", "    b 2f", "1:  mov r0, #5", "2:"], 5)
# This used to be a two-instruction stub that set r0=5 and never touched PC:
# it reported PASS on any core, including one with no load-to-PC path at all.
# Real form: park a landing-pad address in RAM, load it straight into r15, and
# let the VALUE stored name the path taken. Falling through gives 0x63, so the
# fall-through and redirect outcomes are distinguishable.
C("control flow", "LDR PC (load into PC)",
  ["    mov r1, #0x1100", "    adr r2, 1f", "    str r2, [r1]",
   "    ldr pc, [r1]", "    mov r0, #99", "    b 2f",
   "1:  mov r0, #5", "2:"], 5)
# "add r0,pc,#0" is the first instruction after _start (address 0). ARM's
# defined PC-read convention is address-of-this-instruction + 8, regardless
# of pipeline depth -- the assembler bakes that assumption into every
# PC-relative computation it emits, this core included.
C("control flow", "PC as operand (ADD Rd,PC,#0)", ["    add r0, pc, #0"], 8)
# ldr r0,=const lowers to a PC-relative load; GAS auto-places the literal
# after the assembled function (past the harness's own trailing `bx lr`) once
# the file ends, so no explicit .ltorg is needed here.
C("control flow", "literal pool (LDR Rd,=const)", ["    ldr r0, =0x12345678"], 0x12345678)
# Reads program memory through a REGISTER base rather than pc. This is what
# separates "the load path decodes the address" from "LDR Rd,=const is
# special-cased": an Rn==r15 test cannot route this one to ROM, so it fails on
# any build that keys off the instruction form. GCC emits exactly this shape
# for .rodata, jump tables and switch tables.
C("control flow", "program memory via register base",
  ["    ldr r1, =1f", "    ldr r0, [r1, #4]", "    b 2f",
   "    .align 2", "1:  .word 0x11111111", "    .word 0xCAFEBABE", "2:"],
  0xCAFEBABE)
C("psr", "MRS", ["    mrs r0, cpsr", "    mov r0, r0, lsr #28", "    and r0, r0, #15"], None)
# The old body was `mrs r1,cpsr; msr cpsr_f,r1; mov r0,#1` expecting 1 -- the
# answer came from the trailing MOV, so it reported PASS even if MSR decoded to
# nothing. MSR CPSR_f,#imm writes CPSR[31:24] from the rotated immediate;
# 0x40000000 is Z=1, N=C=V=0 (encodable as 1 ROR 2). The conditional MOVs then
# read that flag back, so only a working MSR yields 1.
C("psr", "MSR", ["    msr cpsr_f, #0x40000000",
                 "    moveq r0, #1", "    movne r0, #0"], 1)
C("exceptions", "SWI", ["    mov r0, #1", "    swi #0"], None)

def run(body, expect):
    lines = [".syntax unified", ".arm", ".global _start", "_start:"] + body + [
        f"    mov r11, #{BASE}", "    str r0, [r11]", "    bx lr"]
    asm = "\n".join(lines) + "\n"
    with tempfile.TemporaryDirectory() as wd:
        try:
            words = ps.assemble(asm, wd)
        except subprocess.CalledProcessError:
            return "ASM", None
        try:
            halted, osc, ram = ps.run_rom(words, wd)
        except subprocess.TimeoutExpired:
            return "HANG", None
        except AssertionError:
            return "TOOBIG", None
    if osc: return "OSC", None
    if not halted: return "HANG", None
    got = int(ram.get((BASE - ps.RAM_BASE) // 4, "00000000"), 16)
    if expect is None: return "RAN", got
    return ("PASS" if got == (expect & 0xFFFFFFFF) else "WRONG"), got

cur = None
tally = {}
for group, name, body, expect in CASES:
    if group != cur: print(f"\n--- {group} ---"); cur = group
    st, got = run(body, expect)
    tally[st] = tally.get(st, 0) + 1
    extra = ""
    if st == "WRONG": extra = f"  got {got:08x} want {(expect or 0)&0xFFFFFFFF:08x}"
    elif st == "RAN": extra = f"  result {got:08x} (no reference)"
    print(f"  [{st:^6}] {name}{extra}")
print("\n" + "  ".join(f"{k}={v}" for k, v in sorted(tally.items())))
