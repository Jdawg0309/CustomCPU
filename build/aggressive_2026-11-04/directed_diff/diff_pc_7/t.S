.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xe4ce4fa6
str r0, [r12, #0]
ldr r0, =0x00000101
str r0, [r12, #4]
ldr r0, =0xd502a7b0
str r0, [r12, #8]
ldr r0, =0xb8fc9061
str r0, [r12, #12]
ldr r0, =0xdb92b6b5
str r0, [r12, #16]
ldr r0, =0x00000100
str r0, [r12, #20]
ldr r0, =0x0e94b678
str r0, [r12, #24]
ldr r0, =0xe7dbfa8e
str r0, [r12, #28]
ldr r0, =0x1fbf907d
str r0, [r12, #32]
ldr r0, =0x028a1ec1
str r0, [r12, #36]
ldr r0, =0x6a0a53f8
str r0, [r12, #40]
ldr r0, =0x80000000
str r0, [r12, #44]
ldr r0, =0x6b7b7748
str r0, [r12, #48]
ldr r0, =0x80000001
str r0, [r12, #52]
ldr r0, =0xc33285fc
str r0, [r12, #56]
ldr r0, =0x038f3b38
str r0, [r12, #60]
ldr r0, =0x00000021
ldr r1, =0x00000001
ldr r2, =0x23d6d96a
ldr r3, =0x844bd861
ldr r4, =0x00000021
ldr r5, =0x00000101
ldr r6, =0x000000ff
ldr r7, =0x00000001
ldr r8, =0x00000002
ldr r9, =0x39dd9368
ldr r10, =0xb405de17
ldr r11, =0x0000ffff
ldr r12, =0xffffffff
ldr r14, =0xdc619733
cmn r6, r5
ldr pc, =1f
add r0, r0, #3
1:
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
ldr r0, =0x8ebecf5b
ldr r1, =0x9f511a1b
ldr r2, =0x12345678
ldr r3, =0x00000021
ldr r4, =0x12d44d9b
ldr r5, =0x00000000
ldr r6, =0x30e7339b
ldr r7, =0x00000020
ldr r8, =0xbad381f1
ldr r9, =0xe5e17adb
ldr r10, =0x37f28b76
ldr r11, =0x7fffffff
ldr r12, =0x5888929d
ldr r14, =0x00000100
teq r6, r9
adr r3, 1f
movvs pc, r3
add r0, r0, #1
1:
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
ldr r0, =0xf2d1b799
ldr r1, =0xcafebabe
ldr r2, =0x1c72030a
ldr r3, =0x80000000
ldr r4, =0xac7fd93c
ldr r5, =0x4f66ef6b
ldr r6, =0x9504b988
ldr r7, =0x00000020
ldr r8, =0x80000000
ldr r9, =0x166bcae7
ldr r10, =0x61457676
ldr r11, =0xefedcaba
ldr r12, =0x000000ff
ldr r14, =0x80000001
cmn r2, r10
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
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
ldr r0, =0xb4872071
ldr r1, =0x80701ff2
ldr r2, =0x07ca4616
ldr r3, =0xbd154c10
ldr r4, =0x58db9d8e
ldr r5, =0x00000101
ldr r6, =0xffffffff
ldr r7, =0xab1059cf
ldr r8, =0x80000000
ldr r9, =0x7fffffff
ldr r10, =0xffffffff
ldr r11, =0xffffffff
ldr r12, =0xffffffff
ldr r14, =0x7fffffff
cmp r10, r5
cmp pc, r6
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
ldr r0, =0x81af317e
ldr r1, =0x0000001f
ldr r2, =0x12345678
ldr r3, =0x80000001
ldr r4, =0x00000002
ldr r5, =0x12345678
ldr r6, =0x4d74c172
ldr r7, =0x00000020
ldr r8, =0x6541be15
ldr r9, =0x1d7a6d74
ldr r10, =0x7fffffff
ldr r11, =0x00000001
ldr r12, =0x00000101
ldr r14, =0x2f4b1243
tst r1, r14
sub r1, pc, #56
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
ldr r0, =0xa8fa46a7
ldr r1, =0x9b3de93a
ldr r2, =0x3400c47b
ldr r3, =0x4a457a9e
ldr r4, =0x4a55348c
ldr r5, =0xd3973c77
ldr r6, =0xe69f361a
ldr r7, =0x0000ffff
ldr r8, =0x42a4a030
ldr r9, =0xae495d2e
ldr r10, =0x2ffddab4
ldr r11, =0x00000000
ldr r12, =0x1a33673b
ldr r14, =0x79a52320
teq r0, r7
sub r2, pc, #60
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
ldr r0, =0x80000000
ldr r1, =0x12345678
ldr r2, =0x0000ffff
ldr r3, =0xcafebabe
ldr r4, =0x00000101
ldr r5, =0x8eea8911
ldr r6, =0x00000100
ldr r7, =0x0cae19d2
ldr r8, =0x3caded29
ldr r9, =0x26029f5c
ldr r10, =0x12345678
ldr r11, =0xcafebabe
ldr r12, =0x00000001
ldr r14, =0x7ffffffe
tst r10, r7
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
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
ldr r0, =0x12345678
ldr r1, =0xb4f503eb
ldr r2, =0x27775644
ldr r3, =0x00000000
ldr r4, =0x00000002
ldr r5, =0x1d82815d
ldr r6, =0x35de8331
ldr r7, =0x00000000
ldr r8, =0x00000001
ldr r9, =0xffffffff
ldr r10, =0x00000000
ldr r11, =0x0000001f
ldr r12, =0x3cd1f1c4
ldr r14, =0x7ffffffe
teq r4, r4
add r0, pc, #40
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
