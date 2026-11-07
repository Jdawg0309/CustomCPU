.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x804e8ddc
str r0, [r12, #0]
ldr r0, =0x000000ff
str r0, [r12, #4]
ldr r0, =0xa51931d7
str r0, [r12, #8]
ldr r0, =0x00000021
str r0, [r12, #12]
ldr r0, =0x7fffffff
str r0, [r12, #16]
ldr r0, =0x00000001
str r0, [r12, #20]
ldr r0, =0x0000ffff
str r0, [r12, #24]
ldr r0, =0x12b2b099
str r0, [r12, #28]
ldr r0, =0xffffffff
str r0, [r12, #32]
ldr r0, =0x6e1acd98
str r0, [r12, #36]
ldr r0, =0x00000021
str r0, [r12, #40]
ldr r0, =0xae8a551d
str r0, [r12, #44]
ldr r0, =0x00000001
str r0, [r12, #48]
ldr r0, =0x2bd09193
str r0, [r12, #52]
ldr r0, =0x71611df4
str r0, [r12, #56]
ldr r0, =0xaf70655f
str r0, [r12, #60]
ldr r0, =0x7ffffffe
ldr r1, =0x0000001f
ldr r2, =0x8dfb9587
ldr r3, =0x00000002
ldr r4, =0x12345678
ldr r5, =0xac79889f
ldr r6, =0x00000101
ldr r7, =0xc2ecf606
ldr r8, =0x0000ffff
ldr r9, =0x4b6ae90a
ldr r10, =0xf9b1f6b6
ldr r11, =0x000000ff
ldr r12, =0x00000002
ldr r14, =0x23cec3b4
cmn r6, r6
ldr r10, =0x1120
mov r9, #16
ldrb r3, [r10, #5]
ldrsh r2, [r10, #-4]
ldr r10, =0x1120
ldrsh r14, [r10, #20]!
ldr r10, =0x1120
strh r1, [r10], -r9
ldrsbeq r11, [r10, #0]
strb r5, [r10, #-5]
strhcs r6, [r10], r9
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
ldr r0, =0x12345678
ldr r1, =0x00000020
ldr r2, =0x7f0d4db1
ldr r3, =0xdfec5cf7
ldr r4, =0x5eea51d6
ldr r5, =0xa0ad218f
ldr r6, =0x84ae3c96
ldr r7, =0x80000001
ldr r8, =0x00000001
ldr r9, =0x2302d8d4
ldr r10, =0x7aea19f2
ldr r11, =0xe23644fc
ldr r12, =0x8a74fe4b
ldr r14, =0x80000001
teq r5, r11
ldr r10, =0x1120
mov r9, #12
ldrh r2, [r10, #0]!
ldrsbvc r0, [r10, r9]
ldrsh r7, [r10, -r9]
ldr r10, =0x1120
ldrhi r1, [r10, #12]!
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
ldr r0, =0x2622d181
ldr r1, =0x00000101
ldr r2, =0xf2f8ded1
ldr r3, =0x00000002
ldr r4, =0x7ffffffe
ldr r5, =0x00000001
ldr r6, =0xc9be5c6c
ldr r7, =0x4904c0aa
ldr r8, =0x00000021
ldr r9, =0xafdeae4d
ldr r10, =0x00000021
ldr r11, =0x12345678
ldr r12, =0x49534993
ldr r14, =0x0000ffff
teq r11, r2
ldr r10, =0x1120
mov r9, #12
strh r4, [r10, #14]
ldrsb r8, [r10, r9]
ldr r10, =0x1120
ldrsh r3, [r10, -r9]
ldr r0, [r10], r9
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
ldr r0, =0x00000021
ldr r1, =0x908f7ed4
ldr r2, =0x00000001
ldr r3, =0x9a580450
ldr r4, =0x57d63702
ldr r5, =0x00000101
ldr r6, =0x000000ff
ldr r7, =0x0000001f
ldr r8, =0x12345678
ldr r9, =0x80000000
ldr r10, =0x4c810c83
ldr r11, =0xd2a83939
ldr r12, =0x178eaf1d
ldr r14, =0x00000000
cmn r0, r9
ldr r10, =0x1120
mov r9, #8
ldrsb r3, [r10], -r9
strb r14, [r10, r9]
ldrhls r3, [r10], r9
ldr r10, =0x1120
str r0, [r10, #16]!
ldr r10, =0x1120
str r3, [r10, -r9]
strhgt r6, [r10], -r9
ldr r10, =0x1120
strhgt r14, [r10, #6]
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
ldr r0, =0xffffffff
ldr r1, =0x00000021
ldr r2, =0x000000ff
ldr r3, =0x00000101
ldr r4, =0x0000ffff
ldr r5, =0x80000000
ldr r6, =0x80000000
ldr r7, =0xdec0e50e
ldr r8, =0xdc387724
ldr r9, =0x792900fb
ldr r10, =0xb80dc809
ldr r11, =0x00000100
ldr r12, =0xffffffff
ldr r14, =0x70fb1f85
tst r14, r10
ldr r10, =0x1120
mov r9, #4
ldrsbeq r12, [r10, -r9]
ldr r10, =0x1120
ldrsh r2, [r10], #16
ldr r10, =0x1120
ldrsheq r12, [r10, #8]
str r7, [r10, r9]
ldrsh r14, [r10, #-12]
ldrsbgt r14, [r10, #16]!
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
ldr r0, =0x3ccc1953
ldr r1, =0xcafebabe
ldr r2, =0x0000ffff
ldr r3, =0x631006f8
ldr r4, =0x95982ff2
ldr r5, =0x80000001
ldr r6, =0xeba8ba14
ldr r7, =0x3ccd16c2
ldr r8, =0x0000ffff
ldr r9, =0x646d9658
ldr r10, =0xa00e2a7b
ldr r11, =0xfb38106c
ldr r12, =0x00000020
ldr r14, =0x0000001f
cmp r5, r4
ldr r10, =0x1120
mov r9, #12
str r6, [r10], -r9
ldr r12, [r10], #20
strh r6, [r10], -r9
ldr r10, =0x1120
ldrsh r12, [r10, r9]
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
ldr r0, =0x00000020
ldr r1, =0x782dd7a2
ldr r2, =0x0309993f
ldr r3, =0x80000000
ldr r4, =0x9a2f2cdc
ldr r5, =0x00000021
ldr r6, =0x00000002
ldr r7, =0x7ffffffe
ldr r8, =0x04d47601
ldr r9, =0x6a3621d5
ldr r10, =0xcedc54af
ldr r11, =0xffffffff
ldr r12, =0x00000101
ldr r14, =0x7fffffff
cmn r9, r6
ldr r10, =0x1120
mov r9, #4
ldrb r4, [r10], #20
ldrsb r3, [r10, #8]!
str r2, [r10, #-8]
str r5, [r10], #0
ldr r10, =0x1120
strbpl r14, [r10, #2]
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
ldr r0, =0xffffffff
ldr r1, =0x0000001f
ldr r2, =0x00000021
ldr r3, =0x0000ffff
ldr r4, =0xd962b67c
ldr r5, =0x2f686c4c
ldr r6, =0x1b7ee079
ldr r7, =0x000000ff
ldr r8, =0x00000000
ldr r9, =0xcafebabe
ldr r10, =0x21a1ca9b
ldr r11, =0x12345678
ldr r12, =0x81164c1c
ldr r14, =0xe7ec3b6b
teq r4, r0
ldr r10, =0x1120
mov r9, #12
str r2, [r10], #4
ldrshls r14, [r10], -r9
str r3, [r10], #20
strlt r1, [r10, #-16]
str r2, [r10, -r9]
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
