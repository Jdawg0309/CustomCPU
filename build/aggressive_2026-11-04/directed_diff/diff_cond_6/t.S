.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x854d5cbe
str r0, [r12, #0]
ldr r0, =0x0000ffff
str r0, [r12, #4]
ldr r0, =0x0000ffff
str r0, [r12, #8]
ldr r0, =0xf203efd2
str r0, [r12, #12]
ldr r0, =0x19e0464a
str r0, [r12, #16]
ldr r0, =0x7ffffffe
str r0, [r12, #20]
ldr r0, =0x5cf964a2
str r0, [r12, #24]
ldr r0, =0xf6340623
str r0, [r12, #28]
ldr r0, =0xd5e8280b
str r0, [r12, #32]
ldr r0, =0x0000001f
str r0, [r12, #36]
ldr r0, =0x1c081164
str r0, [r12, #40]
ldr r0, =0x00000002
str r0, [r12, #44]
ldr r0, =0x00000101
str r0, [r12, #48]
ldr r0, =0x6b327f99
str r0, [r12, #52]
ldr r0, =0x2dd99ea6
str r0, [r12, #56]
ldr r0, =0x00000001
str r0, [r12, #60]
ldr r0, =0x0000001f
ldr r1, =0x7ffffffe
ldr r2, =0xffffffff
ldr r3, =0xbc6a6287
ldr r4, =0x80000000
ldr r5, =0xf0815bf0
ldr r6, =0x42b821df
ldr r7, =0x0000001f
ldr r8, =0x80000000
ldr r9, =0x48b82b40
ldr r10, =0x12345678
ldr r11, =0x7f848bb8
ldr r12, =0x668be5b1
ldr r14, =0x37618999
cmp r1, r11
movmi r0, #5
movgt r1, #147
movlt r2, #76
movcc r3, #122
movhi r4, #161
movge r5, #130
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
ldr r0, =0xc26bff92
ldr r1, =0x83d09965
ldr r2, =0xafe80ae1
ldr r3, =0x753e917b
ldr r4, =0x0000001f
ldr r5, =0x49faa41b
ldr r6, =0x97ce69bb
ldr r7, =0x8b61b4aa
ldr r8, =0x000000ff
ldr r9, =0x00000020
ldr r10, =0x974c8795
ldr r11, =0x000000ff
ldr r12, =0x899f642d
ldr r14, =0x0000001f
cmp r5, r10
movlt r0, #36
moveq r1, #136
movge r2, #99
movgt r3, #171
movle r4, #152
movlt r5, #104
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
ldr r0, =0x00000021
ldr r1, =0x19687852
ldr r2, =0x55d7c6b4
ldr r3, =0x3fdd2428
ldr r4, =0x00000021
ldr r5, =0x12345678
ldr r6, =0x26d72c65
ldr r7, =0x00000020
ldr r8, =0x0000001f
ldr r9, =0x2641cdfb
ldr r10, =0x000000ff
ldr r11, =0xfeb6ebf7
ldr r12, =0xf150aef3
ldr r14, =0x00000101
tst r1, r1
movge r0, #102
movpl r1, #193
movgt r2, #151
movvs r3, #78
movcs r4, #58
movvs r5, #179
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
ldr r0, =0x6c568c67
ldr r1, =0xd136508c
ldr r2, =0xcafebabe
ldr r3, =0x7fffffff
ldr r4, =0xcc686dd5
ldr r5, =0x00000021
ldr r6, =0xf5e36ff4
ldr r7, =0x587ffdb0
ldr r8, =0x0b2aa020
ldr r9, =0x00000020
ldr r10, =0x00000021
ldr r11, =0xb84ad8e6
ldr r12, =0x1dc7279d
ldr r14, =0x6eb2d329
cmp r11, r11
movcc r0, #62
movcs r1, #80
movge r2, #35
movlt r3, #150
movpl r4, #72
movhi r5, #153
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
ldr r0, =0x00000002
ldr r1, =0xbca95464
ldr r2, =0x80000000
ldr r3, =0xf2e79852
ldr r4, =0xd3df62ef
ldr r5, =0x000000ff
ldr r6, =0x12345678
ldr r7, =0x501e4451
ldr r8, =0x47a6032e
ldr r9, =0xfe2e5b75
ldr r10, =0x000000ff
ldr r11, =0xffffffff
ldr r12, =0x0be411d8
ldr r14, =0x80000000
cmn r11, r14
movvs r0, #26
movmi r1, #62
movlt r2, #170
movls r3, #89
movcc r4, #176
movmi r5, #44
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
ldr r0, =0x00000020
ldr r1, =0xb2e113c1
ldr r2, =0x00000100
ldr r3, =0x000000ff
ldr r4, =0x00000021
ldr r5, =0x00000021
ldr r6, =0x869a5e31
ldr r7, =0x80000000
ldr r8, =0xb255c0e3
ldr r9, =0x0000ffff
ldr r10, =0x80000001
ldr r11, =0x00000002
ldr r12, =0x12345678
ldr r14, =0x000000ff
cmp r7, r5
movge r0, #16
movgt r1, #67
movpl r2, #192
movvc r3, #50
movlt r4, #168
movhi r5, #14
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
ldr r0, =0x0000ffff
ldr r1, =0x33d5835d
ldr r2, =0x80000001
ldr r3, =0x00000021
ldr r4, =0xfbbf7bc6
ldr r5, =0xf99957f2
ldr r6, =0x44098f2f
ldr r7, =0x0000001f
ldr r8, =0x0000001f
ldr r9, =0x55c9f93b
ldr r10, =0x8e2c03ac
ldr r11, =0xcd1fd94a
ldr r12, =0x0000ffff
ldr r14, =0x16cfa383
cmn r5, r7
movmi r0, #35
moveq r1, #80
movpl r2, #125
movcc r3, #68
movpl r4, #162
movcs r5, #92
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
ldr r0, =0x7b259953
ldr r1, =0x00000020
ldr r2, =0xd930c9dd
ldr r3, =0xde802be3
ldr r4, =0x80000000
ldr r5, =0x5464ae65
ldr r6, =0x3c846b1f
ldr r7, =0x0000ffff
ldr r8, =0x85d5b56c
ldr r9, =0x80000001
ldr r10, =0x7ffffffe
ldr r11, =0x7ffffffe
ldr r12, =0x80000001
ldr r14, =0x00000002
cmn r5, r4
movge r0, #120
movgt r1, #14
movls r2, #157
movgt r3, #143
movle r4, #195
movne r5, #58
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
