.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xdc25eff8
str r0, [r12, #0]
ldr r0, =0x2ffadbae
str r0, [r12, #4]
ldr r0, =0xffffffff
str r0, [r12, #8]
ldr r0, =0xffffffff
str r0, [r12, #12]
ldr r0, =0x00000002
str r0, [r12, #16]
ldr r0, =0x00000000
str r0, [r12, #20]
ldr r0, =0x000000ff
str r0, [r12, #24]
ldr r0, =0xb461e568
str r0, [r12, #28]
ldr r0, =0x948efc8d
str r0, [r12, #32]
ldr r0, =0x3abdce51
str r0, [r12, #36]
ldr r0, =0x0000001f
str r0, [r12, #40]
ldr r0, =0x35809583
str r0, [r12, #44]
ldr r0, =0xbdf68264
str r0, [r12, #48]
ldr r0, =0x1f6e1ac7
str r0, [r12, #52]
ldr r0, =0x00000000
str r0, [r12, #56]
ldr r0, =0x00000001
str r0, [r12, #60]
ldr r0, =0x7ffffffe
ldr r1, =0xb8fbb704
ldr r2, =0xffffffff
ldr r3, =0x00000021
ldr r4, =0xf38c5977
ldr r5, =0x00000100
ldr r6, =0x0000ffff
ldr r7, =0xa5be140c
ldr r8, =0x1905ba8d
ldr r9, =0x420b329f
ldr r10, =0x1d0db03a
ldr r11, =0xb19dc2bf
ldr r12, =0xe1ce3a15
ldr r14, =0x0000ffff
cmn r12, r1
bics r6, r6, r5, lsr r9
bicshi r4, r7, #0x15c000
sbcshi r11, r5, r4
rschi r6, r0, r7, ror #19
cmp r14, r11, lsl #30
rsc r6, r14, r12
adc r3, r6, r10
subs r4, r8, #0xd000000
rsb r11, r12, r6, asr #21
mvn r2, r0, asr #17
orr r9, r2, r3, rrx
ldr r10, =0x1120
mov r9, #4
ldrhcs r4, [r10, #6]
strhmi r12, [r10, r9]
ldr r6, [r10, #4]
strh r1, [r10], #12
strbvc r0, [r10, #19]
ldrsh r11, [r10, #0]!
ldr r7, [r10, #0]!
ldr r10, =0x1120
addsmi r5, r5, r0, rrx
orr r11, r8, r1, ror #3
eorsls r9, r4, r6
moveq r0, #47
moveq r1, #1
movcs r2, #156
movge r3, #190
movge r4, #39
movcs r5, #152
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
ldr r1, =0xffffffff
ldr r2, =0x12345678
ldr r3, =0x0000001f
ldr r4, =0x80000001
ldr r5, =0x12345678
ldr r6, =0x00000021
ldr r7, =0xa3139e4d
ldr r8, =0x16a4dfb6
ldr r9, =0x00000100
ldr r10, =0x00000000
ldr r11, =0x80000001
ldr r12, =0x00d116da
ldr r14, =0xb66fca4b
teq r0, r6
adcs r8, r4, r14, ror #6
cmn r0, r10, lsl #9
adcs r14, r8, #0xe40
tstgt r6, r14, rrx
ldr pc, =1f
add r0, r0, #3
1:
bvc 1f
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
ldr r0, =0xda486454
ldr r1, =0xf51fd1a8
ldr r2, =0x8458d30f
ldr r3, =0xd1bf6064
ldr r4, =0xa3355b68
ldr r5, =0x00000002
ldr r6, =0x1f81a18e
ldr r7, =0x9f5d7261
ldr r8, =0x00000021
ldr r9, =0x80000001
ldr r10, =0xdb030889
ldr r11, =0x685564f5
ldr r12, =0x80000001
ldr r14, =0x00000021
teq r12, r4
andne r11, r1, r5, lsl r5
bics r9, r14, #0xf3000000
teq r4, r11, lsr r7
orr r5, r2, r8
ands r4, r14, r2, ror #28
mvns r5, r9, lsl #2
adr r3, 1f
mov pc, r3
add r0, r0, #1
1:
moveq r0, #87
moveq r1, #136
moveq r2, #178
movmi r3, #187
movle r4, #109
movhi r5, #59
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
ldr r0, =0x0000001f
ldr r1, =0x00000100
ldr r2, =0xffffffff
ldr r3, =0x80000000
ldr r4, =0x00000002
ldr r5, =0x9a5145e1
ldr r6, =0x80000001
ldr r7, =0xa7705e14
ldr r8, =0xce4b284c
ldr r9, =0x1dbc337d
ldr r10, =0xea17bfd0
ldr r11, =0x0000001f
ldr r12, =0x12345678
ldr r14, =0x8d88173c
teq r4, r14
mvn r9, r12, asr #7
cmn r4, r9
andpl r9, r9, r1
eors r8, r8, r11, asr r9
ldr r10, =0x1120
mov r9, #0
ldrhvs r2, [r10], #16
ldr r10, =0x1120
ldrsb r1, [r10], -r9
str r7, [r10, -r9]
strb r1, [r10, #-6]
strb r4, [r10, #4]!
bpl 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
sbcpl r7, r11, #0xc50000
cmp r3, r6
teq r11, #0x4000002
mvn r14, r3, lsl r2
rsb r2, r9, #0x89
ldr r10, =0x1120
ldmdb r10!, {r2,r5,r9}
ldr r10, =0x1120
ldmdb r10!, {r0}
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
ldr r0, =0x16f8d5ca
ldr r1, =0x05ce7df3
ldr r2, =0x80000000
ldr r3, =0xd633f453
ldr r4, =0x0000ffff
ldr r5, =0x0000001f
ldr r6, =0x80000001
ldr r7, =0x00000001
ldr r8, =0x7ffffffe
ldr r9, =0x373f02ed
ldr r10, =0xffffffff
ldr r11, =0xf4128e59
ldr r12, =0x3c807f67
ldr r14, =0x00000020
cmp r11, r12
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
tst r9, r8, rrx
tstvc r11, r6
adc r0, r5, r8, ror #26
orrs r1, r2, r11, lsr r1
adc r5, r12, r3, rrx
cmnlt r0, r11, ror r8
rsc r11, r12, #0xc0000015
sbcs r11, r3, #0x224
movge r0, #52
movle r1, #144
movne r2, #42
movgt r3, #161
movpl r4, #92
movhi r5, #180
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
ldr r0, =0xffffffff
ldr r1, =0x0000ffff
ldr r2, =0x7ffffffe
ldr r3, =0x80000001
ldr r4, =0x07ef2be7
ldr r5, =0xc1a6144a
ldr r6, =0x12510af6
ldr r7, =0x12345678
ldr r8, =0xffffffff
ldr r9, =0x0000001f
ldr r10, =0xcafebabe
ldr r11, =0x7ffffffe
ldr r12, =0xcafebabe
ldr r14, =0x0000ffff
tst r3, r4
add r9, r10, #0xaf00
sbcpl r4, r7, r8, asr r2
adcgt r6, r2, r7
movvs r0, #5
movls r1, #119
movle r2, #77
movls r3, #168
movne r4, #18
movle r5, #127
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
sbcs r9, r11, #0xf4000
orr r7, r5, r14, rrx
sbc r4, r5, #0x1440
orrs r8, r1, r14, asr r12
orrs r11, r11, r6, lsr #30
ands r11, r9, r2
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
ldr r0, =0x7ffffffe
ldr r1, =0x2afddf31
ldr r2, =0xffffffff
ldr r3, =0x7fffffff
ldr r4, =0x00000002
ldr r5, =0x3b97a824
ldr r6, =0x6724d6eb
ldr r7, =0x7fffffff
ldr r8, =0x00000001
ldr r9, =0x01b37792
ldr r10, =0x450016d5
ldr r11, =0x000000ff
ldr r12, =0x12555114
ldr r14, =0x87dae64d
tst r12, r1
add r4, r0, pc
movle r0, #128
movne r1, #197
movcs r2, #17
movge r3, #59
movne r4, #164
movpl r5, #87
teq r8, r6, lsr r10
moveq r3, r7, asr #5
cmphi r4, r7, ror #24
mvnvc r12, r5, lsl r12
addcc r11, r8, r11, ror #9
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
ldr r0, =0x80000001
ldr r1, =0x00000000
ldr r2, =0x08a6fbc5
ldr r3, =0xbca916bd
ldr r4, =0x08cbd50f
ldr r5, =0x14b01a78
ldr r6, =0x00000100
ldr r7, =0x00000002
ldr r8, =0x7ffffffe
ldr r9, =0x00000001
ldr r10, =0x52e0818c
ldr r11, =0xe15ecf89
ldr r12, =0x9d2e9118
ldr r14, =0x0000ffff
cmp r6, r11
ldr r10, =0x1120
mov r9, #16
strh r1, [r10], r9
ldrsb r12, [r10, #10]
ldr r2, [r10, r9]
ldr r0, [r10], r9
ldr r10, =0x1120
ldrsbls r1, [r10, -r9]
ldr r7, [r10, -r9]
ldr r10, =0x1120
ldrsh r5, [r10], #0
ldr r10, =0x1120
cmpcc r8, #0x3200
mvns r14, #0x4a000
cmpeq r10, r14, lsr r5
ldr r10, =0x1120
mov r9, #16
ldrsb r8, [r10, r9]
ldr r12, [r10, #-24]
ldrmi r6, [r10, #-20]
ldrb r7, [r10], #20
ldr r10, =0x1120
adr r3, 1f
movne pc, r3
add r0, r0, #1
1:
movvs r0, #91
movge r1, #82
movvc r2, #119
movvs r3, #195
movne r4, #24
movls r5, #151
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
