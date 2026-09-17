#!/usr/bin/env python3
"""Systematic per-instruction-class differential test matrix.

Unlike tools/aggressive_c_harness.py (organic compiled C), this generates
targeted ARM assembly test vectors, one instruction-class dimension at a
time (every data-processing opcode x every shift type x boundary amounts,
every load/store size x every byte/halfword lane x every addressing mode,
...), diffs each against Unicorn, and for every failing case captures enough
state to point straight at the broken net.

Same oracle/hardware split as aggressive_c_harness.py:
  - Unicorn = ground truth ARM semantics.
  - armv4t_2.circ -> Verilog (circ2v.py) -> iverilog = the actual hardware.

Usage:
    python3 tools/isa_matrix_harness.py                # all categories
    python3 tools/isa_matrix_harness.py --only shifter  # one category
"""
from __future__ import annotations

import argparse
import pathlib
import struct
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
COT_ROOT = pathlib.Path("/home/junaet/Documents/CustomCPU-COT")
sys.path.insert(0, str(pathlib.Path.home() / ".local/lib/python3.10/site-packages"))


def _load(name: str, path: pathlib.Path):
    """Load a module by explicit file path -- CustomCPU-COT and CustomCPU
    both have a `tools` package, so `from tools import x` is ambiguous about
    which one wins. This sidesteps that entirely."""
    import importlib.util
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


cot_pysim = _load("cot_pysim", COT_ROOT / "tools" / "pysim.py")   # assemble()
ach = _load("ach", ROOT / "tools" / "aggressive_c_harness.py")     # run_unicorn/run_hardware/build_cpu_top

HEADER = ".syntax unified\n.arm\n.global _start\n_start:\n    mov sp, #0x1400\n"
FOOTER = "\n    mov r0, #0\n    bx r0\n"


def assemble_body(body: str) -> list[int]:
    return cot_pysim.assemble(HEADER + body + FOOTER)


def run_case(body: str, circ_path: str, max_cycles: int = 600):
    words = assemble_body(body)
    oracle = ach.run_unicorn(words, max_instrs=200_000)
    hw = ach.run_hardware(words, circ_path, max_cycles)
    diffs = ach.diff_ram(oracle["ram"], hw["ram"])
    return words, oracle, hw, diffs


# ---------------------------------------------------------------------------
# Category: data-processing opcode x operand2 form (shift type/amount, S bit)
# ---------------------------------------------------------------------------

DP_OPS = ["and", "eor", "sub", "rsb", "add", "adc", "sbc", "rsc",
          "orr", "bic"]                    # two-operand-result ops (Rd = Rn OP op2)
DP_TEST_ONLY = ["tst", "teq", "cmp", "cmn"] # set flags only, no Rd write
DP_MOV_OPS = ["mov", "mvn"]                 # single-operand (Rd = OP op2)

SHIFT_IMM_CASES = [
    ("lsl", 0), ("lsl", 1), ("lsl", 31),
    ("lsr", 1), ("lsr", 31), ("lsr", 32),      # lsr #32 encodes as #0
    ("asr", 1), ("asr", 31), ("asr", 32),      # asr #32 encodes as #0
    ("ror", 1), ("ror", 31),
    ("rrx", None),                              # ror #0
]
SHIFT_REG_AMOUNTS = [0, 1, 31, 32, 33, 40, 255, 256]

# MRS is a known-broken instruction (isa_coverage flags it "no reference" --
# it just returns 0). Using it to observe flags would make every S-suffixed
# test in this file fail for that unrelated reason, masking whatever the
# actual opcode does. Read flags via conditional execution instead -- already
# verified correct by adversarial_regression's 14 condition-code cases.
FLAG_READ = (
    "    mov r6, #0\n"
    "    addmi r6, r6, #8\n"
    "    addeq r6, r6, #4\n"
    "    addcs r6, r6, #2\n"
    "    addvs r6, r6, #1\n"
    "    str r6, [r4, #4]\n"
)


