.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xc101c7cf
str r0, [r12, #0]
ldr r0, =0xe817292a
str r0, [r12, #4]
ldr r0, =0x12345678
str r0, [r12, #8]
ldr r0, =0x00000002
str r0, [r12, #12]
ldr r0, =0x03b144f2
str r0, [r12, #16]
ldr r0, =0x00000100
str r0, [r12, #20]
ldr r0, =0x00000101
str r0, [r12, #24]
ldr r0, =0x0000ffff
str r0, [r12, #28]
ldr r0, =0xcafebabe
str r0, [r12, #32]
ldr r0, =0x00000000
str r0, [r12, #36]
ldr r0, =0x0000001f
str r0, [r12, #40]
ldr r0, =0x7ffffffe
str r0, [r12, #44]
ldr r0, =0x0000001f
str r0, [r12, #48]
ldr r0, =0x0000001f
str r0, [r12, #52]
ldr r0, =0x000000ff
str r0, [r12, #56]
ldr r0, =0x7fffffff
str r0, [r12, #60]
ldr r0, =0x0000ffff
ldr r1, =0x7fffffff
ldr r2, =0x000000ff
ldr r3, =0x4347cc6f
ldr r4, =0x000000ff
ldr r5, =0x05d70a5e
ldr r6, =0xbc47a09f
ldr r7, =0x00000100
ldr r8, =0x00000020
ldr r9, =0x00000101
ldr r10, =0x000000ff
ldr r11, =0x80000000
ldr r12, =0x02d967a3
ldr r14, =0xa4c40b23
teq r10, r3
ldr r10, =0x1120
stmib r10, {r1,r3,r9,r12}
ldr r10, =0x1120
ldmda r10, {r5,r6,r9}
ldr r10, =0x1120
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
ldr r0, =0x0000ffff
ldr r1, =0x00000100
ldr r2, =0x16ae4b7a
ldr r3, =0xdf421bf6
ldr r4, =0x00000002
ldr r5, =0x00000100
ldr r6, =0x0000001f
ldr r7, =0x80000000
ldr r8, =0x7ffffffe
ldr r9, =0xcafebabe
ldr r10, =0xc152bd5e
ldr r11, =0x0000001f
ldr r12, =0x00000021
ldr r14, =0x373c740d
teq r6, r1
ldr r10, =0x1120
ldmia r10, {r8,r11,lr}
ldr r10, =0x1120
stmib r10!, {r6,r7,lr}
ldr r10, =0x1120
stmdb r10, {r1,r4,lr}
ldr r10, =0x1120
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
ldr r0, =0xab05f3d0
ldr r1, =0x80000000
ldr r2, =0xb079d4ec
ldr r3, =0x00000000
ldr r4, =0xacdb386b
ldr r5, =0x12345678
ldr r6, =0xc6880047
ldr r7, =0xab89fbeb
ldr r8, =0x00000000
ldr r9, =0x12345678
ldr r10, =0x2f00f01a
ldr r11, =0x00000021
ldr r12, =0xcfa2b080
ldr r14, =0x158e733c
teq r0, r2
ldr r10, =0x1120
stmdb r10!, {r0,r5,r6,r7,r9}
ldr r10, =0x1120
stmib r10, {r5,r6,r8,r12}
ldr r10, =0x1120
stmdb r10, {r0,r4,r9,r11,r12}
ldr r10, =0x1120
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
ldr r0, =0x7fffffff
ldr r1, =0xffffffff
ldr r2, =0x284b409d
ldr r3, =0xc83712a7
ldr r4, =0x00000002
ldr r5, =0x81c5957a
ldr r6, =0x56c16062
ldr r7, =0x00000000
ldr r8, =0x00000100
ldr r9, =0x72acdcbd
ldr r10, =0x7fffffff
ldr r11, =0x2fe92097
ldr r12, =0x7fcd02a1
ldr r14, =0x9306930f
cmn r11, r1
ldr r10, =0x1120
ldmdb r10!, {r6,lr}
ldr r10, =0x1120
stmia r10!, {r1,r2,r4,r12,lr}
ldr r10, =0x1120
stmda r10, {r2,r7,lr}
ldr r10, =0x1120
stmib r10, {r5,r9,r11}
ldr r10, =0x1120
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
ldr r1, =0x00000101
ldr r2, =0x7ffffffe
ldr r3, =0xcafebabe
ldr r4, =0xd5bf55be
ldr r5, =0x0000001f
ldr r6, =0x37cc5231
ldr r7, =0x00000101
ldr r8, =0x00658ff7
ldr r9, =0x00000101
ldr r10, =0x7e4312a0
ldr r11, =0xcafebabe
ldr r12, =0x7ffffffe
ldr r14, =0x00000020
tst r8, r3
ldr r10, =0x1120
ldmdb r10, {r1,r3,r4,lr}
ldr r10, =0x1120
ldmdb r10, {r0,r2,r3,r7,lr}
ldr r10, =0x1120
ldmia r10!, {r0,r1,r2,r6,r12}
ldr r10, =0x1120
stmda r10, {r0,r12,lr}
ldr r10, =0x1120
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
ldr r0, =0x7ffffffe
ldr r1, =0x8c9c7f2f
ldr r2, =0x0ee21987
ldr r3, =0x93b60ade
ldr r4, =0xd72184c2
ldr r5, =0x404a9ff1
ldr r6, =0x9050eaee
ldr r7, =0x221cabca
ldr r8, =0xc43ed67f
ldr r9, =0x15032509
ldr r10, =0x00000020
ldr r11, =0x00000020
ldr r12, =0x16e0b96d
ldr r14, =0x00000020
teq r12, r11
ldr r10, =0x1120
ldmib r10!, {r0,r2}
ldr r10, =0x1120
stmdbpl r10!, {r4,r8,r9,r12}
ldr r10, =0x1120
ldmib r10!, {r1,r7}
ldr r10, =0x1120
stmdb r10!, {r1,r6,r8}
ldr r10, =0x1120
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
ldr r0, =0x77229611
ldr r1, =0x000000ff
ldr r2, =0x00000001
ldr r3, =0x00000020
ldr r4, =0x0eda85eb
ldr r5, =0x80000000
ldr r6, =0x0000001f
ldr r7, =0x15db3203
ldr r8, =0x7fffffff
ldr r9, =0x4e53faa2
ldr r10, =0x3d9a47a5
ldr r11, =0x90edbc9c
ldr r12, =0x00000000
ldr r14, =0xee793e61
teq r2, r9
ldr r10, =0x1120
ldmials r10, {r6}
ldr r10, =0x1120
ldmib r10, {r5,r6,r12}
ldr r10, =0x1120
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
ldr r0, =0xfc9d1cdd
ldr r1, =0xf33976fa
ldr r2, =0x00000002
ldr r3, =0x75ab47a7
ldr r4, =0x0883083f
ldr r5, =0x80000000
ldr r6, =0x00000000
ldr r7, =0x00000021
ldr r8, =0x80000000
ldr r9, =0x0e7d3298
ldr r10, =0x261551f5
ldr r11, =0x80000001
ldr r12, =0x00000020
ldr r14, =0x6904772e
cmp r10, r8
ldr r10, =0x1120
ldmib r10!, {r4}
ldr r10, =0x1120
stmdbpl r10, {r1,r4,r12}
ldr r10, =0x1120
ldmia r10, {r6}
ldr r10, =0x1120
stmia r10!, {r0,r1,r4,r8,lr}
ldr r10, =0x1120
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
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
