.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000000
str r0, [r12, #0]
ldr r0, =0x3c59bf07
str r0, [r12, #4]
ldr r0, =0x7ffffffe
str r0, [r12, #8]
ldr r0, =0x02e1d0ae
str r0, [r12, #12]
ldr r0, =0xda4e0cd3
str r0, [r12, #16]
ldr r0, =0x8b1d15bf
str r0, [r12, #20]
ldr r0, =0xe6909346
str r0, [r12, #24]
ldr r0, =0x7fffffff
str r0, [r12, #28]
ldr r0, =0x00000100
str r0, [r12, #32]
ldr r0, =0x0000ffff
str r0, [r12, #36]
ldr r0, =0x601abd16
str r0, [r12, #40]
ldr r0, =0x54460a14
str r0, [r12, #44]
ldr r0, =0x328d3432
str r0, [r12, #48]
ldr r0, =0x12345678
str r0, [r12, #52]
ldr r0, =0xcafebabe
str r0, [r12, #56]
ldr r0, =0x00000020
str r0, [r12, #60]
ldr r0, =0xc691d805
ldr r1, =0x00000101
ldr r2, =0x04d9ef08
ldr r3, =0xce8cc037
ldr r4, =0x7ffffffe
ldr r5, =0x7fffffff
ldr r6, =0x0000ffff
ldr r7, =0x8b7345ae
ldr r8, =0x252a4c27
ldr r9, =0x4917b7eb
ldr r10, =0x7202c6a2
ldr r11, =0x73405656
ldr r12, =0x000000ff
ldr r14, =0xffffffff
cmn r11, r11
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
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
ldr r0, =0xcafebabe
ldr r1, =0xc70e3187
ldr r2, =0x00000020
ldr r3, =0x00000000
ldr r4, =0x593e7072
ldr r5, =0x00000021
ldr r6, =0x19754044
ldr r7, =0xcafebabe
ldr r8, =0x80000000
ldr r9, =0x00000002
ldr r10, =0xffffffff
ldr r11, =0xdb683c17
ldr r12, =0x0000001f
ldr r14, =0x8ab74766
cmn r0, r11
adds r4, pc, r0
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
ldr r0, =0x989cc0ac
ldr r1, =0x0000ffff
ldr r2, =0x80000000
ldr r3, =0xc074ebb4
ldr r4, =0xe663a09d
ldr r5, =0x00000001
ldr r6, =0x00000020
ldr r7, =0xac9b5f33
ldr r8, =0x12345678
ldr r9, =0x12345678
ldr r10, =0x3609edd7
ldr r11, =0x000000ff
ldr r12, =0x12345678
ldr r14, =0x5c40066a
tst r10, r11
add r2, pc, #52
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
ldr r0, =0x00000021
ldr r1, =0x00000002
ldr r2, =0x6694cd7d
ldr r3, =0xc212e8c7
ldr r4, =0xcec9ff75
ldr r5, =0xf51632ff
ldr r6, =0x654f43ad
ldr r7, =0x9bb48793
ldr r8, =0x508da79b
ldr r9, =0x0000001f
ldr r10, =0x00000000
ldr r11, =0x0000001f
ldr r12, =0x00000002
ldr r14, =0x00000101
tst r2, r0
adr r3, 1f
mov pc, r3
add r0, r0, #1
1:
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
ldr r0, =0x0000ffff
ldr r1, =0xcafebabe
ldr r2, =0x80000000
ldr r3, =0xffffffff
ldr r4, =0x4376c98c
ldr r5, =0x693c07ff
ldr r6, =0xac8de6b8
ldr r7, =0x03690276
ldr r8, =0xe332c09b
ldr r9, =0xc336f15a
ldr r10, =0x0e3c054e
ldr r11, =0x0896a2cb
ldr r12, =0x7fffffff
ldr r14, =0x333e3c59
cmp r5, r6
ldr r10, =0x1120
adr r3, 1f
str r3, [r10, #4]
ldmia r10, {r4, pc}
add r0, r0, #7
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
ldr r0, =0x41257663
ldr r1, =0x00000101
ldr r2, =0x12345678
ldr r3, =0x8ab426d8
ldr r4, =0xb6af4629
ldr r5, =0x590f0f55
ldr r6, =0x1f853476
ldr r7, =0x94d7097f
ldr r8, =0x5eeab048
ldr r9, =0x00000001
ldr r10, =0xb18bd86a
ldr r11, =0x9919e67f
ldr r12, =0x12345678
ldr r14, =0x00000021
cmn r12, r9
add r6, pc, r5, lsl #2
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
ldr r0, =0xa1da043b
ldr r1, =0x00000101
ldr r2, =0x42af6c84
ldr r3, =0x94367eda
ldr r4, =0x3f577ab5
ldr r5, =0x00000100
ldr r6, =0x00000000
ldr r7, =0x0000ffff
ldr r8, =0x00000100
ldr r9, =0x3ea8c1d6
ldr r10, =0x00000101
ldr r11, =0x00000002
ldr r12, =0x6562b002
ldr r14, =0x71746352
teq r7, r14
ldr r0, [pc, #-8]
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
ldr r0, =0xffffffff
ldr r1, =0xba5e4034
ldr r2, =0x00000021
ldr r3, =0xcafebabe
ldr r4, =0xcafebabe
ldr r5, =0x00000000
ldr r6, =0xe0986c0b
ldr r7, =0x00000002
ldr r8, =0x00758a94
ldr r9, =0xf2006a9d
ldr r10, =0xe6237852
ldr r11, =0x8746cfa7
ldr r12, =0x23e62cec
ldr r14, =0x472a0f1d
cmp r12, r4
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
