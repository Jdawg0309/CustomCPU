#!/usr/bin/env python3
"""Retained real-Logisim probes for gaps excluded by the random generator.

Uses an external PC observer on a disposable copy for BX tests. CPU state,
datapath and control wiring are untouched. Every test must write a completion
marker; unsupported instructions are failures, never silently skipped passes.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / 'tests'))
from logisim import edit
import push_suite as ps
import unicorn_diff as ud


def terminal_observer(text, end):
    """Move only the halt output pin to PC_PLUS4 == terminal address + 4."""
    a, b = edit._circuit_span(text, 'main')
    body = text[a:b]
    matches = []
    for m in re.finditer(r'<comp\b[^>]*name="Pin">.*?</comp>', body, re.S):
        attrs = {x.get('name'): x.get('val') for x in ET.fromstring(m.group()).findall('a')}
        if attrs.get('label') == 'halt':
            matches.append(m.group())
    assert len(matches) == 1
    text = text[:a] + body.replace(matches[0], '', 1) + text[b:]
    for lib, name, loc, attrs in [
        ('5', 'Comparator', (6200, 3000), {'width': '32', 'mode': 'unsigned', 'label': 'TEST_TERMINAL_PC'}),
        ('0', 'Tunnel', (6160, 2990), {'width': '32', 'label': 'PC_PLUS4'}),
        ('0', 'Constant', (6160, 3010), {'width': '32', 'value': hex(end + 4)}),
        ('0', 'Pin', (6240, 3000), {'type': 'output', 'facing': 'west', 'label': 'halt'}),
    ]:
        text = edit.add_component(text, 'main', lib, name, loc, attrs)
    return edit.add_wires(text, 'main', [(6200, 3000, 6240, 3000)])


def cases():
    # Do not assert PC+8/+12 for register-specified shifts. ARM DDI 0100I
    # A5.1.6 marks R15 in Rd/Rm/Rn/Rs UNPREDICTABLE for this operand form.
    yield 'boundary LDM base in list without writeback', ['mov r1,#0x1100',
        'mov r2,#23','str r2,[r1]','mov r2,#47','str r2,[r1,#4]',
        'ldmia r1,{r0,r1}'], {0:23,1:47}, False
    yield 'boundary STM base first with writeback', ['mov r1,#0x1100',
        'mov r2,#47','stmia r1!,{r1,r2}','mov r3,#0x1100',
        'ldr r0,[r3]','ldr r4,[r3,#4]'], {0:0x1100,1:0x1108,4:47}, False
    # Positive control for the changed termination monitor, plus actual BX.
    yield 'observer control MOV-PC return', ['mov r0,#0', 'bl sub', 'b done',
        'sub:', 'add r0,r0,#7', 'mov pc,lr', 'done:'], {0: 7}, True
    yield 'BX two ARM returns', ['mov r0,#0', 'bl sub', 'bl sub', 'b done',
        'sub:', 'add r0,r0,#7', 'bx lr', 'done:'], {0: 14}, True
    yield 'BX register redirect', ['adr r3,target', 'bx r3', 'mov r0,#99',
        'b done', 'target:', 'mov r0,#37', 'done:'], {0: 37}, True
    yield 'BX failed condition falls through', ['mov r0,#1', 'cmp r0,#2',
        'adr r3,target', 'bxeq r3', 'mov r0,#38', 'b done',
        'target:', 'mov r0,#99', 'done:'], {0: 38}, True
    yield 'BX taken condition redirects', ['mov r0,#1', 'cmp r0,#1',
        'adr r3,target', 'bxeq r3', 'mov r0,#99', 'b done',
        'target:', 'mov r0,#39', 'done:'], {0: 39}, True

    for op, expected in [('mul', {0: 0xfffffffe}), ('mla', {0: 1}),
                         ('umull', {0: 0xfffffffe, 4: 1}),
                         ('umlal', {0: 3, 4: 9}),
                         ('smull', {0: 0xfffffffe, 4: 0xffffffff}),
                         ('smlal', {0: 3, 4: 7})]:
        body = ['mvn r1,#0', 'mov r2,#2', 'mov r3,#3', 'mov r0,#5', 'mov r4,#7']
        args = 'r0,r1,r2' if op == 'mul' else ('r0,r1,r2,r3' if op == 'mla' else 'r0,r4,r1,r2')
        yield op.upper() + ' result', body + [op + ' ' + args], expected, False
    for op in ['muls', 'umulls', 'smulls']:
        for zero in (False, True):
            args = 'r0,r1,r2' if op == 'muls' else 'r0,r4,r1,r2'
            # Only N/Z are asserted; old ARM multiply C behavior is not an oracle.
            body = ['mov r6,#0', 'cmp r6,#1' if zero else 'cmp r6,#0',
                    'mov r1,#0' if zero else 'mvn r1,#0', 'mov r2,#2', op+' '+args,
                    'mov r5,#0', 'orrmi r5,r5,#2', 'orreq r5,r5,#1']
            nz = 1 if zero else (0 if op == 'umulls' else 2)
            yield f'{op.upper()} NZ zero={zero}', body, {5: nz}, False
    yield 'MUL failed condition preserves destination', ['mov r0,#23','mov r1,#7',
        'mov r2,#6','cmp r1,#0','muleq r0,r1,r2'], {0: 23}, False

    for op in ['swp', 'swpb']:
        for lane in ([0] if op == 'swp' else range(4)):
            body = ['mov r1,#0x1100','ldr r2,=0x11223344','str r2,[r1]',
                    f'add r1,r1,#{lane}','ldr r3,=0xaabbccdd',f'{op} r0,r3,[r1]',
                    'mov r1,#0x1100','ldr r4,[r1]']
            old = 0x11223344 if op=='swp' else (0x11223344>>(lane*8))&255
            new = 0xaabbccdd if op=='swp' else (0x11223344 & ~(255<<(lane*8))) | (0xdd<<(lane*8))
            yield f'{op.upper()} lane {lane}', body, {0: old, 4: new}, False

    yield 'MRS reads known NZCV', ['mov r1,#0','cmp r1,#1','mov r0,#0x55',
        'mrs r0,cpsr','mov r0,r0,lsr #28'], {0: 8}, False
    for form in ('immediate', 'register'):
        for flags in (0, 2, 4, 8, 15):
            body = ['mov r1,#0','cmp r1,#0' if flags==8 else 'cmp r1,#1']
            body += [f'ldr r2,=0x{flags<<28:x}', 'msr cpsr_f,r2'] if form=='register' else [f'msr cpsr_f,#0x{flags<<28:x}']
            body += ['mov r0,#0','orrmi r0,r0,#8','orreq r0,r0,#4','orrcs r0,r0,#2','orrvs r0,r0,#1']
            yield f'MSR flags {form} {flags:x}', body, {0: flags}, False

    for op in ('ldr', 'ldrb', 'ldrh', 'ldrsb', 'ldrsh'):
        offsets = (0,) if op=='ldr' else ((0,2) if op in ('ldrh','ldrsh') else range(4))
        for off in offsets:
            value = 0x80fe917f
            width = 32 if op=='ldr' else (16 if op in ('ldrh','ldrsh') else 8)
            want = (value>>(8*off)) & ((1<<width)-1)
            if op in ('ldrsb','ldrsh') and want & (1<<(width-1)):
                want |= 0xffffffff ^ ((1<<width)-1)
            body = ['adr r1,data', f'{op} r0,[r1,#{off}]','b done',
                    '.align 2','data: .word 0x80fe917f','done:']
            yield f'ROM {op.upper()} offset {off}', body, {0: want}, False

    for shift, rm, offset in [('lsr #32',4,0),('asr #32',4,0),
                               ('asr #32',0xffffffff,-1),('rrx',8,4)]:
        for store in (False, True):
            body=['ldr r1,=0x1104','ldr r2,=0x11223344','str r2,[r1,#-4]',
                  'ldr r2,=0x55667788','str r2,[r1]','ldr r2,=0x99aabbcc','str r2,[r1,#4]',
                  f'ldr r3,=0x{rm:x}','mov r4,#0','cmp r4,#1']
            if store:
                body += ['mov r0,#0xee',f'strb r0,[r1,r3,{shift}]',f'ldrb r0,[r1,#{offset}]']
                want=0xee
            else:
                body += [f'ldrb r0,[r1,r3,{shift}]']
                want={0:0x88,-1:0x11,4:0xcc}[offset]
            yield f'address shift {"STRB" if store else "LDRB"} {shift} Rm={rm:x}',body,{0:want},False
    yield 'address RRX carry=1 subtraction', ['mov r1,#0x1100','mov r2,#0x66','str r2,[r1]',
        'ldr r1,=0x80001104','mov r3,#8','cmp r3,#0','ldr r0,[r1,-r3,rrx]'],{0:0x66},False
    yield ('confirm ROM halfword source', ['adr r1,data','add r2,r1,#0x1000',
        'ldr r3,=0x12345678','str r3,[r2]','ldrh r0,[r1]','ldrsh r4,[r1,#2]',
        'ldr r5,[r1]','b done','.align 2','data: .word 0x80fe917f','done:'],
           {0:0x917f,4:0xffff80fe,5:0x80fe917f},False)
    for shift,rm,offset in [('lsr #32',4,0),('asr #32',4,0),('rrx',8,4)]:
        for store in (False,True):
            body=['mov r1,#0x1100','ldr r2,=0x11223344','str r2,[r1]',
                  'ldr r2,=0x55667788','str r2,[r1,#4]',f'mov r3,#{rm}',
                  'mov r4,#0','cmp r4,#1']
            if store:
                body+=['ldr r0,=0xaabbccdd',f'str r0,[r1,r3,{shift}]',f'ldr r0,[r1,#{offset}]']
                want=0xaabbccdd
            else:
                body+=[f'ldr r0,[r1,r3,{shift}]'];want=0x11223344 if offset==0 else 0x55667788
            yield f'confirm address {"STR" if store else "LDR"} {shift}',body,{0:want},False


def main():
    ap=argparse.ArgumentParser();ap.add_argument('circuit',type=Path)
    ap.add_argument('--output',type=Path,required=True);ap.add_argument('--match',default='')
    ap.add_argument('--timeout',type=int,default=30);args=ap.parse_args()
    source=args.circuit.read_text();fingerprint=hashlib.sha256(source.encode()).hexdigest()
    args.output.mkdir(parents=True,exist_ok=True);ps.RUN_TIMEOUT=args.timeout
    results=[]
    for i,(name,body,checks,observe) in enumerate(cases()):
        if args.match not in name:continue
        wd=args.output/f'{i:03d}';wd.mkdir(exist_ok=True)
        lines=['.syntax unified','.arm','.global _start','_start:',*body,'mov r12,#0x1200']
        for j,reg in enumerate(checks):lines.append(f'str r{reg},[r12,#{j*4}]')
        lines+=['mov r11,#0x5a','str r11,[r12,#252]','halt_here:',
                'b halt_here' if observe else 'bx lr','.ltorg']
        row=dict(name=name,directory=str(wd),terminal_observer=observe,expected=list(checks.values()))
        try:
            words,end=ud.assemble('\n'.join(lines)+'\n',str(wd))
            assert len(words)<=1024
            ref=ud.oracle(words,end)
            expected=list(checks.values())
            assert [int(ref[128+j],16) for j in range(len(expected))]==expected,'Reference disagrees with expected values'
            assert int(ref[191],16)==0x5a,'Reference did not complete'
            target=wd/'observed.circ'
            if observe:
                target.write_text(terminal_observer(source,end));ps.CIRC=str(target)
            else:ps.CIRC=str(args.circuit.resolve())
            halt,osc,ram=ps.run_rom(words,str(wd))
            got=[int(ram.get(128+j,'0'),16) for j in range(len(expected))]
            complete=int(ram.get(191,'0'),16)==0x5a
            row.update(got=got,halted=halt,oscillated=osc,completed=complete,
                       status='PASS' if halt and not osc and complete and got==expected else 'FAIL')
        except subprocess.TimeoutExpired:row.update(status='TIMEOUT')
        except Exception as e:row.update(status='HARNESS_ERROR',error=str(e),stderr=str(getattr(e,'stderr','')))
        results.append(row);(args.output/'results.json').write_text(json.dumps(results,indent=2))
        print(json.dumps(row),flush=True)
    assert hashlib.sha256(args.circuit.read_bytes()).hexdigest()==fingerprint
    (args.output/'source.sha256').write_text(fingerprint+'\n')
    print('SUMMARY',{s:sum(r['status']==s for r in results) for s in {r['status'] for r in results}})
    return int(any(r['status']!='PASS' for r in results))


if __name__=='__main__':raise SystemExit(main())
