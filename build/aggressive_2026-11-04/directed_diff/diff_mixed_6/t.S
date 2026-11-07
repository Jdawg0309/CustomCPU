.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000101
str r0, [r12, #0]
ldr r0, =0xffffffff
str r0, [r12, #4]
ldr r0, =0xcafebabe
str r0, [r12, #8]
ldr r0, =0x9273fe63
str r0, [r12, #12]
ldr r0, =0x00000101
str r0, [r12, #16]
ldr r0, =0x80038c74
str r0, [r12, #20]
ldr r0, =0x5f2d7cf0
str r0, [r12, #24]
ldr r0, =0x80000001
str r0, [r12, #28]
ldr r0, =0xfbcbd411
str r0, [r12, #32]
ldr r0, =0x13eb75a0
str r0, [r12, #36]
ldr r0, =0x7ffffffe
str r0, [r12, #40]
ldr r0, =0xce2e7cfd
str r0, [r12, #44]
ldr r0, =0x00000000
str r0, [r12, #48]
ldr r0, =0xf1511983
str r0, [r12, #52]
ldr r0, =0x0000ffff
str r0, [r12, #56]
ldr r0, =0x00000020
str r0, [r12, #60]
ldr r0, =0x52c58316
ldr r1, =0x00000100
ldr r2, =0xeeba60b1
ldr r3, =0x00000001
ldr r4, =0x138161fe
ldr r5, =0x246c6112
ldr r6, =0x7f51e222
ldr r7, =0xfd5a5d3f
ldr r8, =0x7c7f5675
ldr r9, =0x0000ffff
ldr r10, =0x80000001
ldr r11, =0x00000002
ldr r12, =0x029adc1d
ldr r14, =0xed4c5084
tst r1, r14
orrsmi r1, r4, #0x80000001
movle r2, r9
eor r8, r5, #0xe
rsb r2, r12, r0, ror r5
tstmi r8, r3, ror r0
sbc r0, r1, r7, lsl r7
subs r8, r1, r2, asr #14
orrs r0, r2, r11, rrx
sbc r8, r4, r10
sub r5, r9, r3, asr #23
teq r6, r1, asr r14
mov r11, #0x3880000
subs r11, r9, r1, asr r12
bls 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
sbcs r0, r14, r5, asr r8
adcsge r12, r7, r2
adcs r3, r5, #0xef00000
bicspl r1, r0, #0x2980000
movs r2, r5, rrx
eorsls r6, r12, r10, rrx
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
ldr r0, =0x4f0e6ec0
ldr r1, =0x58152101
ldr r2, =0x000000ff
ldr r3, =0x80000001
ldr r4, =0x50faa1e2
ldr r5, =0x00000002
ldr r6, =0x80000001
ldr r7, =0x6f159ff6
ldr r8, =0xc041069e
ldr r9, =0x7ba38774
ldr r10, =0x8cb87614
ldr r11, =0xca98a3a3
ldr r12, =0xcb9a0f68
ldr r14, =0x7fffffff
teq r3, r7
tst r2, r3, ror #2
eor r2, r5, r6
teq r12, r12, ror #10
mvns r12, r1, lsr r6
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvs 2f
add r1, r1, #7
2:
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
ldr r0, =0x00000021
ldr r1, =0x00000100
ldr r2, =0xec9d391b
ldr r3, =0x00000101
ldr r4, =0x00000101
ldr r5, =0x7fffffff
ldr r6, =0xb9c2c485
ldr r7, =0x33917460
ldr r8, =0x0000001f
ldr r9, =0x0000ffff
ldr r10, =0x31d97a63
ldr r11, =0x11d216bb
ldr r12, =0xcafebabe
ldr r14, =0x712401e6
cmn r2, r14
rscscs r4, r4, r2, ror r0
subs r4, r4, r14, lsl r9
mov r1, r0, rrx
cmngt r1, r2, lsl r0
ldr r10, =0x1120
stmdb r10, {r4}
ldr r10, =0x1120
stmia r10, {r0,r7,r8,lr}
ldr r10, =0x1120
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
ldr r0, =0x9289c990
ldr r1, =0x7fffffff
ldr r2, =0x943f14fa
ldr r3, =0x7dd72613
ldr r4, =0x00000001
ldr r5, =0xdf2ee962
ldr r6, =0x80000000
ldr r7, =0xffffffff
ldr r8, =0x3732bcd5
ldr r9, =0xffffffff
ldr r10, =0x00000101
ldr r11, =0x0ff134ab
ldr r12, =0x80000001
ldr r14, =0xee2db471
cmp r1, r6
rsbs r5, r7, r6, lsr #27
tstne r10, r1
movsmi r4, r9, ror #16
rsbs r3, r9, r1
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
ldr r10, =0x1120
stmda r10, {r1,r2,r6,r11}
ldr r10, =0x1120
ldmia r10!, {r3}
ldr r10, =0x1120
ldmia r10!, {r2,r7}
ldr r10, =0x1120
stmia r10, {r9}
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
ldr r0, =0x00000001
ldr r1, =0x9457df60
ldr r2, =0x9ace4dd6
ldr r3, =0xd33d238a
ldr r4, =0x63dc427f
ldr r5, =0x20488eb2
ldr r6, =0xdd390b5d
ldr r7, =0x0000001f
ldr r8, =0x7fffffff
ldr r9, =0xc70c463a
ldr r10, =0xe13d114a
ldr r11, =0x4fef4eb2
ldr r12, =0x0000001f
ldr r14, =0x00000002
tst r7, r9
movne r0, #108
movcc r1, #183
movvs r2, #108
movvc r3, #39
movgt r4, #66
movgt r5, #28
ldr r10, =0x1120
mov r9, #12
str r1, [r10, #16]!
ldrb r6, [r10], #12
ldr r10, =0x1120
strheq r11, [r10, #-14]
str r7, [r10], r9
ldrsh r12, [r10, #0]!
ldrsb r2, [r10], r9
ldr r6, [r10, #20]!
ands r7, r9, r10, asr #21
orrmi r4, r6, r8, lsl #9
addsle r12, r8, r11
sub r10, r11, r0, rrx
rsc r1, r8, #0x25c0000
cmnpl r10, r2, rrx
cmn r0, r1, ror r6
eorvc r6, r0, r1, lsr r4
and r9, r0, r12
rsc r4, r1, r11, lsr #9
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
ldr r0, =0x9f132c62
ldr r1, =0xa9bf112a
ldr r2, =0x591884e9
ldr r3, =0x12345678
ldr r4, =0x9632cbc0
ldr r5, =0x6d48a0b1
ldr r6, =0x00000100
ldr r7, =0x00000021
ldr r8, =0x12345678
ldr r9, =0x41c5cc84
ldr r10, =0x99de8bae
ldr r11, =0x6469c907
ldr r12, =0xff33d65e
ldr r14, =0x00000020
cmn r10, r9
movs r1, r11, lsl r7
cmp r7, r9
rsb r9, r9, r11
eor r4, r12, r8
mvn r6, r1, ror #19
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
sbcs r8, r5, r12, lsl r11
bic r11, r2, r7
sub r14, r9, r11, lsl #26
sbcspl r11, r14, r0, lsr r11
moveq r0, #81
movcc r1, #178
movls r2, #171
movle r3, #180
movge r4, #47
movge r5, #39
mvn r8, r7, lsl #29
orr r11, r10, r6, lsl r5
cmn r10, r2
cmpvc r3, r1, lsr #28
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
ldr r0, =0x1eff678d
ldr r1, =0xcbfef246
ldr r2, =0x0000ffff
ldr r3, =0x7ffffffe
ldr r4, =0x7ffffffe
ldr r5, =0x8bb891cc
ldr r6, =0x80000001
ldr r7, =0x0000001f
ldr r8, =0x739ce320
ldr r9, =0xf51b2b8f
ldr r10, =0xeea345a2
ldr r11, =0xcafebabe
ldr r12, =0xf83b386d
ldr r14, =0x1400abe9
cmn r10, r14
subs r1, r7, r3
cmp r5, r5, ror #31
rscs r8, r4, r0, asr r10
teq r11, r11
cmnlt r6, r6
mvn r9, r9, rrx
movmi r0, #187
movgt r1, #137
movcc r2, #197
movpl r3, #105
movcs r4, #53
movge r5, #167
bne 1f
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
orrscs r1, r1, r11, asr #20
cmphi r0, #0x3fc0
rscs r7, r2, r7, asr #25
mvn r2, #0xc0000038
rsbcc r7, r3, r12, rrx
addsmi r7, r7, r14, lsl #27
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
ldr r0, =0xbc7cdf67
ldr r1, =0x24e74093
ldr r2, =0x0306a3c5
ldr r3, =0x86d6a9f3
ldr r4, =0x80000000
ldr r5, =0xf86e24ff
ldr r6, =0xda664b62
ldr r7, =0x63139798
ldr r8, =0xcb67d7a3
ldr r9, =0x3867238e
ldr r10, =0xcafebabe
ldr r11, =0x5960bfd9
ldr r12, =0x00000001
ldr r14, =0x3dc63bb9
tst r4, r11
ldr r10, =0x1120
mov r9, #12
str r4, [r10], r9
str r11, [r10, #12]!
ldr r10, =0x1120
strne r5, [r10, -r9]
ldr r10, =0x1120
strb r3, [r10, #-16]
ldrshvc r0, [r10, r9]
ldrh r0, [r10], -r9
mvns r11, r9, lsr r14
sbc r0, r10, r14, ror r14
cmp r5, r7
mvns r4, r12
orreq r12, r0, r12, ror r9
blne 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
