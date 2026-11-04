.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x57458e16
str r0, [r12, #0]
ldr r0, =0x6c2debb3
str r0, [r12, #4]
ldr r0, =0x0000001f
str r0, [r12, #8]
ldr r0, =0x2b8572d0
str r0, [r12, #12]
ldr r0, =0x3ce5e4d3
str r0, [r12, #16]
ldr r0, =0x7fffffff
str r0, [r12, #20]
ldr r0, =0x087201b7
str r0, [r12, #24]
ldr r0, =0x655408ed
str r0, [r12, #28]
ldr r0, =0x642f441e
str r0, [r12, #32]
ldr r0, =0x08345c38
str r0, [r12, #36]
ldr r0, =0x78b77147
str r0, [r12, #40]
ldr r0, =0x4053646c
str r0, [r12, #44]
ldr r0, =0x00000020
str r0, [r12, #48]
ldr r0, =0x7ffffffe
str r0, [r12, #52]
ldr r0, =0x7ffffffe
str r0, [r12, #56]
ldr r0, =0x12345678
str r0, [r12, #60]
ldr r0, =0x00000100
ldr r1, =0x80000000
ldr r2, =0x000000ff
ldr r3, =0x0f39f6b1
ldr r4, =0x23420a51
ldr r5, =0x7eb9756f
ldr r6, =0xf3500165
ldr r7, =0x998e982e
ldr r8, =0x38d8fd14
ldr r9, =0xf070286a
ldr r10, =0x00000021
ldr r11, =0x00000020
ldr r12, =0x1981070c
ldr r14, =0xc2333843
cmp r11, r0
movhi r0, #50
movpl r1, #52
movvc r2, #59
movcc r3, #43
movgt r4, #113
movlt r5, #21
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
ldr r0, =0xd3fcee28
ldr r1, =0x0000ffff
ldr r2, =0x80000000
ldr r3, =0xea0d5aa3
ldr r4, =0xf6a49e5e
ldr r5, =0x8972aedb
ldr r6, =0xff4e8007
ldr r7, =0x36d2075c
ldr r8, =0x0000ffff
ldr r9, =0xb2508c9c
ldr r10, =0xbbe70413
ldr r11, =0x714a6304
ldr r12, =0x2bcb79e9
ldr r14, =0x80000000
cmp r12, r7
movle r0, #31
movgt r1, #76
moveq r2, #156
movhi r3, #92
movle r4, #152
movle r5, #5
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
ldr r0, =0xa1f92634
ldr r1, =0x0000001f
ldr r2, =0x12345678
ldr r3, =0x04b1f115
ldr r4, =0xfaddbb4e
ldr r5, =0x86f2a29a
ldr r6, =0x6a25c1ae
ldr r7, =0x00000000
ldr r8, =0x54545fc1
ldr r9, =0xffffffff
ldr r10, =0xc6bbd641
ldr r11, =0x3f49205e
ldr r12, =0x41699aa8
ldr r14, =0xcafebabe
cmn r4, r11
movhi r0, #134
movlt r1, #174
movvs r2, #193
movhi r3, #67
movpl r4, #1
movls r5, #114
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
ldr r0, =0xa0c5acaa
ldr r1, =0xc0a868d4
ldr r2, =0x80000001
ldr r3, =0x7ffffffe
ldr r4, =0xb6f0f216
ldr r5, =0x00000021
ldr r6, =0x8f8bf3df
ldr r7, =0x0000ffff
ldr r8, =0x0000ffff
ldr r9, =0xab49eecb
ldr r10, =0x80000000
ldr r11, =0x00000100
ldr r12, =0xcafebabe
ldr r14, =0x00000020
cmn r9, r3
movle r0, #172
movne r1, #143
movge r2, #187
movne r3, #51
movhi r4, #79
movpl r5, #65
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
ldr r1, =0x843b35ec
ldr r2, =0x000000ff
ldr r3, =0x6101a805
ldr r4, =0xcafebabe
ldr r5, =0xb0c366c5
ldr r6, =0xecb215ca
ldr r7, =0x00000001
ldr r8, =0x00000000
ldr r9, =0xcafebabe
ldr r10, =0x7ec4846f
ldr r11, =0x80000001
ldr r12, =0x8d10b2df
ldr r14, =0x81f0063e
tst r3, r1
movcs r0, #199
movvs r1, #112
movcc r2, #106
movpl r3, #42
movhi r4, #144
movhi r5, #122
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
ldr r1, =0x339d2459
ldr r2, =0x00000101
ldr r3, =0x80000001
ldr r4, =0x000000ff
ldr r5, =0x00000101
ldr r6, =0x00000000
ldr r7, =0x9baaeea2
ldr r8, =0x2c4df192
ldr r9, =0x2455f6eb
ldr r10, =0x5bd0f8e1
ldr r11, =0x025fdfb8
ldr r12, =0x00000002
ldr r14, =0x00000001
teq r14, r7
movvs r0, #119
movhi r1, #137
movgt r2, #1
movmi r3, #187
movge r4, #4
movcc r5, #124
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
ldr r0, =0x97827337
ldr r1, =0x80000000
ldr r2, =0x2d3d417b
ldr r3, =0x8a85f185
ldr r4, =0x3db767ed
ldr r5, =0xe76582ce
ldr r6, =0x684d66db
ldr r7, =0xfdf6c048
ldr r8, =0xadaee37e
ldr r9, =0xd09e4bb1
ldr r10, =0xfdc0a13c
ldr r11, =0x0000ffff
ldr r12, =0x00000020
ldr r14, =0x00000001
cmn r8, r10
movge r0, #134
movmi r1, #119
movcs r2, #188
movlt r3, #192
movmi r4, #155
moveq r5, #178
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
ldr r0, =0x12345678
ldr r1, =0xfd68703d
ldr r2, =0x628eab4d
ldr r3, =0x12345678
ldr r4, =0x12405130
ldr r5, =0x00000101
ldr r6, =0x626b0eb6
ldr r7, =0x00000021
ldr r8, =0x00000020
ldr r9, =0x6eeebffd
ldr r10, =0x000000ff
ldr r11, =0x6590a828
ldr r12, =0xb8dc3f9c
ldr r14, =0x77ed8a16
cmp r9, r9
movgt r0, #102
movls r1, #177
movpl r2, #141
movvs r3, #87
movhi r4, #14
movne r5, #26
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
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
