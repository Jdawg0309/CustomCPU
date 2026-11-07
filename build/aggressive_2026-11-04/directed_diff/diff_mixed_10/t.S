.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000021
str r0, [r12, #0]
ldr r0, =0x000000ff
str r0, [r12, #4]
ldr r0, =0xd1088cd6
str r0, [r12, #8]
ldr r0, =0x7ffffffe
str r0, [r12, #12]
ldr r0, =0x000000ff
str r0, [r12, #16]
ldr r0, =0x80000000
str r0, [r12, #20]
ldr r0, =0xee646b46
str r0, [r12, #24]
ldr r0, =0xf31ad4fd
str r0, [r12, #28]
ldr r0, =0x99a608e7
str r0, [r12, #32]
ldr r0, =0x00000100
str r0, [r12, #36]
ldr r0, =0x01c891b2
str r0, [r12, #40]
ldr r0, =0xd296b5fe
str r0, [r12, #44]
ldr r0, =0x6cb6dbd2
str r0, [r12, #48]
ldr r0, =0x00000100
str r0, [r12, #52]
ldr r0, =0x12345678
str r0, [r12, #56]
ldr r0, =0x8fa82e72
str r0, [r12, #60]
ldr r0, =0x00000101
ldr r1, =0x4bf7be3b
ldr r2, =0x80000001
ldr r3, =0xb38581f6
ldr r4, =0x80000001
ldr r5, =0x00000001
ldr r6, =0x85edc967
ldr r7, =0x6ab09f68
ldr r8, =0x0000ffff
ldr r9, =0x12345678
ldr r10, =0x0e881993
ldr r11, =0x7ffffffe
ldr r12, =0x6aff6e3b
ldr r14, =0x80000001
tst r0, r8
mov r5, pc
movcc r0, #35
movls r1, #185
movne r2, #158
movmi r3, #5
movls r4, #39
movls r5, #55
movcc r0, #136
moveq r1, #187
movcc r2, #110
movpl r3, #115
movmi r4, #164
movge r5, #170
ands r14, r2, r2, asr r6
cmp r11, r12
subne r3, r0, r5, asr #26
eorsvs r4, r2, r5, lsr #13
ldr r10, =0x1120
mov r9, #4
ldrsb r8, [r10, #12]!
ldrsh r7, [r10], #8
ldr r10, =0x1120
ldrshmi r4, [r10, -r9]
ldr r10, =0x1120
ldrh r5, [r10, r9]
ldr r10, =0x1120
ldr r6, [r10, #24]
ldr r10, =0x1120
ldrsbhi r8, [r10, #16]!
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
ldr r1, =0x75794624
ldr r2, =0xcafebabe
ldr r3, =0x31c623c8
ldr r4, =0x000000ff
ldr r5, =0x29c85458
ldr r6, =0x00000021
ldr r7, =0x2d8605ed
ldr r8, =0xd628dbbd
ldr r9, =0x00000100
ldr r10, =0x523d10bc
ldr r11, =0xcafebabe
ldr r12, =0x00000002
ldr r14, =0x00000001
cmn r8, r10
ands r2, r11, #0x348000
sbcs r14, r10, r9, lsl r1
teqcs r5, r1, ror #27
cmpvc r8, r0, lsr r4
eors r1, r3, #0x5900000
ldr r10, =0x1120
stmdavs r10!, {r2,r4,r5}
ldr r10, =0x1120
stmdbls r10, {r5,r11}
ldr r10, =0x1120
ldmda r10, {r1,r4,r6,r8,r11}
ldr r10, =0x1120
rsbs r3, r7, r11, lsr r7
add r8, r11, r1, ror #9
movs r9, r2
tst r1, #0x14400000
ands r4, r4, r6
mov r10, r12
ldr r4, [pc, #4]
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
ldr r0, =0xffffffff
ldr r1, =0x0000001f
ldr r2, =0x0000ffff
ldr r3, =0x730e47d4
ldr r4, =0x10975e17
ldr r5, =0x7ffffffe
ldr r6, =0x939c8dcf
ldr r7, =0x00000100
ldr r8, =0x00000001
ldr r9, =0x7474d55b
ldr r10, =0x00000002
ldr r11, =0x7ffffffe
ldr r12, =0x2b9e75da
ldr r14, =0x00000001
teq r11, r3
ldr r10, =0x1120
ldmdb r10!, {r1,r5,r9,r12}
ldr r10, =0x1120
stmdbne r10!, {r0,r6,r11,r12,lr}
ldr r10, =0x1120
ldmdb r10!, {r0,r9}
ldr r10, =0x1120
movmi r0, #103
movle r1, #24
movle r2, #180
movcc r3, #57
movvc r4, #30
movhi r5, #153
sbcscs r6, r4, r1
adcvs r14, r12, #0x398000
ands r8, r11, r0, asr r0
bic r6, r4, r0, rrx
tst r4, r11, lsr #23
subgt r11, r6, r3, lsr r0
movs r11, r12
bicsls r12, r12, r5, ror #7
orrs r3, r1, r11, lsl #13
cmp r7, r10, asr r1
movpl r0, #199
movne r1, #70
movcc r2, #161
movge r3, #56
movlt r4, #197
movne r5, #29
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
ldr r1, =0x00000002
ldr r2, =0x00000021
ldr r3, =0xb02b4400
ldr r4, =0x00000021
ldr r5, =0x12345678
ldr r6, =0xcc326d5a
ldr r7, =0x352ae1fb
ldr r8, =0x2877283d
ldr r9, =0x06dbd981
ldr r10, =0x7fffffff
ldr r11, =0x00000101
ldr r12, =0xab889619
ldr r14, =0x00000101
teq r7, r9
ldr r10, =0x1120
mov r9, #8
ldr r11, [r10], -r9
ldrsb r1, [r10], r9
strcc r8, [r10, #0]!
ldr r10, =0x1120
ldrsh r3, [r10, #0]!
ldrh r6, [r10, #6]
strb r2, [r10, #20]!
ldr r10, =0x1120
ldmdb r10, {r5}
ldr r10, =0x1120
stmdb r10!, {r1,r2,r3,r8}
ldr r10, =0x1120
ldmiaeq r10!, {r4,r5,r7,lr}
ldr r10, =0x1120
ldmia r10, {r7,lr}
ldr r10, =0x1120
teq r7, r4, asr #19
cmp r4, r2, rrx
cmngt r5, r2, lsl r4
mvns r4, r3
adds r9, r4, r3
add r7, r14, r4, lsl #2
movne r0, #175
movvc r1, #115
movge r2, #64
movpl r3, #108
movle r4, #76
movmi r5, #198
ldr r10, =0x1120
mov r9, #12
ldrh r0, [r10, #16]!
strb r7, [r10, #-8]
ldr r10, =0x1120
ldr r7, [r10, #-24]
ldrbcc r2, [r10, -r9]
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
ldr r0, =0x00000100
ldr r1, =0x6ce2c14d
ldr r2, =0xaf57448d
ldr r3, =0x2ccf36cd
ldr r4, =0x8783b64e
ldr r5, =0xffffffff
ldr r6, =0x80000001
ldr r7, =0x000000ff
ldr r8, =0x9ff16daf
ldr r9, =0x12345678
ldr r10, =0x1fcf23de
ldr r11, =0x00000100
ldr r12, =0xffffffff
ldr r14, =0xd6832d03
cmp r9, r14
cmngt r6, r5, asr r5
rsbsvc r2, r3, r1, lsr r1
adcs r3, r2, r2, lsl r0
sbc r14, r9, r11, lsr r8
sbc r1, r8, r6, ror #16
and r14, r6, r1, rrx
rscs r6, r3, #0xfd00
mvn r1, #0x1e000000
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x00000002
ldr r1, =0x0000ffff
ldr r2, =0x000000ff
ldr r3, =0x00000021
ldr r4, =0xc81f80b0
ldr r5, =0x000000ff
ldr r6, =0x000000ff
ldr r7, =0x35bc172e
ldr r8, =0xc1248a59
ldr r9, =0x7ffffffe
ldr r10, =0x8a5d7d66
ldr r11, =0x38dd8c0c
ldr r12, =0xdbaaacca
ldr r14, =0xf70f33a8
cmp r6, r9
blne 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
ldr r10, =0x1120
mov r9, #16
strb r8, [r10, #-12]
ldr r10, =0x1120
ldrbge r14, [r10], r9
ldrsh r7, [r10], r9
ldr r10, =0x1120
str r11, [r10], r9
ldr r10, =0x1120
strls r5, [r10, #12]!
ldr r10, =0x1120
rscsne r5, r5, r4, asr r14
eors r0, r2, r7, lsl r1
orrmi r9, r10, r9, lsr #31
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
ldr r0, =0x0000001f
ldr r1, =0x81c12b89
ldr r2, =0xc632419e
ldr r3, =0x5803b012
ldr r4, =0x0ff67c4b
ldr r5, =0x643d317f
ldr r6, =0xbf22d88a
ldr r7, =0x090274a1
ldr r8, =0x80000001
ldr r9, =0x80000001
ldr r10, =0xd690992e
ldr r11, =0x0000001f
ldr r12, =0xb0e3c03e
ldr r14, =0xe73d0197
cmn r5, r0
rsb r6, r12, r8, lsl r0
eor r5, r8, r9, rrx
subsle r11, r4, r5, ror r8
ldr r10, =0x1120
mov r9, #4
ldrh r8, [r10], #8
ldr r10, =0x1120
ldrsh r7, [r10, #2]
strbhi r6, [r10, #-13]
ldrshne r8, [r10], #4
str r8, [r10, #24]
ldr r10, =0x1120
mov r9, #8
ldr r8, [r10], -r9
ldrne r5, [r10], #0
ldrsh r8, [r10, r9]
ldr r10, =0x1120
ldr r14, [r10], #20
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
ldr r0, =0x36b837ba
ldr r1, =0x7fffffff
ldr r2, =0xd7e9ac5c
ldr r3, =0xe9f37c28
ldr r4, =0x0000ffff
ldr r5, =0xde1386b8
ldr r6, =0x509a175a
ldr r7, =0xca4bc140
ldr r8, =0x8ff5583a
ldr r9, =0x76dcc08e
ldr r10, =0xffffffff
ldr r11, =0x00000002
ldr r12, =0x60d5643d
ldr r14, =0xcafebabe
cmp r14, r7
orrs r6, r14, r0, asr #29
teq r9, r9, lsr r7
mvns r11, r8
adc r11, r2, r1
sub r12, r6, r9, ror r4
blne 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
movcc r0, #166
movmi r1, #103
moveq r2, #193
movgt r3, #18
movle r4, #12
movcc r5, #120
adds r0, pc, r5
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
