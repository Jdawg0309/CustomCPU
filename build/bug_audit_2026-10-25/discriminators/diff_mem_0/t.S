.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x9af013ff
str r0, [r12, #0]
ldr r0, =0xf148947f
str r0, [r12, #4]
ldr r0, =0x7548dc6f
str r0, [r12, #8]
ldr r0, =0x80000000
str r0, [r12, #12]
ldr r0, =0x9e76b5f9
str r0, [r12, #16]
ldr r0, =0x00000101
str r0, [r12, #20]
ldr r0, =0xc048381e
str r0, [r12, #24]
ldr r0, =0x00000100
str r0, [r12, #28]
ldr r0, =0xacd44732
str r0, [r12, #32]
ldr r0, =0x57e8f149
str r0, [r12, #36]
ldr r0, =0x7fffffff
str r0, [r12, #40]
ldr r0, =0x00000101
str r0, [r12, #44]
ldr r0, =0x01a7837c
str r0, [r12, #48]
ldr r0, =0x000000ff
str r0, [r12, #52]
ldr r0, =0x80000000
str r0, [r12, #56]
ldr r0, =0x00000100
str r0, [r12, #60]
ldr r0, =0xffffffff
ldr r1, =0xca6adb90
ldr r2, =0x00000002
ldr r3, =0x0000ffff
ldr r4, =0x135af691
ldr r5, =0x00000021
ldr r6, =0xac0ed481
ldr r7, =0x00000001
ldr r8, =0x00000001
ldr r9, =0x88330eb8
ldr r10, =0x000000ff
ldr r11, =0x9e1bc2b9
ldr r12, =0x00000002
ldr r14, =0x80000001
cmp r6, r8
ldr r10, =0x1120
mov r9, #4
ldr r3, [r10, #24]
ldrhlt r14, [r10, #16]!
ldr r10, =0x1120
strb r3, [r10, #-16]
str r8, [r10, #-12]
str r14, [r10, #-24]
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
ldr r0, =0x0000001f
ldr r1, =0xb0c3000e
ldr r2, =0xf273d57e
ldr r3, =0x80eff3d7
ldr r4, =0x7fffffff
ldr r5, =0x5131ead1
ldr r6, =0x12345678
ldr r7, =0x5a067d63
ldr r8, =0x141a5cca
ldr r9, =0xb11d9f2b
ldr r10, =0x1eac47f5
ldr r11, =0x00000101
ldr r12, =0xa3d437a2
ldr r14, =0xe2b6e665
cmp r5, r2
ldr r10, =0x1120
mov r9, #12
ldr r1, [r10], -r9
ldrsb r6, [r10, #12]!
ldrb r14, [r10, #4]!
ldr r10, =0x1120
ldr r7, [r10], -r9
ldr r10, =0x1120
ldrb r6, [r10, #9]
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
ldr r0, =0x89d0b3ed
ldr r1, =0x00000001
ldr r2, =0x0000001f
ldr r3, =0x9e5a7ed3
ldr r4, =0x00000021
ldr r5, =0x857d882e
ldr r6, =0xf743dff9
ldr r7, =0x00000100
ldr r8, =0x0000ffff
ldr r9, =0x3602b64e
ldr r10, =0x00000021
ldr r11, =0x10b8cc1f
ldr r12, =0x00000002
ldr r14, =0x0000001f
cmn r12, r14
ldr r10, =0x1120
mov r9, #4
str r2, [r10], -r9
ldr r6, [r10], -r9
ldr r10, =0x1120
strb r7, [r10], #16
ldrh r14, [r10], -r9
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
ldr r1, =0x00000000
ldr r2, =0x7ffffffe
ldr r3, =0xd4e43b57
ldr r4, =0xcb68e62d
ldr r5, =0x7b276ddf
ldr r6, =0x4a0048b6
ldr r7, =0xfefa08d7
ldr r8, =0xa4065422
ldr r9, =0x00000020
ldr r10, =0x0000ffff
ldr r11, =0xb9aed04c
ldr r12, =0x1f01fa8d
ldr r14, =0x00000020
cmp r11, r7
ldr r10, =0x1120
mov r9, #12
strb r3, [r10, r9]
strb r4, [r10], #16
ldrsb r7, [r10, #-10]
ldr r14, [r10, #-4]
strh r14, [r10, #4]
strpl r2, [r10, -r9]
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
ldr r0, =0x553d7dff
ldr r1, =0x7ffffffe
ldr r2, =0x0556e4ec
ldr r3, =0x485288a6
ldr r4, =0x00000100
ldr r5, =0x00000020
ldr r6, =0x00000020
ldr r7, =0x0000001f
ldr r8, =0x00000002
ldr r9, =0xd3c3fada
ldr r10, =0x00000020
ldr r11, =0x00000020
ldr r12, =0xbf5d99b9
ldr r14, =0x00000021
teq r3, r4
ldr r10, =0x1120
mov r9, #16
ldrsh r7, [r10, -r9]
ldrsb r6, [r10, #-15]
str r4, [r10, -r9]
ldr r10, =0x1120
str r8, [r10], -r9
ldr r10, =0x1120
ldr r14, [r10, #-16]
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
ldr r0, =0x000000ff
ldr r1, =0xc1b0089b
ldr r2, =0x7ffffffe
ldr r3, =0x5fc59479
ldr r4, =0x235bf39a
ldr r5, =0xb3645fa3
ldr r6, =0x00000100
ldr r7, =0x5166ed11
ldr r8, =0xdad764da
ldr r9, =0x4771f314
ldr r10, =0x7ffffffe
ldr r11, =0x00000002
ldr r12, =0xed4c4d5e
ldr r14, =0x7fffffff
tst r8, r11
ldr r10, =0x1120
mov r9, #8
strhne r14, [r10, -r9]
ldrhge r4, [r10, #0]
strvs r11, [r10, #-28]
ldrh r4, [r10, -r9]
ldrsh r0, [r10, -r9]
ldr r10, =0x1120
ldrsb r2, [r10, #-17]
ldr r10, =0x1120
ldrsb r4, [r10, r9]
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
ldr r0, =0x718a1606
ldr r1, =0x97de6061
ldr r2, =0x00000020
ldr r3, =0x860a1231
ldr r4, =0x2837543b
ldr r5, =0xcafebabe
ldr r6, =0x63d65a16
ldr r7, =0x7fffffff
ldr r8, =0x0000001f
ldr r9, =0x12345678
ldr r10, =0x12345678
ldr r11, =0x80000001
ldr r12, =0x00000100
ldr r14, =0x00000001
cmn r11, r1
ldr r10, =0x1120
mov r9, #12
ldr r1, [r10], #12
ldr r10, =0x1120
strb r14, [r10, #8]!
str r3, [r10, #16]
ldrsb r7, [r10], #12
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
ldr r0, =0x9a1a8087
ldr r1, =0x80000000
ldr r2, =0xb720b99e
ldr r3, =0x80000001
ldr r4, =0x0784d1e6
ldr r5, =0x00000020
ldr r6, =0xfceaa8b8
ldr r7, =0x4b85d9c6
ldr r8, =0x00000020
ldr r9, =0x186cf9e1
ldr r10, =0x0000001f
ldr r11, =0x12345678
ldr r12, =0x4a95712c
ldr r14, =0x00000021
cmp r11, r2
ldr r10, =0x1120
mov r9, #0
ldrsb r0, [r10, #16]!
str r12, [r10, #-12]
ldrble r2, [r10, #16]!
ldr r10, =0x1120
str r5, [r10], -r9
ldrh r14, [r10], #8
strh r4, [r10, r9]
ldrh r1, [r10, #-8]
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
