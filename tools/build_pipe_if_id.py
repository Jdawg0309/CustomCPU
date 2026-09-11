#!/usr/bin/env python3
"""Add the first real pipeline boundary, pipe_if_id, to the pipeline copy."""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from logisim import geometry, model

ROOT = Path(__file__).resolve().parent.parent
PATH = ROOT / "pipelined_debug_armv4t_2.circ"


def attrs_xml(attrs):
    return "".join(f'      <a name="{k}" val="{v}"/>\n' for k, v in attrs.items())


def comp(lib, name, loc, **attrs):
    return f'    <comp lib="{lib}" loc="({loc[0]},{loc[1]})" name="{name}">\n{attrs_xml(attrs)}    </comp>\n'


def wire(a, b):
    return f'    <wire from="({a[0]},{a[1]})" to="({b[0]},{b[1]})"/>\n'


def tunnel(loc, label, width=1):
    attrs = {"label": label}
    if width != 1:
        attrs["width"] = str(width)
    return comp("0", "Tunnel", loc, **attrs)


def pin(loc, label, width=1, output=False):
    attrs = {"appearance": "classic", "label": label}
    if width != 1:
        attrs["width"] = str(width)
    if output:
        attrs.update({"facing": "west", "output": "true"})
    else:
        attrs["facing"] = "east"
    return comp("0", "Pin", loc, **attrs)


class Builder:
    def __init__(self):
        self.body = []

    def part(self, lib, name, loc, attrs, ports):
        self.body.append(comp(lib, name, loc, **attrs))
        component = model.Component(name, lib, loc, attrs)
        actual = {port.name: port.at(component) for port in geometry.ports(None, component)}
        for port_name, (label, width) in ports.items():
            self.body.append(tunnel(actual[port_name], label, width))


def build():
    b = Builder()
    ports = [
        ((100, 100), "clk", 1, False),
        ((100, 160), "rst", 1, False),
        ((100, 220), "enable", 1, False),
        ((100, 280), "flush", 1, False),
        ((100, 360), "instruction_in", 32, False),
        ((100, 440), "pc_word_addr_in", 32, False),
        ((100, 520), "pc_plus4_in", 32, False),
        ((100, 600), "valid_in", 1, False),
        ((1000, 360), "instruction_out", 32, True),
        ((1000, 440), "pc_word_addr_out", 32, True),
        ((1000, 520), "pc_plus4_out", 32, True),
        ((1000, 600), "valid_out", 1, True),
    ]
    for loc, label, width, output in ports:
        b.body += [pin(loc, label, width, output), tunnel(loc, label.upper(), width)]

    b.body += [
        comp("0", "Constant", (260, 700), width="32", value="0xe1a00000"),
        tunnel((260, 700), "ARM_NOP", 32),
        comp("0", "Constant", (260, 740), value="0x0"), tunnel((260, 740), "ZERO1"),
    ]

    # Flush replaces the instruction with NOP and clears valid. Address fields
    # may advance because valid=0 makes them architecturally irrelevant.
    b.part("4", "Multiplexer", (430, 360), {"width": "32", "label": "IFID_INSTR_FLUSH"},
           {"in0": ("INSTRUCTION_IN", 32), "in1": ("ARM_NOP", 32),
            "sel": ("FLUSH", 1), "out": ("IFID_INSTR_D", 32)})
    b.part("4", "Multiplexer", (430, 600), {"label": "IFID_VALID_FLUSH"},
           {"in0": ("VALID_IN", 1), "in1": ("ZERO1", 1),
            "sel": ("FLUSH", 1), "out": ("IFID_VALID_D", 1)})

    for y, label, width, d_signal, q_signal in [
        (360, "IFID_INSTRUCTION", 32, "IFID_INSTR_D", "INSTRUCTION_OUT"),
        (440, "IFID_PC_WORD", 32, "PC_WORD_ADDR_IN", "PC_WORD_ADDR_OUT"),
        (520, "IFID_PC_PLUS4", 32, "PC_PLUS4_IN", "PC_PLUS4_OUT"),
        (600, "IFID_VALID", 1, "IFID_VALID_D", "VALID_OUT"),
    ]:
        attrs = {"appearance": "logisim_evolution", "label": label,
                 "width": str(width)}
        b.part("2", "Register", (700, y - 30), attrs,
               {"D": (d_signal, width), "Q": (q_signal, width),
                "clk": ("CLK", 1), "clr": ("RST", 1), "en": ("ENABLE", 1)})

    return ('  <circuit name="pipe_if_id">\n'
            '    <a name="appearance" val="logisim_evolution"/>\n'
            '    <a name="circuit" val="pipe_if_id"/>\n' + "".join(b.body) + '  </circuit>\n')


def main():
    text = PATH.read_text()
    if '<circuit name="pipe_if_id"' in text:
        raise SystemExit("pipe_if_id already exists")
    anchor = text.index('  <circuit name="main"')
    PATH.write_text(text[:anchor] + build() + text[anchor:])
    model.load(PATH)
    print("added isolated pipe_if_id to", PATH)


if __name__ == "__main__":
    main()
