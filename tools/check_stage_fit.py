#!/usr/bin/env python3
"""Does the stage interface actually fit together?  Checked by NAME, not place.

Every other checker in this repo looks inside one stage.  This one looks only at
the seams: for each input a stage needs, is there a producer with that name and
that width?  Subcircuit ports are positional, so this also reports the port
INDEX each signal lands on -- the number that silently changes when a pin is
nudged, and the one thing no single-stage check can see.

usage: check_stage_fit.py <file.circ>
"""
import sys
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
from logisim import model

STAGES = ["stage_IF", "stage_ID", "stage_EX", "stage_MEM", "stage_WB"]

# consumer stage -> {consumer port: producer "stage.port"}
# "-" means: nothing produces this yet; it is tied off in the smoke main.
CONTRACT = {
    "stage_ID": {
        "instruction":  "stage_IF.instruction",
        "pc_word_addr": "stage_IF.pc_word_addr",
        "wd":           "stage_WB.wd",
        "we":           "stage_WB.we",
        "bl_taken":     "stage_EX.bl_taken",
        "clk": "*", "rst": "*",
        "wd2": "stage_MEM.wd2", "we2": "stage_MEM.we2", "wa2": "stage_MEM.wa2",
        "sbwe": "stage_MEM.sbwe", "data_ram_we": "stage_MEM.data_ram_we",
        "bt_active": "stage_MEM.bt_active", "bt_reg_idx": "stage_MEM.bt_reg_idx",
    },
    "stage_EX": {
        "rd_a":         "stage_ID.rd_a",
        "rd_b":         "stage_ID.rd_b",
        "alu_ctrl":     "stage_ID.alu_ctrl",
        "cond":         "stage_ID.cond",
        "class_bits":   "stage_ID.class_bits",
        "opcode":       "stage_ID.opcode",
        "imm_bit":      "stage_ID.imm_bit",
        "imm8":         "stage_ID.imm8",
        "shift_amount": "stage_ID.shift_amount",
        "shift_type":   "stage_ID.shift_type",
        "s_bit":        "stage_ID.s_bit",
        "instr_27_4":   "stage_ID.instr_27_4",
        # rotate is instr[11:8]; Rs is instr[11:8].  Same four bits, one output.
        "rot":          "stage_ID.rs",
        "branch_imm24": "stage_ID.branch_imm24",
        "clk": "*", "rst": "*",
    },
    "stage_WB": {
        "alu_result": "stage_EX.alu_result", "alu_we": "stage_EX.alu_we",
        "cond_pass": "stage_EX.cond_pass", "bl_taken": "stage_EX.bl_taken",
        "branch_taken": "stage_EX.branch_taken", "bx_taken": "stage_EX.bx_taken",
        "pc_plus4": "stage_IF.pc_plus4",
        "load_data": "stage_MEM.load_data", "mem_read": "stage_MEM.mem_read",
        "memory_up_base": "stage_MEM.memory_up_base", "sbwe": "stage_MEM.sbwe",
        "data_ram_we": "stage_MEM.data_ram_we", "wa": "stage_ID.wa",
    },
    "stage_MEM": {
        "rd_a":       "stage_ID.rd_a",
        "rd_b":       "stage_ID.rd_b",
        "class_bits": "stage_ID.class_bits",
        "opcode":     "stage_ID.opcode",
        "s_bit":      "stage_ID.s_bit",
        "rn":         "stage_ID.rn",
        "instr_15_0": "stage_ID.instr_15_0",
        "cond_pass":  "stage_EX.cond_pass",
        "clk": "*", "rst": "*",
    },
    "stage_IF": {
        "branch_offset": "stage_EX.branch_offset",
        "branch_taken":  "stage_EX.branch_taken",
        "bx_target":     "stage_EX.bx_target",
        "bx_taken":      "stage_EX.bx_taken",
        "clk": "*", "rst": "*",
        "hold_pc": "stage_MEM.hold_pc", "bt_done": "stage_MEM.bt_done",
        "wb_writes_pc": "stage_WB.wb_writes_pc", "wb_data": "stage_WB.wd",
    },
}


def main():
    d = model.load(sys.argv[1] if len(sys.argv) > 1 else "armv4t_2.circ")
    built = [s for s in STAGES if s in d.circuits]
    port = {}          # "stage.port" -> (width, kind, index)
    for s in built:
        circ = d.circuits[s]
        outs, ins = circ.outputs(), circ.inputs()
        for k, p in enumerate(outs):
            port["%s.%s" % (s, p.label)] = (int(p.attrs.get("width", 1)), "out", k)
        for k, p in enumerate(ins):
            port["%s.%s" % (s, p.label)] = (int(p.attrs.get("width", 1)), "in", k + len(outs))

    print("stages present: %s" % ", ".join(built))
    print("missing:        %s\n" % (", ".join(s for s in STAGES if s not in built) or "none"))

    bad = 0
    for cons in built:
        want = CONTRACT.get(cons)
        if want is None:
            print("== %s ==  no contract declared yet\n" % cons)
            continue
        circ = d.circuits[cons]
        nout = len(circ.outputs())
        print("== %s ==" % cons)
        for k, p in enumerate(circ.inputs()):
            name, idx = p.label, k + nout
            w = int(p.attrs.get("width", 1))
            src = want.get(name)
            if src is None:
                bad += 1
                print("  MISSING-SPEC port %-14s w=%-3d idx=%-2d  not in the contract"
                      % (name, w, idx))
            elif src in ("*", "-"):
                tag = "clk/rst" if src == "*" else "tied off (no MEM/WB yet)"
                print("  ok        port %-14s w=%-3d idx=%-2d  %s" % (name, w, idx, tag))
            elif src not in port:
                s2, p2 = src.split(".")
                if s2 not in built:
                    print("  ok        port %-14s w=%-3d idx=%-2d  tied off until %s exists"
                          % (name, w, idx, s2))
                    continue
                bad += 1
                print("  NO SOURCE port %-14s w=%-3d idx=%-2d  wants %-24s -- %s has no "
                      "output named %s" % (name, w, idx, src, s2, p2))
            elif port[src][0] != w:
                bad += 1
                print("  WIDTH     port %-14s w=%-3d idx=%-2d  %s is w=%d"
                      % (name, w, idx, src, port[src][0]))
            elif port[src][1] != "out":
                bad += 1
                print("  NOT-OUT   port %-14s wants %s, which is an INPUT" % (name, src))
            else:
                print("  ok        port %-14s w=%-3d idx=%-2d  <- %-24s (out idx %d)"
                      % (name, w, idx, src, port[src][2]))
        print()

    # Outputs nobody consumes -- not an error, but it is where MEM and WB attach.
    consumed = {v for t in CONTRACT.values() for v in t.values()}
    print("== outputs with no consumer in the contract ==")
    for s in built:
        spare = [p.label for p in d.circuits[s].outputs()
                 if "%s.%s" % (s, p.label) not in consumed]
        if spare:
            print("  %-10s %s" % (s, ", ".join(spare)))
    print("\nRESULT: %s" % ("PASS" if not bad else "%d problem(s)" % bad))
    return 1 if bad else 0


sys.exit(main())
