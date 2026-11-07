.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xb53076f6
str r0, [r12, #0]
ldr r0, =0x00000001
str r0, [r12, #4]
ldr r0, =0x80000001
str r0, [r12, #8]
ldr r0, =0x000000ff
str r0, [r12, #12]
ldr r0, =0x53adbd31
str r0, [r12, #16]
ldr r0, =0x32d9145a
str r0, [r12, #20]
ldr r0, =0x00000002
str r0, [r12, #24]
ldr r0, =0x00000101
str r0, [r12, #28]
ldr r0, =0x00000021
str r0, [r12, #32]
ldr r0, =0x89de2cd8
str r0, [r12, #36]
ldr r0, =0xd160b684
str r0, [r12, #40]
ldr r0, =0x1cd838cf
str r0, [r12, #44]
ldr r0, =0x4c83cb77
str r0, [r12, #48]
ldr r0, =0x00000101
str r0, [r12, #52]
ldr r0, =0x80000001
str r0, [r12, #56]
ldr r0, =0xf4600d5e
str r0, [r12, #60]
ldr r0, =0x00000000
ldr r1, =0xd60588f3
ldr r2, =0x6d8c7596
ldr r3, =0x00000101
ldr r4, =0x00000100
ldr r5, =0x2baa1a8a
ldr r6, =0x00000100
ldr r7, =0x00000002
ldr r8, =0xabd86c43
ldr r9, =0xcafebabe
ldr r10, =0xe90cd34b
ldr r11, =0xc179e2b3
ldr r12, =0x12345678
ldr r14, =0x80000000
teq r2, r1
ldr r10, =0x1120
mov r9, #0
str r6, [r10, #28]
ldrsb r3, [r10, #-12]
ldrb r14, [r10, #4]!
ldrbvc r6, [r10], -r9
ldr r10, =0x1120
ldrsb r6, [r10, #14]
ldr r8, [r10, #12]
ldrsh r14, [r10], -r9
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
ldr r0, =0x48736500
ldr r1, =0x657a3728
ldr r2, =0x6382c2a6
ldr r3, =0x0000ffff
ldr r4, =0x13ba03a0
ldr r5, =0x12345678
ldr r6, =0xdb8fde3b
ldr r7, =0x00000021
ldr r8, =0xe9c077bd
ldr r9, =0x00000002
ldr r10, =0x2c3925db
ldr r11, =0x00000101
ldr r12, =0x0dbb309c
ldr r14, =0x9f506ac5
teq r6, r7
ldr r10, =0x1120
mov r9, #12
ldrsbpl r12, [r10, r9]
ldrsb r6, [r10, #-15]
ldr r6, [r10], r9
ldr r6, [r10], r9
ldrsh r4, [r10, #-0]
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
ldr r0, =0x0000ffff
ldr r1, =0x0000ffff
ldr r2, =0x00000021
ldr r3, =0x12345678
ldr r4, =0x4d2b9888
ldr r5, =0x883dbe60
ldr r6, =0x00000000
ldr r7, =0xef952dd4
ldr r8, =0x25a7ca64
ldr r9, =0x00000021
ldr r10, =0xb864a8b8
ldr r11, =0xffffffff
ldr r12, =0x703ded6c
ldr r14, =0x7ffffffe
tst r2, r1
ldr r10, =0x1120
mov r9, #4
ldrsh r11, [r10, #-8]
ldr r10, =0x1120
ldrb r0, [r10, #-19]
ldrh r2, [r10, #-0]
ldr r10, =0x1120
strh r0, [r10, #8]!
ldr r10, =0x1120
ldrsbvs r2, [r10], r9
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
ldr r0, =0x993423f3
ldr r1, =0x000000ff
ldr r2, =0x00000101
ldr r3, =0x00000020
ldr r4, =0x80000001
ldr r5, =0x00000101
ldr r6, =0x8de3d4fa
ldr r7, =0x76c8ccbe
ldr r8, =0x6dc5d726
ldr r9, =0x05a55a1e
ldr r10, =0xc9bcde56
ldr r11, =0x7ffffffe
ldr r12, =0x00000101
ldr r14, =0x9328c851
tst r4, r14
ldr r10, =0x1120
mov r9, #4
ldrh r8, [r10, r9]
ldr r10, =0x1120
ldr r2, [r10, #12]
ldr r8, [r10], -r9
ldrsh r2, [r10, #-4]
ldr r1, [r10, -r9]
ldr r14, [r10], #4
ldr r10, =0x1120
strh r0, [r10], -r9
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
ldr r0, =0xcafebabe
ldr r1, =0x892760da
ldr r2, =0x9488106c
ldr r3, =0x7fffffff
ldr r4, =0x2ac091f2
ldr r5, =0xffffffff
ldr r6, =0x80000000
ldr r7, =0x35545d3e
ldr r8, =0x00000001
ldr r9, =0x00000000
ldr r10, =0x66074622
ldr r11, =0xe51cbdcd
ldr r12, =0x80000000
ldr r14, =0x856ab328
cmp r5, r11
ldr r10, =0x1120
mov r9, #12
ldrh r12, [r10, #8]!
strb r3, [r10, #0]!
ldr r10, =0x1120
ldr r11, [r10], -r9
ldr r10, =0x1120
str r4, [r10], -r9
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
ldr r0, =0x7fffffff
ldr r1, =0x70acd29d
ldr r2, =0xcba45375
ldr r3, =0x3190c9a3
ldr r4, =0x593384ac
ldr r5, =0xfd5d2ea9
ldr r6, =0x6ca741f3
ldr r7, =0x00000002
ldr r8, =0x0000ffff
ldr r9, =0x67303fb8
ldr r10, =0x00000021
ldr r11, =0xf2ce72a0
ldr r12, =0x481dc79f
ldr r14, =0xee5816bf
teq r4, r3
ldr r10, =0x1120
mov r9, #4
ldrsb r2, [r10, -r9]
str r4, [r10, #12]!
ldrsh r1, [r10, r9]
ldrsh r1, [r10, #20]!
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
ldr r0, =0x00000101
ldr r1, =0x43c694b3
ldr r2, =0x12345678
ldr r3, =0x1069db4a
ldr r4, =0xc662ea51
ldr r5, =0xcafebabe
ldr r6, =0x4cd2b03f
ldr r7, =0xfb16eed0
ldr r8, =0x00000100
ldr r9, =0x12345678
ldr r10, =0x57c0cd6a
ldr r11, =0x00000002
ldr r12, =0x0000001f
ldr r14, =0x4235f604
tst r14, r11
ldr r10, =0x1120
mov r9, #4
strb r14, [r10, #-11]
ldr r10, =0x1120
strhhi r8, [r10, #4]!
ldrb r8, [r10, -r9]
ldrshge r3, [r10, #-0]
ldr r10, =0x1120
ldr r3, [r10, #-24]
ldrshcs r1, [r10], r9
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
ldr r0, =0x920e3be1
ldr r1, =0x00000100
ldr r2, =0x7ffffffe
ldr r3, =0x0111aa21
ldr r4, =0x00000101
ldr r5, =0x80000001
ldr r6, =0x00000021
ldr r7, =0xcafebabe
ldr r8, =0x3fc0d1e3
ldr r9, =0x00000000
ldr r10, =0x7fffffff
ldr r11, =0x12345678
ldr r12, =0x5cd13712
ldr r14, =0xff77fa04
cmp r6, r8
ldr r10, =0x1120
mov r9, #8
ldrh r0, [r10, #4]!
ldrsheq r4, [r10], #4
ldrsh r3, [r10, #2]
strh r5, [r10], r9
ldr r8, [r10, #4]!
ldr r8, [r10, #0]
strb r0, [r10, #4]!
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
