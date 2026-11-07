.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000000
str r0, [r12, #0]
ldr r0, =0xcafebabe
str r0, [r12, #4]
ldr r0, =0x12345678
str r0, [r12, #8]
ldr r0, =0xbd35a334
str r0, [r12, #12]
ldr r0, =0x1a1c4309
str r0, [r12, #16]
ldr r0, =0x7fffffff
str r0, [r12, #20]
ldr r0, =0x00000002
str r0, [r12, #24]
ldr r0, =0xbf9fb5bc
str r0, [r12, #28]
ldr r0, =0x7ffffffe
str r0, [r12, #32]
ldr r0, =0xcb94e6e1
str r0, [r12, #36]
ldr r0, =0xe20384e5
str r0, [r12, #40]
ldr r0, =0x368358fd
str r0, [r12, #44]
ldr r0, =0x000000ff
str r0, [r12, #48]
ldr r0, =0xae248ae8
str r0, [r12, #52]
ldr r0, =0x7dc86953
str r0, [r12, #56]
ldr r0, =0x0fe4aa8a
str r0, [r12, #60]
ldr r0, =0x3e90c9b7
ldr r1, =0x0000001f
ldr r2, =0xffffffff
ldr r3, =0xcd1d1971
ldr r4, =0x731562b7
ldr r5, =0x12345678
ldr r6, =0x80000000
ldr r7, =0x00000021
ldr r8, =0xffffffff
ldr r9, =0x80000000
ldr r10, =0x000000ff
ldr r11, =0xafa15631
ldr r12, =0x67f94ee6
ldr r14, =0x7fffffff
cmp r0, r3
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
ldr r0, =0x56169948
ldr r1, =0x7fffffff
ldr r2, =0x7ffffffe
ldr r3, =0xa3386b98
ldr r4, =0xe419a6df
ldr r5, =0x80000001
ldr r6, =0x4d78fd52
ldr r7, =0xd2bfd9a5
ldr r8, =0x576b97f5
ldr r9, =0x00000001
ldr r10, =0x7fffffff
ldr r11, =0xd55dcac1
ldr r12, =0xfea682cb
ldr r14, =0x00000020
tst r7, r12
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bvc 2f
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
ldr r0, =0x7d8571c3
ldr r1, =0x0f6ebb61
ldr r2, =0x00000002
ldr r3, =0xd010c432
ldr r4, =0x80000000
ldr r5, =0x7fffffff
ldr r6, =0xe36f050c
ldr r7, =0xa80b9005
ldr r8, =0x00000002
ldr r9, =0x0000ffff
ldr r10, =0xfb83b136
ldr r11, =0x80000000
ldr r12, =0xc46de280
ldr r14, =0xffffffff
tst r2, r6
bllt 1f
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
ldr r0, =0xb6f81d5c
ldr r1, =0x542e3bb7
ldr r2, =0x80000001
ldr r3, =0x1bd750f4
ldr r4, =0x20fb1f4d
ldr r5, =0x0000001f
ldr r6, =0x00000020
ldr r7, =0xee6aca74
ldr r8, =0x16f02797
ldr r9, =0x7fffffff
ldr r10, =0x07ef8608
ldr r11, =0x7ffffffe
ldr r12, =0x1a8f35a1
ldr r14, =0xe248c0b8
tst r6, r7
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
ldr r0, =0x93250926
ldr r1, =0xaa8d9071
ldr r2, =0x0000ffff
ldr r3, =0x7fffffff
ldr r4, =0xf0fe80b0
ldr r5, =0x6d67494b
ldr r6, =0xb88be595
ldr r7, =0xd1c70b88
ldr r8, =0xa03b9842
ldr r9, =0x4191e2c6
ldr r10, =0x0c5b5969
ldr r11, =0x7fffffff
ldr r12, =0xffffffff
ldr r14, =0xdf017f8f
tst r10, r4
blt 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
ldr r1, =0x52e26cb8
ldr r2, =0x9615266d
ldr r3, =0xa5784a3e
ldr r4, =0xe27925b4
ldr r5, =0x6931bb0c
ldr r6, =0x1e1fe58b
ldr r7, =0x80000000
ldr r8, =0xc6dd387e
ldr r9, =0xacf1338c
ldr r10, =0x7ffffffe
ldr r11, =0xd59eb691
ldr r12, =0x00000100
ldr r14, =0x4ea1b66e
tst r3, r14
bhi 1f
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
ldr r0, =0x00000100
ldr r1, =0x7ffffffe
ldr r2, =0x7fffffff
ldr r3, =0x424b9f99
ldr r4, =0x7fffffff
ldr r5, =0x9e0b41ae
ldr r6, =0x955b6df2
ldr r7, =0xcc3f7837
ldr r8, =0x0000001f
ldr r9, =0xcbd628db
ldr r10, =0x80000001
ldr r11, =0xb78c2056
ldr r12, =0x00000021
ldr r14, =0x2eea1509
cmn r3, r8
blt 1f
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
ldr r0, =0x00000020
ldr r1, =0x3b278986
ldr r2, =0x80000000
ldr r3, =0x1e35e04d
ldr r4, =0x00000100
ldr r5, =0x00000101
ldr r6, =0x00000000
ldr r7, =0x4e119aaf
ldr r8, =0x526ea0ea
ldr r9, =0xb0b4ae4a
ldr r10, =0x569940b8
ldr r11, =0x7aa34d59
ldr r12, =0x7d9bc992
ldr r14, =0xd558b46e
teq r6, r11
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
