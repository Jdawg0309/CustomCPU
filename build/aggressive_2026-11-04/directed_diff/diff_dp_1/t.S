.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000020
str r0, [r12, #0]
ldr r0, =0x00000002
str r0, [r12, #4]
ldr r0, =0x93afb592
str r0, [r12, #8]
ldr r0, =0xf6a4be8e
str r0, [r12, #12]
ldr r0, =0xa844a996
str r0, [r12, #16]
ldr r0, =0x205237d4
str r0, [r12, #20]
ldr r0, =0xe9caec53
str r0, [r12, #24]
ldr r0, =0x5565ae24
str r0, [r12, #28]
ldr r0, =0x80000000
str r0, [r12, #32]
ldr r0, =0x00000100
str r0, [r12, #36]
ldr r0, =0x8bc0b795
str r0, [r12, #40]
ldr r0, =0xabfab78d
str r0, [r12, #44]
ldr r0, =0x49eb67bc
str r0, [r12, #48]
ldr r0, =0x6f1f9b32
str r0, [r12, #52]
ldr r0, =0xffffffff
str r0, [r12, #56]
ldr r0, =0x7ffffffe
str r0, [r12, #60]
ldr r0, =0x00000101
ldr r1, =0x5ddd663f
ldr r2, =0x00000100
ldr r3, =0x0000ffff
ldr r4, =0xa0254a47
ldr r5, =0xcf3cb344
ldr r6, =0x7ffffffe
ldr r7, =0x00000021
ldr r8, =0x7ffffffe
ldr r9, =0xffffffff
ldr r10, =0x31d74c5c
ldr r11, =0x6c730011
ldr r12, =0x7ffffffe
ldr r14, =0xcd16d0fd
tst r4, r14
sbcs r6, r12, r3
movs r10, r6, lsr r0
cmpvs r4, r4, asr #22
mvns r7, #0x49000
cmp r3, r1, asr r3
ldr sp, =0x1200
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r0, =0x00000101
ldr r1, =0xa9c92b0c
ldr r2, =0x0632fd09
ldr r3, =0x3bba4421
ldr r4, =0x7f834c7d
ldr r5, =0x87e470c2
ldr r6, =0x24cd3ac9
ldr r7, =0x4c5f21a2
ldr r8, =0x13ff0e3d
ldr r9, =0x3165e02d
ldr r10, =0x7ffffffe
ldr r11, =0x00000101
ldr r12, =0x00000020
ldr r14, =0x40a0e7ed
cmn r0, r14
adcsvc r6, r5, r4, rrx
mvnslt r4, r9, asr r6
teq r10, r8, ror r2
ldr sp, =0x1240
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r0, =0x00000000
ldr r1, =0x00000101
ldr r2, =0xfa59d3ab
ldr r3, =0x17e199b7
ldr r4, =0x2eae468e
ldr r5, =0x383d9fa1
ldr r6, =0x6b888af1
ldr r7, =0x00000021
ldr r8, =0x00000002
ldr r9, =0xc25d392b
ldr r10, =0x980d83ab
ldr r11, =0x4bb6ce43
ldr r12, =0x46af5ecc
ldr r14, =0xdaa95bd3
tst r10, r12
tst r6, #0x20000000
teq r2, r1, lsr r6
eors r4, r11, r1, asr r4
sbc r1, r5, r12, lsl r3
and r12, r0, #0x84
eor r11, r8, r6, rrx
ldr sp, =0x1280
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r0, =0x00000002
ldr r1, =0xc2e76d33
ldr r2, =0xdb5c75b7
ldr r3, =0x0000001f
ldr r4, =0xc9716e66
ldr r5, =0x80000000
ldr r6, =0x00000021
ldr r7, =0xcd800c81
ldr r8, =0x996339a5
ldr r9, =0x0000001f
ldr r10, =0x9df2fdd1
ldr r11, =0x3b91eb7e
ldr r12, =0x0000001f
ldr r14, =0x7121231e
cmn r8, r8
adc r5, r10, #0x8c00000
sbcs r2, r2, r12, asr r8
cmp r11, r4, ror #3
mov r6, r6, lsr #8
bic r12, r14, r6, lsl #8
add r12, r5, r14, ror #19
ldr sp, =0x12c0
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r0, =0x6959f4e0
ldr r1, =0x15bc9549
ldr r2, =0x3229b677
ldr r3, =0xffffffff
ldr r4, =0xcafebabe
ldr r5, =0x38da72f1
ldr r6, =0x00000101
ldr r7, =0xea7c1a43
ldr r8, =0xf228a55e
ldr r9, =0x49d40d90
ldr r10, =0x00000001
ldr r11, =0xa9028d57
ldr r12, =0x91b4eaa0
ldr r14, =0x80000000
tst r11, r2
tst r0, r8, rrx
subls r9, r3, r1, asr r9
mov r11, r0, ror #28
ldr sp, =0x1300
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r0, =0x80000000
ldr r1, =0xcafebabe
ldr r2, =0x80000000
ldr r3, =0xececa9ba
ldr r4, =0x7ffffffe
ldr r5, =0x0000001f
ldr r6, =0x80000000
ldr r7, =0xffc7517d
ldr r8, =0xffffffff
ldr r9, =0xe45d7fdd
ldr r10, =0x496f7d35
ldr r11, =0x000000ff
ldr r12, =0xe74cbc91
ldr r14, =0x00000020
teq r2, r3
movs r7, r3, lsl #30
mvnmi r6, r5, lsl r9
sbcs r0, r14, #0x36400
subsvc r1, r9, r11, asr #24
cmp r1, r5
teq r4, r4, asr r11
ldr sp, =0x1340
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r0, =0x7ffffffe
ldr r1, =0xdd4ff747
ldr r2, =0x0000001f
ldr r3, =0x00000001
ldr r4, =0x9eb70740
ldr r5, =0xffffffff
ldr r6, =0xd0685cd1
ldr r7, =0x00000000
ldr r8, =0xef86d491
ldr r9, =0x00000101
ldr r10, =0x6bd96276
ldr r11, =0x0000ffff
ldr r12, =0x8fa78648
ldr r14, =0x12345678
tst r10, r5
adcs r11, r8, r7, asr r5
ands r12, r10, r4, ror #6
cmnge r4, r0, ror r9
sbcs r14, r2, r8, asr #14
ldr sp, =0x1380
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r0, =0xe87f6d67
ldr r1, =0x00000002
ldr r2, =0x12345678
ldr r3, =0x00000000
ldr r4, =0x000000ff
ldr r5, =0x0000001f
ldr r6, =0x03127d24
ldr r7, =0x56f458e9
ldr r8, =0xcafebabe
ldr r9, =0x7fffffff
ldr r10, =0x80000000
ldr r11, =0x2817635e
ldr r12, =0x37653b0c
ldr r14, =0x00000001
cmn r11, r9
mvn r9, #0xd100000
rsble r14, r5, #0x37800000
mvn r12, #0x324
tst r10, r10, asr r7
movvc r5, r5
sub r10, r8, r3, ror #23
ldr sp, =0x13c0
str r0, [sp, #0]
str r1, [sp, #4]
str r2, [sp, #8]
str r3, [sp, #12]
str r4, [sp, #16]
str r5, [sp, #20]
str r6, [sp, #24]
str r7, [sp, #28]
str r8, [sp, #32]
str r9, [sp, #36]
str r10, [sp, #40]
str r11, [sp, #44]
str r12, [sp, #48]
str lr, [sp, #52]
mov r0, #0
orrmi r0, r0, #8
orreq r0, r0, #4
orrcs r0, r0, #2
orrvs r0, r0, #1
str r0, [sp, #56]
mov lr, #0
ldr r12,=0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
