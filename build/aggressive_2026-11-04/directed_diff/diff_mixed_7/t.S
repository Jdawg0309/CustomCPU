.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xcf457ffb
str r0, [r12, #0]
ldr r0, =0xbf2632cb
str r0, [r12, #4]
ldr r0, =0x6f7e1b01
str r0, [r12, #8]
ldr r0, =0x55ace72f
str r0, [r12, #12]
ldr r0, =0x2acb2b38
str r0, [r12, #16]
ldr r0, =0xce4fdabe
str r0, [r12, #20]
ldr r0, =0x0000001f
str r0, [r12, #24]
ldr r0, =0x7fc12dc8
str r0, [r12, #28]
ldr r0, =0xa1c390ec
str r0, [r12, #32]
ldr r0, =0x2c5ca3d3
str r0, [r12, #36]
ldr r0, =0xe55c4396
str r0, [r12, #40]
ldr r0, =0xdc728eae
str r0, [r12, #44]
ldr r0, =0x75fc1545
str r0, [r12, #48]
ldr r0, =0xffffffff
str r0, [r12, #52]
ldr r0, =0xffffffff
str r0, [r12, #56]
ldr r0, =0x4cb6a035
str r0, [r12, #60]
ldr r0, =0x52d8fa6f
ldr r1, =0x3f15b644
ldr r2, =0xcafebabe
ldr r3, =0xee50c981
ldr r4, =0xfa5db54f
ldr r5, =0x9d8d0929
ldr r6, =0x99cdf11e
ldr r7, =0x0000ffff
ldr r8, =0xf075f58c
ldr r9, =0xcafebabe
ldr r10, =0x6b4fc50d
ldr r11, =0x000000ff
ldr r12, =0x10eb92d2
ldr r14, =0x90ad4785
tst r6, r5
moveq r0, #108
movcc r1, #140
movmi r2, #71
movvs r3, #129
movvs r4, #179
movle r5, #193
adcscs r14, r2, r10, lsl #10
rsbsgt r6, r6, r0, rrx
sbc r9, r2, r2, ror r3
mvnsmi r8, r9, lsl #4
subgt r6, r4, r11
cmp r8, r11, lsl #27
tstcs r11, #0x1400000
orrs r1, r11, r8, rrx
movs r0, r6
cmp r0, r3, ror #9
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
ldr r1, =0x80000000
ldr r2, =0x80000000
ldr r3, =0x9a54d52d
ldr r4, =0x80000000
ldr r5, =0x00000101
ldr r6, =0x000000ff
ldr r7, =0x4efdfd5d
ldr r8, =0x00000101
ldr r9, =0x7079ded1
ldr r10, =0x7fffffff
ldr r11, =0xcafebabe
ldr r12, =0x722db3e7
ldr r14, =0xc5a54b30
tst r0, r8
ldr r10, =0x1120
mov r9, #16
str r6, [r10], -r9
ldrb r14, [r10, #0]!
ldr r10, =0x1120
strbcs r11, [r10, #16]!
ldr r10, =0x1120
str r4, [r10], -r9
str r14, [r10, #-16]
str r14, [r10, -r9]
ldr r10, =0x1120
adcs r5, r5, r3, ror #25
addslt r1, r8, r12, asr #12
bic r14, r2, r1
tst r6, r6
ldr r10, =0x1120
mov r9, #16
ldr r1, [r10], #8
ldrsb r14, [r10, #9]
ldrb r2, [r10, #-7]
ldrsb r7, [r10, #-14]
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
ldr r0, =0x1dcaa8f9
ldr r1, =0x00000001
ldr r2, =0x00000021
ldr r3, =0x31964489
ldr r4, =0x41c95050
ldr r5, =0x00000001
ldr r6, =0xf4ea0417
ldr r7, =0x7ffffffe
ldr r8, =0xccde72d9
ldr r9, =0x599bf9f7
ldr r10, =0x00000020
ldr r11, =0x00000001
ldr r12, =0xe485ef6b
ldr r14, =0xcafebabe
cmp r12, r6
movle r0, #64
movle r1, #18
movmi r2, #83
movls r3, #60
movhi r4, #53
movcs r5, #151
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bgt 2f
add r1, r1, #7
2:
movs r8, r6, lsr r9
adc r0, r11, r7, asr r2
sub r12, r11, r8, ror r6
rscsge r0, r2, r11, lsr r10
cmp r9, r7, rrx
sub r2, r4, r3
movle r0, #46
movle r1, #138
movhi r2, #61
movhi r3, #195
movcc r4, #56
movmi r5, #183
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
ldr r0, =0xd7e0adbd
ldr r1, =0x7ffffffe
ldr r2, =0xee6e387b
ldr r3, =0xc6583a31
ldr r4, =0x80000001
ldr r5, =0xbc6c729f
ldr r6, =0x00000021
ldr r7, =0xffffffff
ldr r8, =0x00000000
ldr r9, =0x12345678
ldr r10, =0x12345678
ldr r11, =0x202c7e9a
ldr r12, =0x7fffffff
ldr r14, =0xdd40bf65
cmn r6, r12
mvns r3, r10
teq r2, r1, lsr #30
tst r3, r5, lsl r3
adcs r3, r9, r1, ror #26
movne r12, r6, lsl #7
adcne r14, r12, r10, lsl r1
mvn r9, r8
sbccs r7, r8, #0x15800000
add r9, r5, r4, asr r5
teqcs r7, r3, ror #12
blmi 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0xab95b8e7
ldr r1, =0x0000001f
ldr r2, =0x77066ee0
ldr r3, =0x974a5ea9
ldr r4, =0x00000100
ldr r5, =0x3a2088cb
ldr r6, =0xffffffff
ldr r7, =0x00000101
ldr r8, =0x00000100
ldr r9, =0x000000ff
ldr r10, =0x7fffffff
ldr r11, =0x0000001f
ldr r12, =0xea1d12f8
ldr r14, =0x80000000
cmp r8, r4
bge 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
ldr r10, =0x1120
mov r9, #4
strhls r6, [r10, #4]
ldrmi r1, [r10, #20]
ldr r4, [r10, #0]
ldr r10, =0x1120
ldrshpl r7, [r10, #8]!
ldr r10, =0x1120
mov r9, #4
str r1, [r10, -r9]
ldr r1, [r10], #16
ldrsh r6, [r10, #-14]
ldrsbvc r7, [r10], #20
ldrsb r11, [r10, #-19]
ldr r10, =0x1120
subs r2, r14, #0x44000003
sbcs r14, r5, #0xd000
and r6, r5, r7, asr #29
cmp r7, r8, rrx
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
ldr r0, =0x00000000
ldr r1, =0x00000020
ldr r2, =0xe29907c0
ldr r3, =0x0cf0fe50
ldr r4, =0xea5d1dec
ldr r5, =0x0000001f
ldr r6, =0x0000ffff
ldr r7, =0xb9d36129
ldr r8, =0x97621ac6
ldr r9, =0x43f46737
ldr r10, =0x000000ff
ldr r11, =0xbee1c07e
ldr r12, =0x00000002
ldr r14, =0xbf711021
teq r12, r10
ldr r10, =0x1120
stmdb r10!, {r4}
ldr r10, =0x1120
stmia r10!, {r0,r2,r8,r12}
ldr r10, =0x1120
stmda r10!, {r1,r5,r6,lr}
ldr r10, =0x1120
stmda r10, {r5}
ldr r10, =0x1120
blhi 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
bhi 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
rsc r4, r2, r11
orr r12, r9, r10
tst r9, #0x74000002
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
ldr r0, =0x00000021
ldr r1, =0x0ae70d03
ldr r2, =0x00000021
ldr r3, =0xdc19762e
ldr r4, =0x5d30504b
ldr r5, =0x8a7703ec
ldr r6, =0xef7a709c
ldr r7, =0x2f78149d
ldr r8, =0x5250bbd0
ldr r9, =0x7ffd518b
ldr r10, =0xcafebabe
ldr r11, =0x00000000
ldr r12, =0xb74d5c48
ldr r14, =0xc249ebb4
tst r3, r4
ldr r10, =0x1120
mov r9, #12
ldr r4, [r10], r9
ldr r12, [r10, #8]!
ldrvc r7, [r10, #-4]
str r8, [r10, #-4]
ldr r10, =0x1120
ldrshhi r14, [r10], r9
bne 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
ldr r10, =0x1120
mov r9, #0
ldr r12, [r10], #8
ldr r10, =0x1120
strvs r5, [r10, #20]!
ldrvc r6, [r10, #8]!
strh r11, [r10, #4]
ldr r10, =0x1120
strb r8, [r10, -r9]
ldr r10, =0x1120
ldr r5, [r10], r9
ldrb r1, [r10], #4
bcc 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
beq 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r0, =0xedbd4887
ldr r1, =0x00000002
ldr r2, =0x00000001
ldr r3, =0x53315b0b
ldr r4, =0x80000000
ldr r5, =0x00000001
ldr r6, =0xefabbfc7
ldr r7, =0x00000002
ldr r8, =0x66d65056
ldr r9, =0x000000ff
ldr r10, =0x000000ff
ldr r11, =0x7fffffff
ldr r12, =0x00000100
ldr r14, =0xe5d0f9aa
teq r3, r5
addvc pc, pc, #0
add r1, r1, #1
add r2, r2, #1
ldr r10, =0x1120
stmib r10!, {r1,r9}
ldr r10, =0x1120
ldmda r10!, {r2,r7,lr}
ldr r10, =0x1120
movls r0, #112
movlt r1, #84
movgt r2, #98
movpl r3, #151
movmi r4, #36
movvc r5, #193
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
