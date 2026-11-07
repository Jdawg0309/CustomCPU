.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000100
str r0, [r12, #0]
ldr r0, =0xcafebabe
str r0, [r12, #4]
ldr r0, =0x00000101
str r0, [r12, #8]
ldr r0, =0x00000020
str r0, [r12, #12]
ldr r0, =0x51a41aa3
str r0, [r12, #16]
ldr r0, =0x4faa2b34
str r0, [r12, #20]
ldr r0, =0x403294c7
str r0, [r12, #24]
ldr r0, =0x0ca0fead
str r0, [r12, #28]
ldr r0, =0xb51943e5
str r0, [r12, #32]
ldr r0, =0xaf62d8f9
str r0, [r12, #36]
ldr r0, =0x3e9e08ff
str r0, [r12, #40]
ldr r0, =0x7ffffffe
str r0, [r12, #44]
ldr r0, =0x0000ffff
str r0, [r12, #48]
ldr r0, =0x0507f13f
str r0, [r12, #52]
ldr r0, =0x60461b81
str r0, [r12, #56]
ldr r0, =0xe75527bf
str r0, [r12, #60]
ldr r0, =0x00000101
ldr r1, =0x0000ffff
ldr r2, =0xcd1ef84b
ldr r3, =0x0e39123a
ldr r4, =0x08831489
ldr r5, =0x12345678
ldr r6, =0x00000101
ldr r7, =0xec624e4c
ldr r8, =0x0000ffff
ldr r9, =0x00000101
ldr r10, =0x12345678
ldr r11, =0x80000001
ldr r12, =0x98fde4ff
ldr r14, =0x5b5f0da2
tst r14, r2
ldr r2, [pc, #-8]
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
ldr r0, =0x80000000
ldr r1, =0x0000ffff
ldr r2, =0x00000001
ldr r3, =0xa2e47eee
ldr r4, =0x8011f537
ldr r5, =0x1aa2f2fb
ldr r6, =0x00000002
ldr r7, =0x00000020
ldr r8, =0x00000020
ldr r9, =0x7a62535e
ldr r10, =0xe0548c31
ldr r11, =0x0000001f
ldr r12, =0xde3c1a20
ldr r14, =0x80000000
tst r6, r9
addle pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x000000ff
ldr r1, =0x00000100
ldr r2, =0x00000101
ldr r3, =0x7ffffffe
ldr r4, =0x40475463
ldr r5, =0x1c14ad78
ldr r6, =0x80000001
ldr r7, =0xc1e449b7
ldr r8, =0x7b1955fe
ldr r9, =0xdc11dd60
ldr r10, =0x50dc0daf
ldr r11, =0x5f44a179
ldr r12, =0x7fffffff
ldr r14, =0xcafebabe
cmp r0, r6
ldr r1, [pc, #-8]
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
ldr r0, =0x28a5f908
ldr r1, =0x80000000
ldr r2, =0xffffffff
ldr r3, =0xffffffff
ldr r4, =0x0000ffff
ldr r5, =0x0420ea8b
ldr r6, =0x00000002
ldr r7, =0xaefc88ed
ldr r8, =0x9f6dd2f9
ldr r9, =0x4d8c5a04
ldr r10, =0xb71d4fee
ldr r11, =0x12345678
ldr r12, =0xc6159a7f
ldr r14, =0x00000100
cmn r8, r4
addgt pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r1, =0x0000ffff
ldr r2, =0xc175f50a
ldr r3, =0x00000101
ldr r4, =0x0000001f
ldr r5, =0x0000ffff
ldr r6, =0x07d3287c
ldr r7, =0xf1d69382
ldr r8, =0x60ecc647
ldr r9, =0xdbb3033b
ldr r10, =0xcfb9b11a
ldr r11, =0x7ffffffe
ldr r12, =0x00000101
ldr r14, =0x27de7955
tst r9, r10
ldrb r5, [pc, #-7]
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
ldr r0, =0x0000ffff
ldr r1, =0x18662e73
ldr r2, =0x00000001
ldr r3, =0x79ff92d0
ldr r4, =0x00000002
ldr r5, =0x000000ff
ldr r6, =0xcafebabe
ldr r7, =0x0000001f
ldr r8, =0x00000020
ldr r9, =0x0000ffff
ldr r10, =0x59e364a1
ldr r11, =0x80000000
ldr r12, =0xffffffff
ldr r14, =0xe270261d
teq r14, r10
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
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
ldr r0, =0xf5e35be5
ldr r1, =0x1e9b03bd
ldr r2, =0xffffffff
ldr r3, =0x02932113
ldr r4, =0xffffffff
ldr r5, =0x00000001
ldr r6, =0x0e9c0957
ldr r7, =0x0000001f
ldr r8, =0x8142edcc
ldr r9, =0x00000020
ldr r10, =0x0000ffff
ldr r11, =0x0000ffff
ldr r12, =0x02f13dd7
ldr r14, =0x563db39d
teq r1, r9
addge pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r1, =0x00000000
ldr r2, =0xa664837f
ldr r3, =0x0da210a7
ldr r4, =0x00000100
ldr r5, =0xa9ca3bb7
ldr r6, =0x00000020
ldr r7, =0x000000ff
ldr r8, =0xd2a0094f
ldr r9, =0xf51fa4e4
ldr r10, =0x80000001
ldr r11, =0x7fffffff
ldr r12, =0x7fffffff
ldr r14, =0x00000001
teq r4, r10
adr r3, 1f
mov pc, r3
add r0, r0, #1
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
