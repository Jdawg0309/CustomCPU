"""Case definitions for tools/pre_multiply_audit.py (real Logisim engine).

Extracted verbatim from the former tools/deep_matrix.py, which ran these same
cases through the Python CPU simulator and was deleted with it.  Nothing here
simulates anything: pre_multiply_audit.py executes these definitions with its
own flags_after/record hooks and runs every case on the Logisim jar.
"""

MASK = 4294967295

def lit(rd, value):
    return '    ldr r%d, =0x%08x' % (rd, value & MASK)

def add_flags(a, b, cin=0):
    r = a + b + cin & MASK
    c = 1 if a + b + cin > MASK else 0
    v = 1 if ((a ^ r) & (b ^ r)) >> 31 & 1 else 0
    return (r >> 31 & 1, int(r == 0), c, v)

def sub_flags(a, b):
    r = a - b & MASK
    c = 1 if a >= b else 0
    v = 1 if ((a ^ b) & (a ^ r)) >> 31 & 1 else 0
    return (r >> 31 & 1, int(r == 0), c, v)

FLAG_VALS = [0, 1, 2, 2147483647, 2147483648, 4294967295, 1431655765]

for a in FLAG_VALS:
    for b in FLAG_VALS:
        got = flags_after([lit(0, a), lit(1, b), '    adds r2,r0,r1'])
        record('flags-adds', 'adds %08x,%08x' % (a, b), got, add_flags(a, b))
        got = flags_after([lit(0, a), lit(1, b), '    subs r2,r0,r1'])
        record('flags-subs', 'subs %08x,%08x' % (a, b), got, sub_flags(a, b))
        got = flags_after([lit(0, a), lit(1, b), '    cmp r0,r1'])
        record('flags-cmp', 'cmp %08x,%08x' % (a, b), got, sub_flags(a, b))
        got = flags_after([lit(0, a), lit(1, b), '    cmn r0,r1'])
        record('flags-cmn', 'cmn %08x,%08x' % (a, b), got, add_flags(a, b))

for a, b in [(4042322160, 252645135), (4294967295, 4294967295), (0, 4294967295), (2147483648, 4294967295)]:
    for op, fn in (('ands', lambda x, y: x & y), ('orrs', lambda x, y: x | y), ('eors', lambda x, y: x ^ y), ('bics', lambda x, y: x & ~y)):
        r = fn(a, b) & MASK
        got = flags_after([lit(3, 5), '    cmp r3,#1', lit(0, a), lit(1, b), '    %s r2,r0,r1' % op])
        record('flags-logical', '%s %08x,%08x' % (op, a, b), got, (r >> 31 & 1, int(r == 0), 1, 0), 'C must be preserved (no shift), V unchanged')

for a, b in [(240, 15), (255, 255), (2147483648, 2147483648)]:
    r = a & b
    got = flags_after([lit(3, 5), '    cmp r3,#1', lit(0, a), lit(1, b), '    tst r0,r1'])
    record('flags-logical', 'tst %08x,%08x' % (a, b), got, (r >> 31 & 1, int(r == 0), 1, 0))

MEM = []

def mem(name, lines, want_reg, want, note=''):
    MEM.append((name, lines, want_reg, want, note))

mem('byte lane 0', [lit(1, 4352), '    mov r2,#0xAB', '    strb r2,[r1]', '    ldrb r0,[r1]'], 0, 171)

mem('byte lane 1 isolated', [lit(1, 4352), '    mov r2,#0x11', '    strb r2,[r1]', '    mov r2,#0x22', '    strb r2,[r1,#1]', '    ldrb r0,[r1]'], 0, 17, 'writing lane 1 must not disturb lane 0')

mem('strb truncates', [lit(1, 4352), lit(2, 511), '    strb r2,[r1]', '    ldrb r0,[r1]'], 0, 255)

mem('ldrb zero-extends', [lit(1, 4352), lit(2, 4294967168), '    str r2,[r1]', '    ldrb r0,[r1]'], 0, 128)

mem('halfword store/load', [lit(1, 4352), lit(2, 43981), '    strh r2,[r1]', '    ldrh r0,[r1]'], 0, 43981)

mem('ldrsb sign-extends', [lit(1, 4352), lit(2, 255), '    strb r2,[r1]', '    ldrsb r0,[r1]'], 0, 4294967295)

mem('ldrsh sign-extends', [lit(1, 4352), lit(2, 32768), '    strh r2,[r1]', '    ldrsh r0,[r1]'], 0, 4294934528)

mem('reg offset LOAD is not ignored', [lit(1, 4352), lit(4, 4368), lit(2, 170), '    str r2,[r1]', lit(2, 187), '    str r2,[r4]', '    mov r3,#16', '    ldr r0,[r1,r3]'], 0, 187, '0xAA here means the offset was dropped and the base was used')

mem('reg offset STORE is not ignored', [lit(1, 4352), '    mov r3,#16', lit(2, 204), '    str r2,[r1,r3]', '    ldr r0,[r1,#16]'], 0, 204, 'read back through the IMMEDIATE form, so a dropped offset shows up')

