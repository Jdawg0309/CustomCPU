"""Retained direct-Logisim discriminators and unmasked Unicorn comparisons.

Requires Unicorn. The master is read-only; all runs use a caller's snapshot.
"""
import argparse
import hashlib
import json
from pathlib import Path
import random
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tests'))
import push_suite as ps
import unicorn_diff as ud
import memory_lane_regression as lanes
import register_offset_regression as offsets


def directed():
    for name, body, expected in offsets.CASES:
        yield 'offset: ' + name, body, expected
    for name, body, expected in lanes.CASES:
        yield 'lane: ' + name, ['mov r1,#0x1100'] + body, expected
    for insn in ['ldr r2,[r10]', 'ldrb r2,[r10]', 'ldrh r2,[r10]',
                 'ldrsb r2,[r10]', 'ldrsh r2,[r10]', 'strh r2,[r10]',
                 'ldmia r10,{r2}', 'stmia r10,{r2}']:
        body = ['mov r10,#0x1100', 'mov r2,#0x55', 'str r2,[r10]',
                'mov r0,#0', 'cmp r0,#1', insn, 'mov r0,#0',
                'orrmi r0,r0,#8', 'orreq r0,r0,#4', 'orrcs r0,r0,#2',
                'orrvs r0,r0,#1']
        yield 'NZCV preserved: ' + insn, body, 8
    for k in range(4):
        v = 0x11223344
        expected = ((v >> (8*k)) | (v << (32-8*k))) & 0xffffffff if k else v
        yield f'word LDR alignment offset {k}', [
            'mov r1,#0x1100', 'ldr r2,=0x11223344', 'str r2,[r1]',
            f'ldr r0,[r1,#{k}]'], expected
    for variant in ['ldm_pc_then_stm', 'ldm_pc_then_ldr', 'ldm_no_pc_then_stm',
                    'ldr_pc_then_stm', 'ldm_pc_then_ldm']:
        body = ['mov r10,#0x1100', 'mov r1,#17', 'str r1,[r10]',
                'adr r3,after', 'str r3,[r10,#4]']
        if variant.startswith('ldr_pc'):
            body += ['ldr pc,[r10,#4]', 'b .']
        elif variant.startswith('ldm_no_pc'):
            body += ['ldmia r10,{r4}']
        else:
            body += ['ldmia r10,{r4,pc}', 'b .']
        body += ['after:', 'mov r1,#0x55']
        body += ['stmia r10,{r1}'] if variant.endswith('stm') else [
            'ldmia r10,{r5}' if variant.endswith('ldm') else 'ldr r5,[r10]']
        body += ['mov r0,#0x5a']
        yield variant, body, 0x5a
    yield 'two stack-return calls', [
        'ldr sp,=0x13f0', 'mov r0,#0', 'bl f', 'bl f', 'b done',
        'f:', 'push {r4,lr}', 'add r0,r0,#1', 'pop {r4,pc}', 'done:'], 2
    yield 'two MOV-PC return calls control', [
        'mov r0,#0', 'bl f', 'bl f', 'b done',
        'f:', 'add r0,r0,#1', 'mov pc,lr', 'done:'], 2


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('circuit', type=Path)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--programs', type=int, default=2)
    ap.add_argument('--timeout', type=int, default=30)
    ap.add_argument('--start-directed', type=int, default=0)
    args = ap.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    ps.CIRC = str(args.circuit.resolve())
    ps.RUN_TIMEOUT = args.timeout
    rows = []
    def record(row):
        rows.append(row)
        (args.output / 'results.json').write_text(json.dumps(rows, indent=2))
        print(json.dumps(row), flush=True)
    marker = ['ldr r12,=0x13fc', 'mov r11,#0x5a', 'str r11,[r12]', 'mov lr,#0']
    for i, (name, body, expected) in enumerate(directed()):
        if i < args.start_directed:
            continue
        wd = args.output / f'directed_{i:03d}'
        wd.mkdir(exist_ok=True)
        asm = '\n'.join(['.syntax unified', '.arm', '.global _start', '_start:',
                         *body, 'mov r12,#0x1200', 'str r0,[r12]', *marker,
                         'halt_here:', 'bx lr', '.ltorg']) + '\n'
        row = dict(name=name, expected=expected, directory=str(wd))
        try:
            words, end = ud.assemble(asm, str(wd))
            # Unaligned loads use the written ARM rule, not Unicorn's behavior.
            if not name.startswith('word LDR alignment'):
                oracle = ud.oracle(words, end)
                actual_ref = int(oracle[0x80], 16)
                if actual_ref != expected or int(oracle[255], 16) != 0x5a:
                    raise ValueError(f'Bad test oracle: result {actual_ref:#x}')
            halted, osc, ram = ps.run_rom(words, str(wd))
            got = int(ram.get(0x80, '0'), 16)
            completed = int(ram.get(255, '0'), 16) == 0x5a
            row.update(got=got, halted=halted, oscillated=osc, completed=completed,
                       status='PASS' if halted and not osc and completed and got == expected else 'FAIL')
        except subprocess.TimeoutExpired:
            row.update(status='TIMEOUT', timeout_seconds=args.timeout)
        except Exception as e:
            row.update(status='HARNESS_ERROR', error=str(e), stderr=getattr(e, 'stderr', None))
        record(row)
    for cat in ud.CATEGORIES:
        for i in range(args.programs):
            wd = args.output / f'diff_{cat}_{i}'
            wd.mkdir(exist_ok=True)
            prefill, tests = ud.build_program(random.Random(f'20261025-{cat}-{i}'), [cat])
            asm = ud.render(prefill, tests).replace('halt_here:\n', '\n'.join(marker) + '\nhalt_here:\n')
            row = dict(name=f'Unicorn {cat} program {i}', directory=str(wd), tests=8)
            try:
                words, end = ud.assemble(asm, str(wd))
                expected = ud.oracle(words, end)
                (wd / 'expected_ram.json').write_text(json.dumps(expected))
                halted, osc, ram = ps.run_rom(words, str(wd))
                got = [ram.get(i, '00000000') for i in range(256)]
                bad = ud.diff(expected, got)
                complete = int(got[255], 16) == 0x5a
                row.update(status='PASS' if halted and not osc and complete and not bad else 'FAIL',
                           halted=halted, oscillated=osc, completed=complete, differences=bad)
            except subprocess.TimeoutExpired:
                row.update(status='TIMEOUT', timeout_seconds=args.timeout)
            except Exception as e:
                row.update(status='HARNESS_ERROR', error=str(e), stderr=getattr(e, 'stderr', None))
            record(row)
    (args.output / 'source.sha256').write_text(hashlib.sha256(args.circuit.read_bytes()).hexdigest() + '\n')
    print('SUMMARY', {s: sum(r['status'] == s for r in rows) for s in {r['status'] for r in rows}})
    return int(any(r['status'] != 'PASS' for r in rows))


if __name__ == '__main__':
    sys.exit(main())
