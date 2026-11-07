.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000001
str r0, [r12, #0]
ldr r0, =0x00000101
str r0, [r12, #4]
ldr r0, =0xc0dbb8dd
str r0, [r12, #8]
ldr r0, =0x80000001
str r0, [r12, #12]
ldr r0, =0x446e2aa0
str r0, [r12, #16]
ldr r0, =0x80000001
str r0, [r12, #20]
ldr r0, =0xffffffff
str r0, [r12, #24]
ldr r0, =0xe00570ee
str r0, [r12, #28]
ldr r0, =0x0000ffff
str r0, [r12, #32]
ldr r0, =0x00000002
str r0, [r12, #36]
ldr r0, =0x9dd93566
str r0, [r12, #40]
ldr r0, =0x8940e04d
str r0, [r12, #44]
ldr r0, =0x740f707e
str r0, [r12, #48]
ldr r0, =0x0c106dd4
str r0, [r12, #52]
ldr r0, =0x5729da2a
str r0, [r12, #56]
ldr r0, =0x2e344157
str r0, [r12, #60]
ldr r0, =0xb711526c
ldr r1, =0x17c20eb2
ldr r2, =0x00000002
ldr r3, =0x80000000
ldr r4, =0x12345678
ldr r5, =0x00000100
ldr r6, =0x12345678
ldr r7, =0x80000001
ldr r8, =0x00000021
ldr r9, =0x79653501
ldr r10, =0xffffffff
ldr r11, =0x578a5f17
ldr r12, =0x00000002
ldr r14, =0x00000020
tst r11, r14
ldr r10, =0x1120
mov r9, #12
ldrh r7, [r10], -r9
ldr r3, [r10], -r9
ldr r10, =0x1120
ldr r4, [r10], r9
ldrsh r8, [r10], #0
ldrsbpl r0, [r10], #16
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
ldr r0, =0x00000101
ldr r1, =0x2683f9f6
ldr r2, =0x000000ff
ldr r3, =0x6a790866
ldr r4, =0xfdcc9a02
ldr r5, =0x901eb26b
ldr r6, =0x80000001
ldr r7, =0xe784a4ad
ldr r8, =0x20308395
ldr r9, =0x3f564d2c
ldr r10, =0xffffffff
ldr r11, =0xc231f5cb
ldr r12, =0xffffffff
ldr r14, =0x00000021
cmp r2, r2
ldr r10, =0x1120
mov r9, #12
ldr r12, [r10, #28]
ldr r8, [r10, #-24]
ldrsb r4, [r10, #-7]
strb r5, [r10, #-5]
str r6, [r10, -r9]
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
ldr r0, =0x7ffffffe
ldr r1, =0x0000001f
ldr r2, =0x7fffffff
ldr r3, =0xc39adef0
ldr r4, =0x5f8717b6
ldr r5, =0x00000021
ldr r6, =0xcafebabe
ldr r7, =0x469512fb
ldr r8, =0x3211ca80
ldr r9, =0x00000001
ldr r10, =0xc624b764
ldr r11, =0x014b67e2
ldr r12, =0x00000000
ldr r14, =0x7ffffffe
tst r9, r4
ldr r10, =0x1120
mov r9, #8
ldrh r11, [r10], #12
ldr r10, =0x1120
ldrsb r12, [r10], r9
ldr r5, [r10], -r9
ldrh r0, [r10, #-4]
ldrb r6, [r10, #6]
ldr r10, =0x1120
str r8, [r10], #8
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
ldr r0, =0x80000000
ldr r1, =0x000000ff
ldr r2, =0xb0b71eed
ldr r3, =0x00000021
ldr r4, =0x0443a038
ldr r5, =0x12345678
ldr r6, =0x7eeb2a1d
ldr r7, =0xbbb558e5
ldr r8, =0x80000000
ldr r9, =0xcafebabe
ldr r10, =0x00000020
ldr r11, =0xaec99ec7
ldr r12, =0x80000001
ldr r14, =0xa7667280
cmp r3, r3
ldr r10, =0x1120
mov r9, #4
ldrh r1, [r10, #-4]
ldrhcc r0, [r10, #-12]
ldrvs r12, [r10], -r9
ldrsh r8, [r10, #8]
ldrsh r12, [r10, #6]
ldr r10, =0x1120
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
ldr r0, =0x78bb237a
ldr r1, =0x12345678
ldr r2, =0x7601885d
ldr r3, =0x00000002
ldr r4, =0x27854756
ldr r5, =0x00000001
ldr r6, =0xffffffff
ldr r7, =0x640b140c
ldr r8, =0xb836042e
ldr r9, =0x8771239d
ldr r10, =0x0000001f
ldr r11, =0x968af905
ldr r12, =0x7ffffffe
ldr r14, =0x133ad1b2
cmp r2, r3
ldr r10, =0x1120
mov r9, #12
ldr r1, [r10, r9]
ldrhcc r7, [r10, #8]!
strpl r11, [r10], -r9
strblt r1, [r10, #-12]
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
ldr r1, =0x0000001f
ldr r2, =0xd2a1993f
ldr r3, =0x02d53e6d
ldr r4, =0x0000001f
ldr r5, =0x80000000
ldr r6, =0x7fffffff
ldr r7, =0x00000001
ldr r8, =0x17eee47b
ldr r9, =0xa7623fd4
ldr r10, =0x80000000
ldr r11, =0x00000100
ldr r12, =0x00000000
ldr r14, =0xe88241c9
tst r11, r1
ldr r10, =0x1120
mov r9, #4
str r11, [r10], -r9
strhle r7, [r10], -r9
ldr r10, =0x1120
ldrb r8, [r10, #5]
str r5, [r10], #0
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
ldr r0, =0x7ffffffe
ldr r1, =0x000000ff
ldr r2, =0x69aeaf3f
ldr r3, =0x113baad3
ldr r4, =0x394ecef7
ldr r5, =0x80000000
ldr r6, =0x000000ff
ldr r7, =0x7ffffffe
ldr r8, =0x000000ff
ldr r9, =0x96098d57
ldr r10, =0xd66a7fc4
ldr r11, =0xa9bc579b
ldr r12, =0x0000001f
ldr r14, =0x00000001
cmn r14, r6
ldr r10, =0x1120
mov r9, #12
ldrsb r6, [r10], #0
ldr r10, =0x1120
ldrhcs r0, [r10, #16]!
ldr r10, =0x1120
ldrsh r2, [r10], r9
strh r6, [r10, -r9]
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
ldr r0, =0x0000001f
ldr r1, =0x4e0c5fea
ldr r2, =0xffffffff
ldr r3, =0xef039d56
ldr r4, =0xbcc66e5c
ldr r5, =0xd2b7423f
ldr r6, =0xd4b482f2
ldr r7, =0xbcdc5b91
ldr r8, =0xffffffff
ldr r9, =0x5f041805
ldr r10, =0x00000002
ldr r11, =0x00000020
ldr r12, =0x00000100
ldr r14, =0x12345678
cmp r12, r11
ldr r10, =0x1120
mov r9, #4
ldrb r6, [r10], #12
ldr r10, =0x1120
str r14, [r10, r9]
ldr r10, =0x1120
ldrb r0, [r10, #-13]
ldrsb r11, [r10, r9]
str r7, [r10, #-12]
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
