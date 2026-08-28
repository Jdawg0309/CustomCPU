#!/usr/bin/env python3
"""Run the CPU in Python, straight out of the live .circ file.

No copy, no ROM patched on disk, no jar, no xvfb.  `armv4t_2.circ` is read at
call time and never written, so whatever is saved is what runs.

The top level is assembled here from the stage instances rather than read from
`main`, so this works while `main` is still empty -- and the wiring is the same
contract `tools/check_stage_fit.py` verifies, declared once below.
"""
import os, re, subprocess, sys, tempfile
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
from logisim.sim import Sim

CIRC = "/home/junaet/Documents/CustomCPU/armv4t_2.circ"

# (producer, consumer) by port name.  Mirrors CONTRACT in check_stage_fit.py.
WIRING = [
    ("IF.instruction",   "ID.instruction"),
    ("IF.pc_word_addr",  "ID.pc_word_addr"),
    ("EX.bl_taken",      "ID.bl_taken"),
    ("ID.rd_a",          "EX.rd_a"),
    ("ID.rd_b",          "EX.rd_b"),
    ("ID.alu_ctrl",      "EX.alu_ctrl"),
    ("ID.cond",          "EX.cond"),
    ("ID.class_bits",    "EX.class_bits"),
    ("ID.opcode",        "EX.opcode"),
    ("ID.imm_bit",       "EX.imm_bit"),
    ("ID.imm8",          "EX.imm8"),
    ("ID.shift_amount",  "EX.shift_amount"),
    ("ID.shift_type",    "EX.shift_type"),
    ("ID.s_bit",         "EX.s_bit"),
    ("ID.instr_27_4",    "EX.instr_27_4"),
    ("ID.rs",            "EX.rot"),         # rotate and Rs are both instr[11:8]
    ("ID.branch_imm24",  "EX.branch_imm24"),
    ("EX.branch_offset", "IF.branch_offset"),
    ("EX.branch_taken",  "IF.branch_taken"),
    ("EX.bx_target",     "IF.bx_target"),
    ("EX.bx_taken",      "IF.bx_taken"),
    ("IF.clk", "ID.clk"), ("ID.clk", "EX.clk"),
    ("IF.rst", "ID.rst"), ("ID.rst", "EX.rst"),
]

# Everything stage_MEM and stage_WB would drive.
TIES = {
    "IF.hold_pc": 0, "IF.wb_writes_pc": 0, "IF.wb_data": 0, "IF.bt_done": 0,
    "ID.wd2": 0, "ID.we2": 0, "ID.wa2": 0, "ID.sbwe": 0, "ID.data_ram_we": 0,
    "IF.rst": 0,
}


# Wired only when stage_WB exists.
WB_WIRING = [
    ("EX.alu_result", "WB.alu_result"), ("EX.alu_we", "WB.alu_we"),
    ("EX.cond_pass", "WB.cond_pass"), ("EX.bl_taken", "WB.bl_taken"),
    ("EX.branch_taken", "WB.branch_taken"), ("EX.bx_taken", "WB.bx_taken"),
    ("IF.pc_plus4", "WB.pc_plus4"),
    ("MEM.load_data", "WB.load_data"), ("MEM.mem_read", "WB.mem_read"),
    ("MEM.memory_up_base", "WB.memory_up_base"), ("MEM.sbwe", "WB.sbwe"),
    ("MEM.data_ram_we", "WB.data_ram_we"), ("ID.wa", "WB.wa"),
    ("WB.wd", "ID.wd"), ("WB.wd", "IF.wb_data"),
    ("WB.we", "ID.we"), ("WB.wb_writes_pc", "IF.wb_writes_pc"),
]

# Wired only when stage_MEM exists.  Until then the same signals stay in TIES,
# so nothing here needs editing to start testing a half-built MEM.
MEM_WIRING = [
    ("ID.rd_a", "MEM.rd_a"), ("ID.rd_b", "MEM.rd_b"),
    ("ID.class_bits", "MEM.class_bits"), ("ID.opcode", "MEM.opcode"),
    ("ID.s_bit", "MEM.s_bit"), ("ID.rn", "MEM.rn"),
    ("ID.instr_15_0", "MEM.instr_15_0"), ("EX.cond_pass", "MEM.cond_pass"),
    ("IF.clk", "MEM.clk"), ("IF.rst", "MEM.rst"),
    ("MEM.data_ram_we", "ID.data_ram_we"), ("MEM.sbwe", "ID.sbwe"),
    ("MEM.wd2", "ID.wd2"), ("MEM.we2", "ID.we2"), ("MEM.wa2", "ID.wa2"),
    ("MEM.bt_active", "ID.bt_active"), ("MEM.bt_reg_idx", "ID.bt_reg_idx"),
    ("MEM.hold_pc", "IF.hold_pc"), ("MEM.bt_done", "IF.bt_done"),
]


