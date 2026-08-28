#!/usr/bin/env python3
"""Discriminator suite for the smoke-test main (IF + ID + EX only).

There is no MEM and no WB, so this cannot test loads, stores or `mov pc,..`.
What it CAN test is everything those three stages own, and it does so by
reading the per-cycle output-pin table rather than a final memory dump -- so a
wrong intermediate value is caught even when the final answer happens to be
right.

Each case states expectations as (pc, mnemonic, alu_result, wa, we) and every
expected value is computed from the ARM ARM by hand in the test, never from the
circuit.  A case that would still pass with the feature removed is not a case.
"""
import os, re, subprocess, sys, tempfile

AS = "arm-none-eabi-as"
OC = "arm-none-eabi-objcopy"
JAR = "/snap/logisim-evolution/current/logisim-evolution/logisim-evolution.jar"
ENGINE = "python"
args = [a for a in sys.argv[1:] if not a.startswith("--")]
for a in sys.argv[1:]:
    if a.startswith("--engine="):
        ENGINE = a.split("=", 1)[1]
CIRC = args[0] if args else ("armv4t_2.circ" if ENGINE == "python" else "smoke.circ")
ONLY = args[1] if len(args) > 1 else None

# --tty table prints one row per settled cycle: the output pins of `main`,
# excluding the pin named by --tty halt.  Widths make the mapping unambiguous.
COLS = ["pc", "instr", "alu", "wa", "we", "cpsr", "pass", "btaken", "bltaken"]


def run(asm, timeout=90):
    """Execute one program and return (rows, timed_out, words).

    Two engines, deliberately.  `python` flattens the live .circ and evaluates
    it here -- fast, no copy, no jar.  `logisim` drives the real simulator on a
    prepared copy.  Running both and comparing is the only way either one earns
    trust; neither is checking the other by construction.
    """
    if ENGINE == "python":
        return _run_python(asm)
    return _run_logisim(asm, timeout)


_KEYMAP = {"pc": "pc_word_addr", "instr": "instruction", "alu": "alu_result",
           "wa": "wa", "we": "alu_we", "cpsr": "cpsr", "pass": "cond_pass",
           "btaken": "branch_taken", "bltaken": "bl_taken"}


def _run_python(asm):
    sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
    import importlib
    P = importlib.import_module("tools.pysim")
    raw, words, _ = P.run(asm, max_cycles=200, path=CIRC)
    rows = [{k: r[v] for k, v in _KEYMAP.items()} for r in raw]
    timed_out = not (rows and rows[-1] and raw[-1]["bx_taken"])
    return rows, timed_out, ["%08x" % w for w in words]


def _run_logisim(asm, timeout=90):
    wd = tempfile.mkdtemp(prefix="smk_")
    src, obj, binf = (os.path.join(wd, n) for n in ("t.S", "t.o", "t.bin"))
    open(src, "w").write(asm)
    subprocess.run([AS, "-march=armv4t", "-o", obj, src], check=True,
                   capture_output=True)
    subprocess.run([OC, "-O", "binary", obj, binf], check=True)
    data = open(binf, "rb").read()
    words = ["%08x" % int.from_bytes(data[i:i+4], "little")
             for i in range(0, len(data), 4)]

    text = open(CIRC).read()
    pos, roms = 0, []
    while True:
        m = re.search(r'<comp lib="2"[^>]*name="ROM">.*?</comp>', text[pos:], re.S)
        if not m:
            break
        if 'val="32"' in m.group(0):
            roms.append(m.group(0))
        pos += m.end()
    for rom in roms:
        aw = int(re.search(r'addrWidth" val="(\d+)"', rom).group(1))
        assert len(words) <= (1 << aw)
        text = text.replace(rom, re.sub(
            r'<a name="contents">.*?</a>',
            '<a name="contents">addr/data: %d 32\n%s\n</a>' % (aw, " ".join(words)),
            rom, flags=re.S), 1)
    path = os.path.join(wd, "t.circ")
    open(path, "w").write(text)
    cmd = ["xvfb-run", "-a", "java", "-jar", JAR, "--tty", "table,halt",
           "--toplevel-circuit", "main", path]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        out, timed_out = p.stdout, False
    except subprocess.TimeoutExpired as e:
        out = (e.stdout or b"").decode(errors="replace")
        timed_out = True
    rows = []
    for line in out.splitlines():
        cells = [c.replace(" ", "") for c in line.split("\t")]
        if len(cells) != len(COLS) or not all(re.fullmatch(r"[01x]+", c) for c in cells):
            continue
        r = {}
        for k, c in zip(COLS, cells):
            r[k] = None if "x" in c else int(c, 2)
        rows.append(r)
    return rows, timed_out, words


