.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xb31d7416
str r0, [r12, #0]
ldr r0, =0x98fa0c09
str r0, [r12, #4]
ldr r0, =0x0000001f
str r0, [r12, #8]
ldr r0, =0x5f1649db
str r0, [r12, #12]
ldr r0, =0x00000020
str r0, [r12, #16]
ldr r0, =0xe0d719a3
str r0, [r12, #20]
ldr r0, =0x80000000
str r0, [r12, #24]
ldr r0, =0x80000001
str r0, [r12, #28]
ldr r0, =0x00000000
str r0, [r12, #32]
ldr r0, =0x2efae46d
str r0, [r12, #36]
ldr r0, =0xfe712459
str r0, [r12, #40]
ldr r0, =0x80000001
str r0, [r12, #44]
ldr r0, =0x9c21543f
str r0, [r12, #48]
ldr r0, =0x83401cdb
str r0, [r12, #52]
ldr r0, =0x000000ff
str r0, [r12, #56]
ldr r0, =0x07cbf1ea
str r0, [r12, #60]
ldr r0, =0x12bca1c8
ldr r1, =0x2b152c36
ldr r2, =0x28b29993
ldr r3, =0x12345678
ldr r4, =0x26a41e9c
ldr r5, =0x000000ff
ldr r6, =0x00000100
ldr r7, =0x55790e89
ldr r8, =0x80000001
ldr r9, =0xdacbe083
ldr r10, =0xa83ea870
ldr r11, =0xffffffff
ldr r12, =0x0000001f
ldr r14, =0xcafebabe
cmn r0, r8
ldr r10, =0x1120
mov r9, #8
str r0, [r10], #16
ldr r10, =0x1120
ldrb r14, [r10, #16]!
ldrh r6, [r10, #2]
ldrhi r14, [r10, #-20]
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
ldr r0, =0x80000001
ldr r1, =0xffffffff
ldr r2, =0x124cda7d
ldr r3, =0xbfce7ce2
ldr r4, =0x00000020
ldr r5, =0xffffffff
ldr r6, =0xd251838e
ldr r7, =0x12345678
ldr r8, =0x0b9c8381
ldr r9, =0x5cad947e
ldr r10, =0x0000ffff
ldr r11, =0x00000020
ldr r12, =0xdb93681c
ldr r14, =0x00000000
teq r7, r5
ldr r10, =0x1120
mov r9, #4
ldrsh r12, [r10, #-8]
ldr r10, =0x1120
ldrhlt r7, [r10, #20]!
str r2, [r10, #20]
ldr r10, =0x1120
ldr r5, [r10], #0
ldr r10, =0x1120
strb r2, [r10], #4
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
ldr r0, =0x8e1a1d12
ldr r1, =0x00000000
ldr r2, =0x00000002
ldr r3, =0xb49b5b07
ldr r4, =0x00000000
ldr r5, =0x80000000
ldr r6, =0xef9ec639
ldr r7, =0x00000020
ldr r8, =0x54b97ad3
ldr r9, =0x00000021
ldr r10, =0x7ffffffe
ldr r11, =0xdf6bcdf5
ldr r12, =0x28607e6a
ldr r14, =0xc2ebbeeb
teq r9, r14
ldr r10, =0x1120
mov r9, #0
ldrh r6, [r10, #-14]
strh r4, [r10], #0
ldrsb r0, [r10], #8
strh r3, [r10], -r9
str r5, [r10, r9]
str r8, [r10], -r9
ldr r10, =0x1120
ldrsbvc r14, [r10, r9]
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
ldr r0, =0xffffffff
ldr r1, =0x0000ffff
ldr r2, =0x00000020
ldr r3, =0x00000100
ldr r4, =0x15af9081
ldr r5, =0xc783229b
ldr r6, =0x0000ffff
ldr r7, =0x00000000
ldr r8, =0xb63108b4
ldr r9, =0x0000ffff
ldr r10, =0x42f248be
ldr r11, =0xab3a32c2
ldr r12, =0x00000101
ldr r14, =0x000000ff
tst r12, r11
ldr r10, =0x1120
mov r9, #0
ldrsb r0, [r10], #0
ldrbne r2, [r10, #4]!
str r4, [r10, #-28]
ldrsh r7, [r10, r9]
ldr r10, =0x1120
strgt r7, [r10, -r9]
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
ldr r0, =0x00000000
ldr r1, =0x1b5c9112
ldr r2, =0xffffffff
ldr r3, =0x33a6a719
ldr r4, =0x0000001f
ldr r5, =0x0000001f
ldr r6, =0x759a045c
ldr r7, =0x00000000
ldr r8, =0x00000001
ldr r9, =0x32007b64
ldr r10, =0x0a71ebb2
ldr r11, =0xe722cb64
ldr r12, =0xcc722019
ldr r14, =0x458cf132
tst r0, r9
ldr r10, =0x1120
mov r9, #0
str r12, [r10, #-24]
ldr r10, =0x1120
ldrb r2, [r10], r9
ldr r10, =0x1120
ldrcs r2, [r10, -r9]
str r14, [r10, #0]!
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
ldr r0, =0x0000001f
ldr r1, =0xe5d9c6b8
ldr r2, =0x80000000
ldr r3, =0xfc727c2a
ldr r4, =0xe950b59a
ldr r5, =0x80000000
ldr r6, =0x00000020
ldr r7, =0xc20e5ea2
ldr r8, =0x80000000
ldr r9, =0x00000100
ldr r10, =0x000000ff
ldr r11, =0x00000002
ldr r12, =0x00000000
ldr r14, =0x00000100
tst r9, r5
ldr r10, =0x1120
mov r9, #8
str r14, [r10, r9]
ldrsh r12, [r10, #14]
ldr r10, =0x1120
ldrsbpl r1, [r10, #17]
ldrh r14, [r10, #0]
ldr r10, =0x1120
ldrb r11, [r10, #6]
ldr r10, =0x1120
ldr r12, [r10], -r9
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
ldr r0, =0x00000101
ldr r1, =0xbadb5b91
ldr r2, =0x7ffffffe
ldr r3, =0x0000ffff
ldr r4, =0x00000002
ldr r5, =0x12345678
ldr r6, =0x2b158abc
ldr r7, =0xefb96e4f
ldr r8, =0x9425b7ae
ldr r9, =0x4374a181
ldr r10, =0xa9c06345
ldr r11, =0x12345678
ldr r12, =0x00000000
ldr r14, =0x12345678
tst r12, r10
ldr r10, =0x1120
mov r9, #0
ldrsh r14, [r10, #16]!
ldr r10, =0x1120
str r6, [r10], r9
strb r5, [r10], #4
ldrsbcs r7, [r10, r9]
str r14, [r10, #28]
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
ldr r0, =0x84544b24
ldr r1, =0x0000001f
ldr r2, =0x80000001
ldr r3, =0x0000001f
ldr r4, =0x2b8e80cd
ldr r5, =0xc083a00c
ldr r6, =0x606d5268
ldr r7, =0x10460463
ldr r8, =0x80000001
ldr r9, =0xa8fd3288
ldr r10, =0x90f87bad
ldr r11, =0x80000000
ldr r12, =0xec2a90d6
ldr r14, =0x21670073
cmn r9, r4
ldr r10, =0x1120
mov r9, #0
ldr r0, [r10, -r9]
ldrbne r12, [r10, #-11]
strb r8, [r10, #-0]
ldrsh r14, [r10, #20]!
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
