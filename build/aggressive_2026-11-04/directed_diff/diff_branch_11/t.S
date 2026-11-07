.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x7ffffffe
str r0, [r12, #0]
ldr r0, =0x7ffffffe
str r0, [r12, #4]
ldr r0, =0x00000100
str r0, [r12, #8]
ldr r0, =0x0000001f
str r0, [r12, #12]
ldr r0, =0x00000001
str r0, [r12, #16]
ldr r0, =0x0000001f
str r0, [r12, #20]
ldr r0, =0xc5f2dba9
str r0, [r12, #24]
ldr r0, =0x516e0861
str r0, [r12, #28]
ldr r0, =0x00000021
str r0, [r12, #32]
ldr r0, =0xac31b105
str r0, [r12, #36]
ldr r0, =0x020b7ac3
str r0, [r12, #40]
ldr r0, =0x4ff3c314
str r0, [r12, #44]
ldr r0, =0xc9a03182
str r0, [r12, #48]
ldr r0, =0xcafebabe
str r0, [r12, #52]
ldr r0, =0x7fffffff
str r0, [r12, #56]
ldr r0, =0x5b68e1f3
str r0, [r12, #60]
ldr r0, =0xd7d86894
ldr r1, =0xdae54261
ldr r2, =0x81215b79
ldr r3, =0xc58bae7c
ldr r4, =0xb1c87c48
ldr r5, =0x36b97867
ldr r6, =0x00000020
ldr r7, =0x3c0f6690
ldr r8, =0x615d5eeb
ldr r9, =0x7ffffffe
ldr r10, =0xbfd43699
ldr r11, =0x7fffffff
ldr r12, =0x37afbaf8
ldr r14, =0x000000ff
tst r12, r6
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
ldr r0, =0xfc3a4f8c
ldr r1, =0xcafebabe
ldr r2, =0x0000ffff
ldr r3, =0x927fc56a
ldr r4, =0x00000020
ldr r5, =0x08aa4919
ldr r6, =0x000000ff
ldr r7, =0x7ffffffe
ldr r8, =0x00000020
ldr r9, =0x80000000
ldr r10, =0x9c9b8d3e
ldr r11, =0x2098d98d
ldr r12, =0xfdca1cce
ldr r14, =0x7ffffffe
cmp r14, r8
bmi 1f
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
ldr r0, =0x4c3d30f5
ldr r1, =0x80000001
ldr r2, =0x00000001
ldr r3, =0xc6ec7d7b
ldr r4, =0xe70abe7a
ldr r5, =0xa66a68c1
ldr r6, =0x00000002
ldr r7, =0xcafebabe
ldr r8, =0x01684f6b
ldr r9, =0xc20c2a22
ldr r10, =0x6f95b97e
ldr r11, =0x0000001f
ldr r12, =0x9a45571b
ldr r14, =0x9f70e67b
cmn r8, r2
bleq 1f
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
ldr r0, =0x00000020
ldr r1, =0x719d9883
ldr r2, =0xe8bd494e
ldr r3, =0x0000ffff
ldr r4, =0x0000ffff
ldr r5, =0x00000000
ldr r6, =0x0000ffff
ldr r7, =0xf41119e4
ldr r8, =0xcafebabe
ldr r9, =0x09ac6308
ldr r10, =0x2bc473af
ldr r11, =0x81efd91c
ldr r12, =0x80000001
ldr r14, =0xcafebabe
cmn r5, r5
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bpl 2f
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
ldr r0, =0xcafebabe
ldr r1, =0x3475c82f
ldr r2, =0x12345678
ldr r3, =0xe6df8129
ldr r4, =0x0d93f126
ldr r5, =0x8d2d6579
ldr r6, =0xc61bbd0a
ldr r7, =0xd53f3f88
ldr r8, =0x7ffffffe
ldr r9, =0x77b44087
ldr r10, =0xcafebabe
ldr r11, =0x80000001
ldr r12, =0xc1c2aed8
ldr r14, =0x0000ffff
teq r2, r3
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
ble 2f
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
ldr r0, =0x00000000
ldr r1, =0x1011ac7c
ldr r2, =0xcafebabe
ldr r3, =0x52aa2665
ldr r4, =0x000000ff
ldr r5, =0x32c2bc75
ldr r6, =0xc4abd153
ldr r7, =0x80000000
ldr r8, =0x78e029df
ldr r9, =0x399cdee6
ldr r10, =0x00000020
ldr r11, =0x80b9af4e
ldr r12, =0xd6390a40
ldr r14, =0x00000101
tst r10, r7
blgt 1f
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
ldr r0, =0xec7631a9
ldr r1, =0x2f17c575
ldr r2, =0x3a43f4e3
ldr r3, =0x0000001f
ldr r4, =0x00000002
ldr r5, =0xc1d866f9
ldr r6, =0x00000101
ldr r7, =0x7fffffff
ldr r8, =0x0000ffff
ldr r9, =0xf64524cc
ldr r10, =0x00000002
ldr r11, =0x5fb2321e
ldr r12, =0x00000001
ldr r14, =0x000000ff
teq r11, r5
blmi 1f
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
ldr r0, =0x344cb5ea
ldr r1, =0xf611e89f
ldr r2, =0x3a90068a
ldr r3, =0xe9ad55d2
ldr r4, =0x29c9a24a
ldr r5, =0x0000ffff
ldr r6, =0x0000ffff
ldr r7, =0x0e666df0
ldr r8, =0xaac3e39e
ldr r9, =0x00000002
ldr r10, =0x0000001f
ldr r11, =0xeb7f000e
ldr r12, =0x0fba5ce8
ldr r14, =0x00000101
cmp r9, r14
bvc 1f
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
