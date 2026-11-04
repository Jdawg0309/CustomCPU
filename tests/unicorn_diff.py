#!/usr/bin/env python3
"""Differential ISA test: the real Logisim circuit vs Unicorn.

  oracle   Unicorn, CPU model ARM925T (an ARMv4T-class core). Unicorn rejects
           ARMv5 instructions on this model (CLZ faults), which is how the
           model was checked. It is NOT canonical for *unaligned* word loads
           (it does a plain byte read; ARMv4T rotates), so this harness only
           generates aligned accesses.
  hardware the circuit, run headlessly in the Logisim jar on a temporary copy
           with the program patched into every 32-bit ROM (tests/push_suite.py).

Each program holds several independent tests. A test loads all of r0-r9 with
fixed values, randomises the flags, runs a few instructions from one
category, then stores r0-r12, r14 and the packed NZCV word to its own RAM window.
The whole 1 KiB RAM window is compared word by word.

Setup:   pip install unicorn        (use a venv; pass its python)
Usage:   python tests/unicorn_diff.py arm_custom_subset.circ
         python tests/unicorn_diff.py CIRC --category dp --programs 20 --seed 7

Only the implemented subset is generated. MUL/MLA/SWP/MSR/MRS, unaligned
access and BX are deliberately absent (BX halts the testbench), as are the
implementation-defined STR/STM of the PC.
"""
import argparse
import concurrent.futures as cf
import json
import os
import random
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
_argv, sys.argv = sys.argv, sys.argv[:1]     # push_suite reads argv[1] on import
import push_suite as ps                      # noqa: E402
sys.argv = _argv

from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UcError   # noqa: E402
from unicorn.arm_const import UC_ARM_REG_CPSR, UC_ARM_REG_PC, UC_CPU_ARM_TI925T   # noqa: E402

RAM_BASE, RAM_BYTES = 0x1000, 0x400
WIN = 0x1200            # result windows start here, 0x40 bytes per test
TESTS_PER_PROGRAM = 8
CONDS = ["eq", "ne", "cs", "cc", "mi", "pl", "vs", "vc", "hi", "ls", "ge", "lt", "gt", "le"]
DP = ["and", "eor", "sub", "rsb", "add", "adc", "sbc", "rsc",
      "tst", "teq", "cmp", "cmn", "orr", "mov", "bic", "mvn"]
NOWRITE = {"tst", "teq", "cmp", "cmn"}
ONEOP = {"mov", "mvn"}
SPECIAL = [0, 1, 2, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF, 0x7FFFFFFE, 0x80000001,
           31, 32, 33, 0xFF, 0x100, 0x101, 0xFFFF, 0x12345678, 0xCAFEBABE]


GPR = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14]   # r13 (sp) is the result pointer


def reg(rng):
    return rng.choice(GPR)


def val(rng):
    return rng.choice(SPECIAL) if rng.random() < 0.5 else rng.getrandbits(32)


def cond(rng, p=0.3):
    return rng.choice(CONDS) if rng.random() < p else ""


def ror32(v, n):
    n %= 32
    return ((v >> n) | (v << (32 - n))) & 0xFFFFFFFF if n else v


def op2(rng):
    form = rng.choice(["imm", "reg", "shimm", "shimm", "shreg", "shreg"])
    r = reg(rng)
    if form == "imm":
        return "#0x%x" % ror32(rng.getrandbits(8), 2 * rng.randrange(16))
    if form == "reg":
        return f"r{r}"
    if form == "shimm":
        t = rng.choice(["lsl", "lsr", "asr", "ror", "rrx"])
        if t == "rrx":
            return f"r{r}, rrx"
        amt = {"lsl": rng.randrange(1, 32), "lsr": rng.randrange(1, 33),
               "asr": rng.randrange(1, 33), "ror": rng.randrange(1, 32)}[t]
        return f"r{r}, {t} #{amt}"
    return f"r{r}, {rng.choice(['lsl', 'lsr', 'asr', 'ror'])} r{reg(rng)}"


