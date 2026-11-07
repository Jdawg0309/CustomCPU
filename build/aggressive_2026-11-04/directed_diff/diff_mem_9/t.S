.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000000
str r0, [r12, #0]
ldr r0, =0xbb0d7143
str r0, [r12, #4]
ldr r0, =0x3148748a
str r0, [r12, #8]
ldr r0, =0x991aad76
str r0, [r12, #12]
ldr r0, =0x00000001
str r0, [r12, #16]
ldr r0, =0x02b462ad
str r0, [r12, #20]
ldr r0, =0x00000000
str r0, [r12, #24]
ldr r0, =0x1a5db021
str r0, [r12, #28]
ldr r0, =0xe8df713f
str r0, [r12, #32]
ldr r0, =0x525cea8f
str r0, [r12, #36]
ldr r0, =0x9c77b529
str r0, [r12, #40]
ldr r0, =0x12345678
str r0, [r12, #44]
ldr r0, =0x000000ff
str r0, [r12, #48]
ldr r0, =0x37dc8231
str r0, [r12, #52]
ldr r0, =0x7ffffffe
str r0, [r12, #56]
ldr r0, =0x00000002
str r0, [r12, #60]
ldr r0, =0x4d8c6de5
ldr r1, =0x20508688
ldr r2, =0xa51e5c8a
ldr r3, =0x239475d7
ldr r4, =0x00000101
ldr r5, =0x1df523d4
ldr r6, =0x00000000
ldr r7, =0x0a225027
ldr r8, =0x80000001
ldr r9, =0x00000100
ldr r10, =0x80000000
ldr r11, =0x00000020
ldr r12, =0x00000000
ldr r14, =0xa20e1b4a
cmn r0, r11
ldr r10, =0x1120
mov r9, #4
ldrsh r6, [r10, #12]!
ldr r10, =0x1120
ldrsh r6, [r10, #-10]
ldrsb r12, [r10, #-17]
ldr r10, =0x1120
ldrsh r5, [r10, #2]
ldr r8, [r10, #28]
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
ldr r0, =0x74c0be12
ldr r1, =0xcafebabe
ldr r2, =0x0000ffff
ldr r3, =0x195bbbfa
ldr r4, =0xadabfd2c
ldr r5, =0x9a4b64e3
ldr r6, =0xaab6420a
ldr r7, =0x9bc3cf6f
ldr r8, =0xce5a26a5
ldr r9, =0x12b7348a
ldr r10, =0x7fffffff
ldr r11, =0x80000001
ldr r12, =0x50ac2dd4
ldr r14, =0x40dc8296
cmn r14, r6
ldr r10, =0x1120
mov r9, #8
ldrh r5, [r10, #8]!
strh r4, [r10], #4
str r7, [r10, #4]
str r2, [r10], #0
ldrh r12, [r10], #8
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
ldr r0, =0x00000000
ldr r1, =0x124e8a20
ldr r2, =0x9460acd0
ldr r3, =0x00000002
ldr r4, =0xcf348dd2
ldr r5, =0xffffffff
ldr r6, =0x9d6cef64
ldr r7, =0x00000001
ldr r8, =0x000000ff
ldr r9, =0xd10cbdfb
ldr r10, =0x4fd65bc5
ldr r11, =0x80000000
ldr r12, =0x00000020
ldr r14, =0x64e5d08b
cmn r2, r7
ldr r10, =0x1120
mov r9, #4
strle r2, [r10, #8]!
ldrsb r12, [r10], r9
ldr r10, =0x1120
ldrvs r7, [r10], -r9
str r1, [r10, #8]
ldrb r7, [r10, #12]!
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
ldr r0, =0x7fffffff
ldr r1, =0x00000100
ldr r2, =0x1b50710d
ldr r3, =0x00000000
ldr r4, =0x00000002
ldr r5, =0x80000000
ldr r6, =0x00000100
ldr r7, =0x0000001f
ldr r8, =0x4b3d3a48
ldr r9, =0x00c0f0e4
ldr r10, =0x00000021
ldr r11, =0xc9c67309
ldr r12, =0xacb66075
ldr r14, =0xffffffff
teq r9, r10
ldr r10, =0x1120
mov r9, #4
ldrhne r3, [r10], -r9
ldr r10, =0x1120
ldrb r11, [r10], -r9
ldrshpl r1, [r10], #20
ldr r10, =0x1120
strgt r2, [r10, r9]
ldr r5, [r10, -r9]
ldrh r2, [r10, #8]!
str r14, [r10, r9]
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
ldr r0, =0x00000020
ldr r1, =0x12345678
ldr r2, =0x00000100
ldr r3, =0x481cb804
ldr r4, =0x00000101
ldr r5, =0x12345678
ldr r6, =0x00000020
ldr r7, =0x000000ff
ldr r8, =0x000000ff
ldr r9, =0x80000000
ldr r10, =0xc7127073
ldr r11, =0x7ffffffe
ldr r12, =0x5b646e39
ldr r14, =0x00000002
tst r7, r11
ldr r10, =0x1120
mov r9, #12
ldr r5, [r10], #16
strb r5, [r10, #16]!
str r0, [r10, -r9]
ldrsbvc r1, [r10, #16]!
ldrb r4, [r10, #18]
ldrsb r0, [r10, #-19]
ldr r10, =0x1120
ldrsb r8, [r10, #-12]
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
ldr r0, =0xa723d602
ldr r1, =0xa29ab3f8
ldr r2, =0x00000001
ldr r3, =0x0fef5c7f
ldr r4, =0xb7a878b4
ldr r5, =0xaf6b1b0e
ldr r6, =0x34745fa9
ldr r7, =0xf177779a
ldr r8, =0x7ffffffe
ldr r9, =0x5a67a32c
ldr r10, =0x00000000
ldr r11, =0xe1ebb9c5
ldr r12, =0x80000000
ldr r14, =0x262e7dc9
tst r5, r11
ldr r10, =0x1120
mov r9, #8
strgt r12, [r10, r9]
ldr r10, =0x1120
ldr r8, [r10, #-24]
ldr r10, =0x1120
ldrhne r5, [r10, #4]
ldrh r3, [r10, #6]
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
ldr r0, =0x2b6bc5eb
ldr r1, =0xdf2fda22
ldr r2, =0xfc925615
ldr r3, =0xc14a2e85
ldr r4, =0x2e79017b
ldr r5, =0x58c45e8c
ldr r6, =0x80000000
ldr r7, =0x70a82c8f
ldr r8, =0xcfcf1e43
ldr r9, =0xc425dc64
ldr r10, =0x00000100
ldr r11, =0x101a712f
ldr r12, =0x80000000
ldr r14, =0x00000021
tst r12, r0
ldr r10, =0x1120
mov r9, #0
ldrsh r1, [r10, #8]!
ldrb r0, [r10], #0
ldrle r8, [r10, #12]
str r6, [r10, #20]!
ldrsh r1, [r10], -r9
str r2, [r10, #0]
ldrsb r5, [r10, #12]!
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
ldr r0, =0x10499bfb
ldr r1, =0x5bb079e7
ldr r2, =0x00000001
ldr r3, =0x18ebf093
ldr r4, =0x6beb777f
ldr r5, =0x77c43281
ldr r6, =0xd7728a8a
ldr r7, =0x00000002
ldr r8, =0x00000021
ldr r9, =0xe2404897
ldr r10, =0x000000ff
ldr r11, =0xa73dbf24
ldr r12, =0x517c0d69
ldr r14, =0x7ffffffe
cmp r7, r14
ldr r10, =0x1120
mov r9, #12
strh r4, [r10, #0]
ldrb r7, [r10, #7]
strge r1, [r10, #12]
ldr r10, =0x1120
ldrvc r6, [r10, -r9]
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
