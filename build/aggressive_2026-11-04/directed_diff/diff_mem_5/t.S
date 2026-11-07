.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x9e6e8ed3
str r0, [r12, #0]
ldr r0, =0xac0f152a
str r0, [r12, #4]
ldr r0, =0x17d068c0
str r0, [r12, #8]
ldr r0, =0x41f99e77
str r0, [r12, #12]
ldr r0, =0x00000021
str r0, [r12, #16]
ldr r0, =0xa3543c6a
str r0, [r12, #20]
ldr r0, =0x132d463c
str r0, [r12, #24]
ldr r0, =0x491289ef
str r0, [r12, #28]
ldr r0, =0xe8e25653
str r0, [r12, #32]
ldr r0, =0x00000001
str r0, [r12, #36]
ldr r0, =0xffffffff
str r0, [r12, #40]
ldr r0, =0x00000000
str r0, [r12, #44]
ldr r0, =0x5763db13
str r0, [r12, #48]
ldr r0, =0xe5d71ae1
str r0, [r12, #52]
ldr r0, =0x00000021
str r0, [r12, #56]
ldr r0, =0x00000100
str r0, [r12, #60]
ldr r0, =0x00000000
ldr r1, =0x80000001
ldr r2, =0x53726623
ldr r3, =0x03896101
ldr r4, =0x00000100
ldr r5, =0x0000ffff
ldr r6, =0x1ba5da74
ldr r7, =0x4bddbbd1
ldr r8, =0xa16bd4a7
ldr r9, =0x12345678
ldr r10, =0x00000002
ldr r11, =0x2bd729ea
ldr r12, =0xba87bbd4
ldr r14, =0x00000100
teq r8, r2
ldr r10, =0x1120
mov r9, #0
ldreq r12, [r10, -r9]
ldrsb r4, [r10], -r9
ldrhgt r7, [r10, #8]
str r12, [r10, r9]
ldr r10, =0x1120
ldrsb r0, [r10, -r9]
ldr r2, [r10, #-20]
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
ldr r0, =0x80000000
ldr r1, =0xa0ba9a22
ldr r2, =0x80000001
ldr r3, =0x9440fc8f
ldr r4, =0x00000002
ldr r5, =0x24e9f448
ldr r6, =0xcafebabe
ldr r7, =0x0000ffff
ldr r8, =0xe25dd5cd
ldr r9, =0xb87e5f63
ldr r10, =0x00000101
ldr r11, =0x12345678
ldr r12, =0x00000100
ldr r14, =0xc019097c
cmn r10, r11
ldr r10, =0x1120
mov r9, #4
strh r14, [r10, #0]
ldrsb r2, [r10, #15]
ldrne r11, [r10, #4]
ldrvs r8, [r10, #-20]
ldr r10, =0x1120
strh r0, [r10], r9
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
ldr r0, =0x07052cde
ldr r1, =0x8d1e21c5
ldr r2, =0x00000100
ldr r3, =0x00000001
ldr r4, =0x40638321
ldr r5, =0x00000020
ldr r6, =0x0ec83336
ldr r7, =0x12345678
ldr r8, =0x75bfbfb0
ldr r9, =0x94547f46
ldr r10, =0xa0df3e19
ldr r11, =0x00000020
ldr r12, =0x00000020
ldr r14, =0x00000002
cmp r1, r14
ldr r10, =0x1120
mov r9, #0
ldrsh r8, [r10], r9
str r2, [r10], #8
ldrh r12, [r10], #12
strh r4, [r10], r9
ldr r10, =0x1120
ldr r11, [r10], r9
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
ldr r0, =0xe069e0cd
ldr r1, =0x7db98204
ldr r2, =0x0000ffff
ldr r3, =0x12345678
ldr r4, =0x76a1973c
ldr r5, =0x00000000
ldr r6, =0xae986f63
ldr r7, =0x076cbf9b
ldr r8, =0x5369d0c0
ldr r9, =0xb6321972
ldr r10, =0xcb1a190a
ldr r11, =0x12345678
ldr r12, =0xae612eab
ldr r14, =0xffffffff
cmn r1, r10
ldr r10, =0x1120
mov r9, #4
ldrsb r2, [r10], r9
str r0, [r10], r9
ldr r7, [r10], -r9
ldrsh r12, [r10], -r9
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
ldr r0, =0x8aa00bfc
ldr r1, =0xf515cdd2
ldr r2, =0x00000021
ldr r3, =0x654ce103
ldr r4, =0x00000100
ldr r5, =0x00000002
ldr r6, =0xb4f8078c
ldr r7, =0x000000ff
ldr r8, =0x7ffffffe
ldr r9, =0x4d0dacc0
ldr r10, =0x944b54e1
ldr r11, =0xec2018ad
ldr r12, =0x00000002
ldr r14, =0x7ffffffe
teq r6, r0
ldr r10, =0x1120
mov r9, #0
ldrh r3, [r10, #14]
ldr r10, =0x1120
strb r7, [r10, #-13]
strb r11, [r10], #20
str r2, [r10, #16]!
strh r0, [r10], #12
ldr r10, =0x1120
ldrsh r14, [r10, #8]!
ldr r10, =0x1120
str r12, [r10], #0
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
ldr r0, =0x00000020
ldr r1, =0x00000100
ldr r2, =0xcafebabe
ldr r3, =0x1a00d412
ldr r4, =0xa4c602f4
ldr r5, =0x7fffffff
ldr r6, =0x588d4d1b
ldr r7, =0x48b12818
ldr r8, =0x00000000
ldr r9, =0xcafebabe
ldr r10, =0x6965f9c7
ldr r11, =0x6823f660
ldr r12, =0x00000101
ldr r14, =0x7ffffffe
teq r11, r8
ldr r10, =0x1120
mov r9, #0
ldrb r3, [r10, #12]!
strb r0, [r10, #-2]
strb r7, [r10, #8]!
ldr r0, [r10], #12
ldr r11, [r10], r9
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
ldr r1, =0x00000020
ldr r2, =0x00000101
ldr r3, =0x627879b9
ldr r4, =0x0000ffff
ldr r5, =0x00000002
ldr r6, =0x00000020
ldr r7, =0x07cd4ca5
ldr r8, =0x0000ffff
ldr r9, =0x00000021
ldr r10, =0xd84042af
ldr r11, =0xe49049a1
ldr r12, =0x00000000
ldr r14, =0x7ffffffe
teq r7, r9
ldr r10, =0x1120
mov r9, #16
ldr r7, [r10, #-24]
ldr r10, =0x1120
ldrsh r5, [r10, #-2]
ldr r10, =0x1120
ldrsb r0, [r10, #13]
ldrsh r0, [r10, r9]
ldrsb r4, [r10], r9
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
ldr r0, =0x9b3cb927
ldr r1, =0x12345678
ldr r2, =0x046546a3
ldr r3, =0xf3739481
ldr r4, =0xfbd51177
ldr r5, =0x80000000
ldr r6, =0x0000001f
ldr r7, =0xffffffff
ldr r8, =0x0b2385cf
ldr r9, =0x54cbd97a
ldr r10, =0x00000021
ldr r11, =0xce4105eb
ldr r12, =0x70b37487
ldr r14, =0x7fffffff
cmn r8, r5
ldr r10, =0x1120
mov r9, #0
strb r3, [r10, #4]!
ldrsbls r1, [r10, r9]
ldrsh r0, [r10, #-2]
strbpl r7, [r10], -r9
strbvs r3, [r10, #5]
str r7, [r10, #20]
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
