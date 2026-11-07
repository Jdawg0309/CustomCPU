.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x1942f941
str r0, [r12, #0]
ldr r0, =0x8a900557
str r0, [r12, #4]
ldr r0, =0x00000100
str r0, [r12, #8]
ldr r0, =0x00000000
str r0, [r12, #12]
ldr r0, =0xb25292c2
str r0, [r12, #16]
ldr r0, =0x7ffffffe
str r0, [r12, #20]
ldr r0, =0xb55ecc18
str r0, [r12, #24]
ldr r0, =0x7fffffff
str r0, [r12, #28]
ldr r0, =0x0000ffff
str r0, [r12, #32]
ldr r0, =0x00000001
str r0, [r12, #36]
ldr r0, =0x7a9e1bc9
str r0, [r12, #40]
ldr r0, =0x3538787e
str r0, [r12, #44]
ldr r0, =0x3c8645e7
str r0, [r12, #48]
ldr r0, =0x00000002
str r0, [r12, #52]
ldr r0, =0xcef0c09b
str r0, [r12, #56]
ldr r0, =0x1c3e68d0
str r0, [r12, #60]
ldr r0, =0x98e6c272
ldr r1, =0x00000001
ldr r2, =0x12345678
ldr r3, =0xf6ae0415
ldr r4, =0xffffffff
ldr r5, =0xcafebabe
ldr r6, =0x1d326678
ldr r7, =0xbc306926
ldr r8, =0x80000000
ldr r9, =0x0000001f
ldr r10, =0x5291ab9f
ldr r11, =0x80000000
ldr r12, =0x7206f261
ldr r14, =0x0f454889
teq r3, r5
movle r0, #154
movvc r1, #154
movcs r2, #152
movvs r3, #121
movvc r4, #4
movmi r5, #58
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
ldr r0, =0x00000100
ldr r1, =0x00000002
ldr r2, =0x4d397161
ldr r3, =0x12345678
ldr r4, =0x00000002
ldr r5, =0xc1546659
ldr r6, =0x181f5b7b
ldr r7, =0xd922ac41
ldr r8, =0xcbd11593
ldr r9, =0x00000001
ldr r10, =0x713f353c
ldr r11, =0x000000ff
ldr r12, =0x5522d937
ldr r14, =0x7fffffff
cmn r0, r1
movmi r0, #82
movgt r1, #109
movgt r2, #157
movhi r3, #166
movle r4, #192
movhi r5, #34
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
ldr r0, =0x80000000
ldr r1, =0x80c7a724
ldr r2, =0x0000001f
ldr r3, =0x7280ecbb
ldr r4, =0x113fe0fc
ldr r5, =0xd15ab4f9
ldr r6, =0x01fc298e
ldr r7, =0xcafebabe
ldr r8, =0x79bba6a1
ldr r9, =0x12345678
ldr r10, =0x779a2ae5
ldr r11, =0x000000ff
ldr r12, =0x00000000
ldr r14, =0xfafbc817
cmn r11, r8
movlt r0, #74
movle r1, #31
movvs r2, #7
movne r3, #150
movhi r4, #37
movhi r5, #138
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
ldr r0, =0x996f0526
ldr r1, =0x00000020
ldr r2, =0xffffffff
ldr r3, =0xf02b4133
ldr r4, =0x00000021
ldr r5, =0x7cd62ff7
ldr r6, =0xffffffff
ldr r7, =0x80000000
ldr r8, =0x12345678
ldr r9, =0x0000ffff
ldr r10, =0x2293b6ab
ldr r11, =0x0000ffff
ldr r12, =0x7fffffff
ldr r14, =0x80000001
teq r2, r0
moveq r0, #133
movvc r1, #85
movcs r2, #168
movne r3, #44
movmi r4, #34
movlt r5, #64
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
ldr r1, =0x00000001
ldr r2, =0x9eb62f72
ldr r3, =0x00000101
ldr r4, =0x75723ed4
ldr r5, =0x00000020
ldr r6, =0xd419c6e5
ldr r7, =0x7fffffff
ldr r8, =0x00000000
ldr r9, =0x2bf3830b
ldr r10, =0xcb183a3d
ldr r11, =0xd6b5233e
ldr r12, =0xffc55f05
ldr r14, =0xdcafa6df
teq r3, r5
movge r0, #69
movls r1, #176
movhi r2, #85
movhi r3, #58
movmi r4, #55
movle r5, #184
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
ldr r0, =0x6af7c840
ldr r1, =0xffffffff
ldr r2, =0x00000020
ldr r3, =0x0e1a7def
ldr r4, =0x76b22c81
ldr r5, =0x55df3e57
ldr r6, =0x17d7a1b9
ldr r7, =0x0000001f
ldr r8, =0x0000ffff
ldr r9, =0x1d01f871
ldr r10, =0xd94b8360
ldr r11, =0xb246bbcc
ldr r12, =0x3588415a
ldr r14, =0x08308c3c
cmp r4, r1
movvs r0, #22
movmi r1, #95
movvs r2, #184
moveq r3, #189
movlt r4, #49
movgt r5, #149
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
ldr r0, =0x0000001f
ldr r1, =0x000000ff
ldr r2, =0x80000000
ldr r3, =0x7fffffff
ldr r4, =0x00000100
ldr r5, =0x00000021
ldr r6, =0x00000002
ldr r7, =0xf40bc6da
ldr r8, =0x000000ff
ldr r9, =0x7d716ffa
ldr r10, =0x12345678
ldr r11, =0x1050ba3b
ldr r12, =0x00000000
ldr r14, =0x0000ffff
teq r5, r11
movcc r0, #39
movmi r1, #72
movpl r2, #19
movpl r3, #33
moveq r4, #74
movmi r5, #119
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
ldr r0, =0xcafebabe
ldr r1, =0x49e3e276
ldr r2, =0x2d9b5934
ldr r3, =0x8c1cce45
ldr r4, =0x67254d5f
ldr r5, =0x7fffffff
ldr r6, =0x0000ffff
ldr r7, =0x714868e8
ldr r8, =0xfc287ccc
ldr r9, =0xca36006d
ldr r10, =0x00000100
ldr r11, =0xea5f642e
ldr r12, =0x000000ff
ldr r14, =0x57e9445d
cmp r2, r11
moveq r0, #55
movle r1, #103
movcc r2, #66
movmi r3, #75
movvs r4, #47
movmi r5, #11
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
