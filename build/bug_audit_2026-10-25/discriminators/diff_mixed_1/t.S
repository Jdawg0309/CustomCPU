.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x7fffffff
str r0, [r12, #0]
ldr r0, =0x0000ffff
str r0, [r12, #4]
ldr r0, =0xffffffff
str r0, [r12, #8]
ldr r0, =0x0c6a8626
str r0, [r12, #12]
ldr r0, =0x2973aed6
str r0, [r12, #16]
ldr r0, =0x00000021
str r0, [r12, #20]
ldr r0, =0x00000001
str r0, [r12, #24]
ldr r0, =0x86a56fcd
str r0, [r12, #28]
ldr r0, =0x000000ff
str r0, [r12, #32]
ldr r0, =0x342ef0c6
str r0, [r12, #36]
ldr r0, =0x00000000
str r0, [r12, #40]
ldr r0, =0x00000001
str r0, [r12, #44]
ldr r0, =0x00000000
str r0, [r12, #48]
ldr r0, =0x00000002
str r0, [r12, #52]
ldr r0, =0x00000100
str r0, [r12, #56]
ldr r0, =0x00000101
str r0, [r12, #60]
ldr r0, =0x3cd3de2b
ldr r1, =0xc8f6e3a2
ldr r2, =0x80000001
ldr r3, =0x000000ff
ldr r4, =0x0000ffff
ldr r5, =0xcafebabe
ldr r6, =0x00000100
ldr r7, =0x00000020
ldr r8, =0x000000ff
ldr r9, =0x7f382514
ldr r10, =0xd4f3fc38
ldr r11, =0xf44b96f3
ldr r12, =0x1683f4a9
ldr r14, =0xba5636d3
teq r14, r1
movls r0, #23
movls r1, #184
movlt r2, #146
movpl r3, #33
movvc r4, #103
movvc r5, #152
adcpl r2, r14, r10
orr r10, r9, r3, ror r11
rsbcc r1, r10, #0x6c0000
ldr r10, =0x1120
stmiale r10, {r0,r5,r8,r9,r11}
ldr r10, =0x1120
ldmib r10!, {r4,r5,lr}
ldr r10, =0x1120
ldmia r10, {r1,r3,r4,lr}
ldr r10, =0x1120
movs r1, r4
adcshi r14, r8, r6, asr #30
adchi r0, r3, #0xa3000000
bic r6, r2, r11, asr r0
eorscc r9, r9, r5
bics r5, r4, r6
movs r5, r8, ror #3
cmple r9, r8, ror r12
adcle r10, r1, r7, asr r6
add r7, r7, r8, rrx
add r12, r3, r2, lsl r12
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
ldr r0, =0xc77387eb
ldr r1, =0x00000100
ldr r2, =0x3f86e6b7
ldr r3, =0x80000001
ldr r4, =0xba79dba2
ldr r5, =0x9e5a4aa2
ldr r6, =0xc3cf7901
ldr r7, =0x5e18f1b2
ldr r8, =0xc1e7accd
ldr r9, =0xe55efc30
ldr r10, =0x9187dd21
ldr r11, =0x7fffffff
ldr r12, =0x7ffffffe
ldr r14, =0x4dec57e5
cmn r0, r3
movls r0, #69
movmi r1, #17
movcs r2, #99
movcc r3, #82
movhi r4, #69
movge r5, #124
ldr r10, =0x1120
stmdb r10, {r0,r2,r4,r11,lr}
ldr r10, =0x1120
stmdbvc r10!, {r3}
ldr r10, =0x1120
ldmdb r10!, {r6,r7,lr}
ldr r10, =0x1120
ldmia r10!, {r3}
ldr r10, =0x1120
ldr r10, =0x1120
ldmdb r10, {r7}
ldr r10, =0x1120
stmdb r10, {r1,r7,lr}
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
ldr r0, =0xa2a04918
ldr r1, =0xcafebabe
ldr r2, =0x00000101
ldr r3, =0x7258ce0e
ldr r4, =0xffffffff
ldr r5, =0x0bc2f026
ldr r6, =0xe7b6aaec
ldr r7, =0x00000101
ldr r8, =0x0000ffff
ldr r9, =0x000000ff
ldr r10, =0xb9cf2e7c
ldr r11, =0xcafebabe
ldr r12, =0x00000000
ldr r14, =0xf4590414
cmp r0, r1
ldr r10, =0x1120
mov r9, #0
ldrsb r2, [r10, #-7]
str r8, [r10], #12
strhle r14, [r10, #14]
ldr r10, =0x1120
ldrsb r1, [r10, #-6]
strb r5, [r10, #20]!
ldrb r3, [r10, #8]!
ldr r10, =0x1120
subscs r1, r14, r8, lsr r3
mvn r3, r7, lsr #22
adclt r1, r5, r1, lsl #14
mvnls r4, r2, asr r10
sbceq r2, r6, #0xb0
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
orrs r10, r11, r0, asr #12
rscls r8, r6, r11, asr #23
sub r9, r10, r11, ror r9
eorls r9, r12, r2, ror #17
cmp r10, #0xa3
adc r5, r7, r5, asr r10
sbc r1, r11, r12, asr r3
rsbsls r6, r10, r4, asr r3
cmn r2, r14
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
ldr r0, =0x82bb0bb8
ldr r1, =0x7ffffffe
ldr r2, =0xf7f72be0
ldr r3, =0x0000ffff
ldr r4, =0x00000002
ldr r5, =0x7fffffff
ldr r6, =0xc2df786b
ldr r7, =0xffffffff
ldr r8, =0x6a2fe59f
ldr r9, =0x80000000
ldr r10, =0xfa35fb74
ldr r11, =0xc0b44f2c
ldr r12, =0x97d65173
ldr r14, =0x0d305a55
tst r1, r10
ldr r10, =0x1120
ldmdage r10!, {r1,r2,lr}
ldr r10, =0x1120
stmib r10!, {r5}
ldr r10, =0x1120
stmdbmi r10!, {r1,r3,r11,r12}
ldr r10, =0x1120
ldmda r10, {r0,r2,r8}
ldr r10, =0x1120
blne 1f
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
bls 2f
add r1, r1, #7
2:
addcs pc, pc, #0
add r1, r1, #1
add r2, r2, #1
ldr r10, =0x1120
stmdb r10, {r4,r9,r12}
ldr r10, =0x1120
ldmdb r10!, {r5,r6,r8,r9,r11}
ldr r10, =0x1120
ldmib r10!, {r0,r3,r6}
ldr r10, =0x1120
ldmda r10!, {r0,r1,r3,r6}
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
ldr r1, =0x00000021
ldr r2, =0x15cfa250
ldr r3, =0x133c894a
ldr r4, =0x80000001
ldr r5, =0x0000ffff
ldr r6, =0x00000021
ldr r7, =0x00000000
ldr r8, =0x10981051
ldr r9, =0x444e5fc1
ldr r10, =0x3ccf385e
ldr r11, =0x2e0e939c
ldr r12, =0xc3d4f932
ldr r14, =0xf5f3c79b
teq r6, r7
mov r0, r4, lsl #19
andsge r7, r7, r11, lsl #16
cmn r4, r1, lsl r4
orrsvc r14, r10, r2, lsl #15
addge r4, r9, r3, ror #27
sub r9, r11, r12, lsl #13
ldr r10, =0x1120
mov r9, #8
strh r0, [r10, #-8]
ldr r10, =0x1120
ldrsb r0, [r10, #-9]
ldr r10, =0x1120
ldrh r8, [r10], -r9
ldr r10, =0x1120
ldrsh r3, [r10, r9]
ldr r10, =0x1120
strh r11, [r10], -r9
sbcslt r7, r14, r4
and r8, r6, r14, ror #24
orrs r0, r5, r0, lsr #13
mvn r0, #0x384000
sbcsls r10, r4, #0x3c000
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
ldr r0, =0x7b02987e
ldr r1, =0xc92856e6
ldr r2, =0xc02a77f4
ldr r3, =0xc165fd97
ldr r4, =0x00000021
ldr r5, =0xf1e39d7a
ldr r6, =0x0000ffff
ldr r7, =0x00000001
ldr r8, =0x00000100
ldr r9, =0x00000000
ldr r10, =0xb364849c
ldr r11, =0x977238ef
ldr r12, =0x277f4947
ldr r14, =0x12345678
tst r5, r14
movvc r0, #144
movlt r1, #126
movls r2, #142
movvc r3, #21
movcs r4, #194
movls r5, #67
ldr r10, =0x1120
ldmib r10!, {r2,r9}
ldr r10, =0x1120
ldmdb r10, {r0,r1,r4,r6,r8}
ldr r10, =0x1120
ldmdb r10!, {r7,r11,r12}
ldr r10, =0x1120
bne 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
ldr r10, =0x1120
ldmib r10, {r2,r7,r8,r11,lr}
ldr r10, =0x1120
ldmda r10!, {r1,r3,r11,r12,lr}
ldr r10, =0x1120
stmibcs r10!, {r0,r1,r6,r11}
ldr r10, =0x1120
stmda r10, {r1,r7,r8,r11}
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
ldr r0, =0x27037077
ldr r1, =0x80000001
ldr r2, =0xf9e8e69a
ldr r3, =0x8eec839d
ldr r4, =0x24b8a134
ldr r5, =0xa4e3a713
ldr r6, =0x8a3c38ed
ldr r7, =0x00000101
ldr r8, =0xfffdd595
ldr r9, =0x23d2bd7b
ldr r10, =0x37e2d0b0
ldr r11, =0x00000001
ldr r12, =0xcebfe6c4
ldr r14, =0xd01f2124
teq r9, r11
sbcs r6, r10, r11, asr r0
bic r7, r5, r3, lsl #16
subs r0, r8, r11, lsr r3
mvnspl r10, r14, ror #26
orrspl r0, r14, r14
rsbscs r11, r10, r10, rrx
add r11, r14, r0, ror r2
ldr r10, =0x1120
mov r9, #12
strhle r1, [r10, -r9]
ldrsh r7, [r10], -r9
strh r8, [r10, -r9]
ldrshcs r5, [r10], r9
ldr r10, =0x1120
rsbcs r4, r0, r6, lsr #29
cmpcc r1, r2, ror r9
subscc r1, r6, r4, lsl r2
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
ldr r0, =0x26ab9429
ldr r1, =0x80000001
ldr r2, =0x5ed161e9
ldr r3, =0x6df2091e
ldr r4, =0x0000001f
ldr r5, =0xa34f6143
ldr r6, =0x25a9f8a3
ldr r7, =0x3fca710b
ldr r8, =0xd40c2dad
ldr r9, =0x00000101
ldr r10, =0x98d6cda7
ldr r11, =0x37bf8437
ldr r12, =0x7fffffff
ldr r14, =0x8d34fdef
cmp r14, r11
cmp pc, r6
adr r3, 1f
movhi pc, r3
add r0, r0, #1
1:
movvc r0, #129
movcc r1, #190
movls r2, #148
movgt r3, #5
movlt r4, #164
movvc r5, #29
adc r4, r6, r6, lsr r2
adcs r12, r12, r3, lsr #26
sbcs r8, r9, r8, lsl r9
rsbsge r10, r4, #0xc000002a
andscs r6, r9, r4, ror r11
movs r5, r4, lsl r11
adc r6, r2, r5, rrx
tst r11, #0xe9000000
movshi r8, #0xe4000002
add r11, r5, r6
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
