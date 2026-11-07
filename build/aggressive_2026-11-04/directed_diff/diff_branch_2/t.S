.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000020
str r0, [r12, #0]
ldr r0, =0xcc833928
str r0, [r12, #4]
ldr r0, =0x80000001
str r0, [r12, #8]
ldr r0, =0xbe756b58
str r0, [r12, #12]
ldr r0, =0xf7f2af7a
str r0, [r12, #16]
ldr r0, =0x0000ffff
str r0, [r12, #20]
ldr r0, =0x00000020
str r0, [r12, #24]
ldr r0, =0xcafebabe
str r0, [r12, #28]
ldr r0, =0x80000000
str r0, [r12, #32]
ldr r0, =0xdc5b5a94
str r0, [r12, #36]
ldr r0, =0x00000020
str r0, [r12, #40]
ldr r0, =0x78e5bc56
str r0, [r12, #44]
ldr r0, =0x2e796891
str r0, [r12, #48]
ldr r0, =0xb3741cfd
str r0, [r12, #52]
ldr r0, =0x80000000
str r0, [r12, #56]
ldr r0, =0x3e5a8706
str r0, [r12, #60]
ldr r0, =0x50034738
ldr r1, =0x00000101
ldr r2, =0x00000000
ldr r3, =0x710cfe4c
ldr r4, =0x71059c9d
ldr r5, =0x7ffffffe
ldr r6, =0xd762ec53
ldr r7, =0x00000001
ldr r8, =0x3e0620a7
ldr r9, =0x64086caf
ldr r10, =0x000000ff
ldr r11, =0xffffffff
ldr r12, =0xd5290ef7
ldr r14, =0x00000100
cmp r0, r0
blcc 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x00000000
ldr r1, =0x0000ffff
ldr r2, =0xc4d31e7d
ldr r3, =0xf0d43bc2
ldr r4, =0x5c899d98
ldr r5, =0xa33a7965
ldr r6, =0x18e35c08
ldr r7, =0x00000101
ldr r8, =0x00000001
ldr r9, =0x00000020
ldr r10, =0x80000000
ldr r11, =0x00000020
ldr r12, =0x8c3417e6
ldr r14, =0x7fffffff
cmn r1, r9
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
ldr r0, =0x1e5e550a
ldr r1, =0x00000021
ldr r2, =0x7ba66466
ldr r3, =0x000000ff
ldr r4, =0x000000ff
ldr r5, =0x0fce33ea
ldr r6, =0x00015374
ldr r7, =0x5e7e2ab8
ldr r8, =0x000000ff
ldr r9, =0x00000000
ldr r10, =0x447d735f
ldr r11, =0x00000021
ldr r12, =0x1543d4a3
ldr r14, =0x0228a260
tst r9, r3
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
ldr r0, =0x00000001
ldr r1, =0x80000001
ldr r2, =0xffffffff
ldr r3, =0xdd565f96
ldr r4, =0x0000001f
ldr r5, =0x80000000
ldr r6, =0x4b3e0bed
ldr r7, =0xeef54d59
ldr r8, =0x00000001
ldr r9, =0x0000ffff
ldr r10, =0x00000100
ldr r11, =0x80000000
ldr r12, =0x0000ffff
ldr r14, =0x80000001
teq r6, r1
bleq 1f
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
ldr r0, =0x7ffffffe
ldr r1, =0x9c85e9f3
ldr r2, =0x0000ffff
ldr r3, =0x7ffffffe
ldr r4, =0x12345678
ldr r5, =0xfd4d0f62
ldr r6, =0x195b65a7
ldr r7, =0x7fc7346e
ldr r8, =0x00000020
ldr r9, =0x278441f3
ldr r10, =0xffffffff
ldr r11, =0xb78da888
ldr r12, =0xffffffff
ldr r14, =0xdae9b90f
cmp r2, r7
blne 1f
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
ldr r0, =0x027f67bc
ldr r1, =0x00000100
ldr r2, =0x12345678
ldr r3, =0x97d7012c
ldr r4, =0x304769c3
ldr r5, =0x6e8ecfa3
ldr r6, =0x65b13e7e
ldr r7, =0xffffffff
ldr r8, =0x0afaa31f
ldr r9, =0x996cd024
ldr r10, =0xb36f4309
ldr r11, =0x00000101
ldr r12, =0x12345678
ldr r14, =0x5b22f41f
cmp r14, r4
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvc 2f
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
ldr r0, =0x00000002
ldr r1, =0xf9333f22
ldr r2, =0x00000020
ldr r3, =0x0000ffff
ldr r4, =0x0000ffff
ldr r5, =0x0000ffff
ldr r6, =0x6e8712ac
ldr r7, =0x80000000
ldr r8, =0x00000021
ldr r9, =0x64c8f31c
ldr r10, =0xf95335a6
ldr r11, =0x93d6de65
ldr r12, =0xd535a599
ldr r14, =0x80000000
cmp r4, r0
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvc 2f
add r1, r1, #7
2:
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
ldr r1, =0xcafebabe
ldr r2, =0x2ccc4682
ldr r3, =0xfddf283e
ldr r4, =0x00000101
ldr r5, =0x8e104428
ldr r6, =0xe982e891
ldr r7, =0xcafebabe
ldr r8, =0xa1016ac1
ldr r9, =0x80000000
ldr r10, =0x4f07b0db
ldr r11, =0x322e7688
ldr r12, =0x000000ff
ldr r14, =0x000000ff
cmp r7, r2
bl 1f
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
