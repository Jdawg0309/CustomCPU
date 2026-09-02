#!/usr/bin/env python3
"""Semantic, read-only checker for the hand-wired ``stage_EX`` circuit.

Third of the set, same design as check_stage_id.py and check_stage_if.py: every
role is derived from what a part is connected to, never from where it sits.
"the 32-bit AND gate whose output reaches bx_target" survives being dragged
across the canvas; "AND Gate@1110,2180" does not.

    python3 tools/check_stage_ex.py armv4t_2.circ
    python3 tools/check_stage_ex.py armv4t_2.circ --through B
    python3 tools/check_stage_ex.py armv4t_2.circ --json

Groups:
  A  operand B -- immediate vs shifted register, sharing one barrel shifter
  B  the ALU and the ten-bit control word
  C  flags, the CPSR, and the condition checker
  D  class decode, B/BL, the branch target, and BX

Opens the file read-only. Contains no editing code and never writes a .circ.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from dataclasses import dataclass, field
from typing import Dict, List, Optional

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)

from logisim import graph as G

GROUPS = "ABCD"

PORTS = {
    "clk": ("in", 1), "rst": ("in", 1),
    "rd_a": ("in", 32), "rd_b": ("in", 32),
    "alu_ctrl": ("in", 10), "cond": ("in", 4),
    "class_bits": ("in", 3), "opcode": ("in", 4),
    "imm_bit": ("in", 1), "imm8": ("in", 8), "rot": ("in", 4),
    "shift_type": ("in", 2), "shift_amount": ("in", 5),
    "s_bit": ("in", 1), "instr_27_4": ("in", 24), "branch_imm24": ("in", 24),
    "alu_result": ("out", 32), "alu_we": ("out", 1), "cond_pass": ("out", 1),
    "branch_taken": ("out", 1), "bl_taken": ("out", 1), "bx_taken": ("out", 1),
    "bx_target": ("out", 32), "branch_offset": ("out", 32), "cpsr": ("out", 4),
}

# alu_ctrl bit -> (field, width). Read off the working circuit's splitter.
CTRL_FIELDS = {0: ("write_enable", 1), 1: ("logic_sel", 3), 4: ("cin_sel", 2),
               6: ("b_inv", 1), 7: ("a_inv", 1), 8: ("engine_sel", 2)}


@dataclass
class Result:
    group: str
    checks: int = 0
    failures: List[str] = field(default_factory=list)

    def check(self, ok: bool, msg: str) -> bool:
        self.checks += 1
        if not ok:
            self.failures.append(msg)
        return ok

    @property
    def passed(self) -> bool:
        return not self.failures


class StageEX:
    def __init__(self, path: str):
        self.g = G.build(path, "stage_EX")
        self.c = self.g.circ
        self.byid = {G.comp_id(c): c for c in self.c.components}

    # -- primitives ------------------------------------------------------

    def pins(self):
        return {c.attrs.get("label", ""): c
                for c in self.c.components if c.name == "Pin"}

    def net_at(self, comp, port=None) -> Optional[int]:
        cid = G.comp_id(comp)
        for nid, n in self.g.nodes.items():
            if n.comp == cid and (port is None or n.port == port):
                net = self.g.net_of(nid)
                return None if net is None else net.index
        return None

    def pin_net(self, label) -> Optional[int]:
        p = self.pins().get(label)
        return None if p is None else self.net_at(p)

    def kind(self, name, **attrs):
        out = []
        for c in self.c.components:
            if c.name != name:
                continue
            if all(c.attrs.get(k) == v for k, v in attrs.items()):
                out.append(c)
        return out

    def sub_net(self, sub, port) -> Optional[int]:
        for c in self.c.components:
            if c.name == sub:
                return self.net_at(c, port)
        return None

    def inputs_of(self, comp) -> List[Optional[int]]:
        cid = G.comp_id(comp)
        vals = []
        for nid, n in sorted(self.g.nodes.items()):
            if n.comp == cid and n.direction == "in":
                net = self.g.net_of(nid)
                vals.append(None if net is None else net.index)
        return vals

    def output_of(self, comp) -> Optional[int]:
        cid = G.comp_id(comp)
        for nid, n in self.g.nodes.items():
            if n.comp == cid and n.direction == "out":
                net = self.g.net_of(nid)
                return None if net is None else net.index
        return None

    def find(self, name, drives=None, fed_by=None, **attrs):
        for c in self.kind(name, **attrs):
            if drives is not None and self.output_of(c) != drives:
                continue
            if fed_by is not None and fed_by not in self.inputs_of(c):
                continue
            return c
        return None

    def const_feeding(self, net) -> Optional[object]:
        """The Constant driving a net, if any -- with its EFFECTIVE value.

        Logisim omits default attributes, and a Constant's default value is 1,
        not 0. A constant written as `{}` is therefore a one, which is how a
        branch adder quietly gained a carry-in of 1.
        """
        if net is None:
            return None
        for nid, n in self.g.nodes.items():
            nn = self.g.net_of(nid)
            if nn is not None and nn.index == net and n.kind == "Constant":
                return self.byid[n.comp]
        return None

    @staticmethod
    def const_value(c) -> int:
        return int(c.attrs.get("value", "0x1"), 0)

    def fan_carrying(self, splitter, bits) -> Optional[int]:
        """The net on the fan that carries exactly this set of bus bits."""
        want = tuple(sorted(bits))
        for nid, n in self.g.nodes.items():
            if n.comp == G.comp_id(splitter) and n.port != "combined":
                if tuple(sorted(n.bus_bits)) == want:
                    net = self.g.net_of(nid)
                    return None if net is None else net.index
        return None

    def splitter_on(self, net, incoming=None):
        for c in self.kind("Splitter"):
            if incoming is not None and c.attrs.get("incoming") != incoming:
                continue
            if self.net_at(c, "combined") == net:
                return c
        return None

    # -- groups ----------------------------------------------------------

    def group_a(self) -> Result:
        r = Result("A")
        for name, (wd, ww) in PORTS.items():
            c = self.pins().get(name)
            if not r.check(c is not None, "port %s is missing" % name):
                continue
            gd = "out" if c.attrs.get("output") == "true" else "in"
            gw = int(c.attrs.get("width", 1))
            r.check((gd, gw) == (wd, ww), "port %s is %s/%d, expected %s/%d"
                    % (name, gd, gw, wd, ww))
        extra = set(self.pins()) - set(PORTS)
        r.check(not extra, "unexpected ports: %s" % ", ".join(sorted(extra)))

        imm_bit = self.pin_net("imm_bit")

        # the three muxes on the shifter's three inputs, found by what they drive
        shin = self.sub_net("barrel_32b", "input_32b")
        shamt = self.sub_net("barrel_32b", "amnt")
        shtyp = self.sub_net("barrel_32b", "typ")
        m_in = self.find("Multiplexer", drives=shin)
        m_amt = self.find("Multiplexer", drives=shamt)
        m_typ = self.find("Multiplexer", drives=shtyp)
        for m, nm in ((m_in, "input_32b"), (m_amt, "amnt"), (m_typ, "typ")):
            if r.check(m is not None, "barrel_32b.%s is not driven by a multiplexer" % nm):
                r.check(self.net_at(m, "sel") == imm_bit,
                        "the %s mux is not selected by imm_bit" % nm)

        if m_in is not None:
            ins = self.inputs_of(m_in)
            r.check(self.pin_net("rd_b") in ins,
                    "the shifter-input mux does not offer rd_b")
            ext = self.find("Bit Extender", drives=self.net_at(m_in, "in1"))
            if r.check(ext is not None,
                       "the immediate side of the shifter-input mux is not a Bit Extender"):
                r.check(self.net_at(ext, "in") == self.pin_net("imm8"),
                        "the immediate extender does not take imm8")
                r.check(ext.attrs.get("out_width") == "32",
                        "the immediate extender outputs %s bits, expected 32"
                        % ext.attrs.get("out_width"))
                # Logisim's default extension type is SIGN. An 8-bit ARM
                # immediate is unsigned, so this MUST be stated as zero --
                # otherwise every immediate >= 0x80 comes out negative.
                r.check(ext.attrs.get("type") == "zero",
                        "the immediate extender is not zero-extending "
                        "(no explicit type means SIGN, so #0xFF becomes "
                        "0xFFFFFFFF)")

        if m_amt is not None:
            ins = self.inputs_of(m_amt)
            r.check(self.pin_net("shift_amount") in ins,
                    "the shift-amount mux does not offer shift_amount")
            rot5 = self.net_at(m_amt, "in1")
            sp = self.splitter_on(rot5, incoming="5")
            if r.check(sp is not None,
                       "the immediate rotate is not built from a 5-bit splitter"):
                # rot x 2: bit 0 tied low, bits 4:1 carry rot
                low = self.fan_carrying(sp, [0])
                high = self.fan_carrying(sp, [1, 2, 3, 4])
                r.check(high == self.pin_net("rot"),
                        "the rotate splitter's bits 4:1 do not carry rot "
                        "(this is the x2; reversed, every immediate rotates "
                        "by half)")
                k = self.const_feeding(low)
                if r.check(k is not None,
                           "the rotate splitter's bit 0 is not tied to a constant"):
                    r.check(self.const_value(k) == 0,
                            "the rotate splitter's bit 0 is %d, expected 0"
                            % self.const_value(k))

        if m_typ is not None:
            ins = self.inputs_of(m_typ)
            r.check(self.pin_net("shift_type") in ins,
                    "the shift-type mux does not offer shift_type")
            k = self.const_feeding(self.net_at(m_typ, "in1"))
            if r.check(k is not None,
                       "the immediate shift type is not a constant"):
                r.check(self.const_value(k) == 3,
                        "the immediate shift type is %d, expected 3 (ROR)"
                        % self.const_value(k))
                r.check(k.attrs.get("width") == "2",
                        "the immediate shift-type constant is %s bits, expected 2"
                        % k.attrs.get("width", "1"))
        return r

    def group_b(self) -> Result:
        r = Result("B")
        alu = self.kind("ALU")
        if not r.check(len(alu) == 1, "expected one ALU instance, found %d" % len(alu)):
            return r
        alu = alu[0]

        r.check(self.net_at(alu, "A") == self.pin_net("rd_a"),
                "ALU.A is not on the rd_a net")
        r.check(self.net_at(alu, "B") == self.sub_net("barrel_32b", "outp"),
                "ALU.B is not driven by the barrel shifter")
        r.check(self.net_at(alu, "result") == self.pin_net("alu_result"),
                "ALU.result does not reach the alu_result pin")
        r.check(self.net_at(alu, "write_enable_out") == self.pin_net("alu_we"),
                "ALU.write_enable_out does not reach the alu_we pin")

        k = self.const_feeding(self.net_at(alu, "unused"))
        if r.check(k is not None, "ALU.unused is not tied to a constant"):
            r.check(self.const_value(k) == 0,
                    "ALU.unused is tied to %d, expected 0" % self.const_value(k))

        ctrl = self.splitter_on(self.pin_net("alu_ctrl"), incoming="10")
        if not r.check(ctrl is not None,
                       "alu_ctrl is not split by a 10-bit splitter"):
            return r
        for lsb, (fieldname, width) in sorted(CTRL_FIELDS.items()):
            bits = list(range(lsb, lsb + width))
            fan = self.fan_carrying(ctrl, [lsb])
            if width == 1:
                r.check(fan is not None and fan == self.net_at(alu, fieldname),
                        "alu_ctrl bit %d does not reach ALU.%s" % (lsb, fieldname))
            else:
                # the field is regrouped by a small combiner splitter
                target = self.net_at(alu, fieldname)
                comb = self.splitter_on(target)
                if r.check(comb is not None,
                           "ALU.%s is not fed by a combining splitter" % fieldname):
                    got = [self.fan_carrying(comb, [i]) for i in range(width)]
                    want = [self.fan_carrying(ctrl, [b]) for b in bits]
                    r.check(got == want,
                            "ALU.%s is assembled from alu_ctrl bits %s, expected %s"
                            % (fieldname, got, want))
        return r

    def group_c(self) -> Result:
        r = Result("C")
        alu = self.kind("ALU")
        regs = self.kind("Register")
        cc = self.kind("condition_checker")
        if not (r.check(len(regs) == 1, "expected one Register (CPSR), found %d" % len(regs))
                and r.check(len(cc) == 1, "expected one condition_checker, found %d" % len(cc))
                and alu):
            return r
        alu, reg, cc = alu[0], regs[0], cc[0]

        r.check(reg.attrs.get("width") == "4",
                "the CPSR register is %s bits, expected 4 (NZCV)"
                % reg.attrs.get("width", "1"))
        r.check(self.net_at(reg, "clk") == self.pin_net("clk"),
                "CPSR.clk is not on the clk net")
        r.check(self.net_at(reg, "clr") == self.pin_net("rst"),
                "CPSR.clr is not on the rst net")

        # pack: bit3=N bit2=Z bit1=C bit0=V
        w = self.splitter_on(self.net_at(reg, "D"), incoming="4")
        if r.check(w is not None, "CPSR.D is not fed by a 4-bit splitter"):
            for bit, flag in ((3, "N"), (2, "Z"), (1, "C"), (0, "V")):
                r.check(self.fan_carrying(w, [bit]) == self.net_at(alu, flag),
                        "CPSR bit %d is not ALU.%s on the write side" % (bit, flag))

        # unpack: the same layout, read back
        rd = self.splitter_on(self.net_at(reg, "Q"), incoming="4")
        if r.check(rd is not None, "CPSR.Q is not read by a 4-bit splitter"):
            for bit, flag in ((3, "N"), (2, "Z"), (1, "C"), (0, "V")):
                r.check(self.fan_carrying(rd, [bit]) == self.net_at(cc, flag),
                        "CPSR bit %d is not condition_checker.%s on the read side"
                        % (bit, flag))
            # the ADC/SBC/RSC wire: C reaches the ALU as well as the checker
            r.check(self.fan_carrying(rd, [1]) == self.net_at(alu, "Cflag"),
                    "the CPSR C bit does not reach ALU.Cflag -- ADC, SBC and "
                    "RSC will all drop their carry-in")

        r.check(self.net_at(reg, "Q") == self.pin_net("cpsr"),
                "CPSR.Q does not reach the cpsr pin")
        r.check(self.net_at(cc, "cond") == self.pin_net("cond"),
                "condition_checker.cond is not on the cond net")
        cond_pass = self.net_at(cc, "chk_out")
        r.check(cond_pass == self.pin_net("cond_pass"),
                "condition_checker's output does not reach the cond_pass pin")

        # the write gate
        en = self.find("AND Gate", drives=self.net_at(reg, "en"))
        if r.check(en is not None, "CPSR.en is not driven by an AND gate"):
            ins = self.inputs_of(en)
            r.check(len(ins) == 3, "the CPSR write gate has %d inputs, expected 3" % len(ins))
            r.check(cond_pass in ins, "the CPSR write gate does not take cond_pass")
            r.check(self.pin_net("s_bit") in ins,
                    "the CPSR write gate does not take s_bit -- flags would "
                    "update on instructions without S")
            inv = None
            for i in ins:
                g = self.find("NOT Gate", drives=i)
                if g is not None:
                    inv = g
            r.check(inv is not None,
                    "the CPSR write gate has no inverted term -- branches and "
                    "loads would clobber the flags")
        return r

    def group_d(self) -> Result:
        r = Result("D")
        cls = self.splitter_on(self.pin_net("class_bits"), incoming="3")
        if not r.check(cls is not None, "class_bits is not split by a 3-bit splitter"):
            return r
        i25 = self.fan_carrying(cls, [0])
        i26 = self.fan_carrying(cls, [1])
        i27 = self.fan_carrying(cls, [2])

        brc = self.find("AND Gate", fed_by=i25)
        if r.check(brc is not None, "no AND gate takes instr[25]"):
            ins = self.inputs_of(brc)
            r.check(len(ins) == 3, "branch_class has %d inputs, expected 3" % len(ins))
            r.check(i27 in ins, "branch_class does not take instr[27]")
            n26 = self.find("NOT Gate", fed_by=i26)
            r.check(n26 is not None and self.output_of(n26) in ins,
                    "branch_class does not take NOT instr[26] (needs 0b101)")
        branch_class = self.output_of(brc) if brc else None

        memc = self.find("AND Gate", fed_by=i26)
        if r.check(memc is not None, "no AND gate takes instr[26] for mem_class"):
            n27 = self.find("NOT Gate", fed_by=i27)
            r.check(n27 is not None and self.output_of(n27) in self.inputs_of(memc),
                    "mem_class does not take NOT instr[27]")

        # B / BL
        opc = self.splitter_on(self.pin_net("opcode"), incoming="4")
        if r.check(opc is not None, "opcode is not split by a 4-bit splitter"):
            lbit = self.fan_carrying(opc, [3])
            isbl = self.find("AND Gate", fed_by=lbit)
            if r.check(isbl is not None,
                       "no AND gate takes opcode[3] (the L bit of B/BL)"):
                r.check(branch_class in self.inputs_of(isbl),
                        "is_BL does not take branch_class")
                # Two accepted shapes, because BL's PC redirect is a live
                # design decision (see specs/stage_IF.md section 6):
                #
                #   (a) branch_taken = cond_pass AND branch_class AND NOT is_BL
                #       -- the master's shape.  BL cannot redirect the PC.
                #   (b) branch_taken = cond_pass AND branch_class
                #       -- BL redirects too; NOT_L and is_B are then dead and
                #          should be deleted.
                #
                # Accepting both means this checker stays green across the
                # change instead of failing halfway through it.
                notl = self.find("NOT Gate", fed_by=self.output_of(isbl))
                bt_gate = self.find("AND Gate", drives=self.pin_net("branch_taken"))
                folded = (bt_gate is not None and branch_class is not None
                          and branch_class in self.inputs_of(bt_gate))
                r.check(notl is not None or folded,
                        "branch_taken is neither gated by branch_class (BL folded in) "
                        "nor built from NOT is_BL (the master's shape)")
                r.check(True, "branch decode shape: %s"
                        % ("BL folded into branch_taken" if folded
                           else "master shape (BL cannot redirect)"))

        cond_pass = self.pin_net("cond_pass")
        for pin in ("branch_taken", "bl_taken", "bx_taken"):
            gate = self.find("AND Gate", drives=self.pin_net(pin))
            if r.check(gate is not None, "%s is not driven by an AND gate" % pin):
                r.check(cond_pass in self.inputs_of(gate),
                        "%s is not gated by cond_pass" % pin)

        # branch target: (sign_extend(imm24) << 2) + 8
        add = self.find("Adder", drives=self.pin_net("branch_offset"))
        if r.check(add is not None, "branch_offset is not driven by an Adder"):
            k8 = self.const_feeding(self.net_at(add, "b"))
            if r.check(k8 is not None, "the branch adder's b input is not a constant"):
                r.check(self.const_value(k8) == 8,
                        "the branch adder adds %d, expected 8 (the pipeline offset)"
                        % self.const_value(k8))
            kc = self.const_feeding(self.net_at(add, "cin"))
            if r.check(kc is not None,
                       "the branch adder's carry-in is not tied to a constant "
                       "(it floats in debug_armv4t.circ -- do not reproduce that)"):
                r.check(self.const_value(kc) == 0,
                        "the branch adder's carry-in is %d, expected 0 -- every "
                        "branch target would be one byte high"
                        % self.const_value(kc))
            sh = self.find("Shifter", drives=self.net_at(add, "a"))
            if r.check(sh is not None, "the branch adder's a input is not a Shifter"):
                r.check(sh.attrs.get("shift") in (None, "ll"),
                        "the branch shifter is %s, expected logical left"
                        % sh.attrs.get("shift"))
                kd = self.const_feeding(self.net_at(sh, "dist"))
                if r.check(kd is not None, "the branch shifter's distance is not constant"):
                    r.check(self.const_value(kd) == 2,
                            "the branch shifter shifts by %d, expected 2"
                            % self.const_value(kd))
                ex = self.find("Bit Extender", drives=self.net_at(sh, "in"))
                if r.check(ex is not None, "the branch shifter is not fed by a Bit Extender"):
                    r.check(self.net_at(ex, "in") == self.pin_net("branch_imm24"),
                            "the branch extender does not take branch_imm24")
                    # SIGN is Logisim's default, so absent is acceptable here --
                    # but zero would turn every backward branch into a forward one.
                    r.check(ex.attrs.get("type") in (None, "sign"),
                            "the branch extender is %s-extending, expected sign "
                            "-- a backward branch is a negative offset"
                            % ex.attrs.get("type"))

        # BX
        cmp_bx = self.kind("Comparator")
        if r.check(len(cmp_bx) == 1, "expected one Comparator (BX), found %d" % len(cmp_bx)):
            cb = cmp_bx[0]
            r.check(self.net_at(cb, "a") == self.pin_net("instr_27_4"),
                    "the BX comparator does not take instr_27_4")
            kp = self.const_feeding(self.net_at(cb, "b"))
            if r.check(kp is not None, "the BX comparator has no pattern constant"):
                r.check(self.const_value(kp) == 0x12FFF1,
                        "the BX pattern is 0x%x, expected 0x12fff1"
                        % self.const_value(kp))
                r.check(kp.attrs.get("width") == "24",
                        "the BX pattern constant is %s bits, expected 24"
                        % kp.attrs.get("width", "1"))

        align = self.find("AND Gate", drives=self.pin_net("bx_target"))
        if r.check(align is not None, "bx_target is not driven by an AND gate"):
            r.check(align.attrs.get("width") == "32",
                    "the BX alignment gate is %s bits, expected 32 -- at the "
                    "default it collapses the target to one bit"
                    % align.attrs.get("width", "1"))
            r.check(self.pin_net("rd_b") in self.inputs_of(align),
                    "the BX alignment gate does not take rd_b")
            km = self.const_feeding([i for i in self.inputs_of(align)
                                     if i != self.pin_net("rd_b")][0]
                                    if len(self.inputs_of(align)) > 1 else None)
            if r.check(km is not None, "the BX alignment mask is not a constant"):
                r.check(self.const_value(km) == 0xFFFFFFFC,
                        "the BX alignment mask is 0x%x, expected 0xfffffffc"
                        % self.const_value(km))
        return r


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("circ")
    ap.add_argument("--through", default="D", choices=list(GROUPS))
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()

    s = StageEX(a.circ)
    want = GROUPS[:GROUPS.index(a.through) + 1]
    results = [getattr(s, "group_%s" % g.lower())() for g in want]

    if a.json:
        print(json.dumps({r.group: {"checks": r.checks, "failures": r.failures}
                          for r in results}, indent=2))
    else:
        print("== %s :: stage_EX through Group %s ==" %
              (os.path.basename(a.circ), a.through))
        for r in results:
            print("%s  Group %s  (%d deterministic checks)"
                  % ("PASS" if r.passed else "FAIL", r.group, r.checks))
            for f in r.failures:
                print("        %s" % f)
        print()
        print("RESULT: %s" % ("PASS" if all(r.passed for r in results) else "FAIL"))
    return 0 if all(r.passed for r in results) else 1


if __name__ == "__main__":
    sys.exit(main())