CASES = []


def case(name, asm, expect, note=""):
    CASES.append((name, asm, expect, note))


P = ".syntax unified\n.arm\n.global _start\n_start:\n"
BX = "    bx lr\n"

# ---------------------------------------------------------------------------
# 1. every data-processing opcode, with operands chosen so no two opcodes
#    share an answer -- swapping AND for ORR, or ADD for ADC, changes the value.
case("dp_opcodes",
     P + """    mov  r0, #0xF0
    mov  r1, #0x3C
    and  r2, r0, r1
    orr  r3, r0, r1
    eor  r4, r0, r1
    add  r5, r0, r1
    sub  r6, r0, r1
    rsb  r7, r0, r1
    bic  r8, r0, r1
    mvn  r9, r1
""" + BX,
     # r0=0xF0 r1=0x3C
     [(2, 0xF0 & 0x3C, 2), (3, 0xF0 | 0x3C, 3), (4, 0xF0 ^ 0x3C, 4),
      (5, 0xF0 + 0x3C, 5), (6, 0xF0 - 0x3C, 6),
      (7, (0x3C - 0xF0) & 0xFFFFFFFF, 7),
      (8, 0xF0 & ~0x3C & 0xFFFFFFFF, 8), (9, (~0x3C) & 0xFFFFFFFF, 9)],
     "AND/ORR/EOR/ADD/SUB/RSB/BIC/MVN all distinct on 0xF0,0x3C")

# 2. immediate rotation.  #0xFF000000 is encodable only as 0xFF ROR 8.
#    If `rot` is wrong the value comes out 0xFF, 0xFF0000 or 0xFF00.
case("imm_rotate",
     P + """    mov  r0, #0xFF000000
    mov  r1, #0x3F00
    mov  r2, #0x104
""" + BX,
     [(0, 0xFF000000, 0), (1, 0x3F00, 1), (2, 0x104, 2)],
     "ROR-by-2*rot on the 8-bit immediate; a broken rot gives 0xFF / 0x3F / 0x41")

# 3. barrel shifter, immediate amount, all four types.
case("shift_imm",
     P + """    mov  r0, #0x81
    mov  r1, r0, lsl #4
    mov  r2, r0, lsr #4
    mvn  r3, #0
    mov  r4, r3, asr #4
    mov  r5, r0, ror #4
""" + BX,
     [(1, 0x810, 1), (2, 0x8, 2), (3, 0xFFFFFFFF, 3),
      (4, 0xFFFFFFFF, 4), (5, 0x10000008, 5)],
     "LSL/LSR/ASR/ROR by immediate; ASR of -1 stays -1, ROR wraps the low nibble")

# 4. barrel shifter, REGISTER amount -- exercises the Rs field, which is the
#    same four bits this main routes to `rot`.  If that sharing is wrong, one
#    of case 2 and case 4 must break.
case("shift_reg",
     P + """    mov  r0, #0x81
    mov  r1, #4
    mov  r2, r0, lsl r1
    mov  r3, r0, lsr r1
    mov  r4, r0, ror r1
""" + BX,
     [(2, 0x810, 2), (3, 0x8, 3), (4, 0x10000008, 4)],
     "register-specified shift amount")

# 5. flags.  CMP sets NZCV; the CPSR pin must show them.
#    NZCV bit order in this design is N=3 Z=2 C=1 V=0.
case("flags_cmp",
     P + """    mov  r0, #5
    mov  r1, #5
    cmp  r0, r1
    mov  r2, #7
    cmp  r0, r2
    subs r3, r0, r0
""" + BX,
     [],  # checked by the custom hook below
     "CMP 5,5 -> Z=1 C=1; CMP 5,7 -> N=1 C=0")

# 6. conditional execution.  Only ONE of the two moves may write.
case("cond_exec",
     P + """    mov  r0, #5
    cmp  r0, #5
    moveq r1, #0xAA
    movne r2, #0xBB
    cmp  r0, #9
    movlt r3, #0xCC
    movgt r4, #0xDD
""" + BX,
     [(2, 0xAA, 1), (5, 0xCC, 3)],
     "moveq and movlt must fire; movne and movgt must not write")

