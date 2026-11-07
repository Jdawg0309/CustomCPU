.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x76511bf4
str r0, [r12, #0]
ldr r0, =0x14bde9a8
str r0, [r12, #4]
ldr r0, =0xbf274863
str r0, [r12, #8]
ldr r0, =0x0000001f
str r0, [r12, #12]
ldr r0, =0x00000100
str r0, [r12, #16]
ldr r0, =0x7ffffffe
str r0, [r12, #20]
ldr r0, =0xdd664672
str r0, [r12, #24]
ldr r0, =0x4aebb02f
str r0, [r12, #28]
ldr r0, =0x6c4461cc
str r0, [r12, #32]
ldr r0, =0xa70b8271
str r0, [r12, #36]
ldr r0, =0x7bb53a8a
str r0, [r12, #40]
ldr r0, =0x00000101
str r0, [r12, #44]
ldr r0, =0xbe6013f3
str r0, [r12, #48]
ldr r0, =0x12345678
str r0, [r12, #52]
ldr r0, =0x00000020
str r0, [r12, #56]
ldr r0, =0xb26c005f
str r0, [r12, #60]
ldr r0, =0x00000000
ldr r1, =0x2cbe2398
ldr r2, =0x938785ec
ldr r3, =0x12345678
ldr r4, =0x3d167d99
ldr r5, =0x7d728304
ldr r6, =0x3aa177fb
ldr r7, =0x00000100
ldr r8, =0xd24b5c2c
ldr r9, =0x9fbee757
ldr r10, =0xcafebabe
ldr r11, =0xffffffff
ldr r12, =0x00000020
ldr r14, =0x00000002
cmn r6, r12
ldr r10, =0x1120
ldmib r10!, {r1,r5,r7,r8,r12}
ldr r10, =0x1120
stmib r10, {r6}
ldr r10, =0x1120
ldmib r10, {r5,r11,r12}
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
ldr r0, =0xa0eb43b6
ldr r1, =0xf115a713
ldr r2, =0x00000020
ldr r3, =0x0000ffff
ldr r4, =0xe91fd56a
ldr r5, =0x80000001
ldr r6, =0x00000020
ldr r7, =0x7fffffff
ldr r8, =0xef082c49
ldr r9, =0x1fb00069
ldr r10, =0x67893428
ldr r11, =0x80000001
ldr r12, =0x243c7022
ldr r14, =0xde07e975
tst r3, r2
ldr r10, =0x1120
ldmdalt r10!, {r5,r6}
ldr r10, =0x1120
ldmia r10, {r0,r3,r4,r7,r8}
ldr r10, =0x1120
ldmia r10, {r8,r11}
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
ldr r0, =0xdebc30ff
ldr r1, =0x000000ff
ldr r2, =0x91418149
ldr r3, =0x0000001f
ldr r4, =0x00000002
ldr r5, =0xeb2d533d
ldr r6, =0xf059bf56
ldr r7, =0x0000ffff
ldr r8, =0x15146f21
ldr r9, =0x1bdf6a0c
ldr r10, =0x545d8737
ldr r11, =0xe344445f
ldr r12, =0x00000021
ldr r14, =0xd9816d81
tst r12, r5
ldr r10, =0x1120
stmia r10!, {r0,r3,r9}
ldr r10, =0x1120
stmdb r10, {r2}
ldr r10, =0x1120
stmib r10, {r1,r2,r3,r7,r11}
ldr r10, =0x1120
stmda r10, {r0,r6}
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
ldr r0, =0xbe7b5935
ldr r1, =0xc9a708f9
ldr r2, =0xda123a9b
ldr r3, =0x80000001
ldr r4, =0x00000020
ldr r5, =0x128f7bec
ldr r6, =0x9aef92c4
ldr r7, =0x0000001f
ldr r8, =0x00000020
ldr r9, =0xa64ec121
ldr r10, =0x5051ce3d
ldr r11, =0x66c2f4d8
ldr r12, =0x3d103885
ldr r14, =0x00000000
teq r14, r3
ldr r10, =0x1120
ldmdb r10!, {r2,r6,lr}
ldr r10, =0x1120
ldmdbls r10, {r7,r9}
ldr r10, =0x1120
ldmdagt r10!, {r1,r12,lr}
ldr r10, =0x1120
ldmia r10!, {r2}
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
ldr r0, =0x83fd11d3
ldr r1, =0x0ca1911d
ldr r2, =0xd7fd766e
ldr r3, =0xcafebabe
ldr r4, =0xffffffff
ldr r5, =0x80000000
ldr r6, =0x00000002
ldr r7, =0x116df1c3
ldr r8, =0x4598d470
ldr r9, =0x00000021
ldr r10, =0xd6216e70
ldr r11, =0xace75a52
ldr r12, =0x7ffffffe
ldr r14, =0x00000020
tst r0, r2
ldr r10, =0x1120
ldmia r10, {r4}
ldr r10, =0x1120
stmda r10, {r1,r12}
ldr r10, =0x1120
stmda r10!, {r6}
ldr r10, =0x1120
ldmiblt r10, {r0}
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
ldr r0, =0x12345678
ldr r1, =0xf2fa19e4
ldr r2, =0xe5a8f815
ldr r3, =0xbe49e960
ldr r4, =0xf06bc688
ldr r5, =0xe806aad9
ldr r6, =0x00000001
ldr r7, =0x01cc1b2b
ldr r8, =0xcafebabe
ldr r9, =0x21875942
ldr r10, =0xc66854bf
ldr r11, =0xd477f010
ldr r12, =0x3a98dfd8
ldr r14, =0x80000001
cmp r9, r9
ldr r10, =0x1120
ldmia r10, {r0,r4,r6,r9,lr}
ldr r10, =0x1120
stmda r10!, {r5}
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
ldr r0, =0x9147760b
ldr r1, =0x80000001
ldr r2, =0xffffffff
ldr r3, =0x00000000
ldr r4, =0x0000ffff
ldr r5, =0x7ffffffe
ldr r6, =0x0000001f
ldr r7, =0x000000ff
ldr r8, =0xcc6110a1
ldr r9, =0x00000100
ldr r10, =0xb5a47d2b
ldr r11, =0x00000001
ldr r12, =0x05e473e6
ldr r14, =0x7b474ce7
tst r12, r14
ldr r10, =0x1120
ldmib r10!, {r4}
ldr r10, =0x1120
stmda r10, {r12}
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
ldr r0, =0x0000001f
ldr r1, =0x3ce6353a
ldr r2, =0x30efff54
ldr r3, =0xf6ef1297
ldr r4, =0x7fffffff
ldr r5, =0x15dbd6e0
ldr r6, =0x00000000
ldr r7, =0x0000ffff
ldr r8, =0x9d628b57
ldr r9, =0x0000001f
ldr r10, =0x80000001
ldr r11, =0x12345678
ldr r12, =0x00000000
ldr r14, =0x7ffffffe
cmp r12, r12
ldr r10, =0x1120
stmia r10!, {r9,lr}
ldr r10, =0x1120
ldmdb r10!, {r2,r3,r6,r7,r8}
ldr r10, =0x1120
ldmda r10, {r1,r2,r6,r8,r12}
ldr r10, =0x1120
ldmda r10!, {r2,r5}
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
ldr r12,=0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
