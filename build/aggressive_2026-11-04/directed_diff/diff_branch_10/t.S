.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000021
str r0, [r12, #0]
ldr r0, =0x14720b27
str r0, [r12, #4]
ldr r0, =0x00000001
str r0, [r12, #8]
ldr r0, =0x80000000
str r0, [r12, #12]
ldr r0, =0x00000000
str r0, [r12, #16]
ldr r0, =0xffffffff
str r0, [r12, #20]
ldr r0, =0x000000ff
str r0, [r12, #24]
ldr r0, =0xffffffff
str r0, [r12, #28]
ldr r0, =0x00000002
str r0, [r12, #32]
ldr r0, =0x005d5f5a
str r0, [r12, #36]
ldr r0, =0x0000001f
str r0, [r12, #40]
ldr r0, =0x0000001f
str r0, [r12, #44]
ldr r0, =0x0c716c06
str r0, [r12, #48]
ldr r0, =0xcefc936e
str r0, [r12, #52]
ldr r0, =0x00000020
str r0, [r12, #56]
ldr r0, =0x00000100
str r0, [r12, #60]
ldr r0, =0x29a65afc
ldr r1, =0x000000ff
ldr r2, =0x80000001
ldr r3, =0x7ffffffe
ldr r4, =0x80000000
ldr r5, =0x7e1173e8
ldr r6, =0x7ffffffe
ldr r7, =0xc6a9f5bd
ldr r8, =0xcafebabe
ldr r9, =0x000000ff
ldr r10, =0x5a7607f7
ldr r11, =0x00000020
ldr r12, =0x290b4058
ldr r14, =0x00000001
teq r2, r1
ble 1f
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
ldr r0, =0x0f4f07fd
ldr r1, =0x00000101
ldr r2, =0x00000021
ldr r3, =0xcc8f3e7e
ldr r4, =0x80000001
ldr r5, =0x38957925
ldr r6, =0x90de56b7
ldr r7, =0x8b7a54bb
ldr r8, =0x00000020
ldr r9, =0xc1c1c0e1
ldr r10, =0xcafebabe
ldr r11, =0x80000001
ldr r12, =0x000000ff
ldr r14, =0xd354e8dd
tst r4, r5
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
ldr r0, =0x00000021
ldr r1, =0x00000002
ldr r2, =0x7f3bbd41
ldr r3, =0x0000001f
ldr r4, =0xa8eb115c
ldr r5, =0x19d62e03
ldr r6, =0x00000021
ldr r7, =0x0000ffff
ldr r8, =0x0000001f
ldr r9, =0x96f48ed9
ldr r10, =0x4bd43648
ldr r11, =0x000000ff
ldr r12, =0x9a5e4f5c
ldr r14, =0x595094c0
teq r14, r0
bvs 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r0, =0x927b18c9
ldr r1, =0xa4b6adcc
ldr r2, =0x436f4d58
ldr r3, =0x6383f64c
ldr r4, =0xea02d8b1
ldr r5, =0x495501d1
ldr r6, =0x00000000
ldr r7, =0x12345678
ldr r8, =0x00000021
ldr r9, =0x6b38981c
ldr r10, =0x00000100
ldr r11, =0xeb741dc7
ldr r12, =0xba146981
ldr r14, =0x00000021
cmn r0, r1
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
ldr r0, =0x00000001
ldr r1, =0xcafebabe
ldr r2, =0x2643fd94
ldr r3, =0x42016947
ldr r4, =0xffffffff
ldr r5, =0x7ffffffe
ldr r6, =0xedc6164d
ldr r7, =0x12345678
ldr r8, =0x12345678
ldr r9, =0x7fffffff
ldr r10, =0x00000020
ldr r11, =0x00000101
ldr r12, =0x7fffffff
ldr r14, =0xf908ce4d
teq r11, r7
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bne 2f
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
ldr r0, =0xd65f5336
ldr r1, =0xc801ff34
ldr r2, =0x7ffffffe
ldr r3, =0x3037589a
ldr r4, =0xbab75b75
ldr r5, =0x257897e2
ldr r6, =0xb59a13ff
ldr r7, =0xebb0a666
ldr r8, =0x00000100
ldr r9, =0x65637c51
ldr r10, =0x9cc64829
ldr r11, =0x0000001f
ldr r12, =0xf5a04c23
ldr r14, =0x00000000
tst r4, r12
blmi 1f
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
ldr r0, =0x8d8fc084
ldr r1, =0x00000021
ldr r2, =0x1c6fe31d
ldr r3, =0x12345678
ldr r4, =0xcafebabe
ldr r5, =0xbd1ef929
ldr r6, =0x80000001
ldr r7, =0x409042ce
ldr r8, =0xffffffff
ldr r9, =0xde78ad39
ldr r10, =0x12345678
ldr r11, =0x80a1649c
ldr r12, =0xcdcd4fcd
ldr r14, =0x80000001
cmp r6, r12
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
ldr r0, =0xc78f1083
ldr r1, =0x0000001f
ldr r2, =0x80000001
ldr r3, =0xa956d531
ldr r4, =0x0234c642
ldr r5, =0x80000001
ldr r6, =0xfca68970
ldr r7, =0x213c3ece
ldr r8, =0x7d96c1b3
ldr r9, =0x8de42b2f
ldr r10, =0xb2a7d045
ldr r11, =0x40749d31
ldr r12, =0x80000000
ldr r14, =0x3f88ca33
teq r12, r3
blhi 1f
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
ldr r12,=0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
