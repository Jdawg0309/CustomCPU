.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x819f44ed
str r0, [r12, #0]
ldr r0, =0x00000021
str r0, [r12, #4]
ldr r0, =0x57760d26
str r0, [r12, #8]
ldr r0, =0x5e2b8974
str r0, [r12, #12]
ldr r0, =0x80899205
str r0, [r12, #16]
ldr r0, =0x00000020
str r0, [r12, #20]
ldr r0, =0x000000ff
str r0, [r12, #24]
ldr r0, =0x80000000
str r0, [r12, #28]
ldr r0, =0x12345678
str r0, [r12, #32]
ldr r0, =0xaf1eae55
str r0, [r12, #36]
ldr r0, =0x8df4f3b8
str r0, [r12, #40]
ldr r0, =0x00000100
str r0, [r12, #44]
ldr r0, =0x00000001
str r0, [r12, #48]
ldr r0, =0x7ffffffe
str r0, [r12, #52]
ldr r0, =0x00000001
str r0, [r12, #56]
ldr r0, =0xb1abf00e
str r0, [r12, #60]
ldr r0, =0xdca98bd3
ldr r1, =0x3a4d0457
ldr r2, =0x7fffffff
ldr r3, =0xbb06566a
ldr r4, =0x99a34559
ldr r5, =0x8e195ced
ldr r6, =0xffffffff
ldr r7, =0xcafebabe
ldr r8, =0x00000020
ldr r9, =0x80000001
ldr r10, =0x7ffffffe
ldr r11, =0x0000ffff
ldr r12, =0x7ffffffe
ldr r14, =0x000000ff
tst r0, r9
adr r3, 1f
movgt pc, r3
add r0, r0, #1
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
ldr r0, =0xac389f3a
ldr r1, =0x1726b6da
ldr r2, =0x2e9a9300
ldr r3, =0x12345678
ldr r4, =0x00000000
ldr r5, =0x0000001f
ldr r6, =0x4eee67a3
ldr r7, =0x00000000
ldr r8, =0x12345678
ldr r9, =0x7ffffffe
ldr r10, =0x044c61cc
ldr r11, =0x00000020
ldr r12, =0x7fffffff
ldr r14, =0xbf224110
cmp r12, r7
add r6, pc, #52
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
ldr r0, =0x80000001
ldr r1, =0x0000ffff
ldr r2, =0x3bb4ded0
ldr r3, =0x00000000
ldr r4, =0xd84d2b3a
ldr r5, =0x80000001
ldr r6, =0x9c8b22a5
ldr r7, =0x187bef76
ldr r8, =0xa9175b88
ldr r9, =0x00000100
ldr r10, =0x0000ffff
ldr r11, =0xfff80341
ldr r12, =0x78e941ce
ldr r14, =0x00000100
tst r2, r3
addcs pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x64dd18fc
ldr r1, =0xcafebabe
ldr r2, =0xe1ab7020
ldr r3, =0xaa5969e5
ldr r4, =0x00000000
ldr r5, =0x00000100
ldr r6, =0x1922679f
ldr r7, =0x86afc2dd
ldr r8, =0xb9b9b5fc
ldr r9, =0x3b1b987e
ldr r10, =0x00000100
ldr r11, =0x00000020
ldr r12, =0x22797803
ldr r14, =0x03ff21be
cmn r9, r0
ldrb r4, [pc, #-7]
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
ldr r0, =0xf31afecd
ldr r1, =0x4ffff28f
ldr r2, =0x7e5c98cb
ldr r3, =0x00000000
ldr r4, =0x00000001
ldr r5, =0xe8167b88
ldr r6, =0x341c8890
ldr r7, =0x00000101
ldr r8, =0x14eaca06
ldr r9, =0xe3d4dd96
ldr r10, =0xf5637bfb
ldr r11, =0x12345678
ldr r12, =0x00000000
ldr r14, =0x8b49c40e
cmn r2, r12
ldr pc, =1f
add r0, r0, #3
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
ldr r0, =0xad917a9f
ldr r1, =0x00000001
ldr r2, =0xc895b1c6
ldr r3, =0x12345678
ldr r4, =0x80000001
ldr r5, =0x7ffffffe
ldr r6, =0xc31242a3
ldr r7, =0x0000ffff
ldr r8, =0x08e54dd5
ldr r9, =0x0000001f
ldr r10, =0x80000001
ldr r11, =0x2418a93c
ldr r12, =0x80000001
ldr r14, =0x0000001f
tst r5, r12
cmp pc, r1
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
ldr r0, =0xffffffff
ldr r1, =0x12345678
ldr r2, =0x80000000
ldr r3, =0xa494ae5a
ldr r4, =0xa3793b11
ldr r5, =0x6e89c4c7
ldr r6, =0xffffffff
ldr r7, =0x12345678
ldr r8, =0x7fffffff
ldr r9, =0x7fffffff
ldr r10, =0xa3768e7f
ldr r11, =0x67b68aa4
ldr r12, =0x00000002
ldr r14, =0x59bf6638
teq r9, r0
mov r6, pc
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
ldr r0, =0x692a3b1f
ldr r1, =0xdcd3796c
ldr r2, =0x8a6e26bc
ldr r3, =0x7ffffffe
ldr r4, =0x0000001f
ldr r5, =0x242c316f
ldr r6, =0x00000001
ldr r7, =0x0000ffff
ldr r8, =0xe1dfbf5d
ldr r9, =0xcafebabe
ldr r10, =0x8eaae98e
ldr r11, =0xefd99283
ldr r12, =0x80000000
ldr r14, =0xcafebabe
tst r0, r5
ldr pc, =1f
add r0, r0, #3
1:
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
