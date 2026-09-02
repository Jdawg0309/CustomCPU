#!/usr/bin/env python3
"""Semantic, read-only checker for the hand-wired ``stage_IF`` circuit.

The companion to tools/check_stage_id.py, and built the same way: roles are
derived from what a part is *connected to*, never from where it sits. "The
1-bit register whose output feeds the apply gate" survives being dragged across
the canvas; "Register@1540,800" does not.

    python3 tools/check_stage_if.py armv4t_2.circ
    python3 tools/check_stage_if.py armv4t_2.circ --through B
    python3 tools/check_stage_if.py armv4t_2.circ --json

Groups:
  A  ports, the instruction ROM, and the pc_fetch interface
  B  redirect-request logic -- what makes the PC jump at all
  C  the deferred PC write -- a PC write that arrives while the fetch is held

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

GROUPS = "ABC"

PORTS = {
    "clk":          ("in", 1),
    "rst":          ("in", 1),
    "hold_pc":      ("in", 1),
    "branch_taken": ("in", 1),
    "bx_taken":     ("in", 1),
    "bt_done":      ("in", 1),
    "wb_writes_pc": ("in", 1),
    "bx_target":    ("in", 32),
    "wb_data":      ("in", 32),
    "branch_offset": ("in", 32),
    "instruction":  ("out", 32),
    "pc_word_addr": ("out", 10),
    "pc_plus4":     ("out", 32),
}


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


class StageIF:
    def __init__(self, path: str):
        self.g = G.build(path, "stage_IF")
        self.c = self.g.circ

    # -- primitives ------------------------------------------------------

    def pins(self) -> Dict[str, object]:
        return {c.attrs.get("label", ""): c
                for c in self.c.components if c.name == "Pin"}

    def net_index(self, comp, port=None) -> Optional[int]:
        """Net index at a component's port (or its only port)."""
        cid = G.comp_id(comp) if not isinstance(comp, str) else comp
        for nid, n in self.g.nodes.items():
            if n.comp == cid and (port is None or n.port == port):
                net = self.g.net_of(nid)
                return None if net is None else net.index
        return None

    def pin_net(self, label) -> Optional[int]:
        p = self.pins().get(label)
        return None if p is None else self.net_index(p)

    def port_net(self, kind, port, width=None) -> Optional[int]:
        for c in self.c.components:
            if c.name != kind:
                continue
            if width is not None and int(c.attrs.get("width", 1)) != width:
                continue
            return self.net_index(c, port)
        return None

    def of_kind(self, kind, width=None):
        out = []
        for c in self.c.components:
            if c.name != kind:
                continue
            if width is not None and int(c.attrs.get("width", 1)) != width:
                continue
            out.append(c)
        return out

    def gate_inputs(self, comp) -> List[Optional[int]]:
        cid = G.comp_id(comp)
        vals = []
        for nid, n in sorted(self.g.nodes.items()):
            if n.comp == cid and n.direction == "in":
                net = self.g.net_of(nid)
                vals.append(None if net is None else net.index)
        return vals

    def gate_output(self, comp) -> Optional[int]:
        cid = G.comp_id(comp)
        for nid, n in self.g.nodes.items():
            if n.comp == cid and n.direction == "out":
                net = self.g.net_of(nid)
                return None if net is None else net.index
        return None

    def find_gate(self, kind, drives=None, fed_by=None):
        """A gate identified by what it connects to, not where it is."""
        for c in self.of_kind(kind):
            if drives is not None and self.gate_output(c) != drives:
                continue
            if fed_by is not None and fed_by not in self.gate_inputs(c):
                continue
            return c
        return None

    # -- groups ----------------------------------------------------------

    def group_a(self) -> Result:
        r = Result("A")
        pins = self.pins()

        for name, (want_dir, want_w) in PORTS.items():
            c = pins.get(name)
            if not r.check(c is not None, "port %s is missing" % name):
                continue
            got_dir = "out" if c.attrs.get("output") == "true" else "in"
            got_w = int(c.attrs.get("width", 1))
            r.check((got_dir, got_w) == (want_dir, want_w),
                    "port %s is %s/%d, expected %s/%d"
                    % (name, got_dir, got_w, want_dir, want_w))

        extra = set(pins) - set(PORTS)
        r.check(not extra, "unexpected ports: %s" % ", ".join(sorted(extra)))

        roms = self.of_kind("ROM")
        if r.check(len(roms) == 1, "expected exactly one ROM, found %d" % len(roms)):
            rom = roms[0]
            r.check(rom.attrs.get("addrWidth") == "10",
                    "ROM addrWidth is %s, expected 10 (1024 words)"
                    % rom.attrs.get("addrWidth"))
            r.check(rom.attrs.get("dataWidth") == "32",
                    "ROM dataWidth is %s, expected 32"
                    % rom.attrs.get("dataWidth"))
            addr = self.net_index(rom, "addr")
            data = self.net_index(rom, "data_out")
            r.check(addr is not None and addr == self.pin_net("pc_word_addr"),
                    "ROM.addr is not on the pc_word_addr net")
            r.check(addr is not None and addr == self.port_net("pc_fetch", "pc_out"),
                    "ROM.addr is not driven by pc_fetch.pc_out")
            r.check(data is not None and data == self.pin_net("instruction"),
                    "ROM.data_out does not reach the instruction pin")

        fetch = self.of_kind("pc_fetch")
        if r.check(len(fetch) == 1, "expected one pc_fetch instance, found %d" % len(fetch)):
            for port, pin in (("CLK", "clk"), ("RST", "rst"),
                              ("hold", "hold_pc"), ("IMM", "branch_offset")):
                r.check(self.port_net("pc_fetch", port) == self.pin_net(pin),
                        "pc_fetch.%s is not on the %s net" % (port, pin))
            r.check(self.port_net("pc_fetch", "pc_plus4") == self.pin_net("pc_plus4"),
                    "pc_fetch.pc_plus4 does not reach the pc_plus4 pin")
        return r

    def group_b(self) -> Result:
        r = Result("B")
        branch_taken = self.pin_net("branch_taken")
        bx_taken = self.pin_net("bx_taken")
        wb_writes_pc = self.pin_net("wb_writes_pc")

        redirect = self.find_gate("OR Gate", fed_by=branch_taken)
        if r.check(redirect is not None, "no OR gate takes branch_taken"):
            ins = self.gate_inputs(redirect)
            r.check(bx_taken in ins,
                    "the branch_taken OR gate does not also take bx_taken")
            redirect_out = self.gate_output(redirect)
        else:
            redirect_out = None

        branch = self.port_net("pc_fetch", "BRANCH")
        or_branch = self.find_gate("OR Gate", drives=branch)
        if r.check(or_branch is not None, "pc_fetch.BRANCH is not driven by an OR gate"):
            ins = self.gate_inputs(or_branch)
            r.check(len(ins) == 3,
                    "the BRANCH OR gate has %d inputs, expected 3" % len(ins))
            r.check(redirect_out in ins,
                    "the BRANCH OR gate does not take the branch/bx redirect")
            r.check(wb_writes_pc in ins,
                    "the BRANCH OR gate does not take wb_writes_pc")

        absel = self.port_net("pc_fetch", "abs_select")
        or_abs = self.find_gate("OR Gate", drives=absel)
        if r.check(or_abs is not None, "pc_fetch.abs_select is not driven by an OR gate"):
            ins = self.gate_inputs(or_abs)
            r.check(len(ins) == 3,
                    "the abs_select OR gate has %d inputs, expected 3" % len(ins))
            r.check(bx_taken in ins,
                    "the abs_select OR gate does not take bx_taken")
            r.check(wb_writes_pc in ins,
                    "the abs_select OR gate does not take wb_writes_pc")
            r.check(branch != absel,
                    "BRANCH and abs_select share a net; a plain B would be "
                    "treated as an absolute jump")
        return r

    def group_c(self) -> Result:
        r = Result("C")
        wb_writes_pc = self.pin_net("wb_writes_pc")
        bt_done = self.pin_net("bt_done")

        pending = self.of_kind("Register", width=1)
        target = self.of_kind("Register", width=32)
        r.check(len(pending) == 1,
                "expected one 1-bit register (pc_pending), found %d" % len(pending))
        r.check(len(target) == 1,
                "expected one 32-bit register (pc_target), found %d" % len(target))
        if not pending or not target:
            return r
        pending, target = pending[0], target[0]

        rst = self.pin_net("rst")
        clk = self.pin_net("clk")
        for reg, name in ((pending, "pc_pending"), (target, "pc_target")):
            r.check(self.net_index(reg, "clk") == clk,
                    "%s.clk is not on the clk net" % name)
            r.check(self.net_index(reg, "clr") == rst,
                    "%s.clr is not on the rst net" % name)

        # The set-only latch: pc_pending captures whenever the value arriving
        # is 1, so its enable and its data input are the SAME net. A floating
        # enable here makes a deferred PC write land intermittently.
        d = self.net_index(pending, "D")
        en = self.net_index(pending, "en")
        r.check(en is not None, "pc_pending.en is floating -- a deferred PC "
                                "write may or may not latch")
        r.check(d is not None and d == en,
                "pc_pending.en is not on the same net as pc_pending.D "
                "(set-only latch: enable must follow the data)")

        pending_q = self.net_index(pending, "Q")
        apply_gate = self.find_gate("AND Gate", fed_by=pending_q)
        if r.check(apply_gate is not None,
                   "nothing gates pc_pending.Q -- the pending write never applies"):
            r.check(bt_done in self.gate_inputs(apply_gate),
                    "the apply gate does not wait on bt_done, so a pending PC "
                    "write could fire mid block-transfer")

        defer = self.find_gate("AND Gate", fed_by=self.pin_net("hold_pc"))
        if r.check(defer is not None, "no AND gate takes hold_pc"):
            r.check(wb_writes_pc in self.gate_inputs(defer),
                    "the defer gate does not take wb_writes_pc")

        tsel = self.find_gate("Multiplexer", drives=self.net_index(target, "D"))
        if r.check(tsel is not None, "pc_target.D is not driven by a multiplexer"):
            ins = self.gate_inputs(tsel)
            r.check(self.pin_net("bx_target") in ins,
                    "the target mux does not take bx_target")
            r.check(self.pin_net("wb_data") in ins,
                    "the target mux does not take wb_data")

        absel = self.find_gate("Multiplexer",
                               drives=self.port_net("pc_fetch", "abs_target"))
        if r.check(absel is not None,
                   "pc_fetch.abs_target is not driven by a multiplexer"):
            ins = self.gate_inputs(absel)
            r.check(self.net_index(target, "Q") in ins,
                    "the abs_target mux does not offer the held pc_target")
            r.check(self.net_index(target, "D") in ins,
                    "the abs_target mux does not offer the live target")
        return r


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("circ")
    ap.add_argument("--through", default="C", choices=list(GROUPS))
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()

    s = StageIF(a.circ)
    want = GROUPS[:GROUPS.index(a.through) + 1]
    results = [getattr(s, "group_%s" % gl.lower())() for gl in want]

    if a.json:
        print(json.dumps({r.group: {"checks": r.checks, "failures": r.failures}
                          for r in results}, indent=2))
    else:
        print("== %s :: stage_IF through Group %s ==" %
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
