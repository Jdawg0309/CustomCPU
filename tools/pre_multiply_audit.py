#!/usr/bin/env python3
"""Run the established shifter cases with retained real-Logisim diagnostics."""
import argparse
import ast
from concurrent.futures import ThreadPoolExecutor
import importlib.util
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tests'))
import push_suite as ps


def deep_cases(extra=False):
    source = (ROOT / 'tools/deep_matrix.py').read_text()
    tree = ast.parse(source)
    collected = []
    latest = []

    def flags(lines):
        latest[:] = lines

    def record(group, name, got, want, note=''):
        collected.append((name, list(latest), dict(flags=want)))

    namespace = dict(flags_after=flags, record=record)
    functions = {'lit', 'add_flags', 'sub_flags', 'mem', 'blk', 'cf'}
    assignments = {'MASK', 'FLAG_VALS', 'MEM', 'BLK', 'CF'}
    selected = []
    for node in tree.body:
        if isinstance(node, ast.FunctionDef) and node.name in functions:
            selected.append(node)
        elif isinstance(node, ast.Assign) and any(
                isinstance(t, ast.Name) and t.id in assignments for t in node.targets):
            selected.append(node)
        elif isinstance(node, ast.For) and 'flags_after' in ast.unparse(node):
            selected.append(node)
        elif isinstance(node, ast.Expr) and isinstance(node.value, ast.Call) and isinstance(node.value.func, ast.Name) and node.value.func.id in {'mem', 'blk', 'cf'}:
            selected.append(node)
    exec(compile(ast.Module(body=selected, type_ignores=[]), '<deep cases>', 'exec'), namespace)
    collected += [(name, lines, {reg: value}) for name, lines, reg, value, _ in namespace['MEM']]
    collected += [(name, lines, checks) for key in ('BLK', 'CF')
                  for name, lines, checks, _ in namespace[key]]
    if extra:
        collected = []
        mask = 0xffffffff
        signed = lambda value: value if value < 0x80000000 else value - 0x100000000
        for opcode in ('adcs', 'sbcs', 'rscs'):
            for a, b, carry in ((0x7fffffff, 0, 1), (0xffffffff, 0, 1),
                                (0, 0, 0), (0x80000000, 1, 1),
                                (0x7fffffff, 0xffffffff, 0), (0, 0xffffffff, 0)):
                left, right = (b, a) if opcode == 'rscs' else (a, b)
                if opcode == 'adcs':
                    full = left + right + carry
                    signed_full = signed(left) + signed(right) + carry
                    cout = int(full > mask)
                else:
                    full = left - right - (1 - carry)
                    signed_full = signed(left) - signed(right) - (1 - carry)
                    cout = int(full >= 0)
                result = full & mask
                flags = (result >> 31, int(result == 0), cout,
                         int(not -0x80000000 <= signed_full <= 0x7fffffff))
                lines = ['    mov r10,#0', f'    cmp r10,#{0 if carry else 1}',
                         f'    ldr r1,=0x{a:x}', f'    ldr r2,=0x{b:x}',
                         f'    {opcode} r0,r1,r2']
                collected.append((f'{opcode} boundary {a:x},{b:x} C={carry}', lines, dict(flags=flags)))
        for opcode in ('ands', 'eors', 'orrs', 'bics', 'movs', 'mvns', 'tst', 'teq'):
            for value in (0x80000001, 0x7ffffffe):
                a, b = 0xf0f0f0f0, (value << 1) & mask
                result = {'ands': a & b, 'eors': a ^ b, 'orrs': a | b, 'bics': a & ~b,
                          'movs': b, 'mvns': (~b) & mask, 'tst': a & b, 'teq': a ^ b}[opcode]
                operands = 'r1,r2' if opcode in ('tst', 'teq') else (
                    'r0,r2' if opcode in ('movs', 'mvns') else 'r0,r1,r2')
                lines = ['    mov r9,#0x80000000', '    cmp r9,#1',
                         '    ldr r1,=0xf0f0f0f0', f'    ldr r2,=0x{value:x}',
                         f'    {opcode} {operands},lsl #1']
                collected.append((f'{opcode} shifter carry and V preservation {value:x}', lines,
                                  dict(flags=(result >> 31, int(result == 0), value >> 31, 1))))
    for name, lines, checks in collected:
        # Snapshot results before scratch registers are used for completion.
        body = ['.syntax unified', '.arm', '.global _start', '_start:']
        if name == 'nested bl / lr save':
            body.append('    mov sp,#0x1400')
        body += lines
        body += ['    mov r12,#0x1200']
        expected = []
        if 'flags' in checks:
            for i, cond in enumerate(('mi', 'eq', 'cs', 'vs')):
                body += ['    mov r10,#0', f'    mov{cond} r10,#1', f'    str r10,[r12,#{i*4}]']
            expected = list(checks['flags'])
        else:
            for i, (reg, value) in enumerate(checks.items()):
                assert reg not in (12, 13)
                body.append(f'    str r{reg},[r12,#{i*4}]')
                expected.append(value)
        body += ['    mov r11,#0x5a', f'    str r11,[r12,#{len(expected)*4}]', '    bx lr']
        yield name, '\n'.join(body) + '\n', tuple(expected + [0x5a]), 0x1200


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('circuit', type=Path)
    parser.add_argument('--limit', type=int)
    parser.add_argument('--match', default='')
    parser.add_argument('--suite', choices=('shifter', 'deep', 'extra'), default='shifter')
    parser.add_argument('--jobs', type=int, default=4)
    parser.add_argument('--output', type=Path, default=ROOT / 'build/pre_multiply_audit/results')
    args = parser.parse_args()
    spec = importlib.util.spec_from_file_location(
        'shifter_cases', ROOT / 'tests/shifter_discriminator.py')
    suite = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(suite)
    ps.CIRC = str(args.circuit.resolve())
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    original_run = ps.subprocess.run

    def checked_run(command, **kwargs):
        result = original_run(command, **kwargs)
        if command[0] == 'xvfb-run':
            Path(command[-1]).with_suffix('.log').write_text(
                (result.stdout or '') + (result.stderr or ''))
            if result.returncode:
                raise RuntimeError(f'Logisim exited {result.returncode}: {result.stderr} {result.stdout}')
        return result

    ps.subprocess.run = checked_run
    results = []
    cases = list(deep_cases(args.suite == 'extra')) if args.suite != 'shifter' else [
        (*case, suite.RESULT) for case in suite.cases()]
    if args.suite == 'shifter':
        for amount in (0, 1, 32, 33, 255, 256):
            for carry in (0, 1):
                asm = suite.make_program(0x80000001, carry, 'movs r0,r1,ror r0', amount)
                asm = asm.replace('ldr r3,=', 'ldr r0,=')
                cases.append((f'ROR amount register r0={amount} C={carry}', asm,
                              suite.register_expected('ror', 0x80000001, amount, carry), suite.RESULT))
        for carry in (0, 1):
            for immediate, expected_carry in ((0x80000000, 1), (0x100, 0), (1, carry)):
                cases.append((f'immediate operand carry {immediate:08x} C={carry}',
                              suite.make_program(0, carry, f'movs r0,#0x{immediate:x}'),
                              (immediate, expected_carry), suite.RESULT))
    cases = [case for case in cases if args.match in case[0]]
    if args.limit:
        cases = cases[:args.limit]

    def execute(item):
        index, (name, asm, expected, address) = item
        directory = output / f'{index:03d}'
        directory.mkdir(exist_ok=True)
        words = ps.assemble(asm, str(directory))
        halted, oscillated, ram = ps.run_rom(words, str(directory))
        got = tuple(int(ram.get((address - ps.RAM_BASE) // 4 + i, '0'), 16)
                    for i in range(len(expected)))
        passed = halted and not oscillated and got == expected
        row = dict(name=name, passed=passed, halted=halted, oscillated=oscillated,
                   expected=expected, got=got)
        print(f'{index:03d} {"PASS" if passed else "FAIL"} {name} got={got} expected={expected}', flush=True)
        return row

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        for row in pool.map(execute, enumerate(cases, 1)):
            results.append(row)
            (output / f'{args.suite}.json').write_text(json.dumps(results, indent=2))
    print(f'{sum(r["passed"] for r in results)}/{len(results)} passed')
    return int(any(not r['passed'] for r in results))


if __name__ == '__main__':
    raise SystemExit(main())
