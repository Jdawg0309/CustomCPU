.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000020
str r0, [r12, #0]
ldr r0, =0x00000002
str r0, [r12, #4]
ldr r0, =0x7ffffffe
str r0, [r12, #8]
ldr r0, =0x173393c9
str r0, [r12, #12]
ldr r0, =0x0000001f
str r0, [r12, #16]
ldr r0, =0x000000ff
str r0, [r12, #20]
ldr r0, =0x00000020
str r0, [r12, #24]
ldr r0, =0x00000100
str r0, [r12, #28]
ldr r0, =0x4423602d
str r0, [r12, #32]
ldr r0, =0x17563b16
str r0, [r12, #36]
ldr r0, =0x00000021
str r0, [r12, #40]
ldr r0, =0x7ffffffe
str r0, [r12, #44]
ldr r0, =0xacbab601
str r0, [r12, #48]
ldr r0, =0x5959a352
str r0, [r12, #52]
ldr r0, =0x7c020eab
str r0, [r12, #56]
ldr r0, =0x1c8f2250
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0x80000001
ldr r2, =0x00000002
ldr r3, =0x6eb8d37f
ldr r4, =0x7ffffffe
ldr r5, =0xb6ec0636
ldr r6, =0xd6762b78
ldr r7, =0x78bfae9e
ldr r8, =0x0a871fd5
ldr r9, =0x80000000
ldr r10, =0x00000000
ldr r11, =0xfb19a154
ldr r12, =0x803ecd40
ldr r14, =0x39bc6b43
cmn r3, r5
movcc r0, #187
movgt r1, #80
movpl r2, #167
movcc r3, #7
movle r4, #1
movne r5, #179
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
ldr r0, =0x85ef82dd
ldr r1, =0x00000002
ldr r2, =0x7ffffffe
ldr r3, =0x0000ffff
ldr r4, =0xc12f2325
ldr r5, =0x80000001
ldr r6, =0x00000020
ldr r7, =0x99191a8a
ldr r8, =0x191b272c
ldr r9, =0x3bd1724f
ldr r10, =0x20840510
ldr r11, =0xd99eef65
ldr r12, =0x80000000
ldr r14, =0xf8c6fa21
cmn r9, r3
movvc r0, #29
movgt r1, #70
movhi r2, #136
moveq r3, #118
movmi r4, #164
movvs r5, #30
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
ldr r0, =0x80000001
ldr r1, =0x12345678
ldr r2, =0x13a335c0
ldr r3, =0xc4d33474
ldr r4, =0xffffffff
ldr r5, =0x62fd4269
ldr r6, =0x00000100
ldr r7, =0x000000ff
ldr r8, =0xa8b6d2de
ldr r9, =0x3fdb0d73
ldr r10, =0x885d3d4a
ldr r11, =0xe7ed1efc
ldr r12, =0x0b64c780
ldr r14, =0xa2e634cd
cmn r12, r0
moveq r0, #16
movcc r1, #42
movpl r2, #25
movvs r3, #48
movvc r4, #94
movhi r5, #178
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
ldr r0, =0xe2abfd08
ldr r1, =0xe81734be
ldr r2, =0x48400459
ldr r3, =0x92726504
ldr r4, =0xd3bf9b1d
ldr r5, =0x9dae6615
ldr r6, =0x66af17ef
ldr r7, =0x000000ff
ldr r8, =0x287ba2b7
ldr r9, =0x0000ffff
ldr r10, =0x80000001
ldr r11, =0xf4246ebc
ldr r12, =0x6a34f8f4
ldr r14, =0x92fd3d1c
cmn r14, r7
movle r0, #42
movlt r1, #65
movne r2, #160
movle r3, #24
movmi r4, #101
movhi r5, #169
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
ldr r1, =0xc6f53c30
ldr r2, =0x2887f9c6
ldr r3, =0x00000021
ldr r4, =0xa4ce886e
ldr r5, =0x657e0295
ldr r6, =0x00000101
ldr r7, =0x603eb0de
ldr r8, =0x80000000
ldr r9, =0x6482f7fa
ldr r10, =0x80000000
ldr r11, =0x6ed008e4
ldr r12, =0x078d76de
ldr r14, =0x00000002
tst r9, r14
movle r0, #141
movmi r1, #77
movvs r2, #198
movls r3, #79
movpl r4, #69
movpl r5, #99
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
ldr r0, =0x68b97741
ldr r1, =0x3840c37c
ldr r2, =0x00000020
ldr r3, =0x7ffffffe
ldr r4, =0x7fffffff
ldr r5, =0x00000100
ldr r6, =0x8cf259d5
ldr r7, =0x69a37997
ldr r8, =0xd87c8dee
ldr r9, =0x00000000
ldr r10, =0x00000001
ldr r11, =0x48f56770
ldr r12, =0x67d29715
ldr r14, =0x12345678
cmn r8, r3
movge r0, #26
movgt r1, #53
movcs r2, #1
movge r3, #186
movne r4, #193
movlt r5, #99
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
ldr r0, =0xceac26bc
ldr r1, =0x80000001
ldr r2, =0x7fffffff
ldr r3, =0x141e77fd
ldr r4, =0x16ac5a41
ldr r5, =0xe5a6f80f
ldr r6, =0x00e2972c
ldr r7, =0xd8f90236
ldr r8, =0x80000001
ldr r9, =0x00000020
ldr r10, =0xcafebabe
ldr r11, =0x00000021
ldr r12, =0x00000021
ldr r14, =0xc1b15508
cmn r14, r8
movls r0, #140
movvs r1, #51
movvs r2, #182
movlt r3, #102
movgt r4, #106
movne r5, #82
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
ldr r0, =0x00000002
ldr r1, =0xff260ce7
ldr r2, =0x80000001
ldr r3, =0x00000101
ldr r4, =0x779c8c07
ldr r5, =0xd57c903d
ldr r6, =0x00000020
ldr r7, =0x7fffffff
ldr r8, =0xfaf5b6b4
ldr r9, =0x2f9854ef
ldr r10, =0xcafebabe
ldr r11, =0x7fffffff
ldr r12, =0x507e1dd5
ldr r14, =0xab5dd791
tst r10, r12
movlt r0, #75
movpl r1, #154
movpl r2, #138
movvc r3, #24
movlt r4, #29
movls r5, #189
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