mem('scaled reg offset lsl#2', [lit(1, 4352), '    mov r3,#3', lit(2, 204), '    str r2,[r1,#12]', '    ldr r0,[r1,r3,lsl #2]'], 0, 204)

mem('negative reg offset', [lit(1, 4368), '    mov r3,#16', lit(2, 90), lit(4, 4352), '    str r2,[r4]', '    ldr r0,[r1,-r3]'], 0, 90)

mem('pre-index writeback', [lit(1, 4352), lit(2, 119), '    str r2,[r1,#8]!', '    mov r0,r1'], 0, 4360)

mem('post-index leaves base then adds', [lit(1, 4352), lit(2, 136), '    str r2,[r1],#4', lit(3, 4352), '    ldr r0,[r3]'], 0, 136)

mem('swp word', [lit(1, 4352), lit(2, 170), '    str r2,[r1]', lit(3, 187), '    swp r0,r3,[r1]'], 0, 170)

mem('ldr/str round trip 0xFFFFFFFF', [lit(1, 4352), lit(2, 4294967295), '    str r2,[r1]', '    ldr r0,[r1]'], 0, 4294967295)

BLK = []

def blk(name, lines, checks, note=''):
    BLK.append((name, lines, checks, note))

blk('stm does not clobber Rd-field reg', [lit(4, 4352), '    mov r1,#0x11', '    mov r2,#0x22', '    mov r0,#0x99', '    stmia r4!,{r1,r2}'], {0: 153}, 'instr[15:12]=0, so a boundary write lands on r0')

blk('ldm does not clobber Rd-field reg', [lit(4, 4352), '    mov r1,#0x31', '    mov r2,#0x32', '    str r1,[r4]', '    str r2,[r4,#4]', '    mov r0,#0x99', '    ldmia r4!,{r6,r7}'], {0: 153, 6: 49, 7: 50})

blk('single register stm/ldm', [lit(4, 4352), '    mov r1,#0x5A', '    stmia r4!,{r1}', '    mov r1,#0', lit(5, 4352), '    ldmia r5!,{r1}'], {1: 90, 4: 4356, 5: 4356})

blk('base register inside the list (store)', [lit(4, 4352), '    mov r1,#0x11', '    stmia r4!,{r1,r4}', lit(5, 4352), '    ldr r0,[r5,#4]'], {0: 4352}, 'STM with base in list stores the ORIGINAL base')

blk('all low registers round trip', [lit(8, 4352)] + ['    mov r%d,#%d' % (i, i) for i in range(8)] + ['    stmia r8!,{r0-r7}'] + ['    mov r%d,#0' % i for i in range(8)] + [lit(9, 4352), '    ldmia r9!,{r0-r7}'], {i: i for i in range(8)})

blk('stmdb/ldmdb pair', [lit(4, 4384), '    mov r1,#0x41', '    mov r2,#0x42', '    stmdb r4!,{r1,r2}', '    mov r1,#0', '    mov r2,#0', '    ldmia r4!,{r1,r2}'], {1: 65, 2: 66})

blk('conditional block transfer suppressed', [lit(4, 4352), '    mov r1,#0x11', '    mov r0,#0', '    cmp r0,#1', '    stmiaeq r4!,{r1}', '    mov r0,r4'], {0: 4352}, 'EQ is false, so the base must NOT advance')

CF = []

def cf(name, lines, checks, note=''):
    CF.append((name, lines, checks, note))

cf('backward branch loop x3', ['    mov r0,#0', '    mov r1,#3', 'lp:', '    add r0,r0,#10', '    subs r1,r1,#1', '    bne lp'], {0: 30, 1: 0})

cf('nested bl / lr save', ['    mov r0,#0', '    bl f1', '    add r0,r0,#1', '    b done', 'f1:', '    push {lr}', '    bl f2', '    pop {lr}', '    add r0,r0,#10', '    mov pc,lr', 'f2:', '    add r0,r0,#100', '    mov pc,lr', 'done:'], {0: 111}, 'requires lr save/restore across a nested call')

cf('conditional branch not taken falls through', ['    mov r0,#5', '    cmp r0,#5', '    bne away', '    mov r1,#7', '    b end', 'away:', '    mov r1,#99', 'end:'], {1: 7})

cf('b to the very next instruction', ['    mov r0,#1', '    b nxt', 'nxt:', '    add r0,r0,#1'], {0: 2})

cf('ldr pc redirect', ['    mov r0,#1', lit(1, 4352), '    adr r2,tgt', '    str r2,[r1]', '    ldr pc,[r1]', '    mov r0,#99', 'tgt:', '    mov r0,#7'], {0: 7})

cf('pc as operand reads +8', ['    mov r0,pc', '    mov r1,pc'], {0: 8, 1: 12})

cf('add to pc computed jump', ['    mov r0,#1', '    add pc,pc,#4', '    mov r0,#99', '    mov r0,#5', '    mov r0,#7'], {0: 7}, 'pc reads +8, so at word 1 the target is word (1*4+8+4)/4 = 4')
