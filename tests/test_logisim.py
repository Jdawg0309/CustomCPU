#!/usr/bin/env python3
"""Tests for the logisim package.

These are discriminators, not smoke tests: each one fails for a specific,
named reason.  The connectivity test in particular encodes the rule that is
easiest to get wrong -- crossing wires are not connected -- because getting it
wrong does not crash, it silently merges the whole design into one net.
"""
import os
import sys
import unittest
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, ROOT)

from logisim import geometry as geo, lint, netlist as nl, render, route  # noqa: E402
from logisim.model import Circuit, Component, Design, Wire, load  # noqa: E402

CIRC = os.path.join(ROOT, "armv4t.circ")


def _design():
    return load(CIRC)


class TestModel(unittest.TestCase):
    def test_loads_every_circuit(self):
        d = _design()
        self.assertEqual(d.main, "main")
        self.assertIn("block_transfer_control", d.circuits)
        self.assertGreater(len(d["main"].components), 100)

    def test_port_order_is_y_then_x(self):
        """Instance port order follows the subcircuit's pins sorted by (y,x).
        Get this wrong and every subcircuit connection is off by a pin."""
        d = _design()
        self.assertEqual([p.label for p in d["pc_fetch"].inputs()],
                         ["CLK", "BRANCH", "hold", "IMM", "abs_target", "abs_select", "RST"])


class TestGeometry(unittest.TestCase):
    def test_pc_fetch_instance_pins(self):
        """Relative to the instance, not absolute: the design gets rearranged,
        and a test pinned to old coordinates only ever reports that fact."""
        d = _design()
        inst = [c for c in d["main"].components if c.name == "pc_fetch"][0]
        got = {p.name: p.at(inst) for p in geo.ports(d, inst)}
        x, y = inst.loc
        self.assertEqual(got["pc_plus4"], (x, y))            # outputs on the anchor
        self.assertEqual(got["pc_out"], (x, y + 20))
        self.assertEqual(got["abs_target"][1] - got["IMM"][1], 20)
        self.assertEqual(got["abs_select"][1] - got["abs_target"][1], 20)
        self.assertEqual(got["CLK"][0], got["RST"][0])       # inputs share a column
        self.assertLess(got["CLK"][0], x)                    # ...west of the anchor

    def test_rotation_is_clockwise(self):
        self.assertEqual(geo.rotate(0, 20, "south"), (-20, 0))
        self.assertEqual(geo.rotate(-30, 10, "west"), (30, -10))
        self.assertEqual(geo.rotate(1, 2, "east"), (1, 2))

    def test_default_gate_size_is_50(self):
        """An AND gate with no size attribute has inputs at (-50, +-20).
        Assuming Logisim's documented 30 puts them 20 units off."""
        c = Component(name="AND Gate", lib="1", loc=(100, 100), attrs={})
        pts = {p.name: p.at(c) for p in geo.ports(None, c)}
        self.assertEqual(pts["in0"], (50, 80))
        self.assertEqual(pts["in1"], (50, 120))
        self.assertEqual(pts["out"], (100, 100))

    def test_wide_gate_grows_instead_of_squeezing(self):
        c = Component(name="OR Gate", lib="1", loc=(0, 0), attrs={"inputs": "32"})
        ys = sorted(p.at(c)[1] for p in geo.ports(None, c) if p.name.startswith("in"))
        self.assertEqual(ys[0], -160)
        self.assertEqual(ys[-1], 160)
        self.assertNotIn(0, ys)          # even count skips the axis

    def test_geometry_explains_almost_every_endpoint(self):
        d = _design()
        m = t = 0
        for c in d:
            cov = nl.coverage(d, c)
            m += cov["matched"]; t += cov["endpoints"]
        self.assertGreater(m / t, 0.98, "port geometry regressed: %d/%d" % (m, t))

    def test_evolution_memory_ports_match_live_circuit(self):
        """RAM/ROM far-edge outputs are essential drivers, not model gaps."""
        d = _design()
        ram = next(c for c in d["main"].components if c.name == "RAM")
        rports = {p.name: p.at(ram) for p in geo.ports(d, ram)}
        x, y = ram.loc
        self.assertEqual(rports["addr"], (x, y + 10))
        self.assertEqual(rports["we"], (x, y + 50))
        self.assertEqual(rports["oe"], (x, y + 60))
        self.assertEqual(rports["clk"], (x, y + 70))
        self.assertEqual(rports["data_in"], (x, y + 90))
        self.assertEqual(rports["data_out"], (x + 240, y + 90))

        rom = next(c for c in d["main"].components if c.name == "ROM")
        oports = {p.name: p.at(rom) for p in geo.ports(d, rom)}
        x, y = rom.loc
        self.assertEqual(oports["addr"], (x, y + 10))
        self.assertEqual(oports["data_out"], (x + 240, y + 60))


