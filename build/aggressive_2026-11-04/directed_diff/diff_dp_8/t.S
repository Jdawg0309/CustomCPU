.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x000000ff
str r0, [r12, #0]
ldr r0, =0x62689e79
str r0, [r12, #4]
ldr r0, =0x38bea6a9
str r0, [r12, #8]
ldr r0, =0x00000020
str r0, [r12, #12]
ldr r0, =0x77090d36
str r0, [r12, #16]
ldr r0, =0x00000101
str r0, [r12, #20]
ldr r0, =0x12345678
str r0, [r12, #24]
ldr r0, =0x00000100
str r0, [r12, #28]
ldr r0, =0xffffffff
str r0, [r12, #32]
ldr r0, =0x219d1840
str r0, [r12, #36]
ldr r0, =0x0000ffff
str r0, [r12, #40]
ldr r0, =0x00000100
str r0, [r12, #44]
ldr r0, =0x00000002
str r0, [r12, #48]
ldr r0, =0x00000001
str r0, [r12, #52]
ldr r0, =0x7ffffffe
str r0, [r12, #56]
ldr r0, =0x00000020
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0x00000100
ldr r2, =0x0000001f
ldr r3, =0x00000021
ldr r4, =0xed3fab37
ldr r5, =0x00000100
ldr r6, =0x709af0f5
ldr r7, =0xcea55bd6
ldr r8, =0x00000001
ldr r9, =0x00000100
ldr r10, =0xc8eed9cb
ldr r11, =0x00000000
ldr r12, =0xffffffff
ldr r14, =0x80000000
cmn r7, r2
teq r2, #0xf60
add r0, r6, r5
eor r12, r1, r0, lsr #27
tst r5, r8
bics r14, r0, #0xc500000
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
ldr r0, =0x00000021
ldr r1, =0x1a584233
ldr r2, =0xffffffff
ldr r3, =0x5a716ebd
ldr r4, =0xe2caced8
ldr r5, =0x000000ff
ldr r6, =0x1d731fc6
ldr r7, =0x03179d5c
ldr r8, =0x00000001
ldr r9, =0xffffffff
ldr r10, =0x3a249378
ldr r11, =0xfc6cb175
ldr r12, =0x7ffffffe
ldr r14, =0x81fd68e9
cmp r8, r7
cmp r14, r4, asr r10
cmp r11, #0xb0000003
orrls r4, r4, r6, lsl r4
rscsvc r6, r1, r0
sbcspl r6, r12, r0
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
ldr r0, =0x00000002
ldr r1, =0x00000020
ldr r2, =0x7decf562
ldr r3, =0x9faf4d5a
ldr r4, =0x00000101
ldr r5, =0x5988ced7
ldr r6, =0xcafebabe
ldr r7, =0xba5b20e6
ldr r8, =0x676a998c
ldr r9, =0x9997df6b
ldr r10, =0x7fffffff
ldr r11, =0xc1fc50f9
ldr r12, =0x7fffffff
ldr r14, =0x00000021
tst r7, r10
cmp r1, #0xf0000004
cmp r5, r10, lsr r4
bicvc r3, r0, r2, lsr r8
adcs r6, r2, r14
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
ldr r0, =0x896109b4
ldr r1, =0xbca43599
ldr r2, =0x7ffffffe
ldr r3, =0x000000ff
ldr r4, =0xef2b4f03
ldr r5, =0xcafebabe
ldr r6, =0x00000100
ldr r7, =0x0000001f
ldr r8, =0x80000001
ldr r9, =0x7fffffff
ldr r10, =0x00000020
ldr r11, =0xa08588b5
ldr r12, =0x29d9210a
ldr r14, =0xa88b16b1
cmn r5, r12
mvns r3, r7, rrx
sbcs r2, r14, r3, rrx
subsls r2, r10, r2, ror #4
movls r5, r0, lsl r5
cmpeq r4, r3, lsr r12
and r3, r1, r9
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
ldr r0, =0x56e52c5b
ldr r1, =0x00000000
ldr r2, =0xffffffff
ldr r3, =0x00000000
ldr r4, =0xf53f93b2
ldr r5, =0x00000100
ldr r6, =0xffffffff
ldr r7, =0x7abb5270
ldr r8, =0x5d168503
ldr r9, =0x3e9d13bd
ldr r10, =0x75a23431
ldr r11, =0x4c7763b7
ldr r12, =0x7fffffff
ldr r14, =0x00000000
cmn r2, r0
addseq r3, r14, #0x31800000
add r8, r5, r3
mvnspl r3, r6, lsr r11
rscs r5, r10, r7, ror r0
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
ldr r0, =0xe10a16bb
ldr r1, =0x3b4b44eb
ldr r2, =0x000000ff
ldr r3, =0x00000001
ldr r4, =0xd100ba20
ldr r5, =0xca786ae4
ldr r6, =0x9b39596b
ldr r7, =0x52c5cea5
ldr r8, =0x00000021
ldr r9, =0x0000ffff
ldr r10, =0x00000100
ldr r11, =0x76d399f5
ldr r12, =0x5e1846fc
ldr r14, =0xcee91266
cmp r0, r11
and r0, r4, r6, lsl r4
subs r0, r2, r4, lsl #2
adcseq r6, r7, r7, asr #23
tst r10, r9
ands r11, r14, r2, ror #23
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
ldr r0, =0x7fffffff
ldr r1, =0x0000001f
ldr r2, =0x0694ca52
ldr r3, =0x3267367b
ldr r4, =0xfee30117
ldr r5, =0x000000ff
ldr r6, =0x37eb7919
ldr r7, =0x0000001f
ldr r8, =0x80000001
ldr r9, =0x27f1eda9
ldr r10, =0x7fffffff
ldr r11, =0x00000100
ldr r12, =0x80000000
ldr r14, =0x80000000
teq r2, r0
ands r9, r11, r3, asr r7
bicmi r7, r1, r2
mvns r14, r1, ror r1
rsbvs r4, r0, r3, rrx
subs r6, r8, #0xc4
orr r8, r2, r12, ror r5
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
ldr r0, =0x6c94d090
ldr r1, =0x0ea288e4
ldr r2, =0xf5ca9306
ldr r3, =0x0bb48917
ldr r4, =0xffffffff
ldr r5, =0x8aabbfaa
ldr r6, =0x00000000
ldr r7, =0x58c84beb
ldr r8, =0x00000000
ldr r9, =0x00000000
ldr r10, =0x80000000
ldr r11, =0xa9548646
ldr r12, =0x44f736eb
ldr r14, =0xbc37c41f
tst r12, r8
tst r10, r5, lsr #14
rsc r11, r10, #0x9e0
rsb r0, r5, r9, asr r12
and r6, r7, r5, lsr r3
sbcs r5, r0, r0, asr r2
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
