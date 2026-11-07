.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x3761c26a
str r0, [r12, #0]
ldr r0, =0x0000ffff
str r0, [r12, #4]
ldr r0, =0xffffffff
str r0, [r12, #8]
ldr r0, =0x00000101
str r0, [r12, #12]
ldr r0, =0xef1cb2ca
str r0, [r12, #16]
ldr r0, =0x00000002
str r0, [r12, #20]
ldr r0, =0x00000101
str r0, [r12, #24]
ldr r0, =0xd78ada14
str r0, [r12, #28]
ldr r0, =0x00000100
str r0, [r12, #32]
ldr r0, =0xcb2cc71d
str r0, [r12, #36]
ldr r0, =0x511e9488
str r0, [r12, #40]
ldr r0, =0xffffffff
str r0, [r12, #44]
ldr r0, =0xfbb11f3c
str r0, [r12, #48]
ldr r0, =0x4f43177a
str r0, [r12, #52]
ldr r0, =0x2cd6f8a8
str r0, [r12, #56]
ldr r0, =0x0000ffff
str r0, [r12, #60]
ldr r0, =0x6828083d
ldr r1, =0x5566e3b9
ldr r2, =0x7ffffffe
ldr r3, =0xcafebabe
ldr r4, =0x9f0a2a5d
ldr r5, =0x000000ff
ldr r6, =0x0000ffff
ldr r7, =0xba99179d
ldr r8, =0x0000ffff
ldr r9, =0xedeab66d
ldr r10, =0x0000001f
ldr r11, =0x1db2c877
ldr r12, =0x7ffffffe
ldr r14, =0x00000002
cmn r0, r6
ldr r10, =0x1120
ldmdb r10, {r0,r4,r5,r12}
ldr r10, =0x1120
stmdage r10!, {r1}
ldr r10, =0x1120
stmib r10!, {r7,lr}
ldr r10, =0x1120
ldmia r10!, {r8,r9}
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
ldr r0, =0xcafebabe
ldr r1, =0x81075554
ldr r2, =0x12345678
ldr r3, =0x61d7676f
ldr r4, =0x00000020
ldr r5, =0x0000001f
ldr r6, =0x80000000
ldr r7, =0xe40b4cd1
ldr r8, =0x7ffffffe
ldr r9, =0x0000ffff
ldr r10, =0x00000002
ldr r11, =0x12345678
ldr r12, =0x900e2813
ldr r14, =0x00000001
tst r3, r8
ldr r10, =0x1120
ldmia r10, {r8,lr}
ldr r10, =0x1120
ldmib r10, {r2,r7,r8}
ldr r10, =0x1120
stmdb r10!, {r2,r4,r9,r11}
ldr r10, =0x1120
stmda r10, {r0,r2,r4,r8,r9}
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
ldr r0, =0x7ffffffe
ldr r1, =0x7ffffffe
ldr r2, =0x45186474
ldr r3, =0x00000101
ldr r4, =0x50cba17e
ldr r5, =0xba4ec8af
ldr r6, =0x1ca0c96d
ldr r7, =0x041306c4
ldr r8, =0x0000ffff
ldr r9, =0x730f8607
ldr r10, =0x13b29f77
ldr r11, =0x705c6fb0
ldr r12, =0xbbf49189
ldr r14, =0x6000fa00
tst r7, r2
ldr r10, =0x1120
ldmdb r10, {r4,r8,r11}
ldr r10, =0x1120
stmda r10!, {r3,lr}
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
ldr r0, =0x7ffffffe
ldr r1, =0x00000002
ldr r2, =0x4e3e7188
ldr r3, =0xb3e3cce3
ldr r4, =0x00000021
ldr r5, =0x80000001
ldr r6, =0x80000001
ldr r7, =0x4710e14a
ldr r8, =0x12345678
ldr r9, =0x0000ffff
ldr r10, =0x050d9964
ldr r11, =0x0000ffff
ldr r12, =0x00000021
ldr r14, =0x12345678
teq r11, r3
ldr r10, =0x1120
stmia r10!, {r7,r11,lr}
ldr r10, =0x1120
stmib r10, {r1}
ldr r10, =0x1120
stmib r10!, {r0,r4,r5,r6}
ldr r10, =0x1120
ldmdb r10, {r4}
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
ldr r0, =0x1f8acfc7
ldr r1, =0x5f7c7f2a
ldr r2, =0x00000002
ldr r3, =0x6c64f65a
ldr r4, =0x000000ff
ldr r5, =0x0695f105
ldr r6, =0x587046eb
ldr r7, =0x1d9c4f6c
ldr r8, =0x16cb3829
ldr r9, =0x00000000
ldr r10, =0x80000000
ldr r11, =0x56733221
ldr r12, =0x000000ff
ldr r14, =0x31ef0dd1
tst r14, r9
ldr r10, =0x1120
ldmib r10, {r1,r3,r8,lr}
ldr r10, =0x1120
stmib r10, {r0,r6}
ldr r10, =0x1120
stmda r10!, {r0,r1,r9,r12,lr}
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
ldr r0, =0xcafebabe
ldr r1, =0x04cb0744
ldr r2, =0x1a39ccdf
ldr r3, =0xd99a185f
ldr r4, =0x43be892c
ldr r5, =0x80000000
ldr r6, =0x00000021
ldr r7, =0x0000ffff
ldr r8, =0x00000101
ldr r9, =0x75e519b8
ldr r10, =0x838e60b9
ldr r11, =0x7af11b49
ldr r12, =0x5656d6d7
ldr r14, =0x47d0a8ea
teq r0, r0
ldr r10, =0x1120
ldmia r10!, {r2,r4,r7,r8,lr}
ldr r10, =0x1120
ldmia r10, {r2,r4,r5,r12,lr}
ldr r10, =0x1120
stmia r10, {r11}
ldr r10, =0x1120
stmda r10!, {r4}
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
ldr r0, =0x0d97b623
ldr r1, =0x9b991f67
ldr r2, =0x0000ffff
ldr r3, =0x00000000
ldr r4, =0x02d0f65e
ldr r5, =0x98a39701
ldr r6, =0xe27f4d89
ldr r7, =0x7ffffffe
ldr r8, =0x00000100
ldr r9, =0xc684fa01
ldr r10, =0x00000021
ldr r11, =0x00000020
ldr r12, =0xd82f4f07
ldr r14, =0x37c3fb04
cmp r8, r7
ldr r10, =0x1120
stmdb r10!, {r1,r6,lr}
ldr r10, =0x1120
ldmda r10!, {r2,r9}
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
ldr r0, =0x00000021
ldr r1, =0x39d3bbd1
ldr r2, =0x6834482a
ldr r3, =0x890bcb20
ldr r4, =0x38ff64af
ldr r5, =0x5d060ba7
ldr r6, =0x7fffffff
ldr r7, =0x128df6ee
ldr r8, =0x0000001f
ldr r9, =0x00000100
ldr r10, =0x80000000
ldr r11, =0x5c2c05df
ldr r12, =0x00000002
ldr r14, =0x4cb1d9f7
cmp r11, r0
ldr r10, =0x1120
ldmdb r10!, {r4,r11,lr}
ldr r10, =0x1120
ldmib r10, {r4,r7,r8,r12}
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
