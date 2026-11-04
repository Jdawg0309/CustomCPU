.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000001
str r0, [r12, #0]
ldr r0, =0x00000021
str r0, [r12, #4]
ldr r0, =0x60915f13
str r0, [r12, #8]
ldr r0, =0x2da3e518
str r0, [r12, #12]
ldr r0, =0x3b412217
str r0, [r12, #16]
ldr r0, =0x3bd01d1b
str r0, [r12, #20]
ldr r0, =0x7fffffff
str r0, [r12, #24]
ldr r0, =0x6368277e
str r0, [r12, #28]
ldr r0, =0x67555fd8
str r0, [r12, #32]
ldr r0, =0xc08bd6e6
str r0, [r12, #36]
ldr r0, =0x80000001
str r0, [r12, #40]
ldr r0, =0x23a956d4
str r0, [r12, #44]
ldr r0, =0xeac3418a
str r0, [r12, #48]
ldr r0, =0x80000001
str r0, [r12, #52]
ldr r0, =0x00000100
str r0, [r12, #56]
ldr r0, =0x80000000
str r0, [r12, #60]
ldr r0, =0x381b9aff
ldr r1, =0xf2ea3b86
ldr r2, =0x00000021
ldr r3, =0x7fffffff
ldr r4, =0x64128780
ldr r5, =0x00000100
ldr r6, =0xc67307e6
ldr r7, =0x8877fe67
ldr r8, =0xea7ebb67
ldr r9, =0x0000ffff
ldr r10, =0x98596bb5
ldr r11, =0x2cd36191
ldr r12, =0xfaa83b7c
ldr r14, =0x0bf2e71b
tst r9, r12
beq 1f
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
ldr r0, =0x00000021
ldr r1, =0x912f4a9c
ldr r2, =0x000000ff
ldr r3, =0x0e1e4181
ldr r4, =0x00000000
ldr r5, =0x12345678
ldr r6, =0x7ffffffe
ldr r7, =0x00000021
ldr r8, =0x00000000
ldr r9, =0x1e663434
ldr r10, =0x80000000
ldr r11, =0x00000020
ldr r12, =0x00000002
ldr r14, =0x000000ff
cmn r5, r1
blcs 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0xdb9526c4
ldr r1, =0x00000001
ldr r2, =0x7ffffffe
ldr r3, =0xcafebabe
ldr r4, =0x93799fad
ldr r5, =0x0000ffff
ldr r6, =0x51f13d67
ldr r7, =0x2bf4880c
ldr r8, =0xc4bafe60
ldr r9, =0x0000ffff
ldr r10, =0x00000000
ldr r11, =0x057fbb17
ldr r12, =0x2e041c20
ldr r14, =0x0000ffff
cmp r5, r2
blcc 1f
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
ldr r0, =0xcafebabe
ldr r1, =0x090fb72f
ldr r2, =0xb0f769ca
ldr r3, =0x9e49f41d
ldr r4, =0x0000001f
ldr r5, =0x0000ffff
ldr r6, =0x80000000
ldr r7, =0x00000020
ldr r8, =0xcafebabe
ldr r9, =0x21134d38
ldr r10, =0x00000100
ldr r11, =0x00000020
ldr r12, =0x7ffffffe
ldr r14, =0xbe8848bf
cmp r5, r14
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
ldr r0, =0x12345678
ldr r1, =0x7fffffff
ldr r2, =0xcafebabe
ldr r3, =0x80000001
ldr r4, =0x80000000
ldr r5, =0xc1088beb
ldr r6, =0xa233b5f7
ldr r7, =0x80000000
ldr r8, =0x69fe80ce
ldr r9, =0x377a5646
ldr r10, =0xaf369c73
ldr r11, =0xffffffff
ldr r12, =0x00000002
ldr r14, =0x443f1e8d
cmn r6, r14
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bhi 2f
add r1, r1, #7
2:
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
ldr r1, =0x5752a99a
ldr r2, =0x1dc437dd
ldr r3, =0x949465f2
ldr r4, =0x000000ff
ldr r5, =0x6d9346b2
ldr r6, =0x5500e59f
ldr r7, =0x2078f87b
ldr r8, =0x00000002
ldr r9, =0x2eea6efd
ldr r10, =0x7fffffff
ldr r11, =0x80000001
ldr r12, =0x12345678
ldr r14, =0xde9f498f
cmp r11, r7
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
ldr r0, =0x38a0554a
ldr r1, =0x21b9769d
ldr r2, =0x00000001
ldr r3, =0x94f2b294
ldr r4, =0x00000021
ldr r5, =0x80000001
ldr r6, =0x00000021
ldr r7, =0xa54a0493
ldr r8, =0x000000ff
ldr r9, =0x7ffffffe
ldr r10, =0x4aa93f52
ldr r11, =0xcafebabe
ldr r12, =0x0000ffff
ldr r14, =0x00000002
tst r5, r10
blpl 1f
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
ldr r0, =0x0000ffff
ldr r1, =0x185f9cc5
ldr r2, =0xf979c43a
ldr r3, =0x0000ffff
ldr r4, =0xae2c65b5
ldr r5, =0x04276294
ldr r6, =0x00000020
ldr r7, =0x0000001f
ldr r8, =0x00000002
ldr r9, =0x00000100
ldr r10, =0xc52b73f9
ldr r11, =0x12345678
ldr r12, =0x5e1f2dcb
ldr r14, =0x47353961
cmp r1, r4
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
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
