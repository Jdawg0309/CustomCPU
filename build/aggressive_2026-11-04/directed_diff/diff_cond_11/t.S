.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x6a7f7e08
str r0, [r12, #0]
ldr r0, =0xfa483398
str r0, [r12, #4]
ldr r0, =0x00000101
str r0, [r12, #8]
ldr r0, =0x000000ff
str r0, [r12, #12]
ldr r0, =0xa4285f8c
str r0, [r12, #16]
ldr r0, =0x82f188a9
str r0, [r12, #20]
ldr r0, =0xffffffff
str r0, [r12, #24]
ldr r0, =0x9ac031fa
str r0, [r12, #28]
ldr r0, =0x4c0f7d9c
str r0, [r12, #32]
ldr r0, =0xd51aba4e
str r0, [r12, #36]
ldr r0, =0x8aea81ba
str r0, [r12, #40]
ldr r0, =0x87e18ef9
str r0, [r12, #44]
ldr r0, =0x00000001
str r0, [r12, #48]
ldr r0, =0x2e4344cb
str r0, [r12, #52]
ldr r0, =0x00000021
str r0, [r12, #56]
ldr r0, =0xc5f272e1
str r0, [r12, #60]
ldr r0, =0x07762ed6
ldr r1, =0xcf828845
ldr r2, =0x00000101
ldr r3, =0x00000000
ldr r4, =0xcafebabe
ldr r5, =0x93c627d7
ldr r6, =0xef47d0d4
ldr r7, =0x00000002
ldr r8, =0x65f9c1ca
ldr r9, =0x00000001
ldr r10, =0x332dc2fd
ldr r11, =0x00000101
ldr r12, =0x66ebfd08
ldr r14, =0x00000101
tst r14, r4
movvs r0, #68
movls r1, #22
movhi r2, #101
movvs r3, #111
movhi r4, #130
movmi r5, #130
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
ldr r0, =0x1da3eb2a
ldr r1, =0xd4e547d0
ldr r2, =0xcafebabe
ldr r3, =0x23402740
ldr r4, =0xaec280e3
ldr r5, =0x00000001
ldr r6, =0x000000ff
ldr r7, =0x77438922
ldr r8, =0x53e27cf2
ldr r9, =0x58faf8a4
ldr r10, =0x80000001
ldr r11, =0x1345e8b8
ldr r12, =0x391782da
ldr r14, =0x00000002
teq r5, r9
movcc r0, #75
movlt r1, #165
movcs r2, #176
movvc r3, #54
movpl r4, #132
movle r5, #64
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
ldr r1, =0x67b12bdd
ldr r2, =0x24d0d9bf
ldr r3, =0x00000002
ldr r4, =0x00000021
ldr r5, =0x00000002
ldr r6, =0xcf34d9f0
ldr r7, =0x064b6bf6
ldr r8, =0xfbf1ef6b
ldr r9, =0x03bb7631
ldr r10, =0x00000001
ldr r11, =0xcafebabe
ldr r12, =0x00000020
ldr r14, =0x80000001
teq r1, r8
movhi r0, #36
movle r1, #46
movvc r2, #180
movhi r3, #186
movge r4, #42
movhi r5, #170
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
ldr r0, =0x5ba6fa08
ldr r1, =0xcafebabe
ldr r2, =0x7fffffff
ldr r3, =0x00000000
ldr r4, =0x51de208f
ldr r5, =0x00000020
ldr r6, =0x80000000
ldr r7, =0x00000001
ldr r8, =0xc1fde2c4
ldr r9, =0x120ccc33
ldr r10, =0x66e74680
ldr r11, =0x7fffffff
ldr r12, =0x7ffffffe
ldr r14, =0xffffffff
cmn r10, r2
movcs r0, #8
movgt r1, #173
movlt r2, #142
movvs r3, #178
movle r4, #183
movvs r5, #60
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
ldr r0, =0x000000ff
ldr r1, =0x00000000
ldr r2, =0x00000100
ldr r3, =0x1e92960b
ldr r4, =0x00000021
ldr r5, =0x984b157c
ldr r6, =0x00000000
ldr r7, =0xcafebabe
ldr r8, =0x80000001
ldr r9, =0x00000101
ldr r10, =0x00000000
ldr r11, =0x880d455b
ldr r12, =0x00000020
ldr r14, =0x00000020
tst r9, r8
movne r0, #182
movvs r1, #152
movpl r2, #123
movpl r3, #18
movgt r4, #173
movge r5, #63
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
ldr r1, =0xc14ca814
ldr r2, =0x9741f8ed
ldr r3, =0x00000000
ldr r4, =0x80000001
ldr r5, =0x7b2f2d2a
ldr r6, =0xe8b7b470
ldr r7, =0x0000001f
ldr r8, =0x12345678
ldr r9, =0x7b302143
ldr r10, =0x00000021
ldr r11, =0x0000ffff
ldr r12, =0x6caf67f6
ldr r14, =0x9a48d4ad
tst r6, r11
movne r0, #75
movgt r1, #141
movmi r2, #151
movcs r3, #6
movcs r4, #147
movge r5, #85
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
ldr r0, =0x16a676b6
ldr r1, =0x00000021
ldr r2, =0x80000000
ldr r3, =0xd672b2c2
ldr r4, =0x662ed8b2
ldr r5, =0xffffffff
ldr r6, =0x00000002
ldr r7, =0x07bade6a
ldr r8, =0x7fffffff
ldr r9, =0xc8c1151f
ldr r10, =0x80000000
ldr r11, =0x596e77fe
ldr r12, =0xbfe70502
ldr r14, =0xd54c3ecf
cmn r2, r10
movlt r0, #47
movcs r1, #172
movmi r2, #29
movcc r3, #52
movls r4, #14
movne r5, #104
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
ldr r1, =0xffffffff
ldr r2, =0x00000000
ldr r3, =0x8153510c
ldr r4, =0xf019ca7c
ldr r5, =0x12345678
ldr r6, =0xd4c3d128
ldr r7, =0x9dabcffe
ldr r8, =0xffffffff
ldr r9, =0x7fffffff
ldr r10, =0x7478b3b0
ldr r11, =0xbcdc7fa6
ldr r12, =0x84540932
ldr r14, =0xf369123b
teq r6, r1
movmi r0, #7
movhi r1, #4
movvs r2, #157
movne r3, #9
movlt r4, #167
moveq r5, #56
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