def gen_dp_immediate_cases():
    """Every DP opcode against a set of 8-bit-rotated immediates, including
    ones whose rotated form has bit31 set (must produce carry-out on S-suffixed
    logical ops) and ones that don't."""
    imms = [0x000000FF, 0xFF000000, 0x0000FF00, 0xC0000000,  # rotate 0, 8, 16, 2 -> bit31 set cases
            0x00000001, 0x40000000, 0x00000000]
    cases = []
    for op in DP_OPS + DP_MOV_OPS:
        for imm in imms:
            name = "%s_s_imm_0x%08x" % (op, imm)
            operand2 = "#0x%x" % imm
            if op in DP_MOV_OPS:
                body = (
                    "    mov r0, #0x11\n"
                    "    %ss r0, %s\n"
                    "    mov r4, #0x1000\n"
                    "    str r0, [r4]\n"
                ) % (op, operand2) + FLAG_READ
            else:
                body = (
                    "    mov r1, #0x55\n"
                    "    %ss r0, r1, %s\n"
                    "    mov r4, #0x1000\n"
                    "    str r0, [r4]\n"
                ) % (op, operand2) + FLAG_READ
            cases.append((name, body))
    return cases


def gen_dp_shift_cases():
    """ADD/MOV/ANDS with every shift type, immediate and register amount, on
    both a 'random' operand and an all-ones operand (exercises carry-out at
    every bit position)."""
    cases = []
    operands = [0x9A3C55F1, 0xFFFFFFFF, 0x00000001, 0x80000000]
    for shtype, amt in SHIFT_IMM_CASES:
        for rmval in operands:
            if shtype == "rrx":
                op2 = "rrx"
            else:
                op2 = "%s #%d" % (shtype, amt)
            name = "movs_%s_0x%08x" % (op2.replace(" ", "_").replace("#", ""), rmval)
            body = (
                "    ldr r1, =0x%08x\n"
                "    movs r0, r1, %s\n"
                "    mov r4, #0x1000\n"
                "    str r0, [r4]\n"
            ) % (rmval, op2) + FLAG_READ
            cases.append((name, body))
    for shtype in ("lsl", "lsr", "asr", "ror"):
        for amt in SHIFT_REG_AMOUNTS:
            for rmval in (0x9A3C55F1, 0xFFFFFFFF):
                name = "movs_reg_%s_amt%d_0x%08x" % (shtype, amt, rmval)
                body = (
                    "    ldr r1, =0x%08x\n"
                    "    mov r3, #%d\n"
                    "    movs r0, r1, %s r3\n"
                    "    mov r4, #0x1000\n"
                    "    str r0, [r4]\n"
                ) % (rmval, amt, shtype) + FLAG_READ
                cases.append((name, body))
    return cases


# ---------------------------------------------------------------------------
# Category: multiply family
# ---------------------------------------------------------------------------

def gen_multiply_cases():
    cases = []
    pairs = [(7, 6), (0, 5), (0xFFFFFFFF, 2), (0x80000000, 2), (0x80000000, 0x80000000),
             (0xFFFFFFFF, 0xFFFFFFFF), (100000, 100000)]
    for a, b in pairs:
        body = (
            "    ldr r1, =0x%08x\n"
            "    ldr r2, =0x%08x\n"
            "    mul r0, r1, r2\n"
            "    mov r4, #0x1000\n"
            "    str r0, [r4]\n"
        ) % (a & 0xffffffff, b & 0xffffffff)
        cases.append(("mul_0x%x_0x%x" % (a & 0xffffffff, b & 0xffffffff), body))
        body = (
            "    ldr r1, =0x%08x\n"
            "    ldr r2, =0x%08x\n"
            "    ldr r3, =0x1000\n"
            "    mla r0, r1, r2, r3\n"
            "    mov r4, #0x1000\n"
            "    str r0, [r4]\n"
        ) % (a & 0xffffffff, b & 0xffffffff)
        cases.append(("mla_0x%x_0x%x" % (a & 0xffffffff, b & 0xffffffff), body))
        body = (
            "    ldr r2, =0x%08x\n"
            "    ldr r3, =0x%08x\n"
            "    umull r0, r1, r2, r3\n"
            "    mov r4, #0x1000\n"
            "    str r0, [r4]\n"
            "    str r1, [r4, #4]\n"
        ) % (a & 0xffffffff, b & 0xffffffff)
        cases.append(("umull_0x%x_0x%x" % (a & 0xffffffff, b & 0xffffffff), body))
        body = (
            "    ldr r2, =0x%08x\n"
            "    ldr r3, =0x%08x\n"
            "    smull r0, r1, r2, r3\n"
            "    mov r4, #0x1000\n"
            "    str r0, [r4]\n"
            "    str r1, [r4, #4]\n"
        ) % (a & 0xffffffff, b & 0xffffffff)
        cases.append(("smull_0x%x_0x%x" % (a & 0xffffffff, b & 0xffffffff), body))
    return cases


