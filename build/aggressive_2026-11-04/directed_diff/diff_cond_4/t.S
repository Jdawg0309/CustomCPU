.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xcdad15e9
str r0, [r12, #0]
ldr r0, =0x2b4526b3
str r0, [r12, #4]
ldr r0, =0x7ffffffe
str r0, [r12, #8]
ldr r0, =0x00000100
str r0, [r12, #12]
ldr r0, =0x00000021
str r0, [r12, #16]
ldr r0, =0xcafebabe
str r0, [r12, #20]
ldr r0, =0xffffffff
str r0, [r12, #24]
ldr r0, =0x64d34cbf
str r0, [r12, #28]
ldr r0, =0x00000100
str r0, [r12, #32]
ldr r0, =0xee23e8e7
str r0, [r12, #36]
ldr r0, =0x000000ff
str r0, [r12, #40]
ldr r0, =0x80000000
str r0, [r12, #44]
ldr r0, =0x0000001f
str r0, [r12, #48]
ldr r0, =0x00000021
str r0, [r12, #52]
ldr r0, =0x00000021
str r0, [r12, #56]
ldr r0, =0x0000ffff
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0xe485fbbb
ldr r2, =0xc5bfa90c
ldr r3, =0xd720afd5
ldr r4, =0xf4ecc7a8
ldr r5, =0x00000001
ldr r6, =0x00000101
ldr r7, =0x672c2f02
ldr r8, =0xfecd9ed8
ldr r9, =0x79137f4b
ldr r10, =0x0000ffff
ldr r11, =0x33d4c1d0
ldr r12, =0x00000020
ldr r14, =0xe4b72d9f
cmp r5, r1
movmi r0, #53
movgt r1, #157
movls r2, #124
movvs r3, #58
movvc r4, #169
movlt r5, #124
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
ldr r0, =0xfa8b7a8b
ldr r1, =0x0000ffff
ldr r2, =0x3da5943c
ldr r3, =0xffffffff
ldr r4, =0x00000001
ldr r5, =0x7fffffff
ldr r6, =0x7ffffffe
ldr r7, =0x71701ddb
ldr r8, =0xcafebabe
ldr r9, =0x05dc8895
ldr r10, =0xe463b691
ldr r11, =0xcafebabe
ldr r12, =0xd3348eb5
ldr r14, =0x115a7d23
cmn r11, r12
movmi r0, #159
movcc r1, #128
movls r2, #48
movcs r3, #131
movgt r4, #70
movmi r5, #173
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
ldr r0, =0xf1edd13b
ldr r1, =0x7fffffff
ldr r2, =0xcafebabe
ldr r3, =0xffffffff
ldr r4, =0x14262dd8
ldr r5, =0x7ffffffe
ldr r6, =0x9a2d0da4
ldr r7, =0x0000001f
ldr r8, =0x5bd962f3
ldr r9, =0x00000002
ldr r10, =0x00000101
ldr r11, =0x8f3dea23
ldr r12, =0x00000001
ldr r14, =0x53ee8100
cmn r1, r5
movge r0, #11
movhi r1, #126
movcs r2, #158
movcs r3, #159
moveq r4, #160
movpl r5, #171
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
ldr r0, =0x80000001
ldr r1, =0x00000101
ldr r2, =0x4270a103
ldr r3, =0x9d81d572
ldr r4, =0x80000001
ldr r5, =0x80000000
ldr r6, =0x00000021
ldr r7, =0x9d53254e
ldr r8, =0xab1fe09a
ldr r9, =0xbdf6b41d
ldr r10, =0x0000ffff
ldr r11, =0x00000001
ldr r12, =0xeed49358
ldr r14, =0x418ff23a
cmp r9, r1
movls r0, #56
movcs r1, #198
movcs r2, #190
movvs r3, #36
movpl r4, #168
movvs r5, #49
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
ldr r1, =0x80000000
ldr r2, =0x00000001
ldr r3, =0x00000101
ldr r4, =0x45a31ff8
ldr r5, =0x00000002
ldr r6, =0x0000001f
ldr r7, =0x80000000
ldr r8, =0xffffffff
ldr r9, =0xfceccfe9
ldr r10, =0x0000001f
ldr r11, =0x7b297f1b
ldr r12, =0x00000001
ldr r14, =0x9798e218
cmn r3, r14
movle r0, #28
movle r1, #42
movne r2, #148
movlt r3, #167
movvs r4, #16
movvc r5, #31
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
ldr r0, =0xb04a6609
ldr r1, =0xf2929f4c
ldr r2, =0x525c45a6
ldr r3, =0x80000000
ldr r4, =0xe4e57d3d
ldr r5, =0x00000001
ldr r6, =0xff128348
ldr r7, =0x327ef65b
ldr r8, =0x1918f01e
ldr r9, =0x00000021
ldr r10, =0x0000ffff
ldr r11, =0xd8f567df
ldr r12, =0x4dd6a0f1
ldr r14, =0xffffffff
cmp r1, r11
movgt r0, #136
moveq r1, #60
movvs r2, #194
movvs r3, #121
movge r4, #43
movle r5, #141
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
ldr r0, =0x5ed99332
ldr r1, =0x00000000
ldr r2, =0x0000ffff
ldr r3, =0xf7076b46
ldr r4, =0x80000001
ldr r5, =0xa745e407
ldr r6, =0x1d760bf3
ldr r7, =0x00000100
ldr r8, =0x80000000
ldr r9, =0x14e06744
ldr r10, =0x0000001f
ldr r11, =0x00000101
ldr r12, =0x00000100
ldr r14, =0x00000101
teq r9, r4
movlt r0, #96
movmi r1, #99
movmi r2, #191
movge r3, #169
movpl r4, #37
movhi r5, #48
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
ldr r0, =0x7fffffff
ldr r1, =0x1d36e25f
ldr r2, =0x00000001
ldr r3, =0x0181c303
ldr r4, =0x2280f2d9
ldr r5, =0x0000001f
ldr r6, =0x7ffffffe
ldr r7, =0x27351b0f
ldr r8, =0x0000ffff
ldr r9, =0x12345678
ldr r10, =0x0000001f
ldr r11, =0x00000000
ldr r12, =0x3cb76234
ldr r14, =0xf05be0a4
teq r9, r2
movne r0, #188
movhi r1, #48
movpl r2, #191
moveq r3, #113
movle r4, #141
movge r5, #129
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
