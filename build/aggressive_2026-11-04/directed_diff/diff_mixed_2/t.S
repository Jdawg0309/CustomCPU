.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x27dea5f1
str r0, [r12, #0]
ldr r0, =0x2f970878
str r0, [r12, #4]
ldr r0, =0xcafebabe
str r0, [r12, #8]
ldr r0, =0xc7a404b2
str r0, [r12, #12]
ldr r0, =0xcfb76f26
str r0, [r12, #16]
ldr r0, =0x7ffffffe
str r0, [r12, #20]
ldr r0, =0x5c5eec84
str r0, [r12, #24]
ldr r0, =0xde4cc798
str r0, [r12, #28]
ldr r0, =0x00000021
str r0, [r12, #32]
ldr r0, =0x8bdd0172
str r0, [r12, #36]
ldr r0, =0x0000001f
str r0, [r12, #40]
ldr r0, =0x00000101
str r0, [r12, #44]
ldr r0, =0xb1c76ca6
str r0, [r12, #48]
ldr r0, =0x0000001f
str r0, [r12, #52]
ldr r0, =0x00000101
str r0, [r12, #56]
ldr r0, =0x0f8a7a1d
str r0, [r12, #60]
ldr r0, =0xcafebabe
ldr r1, =0x00000101
ldr r2, =0x00000101
ldr r3, =0xffffffff
ldr r4, =0xefd11925
ldr r5, =0xdb6bec12
ldr r6, =0x80000000
ldr r7, =0xa1567355
ldr r8, =0x12345678
ldr r9, =0xd41aadee
ldr r10, =0x7ffffffe
ldr r11, =0x00000021
ldr r12, =0x7ffffffe
ldr r14, =0x000000ff
teq r7, r9
tst r5, r10
teq r12, r1
mvns r11, r14, lsr r0
ands r8, r5, r7, lsl #11
cmneq r6, #0x9d0000
orrmi r12, r14, r8, lsl r10
bic r4, r2, r1, asr r4
teqvc r2, #0x700000
cmp r3, r8, asr #30
ldr r10, =0x1120
mov r9, #8
ldr r2, [r10], #20
ldrhcs r7, [r10, r9]
ldr r12, [r10], r9
ldr r10, =0x1120
ldr r4, [r10], #0
ldrhi r6, [r10, r9]
ldr r10, =0x1120
ldmdb r10!, {r4}
ldr r10, =0x1120
ldmdb r10!, {r2}
ldr r10, =0x1120
ldmia r10, {r2,r3,r4,r5,r12}
ldr r10, =0x1120
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
ldr r0, =0x00000020
ldr r1, =0x0000001f
ldr r2, =0x80000001
ldr r3, =0x7d4969cd
ldr r4, =0xcafebabe
ldr r5, =0x77652dcd
ldr r6, =0x00000101
ldr r7, =0x00000101
ldr r8, =0xcb8c17fc
ldr r9, =0xf92bbd8c
ldr r10, =0x38ccde32
ldr r11, =0x00000000
ldr r12, =0x000000ff
ldr r14, =0x062d914d
cmp r4, r6
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bge 2f
add r1, r1, #7
2:
movlt r0, #57
movvc r1, #189
movgt r2, #71
movvs r3, #183
movge r4, #156
moveq r5, #183
cmpeq r3, r2, asr r12
cmp r14, r0, lsr #22
mvns r10, r4
orrls r2, r8, #0x5c000
teq r5, r11, lsl r6
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bge 2f
add r1, r1, #7
2:
sbc r9, r5, #0xd40000
tst r7, r8, asr #25
bic r0, r12, r7, ror r6
subs r4, r1, r8, lsl #24
add r14, r11, r6, rrx
rsbs r3, r8, r10, rrx
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
ldr r1, =0x000000ff
ldr r2, =0xffffffff
ldr r3, =0xc8b97bad
ldr r4, =0x00000100
ldr r5, =0x11d4eda6
ldr r6, =0x00000100
ldr r7, =0x00000000
ldr r8, =0x00000100
ldr r9, =0xdd88e7ba
ldr r10, =0x62e6e3a0
ldr r11, =0xb7629ce9
ldr r12, =0xfee945b5
ldr r14, =0x25615780
teq r7, r11
ldr r10, =0x1120
ldmda r10!, {r5,r7}
ldr r10, =0x1120
ldmia r10!, {r6,r11}
ldr r10, =0x1120
ldmia r10!, {r5,r7}
ldr r10, =0x1120
ldmib r10!, {r0,r3,r6,r9}
ldr r10, =0x1120
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r1, =0xcafebabe
ldr r2, =0x660184be
ldr r3, =0xc10e7407
ldr r4, =0x00000020
ldr r5, =0xa98736de
ldr r6, =0x31cdcb10
ldr r7, =0x000000ff
ldr r8, =0x8c8913cb
ldr r9, =0xcac11b1f
ldr r10, =0x0000ffff
ldr r11, =0xffffffff
ldr r12, =0x1330708f
ldr r14, =0x911602a1
cmp r7, r5
mov r2, pc
ands r11, r14, #0xd3000
teq r6, r10, asr r5
rsbmi r14, r6, r9, asr #22
tst r7, r9
rsbs r5, r5, r1, lsl r11
adcspl r7, r14, r7, asr r4
orrs r12, r9, r6, ror #5
cmn r3, r8, asr r9
orr r12, r2, r10, lsr #19
teqgt r12, r5
mov r6, r8, lsl r11
tst r7, #0xbe0
and r8, r14, r1, lsl r9
mvns r2, #0x60000002
mov r5, #0xaa0000
sbcs r11, r1, r7, lsr #5
sbcne r2, r7, r11
sbc r3, r12, r9, rrx
subne r3, r14, r10, lsl #21
bic r12, r3, r0
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
ldr r0, =0xb0820bf1
ldr r1, =0x324f86b3
ldr r2, =0x00000000
ldr r3, =0xc563e31e
ldr r4, =0x7ffffffe
ldr r5, =0x528e62ae
ldr r6, =0x80331392
ldr r7, =0xeab20ee7
ldr r8, =0xffffffff
ldr r9, =0x00000020
ldr r10, =0x29b482f9
ldr r11, =0x7fffffff
ldr r12, =0x00000020
ldr r14, =0x0000001f
teq r8, r8
movcs r0, #96
moveq r1, #60
movle r2, #60
movhi r3, #104
movge r4, #59
movmi r5, #53
bics r0, r11, r8, rrx
sbcgt r8, r14, r14, lsl r7
cmn r10, r10, lsr r10
sublt r14, r7, r4, rrx
mov r8, #0x80
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvc 2f
add r1, r1, #7
2:
ldr r10, =0x1120
ldmdb r10, {r5,r6}
ldr r10, =0x1120
ldmiapl r10, {r8}
ldr r10, =0x1120
movvc r0, #166
movcc r1, #32
movls r2, #82
movhi r3, #82
movhi r4, #40
movgt r5, #48
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
ldr r0, =0x7ffffffe
ldr r1, =0x7ffffffe
ldr r2, =0x00000021
ldr r3, =0x44690e2b
ldr r4, =0x80000001
ldr r5, =0xf712568e
ldr r6, =0x00000001
ldr r7, =0x495aebbb
ldr r8, =0x2c65a938
ldr r9, =0x7ffffffe
ldr r10, =0x00000101
ldr r11, =0x5942277a
ldr r12, =0x8e3ac6a8
ldr r14, =0x80000000
teq r5, r1
ldr r10, =0x1120
mov r9, #12
ldrsb r8, [r10], r9
ldrsh r7, [r10], #4
ldrshls r1, [r10, #-8]
strh r3, [r10, #8]!
ldr r10, =0x1120
addshi r11, r2, r3, lsl #28
sbcscc r9, r12, r4, asr r14
eorsne r3, r7, r3, lsr r14
teq r10, #0xd8000000
adds r10, r2, r0, lsr #11
and r7, r2, r12, lsl r9
and r10, r10, r3, ror r9
tst r9, r7, ror #16
orr r5, r3, r0, ror r14
adcspl r9, r1, #0x90000002
subeq r2, r6, r11
eors r4, r9, r9, lsl #23
ldr r10, =0x1120
stmib r10, {r1,r3,r4,r7,lr}
ldr r10, =0x1120
ldmdb r10, {r0,r3,r8,lr}
ldr r10, =0x1120
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
ldr r0, =0x00000000
ldr r1, =0x83ab223c
ldr r2, =0x6d6be7aa
ldr r3, =0x000000ff
ldr r4, =0x80000001
ldr r5, =0x857d74ca
ldr r6, =0x0000001f
ldr r7, =0xb2101cc2
ldr r8, =0xcf9751ae
ldr r9, =0x0000ffff
ldr r10, =0x5b277c20
ldr r11, =0x80000000
ldr r12, =0x96646765
ldr r14, =0xe6acf539
teq r4, r6
movgt r0, #3
movvc r1, #56
movls r2, #168
moveq r3, #27
movgt r4, #51
movmi r5, #147
blne 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
ldr r10, =0x1120
mov r9, #8
ldrsh r11, [r10, -r9]
ldr r10, =0x1120
ldrsh r11, [r10], #20
ldr r10, =0x1120
ldrbvc r8, [r10, -r9]
ldrshgt r6, [r10, #12]
ldr r10, =0x1120
ldrsh r12, [r10, #8]
ldr r2, [r10, r9]
ldr r10, =0x1120
ldr r10, =0x1120
ldmdb r10!, {r11,r12}
ldr r10, =0x1120
stmdb r10!, {r1,r3,r4,r9,lr}
ldr r10, =0x1120
stmib r10!, {r5,r6,r7,r9,r12}
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
ldr r0, =0x00000101
ldr r1, =0x89230d8e
ldr r2, =0x000000ff
ldr r3, =0xb721034d
ldr r4, =0x80000000
ldr r5, =0x000000ff
ldr r6, =0x80000001
ldr r7, =0x23523189
ldr r8, =0xcafebabe
ldr r9, =0x00000100
ldr r10, =0x80000001
ldr r11, =0x1025b1c6
ldr r12, =0x0000ffff
ldr r14, =0x427f5adc
teq r14, r10
ldr r10, =0x1120
stmda r10, {r0,r1,r3,r7,r9}
ldr r10, =0x1120
ldmdb r10!, {r1,r4,r11}
ldr r10, =0x1120
stmdb r10!, {r1,r5,r7}
ldr r10, =0x1120
movpl r0, #123
movgt r1, #193
movmi r2, #180
movhi r3, #138
movgt r4, #87
movmi r5, #173
ldr r10, =0x1120
mov r9, #8
ldrsb r0, [r10, #-18]
ldrb r2, [r10, #-0]
str r2, [r10, -r9]
ldrsh r6, [r10, #-14]
movge r0, #105
movle r1, #199
movne r2, #124
movmi r3, #34
movgt r4, #188
movne r5, #193
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
