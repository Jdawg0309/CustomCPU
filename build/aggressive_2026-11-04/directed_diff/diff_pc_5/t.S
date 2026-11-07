.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000001
str r0, [r12, #0]
ldr r0, =0x490d5d7d
str r0, [r12, #4]
ldr r0, =0x232c511c
str r0, [r12, #8]
ldr r0, =0xffffffff
str r0, [r12, #12]
ldr r0, =0x12345678
str r0, [r12, #16]
ldr r0, =0xc691956b
str r0, [r12, #20]
ldr r0, =0xdb015732
str r0, [r12, #24]
ldr r0, =0x66c0b677
str r0, [r12, #28]
ldr r0, =0xff53677c
str r0, [r12, #32]
ldr r0, =0xce844b58
str r0, [r12, #36]
ldr r0, =0x00000001
str r0, [r12, #40]
ldr r0, =0x7fffffff
str r0, [r12, #44]
ldr r0, =0x7fffffff
str r0, [r12, #48]
ldr r0, =0x0000001f
str r0, [r12, #52]
ldr r0, =0xf4498f5c
str r0, [r12, #56]
ldr r0, =0xe56ce000
str r0, [r12, #60]
ldr r0, =0x12345678
ldr r1, =0x379b52f3
ldr r2, =0x00000002
ldr r3, =0x32a539d2
ldr r4, =0x7ffffffe
ldr r5, =0xbd4d204b
ldr r6, =0x0000ffff
ldr r7, =0x00000021
ldr r8, =0x7fffffff
ldr r9, =0x8fff4426
ldr r10, =0x0e87d979
ldr r11, =0xf4788bb5
ldr r12, =0x000000ff
ldr r14, =0x00000002
cmn r11, r4
ldr pc, =1f
add r0, r0, #3
1:
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
ldr r0, =0x9e9d5a97
ldr r1, =0x922c5c43
ldr r2, =0xcafebabe
ldr r3, =0x00000002
ldr r4, =0xe9f92e0e
ldr r5, =0x80000001
ldr r6, =0x6710be42
ldr r7, =0x7ffffffe
ldr r8, =0x00000002
ldr r9, =0x2dacf9a2
ldr r10, =0xffffffff
ldr r11, =0x7ffffffe
ldr r12, =0x5d3d00a0
ldr r14, =0x0aaff49e
tst r9, r6
ldr r10, =0x1120
adr r3, 1f
str r3, [r10, #4]
ldmia r10, {r4, pc}
add r0, r0, #7
1:
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
ldr r0, =0x00000100
ldr r1, =0x95f3fd2c
ldr r2, =0x00000021
ldr r3, =0x13530e22
ldr r4, =0x4829677d
ldr r5, =0x7fffffff
ldr r6, =0xd8c9cd8a
ldr r7, =0x3139e411
ldr r8, =0x00000021
ldr r9, =0x342cae42
ldr r10, =0x00000002
ldr r11, =0x00000000
ldr r12, =0xa0e18473
ldr r14, =0x00000000
teq r3, r1
cmp pc, r4
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
ldr r0, =0x7fffffff
ldr r1, =0x73883e9a
ldr r2, =0x1e713bec
ldr r3, =0x00000020
ldr r4, =0x7bc2f176
ldr r5, =0x000000ff
ldr r6, =0xda4c2e24
ldr r7, =0x42be2d74
ldr r8, =0xc7635e3e
ldr r9, =0x76211100
ldr r10, =0x402fe351
ldr r11, =0x306b5be5
ldr r12, =0x01c06f79
ldr r14, =0x00000002
cmp r6, r10
ldrb r0, [pc, #-7]
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
ldr r0, =0x05c09597
ldr r1, =0xc0dc9cab
ldr r2, =0x000000ff
ldr r3, =0x00000002
ldr r4, =0x00000000
ldr r5, =0xcafebabe
ldr r6, =0xbb0fc5b3
ldr r7, =0x80000000
ldr r8, =0x0000ffff
ldr r9, =0x09e65286
ldr r10, =0x000000ff
ldr r11, =0x00000101
ldr r12, =0x8c95db32
ldr r14, =0x4f05a4b5
cmp r9, r8
add r6, pc, #16
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
ldr r0, =0x9dd08684
ldr r1, =0x00000001
ldr r2, =0xffffffff
ldr r3, =0xe3bcb3e1
ldr r4, =0xa5f43420
ldr r5, =0x000000ff
ldr r6, =0x7ffffffe
ldr r7, =0x6aae642f
ldr r8, =0x024eb1a3
ldr r9, =0x80000001
ldr r10, =0x00000000
ldr r11, =0x0000001f
ldr r12, =0x80375ffb
ldr r14, =0x00000101
teq r12, r9
ldr r4, [pc, #-8]
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
ldr r0, =0xd32d5b91
ldr r1, =0xf72f49d1
ldr r2, =0x00000100
ldr r3, =0xd7039532
ldr r4, =0x35d21fb4
ldr r5, =0x2ff8cdcf
ldr r6, =0x00000021
ldr r7, =0x63a70b62
ldr r8, =0x80000000
ldr r9, =0x12345678
ldr r10, =0x00000001
ldr r11, =0xb8e252a1
ldr r12, =0x71370cae
ldr r14, =0xddcc8237
cmn r5, r7
adr r3, 1f
movvc pc, r3
add r0, r0, #1
1:
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
ldr r1, =0x7fffffff
ldr r2, =0x3c0f5886
ldr r3, =0x92b4d840
ldr r4, =0xe322955f
ldr r5, =0x67a12a93
ldr r6, =0x6a743f36
ldr r7, =0x39107c65
ldr r8, =0x7ffffffe
ldr r9, =0x80000001
ldr r10, =0x60f22187
ldr r11, =0x9f5aa719
ldr r12, =0x7c3e181a
ldr r14, =0xc204e9d6
tst r3, r3
ldr pc, =1f
add r0, r0, #3
1:
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
