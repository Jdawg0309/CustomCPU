#!/usr/bin/env python3
"""Real-Logisim ARM Operand2 shifter qualification.

Every case starts from reset and checks both the result and CPSR.C.  Expected
values are computed independently from ARM-state rules.  This deliberately
includes values that make carry 0 and values that make carry 1, so a stuck
carry line cannot pass.
"""
from pathlib import Path
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE))
import push_suite as ps

MASK = 0xFFFFFFFF
RESULT = 0x1200


def ror(value, amount):
    amount &= 31
    value &= MASK
    return value if amount == 0 else ((value >> amount) | (value << (32 - amount))) & MASK


def asr(value, amount):
    value &= MASK
    if amount >= 32:
        return MASK if value & 0x80000000 else 0
    signed = value - (1 << 32) if value & 0x80000000 else value
    return (signed >> amount) & MASK


def immediate_expected(kind, value, amount, carry_in):
    value &= MASK
    if kind == "lsl":
        if amount == 0:
            return value, carry_in
        return (value << amount) & MASK, (value >> (32 - amount)) & 1
    if kind == "lsr":
        n = 32 if amount == 32 else amount
        return (value >> n) & MASK, (value >> (n - 1)) & 1
    if kind == "asr":
        n = 32 if amount == 32 else amount
        return asr(value, n), (value >> min(n - 1, 31)) & 1
    if kind == "ror":
        result = ror(value, amount)
        return result, (result >> 31) & 1
    if kind == "rrx":
        return ((carry_in << 31) | (value >> 1)) & MASK, value & 1
    raise ValueError(kind)


def register_expected(kind, value, raw_amount, carry_in):
    value &= MASK
    amount = raw_amount & 0xFF
    if amount == 0:
        return value, carry_in
    if kind == "lsl":
        if amount < 32:
            return (value << amount) & MASK, (value >> (32 - amount)) & 1
        if amount == 32:
            return 0, value & 1
        return 0, 0
    if kind == "lsr":
        if amount < 32:
            return value >> amount, (value >> (amount - 1)) & 1
        if amount == 32:
            return 0, (value >> 31) & 1
        return 0, 0
    if kind == "asr":
        if amount < 32:
            return asr(value, amount), (value >> (amount - 1)) & 1
        sign = (value >> 31) & 1
        return (MASK if sign else 0), sign
    if kind == "ror":
        n = amount & 31
        if n == 0:
            return value, (value >> 31) & 1
        result = ror(value, n)
        return result, (result >> 31) & 1
    raise ValueError(kind)


def carry_setup(carry):
    if carry:
        return ["    mov r10,#1", "    cmp r10,#0"]
    return ["    mov r10,#0", "    cmp r10,#1"]


def make_program(value, carry, instruction, amount=None):
    lines = [".syntax unified", ".arm", ".global _start", "_start:"]
    lines += carry_setup(carry)
    lines += [f"    ldr r1,=0x{value & MASK:08x}"]
    if amount is not None:
        lines += [f"    ldr r3,=0x{amount & MASK:08x}"]
    lines += [f"    {instruction}", "    mov r2,#0", "    movcs r2,#1",
              f"    ldr r11,=0x{RESULT:08x}", "    str r0,[r11]",
              "    str r2,[r11,#4]", "    bx lr"]
    return "\n".join(lines) + "\n"


def cases():
    values = (0x80000001, 0x7FFFFFFE, 0x12345678)
    # Immediate encodings. LSR/ASR #32 are encoded with imm5=0; RRX is ROR/0.
    amounts = {"lsl": (0, 1, 31), "lsr": (1, 31, 32),
               "asr": (1, 31, 32), "ror": (1, 31)}
    for kind, ns in amounts.items():
        for value in values:
            for n in ns:
                for cin in ((0, 1) if n == 0 else (0,)):
                    want = immediate_expected(kind, value, n, cin)
                    yield (f"imm {kind.upper()} value={value:08x} n={n} C={cin}",
                           make_program(value, cin, f"movs r0,r1,{kind} #{n}"), want)
    for value in values:
        for cin in (0, 1):
            want = immediate_expected("rrx", value, 0, cin)
            yield (f"imm RRX value={value:08x} C={cin}",
                   make_program(value, cin, "movs r0,r1,rrx"), want)

    # Register amounts use only Rs[7:0]. Include both sides of every boundary,
    # modulo-32 ROR cases, and 256/257 to prove the low-byte rule.
    for kind in ("lsl", "lsr", "asr", "ror"):
        for value in values:
            for n in (0, 1, 31, 32, 33, 63, 64, 255, 256, 257):
                for cin in ((0, 1) if (n & 0xFF) == 0 else (0,)):
                    want = register_expected(kind, value, n, cin)
                    yield (f"reg {kind.upper()} value={value:08x} Rs={n} C={cin}",
                           make_program(value, cin, f"movs r0,r1,{kind} r3", n), want)


def run_case(asm, expected):
    with tempfile.TemporaryDirectory() as wd:
        try:
            words = ps.assemble(asm, wd)
            halted, oscillated, ram = ps.run_rom(words, wd)
        except subprocess.TimeoutExpired:
            return "TIMEOUT", None, None
        except subprocess.CalledProcessError:
            return "ASM", None, None
    got_result = int(ram.get((RESULT - ps.RAM_BASE) // 4, "00000000"), 16)
    got_carry = int(ram.get((RESULT + 4 - ps.RAM_BASE) // 4, "00000000"), 16)
    if oscillated:
        return "OSC", got_result, got_carry
    if not halted:
        return "HANG", got_result, got_carry
    return ("PASS" if (got_result, got_carry) == expected else "FAIL"), got_result, got_carry


def main():
    if len(sys.argv) > 1:
        ps.CIRC = sys.argv[1]
    else:
        ps.CIRC = str(ROOT / "debug_armv4t_2.circ")
    all_cases = list(cases())
    failed = []
    print(f"shifter discriminator: {len(all_cases)} cases on {ps.CIRC}")
    for i, (name, asm, expected) in enumerate(all_cases, 1):
        status, got_r, got_c = run_case(asm, expected)
        if status != "PASS":
            failed.append((name, status, got_r, got_c, expected))
        print(f"[{status:^7}] {i:03d}/{len(all_cases):03d} {name}", flush=True)
        if status != "PASS" and got_r is not None:
            print(f"          result={got_r:08x} want={expected[0]:08x}; C={got_c} want={expected[1]}", flush=True)
    print(f"\nShifter checks: {len(all_cases)-len(failed)}/{len(all_cases)} passed")
    if failed:
        print("Failures by operation:")
        summary = {}
        for name, *_ in failed:
            key = " ".join(name.split()[:2])
            summary[key] = summary.get(key, 0) + 1
        for key in sorted(summary):
            print(f"  {key:<12} {summary[key]}")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
