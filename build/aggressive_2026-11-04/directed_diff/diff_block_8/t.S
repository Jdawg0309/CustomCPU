.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x79bad753
str r0, [r12, #0]
ldr r0, =0xecb2133e
str r0, [r12, #4]
ldr r0, =0x00000002
str r0, [r12, #8]
ldr r0, =0x7fffffff
str r0, [r12, #12]
ldr r0, =0xd6880b20
str r0, [r12, #16]
ldr r0, =0x0000ffff
str r0, [r12, #20]
ldr r0, =0x0cff6bf8
str r0, [r12, #24]
ldr r0, =0x00000020
str r0, [r12, #28]
ldr r0, =0xa6042249
str r0, [r12, #32]
ldr r0, =0xc4ec2330
str r0, [r12, #36]
ldr r0, =0x8bb17a9c
str r0, [r12, #40]
ldr r0, =0x7804154a
str r0, [r12, #44]
ldr r0, =0x00000002
str r0, [r12, #48]
ldr r0, =0x00000021
str r0, [r12, #52]
ldr r0, =0x30f4b906
str r0, [r12, #56]
ldr r0, =0x33ae412c
str r0, [r12, #60]
ldr r0, =0x0000001f
ldr r1, =0xffffffff
ldr r2, =0x0bcd687d
ldr r3, =0x20163679
ldr r4, =0x00000021
ldr r5, =0x00000002
ldr r6, =0x12345678
ldr r7, =0xa3b5320f
ldr r8, =0x00000000
ldr r9, =0xb175050c
ldr r10, =0x12345678
ldr r11, =0x0000ffff
ldr r12, =0x000000ff
ldr r14, =0x8fa9da5b
tst r11, r8
ldr r10, =0x1120
stmdbne r10, {r0,r2,r8,lr}
ldr r10, =0x1120
ldmda r10, {r0,r3,r7,r11}
ldr r10, =0x1120
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
ldr r0, =0x05eb6915
ldr r1, =0x13d731b6
ldr r2, =0x1072d90e
ldr r3, =0x0000001f
ldr r4, =0xcafebabe
ldr r5, =0x80000000
ldr r6, =0x12345678
ldr r7, =0x000000ff
ldr r8, =0x7ffffffe
ldr r9, =0x9fd324f6
ldr r10, =0x4564323e
ldr r11, =0x1fb77218
ldr r12, =0x2dbc580b
ldr r14, =0x00000002
cmn r6, r9
ldr r10, =0x1120
ldmib r10!, {r7,r12}
ldr r10, =0x1120
ldmia r10!, {r8}
ldr r10, =0x1120
ldmia r10, {r3}
ldr r10, =0x1120
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
ldr r0, =0xb0d1cbfb
ldr r1, =0x7ffffffe
ldr r2, =0x0e04b502
ldr r3, =0x80000001
ldr r4, =0x00000001
ldr r5, =0xcafebabe
ldr r6, =0x028347b4
ldr r7, =0x0afffd5d
ldr r8, =0xba1d89e3
ldr r9, =0x00000100
ldr r10, =0x00000101
ldr r11, =0xdfc092f2
ldr r12, =0xd2805a3a
ldr r14, =0xa589934e
cmn r6, r2
ldr r10, =0x1120
stmib r10!, {lr}
ldr r10, =0x1120
stmia r10, {r2,r7}
ldr r10, =0x1120
ldmdb r10!, {r0,r5,r7}
ldr r10, =0x1120
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
ldr r0, =0xefa052b9
ldr r1, =0xd240e236
ldr r2, =0xf1028aa4
ldr r3, =0x0000001f
ldr r4, =0x9dcbfee1
ldr r5, =0x37d3369c
ldr r6, =0x0fa0182e
ldr r7, =0x00000021
ldr r8, =0xcafebabe
ldr r9, =0x80000000
ldr r10, =0x00000000
ldr r11, =0x7fffffff
ldr r12, =0xce010a75
ldr r14, =0x09b29b37
cmp r9, r7
ldr r10, =0x1120
ldmda r10!, {r0,r6,lr}
ldr r10, =0x1120
ldmdb r10!, {r1,r6,r7}
ldr r10, =0x1120
stmib r10!, {r1}
ldr r10, =0x1120
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
ldr r0, =0xabed0c66
ldr r1, =0x38180de9
ldr r2, =0x00000002
ldr r3, =0x3111e8e6
ldr r4, =0x5f46a27a
ldr r5, =0x7ffffffe
ldr r6, =0x0000001f
ldr r7, =0x00000000
ldr r8, =0x6d030394
ldr r9, =0x892abf6e
ldr r10, =0xf531959a
ldr r11, =0xe4a8bbcf
ldr r12, =0x80000001
ldr r14, =0xcafebabe
tst r11, r14
ldr r10, =0x1120
ldmdage r10!, {r4,r7,r9}
ldr r10, =0x1120
ldmdb r10!, {r5}
ldr r10, =0x1120
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
ldr r0, =0x53fcfb43
ldr r1, =0xcafebabe
ldr r2, =0x00000100
ldr r3, =0x15edf7d4
ldr r4, =0x00000101
ldr r5, =0x0000ffff
ldr r6, =0x58b7eb75
ldr r7, =0x0000ffff
ldr r8, =0x9db19b31
ldr r9, =0x00000002
ldr r10, =0x00000101
ldr r11, =0x00000020
ldr r12, =0x000000ff
ldr r14, =0x9c654e90
teq r8, r0
ldr r10, =0x1120
stmia r10, {r8}
ldr r10, =0x1120
ldmda r10, {r1,r5,r6,r11,r12}
ldr r10, =0x1120
stmdb r10!, {r1}
ldr r10, =0x1120
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
ldr r0, =0x00000002
ldr r1, =0x00000100
ldr r2, =0x80000001
ldr r3, =0x000000ff
ldr r4, =0xa907c033
ldr r5, =0xfe52a8e4
ldr r6, =0x00000001
ldr r7, =0x16820bce
ldr r8, =0x4c48e31d
ldr r9, =0xee7e8cee
ldr r10, =0x80000001
ldr r11, =0x8016d880
ldr r12, =0x8e846506
ldr r14, =0x7ffffffe
teq r2, r9
ldr r10, =0x1120
stmia r10, {r6}
ldr r10, =0x1120
ldmia r10, {r1,r4,r5,r7,r9}
ldr r10, =0x1120
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
ldr r0, =0xffffffff
ldr r1, =0xa5302da2
ldr r2, =0xff8ee64a
ldr r3, =0x7ffffffe
ldr r4, =0xa1d00970
ldr r5, =0xffffffff
ldr r6, =0x00000100
ldr r7, =0x0000ffff
ldr r8, =0x7fffffff
ldr r9, =0x7ce61804
ldr r10, =0x7fffffff
ldr r11, =0x00000020
ldr r12, =0x00000000
ldr r14, =0xd1e5df39
cmn r12, r10
ldr r10, =0x1120
stmdals r10, {r0,r2,r3,r5,r8}
ldr r10, =0x1120
ldmia r10!, {r0,r7,r8,lr}
ldr r10, =0x1120
ldmibgt r10!, {r1,r4,r5,r9,r11}
ldr r10, =0x1120
ldmda r10!, {r4,r7,r9,r12,lr}
ldr r10, =0x1120
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
