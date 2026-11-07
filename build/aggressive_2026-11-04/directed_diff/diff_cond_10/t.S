.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000021
str r0, [r12, #0]
ldr r0, =0x00000020
str r0, [r12, #4]
ldr r0, =0x11cb3705
str r0, [r12, #8]
ldr r0, =0x61581f5b
str r0, [r12, #12]
ldr r0, =0xbad62420
str r0, [r12, #16]
ldr r0, =0x7dddec0f
str r0, [r12, #20]
ldr r0, =0xcafebabe
str r0, [r12, #24]
ldr r0, =0x00000100
str r0, [r12, #28]
ldr r0, =0xcd19c85c
str r0, [r12, #32]
ldr r0, =0x868ca590
str r0, [r12, #36]
ldr r0, =0x00000020
str r0, [r12, #40]
ldr r0, =0x00000020
str r0, [r12, #44]
ldr r0, =0x1f470f91
str r0, [r12, #48]
ldr r0, =0x00000001
str r0, [r12, #52]
ldr r0, =0x00000100
str r0, [r12, #56]
ldr r0, =0xcafebabe
str r0, [r12, #60]
ldr r0, =0x18f145fe
ldr r1, =0xf9a8b9e6
ldr r2, =0x16ce33f1
ldr r3, =0xe1ed1da9
ldr r4, =0x00000100
ldr r5, =0xcf03acf8
ldr r6, =0x80000001
ldr r7, =0x9cc6589e
ldr r8, =0x00000100
ldr r9, =0x31fa26c8
ldr r10, =0x7ed9ac7d
ldr r11, =0x12345678
ldr r12, =0x00000000
ldr r14, =0x00000020
cmp r10, r5
movls r0, #71
movcc r1, #179
movls r2, #7
movlt r3, #14
movhi r4, #192
moveq r5, #125
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
ldr r0, =0x7fffffff
ldr r1, =0xe82cfc40
ldr r2, =0x20c0645c
ldr r3, =0x1782a4bf
ldr r4, =0x00000100
ldr r5, =0x00000101
ldr r6, =0x47373e33
ldr r7, =0x00000101
ldr r8, =0x00000021
ldr r9, =0x00000000
ldr r10, =0x00000020
ldr r11, =0x80000000
ldr r12, =0x00000000
ldr r14, =0x7ffffffe
tst r1, r6
movne r0, #162
movne r1, #196
movcc r2, #140
movvs r3, #30
movgt r4, #144
movcc r5, #189
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
ldr r0, =0xa1bdb097
ldr r1, =0x80000000
ldr r2, =0xf12f7899
ldr r3, =0x00000000
ldr r4, =0x00000001
ldr r5, =0x2c9d8435
ldr r6, =0x7fffffff
ldr r7, =0x635f052e
ldr r8, =0xf588bba6
ldr r9, =0x00000002
ldr r10, =0x00000020
ldr r11, =0x00000002
ldr r12, =0x00000101
ldr r14, =0x00000002
teq r10, r9
movpl r0, #52
moveq r1, #10
movls r2, #4
moveq r3, #198
movlt r4, #178
movne r5, #193
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
ldr r0, =0x00000002
ldr r1, =0x00000021
ldr r2, =0x12345678
ldr r3, =0x00000000
ldr r4, =0x00000101
ldr r5, =0x000000ff
ldr r6, =0x00000001
ldr r7, =0x1ebdac28
ldr r8, =0xf6597ec8
ldr r9, =0x00000000
ldr r10, =0x31004533
ldr r11, =0x2b1fcd51
ldr r12, =0x7fffffff
ldr r14, =0xaa776e9d
cmp r10, r8
movvs r0, #11
movls r1, #79
moveq r2, #142
moveq r3, #39
movcc r4, #60
movmi r5, #112
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
ldr r0, =0xaa23185e
ldr r1, =0x80000001
ldr r2, =0xd5e04715
ldr r3, =0x0000001f
ldr r4, =0xee486c11
ldr r5, =0x2c2ad766
ldr r6, =0x7ffffffe
ldr r7, =0x9082ae8d
ldr r8, =0xfe2e4686
ldr r9, =0x80000001
ldr r10, =0x070a4904
ldr r11, =0xffffffff
ldr r12, =0x000000ff
ldr r14, =0x00000020
teq r8, r7
movge r0, #166
movgt r1, #84
movhi r2, #135
movls r3, #152
movge r4, #83
movls r5, #115
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
ldr r0, =0xfc439456
ldr r1, =0x3455506e
ldr r2, =0xcafebabe
ldr r3, =0x000000ff
ldr r4, =0x00000000
ldr r5, =0xe9dd0b08
ldr r6, =0xad4a613c
ldr r7, =0x672f9c4c
ldr r8, =0x80000001
ldr r9, =0x00000100
ldr r10, =0x342c9af6
ldr r11, =0xcadc151b
ldr r12, =0x573e7b18
ldr r14, =0x4ffc8251
cmn r5, r6
movle r0, #99
movvs r1, #10
movvs r2, #34
movle r3, #30
movne r4, #189
movgt r5, #192
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
ldr r0, =0x00000002
ldr r1, =0x80000001
ldr r2, =0x8ee7c96b
ldr r3, =0xffffffff
ldr r4, =0x1a4e7b1d
ldr r5, =0x0000001f
ldr r6, =0xffffffff
ldr r7, =0x0000001f
ldr r8, =0x6febb652
ldr r9, =0x0000001f
ldr r10, =0x0000001f
ldr r11, =0x80000001
ldr r12, =0x00000100
ldr r14, =0x7ffffffe
cmn r9, r9
movls r0, #188
moveq r1, #187
movne r2, #177
movhi r3, #81
movge r4, #132
movcs r5, #113
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
ldr r0, =0x03191298
ldr r1, =0x0000ffff
ldr r2, =0x000000ff
ldr r3, =0x7ffffffe
ldr r4, =0x0000ffff
ldr r5, =0xc3ec6947
ldr r6, =0x460c505b
ldr r7, =0x98983e46
ldr r8, =0x0000ffff
ldr r9, =0x700efa02
ldr r10, =0xbb73f44c
ldr r11, =0x00000100
ldr r12, =0x00000101
ldr r14, =0xac3495d7
tst r14, r2
moveq r0, #82
movle r1, #92
movvs r2, #29
movgt r3, #143
movlt r4, #138
movmi r5, #71
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
