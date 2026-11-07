.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x0000ffff
str r0, [r12, #0]
ldr r0, =0x3f8f3a93
str r0, [r12, #4]
ldr r0, =0x57cfe59e
str r0, [r12, #8]
ldr r0, =0x00000101
str r0, [r12, #12]
ldr r0, =0x1a52f56e
str r0, [r12, #16]
ldr r0, =0x000000ff
str r0, [r12, #20]
ldr r0, =0x00000002
str r0, [r12, #24]
ldr r0, =0x7f210983
str r0, [r12, #28]
ldr r0, =0x00000101
str r0, [r12, #32]
ldr r0, =0x0000ffff
str r0, [r12, #36]
ldr r0, =0x71310e51
str r0, [r12, #40]
ldr r0, =0xae0a713f
str r0, [r12, #44]
ldr r0, =0x00000002
str r0, [r12, #48]
ldr r0, =0xcafebabe
str r0, [r12, #52]
ldr r0, =0xdcfe5dc5
str r0, [r12, #56]
ldr r0, =0xfa340d85
str r0, [r12, #60]
ldr r0, =0x0a71958d
ldr r1, =0x1ba18409
ldr r2, =0x00000100
ldr r3, =0x00000100
ldr r4, =0x7ffffffe
ldr r5, =0x80000000
ldr r6, =0x00000101
ldr r7, =0x00000101
ldr r8, =0x60d4b466
ldr r9, =0x80000000
ldr r10, =0x00000000
ldr r11, =0x7ffffffe
ldr r12, =0x00000101
ldr r14, =0x5b06fef8
teq r11, r11
ldr r10, =0x1120
stmib r10!, {r1,r2,r4,r8}
ldr r10, =0x1120
ldmda r10!, {r0,r3,r8,lr}
ldr r10, =0x1120
ldmib r10, {r4}
ldr r10, =0x1120
stmda r10, {lr}
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
ldr r0, =0x12345678
ldr r1, =0x798d9555
ldr r2, =0xc52e3d23
ldr r3, =0x00000021
ldr r4, =0x9735f697
ldr r5, =0x34d59a2f
ldr r6, =0x8784bcc1
ldr r7, =0x00000101
ldr r8, =0x314b8a30
ldr r9, =0xd4b29c31
ldr r10, =0x0aa3149b
ldr r11, =0xa9b30870
ldr r12, =0x7fffffff
ldr r14, =0x0ba1a43e
cmp r14, r8
ldr r10, =0x1120
stmdb r10, {r1,r6,r7}
ldr r10, =0x1120
stmia r10, {r2,r3,r7,r12}
ldr r10, =0x1120
ldmiami r10!, {r3}
ldr r10, =0x1120
ldmia r10!, {r1}
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
ldr r0, =0x162a8f22
ldr r1, =0x28f71716
ldr r2, =0xcafebabe
ldr r3, =0x00000101
ldr r4, =0x184976d5
ldr r5, =0x00000021
ldr r6, =0x0000ffff
ldr r7, =0x00000100
ldr r8, =0x47de139f
ldr r9, =0x1d66373c
ldr r10, =0x1a4992d9
ldr r11, =0x00000002
ldr r12, =0xc516df25
ldr r14, =0x5923de34
cmn r12, r4
ldr r10, =0x1120
ldmib r10, {r1,r3}
ldr r10, =0x1120
stmda r10, {r0,r2}
ldr r10, =0x1120
ldmia r10, {r0,r1,r2,r7,r12}
ldr r10, =0x1120
ldmda r10!, {r2,r4,r6,r8}
ldr r10, =0x1120
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
ldr r0, =0x1272e9cd
ldr r1, =0xcc8f581a
ldr r2, =0x00000020
ldr r3, =0x54e1ab77
ldr r4, =0x000000ff
ldr r5, =0xcafebabe
ldr r6, =0x00000020
ldr r7, =0xd3f1a91d
ldr r8, =0x80000001
ldr r9, =0xb79c4ca7
ldr r10, =0x9ce91418
ldr r11, =0x780d8673
ldr r12, =0x00000101
ldr r14, =0x0000ffff
tst r5, r8
ldr r10, =0x1120
stmib r10, {r5,r8}
ldr r10, =0x1120
ldmdb r10, {r0,r12}
ldr r10, =0x1120
ldmia r10!, {r2,r8,r11}
ldr r10, =0x1120
stmia r10!, {r6,r9}
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
ldr r0, =0x00000021
ldr r1, =0x00000002
ldr r2, =0x00000000
ldr r3, =0x00000002
ldr r4, =0x00000020
ldr r5, =0xba0eb34c
ldr r6, =0xcafebabe
ldr r7, =0xe425a984
ldr r8, =0xcafebabe
ldr r9, =0x00000100
ldr r10, =0x00000100
ldr r11, =0x0000001f
ldr r12, =0x00000002
ldr r14, =0xf997ba2c
tst r2, r2
ldr r10, =0x1120
stmia r10, {r11,lr}
ldr r10, =0x1120
ldmia r10!, {r2,r4,r6,r11}
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
ldr r0, =0xdbe871cd
ldr r1, =0x37298e3f
ldr r2, =0x4d4bc039
ldr r3, =0x8a84bcdd
ldr r4, =0x7fffffff
ldr r5, =0xcafebabe
ldr r6, =0x80000000
ldr r7, =0x59551fb8
ldr r8, =0x80000001
ldr r9, =0xa894ed3b
ldr r10, =0xfe5dd232
ldr r11, =0x000000ff
ldr r12, =0x7fffffff
ldr r14, =0x18ff7d8f
cmn r12, r10
ldr r10, =0x1120
ldmdahi r10, {r7}
ldr r10, =0x1120
ldmda r10, {r0,r2,r6,r9,r11}
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
ldr r0, =0x0d9712eb
ldr r1, =0x12345678
ldr r2, =0xa40603b9
ldr r3, =0x6daad0d5
ldr r4, =0x00000001
ldr r5, =0xff2cab50
ldr r6, =0x96eb9507
ldr r7, =0x0132ed84
ldr r8, =0xe6c63501
ldr r9, =0x234887b6
ldr r10, =0x00000000
ldr r11, =0x00000100
ldr r12, =0x00000101
ldr r14, =0x3814a5dc
cmp r6, r1
ldr r10, =0x1120
stmib r10, {r1,r6,r7,r12}
ldr r10, =0x1120
stmib r10, {r9}
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
ldr r0, =0x000000ff
ldr r1, =0x80000001
ldr r2, =0x000000ff
ldr r3, =0xbf897c4f
ldr r4, =0x39673890
ldr r5, =0xffffffff
ldr r6, =0x00000021
ldr r7, =0xcafebabe
ldr r8, =0x12345678
ldr r9, =0xfa8e77d4
ldr r10, =0x9826a283
ldr r11, =0x00000100
ldr r12, =0x3598fc74
ldr r14, =0x3b52aa10
tst r5, r14
ldr r10, =0x1120
ldmda r10!, {lr}
ldr r10, =0x1120
stmda r10, {r1,r3,r8,lr}
ldr r10, =0x1120
stmdb r10!, {r3}
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
