#!/usr/bin/env python3
"""Wire ARM short MUL/MLA into a debug circuit, preserving custom mul_32.

The live datapath uses Logisim Evolution's 32-bit Multiplier.  This script is
deliberately limited to debug copies and refuses both protected source files.
"""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from logisim import edit, geometry, model


PROTECTED = {"armv4t.circ", "armv4t_2.circ"}


def add_pin(text, circuit, loc, label, width=1, output=False):
    attrs = {
        "appearance": "classic",
        "facing": "west" if output else "east",
        "label": label,
    }
    if width != 1:
        attrs["width"] = str(width)
    if output:
        attrs["output"] = "true"
    return edit.add_component(text, circuit, "0", "Pin", loc, attrs)


def add_tunnel(text, circuit, loc, label, width=1, facing="east"):
    attrs = {"facing": facing, "label": label}
    if width != 1:
        attrs["width"] = str(width)
    return edit.add_component(text, circuit, "0", "Tunnel", loc, attrs)


def ports(design, name, lib, loc, attrs=None):
    comp = model.Component(name, lib, loc, attrs or {})
    return {p.name: p.at(comp) for p in geometry.ports(design, comp)}


def add_splitter(text, circuit, design, loc, incoming, fanout, mapping,
                 spacing=2):
    attrs = {
        "incoming": str(incoming), "fanout": str(fanout),
        "appear": "right", "spacing": str(spacing),
    }
    for bit, fan in enumerate(mapping):
        attrs["bit%d" % bit] = str(fan)
    text = edit.add_component(text, circuit, "0", "Splitter", loc, attrs)
    return text, ports(design, "Splitter", "0", loc, attrs)


