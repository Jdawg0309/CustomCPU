.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000000
str r0, [r12, #0]
ldr r0, =0x42f54642
str r0, [r12, #4]
ldr r0, =0x00000020
str r0, [r12, #8]
ldr r0, =0xba438d0a
str r0, [r12, #12]
ldr r0, =0xfd0b5d36
str r0, [r12, #16]
ldr r0, =0xffffffff
str r0, [r12, #20]
ldr r0, =0x668ecaa4
str r0, [r12, #24]
ldr r0, =0x0000001f
str r0, [r12, #28]
ldr r0, =0x290580d1
str r0, [r12, #32]
ldr r0, =0xaca3d0ee
str r0, [r12, #36]
ldr r0, =0x00000101
str r0, [r12, #40]
ldr r0, =0x80000000
str r0, [r12, #44]
ldr r0, =0x00000021
str r0, [r12, #48]
ldr r0, =0x2453792e
str r0, [r12, #52]
ldr r0, =0x00000101
str r0, [r12, #56]
ldr r0, =0x00000021
str r0, [r12, #60]
ldr r0, =0xa4ebdfc4
ldr r1, =0x00000020
ldr r2, =0x8d85bd3c
ldr r3, =0x85237cb8
ldr r4, =0xcafebabe
ldr r5, =0xe2f75910
ldr r6, =0x6c729f7d
ldr r7, =0x7ffffffe
ldr r8, =0x80000000
ldr r9, =0x7c982402
ldr r10, =0xffffffff
ldr r11, =0xbd00c483
ldr r12, =0x83b8419d
ldr r14, =0x00000021
cmp r3, r11
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
ble 2f
add r1, r1, #7
2:
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
ldr r0, =0x0000001f
ldr r1, =0x40eb74de
ldr r2, =0x0000001f
ldr r3, =0x7ffffffe
ldr r4, =0xe7e54aa5
ldr r5, =0xeb0b68ec
ldr r6, =0xbd811b96
ldr r7, =0x00000100
ldr r8, =0x0000001f
ldr r9, =0x3b3625ad
ldr r10, =0x00000100
ldr r11, =0x7ffffffe
ldr r12, =0x6809dc4b
ldr r14, =0x7ffffffe
cmp r10, r2
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvc 2f
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
ldr r0, =0x00000101
ldr r1, =0x6aa384ba
ldr r2, =0x0000001f
ldr r3, =0xe020c41e
ldr r4, =0x3b6c8d63
ldr r5, =0x0f3375f0
ldr r6, =0x341b6488
ldr r7, =0x00000101
ldr r8, =0xa1c02ce1
ldr r9, =0x16d30de5
ldr r10, =0x00000100
ldr r11, =0x42dbcd7d
ldr r12, =0x12345678
ldr r14, =0x000000ff
cmn r12, r7
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
ldr r0, =0x18d87da5
ldr r1, =0x00000000
ldr r2, =0x6ce7c53c
ldr r3, =0x80000001
ldr r4, =0xec56c98a
ldr r5, =0xcafebabe
ldr r6, =0x000000ff
ldr r7, =0x99b0508e
ldr r8, =0x8e13c90d
ldr r9, =0x22960146
ldr r10, =0x000000ff
ldr r11, =0x987457a7
ldr r12, =0x12345678
ldr r14, =0x0000001f
teq r0, r1
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
beq 2f
add r1, r1, #7
2:
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
ldr r0, =0x1d2d2d25
ldr r1, =0x00000002
ldr r2, =0x73b8cca9
ldr r3, =0x12345678
ldr r4, =0x7ffffffe
ldr r5, =0x00000020
ldr r6, =0x00000021
ldr r7, =0x00000001
ldr r8, =0x0000ffff
ldr r9, =0x30fbd48e
ldr r10, =0xcafebabe
ldr r11, =0x7e93d8cc
ldr r12, =0xc7cee74e
ldr r14, =0x7ffffffe
cmn r2, r7
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x05bc7eaa
ldr r1, =0x00000020
ldr r2, =0x86bfbc08
ldr r3, =0xd281e02b
ldr r4, =0x0000ffff
ldr r5, =0x22f06bc2
ldr r6, =0x00000002
ldr r7, =0x0000ffff
ldr r8, =0x00000100
ldr r9, =0x330a41a7
ldr r10, =0xb6939d36
ldr r11, =0x00000100
ldr r12, =0xe8b51d11
ldr r14, =0xcafebabe
teq r4, r10
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
ble 2f
add r1, r1, #7
2:
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
ldr r0, =0x2d2cfc1c
ldr r1, =0x80000000
ldr r2, =0xe5f5911a
ldr r3, =0xc2328991
ldr r4, =0x00000000
ldr r5, =0x37667c27
ldr r6, =0x098a9eb0
ldr r7, =0x00000100
ldr r8, =0xffffffff
ldr r9, =0x80000000
ldr r10, =0x4c4bd3ab
ldr r11, =0x1f9b91d5
ldr r12, =0xcafebabe
ldr r14, =0x8cff5b29
teq r12, r10
blhi 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x0000001f
ldr r1, =0x9cc18dc5
ldr r2, =0x98212046
ldr r3, =0xde3d0595
ldr r4, =0xc0cb5913
ldr r5, =0x80000000
ldr r6, =0x12345678
ldr r7, =0x00000001
ldr r8, =0x4cfd9f27
ldr r9, =0x0000ffff
ldr r10, =0x8f167538
ldr r11, =0x00000101
ldr r12, =0xe09f874f
ldr r14, =0x00000000
tst r10, r0
bmi 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
