.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000100
str r0, [r12, #0]
ldr r0, =0x7fffffff
str r0, [r12, #4]
ldr r0, =0x7ffffffe
str r0, [r12, #8]
ldr r0, =0x175fc022
str r0, [r12, #12]
ldr r0, =0xcb577cde
str r0, [r12, #16]
ldr r0, =0x00000021
str r0, [r12, #20]
ldr r0, =0x00000020
str r0, [r12, #24]
ldr r0, =0x9e54bf46
str r0, [r12, #28]
ldr r0, =0xf6546954
str r0, [r12, #32]
ldr r0, =0xf9ed337f
str r0, [r12, #36]
ldr r0, =0xcc7484f9
str r0, [r12, #40]
ldr r0, =0x8abee0f8
str r0, [r12, #44]
ldr r0, =0xbb728e54
str r0, [r12, #48]
ldr r0, =0x00000101
str r0, [r12, #52]
ldr r0, =0xffffffff
str r0, [r12, #56]
ldr r0, =0xf7c4af25
str r0, [r12, #60]
ldr r0, =0x1f577c39
ldr r1, =0x7c8a5f89
ldr r2, =0x80000001
ldr r3, =0x7caa4ba8
ldr r4, =0x1964ceb1
ldr r5, =0x00000001
ldr r6, =0x1e9ff02b
ldr r7, =0xe04a89a8
ldr r8, =0xf1eed083
ldr r9, =0x3b858668
ldr r10, =0x12345678
ldr r11, =0x00000101
ldr r12, =0x00000000
ldr r14, =0x00000002
cmp r10, r10
movls r0, #180
movvc r1, #182
movle r2, #5
movne r3, #166
movge r4, #195
movlt r5, #167
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
ldr r0, =0xba6e89b1
ldr r1, =0x23d0330a
ldr r2, =0x1739571e
ldr r3, =0x00000101
ldr r4, =0x7ffffffe
ldr r5, =0xd2cbf627
ldr r6, =0x93e174c3
ldr r7, =0xcafebabe
ldr r8, =0xd351493b
ldr r9, =0x3c14c17e
ldr r10, =0xc8140c01
ldr r11, =0xc26efecc
ldr r12, =0xfc19a45a
ldr r14, =0x00000101
tst r4, r9
moveq r0, #82
movmi r1, #20
movle r2, #184
movle r3, #131
movvc r4, #77
movhi r5, #177
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
ldr r0, =0x00000000
ldr r1, =0xe0a18e9b
ldr r2, =0x7ffffffe
ldr r3, =0x12345678
ldr r4, =0xf95b4872
ldr r5, =0xffffffff
ldr r6, =0x00000020
ldr r7, =0x6764d104
ldr r8, =0x16f5d3c9
ldr r9, =0xfa8fae2c
ldr r10, =0xc465c893
ldr r11, =0x0000ffff
ldr r12, =0x59781b28
ldr r14, =0x80000000
cmn r3, r7
movgt r0, #3
movpl r1, #181
movls r2, #180
movmi r3, #54
movlt r4, #53
movvs r5, #70
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
ldr r0, =0x00000000
ldr r1, =0x015c013b
ldr r2, =0x04b36ea6
ldr r3, =0xcbbb5169
ldr r4, =0x0370ff99
ldr r5, =0xdb7a679b
ldr r6, =0xc294dbbd
ldr r7, =0x00000101
ldr r8, =0xad4b29a8
ldr r9, =0xcc4e5c12
ldr r10, =0x00000101
ldr r11, =0x7bc42fb3
ldr r12, =0xbdee265e
ldr r14, =0x144064ae
cmn r2, r2
movcc r0, #132
movcs r1, #59
movls r2, #169
movge r3, #33
movcc r4, #35
movlt r5, #78
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
ldr r0, =0x34d544c8
ldr r1, =0x0000001f
ldr r2, =0x4a5e3206
ldr r3, =0xb69affce
ldr r4, =0x2cbc5811
ldr r5, =0x59d38b61
ldr r6, =0x7fffffff
ldr r7, =0x37b3f97d
ldr r8, =0x0000ffff
ldr r9, =0x98ef6188
ldr r10, =0x35431409
ldr r11, =0x82cfa97c
ldr r12, =0x44420d54
ldr r14, =0x88633ee0
teq r14, r2
movcs r0, #24
movle r1, #83
movmi r2, #150
movls r3, #125
movle r4, #51
movvc r5, #2
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
ldr r0, =0xad314a45
ldr r1, =0x0c67b9ae
ldr r2, =0xcafebabe
ldr r3, =0x80000001
ldr r4, =0x00000020
ldr r5, =0xbf03c4a9
ldr r6, =0x0000ffff
ldr r7, =0xe152a28f
ldr r8, =0x6e46c7ae
ldr r9, =0xffffffff
ldr r10, =0x7ffffffe
ldr r11, =0xe358804c
ldr r12, =0x0000ffff
ldr r14, =0x0eee95fb
cmn r12, r10
movpl r0, #57
movge r1, #142
movpl r2, #187
movlt r3, #39
movlt r4, #115
movcc r5, #144
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
ldr r1, =0x41a515db
ldr r2, =0xcc70b262
ldr r3, =0xcbc96aff
ldr r4, =0x29e94a07
ldr r5, =0x00000020
ldr r6, =0x9ed33441
ldr r7, =0x08a62aa9
ldr r8, =0x66cf0199
ldr r9, =0x57613039
ldr r10, =0x12345678
ldr r11, =0x53024ee8
ldr r12, =0x00000101
ldr r14, =0x00000100
tst r3, r5
movpl r0, #157
movcc r1, #128
movge r2, #105
movgt r3, #184
movle r4, #143
movge r5, #30
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
ldr r0, =0xf36cc00a
ldr r1, =0x583dd05b
ldr r2, =0xf24e034e
ldr r3, =0xd71860b3
ldr r4, =0x04532904
ldr r5, =0x00000100
ldr r6, =0x00000000
ldr r7, =0xffffffff
ldr r8, =0x0a8b3aaa
ldr r9, =0x6a472acc
ldr r10, =0x034f26c8
ldr r11, =0x00000100
ldr r12, =0x064e3b05
ldr r14, =0xcafebabe
teq r1, r11
movle r0, #35
movge r1, #127
movpl r2, #48
movcs r3, #96
movcc r4, #179
movmi r5, #177
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
