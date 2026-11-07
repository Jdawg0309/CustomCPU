.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000002
str r0, [r12, #0]
ldr r0, =0xf61029d7
str r0, [r12, #4]
ldr r0, =0xffffffff
str r0, [r12, #8]
ldr r0, =0xbad6f8f8
str r0, [r12, #12]
ldr r0, =0x2a70b127
str r0, [r12, #16]
ldr r0, =0x27092506
str r0, [r12, #20]
ldr r0, =0x12345678
str r0, [r12, #24]
ldr r0, =0xe485920b
str r0, [r12, #28]
ldr r0, =0xf2a1f980
str r0, [r12, #32]
ldr r0, =0xb9b3fdad
str r0, [r12, #36]
ldr r0, =0x00000101
str r0, [r12, #40]
ldr r0, =0xb9853de2
str r0, [r12, #44]
ldr r0, =0xb25fc363
str r0, [r12, #48]
ldr r0, =0x12345678
str r0, [r12, #52]
ldr r0, =0xed6a09b6
str r0, [r12, #56]
ldr r0, =0x0b2970be
str r0, [r12, #60]
ldr r0, =0x00000000
ldr r1, =0x000000ff
ldr r2, =0x7efdd84e
ldr r3, =0x7fffffff
ldr r4, =0x00000101
ldr r5, =0x0000ffff
ldr r6, =0x00000021
ldr r7, =0x00000020
ldr r8, =0xc6d25f2d
ldr r9, =0x00000100
ldr r10, =0x13821f9a
ldr r11, =0x7fffffff
ldr r12, =0x000000ff
ldr r14, =0x6eacd90a
tst r9, r3
bl 1f
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
ldr r0, =0xc42ba971
ldr r1, =0x00000001
ldr r2, =0x0000001f
ldr r3, =0xcafebabe
ldr r4, =0x334675c9
ldr r5, =0x0c662141
ldr r6, =0xf07b4962
ldr r7, =0xcb68f189
ldr r8, =0x00000001
ldr r9, =0x0ea59a20
ldr r10, =0x00000100
ldr r11, =0x00000002
ldr r12, =0x0000ffff
ldr r14, =0x80000000
cmp r9, r10
bvs 1f
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
ldr r0, =0x6b8f71dc
ldr r1, =0x06438a8f
ldr r2, =0x602bebfa
ldr r3, =0x0000001f
ldr r4, =0xecb9a146
ldr r5, =0xffffffff
ldr r6, =0x0347e95a
ldr r7, =0x0000ffff
ldr r8, =0x6bee6b05
ldr r9, =0x1483524e
ldr r10, =0x48441790
ldr r11, =0x00000001
ldr r12, =0x7ffffffe
ldr r14, =0x0000ffff
tst r12, r12
blls 1f
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
ldr r1, =0xf4e1289b
ldr r2, =0x80000000
ldr r3, =0xc0b54d46
ldr r4, =0xcc300611
ldr r5, =0x17a3a087
ldr r6, =0x00000020
ldr r7, =0x4a1fb384
ldr r8, =0x00000100
ldr r9, =0xbccf9054
ldr r10, =0x7058224f
ldr r11, =0xbeab9add
ldr r12, =0x0000001f
ldr r14, =0xc792cbea
teq r12, r6
bmi 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r0, =0x07a8afa5
ldr r1, =0xa7d8dc64
ldr r2, =0x69efb0fe
ldr r3, =0x7ffffffe
ldr r4, =0x00000020
ldr r5, =0xe8576539
ldr r6, =0x946cca40
ldr r7, =0x00000002
ldr r8, =0x00000021
ldr r9, =0x7ffffffe
ldr r10, =0x12ea08e5
ldr r11, =0x00000000
ldr r12, =0x80000001
ldr r14, =0x0bbb8ba0
cmn r5, r11
blhi 1f
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
ldr r0, =0x80000001
ldr r1, =0x9d4aee75
ldr r2, =0x7a6fb490
ldr r3, =0xccfffcb4
ldr r4, =0xe3df7504
ldr r5, =0xd116181b
ldr r6, =0x5add1c70
ldr r7, =0xfec17a2e
ldr r8, =0xee274b7d
ldr r9, =0xcb873e31
ldr r10, =0x0000ffff
ldr r11, =0xf3ed6188
ldr r12, =0xffffffff
ldr r14, =0x00000000
cmp r6, r12
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bmi 2f
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
ldr r0, =0x00000021
ldr r1, =0x80000000
ldr r2, =0x7fffffff
ldr r3, =0x49c2abbb
ldr r4, =0x00000020
ldr r5, =0xd966946a
ldr r6, =0x20ac1535
ldr r7, =0x00000021
ldr r8, =0x00000000
ldr r9, =0x597b2bb5
ldr r10, =0x80000000
ldr r11, =0x00000100
ldr r12, =0xde571a64
ldr r14, =0x80000000
teq r12, r10
bl 1f
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
ldr r0, =0xcafebabe
ldr r1, =0x50ee5281
ldr r2, =0x00000002
ldr r3, =0x0493ec30
ldr r4, =0x3a3b4473
ldr r5, =0xb87905dc
ldr r6, =0x90d2c88d
ldr r7, =0x8ee1fd6c
ldr r8, =0x7ffffffe
ldr r9, =0x68da0e3f
ldr r10, =0xf9d6ea68
ldr r11, =0x00000100
ldr r12, =0x28682cdb
ldr r14, =0x77313aad
cmp r7, r0
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
