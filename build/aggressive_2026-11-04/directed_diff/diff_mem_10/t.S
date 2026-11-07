.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000100
str r0, [r12, #0]
ldr r0, =0x000000ff
str r0, [r12, #4]
ldr r0, =0xe31531c5
str r0, [r12, #8]
ldr r0, =0x0000001f
str r0, [r12, #12]
ldr r0, =0xe01b5e32
str r0, [r12, #16]
ldr r0, =0x6fbff184
str r0, [r12, #20]
ldr r0, =0xbf4b9feb
str r0, [r12, #24]
ldr r0, =0x0000001f
str r0, [r12, #28]
ldr r0, =0x300bd21e
str r0, [r12, #32]
ldr r0, =0xcafebabe
str r0, [r12, #36]
ldr r0, =0xddcedeb3
str r0, [r12, #40]
ldr r0, =0x00000000
str r0, [r12, #44]
ldr r0, =0x00000002
str r0, [r12, #48]
ldr r0, =0x358a990e
str r0, [r12, #52]
ldr r0, =0x473973bc
str r0, [r12, #56]
ldr r0, =0xffffffff
str r0, [r12, #60]
ldr r0, =0x00000001
ldr r1, =0x0000001f
ldr r2, =0x00000000
ldr r3, =0x647914f7
ldr r4, =0x80000000
ldr r5, =0xffffffff
ldr r6, =0x0000001f
ldr r7, =0xc31d0dc4
ldr r8, =0x00000002
ldr r9, =0x00000101
ldr r10, =0x7ffffffe
ldr r11, =0x20e0f5f9
ldr r12, =0x00000101
ldr r14, =0x167376bf
cmp r14, r2
ldr r10, =0x1120
mov r9, #16
ldrsh r12, [r10, #-6]
str r4, [r10], #20
ldrhne r4, [r10, #0]!
ldrsb r6, [r10, #-12]
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
ldr r1, =0x76b92c1b
ldr r2, =0xacf8d091
ldr r3, =0x53326166
ldr r4, =0xcafebabe
ldr r5, =0xad9e1aab
ldr r6, =0xa62ba46a
ldr r7, =0x80000001
ldr r8, =0x00000020
ldr r9, =0x0000001f
ldr r10, =0x7fffffff
ldr r11, =0x816ecbf5
ldr r12, =0x80000001
ldr r14, =0x00000020
teq r14, r1
ldr r10, =0x1120
mov r9, #0
ldrb r7, [r10, #4]!
str r2, [r10, #0]!
ldr r10, =0x1120
ldrsbls r2, [r10], #12
ldr r10, =0x1120
strh r5, [r10, #0]
strh r12, [r10, #4]
ldr r2, [r10, #20]
ldrhle r7, [r10, #-8]
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
ldr r0, =0xe58d4fac
ldr r1, =0x670d6c52
ldr r2, =0x00000020
ldr r3, =0xa4400166
ldr r4, =0x00000020
ldr r5, =0xde524c1f
ldr r6, =0x7fffffff
ldr r7, =0x85a27e15
ldr r8, =0x7ffffffe
ldr r9, =0x12345678
ldr r10, =0x0000ffff
ldr r11, =0x00000100
ldr r12, =0x16be627d
ldr r14, =0x00000021
teq r12, r12
ldr r10, =0x1120
mov r9, #0
ldr r4, [r10, #12]
str r14, [r10, -r9]
ldrshlt r2, [r10, #-2]
ldrsh r1, [r10], r9
ldrb r0, [r10, #-12]
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
ldr r0, =0x93228011
ldr r1, =0x00000100
ldr r2, =0x2a6ac3f4
ldr r3, =0x0000001f
ldr r4, =0x00000100
ldr r5, =0x4535f4be
ldr r6, =0x2ddf68a4
ldr r7, =0x80000001
ldr r8, =0xac66ed99
ldr r9, =0x80000001
ldr r10, =0x00000020
ldr r11, =0xffffffff
ldr r12, =0x7ffffffe
ldr r14, =0xb323a17a
teq r2, r2
ldr r10, =0x1120
mov r9, #12
str r8, [r10], r9
ldr r10, =0x1120
str r14, [r10, #4]!
ldr r10, =0x1120
ldrsb r2, [r10, #-19]
ldrsb r11, [r10, #3]
ldrhle r4, [r10, -r9]
ldrsb r4, [r10, #12]
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
ldr r0, =0x23c0ee4a
ldr r1, =0xcafebabe
ldr r2, =0x9690e238
ldr r3, =0x12345678
ldr r4, =0x49497508
ldr r5, =0x6b2c017e
ldr r6, =0x0000001f
ldr r7, =0x00000100
ldr r8, =0x7ffffffe
ldr r9, =0x0000001f
ldr r10, =0x9d96fcb2
ldr r11, =0x00000020
ldr r12, =0x000000ff
ldr r14, =0x6309974a
teq r1, r4
ldr r10, =0x1120
mov r9, #16
ldrsb r11, [r10, #5]
ldr r10, =0x1120
strb r1, [r10], #12
strh r2, [r10], #8
ldr r8, [r10, #8]
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
ldr r0, =0xca4661d7
ldr r1, =0x1aa59209
ldr r2, =0x98c5330c
ldr r3, =0xaecde574
ldr r4, =0x00000020
ldr r5, =0xac56e9b2
ldr r6, =0x662f201f
ldr r7, =0xffffffff
ldr r8, =0x00000100
ldr r9, =0x58b1ee8c
ldr r10, =0xf87dc3ac
ldr r11, =0x80000001
ldr r12, =0x0956e078
ldr r14, =0x2f2f78cf
cmn r7, r0
ldr r10, =0x1120
mov r9, #16
ldr r3, [r10, #28]
str r11, [r10], r9
ldr r10, =0x1120
ldrshge r6, [r10], -r9
str r0, [r10, -r9]
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
ldr r1, =0x00000021
ldr r2, =0x00000002
ldr r3, =0x5db4a956
ldr r4, =0x8b968dd6
ldr r5, =0x18674d40
ldr r6, =0x80000001
ldr r7, =0xa16e7b16
ldr r8, =0x11ca98db
ldr r9, =0x12345678
ldr r10, =0x316f75c5
ldr r11, =0x19bd5626
ldr r12, =0x6a2e5391
ldr r14, =0x00000021
cmp r12, r1
ldr r10, =0x1120
mov r9, #8
ldrsb r11, [r10, #-10]
ldr r10, =0x1120
ldrsb r12, [r10], r9
ldr r10, =0x1120
ldrh r0, [r10, -r9]
str r11, [r10], #0
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
ldr r1, =0x10d008c3
ldr r2, =0xee880a43
ldr r3, =0x7ffffffe
ldr r4, =0x80000000
ldr r5, =0x0000ffff
ldr r6, =0x7ffffffe
ldr r7, =0x00000100
ldr r8, =0xd496f33f
ldr r9, =0x00000001
ldr r10, =0x7ffffffe
ldr r11, =0x40e07efc
ldr r12, =0xd756b726
ldr r14, =0x00000001
cmp r6, r7
ldr r10, =0x1120
mov r9, #8
ldrh r14, [r10], #8
ldr r10, =0x1120
ldrsb r12, [r10, #18]
ldrsh r11, [r10, #14]
ldrsb r4, [r10, #-1]
ldrsh r11, [r10, #-12]
str r0, [r10, -r9]
ldrsb r8, [r10, #12]!
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