def gen_dp(rng):
    out = []
    for _ in range(rng.randrange(3, 7)):
        op, c = rng.choice(DP), cond(rng)
        rd, rn, o2 = reg(rng), reg(rng), op2(rng)
        s = "s" if (rng.random() < 0.5 and op not in NOWRITE) else ""
        if op in NOWRITE:
            out.append(f"{op}{c} r{rn}, {o2}")
        elif op in ONEOP:
            out.append(f"{op}{s}{c} r{rd}, {o2}")
        else:
            out.append(f"{op}{s}{c} r{rd}, r{rn}, {o2}")
    return out


def gen_cond(rng):
    out = []
    for k in range(6):
        out.append(f"mov{rng.choice(CONDS)} r{k}, #{rng.randrange(1, 200)}")
    return out


def gen_mem(rng):
    out = ["ldr r10, =0x1120", f"mov r9, #{rng.choice([0, 4, 8, 12, 16])}"]
    for _ in range(rng.randrange(4, 8)):
        kind = rng.choice(["w", "w", "b", "h", "sb", "sh"])
        ld = rng.random() < 0.5
        if kind == "w":
            mn, al = ("ldr" if ld else "str"), 4
        elif kind == "b":
            mn, al = ("ldrb" if ld else "strb"), 1
        elif kind == "h":
            mn, al = ("ldrh" if ld else "strh"), 2
        else:                                    # ldrsb / ldrsh (loads only)
            mn, al = "ldr" + kind, (1 if kind == "sb" else 2)
        # UAL puts the condition last: ldrbeq, ldrheq, ldrsbeq, streq
        mn = mn + cond(rng, 0.2)
        rd = rng.choice([0, 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 14])
        mode = rng.choice(["off", "pre", "post", "regoff", "regpost", "neg"])
        off = al * rng.randrange(0, 8) if al > 1 else rng.randrange(0, 20)
        if mode in ("pre", "post"):
            # A writeback offset that is not a multiple of 4 leaves the base
            # misaligned, and the next word access would be unaligned. Unicorn
            # does not rotate unaligned words like ARMv4T, so keep the base aligned.
            off = 4 * rng.randrange(0, 6)
        if mode == "off":
            out.append(f"{mn} r{rd}, [r10, #{off}]")
        elif mode == "neg":
            out.append(f"{mn} r{rd}, [r10, #-{off}]")
        elif mode == "pre":
            out.append(f"{mn} r{rd}, [r10, #{off}]!")
        elif mode == "post":
            out.append(f"{mn} r{rd}, [r10], #{off}")
        elif mode == "regoff":
            out.append(f"{mn} r{rd}, [r10, {rng.choice(['', '-'])}r9]")
        else:
            out.append(f"{mn} r{rd}, [r10], {rng.choice(['', '-'])}r9")
        if rng.random() < 0.3:                   # keep the base inside the window
            out.append("ldr r10, =0x1120")
    return out


def gen_block(rng):
    out = ["ldr r10, =0x1120"]
    for _ in range(rng.randrange(2, 5)):
        regs = sorted(rng.sample([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14], rng.randrange(1, 6)))
        rl = ",".join("lr" if r == 14 else f"r{r}" for r in regs)
        mode = rng.choice(["ia", "ib", "da", "db"])
        mn = rng.choice(["ldm", "stm"]) + mode + cond(rng, 0.15)
        out.append(f"{mn} r10{rng.choice(['', '!'])}, {{{rl}}}")
        out.append("ldr r10, =0x1120")
    return out


