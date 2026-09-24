#!/usr/bin/env python3
"""Build a disposable pre-multiply-ready circuit from the current hand build."""

import argparse
from pathlib import Path
import shutil
import sys


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from logisim import edit, geometry, model

DEFAULT_SOURCE = ROOT / "arm_custom_subset.circ"
DEFAULT_OUTPUT = ROOT / "build/pre_multiply_ready/arm_custom_subset_pre_mul.circ"


def add_tunnel(text, circuit, loc, label, width=1):
    attrs = {"label": label}
    if width != 1:
        attrs["width"] = str(width)
    return edit.add_component(text, circuit, "0", "Tunnel", loc, attrs)


def add_part(text, circuit, lib, name, loc, attrs, signals):
    text = edit.add_component(text, circuit, lib, name, loc, attrs)
    component = model.Component(name, lib, loc, attrs)
    ports = {port.name: port.at(component)
             for port in geometry.ports(None, component)}
    for port, (label, width) in signals.items():
        text = add_tunnel(text, circuit, ports[port], label, width)
    return text


def repair_shift_edges(target: Path):
    text = target.read_text()
    if 'label" val="IMM_SHIFT32_ACTIVE"' in text:
        raise SystemExit("shift-edge repair is already present")

    old = '    <comp lib="5" loc="(810,2990)" name="Comparator"/>\n'
    new = ('    <comp lib="5" loc="(810,2990)" name="Comparator">\n'
           '      <a name="mode" val="unsigned"/>\n'
           '    </comp>\n')
    if old not in text:
        raise SystemExit("expected Rs-vs-32 comparator was not found")
    text = text.replace(old, new, 1)

    for loc, label, width in [
        ((700, 1850), "SHIFT_TYPE_EDGE", 2),
        ((410, 2660), "REG_SHIFT_EDGE", 1),
        ((700, 1320), "IMM_BIT_EDGE", 1),
        ((1720, 1520), "REG_LARGE_RESULT", 1),
    ]:
        text = add_tunnel(text, "stage_EX", loc, label, width)

    for loc, value, label in [((4300, 2450), "0x1", "TYPE_LSR"),
                              ((4300, 2490), "0x2", "TYPE_ASR")]:
        text = edit.add_component(text, "stage_EX", "0", "Constant", loc,
                                  {"width": "2", "value": value})
        text = add_tunnel(text, "stage_EX", loc, label, 2)
    text = add_part(text, "stage_EX", "5", "Comparator", (4400, 2200),
                    {"width": "2", "mode": "unsigned", "label": "IS_LSR"},
                    {"a": ("SHIFT_TYPE_EDGE", 2), "b": ("TYPE_LSR", 2),
                     "eq": ("IS_LSR", 1)})
    text = add_part(text, "stage_EX", "5", "Comparator", (4400, 2280),
                    {"width": "2", "mode": "unsigned", "label": "IS_ASR"},
                    {"a": ("SHIFT_TYPE_EDGE", 2), "b": ("TYPE_ASR", 2),
                     "eq": ("IS_ASR", 1)})
    text = add_part(text, "stage_EX", "1", "OR Gate", (4550, 2240),
                    {"label": "IS_LSR_OR_ASR"},
                    {"in0": ("IS_LSR", 1), "in1": ("IS_ASR", 1),
                     "out": ("IS_LSR_OR_ASR", 1)})
    text = add_part(text, "stage_EX", "1", "NOT Gate", (4550, 2340),
                    {"label": "NOT_REG_SHIFT_EDGE"},
                    {"in": ("REG_SHIFT_EDGE", 1),
                     "out": ("NOT_REG_SHIFT_EDGE", 1)})
    text = add_part(text, "stage_EX", "1", "NOT Gate", (4550, 2400),
                    {"label": "NOT_IMM_BIT_EDGE"},
                    {"in": ("IMM_BIT_EDGE", 1),
                     "out": ("NOT_IMM_BIT_EDGE", 1)})
    text = add_part(text, "stage_EX", "1", "AND Gate", (4700, 2320),
                    {"inputs": "4", "label": "IMM_SHIFT32_ACTIVE"},
                    {"in0": ("IS_LSR_OR_ASR", 1), "in1": ("IMM_ZERO", 1),
                     "in2": ("NOT_REG_SHIFT_EDGE", 1),
                     "in3": ("NOT_IMM_BIT_EDGE", 1),
                     "out": ("IMM_SHIFT32_ACTIVE", 1)})
    text = add_part(text, "stage_EX", "1", "OR Gate", (4850, 2200),
                    {"label": "USE_LARGE_FINAL"},
                    {"in0": ("REG_LARGE_RESULT", 1),
                     "in1": ("IMM_SHIFT32_ACTIVE", 1),
                     "out": ("USE_LARGE_FINAL", 1)})
    text = edit.remove_wire(text, "stage_EX", (1820, 1290, 1940, 1290))
    text = add_tunnel(text, "stage_EX", (1820, 1290), "USE_LARGE_FINAL")

    target.write_text(text)
    model.load(target)
    print(f"fixed immediate shift-32 and unsigned Rs boundaries in {target}")


