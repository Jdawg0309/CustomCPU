"""Failure-path checks for the real-Logisim runner (no CPU emulation)."""
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
import subprocess
import push_suite as ps


class RunnerChecks(unittest.TestCase):
    def test_ram_format(self):
        text = 'v3.0 hex words plain\n' + ' '.join(['A'] + ['0'] * 255)
        self.assertEqual(ps.parse_ram_dump(text), {0: '0000000a'})

    def test_bad_dumps_cannot_pass_as_zero(self):
        for text in ('', 'v3.0 hex words plain\n',
                     'v3.0 hex words plain\n0', 'v2.0 raw\n256*0',
                     'v3.0 hex words plain\n' + ' '.join(['E'] * 255 + ['xxxxxxxx'])):
            with self.subTest(text=text[:30]), self.assertRaises(ValueError):
                ps.parse_ram_dump(text)

    def test_failed_engine_and_missing_dump_rejected(self):
        for code in (0, 1):
            with tempfile.TemporaryDirectory() as td:
                # Even a previous good dump must not hide a failed new run.
                Path(td, 'ram.txt').write_text('v3.0 hex words plain\n' + '0 ' * 256)
                result = subprocess.CompletedProcess([], code, 'halted due to halt pin', '')
                with patch.object(ps.subprocess, 'run', return_value=result):
                    with self.assertRaises(RuntimeError):
                        ps.run_rom(['e12fff1e'], td)

    def test_timeout_is_not_a_cpu_mismatch(self):
        with tempfile.TemporaryDirectory() as td:
            result = subprocess.CompletedProcess([], 124, '', '')
            with patch.object(ps.subprocess, 'run', return_value=result):
                with self.assertRaises(subprocess.TimeoutExpired):
                    ps.run_rom(['eafffffe'], td)


if __name__ == '__main__':
    unittest.main()
