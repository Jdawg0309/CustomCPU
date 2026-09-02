#!/usr/bin/env python3
"""Semantic, read-only checker for the hand-wired ``stage_ID`` circuit.

Unlike a coordinate-based netlist diff, this checker follows the electrical
connections and discovers component roles from what they drive.  Moving a mux
or rerouting a wire therefore does not invalidate the ground truth.

Examples:

    python3 tools/check_stage_id.py armv4t_2.circ --through A
    python3 tools/check_stage_id.py armv4t_2.circ --through C
    python3 tools/check_stage_id.py armv4t_2.circ --through D --json

The circuit file is opened read-only by ``logisim.model.load``.  This script
does not contain any editing code and never writes a .circ file.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from typing import Dict, Iterable, List, Optional, Sequence

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)

from logisim import graph as G
from logisim.model import Component


GROUPS = "ABCD"


@dataclass
class Result:
    group: str
    checks: int = 0
    failures: List[str] = field(default_factory=list)

    def check(self, condition: bool, message: str) -> None:
        self.checks += 1
        if not condition:
            self.failures.append(message)

    @property
    def passed(self) -> bool:
        return not self.failures


class StageID:
    def __init__(self, path: str):
        self.path = path
        self.g = G.build(path, "stage_ID")
        self.c = self.g.circ
        self.pins: Dict[str, Component] = {
            c.attrs.get("label", ""): c
            for c in self.c.components if c.name == "Pin"
        }

    # ---- graph primitives -------------------------------------------------
    @staticmethod
    def pid(c: Component, port: str) -> str:
        return G.port_id(c, port)

    def pin(self, label: str) -> Optional[Component]:
        return self.pins.get(label)

    def pin_id(self, label: str) -> Optional[str]:
        p = self.pin(label)
        return self.pid(p, "p") if p else None

    def net_index(self, endpoint: Optional[str]) -> Optional[int]:
        if endpoint is None:
            return None
        net = self.g.net_of(endpoint)
        return net.index if net is not None else None

    def same_net(self, *endpoints: Optional[str]) -> bool:
        indices = [self.net_index(e) for e in endpoints]
        return bool(indices) and None not in indices and len(set(indices)) == 1

    def components(self, kind: str) -> List[Component]:
        return [c for c in self.c.components if c.name == kind]

    def component_driving_pin(self, kind: str, port: str,
                              label: str) -> Optional[Component]:
        target = self.pin_id(label)
        found = [c for c in self.components(kind)
                 if self.same_net(self.pid(c, port), target)]
        return found[0] if len(found) == 1 else None

    def component_driving_port(self, kind: str, out_port: str,
                               dst: Component, dst_port: str) -> Optional[Component]:
        target = self.pid(dst, dst_port)
        found = [c for c in self.components(kind)
                 if self.same_net(self.pid(c, out_port), target)]
        return found[0] if len(found) == 1 else None

    @staticmethod
    def attr_int(c: Component, name: str, default: int) -> int:
        return int(c.attrs.get(name, default), 0)

    @staticmethod
    def const_value(c: Optional[Component], width: int, value: int) -> bool:
        if c is None or c.name != "Constant":
            return False
        return (int(c.attrs.get("width", 1)) == width
                and int(c.attrs.get("value", "0"), 0) == value)

    def constant_on(self, endpoint: str, width: int,
                    value: int) -> Optional[Component]:
        matches = [c for c in self.components("Constant")
                   if self.const_value(c, width, value)
                   and self.same_net(self.pid(c, "p"), endpoint)]
        return matches[0] if matches else None

    def raw_attr(self, component: Component, name: str) -> str:
        """Read an attribute whose value is element text (not ``val=``).

        Logisim stores memory contents inside the ``<a>`` element body.  The
        normal model intentionally focuses on connectivity attributes, so the
        control-ROM check reads this one value directly and still read-only.
        """
        root = ET.parse(self.path).getroot()
        circuit = next((x for x in root.findall("circuit")
                        if x.get("name") == "stage_ID"), None)
        if circuit is None:
            return ""
        location = "(%d,%d)" % component.loc
        element = next((x for x in circuit.findall("comp")
                        if x.get("name") == component.name
                        and x.get("loc") == location), None)
        if element is None:
            return ""
        attr = next((x for x in element.findall("a") if x.get("name") == name), None)
        if attr is None:
            return ""
        return attr.get("val") if attr.get("val") is not None else (attr.text or "").strip()

    @staticmethod
    def splitter_bits(c: Component, fan: int) -> List[int]:
        incoming = int(c.attrs.get("incoming", c.attrs.get("fanout", 2)))
        bits = []
        for bit in range(incoming):
            value = c.attrs.get("bit%d" % bit, str(bit))
            if value != "none" and int(value) == fan:
                bits.append(bit)
        return bits

    def splitter(self, incoming: int, fanout: int,
                 mapping: Sequence[Sequence[int]]) -> Optional[Component]:
        found = []
        for c in self.components("Splitter"):
            if int(c.attrs.get("incoming", c.attrs.get("fanout", 2))) != incoming:
                continue
            if int(c.attrs.get("fanout", 2)) != fanout:
                continue
            if all(self.splitter_bits(c, fan) == list(bits)
                   for fan, bits in enumerate(mapping)):
                found.append(c)
        return found[0] if len(found) == 1 else None

    def require_net(self, r: Result, name: str,
                    *endpoints: Optional[str]) -> None:
        r.check(self.same_net(*endpoints), "%s is not one electrical net" % name)

    def require_pin(self, r: Result, label: str, direction: str, width: int) -> None:
        p = self.pin(label)
        if p is None:
            r.check(False, "missing port %s" % label)
            return
        actual_dir = "out" if p.attrs.get("output") == "true" else "in"
        actual_width = int(p.attrs.get("width", 1))
        r.check(actual_dir == direction and actual_width == width,
                "port %s is %s/%d; expected %s/%d"
                % (label, actual_dir, actual_width, direction, width))

    # ---- group A ----------------------------------------------------------
    def group_a(self) -> Result:
        r = Result("A")
        ports = {
            "instruction": ("in", 32), "rm": ("out", 4),
            "rd": ("out", 4), "rn": ("out", 4), "s_bit": ("out", 1),
            "opcode": ("out", 4), "class_bits": ("out", 3),
            "cond": ("out", 4), "imm8": ("out", 8), "rs": ("out", 4),
            "imm_bit": ("out", 1), "reg_shift": ("out", 1),
            "shift_type": ("out", 2), "shift_amount": ("out", 5),
            "instr_27_4": ("out", 24),
        }
        for name, (direction, width) in ports.items():
            self.require_pin(r, name, direction, width)

        main = self.splitter(32, 7, [range(0, 4), range(4, 12),
                                     range(12, 16), range(16, 20), [20],
                                     range(21, 25), range(25, 32)])
        imm = self.splitter(32, 3, [range(0, 8), range(8, 12), [25]])
        bx = self.splitter(32, 3, [range(0, 4), range(4, 28), range(28, 32)])
        hi = self.splitter(7, 2, [range(0, 3), range(3, 7)])
        shift = self.splitter(8, 3, [[0], range(1, 3), range(3, 8)])
        for name, comp in (("S_MAIN", main), ("S_IMM", imm), ("S_BX", bx),
                           ("S_HI", hi), ("S_SHIFT", shift)):
            r.check(comp is not None, "%s missing or has a wrong bit map" % name)
        if None in (main, imm, bx, hi, shift):
            return r

        instruction = self.pin_id("instruction")
        self.require_net(r, "instruction fanout", instruction,
                         self.pid(main, "combined"), self.pid(imm, "combined"),
                         self.pid(bx, "combined"))
        for fan, label in ((0, "rm"), (2, "rd"), (3, "rn"),
                           (4, "s_bit"), (5, "opcode")):
            self.require_net(r, label, self.pid(main, "bit%d" % fan),
                             self.pin_id(label))
        self.require_net(r, "S_MAIN[31:25] to S_HI",
                         self.pid(main, "bit6"), self.pid(hi, "combined"))
        self.require_net(r, "class_bits", self.pid(hi, "bit0"),
                         self.pin_id("class_bits"))
        self.require_net(r, "cond", self.pid(hi, "bit1"), self.pin_id("cond"))
        for fan, label in ((0, "imm8"), (1, "rs"), (2, "imm_bit")):
            self.require_net(r, label, self.pid(imm, "bit%d" % fan),
                             self.pin_id(label))
        self.require_net(r, "shift field", self.pid(main, "bit1"),
                         self.pid(shift, "combined"))
        for fan, label in ((0, "reg_shift"), (1, "shift_type"),
                           (2, "shift_amount")):
            self.require_net(r, label, self.pid(shift, "bit%d" % fan),
                             self.pin_id(label))
        self.require_net(r, "instr_27_4", self.pid(bx, "bit1"),
                         self.pin_id("instr_27_4"))
        return r

    # ---- group B ----------------------------------------------------------
    def group_b(self) -> Result:
        r = Result("B")
        regfiles = self.components("reg16x32_1")
        r.check(len(regfiles) == 1, "expected exactly one reg16x32_1 instance")
        if len(regfiles) != 1:
            return r
        rf = regfiles[0]

        m_wa_final = self.component_driving_port("Multiplexer", "out", rf, "WA")
        m_rb_final = self.component_driving_port("Multiplexer", "out", rf, "RB")
        r.check(m_wa_final is not None, "no unique mux drives regfile.WA")
        r.check(m_rb_final is not None, "no unique mux drives regfile.RB")
        if m_wa_final is None or m_rb_final is None:
            return r

        # Group E adds one outer mux to each index path.  Discover that layer
        # electrically instead of mistaking it for the original SB/RB muxes.
        has_bt = self.pin("bt_active") is not None and self.pin("bt_reg_idx") is not None
        if has_bt:
            for name, mux in (("M_WA_BT", m_wa_final), ("M_RB_BT", m_rb_final)):
                r.check(int(mux.attrs.get("width", 1)) == 4,
                        "%s is not 4-bit" % name)
                self.require_net(r, "%s.in1 = bt_reg_idx" % name,
                                 self.pid(mux, "in1"), self.pin_id("bt_reg_idx"))
                self.require_net(r, "%s.sel = bt_active" % name,
                                 self.pid(mux, "sel"), self.pin_id("bt_active"))
            m_wa_sb = self.component_driving_port("Multiplexer", "out",
                                                  m_wa_final, "in0")
            m_rb = self.component_driving_port("Multiplexer", "out",
                                               m_rb_final, "in0")
            r.check(m_wa_sb is not None,
                    "no normal write-address mux drives M_WA_BT.in0")
            r.check(m_rb is not None,
                    "no normal B-address mux drives M_RB_BT.in0")
            if m_wa_sb is None or m_rb is None:
                return r
        else:
            m_wa_sb, m_rb = m_wa_final, m_rb_final

        m_wa_bl = self.component_driving_port("Multiplexer", "out", m_wa_sb, "in0")
        r.check(m_wa_bl is not None, "no unique BL mux drives base-writeback mux input 0")
        if m_wa_bl is None:
            return r
        for name, mux in (("M_WA_BL", m_wa_bl), ("M_WA_SB", m_wa_sb),
                          ("M_RB", m_rb)):
            r.check(int(mux.attrs.get("width", 1)) == 4,
                    "%s is not 4-bit" % name)

        # Field nets are named by their stage output pins, so this remains
        # location-independent even if every splitter is moved.
        self.require_net(r, "M_WA_BL.in0 = Rd", self.pid(m_wa_bl, "in0"),
                         self.pin_id("rd"))
        r.check(self.constant_on(self.pid(m_wa_bl, "in1"), 4, 0xE) is not None,
                "M_WA_BL.in1 is not the 4-bit R14 constant")
        self.require_net(r, "M_WA_BL.sel = bl_taken", self.pid(m_wa_bl, "sel"),
                         self.pin_id("bl_taken"))
        self.require_net(r, "M_WA_SB.in1 = Rn", self.pid(m_wa_sb, "in1"),
                         self.pin_id("rn"))
        self.require_net(r, "M_WA_SB.sel = sbwe", self.pid(m_wa_sb, "sel"),
                         self.pin_id("sbwe"))
        self.require_net(r, "write address", self.pid(m_wa_final, "out"),
                         self.pid(rf, "WA"), self.pin_id("wa"))
        self.require_net(r, "M_RB.in0 = Rm", self.pid(m_rb, "in0"),
                         self.pin_id("rm"))
        self.require_net(r, "M_RB.in1 = Rd", self.pid(m_rb, "in1"),
                         self.pin_id("rd"))
        self.require_net(r, "M_RB.sel = data_ram_we", self.pid(m_rb, "sel"),
                         self.pin_id("data_ram_we"))

        for rf_port, pin in (("CLK", "clk"), ("RST", "rst"), ("RA", "rn"),
                             ("WD", "wd"), ("WE", "we"), ("WD2", "wd2"),
                             ("WE2", "we2"), ("WA2", "wa2")):
            self.require_net(r, "regfile.%s" % rf_port, self.pid(rf, rf_port),
                             self.pin_id(pin))
        return r

    # ---- group C ----------------------------------------------------------
    def group_c(self) -> Result:
        r = Result("C")
        regfiles = self.components("reg16x32_1")
        if len(regfiles) != 1:
            r.check(False, "cannot identify the unique reg16x32_1")
            return r
        rf = regfiles[0]
        m_rda = self.component_driving_pin("Multiplexer", "out", "rd_a")
        m_rdb = self.component_driving_pin("Multiplexer", "out", "rd_b")
        r.check(m_rda is not None, "no unique mux drives rd_a")
        r.check(m_rdb is not None, "no unique mux drives rd_b")
        if m_rda is None or m_rdb is None:
            return r
        r.check(int(m_rda.attrs.get("width", 1)) == 32, "M_RDA is not 32-bit")
        r.check(int(m_rdb.attrs.get("width", 1)) == 32, "M_RDB is not 32-bit")
        self.require_net(r, "M_RDA normal data", self.pid(rf, "RD_A"),
                         self.pid(m_rda, "in0"))
        self.require_net(r, "M_RDB normal data", self.pid(rf, "RD_B"),
                         self.pid(m_rdb, "in0"))

        add = self.component_driving_pin("Adder", "out", "pc_plus8")
        r.check(add is not None, "no unique adder drives pc_plus8")
        if add is None:
            return r
        r.check(int(add.attrs.get("width", 1)) == 32, "PC+8 adder is not 32-bit")
        self.require_net(r, "PC+8 distribution", self.pid(add, "out"),
                         self.pin_id("pc_plus8"), self.pid(m_rda, "in1"),
                         self.pid(m_rdb, "in1"))
        r.check(self.constant_on(self.pid(add, "b"), 32, 8) is not None,
                "PC+8 adder B input is not constant 8/32-bit")
        r.check(self.constant_on(self.pid(add, "cin"), 1, 0) is not None,
                "PC+8 adder carry-in is not constant zero")

        shifter = self.component_driving_port("Shifter", "out", add, "a")
        r.check(shifter is not None, "no shifter drives the PC+8 adder A input")
        if shifter is not None:
            r.check(int(shifter.attrs.get("width", 1)) == 32,
                    "PC byte-address shifter is not 32-bit")
            r.check(shifter.attrs.get("shift", "ll") == "ll",
                    "PC byte-address shifter is not logical-left")
            r.check(self.constant_on(self.pid(shifter, "dist"), 5, 2) is not None,
                    "PC byte-address shift distance is not constant 2/5-bit")
            ext = self.component_driving_port("Bit Extender", "out", shifter, "in")
            r.check(ext is not None, "no bit extender drives the PC shifter")
            if ext is not None:
                r.check(ext.attrs.get("in_width") == "10"
                        and ext.attrs.get("out_width") == "32"
                        and ext.attrs.get("type", "zero") == "zero",
                        "PC extender is not zero-extension 10 -> 32")
                self.require_net(r, "pc_word_addr to extender",
                                 self.pin_id("pc_word_addr"), self.pid(ext, "in"))

        # Find the comparators by the mux select nets.
        cmp_rn = self.component_driving_port("Comparator", "eq", m_rda, "sel")
        cmp_rb = self.component_driving_port("Comparator", "eq", m_rdb, "sel")
        r.check(cmp_rn is not None, "no equality comparator selects M_RDA")
        r.check(cmp_rb is not None, "no equality comparator selects M_RDB")
        if cmp_rn is not None:
            r.check(int(cmp_rn.attrs.get("width", 1)) == 4,
                    "Rn comparator is not 4-bit")
            self.require_net(r, "CMP_RN.a = Rn", self.pid(cmp_rn, "a"),
                             self.pin_id("rn"))
            r.check(self.constant_on(self.pid(cmp_rn, "b"), 4, 0xF) is not None,
                    "CMP_RN.b is not constant R15")
        if cmp_rb is not None:
            r.check(int(cmp_rb.attrs.get("width", 1)) == 4,
                    "selected-RB comparator is not 4-bit")
            m_rb = self.component_driving_port("Multiplexer", "out", rf, "RB")
            r.check(m_rb is not None, "cannot identify M_RB")
            if m_rb is not None:
                self.require_net(r, "CMP_RM.a = selected RB address",
                                 self.pid(cmp_rb, "a"), self.pid(m_rb, "out"),
                                 self.pid(rf, "RB"))
            r.check(self.constant_on(self.pid(cmp_rb, "b"), 4, 0xF) is not None,
                    "CMP_RM.b is not constant R15")
        return r

    # ---- group D ----------------------------------------------------------
    def group_d(self) -> Result:
        r = Result("D")
        splitters = [c for c in self.components("Splitter")
                     if int(c.attrs.get("incoming", c.attrs.get("fanout", 2))) == 16
                     and int(c.attrs.get("fanout", 2)) == 3]
        r.check(len(splitters) == 1, "expected one 16-bit/3-fan ROM-address splitter")
        roms = [c for c in self.components("ROM")
                if int(c.attrs.get("addrWidth", 8)) == 16
                and int(c.attrs.get("dataWidth", 8)) == 10]
        r.check(len(roms) == 1, "expected one 16-address-bit, 10-data-bit control ROM")
        if len(splitters) != 1 or len(roms) != 1:
            return r
        s, rom = splitters[0], roms[0]
        # Facing/appearance determine where the fan pins are drawn, not the
        # electrical meaning of a splitter once the actual nets and inverse
        # bit map below have been verified.  Do not reject a user's equivalent
        # layout merely because it mirrors the specification's drawing.
        r.check(self.splitter_bits(s, 0) == list(range(0, 4))
                and self.splitter_bits(s, 1) == [4]
                and self.splitter_bits(s, 2) == list(range(5, 16)),
                "ROM-address splitter bit map is wrong")
        self.require_net(r, "opcode to ROM address bits 3:0",
                         self.pin_id("opcode"), self.pid(s, "bit0"))
        r.check(self.constant_on(self.pid(s, "bit1"), 1, 0) is not None,
                "ROM address bit 4 is not tied to zero")
        r.check(self.constant_on(self.pid(s, "bit2"), 11, 0) is not None,
                "ROM address bits 15:5 are not tied to zero")
        self.require_net(r, "ROM address", self.pid(s, "combined"),
                         self.pid(rom, "addr"))
        self.require_net(r, "ALU control", self.pid(rom, "data_out"),
                         self.pin_id("alu_ctrl"))
        contents = " ".join(self.raw_attr(rom, "contents").split())
        wanted = "addr/data: 16 10 1 3 151 191 101 121 161 1a1 0 2 150 100 5 7 9 b 201"
        r.check(contents.lower() == wanted.lower(), "control ROM contents do not match stage_ID.md")
        return r


def run(path: str, through: str) -> tuple[List[Result], dict]:
    checker = StageID(path)
    results = []
    methods = {"A": checker.group_a, "B": checker.group_b,
               "C": checker.group_c, "D": checker.group_d}
    for group in GROUPS[:GROUPS.index(through) + 1]:
        results.append(methods[group]())
    payload = {
        "file": os.path.abspath(path),
        "circuit": "stage_ID",
        "through": through,
        "passed": all(r.passed for r in results),
        "groups": [{"group": r.group, "passed": r.passed,
                    "checks": r.checks, "failures": r.failures}
                   for r in results],
    }
    return results, payload


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("circ", nargs="?", default="armv4t_2.circ")
    ap.add_argument("--through", choices=list(GROUPS), default="C",
                    help="verify every group through this one (default: C)")
    ap.add_argument("--json", action="store_true", help="machine-readable output")
    args = ap.parse_args()
    results, payload = run(args.circ, args.through)
    if args.json:
        print(json.dumps(payload, indent=2, sort_keys=True))
    else:
        print("== %s :: stage_ID through Group %s ==" %
              (os.path.basename(args.circ), args.through))
        for r in results:
            if r.passed:
                print("PASS  Group %s  (%d deterministic checks)" %
                      (r.group, r.checks))
            else:
                print("FAIL  Group %s  (%d problem%s)" %
                      (r.group, len(r.failures), "" if len(r.failures) == 1 else "s"))
                for failure in r.failures:
                    print("      - " + failure)
        print("\nRESULT: " + ("PASS" if payload["passed"] else "FAIL"))
    return 0 if payload["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
