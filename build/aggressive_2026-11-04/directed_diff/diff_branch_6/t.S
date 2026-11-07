.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x99af4616
str r0, [r12, #0]
ldr r0, =0x00000020
str r0, [r12, #4]
ldr r0, =0x9f5d5640
str r0, [r12, #8]
ldr r0, =0x00000020
str r0, [r12, #12]
ldr r0, =0x0000ffff
str r0, [r12, #16]
ldr r0, =0x00000001
str r0, [r12, #20]
ldr r0, =0x000000ff
str r0, [r12, #24]
ldr r0, =0xcafebabe
str r0, [r12, #28]
ldr r0, =0x00000002
str r0, [r12, #32]
ldr r0, =0x7ffffffe
str r0, [r12, #36]
ldr r0, =0x0e95c94c
str r0, [r12, #40]
ldr r0, =0x00000100
str r0, [r12, #44]
ldr r0, =0x5f5fd739
str r0, [r12, #48]
ldr r0, =0x00000001
str r0, [r12, #52]
ldr r0, =0x0000ffff
str r0, [r12, #56]
ldr r0, =0x1c5c4034
str r0, [r12, #60]
ldr r0, =0x00000002
ldr r1, =0x00000101
ldr r2, =0xf4e259ea
ldr r3, =0x266bdbc0
ldr r4, =0x1532ef02
ldr r5, =0x7ffffffe
ldr r6, =0xd49dab12
ldr r7, =0x75ad283a
ldr r8, =0xfb2af9d3
ldr r9, =0x00000001
ldr r10, =0xad1e587e
ldr r11, =0x00000020
ldr r12, =0xcafebabe
ldr r14, =0x12345678
teq r6, r2
blpl 1f
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
ldr r0, =0x000000ff
ldr r1, =0x80000000
ldr r2, =0x000000ff
ldr r3, =0x7fffffff
ldr r4, =0x26660861
ldr r5, =0x00000001
ldr r6, =0x06ef90ef
ldr r7, =0xc70f4d10
ldr r8, =0x5e97c6da
ldr r9, =0x0cd5a95b
ldr r10, =0xe4fc5f3d
ldr r11, =0xc851c3a7
ldr r12, =0x17a96867
ldr r14, =0xd1b19bd0
cmp r11, r1
blvc 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x682f2c02
ldr r1, =0x00000101
ldr r2, =0x8d8c7c17
ldr r3, =0x36446e06
ldr r4, =0x8aaa6fc3
ldr r5, =0xcafebabe
ldr r6, =0x332111f5
ldr r7, =0xcb361452
ldr r8, =0x3e3a0f6f
ldr r9, =0x00000101
ldr r10, =0x00000100
ldr r11, =0x89b66965
ldr r12, =0x00000101
ldr r14, =0x48ab4fc4
cmn r7, r1
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
ldr r0, =0x78fc780b
ldr r1, =0x80000001
ldr r2, =0xd63f31c0
ldr r3, =0x41332eba
ldr r4, =0xac0f3152
ldr r5, =0x22baa5d8
ldr r6, =0x7d0ddfe9
ldr r7, =0x4ba1c0bf
ldr r8, =0x12345678
ldr r9, =0x00000101
ldr r10, =0x00000101
ldr r11, =0x7ffffffe
ldr r12, =0x7ffffffe
ldr r14, =0x8655df2a
tst r14, r5
blvc 1f
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
ldr r0, =0x80000001
ldr r1, =0x0000ffff
ldr r2, =0x00000001
ldr r3, =0xbc5fb5d5
ldr r4, =0x0000001f
ldr r5, =0x678a9046
ldr r6, =0xd76792c8
ldr r7, =0xde435def
ldr r8, =0xcafebabe
ldr r9, =0x0000001f
ldr r10, =0x00000001
ldr r11, =0x29a99c08
ldr r12, =0x000000ff
ldr r14, =0x80000001
cmp r1, r1
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
ldr r0, =0x42e61506
ldr r1, =0xcafebabe
ldr r2, =0xcafebabe
ldr r3, =0x00000002
ldr r4, =0x80000000
ldr r5, =0x47561132
ldr r6, =0xffffffff
ldr r7, =0x39a6a7f3
ldr r8, =0x00000101
ldr r9, =0x6a3080ed
ldr r10, =0x00000020
ldr r11, =0xacfd632c
ldr r12, =0x00000021
ldr r14, =0x80000001
teq r12, r11
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0xaf2b1888
ldr r1, =0x00000100
ldr r2, =0xe87d28b2
ldr r3, =0x95904f6f
ldr r4, =0x00000100
ldr r5, =0xb519a0e7
ldr r6, =0x00000020
ldr r7, =0x7ffffffe
ldr r8, =0x14a2d562
ldr r9, =0xf4c84306
ldr r10, =0xa5565bac
ldr r11, =0xf1c60fd6
ldr r12, =0x7fffffff
ldr r14, =0xdcf7f7ca
cmp r5, r5
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bmi 2f
add r1, r1, #7
2:
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
ldr r1, =0xcafebabe
ldr r2, =0x7ffffffe
ldr r3, =0x000000ff
ldr r4, =0xf4bb7a75
ldr r5, =0xaeaf2cf2
ldr r6, =0x2d73ed44
ldr r7, =0xe64ef9c2
ldr r8, =0x00000001
ldr r9, =0x00000002
ldr r10, =0x00000101
ldr r11, =0x58ccda5f
ldr r12, =0xffffffff
ldr r14, =0x80000001
cmp r3, r7
ble 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
