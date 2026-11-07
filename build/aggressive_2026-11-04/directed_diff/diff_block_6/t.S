.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xebc8711f
str r0, [r12, #0]
ldr r0, =0x00000020
str r0, [r12, #4]
ldr r0, =0xf4b0c540
str r0, [r12, #8]
ldr r0, =0x546509b1
str r0, [r12, #12]
ldr r0, =0x0000001f
str r0, [r12, #16]
ldr r0, =0x14292753
str r0, [r12, #20]
ldr r0, =0x208720ec
str r0, [r12, #24]
ldr r0, =0xcbd3d95a
str r0, [r12, #28]
ldr r0, =0x00000002
str r0, [r12, #32]
ldr r0, =0x0a78b064
str r0, [r12, #36]
ldr r0, =0x8c8cfaeb
str r0, [r12, #40]
ldr r0, =0xeba817f1
str r0, [r12, #44]
ldr r0, =0x12345678
str r0, [r12, #48]
ldr r0, =0x6fb38e54
str r0, [r12, #52]
ldr r0, =0x12345678
str r0, [r12, #56]
ldr r0, =0x3a52c6dd
str r0, [r12, #60]
ldr r0, =0x94008c6e
ldr r1, =0x7fffffff
ldr r2, =0xf54f8772
ldr r3, =0xe9690369
ldr r4, =0xffffffff
ldr r5, =0xa75f5494
ldr r6, =0x7e4e54dd
ldr r7, =0x3f971577
ldr r8, =0x00000020
ldr r9, =0x12345678
ldr r10, =0xad60a2a8
ldr r11, =0x00000000
ldr r12, =0xffffffff
ldr r14, =0xcafebabe
teq r4, r5
ldr r10, =0x1120
ldmdb r10, {r0,r6,r7,r11,lr}
ldr r10, =0x1120
ldmdb r10!, {r0,r5,lr}
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
ldr r0, =0x39727371
ldr r1, =0x7ffffffe
ldr r2, =0x12345678
ldr r3, =0x12345678
ldr r4, =0x00000001
ldr r5, =0x2126421d
ldr r6, =0x6f365da7
ldr r7, =0x25265269
ldr r8, =0x000000ff
ldr r9, =0x000000ff
ldr r10, =0x9b4c09fd
ldr r11, =0x3c60b2a4
ldr r12, =0x80000000
ldr r14, =0x2116a1da
tst r4, r12
ldr r10, =0x1120
ldmdb r10!, {r7,r12}
ldr r10, =0x1120
stmdb r10!, {r0,r4}
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
ldr r0, =0xad23c63b
ldr r1, =0xe102c666
ldr r2, =0x0000ffff
ldr r3, =0x54c6878b
ldr r4, =0x8470432a
ldr r5, =0xe71b498d
ldr r6, =0xf3122a72
ldr r7, =0x00000020
ldr r8, =0x80000001
ldr r9, =0x00000021
ldr r10, =0x0000ffff
ldr r11, =0xce1a0a96
ldr r12, =0x6d572d6f
ldr r14, =0xb8c1a108
tst r9, r8
ldr r10, =0x1120
ldmia r10, {r3,r11}
ldr r10, =0x1120
ldmda r10!, {r4,r5,lr}
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
ldr r0, =0x00000100
ldr r1, =0x74cf3ec4
ldr r2, =0x755674b3
ldr r3, =0x00000101
ldr r4, =0x56a4091d
ldr r5, =0xc7983723
ldr r6, =0xaf637e76
ldr r7, =0x000000ff
ldr r8, =0x0000001f
ldr r9, =0xec14dcd8
ldr r10, =0x80000001
ldr r11, =0x00000101
ldr r12, =0x00000021
ldr r14, =0xc07fceda
tst r11, r14
ldr r10, =0x1120
stmda r10!, {r6,r11}
ldr r10, =0x1120
stmia r10!, {r5,r11}
ldr r10, =0x1120
ldmibcc r10, {r0,r3,r6,r7}
ldr r10, =0x1120
ldmia r10, {r11,r12}
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
ldr r0, =0x80000000
ldr r1, =0x2c2ec6e7
ldr r2, =0xffffffff
ldr r3, =0x1a1b7d7e
ldr r4, =0xffffffff
ldr r5, =0x00000000
ldr r6, =0x00000021
ldr r7, =0x8b8e44b1
ldr r8, =0x80000001
ldr r9, =0xcafebabe
ldr r10, =0x80000000
ldr r11, =0x00000002
ldr r12, =0x9132bcd1
ldr r14, =0xffffffff
cmp r10, r8
ldr r10, =0x1120
ldmdbeq r10, {r4,r7,r12}
ldr r10, =0x1120
stmiale r10, {r6,r7}
ldr r10, =0x1120
ldmia r10, {r0,r8,lr}
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
ldr r0, =0xa55dc39a
ldr r1, =0xf2429d3a
ldr r2, =0x00000001
ldr r3, =0x80000000
ldr r4, =0x12345678
ldr r5, =0x00000021
ldr r6, =0xeef0436f
ldr r7, =0xcafebabe
ldr r8, =0x80000000
ldr r9, =0x9bcd2337
ldr r10, =0x00000101
ldr r11, =0x00000021
ldr r12, =0x0000001f
ldr r14, =0x6c9bf587
cmp r9, r14
ldr r10, =0x1120
ldmiale r10, {r3,r6}
ldr r10, =0x1120
ldmdb r10, {r1,r2,r4}
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
ldr r0, =0x000000ff
ldr r1, =0xbe8bfe0e
ldr r2, =0xe0c8aafd
ldr r3, =0x9d05c6fc
ldr r4, =0x00000021
ldr r5, =0x509df39f
ldr r6, =0x80000001
ldr r7, =0xbb4e5f6b
ldr r8, =0x0f82806a
ldr r9, =0x00000101
ldr r10, =0xcafebabe
ldr r11, =0x7ffffffe
ldr r12, =0x9971e740
ldr r14, =0x9bfd3cdf
tst r5, r10
ldr r10, =0x1120
ldmda r10, {r7,r9,r11,lr}
ldr r10, =0x1120
stmda r10, {r0,r2,r5,r8,r12}
ldr r10, =0x1120
stmdb r10, {lr}
ldr r10, =0x1120
ldmda r10!, {r0,r4,r12}
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
ldr r0, =0x90bb0941
ldr r1, =0x00000002
ldr r2, =0x00000000
ldr r3, =0x00000000
ldr r4, =0x7fffffff
ldr r5, =0x1f892bd2
ldr r6, =0x89720e27
ldr r7, =0x7fffffff
ldr r8, =0xc503ec14
ldr r9, =0x7fffffff
ldr r10, =0x80000000
ldr r11, =0xdbecd62b
ldr r12, =0x37c1dfa4
ldr r14, =0xff200a5f
teq r8, r3
ldr r10, =0x1120
ldmib r10!, {r11}
ldr r10, =0x1120
stmdb r10!, {r1,r5,r7,lr}
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
