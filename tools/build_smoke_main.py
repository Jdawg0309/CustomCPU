#!/usr/bin/env python3
"""Assemble a smoke-test `main` from stage_IF / stage_ID / stage_EX.

This exists to answer one question that no structural or semantic check on an
individual stage can answer: do the three stages actually fit together?
Subcircuit ports are POSITIONAL, so a pin nudged up or down inside a stage
silently renumbers every port after it and every check still passes.

Nothing is hand-placed by coordinate.  Instance port points come from
logisim.geometry, and every long connection is a Tunnel dropped exactly on a
derived port point, so there is no routing to get wrong.

MEM and WB do not exist yet, so their inputs are tied off:
  - wd  <- alu_result          (no load data to mux in)
  - we  <- alu_we
  - wb_writes_pc / wb_data     tied 0   => `mov pc,..` will NOT work
  - hold_pc / bt_done          tied 0   => no block transfer
  - wd2 / we2 / wa2            tied 0   => no second write port (no LDM)
  - sbwe / data_ram_we         tied 0   => no store-base writeback

Writes smoke.circ only.  armv4t_2.circ is never opened for writing.
"""
import re, sys
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
from logisim import model, geometry

SRC = DST = "/home/junaet/Documents/CustomCPU/smoke.circ"

IF_AT = (1200, 1000)
ID_AT = (2600, 1000)
EX_AT = (4000, 1000)
STUB  = 60          # length of the stub wire from a port out to its tunnel

comps, wires = [], []


def comp(lib, name, loc, **attrs):
    comps.append((lib, name, loc, attrs))
    return loc


def tunnel(pt, label, width, side):
    """Stub wire from a port out to a Tunnel, so nothing overlaps the box."""
    x, y = pt
    tx = x + STUB if side == "R" else x - STUB
    wires.append((x, y, tx, y))
    a = {"label": label, "facing": "west" if side == "R" else "east"}
    if width != 1:
        a["width"] = str(width)
    comp("0", "Tunnel", (tx, y), **a)


def const(pt, value, width, side="L"):
    x, y = pt
    tx = x + STUB if side == "R" else x - STUB
    wires.append((x, y, tx, y))
    a = {"value": "0x%x" % value, "facing": "east" if side == "L" else "west"}
    if width != 1:
        a["width"] = str(width)          # width MUST precede value in Logisim's
    comp("0", "Constant", (tx, y), **a)  # UI; in the file order is irrelevant


def free_tunnel(loc, label, width, facing="east"):
    a = {"label": label, "facing": facing}
    if width != 1:
        a["width"] = str(width)
    comp("0", "Tunnel", loc, **a)


def outpin(loc, label, width, feed):
    """An observation pin: tunnel `feed` -> short wire -> output Pin."""
    free_tunnel((loc[0] - 60, loc[1]), feed, width, "west")
    wires.append((loc[0] - 60, loc[1], loc[0], loc[1]))
    a = {"label": label, "output": "true", "facing": "west",
         "appearance": "classic"}
    if width != 1:
        a["width"] = str(width)
    comp("0", "Pin", loc, **a)