def cpu(path=CIRC):
    s = Sim(path)
    for inst, circ in (("IF", "stage_IF"), ("ID", "stage_ID"), ("EX", "stage_EX")):
        s.add_instance(inst, circ)
    have_mem = "stage_MEM" in s.design.circuits
    have_wb = "stage_WB" in s.design.circuits
    if have_mem:
        s.add_instance("MEM", "stage_MEM")
    if have_wb:
        s.add_instance("WB", "stage_WB")
    for a, b in WIRING:
        s.connect(a, b)
    ties = dict(TIES)
    if have_mem:
        # Only connect the pairs where BOTH ports actually exist yet, so a
        # partially built stage still runs instead of raising.
        for a, b in MEM_WIRING:
            try:
                s.connect(a, b)
            except KeyError:
                continue
        for k in list(ties):
            if k in ("ID.wd2", "ID.we2", "ID.wa2", "ID.sbwe", "ID.data_ram_we",
                     "IF.hold_pc", "IF.bt_done"):
                ties.pop(k)
    if have_wb:
        for a, b in WB_WIRING:
            try:
                s.connect(a, b)
            except KeyError:
                continue
        for k in ("IF.wb_writes_pc", "IF.wb_data"):
            ties.pop(k, None)
    else:
        # no WB yet: the register file writes the ALU result directly
        for a, b in (("EX.alu_result", "ID.wd"), ("EX.alu_we", "ID.we")):
            try:
                s.connect(a, b)
            except KeyError:
                pass
    s.build()
    s.mem_present = have_mem
    s.wb_present = have_wb
    for k, v in ties.items():
        try:
            s.poke(k, v)
        except KeyError:
            pass
    s.ties = ties
    return s


def assemble(asm):
    wd = tempfile.mkdtemp(prefix="pysim_")
    src, obj, binf = (os.path.join(wd, n) for n in ("t.S", "t.o", "t.bin"))
    open(src, "w").write(asm)
    subprocess.run(["arm-none-eabi-as", "-march=armv4t", "-o", obj, src],
                   check=True, capture_output=True)
    subprocess.run(["arm-none-eabi-objcopy", "-O", "binary", obj, binf], check=True)
    data = open(binf, "rb").read()
    return [int.from_bytes(data[i:i + 4], "little") for i in range(0, len(data), 4)]


# The writeback value and enable come from stage_WB once it exists.  Probing
# EX's raw alu_result/alu_we instead leaves the suite blind to the whole
# writeback path -- it would report "BL does not write r14" with a working WB
# sitting right there.
PROBES_BASE = ["IF.pc_word_addr", "IF.instruction", "ID.wa", "EX.cpsr",
               "EX.cond_pass", "EX.branch_taken", "EX.bl_taken", "EX.bx_taken"]


def probes_for(s):
    if getattr(s, "wb_present", False):
        return PROBES_BASE + ["WB.wd", "WB.we"]
    return PROBES_BASE + ["EX.alu_result", "EX.alu_we"]


PROBES = PROBES_BASE + ["EX.alu_result", "EX.alu_we"]


def run(asm, max_cycles=200, path=CIRC, probes=None):
    """Execute until bx_taken, returning one row per cycle."""
    s = cpu(path)
    if probes is None:
        probes = probes_for(s)
    words = assemble(asm)
    s.load_rom(words, 32)
    s.reset()
    for k, v in s.ties.items():
        s.poke(k, v)
    s.settle()
    rows = []
    for _ in range(max_cycles):
        row = {p.split(".", 1)[1]: s.peek(p) for p in probes}
        row.setdefault("alu_result", row.get("wd", 0))
        row.setdefault("alu_we", row.get("we", 0))
        row["_pc"] = row.get("pc_word_addr")
        rows.append(row)
        if row.get("bx_taken"):
            break
        s.tick("IF.clk")
    return rows, words, s


def fmt(rows, words):
    out = []
    for i, r in enumerate(rows):
        pc = r["pc_word_addr"]
        out.append("  %2d  pc=%-3d %08x  alu=%08x wa=%-2d we=%d cpsr=%s "
                   "pass=%d bt=%d bl=%d bx=%d"
                   % (i, pc, words[pc] if pc < len(words) else 0,
                      r["alu_result"], r["wa"], r["alu_we"],
                      format(r["cpsr"], "04b"), r["cond_pass"],
                      r["branch_taken"], r["bl_taken"], r["bx_taken"]))
    return "\n".join(out)


if __name__ == "__main__":
    asm = sys.stdin.read() if sys.argv[1:2] == ["-"] else open(sys.argv[1]).read()
    rows, words, _ = run(asm)
    print("program: %d words" % len(words))
    print(fmt(rows, words))
