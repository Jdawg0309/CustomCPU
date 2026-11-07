.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xa3ec95a8
str r0, [r12, #0]
ldr r0, =0xcafebabe
str r0, [r12, #4]
ldr r0, =0x34de1f72
str r0, [r12, #8]
ldr r0, =0xf2eb3793
str r0, [r12, #12]
ldr r0, =0x0025a802
str r0, [r12, #16]
ldr r0, =0xa90b4820
str r0, [r12, #20]
ldr r0, =0x48f6078b
str r0, [r12, #24]
ldr r0, =0x80000001
str r0, [r12, #28]
ldr r0, =0x00000100
str r0, [r12, #32]
ldr r0, =0x705b2645
str r0, [r12, #36]
ldr r0, =0xd8b30a97
str r0, [r12, #40]
ldr r0, =0x00000100
str r0, [r12, #44]
ldr r0, =0x12345678
str r0, [r12, #48]
ldr r0, =0x80000000
str r0, [r12, #52]
ldr r0, =0x6a7dad0b
str r0, [r12, #56]
ldr r0, =0xe629cff1
str r0, [r12, #60]
ldr r0, =0x00000021
ldr r1, =0xf17b5a52
ldr r2, =0xd34b8ba6
ldr r3, =0x7ffffffe
ldr r4, =0xc8b259b1
ldr r5, =0xffffffff
ldr r6, =0x7ffffffe
ldr r7, =0xa7f27b3a
ldr r8, =0x553f0ad4
ldr r9, =0xe0e09d15
ldr r10, =0x6c9d9773
ldr r11, =0x000000ff
ldr r12, =0xa4b8db24
ldr r14, =0x00000021
teq r9, r7
ldr pc, =1f
add r0, r0, #3
1:
and r9, r6, r14, lsr #17
rsbs r6, r5, r9, lsl #9
adds r12, r14, r4, lsr #16
tstle r11, #0x2400
rsc r12, r10, #0xf00
sbc r4, r4, r12, ror #12
bic r11, r8, #0x3c
cmnvs r2, r5, ror #12
sub r8, r0, #0x45
bicpl r9, r4, r0, lsl r1
tst r8, r1, ror r5
ands r11, r5, r7, ror #4
rsbeq r12, r10, r12
cmn r14, r11, lsr r11
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
ldr r0, =0x000000ff
ldr r1, =0xe176ae5f
ldr r2, =0xc289459a
ldr r3, =0xffffffff
ldr r4, =0x62ff49d1
ldr r5, =0xfa6577a7
ldr r6, =0x80000000
ldr r7, =0xba1f683a
ldr r8, =0x0000ffff
ldr r9, =0x00000100
ldr r10, =0xef5f58b1
ldr r11, =0x6ac3c883
ldr r12, =0x73cd21a8
ldr r14, =0xafd2a4de
tst r12, r7
bhi 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
bgt 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
ldr r10, =0x1120
ldmibhi r10, {r1,r11,lr}
ldr r10, =0x1120
ldmda r10!, {r8}
ldr r10, =0x1120
ldmdb r10, {r4,r8,lr}
ldr r10, =0x1120
stmda r10, {r2,r4,r6}
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
ldr r1, =0x269980bc
ldr r2, =0xb3953ca7
ldr r3, =0x00000101
ldr r4, =0x8f80e9b9
ldr r5, =0xe3d4920e
ldr r6, =0x1e4c82c7
ldr r7, =0x50d30925
ldr r8, =0x70c46e72
ldr r9, =0x00000020
ldr r10, =0xca9d183c
ldr r11, =0x36e41c56
ldr r12, =0x00000001
ldr r14, =0x000000ff
teq r11, r0
movvc r0, #136
movpl r1, #146
movlt r2, #97
movhi r3, #16
movcc r4, #79
movvs r5, #104
andge r8, r10, r5, asr r2
cmn r9, r12, lsr #18
sub r6, r1, #0x9e000
blvc 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
movmi r0, #192
movge r1, #85
movle r2, #34
movgt r3, #4
movgt r4, #59
movvs r5, #126
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
ldr r0, =0x12345678
ldr r1, =0xf0a2732b
ldr r2, =0xa4defa9d
ldr r3, =0x00000002
ldr r4, =0xfaee2a95
ldr r5, =0x00000021
ldr r6, =0x0000001f
ldr r7, =0x83a45a77
ldr r8, =0x00000101
ldr r9, =0x7fffffff
ldr r10, =0xa54625fc
ldr r11, =0xffffffff
ldr r12, =0x4baf8199
ldr r14, =0x4a9c4109
cmn r9, r6
ldr r10, =0x1120
mov r9, #4
strh r4, [r10], #20
str r6, [r10], r9
ldrshcs r6, [r10, #-0]
ldrsb r7, [r10], #12
ldrsh r3, [r10, #-4]
mvn r5, r10, asr #17
rsb r6, r10, r8, rrx
tstgt r6, #0x3600
subscc r7, r8, r5, lsl r12
ldr r10, =0x1120
mov r9, #16
strb r1, [r10, #-10]
ldrh r5, [r10, #2]
str r14, [r10], -r9
strb r14, [r10, #14]
add r4, pc, r1, lsl #2
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
ldr r0, =0x1660bedd
ldr r1, =0x8af38d58
ldr r2, =0x6d45477d
ldr r3, =0x41d8e15c
ldr r4, =0xbeaf1b83
ldr r5, =0x00000100
ldr r6, =0x82ca7672
ldr r7, =0xba7ec18c
ldr r8, =0x80000001
ldr r9, =0x00000000
ldr r10, =0xa60c3b02
ldr r11, =0x00000100
ldr r12, =0x00000002
ldr r14, =0x12345678
cmp r7, r4
movcs r0, #152
movcc r1, #51
moveq r2, #181
movvc r3, #192
movhi r4, #175
movls r5, #29
movsmi r12, r11
cmplt r12, #0x1940000
andmi r12, r7, r4, lsl r6
mov r14, r2
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0xcafebabe
ldr r1, =0xf950b454
ldr r2, =0x2cf17765
ldr r3, =0xe0f8b5b6
ldr r4, =0x00000000
ldr r5, =0x0a5fbbea
ldr r6, =0xffffffff
ldr r7, =0x5effb3ec
ldr r8, =0x202551fa
ldr r9, =0x152a753b
ldr r10, =0x79877256
ldr r11, =0x0000ffff
ldr r12, =0x80000000
ldr r14, =0xe7d1f57e
cmn r7, r2
subs r2, r7, r2, ror #31
cmn r3, #0x8000
cmngt r9, r14, ror r14
cmn r6, #0xc000003d
cmn r4, r6, lsr r4
subs r11, r6, r2, lsr #32
adcsgt r10, r3, r1, ror r9
mov r12, #0x230000
sbcls r4, r8, r10, ror #17
movs r9, r6, asr r11
bichi r3, r0, #0xc6000000
add r9, r12, r11, ror #29
orrvs r3, r10, r2, lsl r11
teq r1, r8
orrs r6, r8, r7, asr #3
sub r3, r3, r12
ands r14, r10, #0x3400000
bics r10, r1, #0x4000003f
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
ldr r0, =0xf08696b0
ldr r1, =0xcafebabe
ldr r2, =0x023409d8
ldr r3, =0x12345678
ldr r4, =0x00000101
ldr r5, =0x00000100
ldr r6, =0xeff461bc
ldr r7, =0x5b01df7d
ldr r8, =0x03b4a2bf
ldr r9, =0x0cb07b7f
ldr r10, =0x00000002
ldr r11, =0x00000000
ldr r12, =0x80000000
ldr r14, =0x20515a20
cmp r12, r6
tst r3, r10, rrx
orrs r1, r4, #0x220000
tst r4, r2, lsl r7
adds r8, r9, r4, asr r12
rsbs r5, r9, r0
movcc r0, #33
movge r1, #27
movvs r2, #134
movls r3, #115
movvs r4, #93
movlt r5, #34
ldr r10, =0x1120
ldmia r10!, {r2,r7,r8}
ldr r10, =0x1120
ldmib r10, {r2,r5,r6,r8,r11}
ldr r10, =0x1120
ldmib r10!, {r4,r8,r12}
ldr r10, =0x1120
ldr r10, =0x1120
mov r9, #0
ldr r0, [r10, r9]
strbcc r5, [r10, #-17]
ldr r6, [r10, #8]
ldrsb r0, [r10], #4
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
ldr r0, =0x00000021
ldr r1, =0x52146a31
ldr r2, =0xb12dad30
ldr r3, =0xbce5e263
ldr r4, =0x7878f743
ldr r5, =0x8662402e
ldr r6, =0x3da7084e
ldr r7, =0xbc45147c
ldr r8, =0x7ffffffe
ldr r9, =0x00000002
ldr r10, =0x00000020
ldr r11, =0xd341c1bd
ldr r12, =0x52ef802d
ldr r14, =0x00000101
teq r11, r12
movgt r0, #188
movcc r1, #12
movne r2, #173
movlt r3, #61
movge r4, #78
movgt r5, #177
addle r1, r9, r6
movs r3, r0, asr #25
eorle r0, r2, r12, lsr r10
ldr r10, =0x1120
ldmia r10!, {r1,r3,r8,r9}
ldr r10, =0x1120
stmia r10!, {r0,r2,r4,lr}
ldr r10, =0x1120
ldmda r10, {r3,r8,lr}
ldr r10, =0x1120
adcshi r12, r8, r4, ror r14
eors r1, r10, r10, asr #22
andvc r11, r11, r7, lsl r2
sub r9, r7, #0x9000000a
cmp r12, r2, asr #29
rsc r1, r8, r11, lsr r11
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