# 7. forward branch skips an instruction.
case("branch_fwd",
     P + """    mov  r0, #1
    b    skip
    mov  r1, #0xEE
skip:
    mov  r2, #0x22
""" + BX,
     [(0, 1, 0), (3, 0x22, 2)],
     "the mov r1 at pc=2 must never execute")

# 8. backward branch -- a counted loop.  Proves the redirect is stable and
#    that a taken branch does not corrupt the next fetch.
case("loop",
     P + """    mov  r0, #3
    mov  r1, #0
loop:
    add  r1, r1, #10
    subs r0, r0, #1
    bne  loop
""" + BX,
     [],
     "r1 accumulates 10 three times, then falls through")

# 9. BL then BX lr -- link register write and register-indirect return.
case("bl_bx",
     P + """    mov  r0, #1
    bl   sub1
    mov  r2, #0x33
    b    done
sub1:
    mov  r1, #0x11
    mov  pc, lr          @ NOT `bx lr`: the harness halts on the first BX, so a
                         @ subroutine that returns via BX ends the program and
                         @ the return can never be observed.
done:
""" + BX,
     [],
     "BL must write r14 with the return address and BX lr must come back")

# 10. r15 as an operand.  `add r0,pc,#0` must give pc+8.
case("pc_operand",
     P + """    add  r0, pc, #0
    add  r1, pc, #0
""" + BX,
     [(0, 8, 0), (1, 12, 1)],
     "reading r15 yields the instruction address + 8")


def show(rows, words):
    for i, r in enumerate(rows):
        ins = words[r["pc"]] if r["pc"] is not None and r["pc"] < len(words) else "????????"
        print("      %2d  pc=%-3s %s  alu=%08x wa=%-2s we=%s cpsr=%s pass=%s bt=%s bl=%s"
              % (i, r["pc"], ins, r["alu"] or 0, r["wa"], r["we"],
                 format(r["cpsr"] or 0, "04b"), r["pass"], r["btaken"], r["bltaken"]))


def check(name, rows, expect, words):
    """expect: list of (pc, alu_result, wa) -- the write that instruction makes."""
    errs = []
    for pc, val, wa in expect:
        hit = [r for r in rows if r["pc"] == pc]
        if not hit:
            errs.append("pc=%d never executed" % pc)
            continue
        r = hit[0]
        if r["we"] != 1:
            errs.append("pc=%d: we=0, expected a write to r%d" % (pc, wa))
            continue
        if r["wa"] != wa:
            errs.append("pc=%d: wrote r%d, expected r%d" % (pc, r["wa"], wa))
        if r["alu"] != val:
            errs.append("pc=%d: alu=%08x expected %08x" % (pc, r["alu"] or 0, val))
    return errs


# Gaps that belong to stages that DO NOT EXIST YET.  They are printed, never
# counted as failures -- but they are listed explicitly so that "the suite is
# green" can never quietly mean "the suite stopped looking".
KNOWN_GAPS = {
    "cond_exec": "alu_we is not gated by cond_pass -- in debug_armv4t.circ that "
                 "AND lives in main-level glue, so it belongs in stage_WB",
    "bl_bx":     "BL needs stage_WB (link-value mux into wd, and WE) and a path "
                 "for bl_taken to reach stage_IF's redirect",
    "shift_reg": "register-specified shift amount is not decoded -- the same gap "
                 "exists in debug_armv4t.circ (instr[4] is never tested)",
}