def repair_extra_transfer_writeback(target: Path):
    text = target.read_text()
    if 'label" val="ALL_STORE_CONTROL"' in text:
        raise SystemExit("extra-transfer writeback repair is already present")

    # Join the normal STR decoder with the existing extra-transfer store
    # decoder.  The combined signal must drive SBWE, DATA_RAM_WE, and the
    # normal-write suppression path, not only the RAM byte-enable logic.
    text = add_tunnel(text, "stage_MEM", (940, 1080), "NORMAL_STORE_CONTROL")
    text = add_tunnel(text, "stage_MEM", (2780, 1340), "EXTRA_STORE_CONTROL")
    or_loc = (4700, 1000)
    text = edit.add_component(text, "stage_MEM", "1", "OR Gate", or_loc,
                              {"label": "ALL_STORE_CONTROL"})
    component = model.Component("OR Gate", "1", or_loc,
                                {"label": "ALL_STORE_CONTROL"})
    ports = {port.name: port.at(component)
             for port in geometry.ports(None, component)}
    text = add_tunnel(text, "stage_MEM", ports["in0"], "NORMAL_STORE_CONTROL")
    text = add_tunnel(text, "stage_MEM", ports["in1"], "EXTRA_STORE_CONTROL")
    text = add_tunnel(text, "stage_MEM", ports["out"], "ALL_STORE_CONTROL")

    text = edit.remove_wire(text, "stage_MEM", (1260, 850, 1740, 850))
    text = add_tunnel(text, "stage_MEM", (1740, 850), "ALL_STORE_CONTROL")

    # Apply condition gating to the extra-store RAM write.  Keep the raw
    # decoder connected to the byte-enable logic, but replace its branch into
    # RAM_WE with the condition-qualified signal.
    text = add_tunnel(text, "stage_MEM", (720, 1940), "COND_PASS_MEM")
    active_loc = (4700, 1100)
    text = edit.add_component(text, "stage_MEM", "1", "AND Gate", active_loc,
                              {"label": "EXTRA_STORE_ACTIVE"})
    component = model.Component("AND Gate", "1", active_loc,
                                {"label": "EXTRA_STORE_ACTIVE"})
    ports = {port.name: port.at(component)
             for port in geometry.ports(None, component)}
    text = add_tunnel(text, "stage_MEM", ports["in0"], "EXTRA_STORE_CONTROL")
    text = add_tunnel(text, "stage_MEM", ports["in1"], "COND_PASS_MEM")
    text = add_tunnel(text, "stage_MEM", ports["out"], "EXTRA_STORE_ACTIVE")
    text = edit.remove_wire(text, "stage_MEM", (2150, 1040, 2150, 1140))
    text = add_tunnel(text, "stage_MEM", (2160, 1040), "EXTRA_STORE_ACTIVE")

    # DATA_RAM_WE is consumed outside stage_MEM to suppress the ordinary ALU
    # write.  It must include every condition-qualified single-data store.
    text = add_tunnel(text, "stage_MEM", (1850, 1050), "NORMAL_STORE_ACTIVE")
    active_or_loc = (4700, 1200)
    text = edit.add_component(text, "stage_MEM", "1", "OR Gate", active_or_loc,
                              {"label": "ALL_STORE_ACTIVE"})
    component = model.Component("OR Gate", "1", active_or_loc,
                                {"label": "ALL_STORE_ACTIVE"})
    ports = {port.name: port.at(component)
             for port in geometry.ports(None, component)}
    text = add_tunnel(text, "stage_MEM", ports["in0"], "NORMAL_STORE_ACTIVE")
    text = add_tunnel(text, "stage_MEM", ports["in1"], "EXTRA_STORE_ACTIVE")
    text = add_tunnel(text, "stage_MEM", ports["out"], "ALL_STORE_ACTIVE")
    text = edit.remove_wire(text, "stage_MEM", (1850, 1050, 1870, 1050))
    text = add_tunnel(text, "stage_MEM", (1870, 1050), "ALL_STORE_ACTIVE")

    # The existing combined load decoder already includes ordinary LDR plus
    # extra LDRH/LDRSB/LDRSH.  Use it for base writeback as well as Rd writes.
    text = add_tunnel(text, "stage_MEM", (1110, 970), "ALL_LOAD_CONTROL")
    text = edit.remove_wire(text, "stage_MEM", (960, 1150, 1740, 1150))
    text = add_tunnel(text, "stage_MEM", (1740, 1150), "ALL_LOAD_CONTROL")

    target.write_text(text)
    model.load(target)
    print(f"fixed extra-transfer writeback control in {target}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    source = args.source.resolve()
    output = args.output.resolve()
    if source == output:
        raise SystemExit("source and sandbox output must be different files")
    if source.name != "arm_custom_subset.circ":
        raise SystemExit("expected arm_custom_subset.circ as the source snapshot")

    output.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, output)
    repair_shift_edges(output)
    repair_extra_transfer_writeback(output)
    print(f"sandbox source: {source}")
    print(f"sandbox output: {output}")


if __name__ == "__main__":
    main()
