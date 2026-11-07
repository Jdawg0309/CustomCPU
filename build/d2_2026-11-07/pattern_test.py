import sys,json
from pathlib import Path
sys.path.insert(0,'tests')
import push_suite as ps
root=Path('build/d2_2026-11-07')
values=[0x11223344,0x80000001,0xff00aa55,0x01020304,0,0xffffffff]
lines=['.syntax unified','.arm','.global _start','_start:','mov r12,#0x1200','mov r1,#0x1100']; expected=[]
for value in values:
 lines += [f'ldr r2,=0x{value:x}','str r2,[r1]']
 for off in range(4):
  lines += [f'ldr r0,[r1,#{off}]',f'str r0,[r12,#{len(expected)*4}]']
  expected.append(((value>>(8*off))|(value<<(32-8*off)))&0xffffffff)
lines+=['adr r1,rom_data']
for off in range(4):
 lines += [f'ldr r0,[r1,#{off}]',f'str r0,[r12,#{len(expected)*4}]'];v=0xa1b2c3d4;expected.append(((v>>(8*off))|(v<<(32-8*off)))&0xffffffff)
lines += ['mov r1,#0x1100','ldr r2,=0x11223344','str r2,[r1]','ldr r0,[r1,#1]!',f'str r0,[r12,#{len(expected)*4}]'];expected.append(0x44112233)
lines += [f'str r1,[r12,#{len(expected)*4}]'];expected.append(0x1101)
lines += ['ldr r0,[r1],#2',f'str r0,[r12,#{len(expected)*4}]'];expected.append(0x44112233)
lines += [f'str r1,[r12,#{len(expected)*4}]'];expected.append(0x1103)
lines += ['mov r0,#0x5a',f'str r0,[r12,#{len(expected)*4}]','bx lr','.align 2','rom_data: .word 0xa1b2c3d4','.ltorg'];expected.append(0x5a)
for name,circ in [('master','arm_custom_subset.circ'),('d2','build/d2_2026-11-07/candidate_v2.circ')]:
 wd=root/('patterns_'+name);wd.mkdir(exist_ok=True);ps.CIRC=circ
 words=ps.assemble('\n'.join(lines)+'\n',str(wd));assert len(words)<=1024
 halt,osc,ram=ps.run_rom(words,str(wd));got=[int(ram.get(128+i,'0'),16) for i in range(len(expected))]
 result=dict(halted=halt,oscillated=osc,checks=len(expected),passed=sum(a==b for a,b in zip(expected,got)),expected=expected,got=got)
 (wd/'result.json').write_text(json.dumps(result,indent=2));print(name,result,flush=True)
