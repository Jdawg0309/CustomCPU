.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000101
str r0, [r12, #0]
ldr r0, =0x00000100
str r0, [r12, #4]
ldr r0, =0x7a46e6a0
str r0, [r12, #8]
ldr r0, =0x5879c3ca
str r0, [r12, #12]
ldr r0, =0x00000000
str r0, [r12, #16]
ldr r0, =0x00000000
str r0, [r12, #20]
ldr r0, =0x430f1e88
str r0, [r12, #24]
ldr r0, =0x690dc4b4
str r0, [r12, #28]
ldr r0, =0x80000001
str r0, [r12, #32]
ldr r0, =0x8e9e6040
str r0, [r12, #36]
ldr r0, =0x00000101
str r0, [r12, #40]
ldr r0, =0x00000000
str r0, [r12, #44]
ldr r0, =0xf6d5c54a
str r0, [r12, #48]
ldr r0, =0x7fffffff
str r0, [r12, #52]
ldr r0, =0x5e1e11f2
str r0, [r12, #56]
ldr r0, =0xc8e4b052
str r0, [r12, #60]
ldr r0, =0x7fffffff
ldr r1, =0xc6c24f91
ldr r2, =0x80000000
ldr r3, =0x80000001
ldr r4, =0x43cda5d2
ldr r5, =0x17f9b736
ldr r6, =0x80000001
ldr r7, =0x5f5c5c99
ldr r8, =0x80000001
ldr r9, =0xf3442962
ldr r10, =0xb1da5f2b
ldr r11, =0x12345678
ldr r12, =0xa6c03f01
ldr r14, =0xa6bbc881
cmn r7, r8
movls r0, #137
movhi r1, #104
movlt r2, #12
movlt r3, #154
movne r4, #124
moveq r5, #138
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
ldr r0, =0x7747a1b5
ldr r1, =0x96d2c547
ldr r2, =0x00000100
ldr r3, =0xa949959d
ldr r4, =0xa2a9a120
ldr r5, =0x00000100
ldr r6, =0xb24e8853
ldr r7, =0xe15044c2
ldr r8, =0x00000000
ldr r9, =0x83076641
ldr r10, =0xaca5192e
ldr r11, =0x00000001
ldr r12, =0x50cd46b4
ldr r14, =0x00000000
cmp r0, r1
movvs r0, #163
movlt r1, #68
movle r2, #34
movne r3, #13
movhi r4, #116
movcc r5, #170
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
ldr r0, =0x0000001f
ldr r1, =0x88f09ae3
ldr r2, =0xd1fb66b3
ldr r3, =0x67a79f00
ldr r4, =0x80000001
ldr r5, =0x12345678
ldr r6, =0xf986ea60
ldr r7, =0x259ec4b4
ldr r8, =0xc13be19e
ldr r9, =0x0323f33c
ldr r10, =0xb7f389a1
ldr r11, =0xeb9ceb15
ldr r12, =0x80000001
ldr r14, =0x00000001
tst r1, r5
movmi r0, #114
movne r1, #119
movhi r2, #192
movne r3, #152
moveq r4, #25
movge r5, #102
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
ldr r0, =0xdcc57bf4
ldr r1, =0x00000020
ldr r2, =0x00000021
ldr r3, =0x00000101
ldr r4, =0x00000100
ldr r5, =0x00000002
ldr r6, =0x1b984862
ldr r7, =0x00000021
ldr r8, =0x00000001
ldr r9, =0x3ed2d20d
ldr r10, =0xffffffff
ldr r11, =0x00000021
ldr r12, =0x00000000
ldr r14, =0x00000020
cmp r9, r4
moveq r0, #140
movlt r1, #113
movvs r2, #21
movne r3, #122
movls r4, #32
movvs r5, #123
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
ldr r0, =0x00000001
ldr r1, =0x00000100
ldr r2, =0x063843b0
ldr r3, =0x6b97c287
ldr r4, =0x80000001
ldr r5, =0x0000ffff
ldr r6, =0x00000020
ldr r7, =0x5e49c51d
ldr r8, =0x7991999b
ldr r9, =0xcafebabe
ldr r10, =0x2032decb
ldr r11, =0x12345678
ldr r12, =0x7fffffff
ldr r14, =0xd7c03ee6
cmp r6, r8
movcc r0, #18
movpl r1, #98
movcc r2, #52
movle r3, #85
movls r4, #176
movvc r5, #37
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
ldr r0, =0x00000001
ldr r1, =0x00000100
ldr r2, =0x30177712
ldr r3, =0x603248e0
ldr r4, =0x3db75650
ldr r5, =0x7749ac50
ldr r6, =0x0000ffff
ldr r7, =0xa0be3eb9
ldr r8, =0xf6b2effb
ldr r9, =0xa7c1bc73
ldr r10, =0xd0b723f7
ldr r11, =0xfb561788
ldr r12, =0x00000100
ldr r14, =0xb988301a
cmn r14, r14
movne r0, #92
movvc r1, #114
movmi r2, #133
moveq r3, #170
movpl r4, #129
movge r5, #130
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
ldr r1, =0x846d3af3
ldr r2, =0x9a99b245
ldr r3, =0x7e01d9de
ldr r4, =0x3703b610
ldr r5, =0x5b9ff3f2
ldr r6, =0xffffffff
ldr r7, =0x7ffffffe
ldr r8, =0x00000100
ldr r9, =0x12345678
ldr r10, =0x12345678
ldr r11, =0x0fb4de14
ldr r12, =0x00000021
ldr r14, =0x5a763acc
cmn r1, r1
movpl r0, #78
moveq r1, #84
movlt r2, #186
moveq r3, #16
movhi r4, #40
movgt r5, #133
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
ldr r0, =0xbdb27829
ldr r1, =0xa11f6875
ldr r2, =0xb3cc1c52
ldr r3, =0xb573c5b2
ldr r4, =0xf878a840
ldr r5, =0xcafebabe
ldr r6, =0x00000000
ldr r7, =0xed8b1d00
ldr r8, =0x4fb85703
ldr r9, =0x6e1cfff2
ldr r10, =0xffffffff
ldr r11, =0x00000101
ldr r12, =0x0013f18e
ldr r14, =0xd53e518b
tst r10, r11
movhi r0, #55
movmi r1, #168
movlt r2, #18
movcc r3, #36
movlt r4, #18
movmi r5, #189
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
