.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000101
str r0, [r12, #0]
ldr r0, =0x1940779e
str r0, [r12, #4]
ldr r0, =0xe7849c0f
str r0, [r12, #8]
ldr r0, =0xa850e0ff
str r0, [r12, #12]
ldr r0, =0xfd926bfd
str r0, [r12, #16]
ldr r0, =0x40134607
str r0, [r12, #20]
ldr r0, =0x7ffffffe
str r0, [r12, #24]
ldr r0, =0x00000100
str r0, [r12, #28]
ldr r0, =0xffffffff
str r0, [r12, #32]
ldr r0, =0x00000100
str r0, [r12, #36]
ldr r0, =0x4dfc048e
str r0, [r12, #40]
ldr r0, =0x8f4b13d0
str r0, [r12, #44]
ldr r0, =0xd20bf8b2
str r0, [r12, #48]
ldr r0, =0x00000021
str r0, [r12, #52]
ldr r0, =0x7fffffff
str r0, [r12, #56]
ldr r0, =0x00000002
str r0, [r12, #60]
ldr r0, =0xb0b7e572
ldr r1, =0x0000001f
ldr r2, =0x0000001f
ldr r3, =0x31204efb
ldr r4, =0x12345678
ldr r5, =0x0000ffff
ldr r6, =0x7fffffff
ldr r7, =0x4ae32549
ldr r8, =0x7fffffff
ldr r9, =0x0000001f
ldr r10, =0x00000100
ldr r11, =0x4365ae75
ldr r12, =0x7ffffffe
ldr r14, =0x6db2de35
cmp r10, r8
ldr pc, =1f
add r0, r0, #3
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
ldr r0, =0x00000001
ldr r1, =0xd15e78b8
ldr r2, =0x41444df3
ldr r3, =0x0fa69f37
ldr r4, =0x3fadc9ee
ldr r5, =0x00000001
ldr r6, =0xf614c2f5
ldr r7, =0xd8d0df19
ldr r8, =0x0efa6d7b
ldr r9, =0xc740d934
ldr r10, =0x80000000
ldr r11, =0x0000001f
ldr r12, =0x0000001f
ldr r14, =0x00000000
cmp r0, r1
addpl pc, pc, #0
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
ldr r0, =0xffffffff
ldr r1, =0x00000021
ldr r2, =0x0000001f
ldr r3, =0x0000001f
ldr r4, =0x3a954651
ldr r5, =0x596a7030
ldr r6, =0xda9bedfb
ldr r7, =0x00000020
ldr r8, =0x00000101
ldr r9, =0x6698060f
ldr r10, =0xd37c7132
ldr r11, =0xae776ae5
ldr r12, =0x53d0deb2
ldr r14, =0x7fffffff
cmp r2, r3
ldrb r6, [pc, #-7]
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
ldr r0, =0x4a420ddd
ldr r1, =0x00000101
ldr r2, =0x80000000
ldr r3, =0xffffffff
ldr r4, =0xcafebabe
ldr r5, =0x2807bda9
ldr r6, =0x00000100
ldr r7, =0x00000101
ldr r8, =0x1b5ff606
ldr r9, =0x7ffffffe
ldr r10, =0x00000021
ldr r11, =0x8d13c275
ldr r12, =0xdcb2076b
ldr r14, =0xb5e565cf
cmp r9, r11
adr r3, 1f
movpl pc, r3
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
ldr r0, =0x731c4292
ldr r1, =0x80000000
ldr r2, =0x00000020
ldr r3, =0x0499f736
ldr r4, =0x0438eb42
ldr r5, =0x0000ffff
ldr r6, =0x791ab4c7
ldr r7, =0x00000021
ldr r8, =0xcafebabe
ldr r9, =0x46c5b087
ldr r10, =0xffffffff
ldr r11, =0xb17ebb34
ldr r12, =0x5f55d7ba
ldr r14, =0x9276f061
cmn r5, r9
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
ldr r0, =0x00000001
ldr r1, =0x05b4171b
ldr r2, =0x0fb9a17e
ldr r3, =0x46467dfa
ldr r4, =0x80000001
ldr r5, =0x00000021
ldr r6, =0x9591d021
ldr r7, =0x00000021
ldr r8, =0x00000000
ldr r9, =0x967890b9
ldr r10, =0x70914ead
ldr r11, =0x15e99fd1
ldr r12, =0x7147a176
ldr r14, =0x000000ff
tst r8, r5
adr r3, 1f
mov pc, r3
add r0, r0, #1
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
ldr r0, =0x3d96be06
ldr r1, =0xc80045b1
ldr r2, =0xce4c6c11
ldr r3, =0xcb1bf818
ldr r4, =0xe19a34dc
ldr r5, =0x00000021
ldr r6, =0x00000000
ldr r7, =0xfecda2fd
ldr r8, =0x7ffffffe
ldr r9, =0xf4bf85c8
ldr r10, =0x88f80a0a
ldr r11, =0x7fffffff
ldr r12, =0xd52d1e66
ldr r14, =0x10f0419c
teq r0, r1
ldr r10, =0x1120
adr r3, 1f
str r3, [r10, #4]
ldmia r10, {r4, pc}
add r0, r0, #7
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
ldr r0, =0xc3e54b19
ldr r1, =0xffffffff
ldr r2, =0x7fffffff
ldr r3, =0x000000ff
ldr r4, =0x0000ffff
ldr r5, =0xdbff5b4d
ldr r6, =0x00000001
ldr r7, =0x767e3673
ldr r8, =0x00000020
ldr r9, =0x7fffffff
ldr r10, =0x2e45eef3
ldr r11, =0x5062d893
ldr r12, =0xfc929663
ldr r14, =0x7ffffffe
cmn r10, r8
adds r7, pc, r5
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
