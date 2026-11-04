#!/usr/bin/env python3
"""Build a copy of the CPU whose data RAM is four 8-bit banks.

Why: the single 32-bit DATA_RAM uses "Use byte enables", and Logisim's
simulator and Logisim's own VHDL exporter number those four byte-enable pins
in opposite orders -- reversing the four wires flips which engine stores
`strb`/`strh` into the right byte.  No wiring can be right in both.  Four
plain 8-bit RAMs have no byte-enable pins, so there is nothing to disagree on.

In stage_MEM the one RAM is replaced by:

    bank j (j = 0..3): 256 x 8-bit RAM, falling-edge write, holds bits 8j+7:8j
        addr    <- the old RAM's address net
        data_in <- byte j of the old data_in net
        we      <- old we  AND  old byte-enable line for byte j
        oe, clk <- the old oe / clk nets
    data_out net <- the four banks' outputs recombined

Every old port net is reached with a tunnel at the old pin's location, so no
existing wire moves.  The source circuit is only read.

    python3 tools/build_ram_4bank.py arm_custom_subset.circ out.circ [--reverse-lanes]
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from logisim import edit, geometry, model  # noqa: E402

C = "stage_MEM"
RAM_LOC = (3110, 1800)
# The old RAM's pins (Logisim-evolution appearance, byte enables on).  Its four
# byte-enable pins sit at y = 1870..1900.  Which byte each one means is the
# point in dispute, so the mapping below is checked by test, not by name.
OLD = {"addr": ((3110, 1810), 8), "we": ((3110, 1850), 1), "oe": ((3110, 1860), 1),
       "clk": ((3110, 1910), 1), "din": ((3110, 1930), 32), "dout": ((3350, 1930), 32)}
BE_PIN_Y = (1870, 1880, 1890, 1900)


def tunnel(text, loc, label, width=1):
    attrs = {"label": label}
    if width != 1:
        attrs["width"] = str(width)
    return edit.add_component(text, C, "0", "Tunnel", loc, attrs)


def part(text, lib, name, loc, attrs, signals):
    text = edit.add_component(text, C, lib, name, loc, attrs)
    comp = model.Component(name, lib, loc, attrs)
    ports = {p.name: p.at(comp) for p in geometry.ports(None, comp)}
    for port, (label, width) in signals.items():
        text = tunnel(text, ports[port], label, width)
    return text


def build(src, dst, reverse_lanes=False):
    text = Path(src).read_text()
    a, b = edit._circuit_span(text, C)
    body = text[a:b]
    m = re.search(r'    <comp lib="2" loc="\(%d,%d\)" name="RAM">\n(?:      <a [^\n]*\n)*    </comp>\n'
                  % RAM_LOC, body)
    if not m or 'byteEnables' not in m.group(0) or 'val="32"' not in m.group(0):
        raise SystemExit("expected the 32-bit byte-enable DATA_RAM at %s in %s" % (RAM_LOC, C))
    text = text[:a] + body.replace(m.group(0), "", 1) + text[b:]

    for key, (loc, width) in OLD.items():
        text = tunnel(text, loc, "MB_" + key.upper(), width)
    # Byte j's enable pin.  Default: the bottom pin (y=1900) is byte 0 -- the
    # order Logisim's simulator uses, which is what made the old circuit pass
    # the jar tests.  --reverse-lanes is the exporter's order.
    pins = BE_PIN_Y if reverse_lanes else tuple(reversed(BE_PIN_Y))
    for j, y in enumerate(pins):
        text = tunnel(text, (3110, y), "MB_LANE%d" % j)

    lanes = {"incoming": "32", "fanout": "4"}
    lanes.update({"bit%d" % k: str(k // 8) for k in range(32)})
    text = part(text, "0", "Splitter", (4700, 600), lanes,
                {"combined": ("MB_DIN", 32), **{"bit%d" % j: ("MB_DIN%d" % j, 8) for j in range(4)}})
    text = part(text, "0", "Splitter", (4700, 900), lanes,
                {"combined": ("MB_DOUT", 32), **{"bit%d" % j: ("MB_DOUT%d" % j, 8) for j in range(4)}})
    for j in range(4):
        y = 1200 + 300 * j
        text = part(text, "1", "AND Gate", (4800, y - 100), {"label": "MB_WE_AND%d" % j},
                    {"in0": ("MB_WE", 1), "in1": ("MB_LANE%d" % j, 1), "out": ("MB_WE%d" % j, 1)})
        text = part(text, "2", "RAM", (4900, y),
                    {"appearance": "logisim_evolution", "dataWidth": "8",
                     "label": "DATA_RAM_B%d" % j, "labelvisible": "true", "trigger": "falling"},
                    {"addr": ("MB_ADDR", 8), "we": ("MB_WE%d" % j, 1), "oe": ("MB_OE", 1),
                     "clk": ("MB_CLK", 1), "data_in": ("MB_DIN%d" % j, 8),
                     "data_out": ("MB_DOUT%d" % j, 8)})
    Path(dst).parent.mkdir(parents=True, exist_ok=True)
    Path(dst).write_text(text)


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if len(args) != 2:
        raise SystemExit(__doc__)
    build(args[0], args[1], "--reverse-lanes" in sys.argv)
    print("wrote", args[1])
