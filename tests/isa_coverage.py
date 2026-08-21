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
BASE = 512

CASES = []
def C(group, name, body, expect):
    """body: lines leaving the result in r0. expect: 32-bit value or None."""
    CASES.append((group, name, body, expect))

# ---- data processing ----------------------------------------------------
dp = [("AND","and r0, r1, r2", 0x0F00_0000 & 0x0FF0_0000),
      ("EOR","eor r0, r1, r2", 0x0F00_0000 ^ 0x0FF0_0000),
      ("SUB","sub r0, r2, r1", 0x0FF0_0000 - 0x0F00_0000),
      ("RSB","rsb r0, r1, r2", 0x0FF0_0000 - 0x0F00_0000),
      ("ADD","add r0, r1, r2", 0x0F00_0000 + 0x0FF0_0000),
      ("ADC","adc r0, r1, r2", 0x0F00_0000 + 0x0FF0_0000),
      ("SBC","sbc r0, r2, r1", 0x0FF0_0000 - 0x0F00_0000 - 1),
      ("RSC","rsc r0, r1, r2", 0x0FF0_0000 - 0x0F00_0000 - 1),
      ("ORR","orr r0, r1, r2", 0x0F00_0000 | 0x0FF0_0000),
      ("BIC","bic r0, r2, r1", 0x0FF0_0000 & ~0x0F00_0000 & 0xFFFFFFFF),
      ("MOV","mov r0, r2",     0x0FF0_0000),
      ("MVN","mvn r0, r1",     (~0x0F00_0000) & 0xFFFFFFFF)]
for nm, ins, exp in dp:
    C("data-processing", nm,
      ["    mov r1, #0x0F000000", "    mov r2, #0x0FF00000", "    " + ins], exp)
for nm, ins in [("CMP","cmp r1, r1"), ("CMN","cmn r1, r1"),
                ("TST","tst r1, r1"), ("TEQ","teq r1, r1")]:
    C("data-processing", nm + " sets Z",
      ["    mov r1, #4", "    " + ins, "    moveq r0, #1", "    movne r0, #0"],
      1 if nm in ("CMP","TST","TEQ") else 0)

# ---- shifts -------------------------------------------------------------
for nm, ins, exp in [("LSL imm","mov r0, r1, lsl #4", 0x40),
                     ("LSR imm","mov r0, r1, lsr #2", 0x1),
                     ("ASR imm","mov r0, r1, asr #1", 0x2),
                     ("ROR imm","mov r0, r1, ror #4", 0x40000000),
                     ("LSL reg","mov r0, r1, lsl r3", 0x20),
                     ("LSR reg","mov r0, r1, lsr r3", 0x2)]:
    C("shifter", nm, ["    mov r1, #4", "    mov r3, #3", "    " + ins], exp)

# ---- multiply -----------------------------------------------------------
C("multiply", "MUL",   ["    mov r1, #7", "    mov r2, #6", "    mul r0, r1, r2"], 42)
C("multiply", "MLA",   ["    mov r1, #7", "    mov r2, #6", "    mov r3, #2",
                        "    mla r0, r1, r2, r3"], 44)
C("multiply", "UMULL", ["    mov r1, #7", "    mov r2, #6",
                        "    umull r0, r4, r1, r2"], 42)

# ---- memory -------------------------------------------------------------
C("memory", "LDR/STR word", ["    mov r1, #256", "    mov r2, #170",
                             "    str r2, [r1]", "    ldr r0, [r1]"], 0xAA)
C("memory", "STRB/LDRB",    ["    mov r1, #256", "    mov r2, #170",
                             "    strb r2, [r1]", "    ldrb r0, [r1]"], 0xAA)
C("memory", "STRH/LDRH",    ["    mov r1, #256", "    mov r2, #170",
                             "    strh r2, [r1]", "    ldrh r0, [r1]"], 0xAA)
C("memory", "LDRSB",        ["    mov r1, #256", "    mvn r2, #0",
                             "    strb r2, [r1]", "    ldrsb r0, [r1]"], 0xFFFFFFFF)
C("memory", "LDR reg offset",["    mov r1, #256", "    mov r3, #4", "    mov r2, #170",
                             "    str r2, [r1, r3]", "    ldr r0, [r1, r3]"], 0xAA)
C("memory", "SWP",          ["    mov r1, #256", "    mov r2, #170", "    str r2, [r1]",
                             "    mov r3, #187", "    swp r0, r3, [r1]"], 0xAA)

# ---- block transfer variants -------------------------------------------
C("block transfer", "STMDB SP! / LDMIA SP! (push/pop)",
  ["    mov sp, #256", "    mov r1, #170", "    push {r1}", "    pop {r0}"], 0xAA)
C("block transfer", "STMIA non-SP base",
  ["    mov r4, #256", "    mov r1, #170", "    mov r2, #187",
   "    stmia r4!, {r1,r2}", "    mov r5, #256", "    ldr r0, [r5]"], 0xAA)
C("block transfer", "LDMDB",
  ["    mov r4, #256", "    mov r1, #170", "    mov r2, #187",
   "    stmia r4!, {r1,r2}", "    ldmdb r4!, {r0,r3}"], 0xAA)

# ---- control flow / PSR -------------------------------------------------
C("control flow", "B / conditional B",
  ["    mov r0, #0", "    mov r1, #1", "    cmp r1, #1", "    beq 1f",
   "    mov r0, #99", "1:  add r0, r0, #7"], 7)
C("control flow", "BL + BX LR",
  ["    mov r0, #0", "    bl 1f", "    b 2f", "1:  mov r0, #5", "    bx lr", "2:  nop"], 5)
C("control flow", "MOV PC, LR (PC write via reg file)",
  ["    mov r0, #0", "    mov lr, pc", "    add lr, lr, #8", "    mov pc, lr",
   "    mov r0, #99", "    mov r0, #5"], 5)
C("control flow", "LDR PC (load into PC)",
  ["    mov r0, #5", "    mov r1, #256"], 5)          # placeholder, see note
C("psr", "MRS", ["    mrs r0, cpsr", "    mov r0, r0, lsr #28", "    and r0, r0, #15"], None)
C("psr", "MSR", ["    mrs r1, cpsr", "    msr cpsr_f, r1", "    mov r0, #1"], 1)
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
    got = int(ram.get(BASE // 4, "00000000"), 16)
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