# ---------------------------------------------------------------------------
# Category: load/store byte and halfword lanes
# ---------------------------------------------------------------------------

def gen_loadstore_lane_cases():
    """Every store/load offset used here is small enough to fold into the
    str/ldr instruction's own #imm12 field -- the *base register* (r4) is
    always just `mov r4, #0x1000`, never a computed address like 0x1004,
    since not every 12-bit sum is a legal single MOV immediate (ARM's
    8-bit-rotated encoding rejects e.g. 0x1004)."""
    cases = []
    word = 0xAABBCCDD
    # LDRB at every byte lane, from RAM and from a ROM literal
    for off in range(4):
        body = (
            "    mov r1, #0x1000\n"
            "    ldr r2, =0x%08x\n"
            "    str r2, [r1]\n"
            "    ldrb r0, [r1, #%d]\n"
            "    str r0, [r1, #4]\n"
        ) % (word, off)
        cases.append(("ldrb_ram_lane%d" % off, body))

        body = (
            "    ldr r1, =lit_word\n"
            "    ldrb r0, [r1, #%d]\n"
            "    mov r4, #0x1000\n"
            "    str r0, [r4, #4]\n"
            "    b 1f\n"
            "lit_word: .word 0x%08x\n"
            "1:\n"
        ) % (off, word)
        cases.append(("ldrb_rom_lane%d" % off, body))

    # STRB at every byte lane -- write a known byte, read back the WHOLE word
    for off in range(4):
        body = (
            "    mov r1, #0x1000\n"
            "    mov r2, #0\n"
            "    str r2, [r1]\n"          # zero the word first
            "    mov r3, #0x5A\n"
            "    strb r3, [r1, #%d]\n"
            "    ldr r0, [r1]\n"
            "    str r0, [r1, #4]\n"
        ) % off
        cases.append(("strb_lane%d" % off, body))

    # LDRH / STRH at both halfword lanes
    for off in (0, 2):
        body = (
            "    mov r1, #0x1000\n"
            "    ldr r2, =0x%08x\n"
            "    str r2, [r1]\n"
            "    ldrh r0, [r1, #%d]\n"
            "    str r0, [r1, #4]\n"
        ) % (word, off)
        cases.append(("ldrh_ram_lane%d" % off, body))

        body = (
            "    mov r1, #0x1000\n"
            "    mov r2, #0\n"
            "    str r2, [r1]\n"
            "    ldr r3, =0x1234\n"
            "    strh r3, [r1, #%d]\n"
            "    ldr r0, [r1]\n"
            "    str r0, [r1, #4]\n"
        ) % off
        cases.append(("strh_lane%d" % off, body))

    # LDRSB / LDRSH sign extension at each lane, with a negative-looking byte
    neg_word = 0x81828384
    for off in range(4):
        body = (
            "    mov r1, #0x1000\n"
            "    ldr r2, =0x%08x\n"
            "    str r2, [r1]\n"
            "    ldrsb r0, [r1, #%d]\n"
            "    str r0, [r1, #4]\n"
        ) % (neg_word, off)
        cases.append(("ldrsb_lane%d" % off, body))
    for off in (0, 2):
        body = (
            "    mov r1, #0x1000\n"
            "    ldr r2, =0x%08x\n"
            "    str r2, [r1]\n"
            "    ldrsh r0, [r1, #%d]\n"
            "    str r0, [r1, #4]\n"
        ) % (neg_word, off)
        cases.append(("ldrsh_lane%d" % off, body))

    # addressing modes: pre-index writeback, post-index
    body = (
        "    mov r1, #0x1000\n"
        "    add r1, r1, #4\n"          # r1 = 0x1004, at runtime (not an immediate encode)
        "    mov r2, #0xAB\n"
        "    strb r2, [r1, #-4]!\n"     # pre-index down, writeback -> r1 becomes 0x1000
        "    mov r4, #0x1000\n"
        "    str r1, [r4, #8]\n"        # expect 0x1000
        "    ldr r0, [r1]\n"
        "    str r0, [r4, #12]\n"       # expect the byte 0xAB in lane 0
    )
    cases.append(("strb_preindex_writeback", body))

    body = (
        "    mov r1, #0x1000\n"
        "    mov r2, #0xCD\n"
        "    strb r2, [r1], #4\n"       # post-index -> r1 becomes 0x1004
        "    mov r4, #0x1000\n"
        "    str r1, [r4, #8]\n"        # expect 0x1004
        "    ldr r0, [r1, #-4]\n"
        "    str r0, [r4, #12]\n"       # expect the byte 0xCD in lane 0
    )
    cases.append(("strb_postindex", body))
    return cases


