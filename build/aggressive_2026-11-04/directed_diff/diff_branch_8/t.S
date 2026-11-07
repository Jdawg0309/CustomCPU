.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xf23a0cef
str r0, [r12, #0]
ldr r0, =0x00000000
str r0, [r12, #4]
ldr r0, =0x00000000
str r0, [r12, #8]
ldr r0, =0x000000ff
str r0, [r12, #12]
ldr r0, =0x598fe427
str r0, [r12, #16]
ldr r0, =0x000000ff
str r0, [r12, #20]
ldr r0, =0x00000020
str r0, [r12, #24]
ldr r0, =0x080f55d8
str r0, [r12, #28]
ldr r0, =0x9ada6a6d
str r0, [r12, #32]
ldr r0, =0x00000001
str r0, [r12, #36]
ldr r0, =0x80000001
str r0, [r12, #40]
ldr r0, =0xb68f544c
str r0, [r12, #44]
ldr r0, =0x7ffffffe
str r0, [r12, #48]
ldr r0, =0x00000000
str r0, [r12, #52]
ldr r0, =0x2932efc6
str r0, [r12, #56]
ldr r0, =0xc7c65d1c
str r0, [r12, #60]
ldr r0, =0x00000001
ldr r1, =0x0000001f
ldr r2, =0x12345678
ldr r3, =0x00000000
ldr r4, =0xb50e699d
ldr r5, =0x0000ffff
ldr r6, =0x95375ca8
ldr r7, =0x00000020
ldr r8, =0x9de9967b
ldr r9, =0x00000101
ldr r10, =0x83d2ddfb
ldr r11, =0x00000000
ldr r12, =0x00000021
ldr r14, =0x0000001f
tst r7, r14
blhi 1f
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
ldr r0, =0x00000100
ldr r1, =0x00000020
ldr r2, =0x00000001
ldr r3, =0x00000100
ldr r4, =0x32d90e56
ldr r5, =0x0000001f
ldr r6, =0xcafebabe
ldr r7, =0x00000101
ldr r8, =0xcafebabe
ldr r9, =0x00000001
ldr r10, =0xc2b02763
ldr r11, =0x79a01f24
ldr r12, =0x00000000
ldr r14, =0xc65d5843
cmp r2, r11
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bls 2f
add r1, r1, #7
2:
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
ldr r0, =0xf0770552
ldr r1, =0xd1f5f992
ldr r2, =0x80000001
ldr r3, =0x5b31e0b3
ldr r4, =0xffffffff
ldr r5, =0x0000001f
ldr r6, =0x57bae669
ldr r7, =0x00000002
ldr r8, =0x0000001f
ldr r9, =0x00000020
ldr r10, =0x62c03cb5
ldr r11, =0x8aaedaa8
ldr r12, =0x00000101
ldr r14, =0xcafebabe
cmn r4, r1
bl 1f
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
ldr r0, =0x0000001f
ldr r1, =0xdb2c6de9
ldr r2, =0x97cdd656
ldr r3, =0x04716b0e
ldr r4, =0x76a84925
ldr r5, =0x1b287431
ldr r6, =0xfba2ae4a
ldr r7, =0x00000020
ldr r8, =0x0000001f
ldr r9, =0xcafebabe
ldr r10, =0x00000000
ldr r11, =0x0000001f
ldr r12, =0x19be58e2
ldr r14, =0x420ee7d2
cmn r12, r11
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
ldr r0, =0xcafebabe
ldr r1, =0xfddd6a0a
ldr r2, =0x008f810e
ldr r3, =0xdeef9820
ldr r4, =0xa72688c4
ldr r5, =0x12345678
ldr r6, =0x38e498f5
ldr r7, =0xffffffff
ldr r8, =0x02b238b5
ldr r9, =0x06d28096
ldr r10, =0x00000101
ldr r11, =0x00000100
ldr r12, =0x7fffffff
ldr r14, =0x309a67cf
teq r5, r14
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
ldr r0, =0x7fffffff
ldr r1, =0x00000000
ldr r2, =0x7fffffff
ldr r3, =0x80000000
ldr r4, =0xf2ca4876
ldr r5, =0x0af3e110
ldr r6, =0x7fffffff
ldr r7, =0x00000002
ldr r8, =0x00000101
ldr r9, =0xc17a7660
ldr r10, =0x993f0095
ldr r11, =0xcafebabe
ldr r12, =0x2ace6468
ldr r14, =0x8d2d9421
tst r0, r4
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvs 2f
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
ldr r0, =0xd99a3d77
ldr r1, =0x00000001
ldr r2, =0x00000101
ldr r3, =0xf2913a64
ldr r4, =0x000000ff
ldr r5, =0x6289a802
ldr r6, =0xed5ac94d
ldr r7, =0x00000101
ldr r8, =0x7ffffffe
ldr r9, =0x1414061c
ldr r10, =0xcaeef8e0
ldr r11, =0x3329b75d
ldr r12, =0x0000001f
ldr r14, =0x41d5771b
cmn r4, r7
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
ldr r0, =0x00000101
ldr r1, =0xea1d5166
ldr r2, =0xcafebabe
ldr r3, =0xb1baeb0a
ldr r4, =0x8a59f04a
ldr r5, =0x00000001
ldr r6, =0x00308c46
ldr r7, =0x7d641c44
ldr r8, =0xf83225c3
ldr r9, =0xfafb28b0
ldr r10, =0x00000000
ldr r11, =0x5df50c1c
ldr r12, =0xb5e6271b
ldr r14, =0xc35a56a1
teq r5, r1
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
