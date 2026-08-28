#!/usr/bin/env python3
"""Build the five-stage top level specified by specs/main.md.

Reads the user's hand-wired armv4t_2.circ and writes debug_armv4t_2.circ only.
The generated main contains the five stage instances, Clock, RST, observation
pins, and tunnel wiring.  It contains no logic gates.
"""
import sys
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
from logisim import model, geometry

SRC = "/home/junaet/Documents/CustomCPU/armv4t_2.circ"
DST = "/home/junaet/Documents/CustomCPU/debug_armv4t_2.circ"

AT = {"IF": (1200, 1000), "ID": (2600, 1000), "EX": (4000, 1000),
      "MEM": (5400, 1000), "WB": (6800, 1000)}
STUB = 60

comps, wires = [], []


def comp(lib, name, loc, **attrs):
    comps.append((lib, name, loc, attrs))
    return loc


def wire(a, b):
    wires.append((a[0], a[1], b[0], b[1]))


def tunnel(pt, label, width, side):
    x, y = pt
    tx = x + STUB if side == "R" else x - STUB
    wire((x, y), (tx, y))
    a = {"label": label, "facing": "west" if side == "R" else "east"}
    if width != 1:
        a["width"] = str(width)
    comp("0", "Tunnel", (tx, y), **a)


def free_tunnel(loc, label, width, facing="east"):
    a = {"label": label, "facing": facing}
    if width != 1:
        a["width"] = str(width)
    comp("0", "Tunnel", loc, **a)


def const(pt, value, width, side="L"):
    x, y = pt
    tx = x + STUB if side == "L" else x - STUB
    wire((x, y), (tx, y))
    a = {"value": "0x%x" % value, "facing": "east" if side == "L" else "west"}
    if width != 1:
        a["width"] = str(width)
    comp("0", "Constant", (tx if side != "L" else x - STUB, y), **a)