class TestNetlist(unittest.TestCase):
    def test_crossing_wires_are_not_connected(self):
        """The rule that matters. Two wires crossing with no endpoint at the
        crossing are separate nets; treating a shared point as a join collapsed
        a whole subcircuit into one 8674-point net."""
        c = Circuit(name="t")
        c.wires = [Wire((0, 50), (100, 50)), Wire((50, 0), (50, 100))]
        d = Design(path="t", text="", circuits={"t": c}, main="t")
        self.assertEqual(len(nl.build(d, c)), 2)

    def test_endpoint_on_a_span_does_connect(self):
        c = Circuit(name="t")
        c.wires = [Wire((0, 50), (100, 50)), Wire((50, 50), (50, 100))]
        d = Design(path="t", text="", circuits={"t": c}, main="t")
        self.assertEqual(len(nl.build(d, c)), 1)

    def test_pin_on_a_crossing_merges_both_nets(self):
        """Two wires crossing are separate -- but a component pin standing on
        the crossing connects them, and the netlist has to merge them."""
        c = Circuit(name="t")
        c.wires = [Wire((0, 50), (100, 50)), Wire((50, 0), (50, 100))]
        c.components = [Component(name="Probe", lib="0", loc=(50, 50), attrs={})]
        d = Design(path="t", text="", circuits={"t": c}, main="t")
        nets = nl.build(d, c)
        touching = [n for n in nets if (50, 50) in n.points]
        self.assertEqual(len(touching), 1, "the pin should have merged the two nets")
        self.assertEqual(len(touching[0].wires), 2)

    def test_clock_reaches_pc_fetch(self):
        """A real connection stated without coordinates."""
        d = _design(); m = d["main"]
        inst = [c for c in m.components if c.name == "pc_fetch"][0]
        clk = [p.at(inst) for p in geo.ports(d, inst) if p.name == "CLK"][0]
        n = nl.net_at(d, m, clk)
        self.assertIsNotNone(n, "pc_fetch CLK is not on any net")
        self.assertTrue(any(x.name == "Clock" for x, _ in n.pins),
                        "pc_fetch CLK is not driven by the Clock component")

    def test_no_net_has_two_drivers(self):
        d = _design()
        for circ in d:
            for n in nl.build(d, circ):
                self.assertLessEqual(len(n.drivers), 1,
                                     "%s: %s" % (circ.name, [(c.name, c.label, p)
                                                             for c, p in n.drivers]))


class TestLint(unittest.TestCase):
    def test_flags_a_wire_that_stops_short_of_a_pin(self):
        """Built rather than found: a near miss in the real design gets fixed,
        and the check would then quietly pass forever."""
        c = Circuit(name="t")
        c.components = [Component(name="AND Gate", lib="1", loc=(200, 100), attrs={})]
        c.wires = [Wire((100, 80), (140, 80))]     # in0 is at (150, 80)
        d = Design(path="t", text="", circuits={"t": c}, main="t")
        near = lint.near_misses(d, c)
        self.assertTrue(near, "a wire ending 10 short of in0 should be flagged")
        self.assertEqual(near[0]["distance"], 10)
        self.assertEqual(near[0]["port"], "in0")


class TestRoute(unittest.TestCase):
    def test_segments_collapse_straight_runs(self):
        path = [(0, 0), (10, 0), (20, 0), (20, 10)]
        self.assertEqual(route.to_segments(path), [(0, 0, 20, 0), (20, 0, 20, 10)])

    def test_instance_pins_are_obstacles(self):
        """Subcircuit pins are invisible to a component scan; if they are not
        in the obstacle set a route runs over one and connects to it."""
        d = _design(); m = d["main"]
        obs = route.obstacles(d, m)
        inst = [c for c in m.components if c.name == "pc_fetch"][0]
        for p in geo.ports(d, inst):
            self.assertIn(p.at(inst), obs.pads, "pc_fetch.%s is not an obstacle" % p.name)


class TestRender(unittest.TestCase):
    def test_every_circuit_renders_to_well_formed_svg(self):
        d = _design()
        for c in d:
            ET.fromstring(render.svg(d, c))

    def test_wires_carry_net_ids(self):
        """Net highlighting in the viewer depends on this attribute, and on
        buses keeping the net id too (they render as class="w b")."""
        d = _design()
        s = render.svg(d, d["pc_fetch"])
        import re as _re
        tags = _re.findall(r'<line class="(w[^"]*)" data-net="(-?\d+)"', s)
        self.assertTrue(tags, "no wire carried a data-net attribute")
        self.assertTrue(any(c == "w b" for c, _ in tags), "buses lost their net id")
        self.assertTrue(all(int(n) >= 0 for _, n in tags), "a wire got net id -1")


if __name__ == "__main__":
    unittest.main(verbosity=2)