def gen_branch(rng):
    c = cond(rng, 0.7) or rng.choice(CONDS)
    pick = rng.choice(["skip", "bl", "blc", "loop"])
    if pick == "skip":
        return [f"b{c} 1f", "add r0, r0, #1", "add r1, r1, #2", "1:", "add r2, r2, #3"]
    if pick == "bl":
        return ["bl 1f", "b 2f", "1:", "add r0, r0, #5", "mov pc, lr", "2:", "add r1, r1, #1"]
    if pick == "blc":
        return [f"bl{c} 1f", "b 2f", "1:", "add r0, r0, #5", "mov pc, lr", "2:",
                "add r1, r1, #1"]
    return ["mov r8, #3", "1:", "add r0, r0, #2", "subs r8, r8, #1", "bne 1b",
            f"b{c} 2f", "add r1, r1, #7", "2:"]


def gen_pc(rng):
    """PC read as an operand (+8), and every way this subset can write the PC."""
    d, n = rng.choice([0, 1, 2, 4, 5, 6, 7]), rng.choice([0, 1, 2, 4, 5, 6, 7])
    c = rng.choice(CONDS)
    pick = rng.choice(["read"] * 4 + ["adr_mov", "add_pc", "ldr_lit", "ldr_mem",
                                      "ldm_pc", "cond_mov", "cond_add"])
    if pick == "read":
        return [rng.choice([f"add r{d}, pc, #{4 * rng.randrange(0, 16)}",
                            f"sub r{d}, pc, #{4 * rng.randrange(0, 16)}",
                            f"mov r{d}, pc", f"add r{d}, r{n}, pc",
                            f"add r{d}, pc, r{n}, lsl #2", f"adds r{d}, pc, r{n}",
                            f"cmp pc, r{n}", f"ldr r{d}, [pc, #-8]", f"ldr r{d}, [pc, #4]",
                            f"ldrb r{d}, [pc, #-7]"])]
    if pick == "adr_mov":
        return ["adr r3, 1f", "mov pc, r3", "add r0, r0, #1", "1:"]
    if pick == "add_pc":                       # pc+8 lands two words on: skips one
        return ["add pc, pc, #0", "add r1, r1, #1", "add r2, r2, #1"]
    if pick == "ldr_lit":
        return ["ldr pc, =1f", "add r0, r0, #3", "1:"]
    if pick == "ldr_mem":
        return ["ldr r10, =0x1120", "adr r3, 1f", "str r3, [r10]", "ldr pc, [r10]",
                "add r0, r0, #5", "1:"]
    if pick == "ldm_pc":
        return ["ldr r10, =0x1120", "adr r3, 1f", "str r3, [r10, #4]",
                "ldmia r10, {r4, pc}", "add r0, r0, #7", "1:"]
    if pick == "cond_mov":
        return ["adr r3, 1f", f"mov{c} pc, r3", "add r0, r0, #1", "1:"]
    return [f"add{c} pc, pc, #0", "add r1, r1, #1", "add r2, r2, #1"]


def gen_mixed(rng):
    """Chain snippets from several categories, so instruction classes interact."""
    out = []
    for _ in range(rng.randrange(3, 6)):
        out += rng.choice([gen_dp, gen_dp, gen_mem, gen_block, gen_branch, gen_cond,
                           gen_pc])(rng)
    return out


CATEGORIES = {"dp": gen_dp, "cond": gen_cond, "mem": gen_mem,
              "block": gen_block, "branch": gen_branch, "pc": gen_pc,
              "mixed": gen_mixed}

# --refresh-flags: ldrh/ldrsb/ldrsh/ldm currently overwrite NZCV (specs/fix_7).
# Re-running a compare after each one stops that bug masking everything after it.
REFRESH_FLAGS = False
_CLOBBERERS = re.compile(r"^(ldrh|ldrsb|ldrsh|ldm)")


def refresh(rng, lines):
    out = []
    for l in lines:
        out.append(l)
        if _CLOBBERERS.match(l):
            # only cmp/cmn define all of NZCV; tst/teq would leave the old C and V
            out.append(f"{rng.choice(['cmp', 'cmn'])} "
                       f"r{reg(rng)}, r{reg(rng)}")
    return out


