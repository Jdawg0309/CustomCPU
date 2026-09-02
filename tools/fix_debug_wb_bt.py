#!/usr/bin/env python3
"""Suppress ordinary ALU writes while a block transfer is active.

This is intentionally restricted to debug_armv4t_2.circ.  It adds the missing
stage_WB.bt_active input, ORs it into the existing suppression path, and joins
stage_MEM.bt_active to the new WB port in main.
"""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from logisim import edit


PATH = Path("debug_armv4t_2.circ")


def main():
    text = PATH.read_text()
    if 'label" val="bt_active"' in text[text.index('<circuit name="stage_WB"'):text.index('\n  </circuit>', text.index('<circuit name="stage_WB"'))]:
        raise SystemExit("stage_WB.bt_active already exists")

    # Append the interface pin below all existing WB inputs so no old port moves.
    text = edit.add_component(text, "stage_WB", "0", "Pin", (760, 1850), {
        "appearance": "classic", "facing": "east", "label": "bt_active",
    })

    # suppress_all = old_suppress OR bt_active.  Break only the final segment
    # into NOT_SUPPRESS; the old suppress probe remains on the original net.
    text = edit.remove_wire(text, "stage_WB", (1680, 940, 1740, 940))
    text = edit.add_component(text, "stage_WB", "1", "OR Gate", (1200, 2050), {
        "label": "OR_BT_SUPPRESS",
    })
    # Tunnels avoid crossing the dense WB control wiring.
    for loc, label, facing in (
        ((1680, 940), "WB_SUPPRESS_OLD", "west"),
        ((1150, 2030), "WB_SUPPRESS_OLD", "east"),
        ((760, 1850), "WB_BT_ACTIVE", "west"),
        ((1150, 2070), "WB_BT_ACTIVE", "east"),
        ((1200, 2050), "WB_SUPPRESS_ALL", "west"),
        ((1740, 940), "WB_SUPPRESS_ALL", "east"),
    ):
        text = edit.add_component(text, "stage_WB", "0", "Tunnel", loc, {
            "facing": facing, "label": label,
        })

    # The appended WB input is at (6580,1260) in the current main instance.
    # Join it to the already-existing BT_ACTIVE tunnel net.
    text = edit.add_component(text, "main", "0", "Tunnel", (6520, 1260), {
        "facing": "east", "label": "BT_ACTIVE",
    })
    text = edit.add_wires(text, "main", [(6520, 1260, 6580, 1260)])

    PATH.write_text(text)
    print("patched debug stage_WB: bt_active now suppresses normal_we")


if __name__ == "__main__":
    main()
