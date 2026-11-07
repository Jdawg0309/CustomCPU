.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x8750297f
str r0, [r12, #0]
ldr r0, =0xaa792ece
str r0, [r12, #4]
ldr r0, =0x2ff4041a
str r0, [r12, #8]
ldr r0, =0xffffffff
str r0, [r12, #12]
ldr r0, =0x7ffffffe
str r0, [r12, #16]
ldr r0, =0x7fffffff
str r0, [r12, #20]
ldr r0, =0xfd0a602f
str r0, [r12, #24]
ldr r0, =0x12345678
str r0, [r12, #28]
ldr r0, =0x3a6e01aa
str r0, [r12, #32]
ldr r0, =0x7669ef16
str r0, [r12, #36]
ldr r0, =0x74b15210
str r0, [r12, #40]
ldr r0, =0x80000001
str r0, [r12, #44]
ldr r0, =0x00000000
str r0, [r12, #48]
ldr r0, =0xd69a3c5c
str r0, [r12, #52]
ldr r0, =0x8f0664cf
str r0, [r12, #56]
ldr r0, =0x00000021
str r0, [r12, #60]
ldr r0, =0xffffffff
ldr r1, =0x000000ff
ldr r2, =0x00000101
ldr r3, =0xef9b6dd8
ldr r4, =0x80000000
ldr r5, =0x00000021
ldr r6, =0x00000020
ldr r7, =0x0000ffff
ldr r8, =0x452e95b2
ldr r9, =0xffffffff
ldr r10, =0x00000100
ldr r11, =0x55cf8a13
ldr r12, =0xffffffff
ldr r14, =0xc0e46bb3
cmn r9, r10
movcs r0, #179
movge r1, #198
movls r2, #39
movgt r3, #145
movne r4, #157
movne r5, #99
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
ldr r0, =0x40f0d30a
ldr r1, =0xcafebabe
ldr r2, =0x00000100
ldr r3, =0xcafebabe
ldr r4, =0xcafebabe
ldr r5, =0x2f28cd7d
ldr r6, =0xf2fceddc
ldr r7, =0x00000000
ldr r8, =0xffffffff
ldr r9, =0x7ffffffe
ldr r10, =0x7ffffffe
ldr r11, =0x00000002
ldr r12, =0x000000ff
ldr r14, =0x31e312f2
cmp r0, r0
movcs r0, #78
movvs r1, #118
movls r2, #24
movge r3, #49
movge r4, #16
movls r5, #64
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
ldr r0, =0xcafebabe
ldr r1, =0x4a1c838c
ldr r2, =0x00000000
ldr r3, =0x831f5d66
ldr r4, =0x12345678
ldr r5, =0x0000001f
ldr r6, =0xcafebabe
ldr r7, =0x12345678
ldr r8, =0x93b6cade
ldr r9, =0x5152c529
ldr r10, =0x38ae3792
ldr r11, =0x7fffffff
ldr r12, =0x854ff171
ldr r14, =0xd9920718
teq r6, r11
movhi r0, #66
movlt r1, #189
movvs r2, #30
movpl r3, #115
movlt r4, #108
movls r5, #131
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
ldr r0, =0x7295b57c
ldr r1, =0x7ffffffe
ldr r2, =0xa64a2f76
ldr r3, =0xc704d972
ldr r4, =0xd3f482ac
ldr r5, =0xcff7cd74
ldr r6, =0xee3cf39a
ldr r7, =0x4e388b96
ldr r8, =0x00000100
ldr r9, =0x0000ffff
ldr r10, =0x000000ff
ldr r11, =0x000000ff
ldr r12, =0xa0a4962d
ldr r14, =0x00000020
teq r10, r1
movvs r0, #63
movvs r1, #112
movge r2, #199
movmi r3, #190
moveq r4, #68
movmi r5, #118
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
ldr r0, =0x4c650ac2
ldr r1, =0x989bc111
ldr r2, =0x7fffffff
ldr r3, =0xa2903a9d
ldr r4, =0x495def64
ldr r5, =0x7ffffffe
ldr r6, =0xcf3cbcc5
ldr r7, =0x562ed34e
ldr r8, =0xb43fb0b9
ldr r9, =0x00000021
ldr r10, =0x00000000
ldr r11, =0x00000002
ldr r12, =0x00000020
ldr r14, =0xda580385
teq r7, r7
movpl r0, #106
movcc r1, #55
movgt r2, #190
movpl r3, #194
movls r4, #179
movpl r5, #96
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
ldr r0, =0xba057fb0
ldr r1, =0xc6250423
ldr r2, =0xcafebabe
ldr r3, =0xa495558f
ldr r4, =0x3a4235ad
ldr r5, =0x00000101
ldr r6, =0xebbba331
ldr r7, =0x7fffffff
ldr r8, =0x1722315f
ldr r9, =0x80000000
ldr r10, =0xc69e132d
ldr r11, =0x70ed9d29
ldr r12, =0x00000020
ldr r14, =0x56369797
tst r3, r9
movgt r0, #165
movge r1, #178
movcc r2, #16
movne r3, #23
movlt r4, #47
movne r5, #66
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
ldr r0, =0x629b84ae
ldr r1, =0x000000ff
ldr r2, =0xe8ed88d3
ldr r3, =0x00000002
ldr r4, =0x9613e5fa
ldr r5, =0x00000021
ldr r6, =0x000000ff
ldr r7, =0x80000000
ldr r8, =0x00000021
ldr r9, =0x7ffffffe
ldr r10, =0x0000001f
ldr r11, =0x00000002
ldr r12, =0xcfb5c8ec
ldr r14, =0x00000100
tst r10, r7
movgt r0, #142
movgt r1, #44
movvc r2, #110
movmi r3, #188
movls r4, #124
movhi r5, #131
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
ldr r0, =0x00000000
ldr r1, =0x9b7807a9
ldr r2, =0x41ef9084
ldr r3, =0x7fffffff
ldr r4, =0x6f86459f
ldr r5, =0xe6c299da
ldr r6, =0x00000101
ldr r7, =0x00000002
ldr r8, =0xffffffff
ldr r9, =0x12345678
ldr r10, =0xba484bc6
ldr r11, =0xcafebabe
ldr r12, =0xbce82b70
ldr r14, =0x333db078
tst r6, r7
movvc r0, #107
movvc r1, #36
movmi r2, #157
movcs r3, #167
moveq r4, #11
movge r5, #118
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
