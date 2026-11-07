.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x2c417610
str r0, [r12, #0]
ldr r0, =0x7ffffffe
str r0, [r12, #4]
ldr r0, =0x00000020
str r0, [r12, #8]
ldr r0, =0x80000001
str r0, [r12, #12]
ldr r0, =0xc896bf8e
str r0, [r12, #16]
ldr r0, =0x0000001f
str r0, [r12, #20]
ldr r0, =0x7926da4f
str r0, [r12, #24]
ldr r0, =0xbf5305fe
str r0, [r12, #28]
ldr r0, =0x54655244
str r0, [r12, #32]
ldr r0, =0x79d79e5e
str r0, [r12, #36]
ldr r0, =0x12345678
str r0, [r12, #40]
ldr r0, =0x7ffffffe
str r0, [r12, #44]
ldr r0, =0xb89f0739
str r0, [r12, #48]
ldr r0, =0x00000002
str r0, [r12, #52]
ldr r0, =0x000000ff
str r0, [r12, #56]
ldr r0, =0x85cdd37b
str r0, [r12, #60]
ldr r0, =0xbfe3a2b4
ldr r1, =0x9550d48f
ldr r2, =0x000000ff
ldr r3, =0x686afc2d
ldr r4, =0x00000101
ldr r5, =0x3d920081
ldr r6, =0x0dc23575
ldr r7, =0x9c355a6b
ldr r8, =0x00000101
ldr r9, =0x7ffffffe
ldr r10, =0xb09ed493
ldr r11, =0x000000ff
ldr r12, =0x80000001
ldr r14, =0x80000001
teq r8, r1
movgt r0, #191
movne r1, #75
moveq r2, #162
movmi r3, #170
movmi r4, #114
movvc r5, #143
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
ldr r1, =0xa924e39e
ldr r2, =0x00000021
ldr r3, =0x00000101
ldr r4, =0x942ac6e8
ldr r5, =0x00000001
ldr r6, =0x000000ff
ldr r7, =0x00000100
ldr r8, =0x000000ff
ldr r9, =0x00000021
ldr r10, =0x9dffa814
ldr r11, =0x0000001f
ldr r12, =0x0000ffff
ldr r14, =0xa5f6fde2
cmn r7, r10
movle r0, #196
movge r1, #149
movvc r2, #119
movvc r3, #37
movvs r4, #128
movne r5, #186
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
ldr r0, =0x00000002
ldr r1, =0x3e114815
ldr r2, =0x0000001f
ldr r3, =0x00000000
ldr r4, =0x0000001f
ldr r5, =0x00000002
ldr r6, =0x00000100
ldr r7, =0x0000001f
ldr r8, =0x12345678
ldr r9, =0x80000001
ldr r10, =0x27a89712
ldr r11, =0xa709b616
ldr r12, =0x5aa1e728
ldr r14, =0xfcca8f9d
cmp r10, r8
movpl r0, #22
movlt r1, #151
movhi r2, #111
movpl r3, #169
movcs r4, #163
movge r5, #173
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
ldr r0, =0x12345678
ldr r1, =0xcafebabe
ldr r2, =0x00000002
ldr r3, =0x7ffffffe
ldr r4, =0x9ac5dfd1
ldr r5, =0xca89ef12
ldr r6, =0x6f97d9d0
ldr r7, =0x00000101
ldr r8, =0x385742d6
ldr r9, =0x00000020
ldr r10, =0x17b00e1b
ldr r11, =0xb0ed6d99
ldr r12, =0x00000001
ldr r14, =0x00000021
cmp r5, r11
movgt r0, #79
moveq r1, #134
movvc r2, #4
moveq r3, #33
movls r4, #125
movge r5, #167
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
ldr r0, =0x500e6020
ldr r1, =0x00000001
ldr r2, =0xa6a4fbfa
ldr r3, =0xcafebabe
ldr r4, =0xb5a0c3b8
ldr r5, =0x00000000
ldr r6, =0x6c7fc331
ldr r7, =0x80000000
ldr r8, =0xed47be13
ldr r9, =0xc1a70603
ldr r10, =0x35da68c2
ldr r11, =0x53a5045f
ldr r12, =0xd608a126
ldr r14, =0xffffffff
cmp r8, r0
moveq r0, #148
moveq r1, #97
movne r2, #38
movgt r3, #122
movhi r4, #136
movvs r5, #128
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
ldr r0, =0xf36ac83d
ldr r1, =0x00000021
ldr r2, =0x17b0bb1f
ldr r3, =0x8540cbc3
ldr r4, =0x000000ff
ldr r5, =0xa9a39c1c
ldr r6, =0xcf5412b0
ldr r7, =0x0000ffff
ldr r8, =0x80000000
ldr r9, =0x00000100
ldr r10, =0x00000001
ldr r11, =0x4506e9c9
ldr r12, =0xdfbc4cfe
ldr r14, =0x7fffffff
tst r6, r9
movcc r0, #177
movge r1, #142
movge r2, #14
movhi r3, #82
movle r4, #192
movlt r5, #59
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
ldr r0, =0x65922c77
ldr r1, =0x09cdd7eb
ldr r2, =0x405340a1
ldr r3, =0x2cfd2f10
ldr r4, =0x00000001
ldr r5, =0x2de15abb
ldr r6, =0x7ffffffe
ldr r7, =0x65885496
ldr r8, =0xffffffff
ldr r9, =0xf43f7d94
ldr r10, =0x7fffffff
ldr r11, =0x00000021
ldr r12, =0x00000101
ldr r14, =0x7fffffff
tst r5, r1
movcc r0, #111
movle r1, #114
movpl r2, #155
movge r3, #132
movlt r4, #67
movvc r5, #110
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
ldr r0, =0xc4b4dbef
ldr r1, =0x00000002
ldr r2, =0x00000001
ldr r3, =0x7ffffffe
ldr r4, =0x00000020
ldr r5, =0x4c237408
ldr r6, =0x9643170b
ldr r7, =0x1ec67a42
ldr r8, =0x00000000
ldr r9, =0x6399c6c3
ldr r10, =0x7ffffffe
ldr r11, =0x00000020
ldr r12, =0xffffffff
ldr r14, =0x099f05c0
tst r7, r5
movle r0, #160
movls r1, #32
movgt r2, #87
moveq r3, #62
movvs r4, #16
movcc r5, #111
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
