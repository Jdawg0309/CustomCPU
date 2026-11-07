.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x0000001f
str r0, [r12, #0]
ldr r0, =0xcafebabe
str r0, [r12, #4]
ldr r0, =0xf651c047
str r0, [r12, #8]
ldr r0, =0x80000000
str r0, [r12, #12]
ldr r0, =0xcecf9515
str r0, [r12, #16]
ldr r0, =0xee52dd49
str r0, [r12, #20]
ldr r0, =0x80000000
str r0, [r12, #24]
ldr r0, =0xfec72682
str r0, [r12, #28]
ldr r0, =0x80000000
str r0, [r12, #32]
ldr r0, =0x00000001
str r0, [r12, #36]
ldr r0, =0xcaef3d8d
str r0, [r12, #40]
ldr r0, =0xac46372a
str r0, [r12, #44]
ldr r0, =0x5955bcb3
str r0, [r12, #48]
ldr r0, =0xc9929c9c
str r0, [r12, #52]
ldr r0, =0x9189bb4e
str r0, [r12, #56]
ldr r0, =0x00000021
str r0, [r12, #60]
ldr r0, =0x5ad1de02
ldr r1, =0x0000001f
ldr r2, =0x7ffffffe
ldr r3, =0x7ffffffe
ldr r4, =0x00000101
ldr r5, =0x00000000
ldr r6, =0x57f2f5b3
ldr r7, =0x80000000
ldr r8, =0xe1109db2
ldr r9, =0xfb5fb978
ldr r10, =0xe53a5035
ldr r11, =0x12345678
ldr r12, =0x80000001
ldr r14, =0x7fffffff
cmn r14, r3
ldr r10, =0x1120
mov r9, #8
str r2, [r10, #-0]
ldr r14, [r10, #4]
ldr r10, =0x1120
strb r2, [r10, -r9]
ldrb r5, [r10], -r9
ldr r10, =0x1120
ldr r2, [r10, r9]
ldr r10, =0x1120
mov r9, #8
ldrsh r11, [r10, #12]!
ldrsb r3, [r10, #-17]
ldr r10, =0x1120
ldr r8, [r10, #16]
ldrb r4, [r10], -r9
ldr r10, =0x1120
ldrsh r7, [r10], #0
ldrb r14, [r10], #16
strb r14, [r10, #-2]
movge r0, #197
movgt r1, #109
movls r2, #72
movgt r3, #66
movge r4, #79
movvc r5, #97
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
ldr r0, =0x25d79d7a
ldr r1, =0x00000001
ldr r2, =0x7ffffffe
ldr r3, =0x8933d5a0
ldr r4, =0x4611b374
ldr r5, =0x7fffffff
ldr r6, =0xc0316a6e
ldr r7, =0x0000001f
ldr r8, =0x00000001
ldr r9, =0x95fa71bc
ldr r10, =0x00000101
ldr r11, =0x80000001
ldr r12, =0xffffffff
ldr r14, =0x000000ff
tst r11, r8
bic r6, r9, #0xc000002a
rscshi r5, r9, r12
orr r7, r12, r4, ror #26
cmn r9, #0x7d00
rscls r12, r0, r0, ror #17
sbcs r1, r14, r8
adcs r4, r0, #0xb
sbcsvc r1, r0, r9, asr r6
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
ble 2f
add r1, r1, #7
2:
movls r0, #85
movpl r1, #42
movpl r2, #77
movlt r3, #29
movcs r4, #87
movvc r5, #7
movpl r0, #46
movmi r1, #137
movcs r2, #131
movhi r3, #15
movlt r4, #25
movcc r5, #153
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
ldr r1, =0x9af0bb44
ldr r2, =0xb2592f6d
ldr r3, =0x131c7245
ldr r4, =0x1ff93cab
ldr r5, =0x0000ffff
ldr r6, =0x00000002
ldr r7, =0xf45638e4
ldr r8, =0x02877c69
ldr r9, =0xb7fe0c93
ldr r10, =0x9baba79b
ldr r11, =0x000000ff
ldr r12, =0x00000101
ldr r14, =0x1c878fc4
cmn r12, r1
ldr r10, =0x1120
mov r9, #4
ldrsh r11, [r10, #-8]
ldr r10, =0x1120
str r2, [r10, -r9]
strb r7, [r10, r9]
strbge r7, [r10], #0
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
rscs r14, r4, r6
cmn r9, r14
eors r10, r14, r2, lsl r11
cmppl r12, #0x7c0000
eors r9, r11, #0x31000
sub r9, r1, r5, asr #22
blne 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
andcc r5, r3, r9, rrx
rsc r7, r8, #0xd500000
sub r9, r2, r3, lsr #13
rsbs r0, r2, r6, asr #5
sub r10, r12, r12, lsl r4
teq r6, r2, asr r1
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
ldr r0, =0x0000ffff
ldr r1, =0xfaace825
ldr r2, =0xfdb663f3
ldr r3, =0xb50f8141
ldr r4, =0x0caa08b5
ldr r5, =0xae5e941e
ldr r6, =0x80000000
ldr r7, =0x00000002
ldr r8, =0x3dbc9136
ldr r9, =0x50808ada
ldr r10, =0x9dc93164
ldr r11, =0xc94016a6
ldr r12, =0x80000000
ldr r14, =0x7fffffff
teq r4, r1
ldr r10, =0x1120
ldmda r10!, {r7}
ldr r10, =0x1120
ldmdage r10, {r1,r5,r9,lr}
ldr r10, =0x1120
ldmia r10, {r1,r7}
ldr r10, =0x1120
ldmiavs r10, {r1}
ldr r10, =0x1120
ldr r10, =0x1120
adr r3, 1f
str r3, [r10, #4]
ldmia r10, {r4, pc}
add r0, r0, #7
1:
ldr r10, =0x1120
ldmibcs r10!, {r4,r6,r9,lr}
ldr r10, =0x1120
ldmdb r10, {lr}
ldr r10, =0x1120
orrs r1, r3, #0xc000003b
adds r6, r9, r8
subs r14, r1, r4, asr r11
movs r9, r6
movmi r1, #0x34c00000
cmncs r12, r3, lsl #27
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
ldr r0, =0x0000001f
ldr r1, =0x9df401ea
ldr r2, =0x55073bc7
ldr r3, =0xcafebabe
ldr r4, =0x000000ff
ldr r5, =0xeb116946
ldr r6, =0xc506ed6c
ldr r7, =0x0000001f
ldr r8, =0x00000001
ldr r9, =0x0000001f
ldr r10, =0x80000001
ldr r11, =0xb142bf1b
ldr r12, =0x0000ffff
ldr r14, =0x5366f593
tst r8, r6
and r1, r4, r14, asr r5
tstne r3, r11, rrx
teq r4, r2, lsr #15
rsb r4, r1, r5, ror r4
orr r4, r14, r8, rrx
orr r4, r12, r1, asr r3
movlt r0, #117
movmi r1, #181
movls r2, #78
movls r3, #71
movcs r4, #172
movmi r5, #119
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvs 2f
add r1, r1, #7
2:
ldr r10, =0x1120
stmdb r10, {r7,r8}
ldr r10, =0x1120
stmdb r10!, {r0,r6}
ldr r10, =0x1120
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
ldr r0, =0x0000001f
ldr r1, =0x12345678
ldr r2, =0x368538d4
ldr r3, =0x000000ff
ldr r4, =0xb6e3ad9b
ldr r5, =0x8232a076
ldr r6, =0x51bb5457
ldr r7, =0xdab42e8c
ldr r8, =0x0000001f
ldr r9, =0x12345678
ldr r10, =0x7ffffffe
ldr r11, =0x00000000
ldr r12, =0x00000020
ldr r14, =0x49a2c128
teq r6, r1
ldr r10, =0x1120
mov r9, #0
strh r11, [r10, r9]
ldr r10, =0x1120
ldr r1, [r10], r9
ldrsb r6, [r10], #20
ldr r11, [r10, #20]
ands r7, r6, #0x2e400
rsb r2, r6, r8
sub r10, r2, r3, ror #12
subs r3, r1, r5, lsl r4
and r5, r1, #0x40000004
bicscs r12, r4, r6, rrx
ldr r10, =0x1120
stmib r10, {r2,r3}
ldr r10, =0x1120
stmia r10, {r0,r2,r4,r5,r9}
ldr r10, =0x1120
ldmib r10!, {r9,r11}
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
ldr r0, =0x425d004f
ldr r1, =0x00000020
ldr r2, =0x00000020
ldr r3, =0x7fffffff
ldr r4, =0x0000ffff
ldr r5, =0x00000000
ldr r6, =0xffffffff
ldr r7, =0x42e803bf
ldr r8, =0x7fffffff
ldr r9, =0x7ffffffe
ldr r10, =0x12345678
ldr r11, =0x4ca90fcb
ldr r12, =0xffffffff
ldr r14, =0x00000101
teq r1, r10
teqmi r2, r3, asr r5
sbcne r14, r12, r3, lsr r1
sub r2, r3, r12, ror r1
addcc r6, r6, r4, ror #7
adc r6, r3, r3, rrx
suble r10, r0, r9, lsr r7
ldr r10, =0x1120
ldmia r10, {r2}
ldr r10, =0x1120
ldmdb r10!, {r0,r4,r5,r8}
ldr r10, =0x1120
ldmia r10, {r2,r5,r9,r12}
ldr r10, =0x1120
stmdbls r10, {r0,r2,r4,r7,lr}
ldr r10, =0x1120
rscvs r7, r7, r7, rrx
adcs r0, r0, r4, asr #3
teqpl r7, #0x28
movcs r0, #128
movcc r1, #17
movne r2, #132
movpl r3, #180
movhi r4, #152
movvc r5, #160
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
ldr r0, =0x00000100
ldr r1, =0xd96d82da
ldr r2, =0x85f950bd
ldr r3, =0x68c026b1
ldr r4, =0x449e74d1
ldr r5, =0x00000101
ldr r6, =0x00000002
ldr r7, =0x2c991319
ldr r8, =0x9a71a53d
ldr r9, =0x000000ff
ldr r10, =0xffffffff
ldr r11, =0x13bfaeea
ldr r12, =0x0000ffff
ldr r14, =0x00000002
cmn r8, r9
blne 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
movhi r0, #78
movvc r1, #23
movhi r2, #26
movhi r3, #186
movlt r4, #88
movpl r5, #135
ldr r10, =0x1120
stmdb r10, {r8,r12,lr}
ldr r10, =0x1120
ldmda r10!, {r1,r11}
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
