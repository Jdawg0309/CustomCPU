.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x3f7f93b4
str r0, [r12, #0]
ldr r0, =0x0000001f
str r0, [r12, #4]
ldr r0, =0x0000001f
str r0, [r12, #8]
ldr r0, =0x8580c47f
str r0, [r12, #12]
ldr r0, =0xba9627b2
str r0, [r12, #16]
ldr r0, =0xe8462c38
str r0, [r12, #20]
ldr r0, =0xb7fc004a
str r0, [r12, #24]
ldr r0, =0x0420698b
str r0, [r12, #28]
ldr r0, =0x276f1c9e
str r0, [r12, #32]
ldr r0, =0x3ba1569b
str r0, [r12, #36]
ldr r0, =0xfed56770
str r0, [r12, #40]
ldr r0, =0x00000100
str r0, [r12, #44]
ldr r0, =0xda6717b0
str r0, [r12, #48]
ldr r0, =0x27322af5
str r0, [r12, #52]
ldr r0, =0x6fc177c5
str r0, [r12, #56]
ldr r0, =0x000000ff
str r0, [r12, #60]
ldr r0, =0xef5f5d7e
ldr r1, =0x68e60df5
ldr r2, =0x627ed020
ldr r3, =0xea0b182a
ldr r4, =0x0000ffff
ldr r5, =0xe84c168b
ldr r6, =0x00000002
ldr r7, =0x00000100
ldr r8, =0x00000100
ldr r9, =0x84175363
ldr r10, =0xd88dc0ad
ldr r11, =0x7ffffffe
ldr r12, =0x5c37334e
ldr r14, =0x0000ffff
teq r6, r8
ldr r10, =0x1120
ldmdb r10, {r7,lr}
ldr r10, =0x1120
stmib r10, {r2,r4}
ldr r10, =0x1120
stmib r10, {r2,r11}
ldr r10, =0x1120
ldmdbcc r10, {r0,r2,r4,r6,lr}
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
ldr r0, =0x000000ff
ldr r1, =0x00000001
ldr r2, =0x287b9a96
ldr r3, =0x0000001f
ldr r4, =0x0000ffff
ldr r5, =0x0000ffff
ldr r6, =0x7ffffffe
ldr r7, =0xe4a2d048
ldr r8, =0x0502b1fb
ldr r9, =0x00000000
ldr r10, =0xcafebabe
ldr r11, =0x00000002
ldr r12, =0x00000021
ldr r14, =0x00000100
tst r4, r9
ldr r10, =0x1120
ldmda r10, {r1,r6,lr}
ldr r10, =0x1120
ldmia r10!, {lr}
ldr r10, =0x1120
ldmials r10!, {r3,lr}
ldr r10, =0x1120
ldmia r10!, {r1,r6,r9,lr}
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
ldr r0, =0x00000020
ldr r1, =0x4b4b5577
ldr r2, =0xd53ed149
ldr r3, =0x1341c375
ldr r4, =0x0de1b854
ldr r5, =0x017ae5d9
ldr r6, =0xebb85897
ldr r7, =0xf4f8cfc2
ldr r8, =0x0000001f
ldr r9, =0x8ba7cd77
ldr r10, =0xd2cba56b
ldr r11, =0x7ffffffe
ldr r12, =0x80000001
ldr r14, =0xb5785591
teq r14, r7
ldr r10, =0x1120
stmibpl r10, {r1,r5,r6,r7,r9}
ldr r10, =0x1120
ldmdb r10, {r2,r8,r9,r11}
ldr r10, =0x1120
stmia r10!, {r3,r6,r12}
ldr r10, =0x1120
ldmib r10!, {r6,r8,r9}
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
ldr r0, =0x1e7fbb13
ldr r1, =0x00000020
ldr r2, =0x80000000
ldr r3, =0x00000100
ldr r4, =0x12345678
ldr r5, =0xc813a5b6
ldr r6, =0x473d7ccc
ldr r7, =0xcebb6c0b
ldr r8, =0x0000001f
ldr r9, =0x712b7a91
ldr r10, =0x9fbe23a0
ldr r11, =0x000000ff
ldr r12, =0x40ec306e
ldr r14, =0x00000000
cmp r7, r10
ldr r10, =0x1120
stmia r10!, {r5,r8,r9,lr}
ldr r10, =0x1120
ldmda r10!, {r3,r6,lr}
ldr r10, =0x1120
stmdb r10!, {r3,r7,r12}
ldr r10, =0x1120
ldmdb r10, {r0,r2,r3,r6,r9}
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
ldr r0, =0xac5de736
ldr r1, =0xebc84f4f
ldr r2, =0x7fffffff
ldr r3, =0x2f7c25bb
ldr r4, =0x00000101
ldr r5, =0xa88de648
ldr r6, =0xcafebabe
ldr r7, =0xce9b1467
ldr r8, =0x6b2070ba
ldr r9, =0x7ffffffe
ldr r10, =0x64626b03
ldr r11, =0x80000001
ldr r12, =0x371425cc
ldr r14, =0x00000001
cmp r4, r4
ldr r10, =0x1120
stmia r10, {r4,r5,lr}
ldr r10, =0x1120
stmdb r10, {r3,r4,r6,r12,lr}
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
ldr r0, =0x7fffffff
ldr r1, =0x7fffffff
ldr r2, =0x0000001f
ldr r3, =0x00000101
ldr r4, =0x00000101
ldr r5, =0x8e09ab9d
ldr r6, =0xea19df1b
ldr r7, =0x978b794f
ldr r8, =0xc659550d
ldr r9, =0x825566ad
ldr r10, =0x00000002
ldr r11, =0x0000001f
ldr r12, =0x557fbb80
ldr r14, =0xffffffff
teq r0, r4
ldr r10, =0x1120
stmdaeq r10!, {r1,r5}
ldr r10, =0x1120
ldmda r10!, {r1,r2,r4,r5,r11}
ldr r10, =0x1120
ldmia r10!, {r7}
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
ldr r0, =0xefc6366a
ldr r1, =0xf94aa2ad
ldr r2, =0x00000021
ldr r3, =0xf6815bb1
ldr r4, =0x80000000
ldr r5, =0x0000ffff
ldr r6, =0x99134b01
ldr r7, =0x45d49dea
ldr r8, =0x80000001
ldr r9, =0x80000000
ldr r10, =0x00000002
ldr r11, =0xc60d2bba
ldr r12, =0xfd445e2d
ldr r14, =0xdea67eec
tst r7, r14
ldr r10, =0x1120
stmdagt r10!, {r4}
ldr r10, =0x1120
ldmdb r10, {r5}
ldr r10, =0x1120
ldmia r10, {r0,r3,r5,r12}
ldr r10, =0x1120
stmib r10!, {r2,lr}
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
ldr r0, =0x80000001
ldr r1, =0x00000001
ldr r2, =0x0000001f
ldr r3, =0x38f7bd7e
ldr r4, =0xcafebabe
ldr r5, =0x1dc1aaa4
ldr r6, =0xd28ad3b8
ldr r7, =0x0000001f
ldr r8, =0xffffffff
ldr r9, =0x7fffffff
ldr r10, =0x00000020
ldr r11, =0x80000000
ldr r12, =0x7fffffff
ldr r14, =0xc2af7ea6
teq r2, r14
ldr r10, =0x1120
ldmdahi r10, {r3,r7}
ldr r10, =0x1120
ldmia r10, {r3,r8,lr}
ldr r10, =0x1120
ldmiane r10, {r1,r9}
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
