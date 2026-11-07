.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x4c96cb98
str r0, [r12, #0]
ldr r0, =0xb9b1a322
str r0, [r12, #4]
ldr r0, =0x6218a72b
str r0, [r12, #8]
ldr r0, =0x00000021
str r0, [r12, #12]
ldr r0, =0x3cbe8d69
str r0, [r12, #16]
ldr r0, =0x12345678
str r0, [r12, #20]
ldr r0, =0x113d6516
str r0, [r12, #24]
ldr r0, =0xba5248f4
str r0, [r12, #28]
ldr r0, =0x7ffffffe
str r0, [r12, #32]
ldr r0, =0xa9f2a0b5
str r0, [r12, #36]
ldr r0, =0x7fffffff
str r0, [r12, #40]
ldr r0, =0x2ff633cf
str r0, [r12, #44]
ldr r0, =0x00000000
str r0, [r12, #48]
ldr r0, =0x00000002
str r0, [r12, #52]
ldr r0, =0xbaf751d6
str r0, [r12, #56]
ldr r0, =0x00000100
str r0, [r12, #60]
ldr r0, =0x4d75810f
ldr r1, =0xd47d6883
ldr r2, =0xcafebabe
ldr r3, =0x9edd8eae
ldr r4, =0x8a22b2ed
ldr r5, =0xa1f8393b
ldr r6, =0x7fffffff
ldr r7, =0x01b8c877
ldr r8, =0xcc1e0e25
ldr r9, =0x0cd57bfc
ldr r10, =0x00000101
ldr r11, =0x103f5bc8
ldr r12, =0x25b2dbc2
ldr r14, =0x61bc6a8a
cmp r11, r3
adds r2, r3, r9
eorvs r5, r9, #0xf0000
mov r0, r14
subs r5, r11, #0x80000004
movs r0, r0, ror r5
cmp r10, r11
ldr r10, =0x1120
stmibgt r10!, {r3,lr}
ldr r10, =0x1120
stmia r10, {r0,r7,r8,r9,r11}
ldr r10, =0x1120
ldmia r10!, {r0,r4,r6,r7,r8}
ldr r10, =0x1120
ldr r10, =0x1120
mov r9, #12
ldrsh r14, [r10], -r9
str r3, [r10, #-8]
ldrhmi r1, [r10], #20
ldrpl r6, [r10, r9]
ldrsh r0, [r10, #-2]
mov r7, pc
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
ldr r0, =0xdae2db93
ldr r1, =0x80000000
ldr r2, =0x2ff663df
ldr r3, =0xcafebabe
ldr r4, =0x00000021
ldr r5, =0x3a141d17
ldr r6, =0x198b4e75
ldr r7, =0x7960866d
ldr r8, =0x7ffffffe
ldr r9, =0x5814572f
ldr r10, =0x000000ff
ldr r11, =0x59b31f6a
ldr r12, =0x00000000
ldr r14, =0x80000000
cmp r0, r14
tstgt r7, r1, ror r0
cmnlt r0, #0x54000003
orrmi r4, r14, r4
sub r6, r9, r11
teq r6, r4, ror r2
sub r5, r10, r14
teq r7, r0, rrx
cmp r4, r12, lsl r11
ands r4, r2, r5, lsr r12
sbcs r9, r8, #0xec0
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
rscs r11, r9, r1, lsl #13
mvns r2, r7, asr r2
orrs r5, r8, r5
rscs r9, r6, r3, lsl #21
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
ldr r0, =0xa5f4eba5
ldr r1, =0x00000021
ldr r2, =0x00000101
ldr r3, =0xf345b142
ldr r4, =0xc2a6d7e7
ldr r5, =0x00000101
ldr r6, =0x00000020
ldr r7, =0xa2fc8efd
ldr r8, =0x00000021
ldr r9, =0xfbd67879
ldr r10, =0x00000100
ldr r11, =0x00000101
ldr r12, =0x48edfd11
ldr r14, =0x0efcfcb0
tst r7, r0
ldr r10, =0x1120
mov r9, #8
strhvc r5, [r10], r9
ldrsh r2, [r10], -r9
ldrsh r14, [r10, #-2]
ldr r10, =0x1120
strh r0, [r10], r9
ldr r10, =0x1120
ldr r10, =0x1120
stmdb r10, {r3,r9}
ldr r10, =0x1120
stmdacs r10!, {r0}
ldr r10, =0x1120
ldr r10, =0x1120
mov r9, #0
ldrsbcc r3, [r10, #18]
ldr r1, [r10], -r9
ldr r10, =0x1120
ldrsh r1, [r10, #-4]
ldrb r11, [r10, r9]
ldrh r3, [r10], r9
ldrsb r6, [r10, #0]!
ldrsb r7, [r10, #0]!
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
ldr r0, =0xa9413b68
ldr r1, =0xdcc4e89b
ldr r2, =0xdf43e450
ldr r3, =0xfde842fe
ldr r4, =0x63171707
ldr r5, =0xcd5ec23b
ldr r6, =0x55274444
ldr r7, =0x00000100
ldr r8, =0x77b8afa7
ldr r9, =0x02f0620e
ldr r10, =0x0000ffff
ldr r11, =0xe8d0d6b7
ldr r12, =0x80000000
ldr r14, =0x00000020
tst r6, r6
cmp r0, r3
orr r8, r6, r10, asr #32
eor r8, r3, r8, asr #12
eors r9, r11, r4, lsr #3
cmp r12, r1, lsl r3
ands r10, r0, #0x6c000001
cmn r3, r2, lsl #13
orrs r8, r6, r8, ror r11
rsc r6, r4, r11, asr r1
teq r12, #0x6a00
eor r14, r5, r7, ror r14
ldr r10, =0x1120
stmia r10, {r5,r9}
ldr r10, =0x1120
ldmdbcs r10!, {r1,r9}
ldr r10, =0x1120
ldmia r10!, {r3,r5,r7}
ldr r10, =0x1120
stmiale r10!, {r2,r7}
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
ldr r0, =0x12ad97b9
ldr r1, =0xcafebabe
ldr r2, =0x00000001
ldr r3, =0x1dec7981
ldr r4, =0x00000100
ldr r5, =0x0000001f
ldr r6, =0x00000101
ldr r7, =0xc6568860
ldr r8, =0x00000000
ldr r9, =0x00000001
ldr r10, =0x0000001f
ldr r11, =0x7311cef6
ldr r12, =0x7fffffff
ldr r14, =0x000000ff
teq r7, r9
ldr r10, =0x1120
stmdage r10!, {r5,r6,r9,lr}
ldr r10, =0x1120
stmia r10, {r4,r9,r11,lr}
ldr r10, =0x1120
movpl r0, #40
movvc r1, #60
movls r2, #158
movcs r3, #189
movpl r4, #108
moveq r5, #145
blhi 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
ldr pc, =1f
add r0, r0, #3
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
ldr r0, =0x00000101
ldr r1, =0x31da3083
ldr r2, =0xcafebabe
ldr r3, =0xe5a2903a
ldr r4, =0x1a00ab41
ldr r5, =0x0000ffff
ldr r6, =0x9568aab6
ldr r7, =0x98b02295
ldr r8, =0x63db821e
ldr r9, =0x00000101
ldr r10, =0x0000001f
ldr r11, =0x00000002
ldr r12, =0x80000000
ldr r14, =0xa282e109
tst r8, r1
mvns r6, #0xd900
subs r8, r6, r12
subs r8, r1, #0xe600000
rsb r6, r4, r5, lsl #21
tst r12, r5, lsr r3
orrs r11, r7, r7, lsr r5
bhi 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
ldr r10, =0x1120
mov r9, #8
ldrh r14, [r10, #-2]
ldr r10, =0x1120
ldrsb r12, [r10], #12
str r4, [r10, #24]
ldrsh r11, [r10], #12
str r6, [r10, r9]
strb r12, [r10, #16]!
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
ldr r0, =0x0000ffff
ldr r1, =0x7fffffff
ldr r2, =0x000000ff
ldr r3, =0x97717f7c
ldr r4, =0xca90c5fd
ldr r5, =0x33ed9f98
ldr r6, =0x317e141f
ldr r7, =0x27a82f2f
ldr r8, =0x7fffffff
ldr r9, =0xdb04069b
ldr r10, =0x0000ffff
ldr r11, =0x12345678
ldr r12, =0x00000101
ldr r14, =0x24e1e4f7
cmn r6, r8
addsne r11, r1, r2, asr r10
eor r8, r3, r5, lsr r11
tstgt r9, r2
rsc r11, r6, r11, lsl #15
bics r2, r4, #0x1ac00
and r1, r5, #0x8200000
rscs r9, r12, r11, asr r4
movvc r0, #59
movgt r1, #91
movge r2, #77
movmi r3, #40
movne r4, #169
movhi r5, #146
addvc pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r1, =0xffffffff
ldr r2, =0xcafebabe
ldr r3, =0x80000000
ldr r4, =0x12345678
ldr r5, =0x00000101
ldr r6, =0x7ffffffe
ldr r7, =0xf923b7dc
ldr r8, =0x80000000
ldr r9, =0x4592532a
ldr r10, =0xcafebabe
ldr r11, =0x01648b5d
ldr r12, =0x685ac546
ldr r14, =0x00000002
teq r11, r7
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
ldr r10, =0x1120
ldmdb r10!, {r1,r2,r5,r7,r12}
ldr r10, =0x1120
ldmdb r10!, {lr}
ldr r10, =0x1120
stmia r10!, {r0,r3,r4,r11}
ldr r10, =0x1120
ldmib r10, {r0,r3,r7,lr}
ldr r10, =0x1120
orrls r12, r1, r11, ror r14
sub r2, r2, r10, lsl r8
ands r0, r5, r12
sub r8, r0, r3, lsl r1
cmp r7, r8
eor r10, r12, r11, lsl #26
ldr r10, =0x1120
mov r9, #16
strh r2, [r10, #4]!
ldrge r6, [r10], -r9
str r7, [r10], r9
ldr r10, =0x1120
ldr r7, [r10, #12]!
sbc r0, r6, r9, rrx
orrvs r14, r10, r4, ror #21
adcs r7, r11, r0, asr r4
rsb r4, r8, r6
mvns r9, r4, asr r0
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