def patch_id(text, design):
    circuit = "stage_ID"

    # Append outputs below the existing output pins so every old instance port
    # keeps its positional index.
    for loc, label, width in (
        ((5000, 2000), "is_mul", 1),
        ((5000, 2040), "is_mla", 1),
        ((5000, 2080), "mul_acc_value", 32),
    ):
        text = add_pin(text, circuit, loc, label, width, output=True)
        text = add_tunnel(text, circuit, loc,
                          {"is_mul": "MUL_SHORT", "is_mla": "MUL_MLA",
                           "mul_acc_value": "MUL_ACC_VALUE"}[label], width)

    # Exact short-multiply signature:
    #   instr[27:24] == 0000, instr[7:4] == 1001, instr[23:22] == 00.
    # opcode is instr[24:21], so opcode bits 2 and 1 are instr23 and instr22.
    text = add_tunnel(text, circuit, (1780, 590), "MUL_I27_4", 24)
    text = add_tunnel(text, circuit, (1780, 1040), "MUL_OPCODE", 4)

    text, ip = add_splitter(
        text, circuit, design, (4200, 2300), 24, 3,
        [0] * 4 + [1] * 16 + [2] * 4, spacing=4)
    text = add_tunnel(text, circuit, ip["combined"], "MUL_I27_4", 24)
    text = add_tunnel(text, circuit, ip["bit0"], "MUL_I7_4", 4)
    text = add_tunnel(text, circuit, ip["bit2"], "MUL_I27_24", 4)

    for loc, signal, value, result in (
        ((4450, 2300), "MUL_I7_4", "0x9", "MUL_LOW9"),
        ((4450, 2400), "MUL_I27_24", "0x0", "MUL_HIGH0"),
    ):
        attrs = {"width": "4", "mode": "unsigned"}
        text = edit.add_component(text, circuit, "5", "Comparator", loc, attrs)
        cp = ports(design, "Comparator", "5", loc, attrs)
        text = add_tunnel(text, circuit, cp["a"], signal, 4)
        text = edit.add_component(
            text, circuit, "0", "Constant", cp["b"],
            {"width": "4", "value": value})
        text = add_tunnel(text, circuit, cp["eq"], result)

    sig_attrs = {"label": "MUL_SIGNATURE"}
    text = edit.add_component(text, circuit, "1", "AND Gate",
                              (4600, 2350), sig_attrs)
    gp = ports(design, "AND Gate", "1", (4600, 2350), sig_attrs)
    text = add_tunnel(text, circuit, gp["in0"], "MUL_LOW9")
    text = add_tunnel(text, circuit, gp["in1"], "MUL_HIGH0")
    text = add_tunnel(text, circuit, gp["out"], "MUL_SIGNATURE")

    text, op = add_splitter(text, circuit, design, (4200, 2550), 4, 4,
                            [0, 1, 2, 3], spacing=2)
    text = add_tunnel(text, circuit, op["combined"], "MUL_OPCODE", 4)
    text = add_tunnel(text, circuit, op["bit0"], "MUL_OP0")
    text = add_tunnel(text, circuit, op["bit1"], "MUL_OP1")
    text = add_tunnel(text, circuit, op["bit2"], "MUL_OP2")

    for loc, source, result in (
        ((4450, 2520), "MUL_OP1", "MUL_NOT_OP1"),
        ((4450, 2600), "MUL_OP2", "MUL_NOT_OP2"),
    ):
        text = edit.add_component(text, circuit, "1", "NOT Gate", loc, {})
        np = ports(design, "NOT Gate", "1", loc, {})
        text = add_tunnel(text, circuit, np["in"], source)
        text = add_tunnel(text, circuit, np["out"], result)

    short_attrs = {"inputs": "3", "label": "SHORT_MUL_DECODE"}
    text = edit.add_component(text, circuit, "1", "AND Gate",
                              (4650, 2540), short_attrs)
    sp = ports(design, "AND Gate", "1", (4650, 2540), short_attrs)
    for name, label in zip(("in0", "in1", "in2"),
                           ("MUL_SIGNATURE", "MUL_NOT_OP1", "MUL_NOT_OP2")):
        text = add_tunnel(text, circuit, sp[name], label)
    text = add_tunnel(text, circuit, sp["out"], "MUL_SHORT")

    mla_attrs = {"label": "MLA_DECODE"}
    text = edit.add_component(text, circuit, "1", "AND Gate",
                              (4800, 2630), mla_attrs)
    mp = ports(design, "AND Gate", "1", (4800, 2630), mla_attrs)
    text = add_tunnel(text, circuit, mp["in0"], "MUL_SHORT")
    text = add_tunnel(text, circuit, mp["in1"], "MUL_OP0")
    text = add_tunnel(text, circuit, mp["out"], "MUL_MLA")

    # MLA's accumulator is instr[15:12].  Reuse the existing register-output
    # tunnels and add a non-destructive third combinational read mux.
    acc_loc = (4700, 2800)
    text = edit.add_component(text, circuit, None, "reg_read_mux_16x32",
                              acc_loc, {"label": "MLA_ACC_READ"})
    acc = model.Component("reg_read_mux_16x32", None, acc_loc,
                          {"label": "MLA_ACC_READ"})
    ap = {p.name: p.at(acc) for p in geometry.ports(design, acc)}
    for index in range(16):
        text = add_tunnel(text, circuit, ap["r%d" % index], "r%d" % index, 32)
    text = add_tunnel(text, circuit, (1780, 930), "MUL_ACC_SEL", 4)
    text = add_tunnel(text, circuit, ap["sel"], "MUL_ACC_SEL", 4)
    text = add_tunnel(text, circuit, ap["value"], "MUL_ACC_VALUE", 32)

    # Normal data-processing writes instr[15:12]; short multiply writes
    # instr[19:16].  Cut only the normal-WA source segment and leave the entire
    # existing destination trunk intact behind the new selector.
    source_seg = (2580, 1090, 2610, 1090)
    if edit.safe_to_remove(design, circuit, source_seg):
        raise RuntimeError("WA source has a mid-wire dependency; refusing edit")
    text = edit.remove_wire(text, circuit, source_seg)
    text = add_tunnel(text, circuit, (2580, 1090), "WA_NORMAL", 4)
    text = add_tunnel(text, circuit, (1780, 970), "MUL_DEST", 4)
    text = add_tunnel(text, circuit, (2610, 1090), "WA_FINAL", 4)
    wa_attrs = {"width": "4", "label": "SHORT_MUL_DEST_SELECT"}
    text = edit.add_component(text, circuit, "4", "Multiplexer",
                              (3300, 2300), wa_attrs)
    wp = ports(design, "Multiplexer", "4", (3300, 2300), wa_attrs)
    text = add_tunnel(text, circuit, wp["in0"], "WA_NORMAL", 4)
    text = add_tunnel(text, circuit, wp["in1"], "MUL_DEST", 4)
    text = add_tunnel(text, circuit, wp["sel"], "MUL_SHORT")
    text = add_tunnel(text, circuit, wp["out"], "WA_FINAL", 4)
    return text