def build_test(rng, idx, cat):
    """Return (asm lines, label) for one test."""
    L = [f"ldr r{r}, =0x{val(rng):08x}" for r in GPR]
    L.append(f"{rng.choice(['cmp', 'cmn', 'tst', 'teq'])} r{reg(rng)}, r{reg(rng)}")
    body = CATEGORIES[cat](rng)
    L += refresh(rng, body) if REFRESH_FLAGS else body
    L.append(f"ldr sp, =0x{WIN + 0x40 * idx:x}")
    L += [f"str r{r}, [sp, #{4 * r}]" for r in range(13)]
    L.append("str lr, [sp, #52]")
    L += ["mov r0, #0", "orrmi r0, r0, #8", "orreq r0, r0, #4",
          "orrcs r0, r0, #2", "orrvs r0, r0, #1", "str r0, [sp, #56]",
          "mov lr, #0"]     # the testbench halts on BX; BX to an odd lr is not taken
    return L


HEAD, TAIL = len(GPR) + 1, 22          # init+flag-setter lines, epilogue lines


def build_program(rng, cats):
    prefill = ["ldr r12, =0x1100"]
    for k in range(16):
        prefill += [f"ldr r0, =0x{val(rng):08x}", f"str r0, [r12, #{4 * k}]"]
    tests = []
    for i in range(TESTS_PER_PROGRAM):
        cat = cats[i % len(cats)]
        tests.append((cat, build_test(rng, i, cat)))
    return prefill, tests


def render(prefill, tests):
    lines = [".syntax unified", ".arm", ".global _start", "_start:"] + prefill
    for _, t in tests:
        lines += t
    lines += ["halt_here:", "bx lr", ".ltorg"]
    return "\n".join(lines) + "\n"


def assemble(text, wd):
    src, obj, binf = (os.path.join(wd, n) for n in ("t.S", "t.o", "t.bin"))
    open(src, "w").write(text)
    subprocess.run([ps.AS, "-march=armv4t", "-o", obj, src], check=True,
                   capture_output=True)
    subprocess.run([ps.OC, "-O", "binary", obj, binf], check=True)
    nm = subprocess.run(["arm-none-eabi-nm", obj], capture_output=True, text=True).stdout
    end = int(re.search(r"^([0-9a-f]+) \w halt_here", nm, re.M).group(1), 16)
    data = open(binf, "rb").read()
    return ["%08x" % int.from_bytes(data[i:i + 4], "little")
            for i in range(0, len(data), 4)], end


def oracle(words, end):
    uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    uc.ctl_set_cpu_model(UC_CPU_ARM_TI925T)
    uc.mem_map(0, 0x4000)
    uc.mem_write(0, b"".join(int(w, 16).to_bytes(4, "little") for w in words))
    uc.reg_write(UC_ARM_REG_CPSR, 0x13)
    uc.emu_start(0, end, count=500000)
    if uc.reg_read(UC_ARM_REG_PC) != end:
        raise RuntimeError('Unicorn exhausted its instruction budget before halt_here')
    raw = bytes(uc.mem_read(RAM_BASE, RAM_BYTES))
    return ["%08x" % int.from_bytes(raw[i:i + 4], "little") for i in range(0, RAM_BYTES, 4)]


