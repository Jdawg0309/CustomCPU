#!/usr/bin/env python3
"""Prevent register-specified ROR using Rs=r0 from decoding as RRX."""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from logisim import edit, model

ROOT = Path(__file__).resolve().parent.parent
PATH = ROOT / "pipelined_debug_armv4t_2.circ"


def main():
    text = PATH.read_text()
    old = '<comp lib="0" loc="(950,3980)" name="Tunnel"><a name="label" val="RRX_ACTIVE"/></comp>'
    new = '<comp lib="0" loc="(950,3980)" name="Tunnel"><a name="label" val="RRX_ACTIVE_RAW"/></comp>'
    if old not in text:
        raise SystemExit("expected RRX_ACTIVE source tunnel not found")
    text = text.replace(old, new, 1)

    # Select raw RRX only for an immediate-shift encoding (reg_shift=0).
    # A register-specified ROR (reg_shift=1), including one using Rs=r0,
    # must force RRX_ACTIVE low.
    text = edit.add_component(text, "stage_EX", "4", "Multiplexer", (3600, 6000), {})
    for loc, label in [
        ((3570, 5990), "RRX_ACTIVE_RAW"),
        ((3570, 6010), "K0"),
        ((3580, 6020), "REG_SHIFT_SHIFT32"),
        ((3600, 6000), "RRX_ACTIVE"),
    ]:
        text = edit.add_component(text, "stage_EX", "0", "Tunnel", loc, {"label": label})
    PATH.write_text(text)
    model.load(PATH)
    print("RRX_ACTIVE = reg_shift ? 0 : RRX_ACTIVE_RAW")


if __name__ == "__main__":
    main()