def patch_ex(text, design):
    circuit = "stage_EX"
    for loc, label, width, tunnel in (
        ((410, 3100), "is_mul", 1, "MUL_SHORT"),
        ((410, 3140), "is_mla", 1, "MUL_MLA"),
        ((410, 3180), "mul_acc_value", 32, "MUL_ACC_VALUE"),
    ):
        text = add_pin(text, circuit, loc, label, width, output=False)
        text = add_tunnel(text, circuit, loc, tunnel, width)

    # Rm already reaches rd_b; Rs is the independent read port introduced for
    # register-specified shifts.  Low 32 product bits are identical for signed
    # and unsigned multiplication, so unsigned mode is sufficient for MUL/MLA.
    text = add_tunnel(text, circuit, (700, 600), "MUL_RM", 32)
    text = add_tunnel(text, circuit, (410, 2880), "MUL_RS", 32)
    text = edit.add_component(text, circuit, "0", "Constant", (2300, 2800),
                              {"width": "32", "value": "0x0"})
    text = add_tunnel(text, circuit, (2300, 2800), "MUL_ZERO32", 32)

    mul_attrs = {"width": "32", "mode": "unsigned", "label": "FAST_MUL32"}
    mul_loc = (2500, 2900)
    text = edit.add_component(text, circuit, "5", "Multiplier", mul_loc, mul_attrs)
    mp = ports(design, "Multiplier", "5", mul_loc, mul_attrs)
    text = add_tunnel(text, circuit, mp["a"], "MUL_RM", 32)
    text = add_tunnel(text, circuit, mp["b"], "MUL_RS", 32)
    text = add_tunnel(text, circuit, mp["cin"], "MUL_ZERO32", 32)
    text = add_tunnel(text, circuit, mp["out"], "MUL_PRODUCT", 32)

    add_attrs = {"width": "32", "label": "MLA_ADD"}
    add_loc = (2800, 3000)
    text = edit.add_component(text, circuit, "5", "Adder", add_loc, add_attrs)
    ap = ports(design, "Adder", "5", add_loc, add_attrs)
    text = add_tunnel(text, circuit, ap["a"], "MUL_PRODUCT", 32)
    text = add_tunnel(text, circuit, ap["b"], "MUL_ACC_VALUE", 32)
    text = edit.add_component(text, circuit, "0", "Constant", ap["cin"],
                              {"value": "0x0"})
    text = add_tunnel(text, circuit, ap["out"], "MLA_SUM", 32)

    mla_mux_attrs = {"width": "32", "label": "MUL_OR_MLA"}
    text = edit.add_component(text, circuit, "4", "Multiplexer",
                              (3050, 2940), mla_mux_attrs)
    xp = ports(design, "Multiplexer", "4", (3050, 2940), mla_mux_attrs)
    text = add_tunnel(text, circuit, xp["in0"], "MUL_PRODUCT", 32)
    text = add_tunnel(text, circuit, xp["in1"], "MLA_SUM", 32)
    text = add_tunnel(text, circuit, xp["sel"], "MUL_MLA")
    text = add_tunnel(text, circuit, xp["out"], "MUL_VALUE", 32)

    # Override only the two EX outputs needed by short multiply.  WB still
    # performs the existing condition-code gate, so failed conditions cannot
    # write the register file.
    for seg in ((2050, 690, 2120, 690), (2050, 790, 2120, 790)):
        if edit.safe_to_remove(design, circuit, seg):
            raise RuntimeError("EX output has a mid-wire dependency; refusing edit")
        text = edit.remove_wire(text, circuit, seg)
    text = add_tunnel(text, circuit, (2050, 690), "ALU_RESULT_OLD", 32)
    text = add_tunnel(text, circuit, (2120, 690), "EX_RESULT_FINAL", 32)
    text = add_tunnel(text, circuit, (2050, 790), "ALU_WE_OLD")
    text = add_tunnel(text, circuit, (2120, 790), "EX_WE_FINAL")

    result_attrs = {"width": "32", "label": "SHORT_MUL_RESULT_SELECT"}
    text = edit.add_component(text, circuit, "4", "Multiplexer",
                              (3350, 2900), result_attrs)
    rp = ports(design, "Multiplexer", "4", (3350, 2900), result_attrs)
    text = add_tunnel(text, circuit, rp["in0"], "ALU_RESULT_OLD", 32)
    text = add_tunnel(text, circuit, rp["in1"], "MUL_VALUE", 32)
    text = add_tunnel(text, circuit, rp["sel"], "MUL_SHORT")
    text = add_tunnel(text, circuit, rp["out"], "EX_RESULT_FINAL", 32)

    we_attrs = {"label": "SHORT_MUL_WE_SELECT"}
    text = edit.add_component(text, circuit, "4", "Multiplexer",
                              (3350, 3020), we_attrs)
    wep = ports(design, "Multiplexer", "4", (3350, 3020), we_attrs)
    text = add_tunnel(text, circuit, wep["in0"], "ALU_WE_OLD")
    text = edit.add_component(text, circuit, "0", "Constant", wep["in1"],
                              {"value": "0x1"})
    text = add_tunnel(text, circuit, wep["sel"], "MUL_SHORT")
    text = add_tunnel(text, circuit, wep["out"], "EX_WE_FINAL")
    return text