def hardware(words, circ):
    ps.CIRC = circ
    with tempfile.TemporaryDirectory() as wd:
        try:
            halted, osc, ram = ps.run_rom(words, wd)
        except subprocess.TimeoutExpired:          # never reached the halt
            return False, False, ["00000000"] * (RAM_BYTES // 4)
    img = [ram.get(i, "00000000") for i in range(RAM_BYTES // 4)]
    return halted, osc, img


NAMES = [f"r{i}" for i in range(13)] + ["r14", "flags(NZCV)"]
MASK_FLAGS = False      # --mask-flags: ignore the captured NZCV word


def _is_flag_word(addr):
    return addr >= WIN and (addr - WIN) % 0x40 == 4 * 14


def diff(exp, got):
    bad = []
    for i, (e, g) in enumerate(zip(exp, got)):
        if e != g:
            addr = RAM_BASE + 4 * i
            if MASK_FLAGS and _is_flag_word(addr):
                continue
            if addr >= WIN and (addr - WIN) % 0x40 < 60:
                t, w = divmod(addr - WIN, 0x40)
                nm = NAMES[w // 4]
                bad.append(f"test{t}.{nm}: expected {e} got {g}")
            else:
                bad.append(f"mem[{addr:#x}]: expected {e} got {g}")
    return bad


def run_one(job):
    pid, text, circ = job
    with tempfile.TemporaryDirectory() as wd:
        words, end = assemble(text, wd)
    if len(words) > 1024:
        return pid, "TOO_BIG", [f"{len(words)} words"]
    exp = oracle(words, end)
    halted, osc, got = hardware(words, circ)
    if not halted or osc:
        return pid, "NOHALT" if not halted else "OSC", []
    bad = diff(exp, got)
    return pid, ("PASS" if not bad else "FAIL"), bad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("circuit")
    ap.add_argument("--category", choices=list(CATEGORIES) + ["all"], default="all")
    ap.add_argument("--programs", type=int, default=10)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--json")
    ap.add_argument("--mask-flags", action="store_true",
                    help="ignore NZCV, to look past a known flag bug")
    ap.add_argument("--refresh-flags", action="store_true",
                    help="re-run a compare after every flag-clobbering load")
    a = ap.parse_args()
    global MASK_FLAGS, REFRESH_FLAGS
    MASK_FLAGS, REFRESH_FLAGS = a.mask_flags, a.refresh_flags
    cats = list(CATEGORIES) if a.category == "all" else [a.category]
    jobs, texts = [], {}
    for p in range(a.programs):
        rng = random.Random(f"{a.seed}-{p}")
        prefill, tests = build_program(rng, cats)
        texts[p] = (prefill, tests)
        jobs.append((p, render(prefill, tests), a.circuit))
    results, fails = {}, 0
    with cf.ThreadPoolExecutor(a.jobs) as ex:
        for pid, status, bad in ex.map(run_one, jobs):
            results[pid] = (status, bad)
            print(f"program {pid:3d}  {status}", flush=True)
            if status != "PASS":
                fails += 1
                for b in bad[:12]:
                    print("     ", b)
    # localise failures: rerun each test of a failing program alone
    for pid, (status, bad) in sorted(results.items()):
        if status == "PASS":
            continue
        prefill, tests = texts[pid]
        print(f"\n== localising program {pid} ==")
        for i, (cat, t) in enumerate(tests):
            single = [(cat, build_test_at(t, i))]
            _, st, b = run_one((f"{pid}.{i}", render(prefill, single), a.circuit))
            if st != "PASS":
                print(f"  test {i} [{cat}] {st}")
                print("    " + "\n    ".join(t[HEAD:-TAIL]))   # body only
                for x in b[:8]:
                    print("      ", x)
    n = a.programs * TESTS_PER_PROGRAM
    print(f"\nprograms: {a.programs - fails}/{a.programs} identical to Unicorn "
          f"({n} tests, categories: {','.join(cats)}, seed {a.seed})")
    if a.json:
        json.dump({str(k): v for k, v in results.items()}, open(a.json, "w"), indent=1)
    return 1 if fails else 0


def build_test_at(lines, idx):
    """Re-target a test's result window to slot 0 when it is run alone."""
    return [re.sub(r"=0x[0-9a-f]+$", f"=0x{WIN:x}", l) if l.startswith("ldr sp,") else l
            for l in lines]


if __name__ == "__main__":
    sys.exit(main())