def custom(name, rows):
    """Returns (errors, gap_notes).

    CPSR is a REGISTERED output: the flags an instruction sets are visible on
    the NEXT row, not its own.  Reading them off the same row was a bug in the
    first version of this suite and made three correct results look broken.
    """
    e, gaps = [], []
    idx = {}
    for i, r in enumerate(rows):
        idx.setdefault(r["pc"], []).append(i)

    def at(pc, nth=0):
        i = idx.get(pc, [])
        return rows[i[nth]] if len(i) > nth else None

    def cpsr_after(pc, nth=0):
        i = idx.get(pc, [])
        if len(i) <= nth or i[nth] + 1 >= len(rows):
            return None
        return rows[i[nth] + 1]["cpsr"]

    if name == "flags_cmp":
        for pc, want, why in ((2, 0b0110, "cmp 5,5 -> Z=1 C=1"),
                              (4, 0b1000, "cmp 5,7 -> N=1, C=0 (borrow)"),
                              (5, 0b0110, "subs r3,r0,r0 -> Z=1 C=1")):
            got = cpsr_after(pc)
            if got != want:
                e.append("%s: cpsr=%s expected %s"
                         % (why, format(got or 0, "04b"), format(want, "04b")))
        if at(2) and at(2)["we"]:
            e.append("cmp must not write a register")
        r = at(5)
        if not r or r["we"] != 1 or r["wa"] != 3:
            e.append("subs must write r3")

    if name == "cond_exec":
        # What stage_EX owns: the condition verdict itself.
        for pc, want, why in ((2, 1, "moveq after Z=1 must pass"),
                              (3, 0, "movne after Z=1 must fail"),
                              (5, 1, "movlt after N=1 must pass"),
                              (6, 0, "movgt after N=1 must fail")):
            r = at(pc)
            if r is None:
                e.append("pc=%d never executed" % pc)
            elif r["pass"] != want:
                e.append("%s (cond_pass=%s)" % (why, r["pass"]))
        if any(at(pc) and at(pc)["we"] for pc in (3, 6)):
            gaps.append(KNOWN_GAPS["cond_exec"])

    if name == "branch_fwd":
        if at(2) is not None:
            e.append("pc=2 executed; the branch did not skip it")

    if name == "loop":
        adds = [rows[i] for i in idx.get(2, [])]
        if len(adds) != 3:
            e.append("loop body ran %d times, expected 3" % len(adds))
        else:
            for i, r in enumerate(adds):
                if r["alu"] != 10 * (i + 1):
                    e.append("iteration %d: r1=%s expected %d"
                             % (i + 1, r["alu"], 10 * (i + 1)))
        bne = [rows[i] for i in idx.get(4, [])]
        if len(bne) != 3:
            e.append("bne executed %d times, expected 3" % len(bne))
        elif bne[2]["btaken"]:
            e.append("the third bne was still taken; the loop never exits")

    if name == "shift_reg":
        gaps.append(KNOWN_GAPS["shift_reg"])

    if name == "bl_bx":
        r = at(1)
        if r is None:
            return ["bl never executed"], gaps
        # stage_ID owns the write ADDRESS: bl_taken must steer WA to r14.
        if not r["bltaken"]:
            e.append("bl_taken low on the BL -- stage_EX did not decode it")
        if r["wa"] != 14:
            e.append("BL steered WA to r%s, expected r14 (stage_ID's WA mux)" % r["wa"])
        # Everything else about BL needs WB and an IF redirect path.
        # The link VALUE is stage_WB's and cannot work yet.  Keeping these in
        # the gap branch (rather than dropping them) stops this case reporting
        # PASS on a half-working BL: the redirect is fixed, the write is not.
        if r["we"] != 1:
            gaps.append("BL does not write r14 -- needs stage_WB's link mux "
                        "(M_BL) and the bl_taken term in OR_WE")
        elif r["alu"] != 8:
            gaps.append("BL link value %s, expected 8" % r["alu"])
        if at(2) is None:
            e.append("never returned to the instruction after the BL")
        if not r["btaken"]:
            gaps.append("branch_taken low on the BL -- the stage_EX fold is missing")

    return e, gaps


def main():
    total = fails = 0
    for name, asm, expect, note in CASES:
        if ONLY and ONLY != name:
            continue
        total += 1
        rows, timed_out, words = run(asm)
        errs = []
        if timed_out:
            errs.append("TIMEOUT: never reached the halt pin")
        errs += check(name, rows, expect, words)
        cerrs, gaps = custom(name, rows)
        errs += cerrs
        if errs:
            fails += 1
            print("[WRONG] %-14s %s" % (name, note))
            for x in errs:
                print("           ! %s" % x)
            show(rows, words)
        elif gaps:
            print("[ GAP  ] %-14s %s" % (name, note))
        else:
            print("[ PASS ] %-14s %s" % (name, note))
        for g in gaps:
            print("           ~ %s" % g)
    print("\nengine=%s  circuit=%s" % (ENGINE, CIRC))
    print("%d/%d correct for what IF+ID+EX own" % (total - fails, total))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