def build():
    d = model.load(SRC)

    for inst, circ in (("IF", "stage_IF"), ("ID", "stage_ID"),
                       ("EX", "stage_EX"), ("MEM", "stage_MEM"),
                       ("WB", "stage_WB")):
        comps.append((None, circ, AT[inst], {}))

    def ports(inst, circ):
        sub = d.circuits[circ]
        at = AT[inst]
        w = geometry._subcircuit_box_width(d, circ)
        out = {}
        for k, p in enumerate(sub.outputs()):
            out[p.label] = ((at[0], at[1] + 20 * k), int(p.attrs.get("width", 1)), "R")
        for k, p in enumerate(sub.inputs()):
            out[p.label] = ((at[0] - w, at[1] + 20 * k), int(p.attrs.get("width", 1)), "L")
        return out

    IF = ports("IF", "stage_IF"); ID = ports("ID", "stage_ID")
    EX = ports("EX", "stage_EX"); MEM = ports("MEM", "stage_MEM")
    WB = ports("WB", "stage_WB")

    NETS = [
        (IF, "instruction", "INSTR"), (IF, "pc_word_addr", "PC_WORD"),
        (IF, "pc_plus4", "PC_PLUS4"),
        (IF, "branch_offset", "BR_OFF"), (IF, "bx_target", "BX_TGT"),
        (IF, "branch_taken", "BR_TAKEN"), (IF, "bx_taken", "BX_TAKEN"),
        (IF, "hold_pc", "HOLD_PC"), (IF, "bt_done", "BT_DONE"),
        (IF, "wb_writes_pc", "WB_WRITES_PC"), (IF, "wb_data", "WD"),
        (IF, "clk", "CLK"), (IF, "rst", "RST"),

        (ID, "instruction", "INSTR"), (ID, "pc_word_addr", "PC_WORD"),
        (ID, "clk", "CLK"), (ID, "rst", "RST"),
        (ID, "wd", "WD"), (ID, "we", "WE"),
        (ID, "bl_taken", "BL_TAKEN"),
        (ID, "wd2", "WD2"), (ID, "we2", "WE2"), (ID, "wa2", "WA2"),
        (ID, "sbwe", "SBWE"), (ID, "data_ram_we", "DATA_RAM_WE"),
        (ID, "bt_active", "BT_ACTIVE"), (ID, "bt_reg_idx", "BT_REG_IDX"),
        (ID, "rd_a", "RD_A"), (ID, "rd_b", "RD_B"), (ID, "alu_ctrl", "ALU_CTRL"),
        (ID, "cond", "COND"), (ID, "class_bits", "CLASS"), (ID, "opcode", "OPCODE"),
        (ID, "imm_bit", "IMM_BIT"), (ID, "imm8", "IMM8"),
        (ID, "shift_amount", "SH_AMT"), (ID, "shift_type", "SH_TYP"),
        (ID, "s_bit", "S_BIT"), (ID, "instr_27_4", "I27_4"), (ID, "rs", "ROT"),
        (ID, "branch_imm24", "BR_IMM24"), (ID, "instr_15_0", "I15_0"),
        (ID, "rn", "RN"), (ID, "wa", "WA"),

        (EX, "clk", "CLK"), (EX, "rst", "RST"),
        (EX, "rd_a", "RD_A"), (EX, "rd_b", "RD_B"), (EX, "alu_ctrl", "ALU_CTRL"),
        (EX, "cond", "COND"), (EX, "class_bits", "CLASS"), (EX, "opcode", "OPCODE"),
        (EX, "imm_bit", "IMM_BIT"), (EX, "imm8", "IMM8"),
        (EX, "shift_amount", "SH_AMT"), (EX, "rot", "ROT"),
        (EX, "shift_type", "SH_TYP"), (EX, "s_bit", "S_BIT"),
        (EX, "instr_27_4", "I27_4"), (EX, "branch_imm24", "BR_IMM24"),
        (EX, "alu_result", "ALU_RES"), (EX, "alu_we", "ALU_WE"),
        (EX, "cpsr", "CPSR"), (EX, "cond_pass", "CONDPASS"),
        (EX, "bl_taken", "BL_TAKEN"), (EX, "branch_taken", "BR_TAKEN"),
        (EX, "branch_offset", "BR_OFF"), (EX, "bx_target", "BX_TGT"),
        (EX, "bx_taken", "BX_TAKEN"),

        (MEM, "clk", "CLK"), (MEM, "rst", "RST"),
        (MEM, "rd_a", "RD_A"), (MEM, "rd_b", "RD_B"),
        (MEM, "class_bits", "CLASS"), (MEM, "opcode", "OPCODE"),
        (MEM, "s_bit", "S_BIT"), (MEM, "rn", "RN"),
        (MEM, "instr_15_0", "I15_0"), (MEM, "cond_pass", "CONDPASS"),
        (MEM, "load_data", "LOAD_DATA"), (MEM, "mem_read", "MEM_READ"),
        (MEM, "ldr_reg_we", "LDR_REG_WE"), (MEM, "memory_up_base", "MEM_UP_BASE"),
        (MEM, "data_ram_we", "DATA_RAM_WE"), (MEM, "sbwe", "SBWE"),
        (MEM, "wa2", "WA2"), (MEM, "wd2", "WD2"), (MEM, "we2", "WE2"),
        (MEM, "hold_pc", "HOLD_PC"), (MEM, "bt_done", "BT_DONE"),
        (MEM, "bt_active", "BT_ACTIVE"), (MEM, "bt_reg_idx", "BT_REG_IDX"),

        (WB, "alu_result", "ALU_RES"), (WB, "alu_we", "ALU_WE"),
        (WB, "cond_pass", "CONDPASS"), (WB, "bl_taken", "BL_TAKEN"),
        (WB, "branch_taken", "BR_TAKEN"), (WB, "bx_taken", "BX_TAKEN"),
        (WB, "pc_plus4", "PC_PLUS4"), (WB, "load_data", "LOAD_DATA"),
        (WB, "mem_read", "MEM_READ"), (WB, "memory_up_base", "MEM_UP_BASE"),
        (WB, "sbwe", "SBWE"), (WB, "data_ram_we", "DATA_RAM_WE"),
        (WB, "wa", "WA"), (WB, "wd", "WD"), (WB, "we", "WE"),
        (WB, "wb_writes_pc", "WB_WRITES_PC"),
    ]

    widths = {}
    for tbl, port, label in NETS:
        pt, w, side = tbl[port]
        if label in widths and widths[label] != w:
            raise SystemExit("WIDTH MISMATCH %s: %d vs %d (%s)" % (label, widths[label], w, port))
        widths[label] = w
        tunnel(pt, label, w, side)

    # ---- clock and reset ------------------------------------------------
    comp("0", "Clock", (400, 400))
    wire((400, 400), (460, 400)); free_tunnel((460, 400), "CLK", 1, "west")
    rst = {"label": "RST", "facing": "east", "appearance": "classic"}
    comp("0", "Pin", (400, 500), **rst)
    wire((400, 500), (460, 500)); free_tunnel((460, 500), "RST", 1, "west")

    # ---- observation pins ----------------------------------------------
    obs = [("halt", 1, "BX_TAKEN"), ("o_pc", 10, "PC_WORD"),
           ("o_instr", 32, "INSTR"), ("o_wd", 32, "WD"),
           ("o_wa", 4, "WA"), ("o_we", 1, "WE"),
           ("o_cpsr", 4, "CPSR"), ("o_pass", 1, "CONDPASS")]
    for i, (lab, w, feedlbl) in enumerate(obs):
        loc = (7200, 1000 + 60 * i)
        free_tunnel((loc[0] - STUB, loc[1]), feedlbl, w, "west")
        wire((loc[0] - STUB, loc[1]), loc)
        a = {"label": lab, "output": "true", "facing": "west", "appearance": "classic"}
        if w != 1:
            a["width"] = str(w)
        comp("0", "Pin", loc, **a)

    body = []
    for seg in wires:
        body.append('    <wire from="(%d,%d)" to="(%d,%d)"/>' % seg)
    for lib, name, loc, attrs in comps:
        la = "" if lib is None else ' lib="%s"' % lib
        if attrs:
            body.append('    <comp%s loc="(%d,%d)" name="%s">' % (la, loc[0], loc[1], name))
            for k in sorted(attrs):
                body.append('      <a name="%s" val="%s"/>' % (k, attrs[k]))
            body.append("    </comp>")
        else:
            body.append('    <comp%s loc="(%d,%d)" name="%s"/>' % (la, loc[0], loc[1], name))

    text = open(SRC).read()
    a0 = text.index('<circuit name="main"'); a0 = text.index("\n", a0) + 1
    b0 = text.index("\n  </circuit>", a0) + 1
    open(DST, "w").write(text[:a0] + "\n".join(body) + "\n" + text[b0:])
    print("wrote main: %d components, %d wires, %d nets" % (len(comps), len(wires), len(widths)))


build()
