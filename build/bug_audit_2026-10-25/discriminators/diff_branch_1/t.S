.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x07043c9a
str r0, [r12, #0]
ldr r0, =0xe63fd7ee
str r0, [r12, #4]
ldr r0, =0x00000000
str r0, [r12, #8]
ldr r0, =0x00000002
str r0, [r12, #12]
ldr r0, =0x54e630ff
str r0, [r12, #16]
ldr r0, =0xcafebabe
str r0, [r12, #20]
ldr r0, =0x195e8429
str r0, [r12, #24]
ldr r0, =0x7ffffffe
str r0, [r12, #28]
ldr r0, =0x6eefb8e2
str r0, [r12, #32]
ldr r0, =0xf9364ffa
str r0, [r12, #36]
ldr r0, =0x6f28dee8
str r0, [r12, #40]
ldr r0, =0xcafebabe
str r0, [r12, #44]
ldr r0, =0x0000001f
str r0, [r12, #48]
ldr r0, =0x7ffffffe
str r0, [r12, #52]
ldr r0, =0x7ffffffe
str r0, [r12, #56]
ldr r0, =0x458429ae
str r0, [r12, #60]
ldr r0, =0x80000001
ldr r1, =0x58452765
ldr r2, =0x88041266
ldr r3, =0x00d1417b
ldr r4, =0x0000001f
ldr r5, =0x00000101
ldr r6, =0x7fffffff
ldr r7, =0x12345678
ldr r8, =0x00000021
ldr r9, =0x1c2cbbf6
ldr r10, =0x00000101
ldr r11, =0x80000000
ldr r12, =0x1254b5ec
ldr r14, =0x80000001
tst r3, r5
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
ldr r0, =0x12345678
ldr r1, =0x00000002
ldr r2, =0x12345678
ldr r3, =0x7ffffffe
ldr r4, =0x12345678
ldr r5, =0x00000021
ldr r6, =0x176d26c5
ldr r7, =0x7fffffff
ldr r8, =0xcafebabe
ldr r9, =0x8f6efb7c
ldr r10, =0x2ece3387
ldr r11, =0x00000101
ldr r12, =0x00000002
ldr r14, =0xffffffff
cmp r7, r6
bl 1f
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
ldr r0, =0x00000000
ldr r1, =0x27ab1725
ldr r2, =0x85c6fe14
ldr r3, =0x5bdb73f0
ldr r4, =0x0252a4e8
ldr r5, =0x80000001
ldr r6, =0x00000100
ldr r7, =0x00000000
ldr r8, =0xd4523cb1
ldr r9, =0xdd324b67
ldr r10, =0x80000000
ldr r11, =0x00000101
ldr r12, =0xfee87d7e
ldr r14, =0x00000101
tst r14, r9
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bhi 2f
add r1, r1, #7
2:
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
ldr r0, =0x67df4d42
ldr r1, =0x00000101
ldr r2, =0x917b529f
ldr r3, =0x00000020
ldr r4, =0x4f047116
ldr r5, =0xa7d8ef40
ldr r6, =0x12345678
ldr r7, =0x7fffffff
ldr r8, =0xe8ac69a8
ldr r9, =0xffffffff
ldr r10, =0x283483ce
ldr r11, =0xf3c7be99
ldr r12, =0xafb08d1f
ldr r14, =0x0000001f
teq r1, r11
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bcs 2f
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
ldr r0, =0x00000002
ldr r1, =0xcafebabe
ldr r2, =0x9cd8cf1c
ldr r3, =0x0000ffff
ldr r4, =0x0000ffff
ldr r5, =0x19441562
ldr r6, =0x00000020
ldr r7, =0x00000002
ldr r8, =0x46349fd9
ldr r9, =0x59d43755
ldr r10, =0x20932f09
ldr r11, =0xffffffff
ldr r12, =0xc3202a46
ldr r14, =0x89dc2e9f
tst r12, r9
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
ldr r0, =0x9227c75d
ldr r1, =0x80000000
ldr r2, =0x3bb94de4
ldr r3, =0x5920c579
ldr r4, =0x98f6edb2
ldr r5, =0xff67b27f
ldr r6, =0x00000020
ldr r7, =0x0000ffff
ldr r8, =0x00000001
ldr r9, =0x12345678
ldr r10, =0xde75fb0f
ldr r11, =0x0e2791d4
ldr r12, =0x7fffffff
ldr r14, =0x00000101
cmp r0, r0
bvc 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r0, =0x81b296ef
ldr r1, =0xe255ebbb
ldr r2, =0xc8d42669
ldr r3, =0x45b3671f
ldr r4, =0x7ffffffe
ldr r5, =0x80000001
ldr r6, =0x4cd4b8d7
ldr r7, =0xffffffff
ldr r8, =0x27ab6785
ldr r9, =0xe555f067
ldr r10, =0xa24f202b
ldr r11, =0x0000001f
ldr r12, =0x00000002
ldr r14, =0x000000ff
tst r3, r7
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
ldr r0, =0x00000100
ldr r1, =0x7ffffffe
ldr r2, =0x114fc235
ldr r3, =0xc67f13d9
ldr r4, =0xf6a98951
ldr r5, =0x00000001
ldr r6, =0x29fa894a
ldr r7, =0x12345678
ldr r8, =0x9595a9f5
ldr r9, =0x45f0cadb
ldr r10, =0x2ba95cbc
ldr r11, =0x24087992
ldr r12, =0x36d44b71
ldr r14, =0xcafebabe
cmn r3, r9
blls 1f
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
