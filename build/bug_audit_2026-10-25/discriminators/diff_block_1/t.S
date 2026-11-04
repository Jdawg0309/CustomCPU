.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x7fffffff
str r0, [r12, #0]
ldr r0, =0xffffffff
str r0, [r12, #4]
ldr r0, =0x3ece428e
str r0, [r12, #8]
ldr r0, =0x2c009123
str r0, [r12, #12]
ldr r0, =0x2bf5de14
str r0, [r12, #16]
ldr r0, =0xcb1a4d55
str r0, [r12, #20]
ldr r0, =0x5a1e6351
str r0, [r12, #24]
ldr r0, =0xc83782cc
str r0, [r12, #28]
ldr r0, =0xcafebabe
str r0, [r12, #32]
ldr r0, =0x65c7ee0c
str r0, [r12, #36]
ldr r0, =0x572a6f03
str r0, [r12, #40]
ldr r0, =0xffffffff
str r0, [r12, #44]
ldr r0, =0xcafebabe
str r0, [r12, #48]
ldr r0, =0xcafebabe
str r0, [r12, #52]
ldr r0, =0x80000001
str r0, [r12, #56]
ldr r0, =0xcafebabe
str r0, [r12, #60]
ldr r0, =0x3e6312c1
ldr r1, =0x80000001
ldr r2, =0xd2cd02f3
ldr r3, =0x6fe10ad3
ldr r4, =0x00000020
ldr r5, =0x67169f3e
ldr r6, =0xf603d094
ldr r7, =0x00000001
ldr r8, =0x00000021
ldr r9, =0x8ed92e65
ldr r10, =0x0000ffff
ldr r11, =0x00000021
ldr r12, =0x1bb88710
ldr r14, =0x00000020
cmn r8, r11
ldr r10, =0x1120
stmda r10!, {r3,r6,r12,lr}
ldr r10, =0x1120
stmibhi r10, {r1,r2,r3,r8,r9}
ldr r10, =0x1120
ldmda r10, {r12}
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
ldr r0, =0x00000021
ldr r1, =0xf4f6da10
ldr r2, =0x00000021
ldr r3, =0xe5583fd3
ldr r4, =0x00000001
ldr r5, =0x1aca4960
ldr r6, =0x000000ff
ldr r7, =0xbb8b90b2
ldr r8, =0x80000001
ldr r9, =0x0000001f
ldr r10, =0x54aae21b
ldr r11, =0x421fb062
ldr r12, =0x0000ffff
ldr r14, =0x41fe1b3c
cmp r11, r2
ldr r10, =0x1120
ldmda r10, {r5}
ldr r10, =0x1120
stmdble r10, {r0}
ldr r10, =0x1120
ldmia r10!, {r2,r4,r9}
ldr r10, =0x1120
ldmib r10, {r0,r9,lr}
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
ldr r0, =0x7fffffff
ldr r1, =0x12345678
ldr r2, =0x18e242c3
ldr r3, =0x8093d1ad
ldr r4, =0x0000001f
ldr r5, =0x7443e4ab
ldr r6, =0x000000ff
ldr r7, =0x7ffffffe
ldr r8, =0x2e25c201
ldr r9, =0xb9d7bc43
ldr r10, =0xcafebabe
ldr r11, =0x00000101
ldr r12, =0x7fffffff
ldr r14, =0x53337681
tst r10, r5
ldr r10, =0x1120
stmia r10, {r0,r3,r6,r8}
ldr r10, =0x1120
stmia r10, {r2,r6,r7,r8,r12}
ldr r10, =0x1120
stmda r10, {r0,r2,r3,r4}
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
ldr r0, =0x6a6fe531
ldr r1, =0x00000100
ldr r2, =0x06af9292
ldr r3, =0xcafebabe
ldr r4, =0x00000020
ldr r5, =0x5fea2d91
ldr r6, =0x9667d929
ldr r7, =0x28837657
ldr r8, =0x259cdd83
ldr r9, =0x94c2f80b
ldr r10, =0x12345678
ldr r11, =0x80000000
ldr r12, =0x9acf6662
ldr r14, =0xb5ce3cf5
cmn r10, r9
ldr r10, =0x1120
stmiage r10!, {r0,r2,r11}
ldr r10, =0x1120
ldmda r10!, {r0,r1,r2,r4,r11}
ldr r10, =0x1120
ldmib r10, {r4,r5,r7,r8,r11}
ldr r10, =0x1120
ldmdb r10!, {r4}
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
ldr r0, =0x00000100
ldr r1, =0x00116a6c
ldr r2, =0x0000001f
ldr r3, =0xb424f3b3
ldr r4, =0x00000020
ldr r5, =0x7fffffff
ldr r6, =0x00000100
ldr r7, =0x461a2269
ldr r8, =0xf61cfe17
ldr r9, =0x00000001
ldr r10, =0x12345678
ldr r11, =0x7fffffff
ldr r12, =0x00000100
ldr r14, =0x55e85a86
tst r2, r11
ldr r10, =0x1120
ldmdb r10!, {r0,r12,lr}
ldr r10, =0x1120
ldmib r10!, {r0,r6,r8,r11}
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
ldr r0, =0x00000020
ldr r1, =0x00000020
ldr r2, =0xff0f581c
ldr r3, =0x7ffffffe
ldr r4, =0xffffffff
ldr r5, =0x3f13147c
ldr r6, =0x0000ffff
ldr r7, =0x80000001
ldr r8, =0x80000001
ldr r9, =0x00000001
ldr r10, =0x0000001f
ldr r11, =0xffffffff
ldr r12, =0x00000101
ldr r14, =0xb3d06291
cmp r10, r9
ldr r10, =0x1120
stmdb r10!, {r0,r5,r6,r11}
ldr r10, =0x1120
ldmdb r10!, {r5}
ldr r10, =0x1120
ldmib r10!, {r2,r8,r11,lr}
ldr r10, =0x1120
stmdb r10!, {r3,r5}
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
ldr r0, =0x7fffffff
ldr r1, =0x55d18c5c
ldr r2, =0x00000100
ldr r3, =0x368006c3
ldr r4, =0x0000001f
ldr r5, =0x00000000
ldr r6, =0x0000001f
ldr r7, =0x54022b69
ldr r8, =0x00000020
ldr r9, =0xf7b7c383
ldr r10, =0x362c403e
ldr r11, =0x8a288dd4
ldr r12, =0x00000101
ldr r14, =0x80000001
cmn r11, r8
ldr r10, =0x1120
stmib r10!, {r0,r1,r2,r4,r5}
ldr r10, =0x1120
ldmdbge r10, {r0,r6,r7,r9,lr}
ldr r10, =0x1120
ldmdb r10!, {r4,r5,r6,r7,r12}
ldr r10, =0x1120
stmdb r10!, {r0,r3,r4,lr}
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
ldr r0, =0xf880eb88
ldr r1, =0x1a3e4a2b
ldr r2, =0x00000020
ldr r3, =0x12345678
ldr r4, =0x00000002
ldr r5, =0x00000100
ldr r6, =0x0396eac9
ldr r7, =0x000000ff
ldr r8, =0xa89b6014
ldr r9, =0x485f7ed8
ldr r10, =0x000000ff
ldr r11, =0x524bc62c
ldr r12, =0x80000000
ldr r14, =0x747bc9d9
cmn r1, r9
ldr r10, =0x1120
ldmda r10, {r1,r3,r6,r9,r11}
ldr r10, =0x1120
stmda r10, {r1,r2,r4,r7,r9}
ldr r10, =0x1120
ldmdane r10!, {r2,r4,r5,r7,r9}
ldr r10, =0x1120
ldmia r10, {r1,r3,r6,r9,r12}
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
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
