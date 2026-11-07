.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xcafebabe
str r0, [r12, #0]
ldr r0, =0xcafebabe
str r0, [r12, #4]
ldr r0, =0x00000100
str r0, [r12, #8]
ldr r0, =0x9ea09a65
str r0, [r12, #12]
ldr r0, =0x3b7dbe0e
str r0, [r12, #16]
ldr r0, =0x0000001f
str r0, [r12, #20]
ldr r0, =0x6f513138
str r0, [r12, #24]
ldr r0, =0x13114891
str r0, [r12, #28]
ldr r0, =0x80000001
str r0, [r12, #32]
ldr r0, =0x0000ffff
str r0, [r12, #36]
ldr r0, =0xec80229c
str r0, [r12, #40]
ldr r0, =0x0000001f
str r0, [r12, #44]
ldr r0, =0x00000001
str r0, [r12, #48]
ldr r0, =0x7ffffffe
str r0, [r12, #52]
ldr r0, =0x7bc246c6
str r0, [r12, #56]
ldr r0, =0x0000001f
str r0, [r12, #60]
ldr r0, =0x00000000
ldr r1, =0x001515f2
ldr r2, =0x000000ff
ldr r3, =0x7ffffffe
ldr r4, =0x0000ffff
ldr r5, =0x045d0b3a
ldr r6, =0x000000ff
ldr r7, =0x000000ff
ldr r8, =0x403c8ac3
ldr r9, =0xac64ee96
ldr r10, =0x63575c05
ldr r11, =0x223352d3
ldr r12, =0xeccec956
ldr r14, =0x00000002
cmn r0, r12
ldr r10, =0x1120
mov r9, #8
ldr r1, [r10], #0
str r3, [r10], -r9
ldrmi r8, [r10, r9]
ldr r10, =0x1120
ldrhmi r11, [r10, -r9]
ldr r10, =0x1120
strb r7, [r10, r9]
movgt r0, #37
movhi r1, #49
movcc r2, #81
movcc r3, #177
moveq r4, #29
movls r5, #141
bne 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
moveq r0, #106
movlt r1, #33
movpl r2, #62
movcc r3, #41
moveq r4, #181
movvc r5, #127
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
ldr r1, =0x280ab684
ldr r2, =0x7e01bbe9
ldr r3, =0xe4145166
ldr r4, =0x56c3cbcd
ldr r5, =0x0000ffff
ldr r6, =0x0000001f
ldr r7, =0x66aa35db
ldr r8, =0xd06da975
ldr r9, =0x98888a72
ldr r10, =0x641cbf30
ldr r11, =0x12345678
ldr r12, =0x00000001
ldr r14, =0x3670d878
tst r2, r0
movhi r0, #183
moveq r1, #98
movmi r2, #2
moveq r3, #89
movcc r4, #20
movcs r5, #186
cmnhi r2, #0x38000
cmphi r7, r14, ror #23
orrcc r0, r5, r3, lsl r2
adcs r6, r5, r12, lsl r5
rsbs r10, r8, r3, ror #3
bic r0, r12, r14, lsr #17
ldr r10, =0x1120
mov r9, #4
ldrble r0, [r10], -r9
ldrshge r12, [r10, #-8]
ldr r10, =0x1120
strh r7, [r10, #-4]
ldrh r12, [r10], #16
ldr r10, =0x1120
ldrsh r0, [r10, #-10]
strbvc r8, [r10], #4
strhge r4, [r10, -r9]
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
ldr r0, =0x0000ffff
ldr r1, =0x00000020
ldr r2, =0xef7bb06a
ldr r3, =0xf73b7404
ldr r4, =0xaf82d35b
ldr r5, =0xa2935914
ldr r6, =0x12345678
ldr r7, =0xb852ea2c
ldr r8, =0x80000000
ldr r9, =0xffe070a8
ldr r10, =0x00000100
ldr r11, =0x00000020
ldr r12, =0x22028d80
ldr r14, =0x00000000
tst r14, r14
orr r0, r6, r8
movs r5, r2, asr r0
cmp r3, #0x3a40000
subne r7, r3, r0, asr r11
movls r0, #105
movle r1, #116
movcs r2, #26
movge r3, #110
movne r4, #128
movhi r5, #68
ldr r10, =0x1120
ldmib r10!, {r3,r9,r11}
ldr r10, =0x1120
ldmda r10, {r3,r9,lr}
ldr r10, =0x1120
stmda r10!, {r1,r5}
ldr r10, =0x1120
movmi r0, #85
moveq r1, #44
movle r2, #36
movcs r3, #16
movgt r4, #145
movvs r5, #24
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
ldr r0, =0x7ffffffe
ldr r1, =0x0e630548
ldr r2, =0x80000000
ldr r3, =0x35cfb82a
ldr r4, =0xffffffff
ldr r5, =0x965c7ced
ldr r6, =0x41b28ea7
ldr r7, =0x99d51296
ldr r8, =0x0000ffff
ldr r9, =0x00000101
ldr r10, =0x38870492
ldr r11, =0x2894fbc4
ldr r12, =0x000000ff
ldr r14, =0x4689cc0d
cmn r2, r8
ldr r10, =0x1120
mov r9, #0
ldrsb r6, [r10], #16
ldr r10, =0x1120
ldr r12, [r10], #12
ldrsh r4, [r10, -r9]
ldrsheq r3, [r10, -r9]
ldr r10, =0x1120
str r11, [r10, #0]
eor r6, r9, r14, lsl r6
bics r14, r12, r0, ror r7
orr r12, r4, r0, rrx
rsbs r3, r2, r4, lsr #25
orrs r8, r5, r7
bics r10, r7, r1
and r7, r10, r1, lsr r2
subs r6, r3, r11, ror #27
rsbsge r4, r11, r14
ands r6, r11, r3, lsl r5
subs r7, r8, r2, ror #15
cmp r0, r1, lsl r14
cmn r1, r10, lsr r10
sbc r12, r2, r4, asr #20
cmn r4, r6, asr #17
rsbs r11, r9, r9, ror r4
ldr r10, =0x1120
ldmda r10!, {r2,r7,r8,r9}
ldr r10, =0x1120
stmda r10, {r5}
ldr r10, =0x1120
ldmiblt r10, {r4,r9}
ldr r10, =0x1120
ldmia r10!, {r2,r3,r8,r12,lr}
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
ldr r0, =0xa90ef671
ldr r1, =0x659c0ea4
ldr r2, =0xbb767f98
ldr r3, =0x0000001f
ldr r4, =0x80000001
ldr r5, =0x00000020
ldr r6, =0xf23408cd
ldr r7, =0xb1c58e39
ldr r8, =0x8b35f182
ldr r9, =0x00000000
ldr r10, =0x96bc8f21
ldr r11, =0xfea723ef
ldr r12, =0x5dc4e4da
ldr r14, =0xc2a610a4
tst r8, r2
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
bvc 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
adr r3, 1f
movge pc, r3
add r0, r0, #1
1:
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
ldr r1, =0x4fcb2ef9
ldr r2, =0xcafebabe
ldr r3, =0x00000100
ldr r4, =0x80000000
ldr r5, =0x6109b4e2
ldr r6, =0x3c81d195
ldr r7, =0x00000100
ldr r8, =0x00000001
ldr r9, =0x20479a16
ldr r10, =0x370ae44f
ldr r11, =0x0000ffff
ldr r12, =0x00000021
ldr r14, =0x000000ff
tst r11, r1
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
mvncc r10, r12, asr #8
cmp r6, r11
sbcpl r0, r9, r11, asr r7
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
ldr r1, =0x5a85c6fd
ldr r2, =0x8a989e1e
ldr r3, =0x00000020
ldr r4, =0x00000101
ldr r5, =0x00000001
ldr r6, =0x29565f1c
ldr r7, =0x500a127c
ldr r8, =0xe3fdf74b
ldr r9, =0xc3174a6f
ldr r10, =0x0000ffff
ldr r11, =0x4a89d733
ldr r12, =0xd36b3f24
ldr r14, =0xbd840d3a
tst r12, r14
ldr r10, =0x1120
ldmib r10!, {r0,r2,r3,r7}
ldr r10, =0x1120
ldmdavc r10, {r1,r8,r11,r12,lr}
ldr r10, =0x1120
ldmda r10, {r2,r9,r12}
ldr r10, =0x1120
stmdb r10, {r0,r6,r11,r12}
ldr r10, =0x1120
bmi 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
sbcmi r10, r6, r4, ror #16
mov r6, r1, asr r7
adc r8, r9, r4, lsl r8
rscscs r8, r3, r0, ror #27
subsle r12, r0, r9, ror r3
tstvs r10, r7
movge r0, #106
movhi r1, #43
movle r2, #111
movle r3, #166
movhi r4, #2
movvs r5, #148
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
ldr r0, =0x14cb6edd
ldr r1, =0x0000001f
ldr r2, =0x7fffffff
ldr r3, =0x00000101
ldr r4, =0x3a09a6ec
ldr r5, =0xffffffff
ldr r6, =0x8165c718
ldr r7, =0xd1eff89a
ldr r8, =0xde82f08f
ldr r9, =0x7fffffff
ldr r10, =0x860fe106
ldr r11, =0x80000001
ldr r12, =0x7fffffff
ldr r14, =0x00000100
teq r9, r12
subpl r4, r8, r2
add r11, r1, r12, ror #2
add r12, r12, r8, asr #4
cmppl r0, r10, lsl r8
and r10, r8, r9, asr r8
tst r9, r2, rrx
ldr r10, =0x1120
ldmiapl r10!, {r1,r9,r12}
ldr r10, =0x1120
stmda r10, {r2,r6,r11,r12}
ldr r10, =0x1120
mvnsmi r2, #0x20400
rscls r1, r5, r5
eors r12, r6, r4, lsr #6
orrs r12, r8, r10
ldr r10, =0x1120
adr r3, 1f
str r3, [r10, #4]
ldmia r10, {r4, pc}
add r0, r0, #7
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
