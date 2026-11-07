.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x4c82f1c3
str r0, [r12, #0]
ldr r0, =0x0000001f
str r0, [r12, #4]
ldr r0, =0xffffffff
str r0, [r12, #8]
ldr r0, =0xeae8452c
str r0, [r12, #12]
ldr r0, =0x12345678
str r0, [r12, #16]
ldr r0, =0x80000000
str r0, [r12, #20]
ldr r0, =0x59ccebc4
str r0, [r12, #24]
ldr r0, =0xd6eaf878
str r0, [r12, #28]
ldr r0, =0xb26e8733
str r0, [r12, #32]
ldr r0, =0x2af8b867
str r0, [r12, #36]
ldr r0, =0xda5eeca2
str r0, [r12, #40]
ldr r0, =0x0000ffff
str r0, [r12, #44]
ldr r0, =0x00000100
str r0, [r12, #48]
ldr r0, =0x26ae6482
str r0, [r12, #52]
ldr r0, =0x80000001
str r0, [r12, #56]
ldr r0, =0x2ec33a64
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0x000000ff
ldr r2, =0xc97022af
ldr r3, =0x12345678
ldr r4, =0x80000001
ldr r5, =0xd8c61bec
ldr r6, =0x000000ff
ldr r7, =0x14521f78
ldr r8, =0x00000000
ldr r9, =0x57197441
ldr r10, =0x335d6012
ldr r11, =0x3a12982a
ldr r12, =0x00000100
ldr r14, =0x6c1816e6
cmp r1, r7
bge 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r0, =0xcafebabe
ldr r1, =0x000000ff
ldr r2, =0xcafebabe
ldr r3, =0x7fffffff
ldr r4, =0x3af0ecb5
ldr r5, =0x9c5bde35
ldr r6, =0x00000002
ldr r7, =0x7fffffff
ldr r8, =0xf3ec5563
ldr r9, =0xdbb8950f
ldr r10, =0x5dc5608a
ldr r11, =0x00000000
ldr r12, =0xcafebabe
ldr r14, =0x12345678
cmn r9, r2
blt 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r0, =0x80000000
ldr r1, =0xdf74dbcb
ldr r2, =0xcead94ef
ldr r3, =0x88e68469
ldr r4, =0x94fb3c99
ldr r5, =0x5c0408f6
ldr r6, =0x00000101
ldr r7, =0x80000001
ldr r8, =0x80000001
ldr r9, =0x37a7448a
ldr r10, =0xeb51e4b4
ldr r11, =0x1522a2c6
ldr r12, =0x00000001
ldr r14, =0x7ffffffe
teq r6, r9
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
ldr r0, =0x0000001f
ldr r1, =0x0000ffff
ldr r2, =0x5d1ecea1
ldr r3, =0x00000020
ldr r4, =0x7ffffffe
ldr r5, =0x37990d87
ldr r6, =0x7fffffff
ldr r7, =0xffffffff
ldr r8, =0x7ffffffe
ldr r9, =0x000000ff
ldr r10, =0x598cadb7
ldr r11, =0x00000002
ldr r12, =0x07426d43
ldr r14, =0x00000100
tst r0, r9
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x00000101
ldr r1, =0x1a3da27a
ldr r2, =0x7a50924e
ldr r3, =0x2368a3c2
ldr r4, =0x7ffffffe
ldr r5, =0x2b230203
ldr r6, =0x000000ff
ldr r7, =0x00000000
ldr r8, =0x80000000
ldr r9, =0x00000002
ldr r10, =0x0000001f
ldr r11, =0xfd70ed85
ldr r12, =0x0000ffff
ldr r14, =0x00000001
cmn r12, r3
blcs 1f
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
ldr r0, =0x00000101
ldr r1, =0x5158ef9f
ldr r2, =0xd2e9f399
ldr r3, =0x00000002
ldr r4, =0xd401dbd9
ldr r5, =0x00000001
ldr r6, =0xdc167004
ldr r7, =0x77164363
ldr r8, =0xffffffff
ldr r9, =0x4d21bc44
ldr r10, =0x7fffffff
ldr r11, =0x8ff2e675
ldr r12, =0x3d293e09
ldr r14, =0x44b55707
cmn r9, r3
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0xd3f2ccc7
ldr r1, =0x00000021
ldr r2, =0x80000000
ldr r3, =0x7ffffffe
ldr r4, =0x00000020
ldr r5, =0x00000020
ldr r6, =0x21e14071
ldr r7, =0xe8f46766
ldr r8, =0x00000021
ldr r9, =0x867b5d67
ldr r10, =0x80000001
ldr r11, =0xe948b54b
ldr r12, =0x0000ffff
ldr r14, =0xcafebabe
cmn r10, r2
bne 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r0, =0x7ffffffe
ldr r1, =0x00000020
ldr r2, =0x00000001
ldr r3, =0xcafebabe
ldr r4, =0x363d2538
ldr r5, =0x1d98bc2a
ldr r6, =0x7ffffffe
ldr r7, =0xe8858835
ldr r8, =0x00000101
ldr r9, =0x388b553a
ldr r10, =0x80000001
ldr r11, =0x12345678
ldr r12, =0x00000020
ldr r14, =0x0000ffff
teq r7, r3
bhi 1f
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
