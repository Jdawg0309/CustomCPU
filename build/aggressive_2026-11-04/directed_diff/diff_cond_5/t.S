.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x6401ac64
str r0, [r12, #0]
ldr r0, =0xb92481f8
str r0, [r12, #4]
ldr r0, =0x2d92ce13
str r0, [r12, #8]
ldr r0, =0x0000ffff
str r0, [r12, #12]
ldr r0, =0x7fffffff
str r0, [r12, #16]
ldr r0, =0x0000ffff
str r0, [r12, #20]
ldr r0, =0xdf25c6d9
str r0, [r12, #24]
ldr r0, =0x7d66c319
str r0, [r12, #28]
ldr r0, =0x00000021
str r0, [r12, #32]
ldr r0, =0xac1890ff
str r0, [r12, #36]
ldr r0, =0x31aab315
str r0, [r12, #40]
ldr r0, =0x00000101
str r0, [r12, #44]
ldr r0, =0x86483e1c
str r0, [r12, #48]
ldr r0, =0x09cdffca
str r0, [r12, #52]
ldr r0, =0x6195f3e5
str r0, [r12, #56]
ldr r0, =0xffffffff
str r0, [r12, #60]
ldr r0, =0x00000101
ldr r1, =0x80000000
ldr r2, =0xe7f09c31
ldr r3, =0x00000002
ldr r4, =0x80000001
ldr r5, =0x00000002
ldr r6, =0x9554963b
ldr r7, =0x45aae6f7
ldr r8, =0xde231f8b
ldr r9, =0xffffffff
ldr r10, =0x56243eb2
ldr r11, =0x000000ff
ldr r12, =0x049b96f3
ldr r14, =0x0f9a7e70
cmn r9, r10
movne r0, #114
movgt r1, #43
movmi r2, #37
movmi r3, #19
movlt r4, #64
movcs r5, #73
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
ldr r0, =0x00000002
ldr r1, =0x976dc0d4
ldr r2, =0x00000020
ldr r3, =0xdc8aa0f8
ldr r4, =0x80000001
ldr r5, =0x7e3689ad
ldr r6, =0xffffffff
ldr r7, =0x10a1d6dd
ldr r8, =0x00000101
ldr r9, =0x80000000
ldr r10, =0x298e1091
ldr r11, =0xccd1e62a
ldr r12, =0xeaca696f
ldr r14, =0x894fe452
teq r1, r12
movvs r0, #78
movgt r1, #48
movls r2, #109
movhi r3, #180
movmi r4, #13
movvc r5, #113
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
ldr r0, =0x12345678
ldr r1, =0x0000ffff
ldr r2, =0x80000000
ldr r3, =0xffffffff
ldr r4, =0x2799b012
ldr r5, =0x119a3bb7
ldr r6, =0x0d0352b9
ldr r7, =0x57a75746
ldr r8, =0x00000101
ldr r9, =0x62644cc9
ldr r10, =0x85adb49b
ldr r11, =0x633b4bd0
ldr r12, =0x1d4ee155
ldr r14, =0xd86c0089
cmp r12, r11
movge r0, #40
movvs r1, #67
movvs r2, #76
movcc r3, #66
movge r4, #136
movvs r5, #109
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
ldr r0, =0x901457eb
ldr r1, =0x00000101
ldr r2, =0xaf6df39c
ldr r3, =0x000000ff
ldr r4, =0x12345678
ldr r5, =0xf9fe5721
ldr r6, =0xcafebabe
ldr r7, =0x48b6d897
ldr r8, =0x7fffffff
ldr r9, =0x00000101
ldr r10, =0x0000ffff
ldr r11, =0x0000ffff
ldr r12, =0x6fade10c
ldr r14, =0xf8b7c151
tst r14, r12
movne r0, #94
movmi r1, #111
moveq r2, #38
moveq r3, #114
movlt r4, #51
moveq r5, #33
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
ldr r1, =0x00000000
ldr r2, =0x0e811be4
ldr r3, =0x6507dcad
ldr r4, =0x0000ffff
ldr r5, =0xb439b86f
ldr r6, =0x0000ffff
ldr r7, =0x06b4b02a
ldr r8, =0x000000ff
ldr r9, =0xb550ba3d
ldr r10, =0x00000000
ldr r11, =0x00000000
ldr r12, =0x633aca31
ldr r14, =0x0000001f
teq r10, r2
movpl r0, #134
movls r1, #184
moveq r2, #3
movlt r3, #182
movne r4, #87
movvc r5, #193
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
ldr r0, =0x80000000
ldr r1, =0x80000000
ldr r2, =0x80000001
ldr r3, =0x00000002
ldr r4, =0x00000020
ldr r5, =0x9af9d19c
ldr r6, =0x00000100
ldr r7, =0x7ffffffe
ldr r8, =0xf12438d8
ldr r9, =0x80000001
ldr r10, =0x92ce0750
ldr r11, =0x0000ffff
ldr r12, =0xa00bbc2b
ldr r14, =0x000000ff
cmp r2, r2
movls r0, #126
movpl r1, #178
movlt r2, #48
movvc r3, #163
movpl r4, #110
movne r5, #56
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
ldr r0, =0xd9188e48
ldr r1, =0xfc2a04e3
ldr r2, =0x00000000
ldr r3, =0x50ab247e
ldr r4, =0x00000020
ldr r5, =0x00000001
ldr r6, =0x087daccf
ldr r7, =0x7fffffff
ldr r8, =0xa93eee28
ldr r9, =0x00000002
ldr r10, =0x7fffffff
ldr r11, =0x00000100
ldr r12, =0xe732bbf8
ldr r14, =0x00000100
teq r9, r5
movcc r0, #85
movlt r1, #140
movne r2, #76
movcs r3, #40
movcc r4, #185
movmi r5, #94
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
ldr r1, =0xe2262759
ldr r2, =0x0000001f
ldr r3, =0x6baf4400
ldr r4, =0x00000100
ldr r5, =0x5cbe3f4e
ldr r6, =0x7ffffffe
ldr r7, =0xe08782c4
ldr r8, =0x0000ffff
ldr r9, =0x12b2d987
ldr r10, =0x1b05bded
ldr r11, =0x0000ffff
ldr r12, =0xb934fa83
ldr r14, =0xffffffff
cmp r6, r12
movpl r0, #118
movvs r1, #195
movcs r2, #128
movle r3, #34
movle r4, #75
movge r5, #84
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
