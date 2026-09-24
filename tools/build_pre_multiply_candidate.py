#!/usr/bin/env python3
"""Reproduce the carry and boundary repairs only in the audit candidate."""
import importlib.util
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from logisim import edit

TARGET = ROOT / 'build/pre_multiply_audit/candidate.circ'


def load(name):
    path = ROOT.parent / 'CustomCPU-COT/tools' / (name + '.py')
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.PATH = TARGET
    return module


def main():
    carry = load('finish_sandbox_shifter')
    # Real Logisim verifies the existing RRX result select. The older helper
    # used incorrect rotated-mux geometry; omit its redundant select wire.
    original_add_wires = edit.add_wires

    def verified_wires(text, circuit, wires):
        return original_add_wires(text, circuit, [
            w for w in wires if w != (1790, 1180, 1830, 1180)])

    edit.add_wires = verified_wires
    try:
        carry.main()
    finally:
        edit.add_wires = original_add_wires
    load('fix_sandbox_shift_edges').main()


if __name__ == '__main__':
    main()
