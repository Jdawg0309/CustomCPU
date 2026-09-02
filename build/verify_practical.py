#!/usr/bin/env python3
"""Verify the exact first practical-C image and its fetch-capacity contract."""

from __future__ import annotations

import xml.etree.ElementTree as ET
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
EXPECTED_WORDS = (
    0xE3A0DB01,  # MOV SP,#0x400
    0xE3A00004,  # MOV R0,#4
    0xEB000000,  # BL main
    0xEAFFFFFE,  # B .
    0xE3A03001,  # MOV R3,#1
    0xE24DD008,  # SUB SP,SP,#8
    0xE58D3004,  # STR R3,[SP,#4]
    0xE250C000,  # SUBS R12,R0,#0
    0xE59D1004,  # LDR R1,[SP,#4]
    0x0A000009,  # BEQ zero-limit path
    0xE3A00000,  # MOV R0,#0
    0xE0811003,  # ADD R1,R1,R3
    0xE15C0003,  # CMP R12,R3
    0xE0800001,  # ADD R0,R0,R1
    0xE2833001,  # ADD R3,R3,#1
    0x1AFFFFFA,  # BNE loop
    0xE3A03000,  # MOV R3,#0
    0xE5830100,  # STR R0,[R3,#0x100]
    0xE28DD008,  # ADD SP,SP,#8
    0xE12FFF1E,  # BX LR
    0xE1A0000C,  # MOV R0,R12 (zero-limit path)
    0xEAFFFFF9,  # B store-result path
)


def attributes(component: ET.Element) -> dict[str, str]:
    return {
        child.attrib["name"]: child.attrib.get("val", "")
        for child in component.findall("a")
    }


def check_rom() -> None:
    lines = (HERE / "practical_rom").read_text(encoding="ascii").split()
    if lines[:4] != ["v3.0", "hex", "words", "plain"]:
        raise SystemExit("practical_rom has an invalid Logisim header")
    words = tuple(int(word, 16) for word in lines[4:])
    if words != EXPECTED_WORDS:
        raise SystemExit("practical_rom does not match the reviewed GCC image")


def check_circuit() -> None:
    root = ET.parse(ROOT / "armv4t.circ").getroot()
    circuits = {circuit.attrib["name"]: circuit for circuit in root.findall("circuit")}

    main = circuits["main"]
    instruction_roms = []
    for component in main.findall("comp"):
        if component.attrib.get("name") != "ROM":
            continue
        attrs = attributes(component)
        if attrs.get("dataWidth") == "32":
            instruction_roms.append(attrs)
    if len(instruction_roms) != 1 or instruction_roms[0].get("addrWidth") != "8":
        raise SystemExit("main.instr_rom must be exactly one 8-bit x 32-bit ROM")

    pc_fetch = circuits["pc_fetch"]
    pc_out = None
    pc_splitter = None
    for component in pc_fetch.findall("comp"):
        attrs = attributes(component)
        if component.attrib.get("name") == "Pin" and attrs.get("label") == "pc_out":
            pc_out = attrs
        if component.attrib.get("name") == "Splitter" and attrs.get("incoming") == "32":
            pc_splitter = attrs
    if pc_out is None or pc_out.get("width") != "8":
        raise SystemExit("pc_fetch.pc_out must be 8 bits")
    if pc_splitter is None or any(pc_splitter.get(f"bit{bit}") != "1" for bit in range(2, 10)):
        raise SystemExit("pc_fetch.pc_out must select PC[9:2]")


def main() -> None:
    check_rom()
    check_circuit()
    print("practical C image: 22 reviewed ARM words")
    print("instruction fetch: PC[9:2], 256-word capacity")
    print("expected halt signature: R0=00000018 SP=00000400 RAM[40]=00000018")


if __name__ == "__main__":
    main()