def patch_main(text, path):
    # Reload after interface edits.  Subcircuit ports bind positionally, so the
    # fresh model is the authority for the three newly appended ports.
    path.write_text(text)
    design = model.load(path)
    main = design["main"]
    instances = {c.name: c for c in main.components if c.is_subcircuit}
    mapping = {
        ("stage_ID", "is_mul"): ("MUL_SHORT", 1),
        ("stage_ID", "is_mla"): ("MUL_MLA", 1),
        ("stage_ID", "mul_acc_value"): ("MUL_ACC_VALUE", 32),
        ("stage_EX", "is_mul"): ("MUL_SHORT", 1),
        ("stage_EX", "is_mla"): ("MUL_MLA", 1),
        ("stage_EX", "mul_acc_value"): ("MUL_ACC_VALUE", 32),
    }
    for (stage, port), (label, width) in mapping.items():
        comp = instances[stage]
        pp = {p.name: p.at(comp) for p in geometry.ports(design, comp)}
        text = add_tunnel(text, "main", pp[port], label, width)
    return text


def main():
    path = Path(sys.argv[1] if len(sys.argv) > 1
                else "debug_armv4t_2_multiply.circ")
    if path.name in PROTECTED:
        raise SystemExit("refusing protected circuit: %s" % path)
    if not path.name.startswith("debug_"):
        raise SystemExit("target must be a debug variation: %s" % path)
    text = path.read_text()
    if 'label" val="SHORT_MUL_DECODE"' in text:
        raise SystemExit("short multiply is already wired in %s" % path)

    design = model.load(path)
    text = patch_id(text, design)
    path.write_text(text)
    design = model.load(path)
    text = patch_ex(text, design)
    text = patch_main(text, path)
    path.write_text(text)
    print("wired short MUL/MLA into", path)
    print("left mul_32 unchanged")


if __name__ == "__main__":
    main()
