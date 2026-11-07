.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xbed75440
str r0, [r12, #0]
ldr r0, =0x2e0de4cf
str r0, [r12, #4]
ldr r0, =0x80000000
str r0, [r12, #8]
ldr r0, =0xcafebabe
str r0, [r12, #12]
ldr r0, =0x882a6fc8
str r0, [r12, #16]
ldr r0, =0x12345678
str r0, [r12, #20]
ldr r0, =0xf3a7ec43
str r0, [r12, #24]
ldr r0, =0x80000000
str r0, [r12, #28]
ldr r0, =0x938d38b1
str r0, [r12, #32]
ldr r0, =0xffffffff
str r0, [r12, #36]
ldr r0, =0x00000021
str r0, [r12, #40]
ldr r0, =0x00000000
str r0, [r12, #44]
ldr r0, =0x80000001
str r0, [r12, #48]
ldr r0, =0x00000100
str r0, [r12, #52]
ldr r0, =0x0000ffff
str r0, [r12, #56]
ldr r0, =0x80000000
str r0, [r12, #60]
ldr r0, =0x3fd949cb
ldr r1, =0xadf43b1f
ldr r2, =0x7a2a3db8
ldr r3, =0x798663de
ldr r4, =0x4ab04c86
ldr r5, =0x000000ff
ldr r6, =0x80000001
ldr r7, =0x000000ff
ldr r8, =0xc7276d53
ldr r9, =0x451bd0e7
ldr r10, =0xa9469201
ldr r11, =0x12345678
ldr r12, =0xe77aecfb
ldr r14, =0x0a919d37
cmn r6, r7
adds r6, pc, r7
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
ldr r0, =0x2fd7a708
ldr r1, =0x00000000
ldr r2, =0xc1a2fab6
ldr r3, =0x00000021
ldr r4, =0xc8eee8cb
ldr r5, =0x33e88d74
ldr r6, =0xab04fae1
ldr r7, =0x00000000
ldr r8, =0xfd0766cc
ldr r9, =0x00000000
ldr r10, =0x7fffffff
ldr r11, =0x00000100
ldr r12, =0x12345678
ldr r14, =0x7c564d11
tst r9, r4
ldr r5, [pc, #-8]
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
ldr r0, =0x5e37b163
ldr r1, =0x0000ffff
ldr r2, =0x80000001
ldr r3, =0x00000020
ldr r4, =0xd8c24593
ldr r5, =0xcafebabe
ldr r6, =0x36a64d5a
ldr r7, =0xddaf9eb2
ldr r8, =0x00000002
ldr r9, =0xffffffff
ldr r10, =0xb15a759a
ldr r11, =0x36c87ef1
ldr r12, =0x00000000
ldr r14, =0x527da305
cmn r7, r0
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
1:
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
ldr r0, =0x3cbcf16b
ldr r1, =0x00000002
ldr r2, =0x76ad6ee3
ldr r3, =0x7bb3d462
ldr r4, =0x4af1b13e
ldr r5, =0x000000ff
ldr r6, =0x0000001f
ldr r7, =0x76674b11
ldr r8, =0x00000000
ldr r9, =0xba274c66
ldr r10, =0x00000000
ldr r11, =0x0000ffff
ldr r12, =0xffffffff
ldr r14, =0x48114433
teq r3, r9
ldr pc, =1f
add r0, r0, #3
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
ldr r0, =0x7fffffff
ldr r1, =0xc15b58c5
ldr r2, =0x80000000
ldr r3, =0xffffffff
ldr r4, =0x80000000
ldr r5, =0xd01484b5
ldr r6, =0xcc33f84e
ldr r7, =0x00000101
ldr r8, =0xbfbb7ebf
ldr r9, =0x00000002
ldr r10, =0x7fffffff
ldr r11, =0x9eb27b2e
ldr r12, =0x7ffffffe
ldr r14, =0x00000002
cmp r0, r10
ldr r7, [pc, #-8]
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
ldr r0, =0xda6e7b00
ldr r1, =0x38148a01
ldr r2, =0x0000ffff
ldr r3, =0x000000ff
ldr r4, =0x73e1ca2d
ldr r5, =0xe649af71
ldr r6, =0x000000ff
ldr r7, =0xe69ec12c
ldr r8, =0x0000ffff
ldr r9, =0xf07402e9
ldr r10, =0xbc82d0f2
ldr r11, =0xba7d5bb7
ldr r12, =0x0000ffff
ldr r14, =0x00000020
cmn r8, r1
ldr r4, [pc, #4]
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
ldr r0, =0x00000101
ldr r1, =0x00000021
ldr r2, =0xd14bfaf3
ldr r3, =0x00000101
ldr r4, =0x00000000
ldr r5, =0x940ac653
ldr r6, =0x8ecaceb8
ldr r7, =0x6e6c5ef4
ldr r8, =0x7fffffff
ldr r9, =0x80000000
ldr r10, =0x0000ffff
ldr r11, =0x0000001f
ldr r12, =0x00000001
ldr r14, =0x250f2aae
tst r4, r7
ldr pc, =1f
add r0, r0, #3
1:
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
ldr r1, =0x775779ea
ldr r2, =0x80000000
ldr r3, =0x00000002
ldr r4, =0x00000002
ldr r5, =0x0000001f
ldr r6, =0x09ac1f7a
ldr r7, =0xfa0e59fa
ldr r8, =0xffffffff
ldr r9, =0x0000ffff
ldr r10, =0x00000001
ldr r11, =0xe85cd757
ldr r12, =0x909e859d
ldr r14, =0x00000000
cmn r12, r7
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
