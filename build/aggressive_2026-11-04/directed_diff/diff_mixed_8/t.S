.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x8bb6c787
str r0, [r12, #0]
ldr r0, =0x40cac47b
str r0, [r12, #4]
ldr r0, =0xf6056a48
str r0, [r12, #8]
ldr r0, =0x9b69f00a
str r0, [r12, #12]
ldr r0, =0x56e7f53d
str r0, [r12, #16]
ldr r0, =0x994177ef
str r0, [r12, #20]
ldr r0, =0x1637ca44
str r0, [r12, #24]
ldr r0, =0x4cf849bb
str r0, [r12, #28]
ldr r0, =0x9f4c8ab0
str r0, [r12, #32]
ldr r0, =0x69374685
str r0, [r12, #36]
ldr r0, =0x00000100
str r0, [r12, #40]
ldr r0, =0x80000000
str r0, [r12, #44]
ldr r0, =0xcafebabe
str r0, [r12, #48]
ldr r0, =0x80000001
str r0, [r12, #52]
ldr r0, =0xbe3412a7
str r0, [r12, #56]
ldr r0, =0x0eb60f39
str r0, [r12, #60]
ldr r0, =0x799aad5b
ldr r1, =0x00000000
ldr r2, =0x7ffffffe
ldr r3, =0x80000000
ldr r4, =0x00000100
ldr r5, =0x33039cd2
ldr r6, =0x00000000
ldr r7, =0x00000000
ldr r8, =0x7b64377c
ldr r9, =0xd7bcb59b
ldr r10, =0xa417c35d
ldr r11, =0x780e3a82
ldr r12, =0xc82044ff
ldr r14, =0xa9e25032
teq r0, r9
ldr r10, =0x1120
mov r9, #0
ldrsh r6, [r10, #-6]
ldr r10, =0x1120
str r1, [r10, #8]!
ldrbmi r6, [r10, #4]!
ldr r10, =0x1120
ldrsh r11, [r10], #0
ldr r7, [r10, -r9]
str r11, [r10, #12]
ldrsh r6, [r10, r9]
ldr r10, =0x1120
ldr r10, =0x1120
ldmibcc r10, {r4,r7,r11}
ldr r10, =0x1120
ldmda r10!, {r8}
ldr r10, =0x1120
sbcs r8, r1, #0x80
cmn r11, r6, lsr r9
movlt r2, r4, ror r5
rsc r1, r7, #0x40000001
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x00000100
ldr r1, =0x00000100
ldr r2, =0xcafebabe
ldr r3, =0xe1d8eb1a
ldr r4, =0x3c993681
ldr r5, =0xaf93e670
ldr r6, =0x00000100
ldr r7, =0x0000ffff
ldr r8, =0xbd519314
ldr r9, =0x81768f8a
ldr r10, =0x00000100
ldr r11, =0xde6edcc8
ldr r12, =0xffffffff
ldr r14, =0x00000000
cmp r8, r1
ldr r10, =0x1120
mov r9, #4
strls r11, [r10, #-4]
ldrsb r11, [r10], r9
ldr r5, [r10, #0]!
ldr r10, =0x1120
ldrge r1, [r10, #-16]
ldr r10, =0x1120
strh r1, [r10, #0]
ldr r10, =0x1120
strbne r12, [r10, #12]
strhlt r4, [r10, -r9]
ldr r10, =0x1120
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
mov r1, pc
ldr r10, =0x1120
stmdb r10!, {r0,r2,r4}
ldr r10, =0x1120
ldmibhi r10, {r5,r7,r12}
ldr r10, =0x1120
ldr r10, =0x1120
stmdb r10, {r0}
ldr r10, =0x1120
ldmia r10!, {r1,r6,r8,lr}
ldr r10, =0x1120
ldmda r10!, {r1,r4}
ldr r10, =0x1120
ldmib r10, {r0,r1,r6,r8,r11}
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
ldr r0, =0x00000101
ldr r1, =0x00000100
ldr r2, =0x7fffffff
ldr r3, =0x9d045a22
ldr r4, =0x9b1b107c
ldr r5, =0x0000001f
ldr r6, =0x5833caf4
ldr r7, =0xb383b9a7
ldr r8, =0xd0b020be
ldr r9, =0x00000100
ldr r10, =0x12345678
ldr r11, =0x000000ff
ldr r12, =0x00000020
ldr r14, =0x1b6eb3c9
tst r2, r9
addge pc, pc, #0
add r1, r1, #1
add r2, r2, #1
movvs r0, #57
moveq r1, #91
movcs r2, #75
movcc r3, #191
movpl r4, #59
movgt r5, #139
addle pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x00000001
ldr r1, =0x12345678
ldr r2, =0x80000000
ldr r3, =0x00000101
ldr r4, =0x7fffffff
ldr r5, =0xffffffff
ldr r6, =0x0000ffff
ldr r7, =0x6a50f8a6
ldr r8, =0x80000000
ldr r9, =0x00000020
ldr r10, =0x811cfe80
ldr r11, =0x6db8c514
ldr r12, =0x7fffffff
ldr r14, =0x00000020
cmp r14, r14
ldr r10, =0x1120
stmda r10!, {r5,r11}
ldr r10, =0x1120
stmia r10!, {r0,r7,r11,lr}
ldr r10, =0x1120
stmib r10!, {r1,r2,r3,r7,r12}
ldr r10, =0x1120
addpl pc, pc, #0
add r1, r1, #1
add r2, r2, #1
addscc r14, r2, r3, asr r10
cmn r7, r14, asr r14
adcsvc r8, r9, r10, rrx
orrhi r12, r14, #0x60000000
ldr r10, =0x1120
mov r9, #0
str r3, [r10, #24]
ldrsb r4, [r10], -r9
ldrsh r3, [r10, -r9]
ldr r10, =0x1120
ldrsb r3, [r10, r9]
ldr r10, =0x1120
ldrh r14, [r10], #8
ldr r10, =0x1120
ldrsh r5, [r10, r9]
ldrsb r2, [r10], #4
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
ldr r0, =0x3c4fd73f
ldr r1, =0x00000020
ldr r2, =0x00000020
ldr r3, =0x86254dd8
ldr r4, =0x93cec8ad
ldr r5, =0x8d403e26
ldr r6, =0xa80ce52f
ldr r7, =0x00000101
ldr r8, =0x1f94c91d
ldr r9, =0x8507b322
ldr r10, =0xffffffff
ldr r11, =0x1dc04dab
ldr r12, =0x80000000
ldr r14, =0x00000001
teq r10, r3
ands r6, r8, r8, ror r6
mov r8, r5, ror #27
mvn r12, r3, rrx
bics r1, r2, r11, ror r8
teq r14, #0x4e0
cmnle r10, r12
rsc r7, r4, r2, rrx
cmppl r9, r0, ror r14
bicsvs r14, r5, r14, lsr r7
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
ldr r0, =0x00000021
ldr r1, =0xa8a804af
ldr r2, =0x00000100
ldr r3, =0x053a225c
ldr r4, =0xcafebabe
ldr r5, =0x00000020
ldr r6, =0x0000ffff
ldr r7, =0x0000ffff
ldr r8, =0x5f32c653
ldr r9, =0x00000101
ldr r10, =0x0000001f
ldr r11, =0x00000021
ldr r12, =0x7ffffffe
ldr r14, =0xcafebabe
cmn r14, r1
ldr r10, =0x1120
ldmda r10!, {r6,r12,lr}
ldr r10, =0x1120
stmda r10!, {r5,r6,r11}
ldr r10, =0x1120
ldmda r10!, {r2,r12}
ldr r10, =0x1120
addeq pc, pc, #0
add r1, r1, #1
add r2, r2, #1
sub r1, pc, #40
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
ldr r0, =0x000000ff
ldr r1, =0x5e8ca846
ldr r2, =0x92aa3dac
ldr r3, =0x8c424017
ldr r4, =0x78286fb4
ldr r5, =0xb7ac6c35
ldr r6, =0x0000001f
ldr r7, =0x00000021
ldr r8, =0x00000000
ldr r9, =0x681d0f22
ldr r10, =0x0000ffff
ldr r11, =0x4221f6ae
ldr r12, =0xa419dfe7
ldr r14, =0x00000100
cmp r14, r4
ldr r10, =0x1120
mov r9, #12
ldrsh r8, [r10, #6]
ldr r10, =0x1120
ldr r0, [r10, #4]
ldrvc r12, [r10, #-0]
strh r12, [r10], -r9
bmi 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
movgt r0, #101
movhi r1, #82
movhi r2, #65
movvc r3, #95
moveq r4, #63
movcc r5, #197
ldr r10, =0x1120
adr r3, 1f
str r3, [r10, #4]
ldmia r10, {r4, pc}
add r0, r0, #7
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
ldr r0, =0xffffffff
ldr r1, =0x7fffffff
ldr r2, =0x1dbf732c
ldr r3, =0x895aa816
ldr r4, =0x80000000
ldr r5, =0x00000100
ldr r6, =0x80000001
ldr r7, =0x720ec36b
ldr r8, =0x6169ca56
ldr r9, =0x040965dd
ldr r10, =0x7fffffff
ldr r11, =0x00000001
ldr r12, =0x4594f1c2
ldr r14, =0x4a6be511
cmn r2, r2
orr r6, r8, r10, lsl #31
bics r1, r5, r6, asr r11
bics r8, r2, #0x99000
adds r3, r8, r12, lsr r8
suble r9, r1, #0x340
mov r4, r14, asr #12
bics r7, r11, r12
tst r1, r2
sbcs r7, r14, r4, lsr #13
mov r3, r12, lsl r5
adc r3, r3, r6, asr #27
tst r2, r2
sbcs r11, r8, #0xaa000000
ldr r10, =0x1120
adr r3, 1f
str r3, [r10, #4]
ldmia r10, {r4, pc}
add r0, r0, #7
1:
cmp r9, r6, lsr #8
rsb r14, r8, #0xba000000
teqvs r11, r12
rscvc r14, r2, r3, lsl r5
rscs r11, r14, r6, lsr r1
cmn r6, r8
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