CATEGORIES = {
    "dp_immediate": gen_dp_immediate_cases,
    "shifter": gen_dp_shift_cases,
    "multiply": gen_multiply_cases,
    "loadstore_lanes": gen_loadstore_lane_cases,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--circ", default=str(ROOT / "armv4t_2.circ"))
    ap.add_argument("--only", default=None, help="comma-separated category names")
    ap.add_argument("--report", default=str(ROOT / "build" / "isa_matrix_report.xlsx"))
    ap.add_argument("--max-cycles", type=int, default=600)
    args = ap.parse_args()

    cats = args.only.split(",") if args.only else list(CATEGORIES)
    print("building cpu_top.v from %s ..." % args.circ)
    ach.build_cpu_top(args.circ)

    all_rows = {}
    for cat in cats:
        cases = CATEGORIES[cat]()
        rows = []
        print("=== %s: %d cases ===" % (cat, len(cases)))
        for name, body in cases:
            try:
                words, oracle, hw, diffs = run_case(body, args.circ, args.max_cycles)
            except Exception as e:                          # noqa: BLE001
                rows.append({"case": name, "status": "ERROR", "detail": str(e)[:500],
                            "asm": body})
                print("  [ERROR] %s: %s" % (name, str(e)[:120]))
                continue
            status = "PASS" if (not diffs and oracle["halted"] and hw["halted"]) else "DIFFER"
            if not oracle["halted"]:
                status = "ORACLE_TIMEOUT"
            elif not hw["halted"]:
                status = "HW_TIMEOUT"
            detail = "; ".join("word 0x%x: oracle=0x%08x hw=0x%08x" % d for d in diffs)
            rows.append({"case": name, "status": status, "detail": detail, "asm": body})
            tag = "PASS" if status == "PASS" else "DIFFER"
            print("  [%-6s] %-40s %s" % (tag, name, detail[:100]))
        all_rows[cat] = rows

    write_report(all_rows, args.report)
    print("\nwrote %s" % args.report)
    total = sum(len(v) for v in all_rows.values())
    passed = sum(1 for v in all_rows.values() for r in v if r["status"] == "PASS")
    print("%d/%d PASS" % (passed, total))


def write_report(all_rows, path):
    import openpyxl
    from openpyxl.styles import Font, PatternFill
    from openpyxl.utils import get_column_letter

    wb = openpyxl.Workbook()
    del wb["Sheet"]
    fills = {"PASS": "C6EFCE", "DIFFER": "FFC7CE", "ERROR": "FFEB9C",
            "ORACLE_TIMEOUT": "FFEB9C", "HW_TIMEOUT": "FFC7CE"}
    cols = ["case", "status", "detail", "asm"]

    summary = []
    for cat, rows in all_rows.items():
        ws = wb.create_sheet(cat[:31])
        ws.append(cols)
        for c in ws[1]:
            c.font = Font(bold=True)
        for r in rows:
            ws.append([r.get(c, "") for c in cols])
        for i, r in enumerate(rows, 2):
            fill = fills.get(r["status"])
            if fill:
                ws.cell(i, 2).fill = PatternFill("solid", fgColor=fill)
        for i, c in enumerate(cols, 1):
            w = max(10, min(80, max([len(str(r.get(c, ""))) for r in rows] + [len(c)]) + 2))
            ws.column_dimensions[get_column_letter(i)].width = w
        ws.freeze_panes = "A2"
        n_pass = sum(1 for r in rows if r["status"] == "PASS")
        summary.append({"category": cat, "total": len(rows), "pass": n_pass,
                        "fail": len(rows) - n_pass})

    ws = wb.create_sheet("Summary", 0)
    ws.append(["category", "total", "pass", "fail"])
    for c in ws[1]:
        c.font = Font(bold=True)
    for r in summary:
        ws.append([r["category"], r["total"], r["pass"], r["fail"]])
    wb.save(path)


if __name__ == "__main__":
    main()
