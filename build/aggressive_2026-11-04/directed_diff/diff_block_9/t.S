.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000100
str r0, [r12, #0]
ldr r0, =0x00000020
str r0, [r12, #4]
ldr r0, =0x019c6b0a
str r0, [r12, #8]
ldr r0, =0x94f6dc93
str r0, [r12, #12]
ldr r0, =0x8fc1df17
str r0, [r12, #16]
ldr r0, =0xe84bb7c1
str r0, [r12, #20]
ldr r0, =0x80000001
str r0, [r12, #24]
ldr r0, =0x28790424
str r0, [r12, #28]
ldr r0, =0xe232cb5b
str r0, [r12, #32]
ldr r0, =0x3dc4d8a8
str r0, [r12, #36]
ldr r0, =0xbc1e70b9
str r0, [r12, #40]
ldr r0, =0x00000021
str r0, [r12, #44]
ldr r0, =0x28d856ad
str r0, [r12, #48]
ldr r0, =0x00000101
str r0, [r12, #52]
ldr r0, =0x80000000
str r0, [r12, #56]
ldr r0, =0xa8e5362c
str r0, [r12, #60]
ldr r0, =0x7ffffffe
ldr r1, =0x00000020
ldr r2, =0x076d57ae
ldr r3, =0xab7a1f07
ldr r4, =0x11c28a1b
ldr r5, =0xd3018b08
ldr r6, =0x4038ea0e
ldr r7, =0xe25e05b6
ldr r8, =0x98110545
ldr r9, =0x80000001
ldr r10, =0xcafebabe
ldr r11, =0xe9e6e34d
ldr r12, =0x83042590
ldr r14, =0x5e331c29
cmp r3, r6
ldr r10, =0x1120
ldmia r10, {r1,r2,r5,r11,r12}
ldr r10, =0x1120
ldmia r10, {r1,r3,r11}
ldr r10, =0x1120
ldmia r10, {r0,r6,r7}
ldr r10, =0x1120
ldmdb r10, {r0,r9,r11,r12}
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
ldr r0, =0x00000101
ldr r1, =0x0ba94681
ldr r2, =0xd85c49f9
ldr r3, =0x80000001
ldr r4, =0x80000001
ldr r5, =0x00000000
ldr r6, =0x80000000
ldr r7, =0xca394945
ldr r8, =0x7ffffffe
ldr r9, =0xcafebabe
ldr r10, =0x00000001
ldr r11, =0x48b12544
ldr r12, =0x8b1f302a
ldr r14, =0x12345678
teq r10, r10
ldr r10, =0x1120
stmdbgt r10, {r0,r2,lr}
ldr r10, =0x1120
stmib r10!, {r6}
ldr r10, =0x1120
ldmia r10, {r6,r7}
ldr r10, =0x1120
ldmials r10!, {r4,r11,lr}
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
ldr r0, =0xae81995c
ldr r1, =0xa024c9f9
ldr r2, =0x6e7a3d5d
ldr r3, =0xa411d45d
ldr r4, =0x12345678
ldr r5, =0x000000ff
ldr r6, =0x9c107a43
ldr r7, =0x12345678
ldr r8, =0x0000001f
ldr r9, =0x00000020
ldr r10, =0xcafebabe
ldr r11, =0xd67f6113
ldr r12, =0x323257db
ldr r14, =0x3d38d92c
cmp r3, r4
ldr r10, =0x1120
stmda r10!, {r2,r6,r8,r11}
ldr r10, =0x1120
stmiapl r10, {r1,r5,r6,r7,lr}
ldr r10, =0x1120
stmda r10!, {r6,r12,lr}
ldr r10, =0x1120
ldmda r10, {r2,r6,r12}
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
ldr r0, =0x002fc697
ldr r1, =0x8c59eefa
ldr r2, =0x03b98c86
ldr r3, =0x4a812c06
ldr r4, =0x12345678
ldr r5, =0x00000000
ldr r6, =0xf4f08b92
ldr r7, =0x9221f290
ldr r8, =0x80000000
ldr r9, =0x465cfda3
ldr r10, =0x00000100
ldr r11, =0x00000000
ldr r12, =0x00000001
ldr r14, =0x00000021
teq r5, r1
ldr r10, =0x1120
ldmib r10!, {r8}
ldr r10, =0x1120
stmdb r10!, {r8}
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
ldr r0, =0xe8a47255
ldr r1, =0x1a8d7315
ldr r2, =0x9e3fa38a
ldr r3, =0x39954c8c
ldr r4, =0x20f6770d
ldr r5, =0x000000ff
ldr r6, =0x5938b015
ldr r7, =0x55c6c051
ldr r8, =0x2ffe0a2d
ldr r9, =0x00000002
ldr r10, =0x12345678
ldr r11, =0x000000ff
ldr r12, =0xffffffff
ldr r14, =0xffffffff
cmp r7, r3
ldr r10, =0x1120
ldmda r10, {r2,r4,r6,r11}
ldr r10, =0x1120
ldmda r10!, {r1,r5,r7}
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
ldr r1, =0x0000ffff
ldr r2, =0xffffffff
ldr r3, =0x2903ac59
ldr r4, =0x80000001
ldr r5, =0xbcf19eac
ldr r6, =0x7fffffff
ldr r7, =0x00000002
ldr r8, =0x2d8c3f2c
ldr r9, =0x2fcaad91
ldr r10, =0xcafebabe
ldr r11, =0x7fffffff
ldr r12, =0x00000101
ldr r14, =0x80000001
tst r0, r1
ldr r10, =0x1120
ldmdalt r10, {r4}
ldr r10, =0x1120
stmibgt r10!, {r2,r8}
ldr r10, =0x1120
stmdbge r10, {r2,r7,lr}
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
ldr r0, =0x00000021
ldr r1, =0xd59eab13
ldr r2, =0x25e83d76
ldr r3, =0x00000000
ldr r4, =0x12345678
ldr r5, =0xffffffff
ldr r6, =0x12345678
ldr r7, =0x48e31598
ldr r8, =0x7fffffff
ldr r9, =0x00000020
ldr r10, =0x103a5c37
ldr r11, =0x00000001
ldr r12, =0x54b23c98
ldr r14, =0xfe732aa5
tst r12, r10
ldr r10, =0x1120
stmia r10, {r0,r2,r4,r8,lr}
ldr r10, =0x1120
stmia r10!, {r8}
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
ldr r0, =0xfe6585c5
ldr r1, =0x00000002
ldr r2, =0xf5c6ddf0
ldr r3, =0x00000021
ldr r4, =0xe892fb60
ldr r5, =0x00000020
ldr r6, =0x2ac5ff44
ldr r7, =0x00000021
ldr r8, =0x30a5265b
ldr r9, =0xe0c3a06e
ldr r10, =0xb34a1de1
ldr r11, =0x00000002
ldr r12, =0x4ce1982b
ldr r14, =0x47b159b1
tst r7, r8
ldr r10, =0x1120
ldmib r10!, {r0,r2,r9,r11}
ldr r10, =0x1120
stmib r10!, {r2,r3,r7,r12}
ldr r10, =0x1120
ldmibgt r10!, {r0,r1,r5,r9,r12}
ldr r10, =0x1120
stmia r10, {r5,r11}
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
