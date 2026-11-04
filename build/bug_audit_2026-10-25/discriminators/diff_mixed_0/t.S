.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x000000ff
str r0, [r12, #0]
ldr r0, =0xa997122e
str r0, [r12, #4]
ldr r0, =0x80000000
str r0, [r12, #8]
ldr r0, =0x0000001f
str r0, [r12, #12]
ldr r0, =0x000000ff
str r0, [r12, #16]
ldr r0, =0xb67e74e0
str r0, [r12, #20]
ldr r0, =0x80000000
str r0, [r12, #24]
ldr r0, =0xf8110ab5
str r0, [r12, #28]
ldr r0, =0x7ffffffe
str r0, [r12, #32]
ldr r0, =0x00000001
str r0, [r12, #36]
ldr r0, =0x1101a37a
str r0, [r12, #40]
ldr r0, =0x8d3bd4ef
str r0, [r12, #44]
ldr r0, =0x7fcbdb3c
str r0, [r12, #48]
ldr r0, =0x00000101
str r0, [r12, #52]
ldr r0, =0x00000021
str r0, [r12, #56]
ldr r0, =0x0000ffff
str r0, [r12, #60]
ldr r0, =0x8d079f5c
ldr r1, =0x90ec32a2
ldr r2, =0x80000000
ldr r3, =0x3d15b937
ldr r4, =0x0000ffff
ldr r5, =0x00000020
ldr r6, =0x000000ff
ldr r7, =0xffffffff
ldr r8, =0xffffffff
ldr r9, =0x6f6a35a1
ldr r10, =0x80000001
ldr r11, =0x00000001
ldr r12, =0x76e1d160
ldr r14, =0xbed07c64
teq r3, r12
cmplt r11, #0x1000000c
and r9, r3, r7, lsl #9
mov r8, r0, asr #26
rscsls r4, r8, r1, lsl r2
eors r1, r7, r3, asr r3
movsge r11, #0x6400000
ldr r10, =0x1120
ldmia r10, {r3,lr}
ldr r10, =0x1120
ldmda r10!, {r2,r3,r5,r11}
ldr r10, =0x1120
stmia r10!, {r0}
ldr r10, =0x1120
ldr r10, =0x1120
mov r9, #8
strb r4, [r10, #-10]
strblt r0, [r10, #4]!
ldr r10, =0x1120
ldrsh r7, [r10, #12]
strbge r4, [r10, r9]
ldrsbne r12, [r10], -r9
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
ldr r0, =0x0000ffff
ldr r1, =0x000000ff
ldr r2, =0x2bb37aaa
ldr r3, =0x00000100
ldr r4, =0x00000000
ldr r5, =0x138f985f
ldr r6, =0x80000000
ldr r7, =0x80000001
ldr r8, =0x0000001f
ldr r9, =0x128b158e
ldr r10, =0x000000ff
ldr r11, =0xa3e37da2
ldr r12, =0x018dc09b
ldr r14, =0x00000101
cmn r3, r4
ldr r10, =0x1120
stmibcc r10!, {r2,r3,r6,lr}
ldr r10, =0x1120
stmda r10!, {r1,r4}
ldr r10, =0x1120
stmda r10, {r1,r5,r7}
ldr r10, =0x1120
stmdb r10!, {r1,r6}
ldr r10, =0x1120
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
ldr r10, =0x1120
stmib r10!, {r3,r5,r6,r7,r8}
ldr r10, =0x1120
stmda r10, {r7,r8,r9}
ldr r10, =0x1120
stmia r10!, {r2,r8,r11}
ldr r10, =0x1120
stmiaeq r10!, {r4,r6,r11,lr}
ldr r10, =0x1120
ldr r10, =0x1120
mov r9, #12
ldrsh r5, [r10], #20
ldrlt r3, [r10, #-12]
ldr r10, =0x1120
ldrsh r8, [r10, #12]!
ldrsbne r1, [r10, #-2]
ldrsb r11, [r10], r9
ldr r11, [r10], #0
ldrsb r0, [r10, #5]
ldr r10, =0x1120
ldr r10, =0x1120
mov r9, #4
strle r0, [r10, #-12]
str r7, [r10, -r9]
ldr r10, =0x1120
ldrle r2, [r10, #-24]
ldrb r0, [r10], #12
ldrsh r11, [r10, -r9]
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
ldr r0, =0xc6d28a1e
ldr r1, =0x00000020
ldr r2, =0xbcce2531
ldr r3, =0x0000001f
ldr r4, =0x00000100
ldr r5, =0xf13d782a
ldr r6, =0x2a06c354
ldr r7, =0x00000101
ldr r8, =0x000000ff
ldr r9, =0x0b4f5903
ldr r10, =0x00000000
ldr r11, =0x353306d1
ldr r12, =0x5ae9215f
ldr r14, =0x80000000
cmp r6, r7
movlt r0, #113
movpl r1, #32
movgt r2, #62
movvc r3, #121
moveq r4, #84
movge r5, #79
ldr r10, =0x1120
ldmia r10, {r12}
ldr r10, =0x1120
stmia r10, {r8,r11,r12}
ldr r10, =0x1120
stmdb r10, {r2,r3,r6,r7,r12}
ldr r10, =0x1120
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
orrs r3, r1, r6, lsl #19
adcvs r6, r9, r12, asr #11
rsbs r1, r0, r5, ror #24
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
ldr r0, =0x00000020
ldr r1, =0x00000101
ldr r2, =0x00000020
ldr r3, =0x0000001f
ldr r4, =0x80000001
ldr r5, =0x00000020
ldr r6, =0x00000020
ldr r7, =0x80000000
ldr r8, =0x7ab708dd
ldr r9, =0x0000001f
ldr r10, =0xd7a8a42c
ldr r11, =0x7add9ea9
ldr r12, =0x0000001f
ldr r14, =0x752ded6e
teq r3, r0
ldr r10, =0x1120
mov r9, #16
ldrsh r11, [r10, #-10]
str r11, [r10, #28]
ldr r10, =0x1120
strh r5, [r10], -r9
strh r14, [r10, -r9]
strh r12, [r10, #4]
ldrb r14, [r10, r9]
ldr r10, =0x1120
stmda r10!, {r3,r4,r6,r11}
ldr r10, =0x1120
ldmdb r10!, {r6}
ldr r10, =0x1120
stmdb r10, {r2,r3,lr}
ldr r10, =0x1120
blne 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
movhi r0, #132
moveq r1, #173
movlt r2, #55
movvc r3, #40
movvs r4, #11
movne r5, #19
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
ldr r0, =0x12345678
ldr r1, =0x80000001
ldr r2, =0x0517b4f4
ldr r3, =0x0000ffff
ldr r4, =0x00000001
ldr r5, =0x22e74e5f
ldr r6, =0x80000001
ldr r7, =0x6851329b
ldr r8, =0x0000ffff
ldr r9, =0x00000020
ldr r10, =0x00000020
ldr r11, =0x00000000
ldr r12, =0x6a651b43
ldr r14, =0x7ffffffe
tst r10, r3
movcs r0, #146
movle r1, #71
movlt r2, #61
movcs r3, #85
movvc r4, #62
movle r5, #83
orr r12, r11, #0x63000000
teqlt r1, r2, lsl #22
eor r14, r5, r10, ror #13
movs r1, r9, asr #17
cmnvc r8, r6, lsr r12
mvns r4, r6, lsl #16
sub r7, pc, #24
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
ldr r0, =0x80000001
ldr r1, =0x00000021
ldr r2, =0x76629a3e
ldr r3, =0x02937f24
ldr r4, =0xb69f8191
ldr r5, =0x6bb51386
ldr r6, =0x8260f671
ldr r7, =0x3e3e2d0b
ldr r8, =0x3dc31c41
ldr r9, =0x00000021
ldr r10, =0x00000021
ldr r11, =0x00000020
ldr r12, =0xce280f0c
ldr r14, =0x80000000
cmp r3, r4
adcs r0, r10, r12
orrhi r10, r8, r14, lsr r6
orrcs r11, r2, r6, lsr r10
ldr r10, =0x1120
mov r9, #0
ldr r12, [r10, #20]!
ldr r10, =0x1120
ldrsh r2, [r10], r9
ldr r11, [r10, #8]!
ldr r4, [r10], #20
movs r6, #0xf0000002
sbc r4, r8, r3, asr r11
adc r6, r3, r14, ror #2
orr r14, r8, r11, lsl r12
rsbsls r3, r1, #0x47
moveq r0, #187
movge r1, #157
movhi r2, #56
moveq r3, #13
movls r4, #189
movge r5, #116
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
ldr r0, =0x80000000
ldr r1, =0x80000001
ldr r2, =0xcafebabe
ldr r3, =0x806393cc
ldr r4, =0x6d091917
ldr r5, =0xd7663f7e
ldr r6, =0x5f0eb5bf
ldr r7, =0x00000020
ldr r8, =0xffffffff
ldr r9, =0xd09581fa
ldr r10, =0x80000000
ldr r11, =0xffffffff
ldr r12, =0x7fffffff
ldr r14, =0x2d822b65
tst r8, r12
mvns r4, #0x35800000
subsgt r0, r6, r1, lsl r3
adc r3, r11, r4, asr r0
teq r14, #0x1640000
sbcs r12, r9, #0xed
mvnvs r4, r8, rrx
tst r8, r12, lsr r2
subs r12, r14, r2, ror #11
tsteq r0, r2, ror r10
ldr r10, =0x1120
mov r9, #0
ldrhhi r4, [r10, #8]!
ldr r10, =0x1120
ldrshcs r3, [r10], -r9
ldr r10, =0x1120
ldrb r14, [r10, #12]!
strh r14, [r10], -r9
strhi r2, [r10, #-16]
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
ldr r0, =0x7fffffff
ldr r1, =0x7ffffffe
ldr r2, =0xb4b047a5
ldr r3, =0x0000ffff
ldr r4, =0x15249807
ldr r5, =0x0000001f
ldr r6, =0x79d4655d
ldr r7, =0x7ffffffe
ldr r8, =0x12345678
ldr r9, =0x00000101
ldr r10, =0x0000ffff
ldr r11, =0x015474c5
ldr r12, =0x00000002
ldr r14, =0x00000020
cmn r1, r11
movvc r0, #146
movhi r1, #80
movvc r2, #195
movvc r3, #143
movls r4, #66
movgt r5, #59
tstmi r10, r5, lsr r3
mvns r3, r2, lsr #19
eors r11, r12, r10, lsl r9
mvns r10, #0x210
teqhi r4, r3, asr r10
subs r5, r10, r8, asr #10
sub r1, r2, r11, lsl r11
and r1, r9, #0xd9000
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
