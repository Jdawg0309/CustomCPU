.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x9061f33d
str r0, [r12, #0]
ldr r0, =0xb0371929
str r0, [r12, #4]
ldr r0, =0x7ffffffe
str r0, [r12, #8]
ldr r0, =0x8361fdd4
str r0, [r12, #12]
ldr r0, =0x548b4efa
str r0, [r12, #16]
ldr r0, =0x2893e11a
str r0, [r12, #20]
ldr r0, =0x50a0fa96
str r0, [r12, #24]
ldr r0, =0xbd41b35e
str r0, [r12, #28]
ldr r0, =0x7ffffffe
str r0, [r12, #32]
ldr r0, =0x7242d07f
str r0, [r12, #36]
ldr r0, =0x361d79db
str r0, [r12, #40]
ldr r0, =0xffffffff
str r0, [r12, #44]
ldr r0, =0x0000001f
str r0, [r12, #48]
ldr r0, =0x71cb7a33
str r0, [r12, #52]
ldr r0, =0x00000001
str r0, [r12, #56]
ldr r0, =0x00000021
str r0, [r12, #60]
ldr r0, =0x7757838e
ldr r1, =0xcafebabe
ldr r2, =0x247b1e14
ldr r3, =0xedae91ea
ldr r4, =0xf24736ed
ldr r5, =0x00000021
ldr r6, =0x00000002
ldr r7, =0xe16f8ba7
ldr r8, =0x0f72ec5d
ldr r9, =0x82dfae79
ldr r10, =0xde413ce7
ldr r11, =0x828e359f
ldr r12, =0x000000ff
ldr r14, =0x00000002
tst r8, r14
ldr r10, =0x1120
stmdbvs r10!, {r5}
ldr r10, =0x1120
ldmda r10!, {r0,r3,r6,lr}
ldr r10, =0x1120
ldmda r10, {r0,r2,r5,lr}
ldr r10, =0x1120
stmib r10!, {r0,r1,r5,r8,r12}
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
ldr r0, =0x65f33556
ldr r1, =0x00000100
ldr r2, =0x00000100
ldr r3, =0x0000001f
ldr r4, =0xf50ab3f1
ldr r5, =0x9a82d652
ldr r6, =0x00000000
ldr r7, =0x0000ffff
ldr r8, =0x9d217a4e
ldr r9, =0x7fffffff
ldr r10, =0xb191f9f9
ldr r11, =0x00000000
ldr r12, =0xcd6e75fb
ldr r14, =0x000000ff
teq r2, r6
ldr r10, =0x1120
ldmib r10, {r5,r9,r11,lr}
ldr r10, =0x1120
stmia r10!, {r5}
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
ldr r1, =0x0dc1ab19
ldr r2, =0xd395cab7
ldr r3, =0xbf810ad7
ldr r4, =0x0000ffff
ldr r5, =0xcafebabe
ldr r6, =0x00000001
ldr r7, =0xaed36052
ldr r8, =0xffffffff
ldr r9, =0x00000020
ldr r10, =0xffffffff
ldr r11, =0x75980de0
ldr r12, =0x0000ffff
ldr r14, =0x00000002
cmp r12, r9
ldr r10, =0x1120
stmib r10!, {r0,r1,r8}
ldr r10, =0x1120
ldmib r10!, {r3,r6}
ldr r10, =0x1120
ldmib r10!, {r2,r3}
ldr r10, =0x1120
stmda r10, {r3,r9,lr}
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
ldr r1, =0x000000ff
ldr r2, =0x00000100
ldr r3, =0xffffffff
ldr r4, =0x000000ff
ldr r5, =0x0000001f
ldr r6, =0x9e80b3d0
ldr r7, =0xcafebabe
ldr r8, =0x80000001
ldr r9, =0x1e65b616
ldr r10, =0x7fffffff
ldr r11, =0xa7238ae8
ldr r12, =0xfcc06133
ldr r14, =0xffffffff
tst r4, r7
ldr r10, =0x1120
stmia r10!, {r0,r1,r9,lr}
ldr r10, =0x1120
stmib r10, {r0,r1,r9,r11}
ldr r10, =0x1120
stmda r10!, {r3,r4,lr}
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
ldr r0, =0x2bb2209a
ldr r1, =0x1acccf93
ldr r2, =0x122aacf6
ldr r3, =0xc0f2e07b
ldr r4, =0xffffffff
ldr r5, =0xffffffff
ldr r6, =0x80000000
ldr r7, =0xcafebabe
ldr r8, =0x2d02f335
ldr r9, =0x04e12e4e
ldr r10, =0x00000021
ldr r11, =0xe8a573f8
ldr r12, =0xb9e9a85c
ldr r14, =0x00000021
tst r4, r3
ldr r10, =0x1120
ldmdb r10, {r1,r3,r8,lr}
ldr r10, =0x1120
stmda r10, {r2,r4,r12}
ldr r10, =0x1120
ldmia r10!, {r3,r9,lr}
ldr r10, =0x1120
ldmdb r10, {r0,r3,r4,r6}
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
ldr r0, =0x12345678
ldr r1, =0x8ebad5eb
ldr r2, =0x000000ff
ldr r3, =0x0000001f
ldr r4, =0xa38dcad4
ldr r5, =0x46b94072
ldr r6, =0x4129b6df
ldr r7, =0x7fffffff
ldr r8, =0x12345678
ldr r9, =0x000000ff
ldr r10, =0x7ffffffe
ldr r11, =0x2f5678b6
ldr r12, =0x7ffffffe
ldr r14, =0x80000001
tst r14, r8
ldr r10, =0x1120
ldmia r10!, {r0,r1,r9,r12}
ldr r10, =0x1120
stmia r10, {r1,r9,r11}
ldr r10, =0x1120
ldmdb r10, {r3}
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
ldr r0, =0xcafebabe
ldr r1, =0x2ff84211
ldr r2, =0x0000001f
ldr r3, =0xaa21b1c3
ldr r4, =0xf1c43b1e
ldr r5, =0xf16bb3d6
ldr r6, =0x0000ffff
ldr r7, =0xa7924126
ldr r8, =0x00000000
ldr r9, =0x350d24a9
ldr r10, =0x00000001
ldr r11, =0xffffffff
ldr r12, =0x6019b13a
ldr r14, =0x38384ca6
cmp r10, r4
ldr r10, =0x1120
stmda r10!, {r2,r3,r4,r8}
ldr r10, =0x1120
stmibls r10!, {r2,r4,r5,r9,r12}
ldr r10, =0x1120
ldmdavc r10, {r2,r5,r9,r12}
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
ldr r0, =0x0000ffff
ldr r1, =0x00000020
ldr r2, =0x36c8fce2
ldr r3, =0xf70c1a29
ldr r4, =0x00000020
ldr r5, =0x4698f286
ldr r6, =0xe303940c
ldr r7, =0xcafebabe
ldr r8, =0x000000ff
ldr r9, =0xcafebabe
ldr r10, =0x00000001
ldr r11, =0x00000000
ldr r12, =0x0000ffff
ldr r14, =0x00000002
teq r11, r11
ldr r10, =0x1120
ldmdb r10, {r1,r2,r9}
ldr r10, =0x1120
stmda r10!, {r4,r8,r9,lr}
ldr r10, =0x1120
stmda r10, {r0,r9,r12}
ldr r10, =0x1120
stmdb r10!, {r0,r1,r5,r12}
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
