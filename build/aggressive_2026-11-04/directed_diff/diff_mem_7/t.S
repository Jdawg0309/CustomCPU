.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x6c8239bf
str r0, [r12, #0]
ldr r0, =0x31f394fb
str r0, [r12, #4]
ldr r0, =0x53be6df4
str r0, [r12, #8]
ldr r0, =0x00000100
str r0, [r12, #12]
ldr r0, =0x95f499df
str r0, [r12, #16]
ldr r0, =0x000000ff
str r0, [r12, #20]
ldr r0, =0x7fffffff
str r0, [r12, #24]
ldr r0, =0x00000021
str r0, [r12, #28]
ldr r0, =0x00000002
str r0, [r12, #32]
ldr r0, =0x0000001f
str r0, [r12, #36]
ldr r0, =0x7fffffff
str r0, [r12, #40]
ldr r0, =0x7fffffff
str r0, [r12, #44]
ldr r0, =0x00000021
str r0, [r12, #48]
ldr r0, =0x5b9d8d52
str r0, [r12, #52]
ldr r0, =0x03326ef7
str r0, [r12, #56]
ldr r0, =0x618d2591
str r0, [r12, #60]
ldr r0, =0x00000002
ldr r1, =0x40efe2a3
ldr r2, =0x5fbaa28c
ldr r3, =0x9b2215e8
ldr r4, =0x88eee943
ldr r5, =0x12345678
ldr r6, =0x14740083
ldr r7, =0xc2720335
ldr r8, =0x4d6dc085
ldr r9, =0xaee10fdd
ldr r10, =0x12345678
ldr r11, =0x00000002
ldr r12, =0xcafebabe
ldr r14, =0x00000000
teq r14, r12
ldr r10, =0x1120
mov r9, #12
ldrsb r7, [r10, #16]!
ldrsb r1, [r10, #12]!
ldrsh r1, [r10, #-2]
strh r1, [r10], #0
ldr r1, [r10, #20]!
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
ldr r0, =0x80000001
ldr r1, =0x7329f531
ldr r2, =0x80000001
ldr r3, =0x33b4fac9
ldr r4, =0x1fe42a0f
ldr r5, =0xb5ae1cb6
ldr r6, =0xdf8f5ef8
ldr r7, =0x00000021
ldr r8, =0x1444938a
ldr r9, =0xa53b0c21
ldr r10, =0x184bee3d
ldr r11, =0x000000ff
ldr r12, =0x6301cb53
ldr r14, =0xbef0e74d
cmp r14, r10
ldr r10, =0x1120
mov r9, #0
ldrhmi r14, [r10, #-0]
ldr r10, =0x1120
ldrsheq r8, [r10, #2]
ldr r10, =0x1120
str r4, [r10], #12
ldr r10, =0x1120
strle r2, [r10, #-0]
ldr r10, =0x1120
ldrsh r5, [r10, #16]!
ldrsb r7, [r10, -r9]
ldrshvs r5, [r10, -r9]
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
ldr r0, =0x8a293678
ldr r1, =0x000000ff
ldr r2, =0x12345678
ldr r3, =0x4b47846a
ldr r4, =0x00000021
ldr r5, =0xb9e05995
ldr r6, =0x00000100
ldr r7, =0xce77aa29
ldr r8, =0xaf676c9e
ldr r9, =0x00000001
ldr r10, =0x13ecaa89
ldr r11, =0x000000ff
ldr r12, =0xa69832aa
ldr r14, =0x755ce0ca
cmn r2, r2
ldr r10, =0x1120
mov r9, #0
ldrvc r14, [r10, #0]
ldrsbcs r5, [r10, r9]
ldr r10, =0x1120
ldr r12, [r10], r9
strh r5, [r10, #8]
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
ldr r1, =0x7fef3c10
ldr r2, =0x00000000
ldr r3, =0xcf6bff65
ldr r4, =0xe1bb12a1
ldr r5, =0x7fffffff
ldr r6, =0x80000001
ldr r7, =0x1f4c5e44
ldr r8, =0x80000001
ldr r9, =0xab9a2c5b
ldr r10, =0xae83d26c
ldr r11, =0x787a33f6
ldr r12, =0xcafebabe
ldr r14, =0x9592b16f
cmp r9, r14
ldr r10, =0x1120
mov r9, #8
str r11, [r10, -r9]
ldr r10, =0x1120
ldr r8, [r10], #20
str r2, [r10, #-24]
ldrh r2, [r10, #14]
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
ldr r0, =0xdbbdd2ef
ldr r1, =0x000000ff
ldr r2, =0x7ffffffe
ldr r3, =0x36da4fad
ldr r4, =0x12345678
ldr r5, =0x905e7502
ldr r6, =0x00000021
ldr r7, =0xe1b83427
ldr r8, =0x697fd718
ldr r9, =0x0000001f
ldr r10, =0xffffffff
ldr r11, =0xa8a9e2ea
ldr r12, =0x1933d380
ldr r14, =0x59b1eebb
teq r9, r0
ldr r10, =0x1120
mov r9, #16
str r14, [r10], r9
str r3, [r10, #-20]
ldr r10, =0x1120
ldrsh r2, [r10, #6]
strlt r6, [r10, -r9]
ldrsh r14, [r10], #12
ldr r10, =0x1120
ldrsb r6, [r10], #20
ldrsh r5, [r10], r9
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
ldr r1, =0xa68f32b5
ldr r2, =0xbeb30f2f
ldr r3, =0x09b7493b
ldr r4, =0x0000ffff
ldr r5, =0x7fffffff
ldr r6, =0x7ffffffe
ldr r7, =0xd4472dc5
ldr r8, =0x7ffffffe
ldr r9, =0x000000ff
ldr r10, =0x55bc6efe
ldr r11, =0x12345678
ldr r12, =0x000000ff
ldr r14, =0xf6ade669
cmp r11, r9
ldr r10, =0x1120
mov r9, #12
ldrsb r3, [r10, #-17]
ldr r10, =0x1120
ldrh r5, [r10], #12
ldrb r12, [r10, #-3]
ldr r10, =0x1120
str r5, [r10, r9]
ldr r10, =0x1120
ldrshle r2, [r10, #20]!
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
ldr r0, =0x222ae285
ldr r1, =0xcd50687e
ldr r2, =0xee31fe0f
ldr r3, =0x7fffffff
ldr r4, =0x603db5c3
ldr r5, =0x8f747365
ldr r6, =0x6bb85e38
ldr r7, =0x0000001f
ldr r8, =0x80000001
ldr r9, =0x00000001
ldr r10, =0x00000021
ldr r11, =0x90fcc80f
ldr r12, =0x7fffffff
ldr r14, =0xd56d7cb2
cmp r10, r10
ldr r10, =0x1120
mov r9, #4
ldrsb r1, [r10, #7]
strb r2, [r10, -r9]
ldrsbgt r3, [r10, #-13]
ldrh r7, [r10], r9
strh r8, [r10, -r9]
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
ldr r0, =0xa0ac6463
ldr r1, =0x46f34250
ldr r2, =0x00000001
ldr r3, =0x3619c6bd
ldr r4, =0xb1b77abe
ldr r5, =0x69488e00
ldr r6, =0x00000002
ldr r7, =0x58dea27d
ldr r8, =0x822f57ba
ldr r9, =0x39f4e1c6
ldr r10, =0x0000001f
ldr r11, =0xd85f42ca
ldr r12, =0xba3144de
ldr r14, =0xcafebabe
cmn r10, r3
ldr r10, =0x1120
mov r9, #0
ldrble r12, [r10, #12]
ldr r10, =0x1120
ldr r14, [r10, #4]
ldrh r12, [r10], r9
ldrsb r7, [r10, #13]
ldrh r14, [r10, #20]!
ldr r10, =0x1120
ldrh r5, [r10], r9
ldr r10, =0x1120
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