def build():
    d = model.load(SRC)

    # ---- place the three instances -------------------------------------
    for name, at in (("stage_IF", IF_AT), ("stage_ID", ID_AT), ("stage_EX", EX_AT)):
        comps.append((None, name, at, {}))

    def ports(name, at):
        """Port name -> (point, width), derived not assumed."""
        sub = d.circuits[name]
        pts = {}
        outs, ins = sub.outputs(), sub.inputs()
        w = geometry._subcircuit_box_width(d, name)
        for k, p in enumerate(outs):
            pts[p.label] = ((at[0], at[1] + 20 * k), int(p.attrs.get("width", 1)), "R")
        for k, p in enumerate(ins):
            pts[p.label] = ((at[0] - w, at[1] + 20 * k), int(p.attrs.get("width", 1)), "L")
        return pts

    IF, ID, EX = (ports(n, a) for n, a in
                  (("stage_IF", IF_AT), ("stage_ID", ID_AT), ("stage_EX", EX_AT)))

    # ---- the inter-stage net list, BY NAME -----------------------------
    # (stage, port, tunnel-label).  A label appearing on both a producer and a
    # consumer is the connection; every one is checked for width agreement.
    NETS = [
        # IF outputs
        (IF, "pc_plus4",     "PC_PLUS4"),
        (IF, "pc_word_addr", "PC_WORD"),
        (IF, "instruction",  "INSTR"),
        # IF inputs fed from EX
        (IF, "branch_offset", "BR_OFF"),
        (IF, "bx_target",     "BX_TGT"),
        (IF, "branch_taken",  "BR_TAKEN"),
        (IF, "bx_taken",      "BX_TAKEN"),
        (IF, "clk", "CLK"), (IF, "rst", "RST"),
        # ID
        (ID, "instruction",  "INSTR"),
        (ID, "pc_word_addr", "PC_WORD"),
        (ID, "clk", "CLK"), (ID, "rst", "RST"),
        (ID, "wd",  "ALU_RES"),
        (ID, "we",  "ALU_WE"),
        (ID, "bl_taken", "BL_TAKEN"),
        (ID, "rd_a", "RD_A"), (ID, "rd_b", "RD_B"),
        (ID, "alu_ctrl", "ALU_CTRL"), (ID, "cond", "COND"),
        (ID, "class_bits", "CLASS"), (ID, "opcode", "OPCODE"),
        (ID, "imm_bit", "IMM_BIT"), (ID, "imm8", "IMM8"),
        (ID, "shift_amount", "SH_AMT"), (ID, "shift_type", "SH_TYP"),
        (ID, "s_bit", "S_BIT"), (ID, "instr_27_4", "I27_4"),
        (ID, "wa", "WA"),
        # rot == instr[11:8] == the Rs field.  Same four bits, so ID's existing
        # `rs` output feeds EX's `rot` with no extra logic.
        (ID, "rs", "ROT"),
        (ID, "branch_imm24", "BR_IMM24"),
        # EX
        (EX, "clk", "CLK"), (EX, "rst", "RST"),
        (EX, "rd_a", "RD_A"), (EX, "rd_b", "RD_B"),
        (EX, "alu_ctrl", "ALU_CTRL"), (EX, "cond", "COND"),
        (EX, "class_bits", "CLASS"), (EX, "opcode", "OPCODE"),
        (EX, "imm_bit", "IMM_BIT"), (EX, "imm8", "IMM8"),
        (EX, "shift_amount", "SH_AMT"), (EX, "rot", "ROT"),
        (EX, "shift_type", "SH_TYP"), (EX, "s_bit", "S_BIT"),
        (EX, "instr_27_4", "I27_4"),
        (EX, "branch_imm24", "BR_IMM24"),
        (EX, "alu_result", "ALU_RES"), (EX, "alu_we", "ALU_WE"),
        (EX, "cpsr", "CPSR"), (EX, "cond_pass", "CONDPASS"),
        (EX, "bl_taken", "BL_TAKEN"), (EX, "branch_taken", "BR_TAKEN"),
        (EX, "branch_offset", "BR_OFF"), (EX, "bx_target", "BX_TGT"),
        (EX, "bx_taken", "BX_TAKEN"),
    ]

    widths = {}
    for tbl, port, label in NETS:
        pt, w, side = tbl[port]
        if label in widths and widths[label] != w:
            raise SystemExit("WIDTH MISMATCH on %s: %d vs %d (port %s)"
                             % (label, widths[label], w, port))
        widths[label] = w
        tunnel(pt, label, w, side)

    # ---- tie-offs: everything MEM and WB would have driven --------------
    for tbl, port in ((IF, "hold_pc"), (IF, "wb_writes_pc"), (IF, "wb_data"),
                      (IF, "bt_done"), (ID, "wd2"), (ID, "we2"), (ID, "wa2"),
                      (ID, "sbwe"), (ID, "data_ram_we")):
        pt, w, side = tbl[port]
        const(pt, 0, w)

    # ---- clock, reset --------------------------------------------------
    comp("0", "Clock", (400, 1600))
    wires.append((400, 1600, 460, 1600))
    free_tunnel((460, 1600), "CLK", 1, "west")
    comp("0", "Constant", (400, 1700), value="0x0", facing="east")
    wires.append((400, 1700, 460, 1700))
    free_tunnel((460, 1700), "RST", 1, "west")

    # ---- observation pins ----------------------------------------------
    obs = [("halt", 1, "BX_TAKEN"), ("o_pc", 10, "PC_WORD"),
           ("o_instr", 32, "INSTR"), ("o_alu", 32, "ALU_RES"),
           ("o_wa", 4, "WA"), ("o_we", 1, "ALU_WE"),
           ("o_cpsr", 4, "CPSR"), ("o_pass", 1, "CONDPASS"),
           ("o_btaken", 1, "BR_TAKEN"), ("o_bltaken", 1, "BL_TAKEN")]
    for i, (lab, w, feed) in enumerate(obs):
        outpin((5200, 1000 + 60 * i), lab, w, feed)

    # ---- emit -----------------------------------------------------------
    body = []
    for (x0, y0, x1, y1) in wires:
        body.append('    <wire from="(%d,%d)" to="(%d,%d)"/>' % (x0, y0, x1, y1))
    for lib, name, loc, attrs in comps:
        libattr = "" if lib is None else ' lib="%s"' % lib
        if attrs:
            body.append('    <comp%s loc="(%d,%d)" name="%s">' % (libattr, loc[0], loc[1], name))
            for k in sorted(attrs):
                body.append('      <a name="%s" val="%s"/>' % (k, attrs[k]))
            body.append("    </comp>")
        else:
            body.append('    <comp%s loc="(%d,%d)" name="%s"/>' % (libattr, loc[0], loc[1], name))

    text = open(SRC).read()
    a0 = text.index('<circuit name="main"')
    a0 = text.index("\n", a0) + 1
    b0 = text.index("\n  </circuit>", a0) + 1
    new = text[:a0] + "\n".join(body) + "\n" + text[b0:]
    open(DST, "w").write(new)
    print("wrote %s: %d comps, %d wires in main"
          % (DST, len(comps), len(wires)))
    for lab in sorted(widths):
        print("   net %-10s w=%d" % (lab, widths[lab]))


build()
