"""Model discriminators for components used by Operand2 carry logic."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from logisim.model import Component
from logisim.sim import Sim


class CarryPrimitives(unittest.TestCase):
    def evaluate(self, name, attrs, values):
        sim = Sim.__new__(Sim)
        nets = {name: i for i, name in enumerate((*values, 'out', 'cout'))}
        sim.value = {nets[name]: value for name, value in values.items()}
        sim.width = {index: 32 for index in nets.values()}
        result = sim._eval(dict(c=Component(name, '5', (0, 0), attrs), nets=nets))
        return {name: result[nets[name]] for name in ('out', 'cout') if nets[name] in result}

    def test_subtractor_wrap_and_borrow(self):
        for a, b, borrow, expected in [(32, 1, 0, (31, 0)), (0, 1, 0, (31, 1)),
                                        (5, 5, 1, (31, 1)), (31, 1, 1, (29, 0))]:
            got = self.evaluate('Subtractor', {'width': '5'}, dict(a=a, b=b, cin=borrow))
            self.assertEqual((got['out'], got['cout']), expected)

    def test_bit_selector_groups_and_zero_fill(self):
        for group, index, expected in [(1, 31, 1), (1, 1, 0), (8, 2, 0x34), (8, 4, 0)]:
            got = self.evaluate('BitSelector', {'width': '32', 'group': str(group)},
                                {'in': 0x80345601, 'sel': index})
            self.assertEqual(got['out'], expected)


if __name__ == '__main__':
    unittest.main()
