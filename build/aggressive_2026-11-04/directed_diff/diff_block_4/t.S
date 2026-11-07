.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xcfcd94e7
str r0, [r12, #0]
ldr r0, =0x7ffffffe
str r0, [r12, #4]
ldr r0, =0xeba8a854
str r0, [r12, #8]
ldr r0, =0xcf2a782b
str r0, [r12, #12]
ldr r0, =0x0000001f
str r0, [r12, #16]
ldr r0, =0x00000100
str r0, [r12, #20]
ldr r0, =0x3b843d7f
str r0, [r12, #24]
ldr r0, =0x80000000
str r0, [r12, #28]
ldr r0, =0x9c0fbf01
str r0, [r12, #32]
ldr r0, =0x00000000
str r0, [r12, #36]
ldr r0, =0x000000ff
str r0, [r12, #40]
ldr r0, =0x9c5071c1
str r0, [r12, #44]
ldr r0, =0x00000020
str r0, [r12, #48]
ldr r0, =0x000000ff
str r0, [r12, #52]
ldr r0, =0x00000000
str r0, [r12, #56]
ldr r0, =0x00000002
str r0, [r12, #60]
ldr r0, =0x7d6b3728
ldr r1, =0x1da41cec
ldr r2, =0x32342d82
ldr r3, =0x000000ff
ldr r4, =0x80000001
ldr r5, =0x00000100
ldr r6, =0xab5ab054
ldr r7, =0x00000001
ldr r8, =0x0000ffff
ldr r9, =0x00000021
ldr r10, =0xdb52dbf7
ldr r11, =0x00000001
ldr r12, =0x00000021
ldr r14, =0x39a4b543
tst r12, r7
ldr r10, =0x1120
ldmib r10, {r0,r2,r8,r9,r11}
ldr r10, =0x1120
stmia r10, {r2,r5}
ldr r10, =0x1120
ldmib r10!, {r1,r2,r8,lr}
ldr r10, =0x1120
ldmib r10!, {r4}
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
ldr r0, =0xffffffff
ldr r1, =0x9ea5b2c3
ldr r2, =0x00000001
ldr r3, =0x0000001f
ldr r4, =0x00000100
ldr r5, =0x0000001f
ldr r6, =0xca556559
ldr r7, =0x80000000
ldr r8, =0xa4d531f8
ldr r9, =0x916cfa4c
ldr r10, =0x930e5d80
ldr r11, =0x143f43b0
ldr r12, =0x3d3401b0
ldr r14, =0xbcbc0dde
teq r0, r9
ldr r10, =0x1120
stmdale r10!, {r0,r1,r2,r5,r11}
ldr r10, =0x1120
stmiacs r10, {r2,r5,r9,r12}
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
ldr r0, =0x00000002
ldr r1, =0xffffffff
ldr r2, =0x00000100
ldr r3, =0xd6f3b46f
ldr r4, =0x587dea95
ldr r5, =0x00000002
ldr r6, =0x1d7db895
ldr r7, =0x12345678
ldr r8, =0x3ac013bf
ldr r9, =0x00000001
ldr r10, =0x12345678
ldr r11, =0x19a4e460
ldr r12, =0xcafebabe
ldr r14, =0x57fae15f
cmp r0, r4
ldr r10, =0x1120
stmibcs r10, {r1,r6}
ldr r10, =0x1120
ldmia r10!, {r2,r8}
ldr r10, =0x1120
ldmda r10, {r2,r6}
ldr r10, =0x1120
stmib r10, {r9}
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
ldr r0, =0x00000002
ldr r1, =0x00000000
ldr r2, =0x00000000
ldr r3, =0x31dfb959
ldr r4, =0x80000001
ldr r5, =0x000000ff
ldr r6, =0xaf9e93b7
ldr r7, =0x5b655893
ldr r8, =0x5936281d
ldr r9, =0x392275a5
ldr r10, =0x00000001
ldr r11, =0xfcf3a47e
ldr r12, =0x69977dc9
ldr r14, =0xa8bc4b4c
teq r8, r4
ldr r10, =0x1120
ldmiale r10, {r0,r9,r11,lr}
ldr r10, =0x1120
ldmia r10!, {r2,r5,lr}
ldr r10, =0x1120
ldmia r10, {r2,r6}
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
ldr r0, =0x00000100
ldr r1, =0x80000001
ldr r2, =0x63365ead
ldr r3, =0x7ffffffe
ldr r4, =0x70596d8c
ldr r5, =0xb924437b
ldr r6, =0x00000100
ldr r7, =0xffffffff
ldr r8, =0x99bd2039
ldr r9, =0xb10a24d4
ldr r10, =0x0000001f
ldr r11, =0x00000001
ldr r12, =0x5a115dff
ldr r14, =0x0000001f
cmp r4, r10
ldr r10, =0x1120
ldmda r10, {r4,r6}
ldr r10, =0x1120
stmia r10!, {r1,r6,r8,r9,r12}
ldr r10, =0x1120
stmda r10!, {r0,r2,r3,r7}
ldr r10, =0x1120
stmda r10, {r6}
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
ldr r0, =0x7666667a
ldr r1, =0x00000002
ldr r2, =0xcafebabe
ldr r3, =0x00000020
ldr r4, =0x0000001f
ldr r5, =0x00000002
ldr r6, =0x7fffffff
ldr r7, =0xadba13dc
ldr r8, =0x00000100
ldr r9, =0x5bab8bcd
ldr r10, =0x80000001
ldr r11, =0x00000002
ldr r12, =0x00000101
ldr r14, =0xabb0fab0
cmn r14, r9
ldr r10, =0x1120
stmia r10, {r1,r8,lr}
ldr r10, =0x1120
ldmia r10!, {r0,r6,r8}
ldr r10, =0x1120
stmdb r10, {r3,r8,r11}
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
ldr r0, =0x0000ffff
ldr r1, =0x9dcf64be
ldr r2, =0x000000ff
ldr r3, =0x00000020
ldr r4, =0x9ae092e9
ldr r5, =0x2bf600b9
ldr r6, =0xcb84bc5f
ldr r7, =0x000000ff
ldr r8, =0xfcbc3f00
ldr r9, =0x00000100
ldr r10, =0x5d14aff3
ldr r11, =0x8cdceb44
ldr r12, =0xe1708fa1
ldr r14, =0x53ccc149
cmn r3, r6
ldr r10, =0x1120
ldmia r10!, {r7,r12,lr}
ldr r10, =0x1120
stmia r10, {r6,r12,lr}
ldr r10, =0x1120
stmda r10, {r11}
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
ldr r0, =0x00000020
ldr r1, =0x00000000
ldr r2, =0xfb1f58ac
ldr r3, =0x00000000
ldr r4, =0x1f824ae4
ldr r5, =0x0000ffff
ldr r6, =0x00000020
ldr r7, =0x80000001
ldr r8, =0x80000000
ldr r9, =0xf13ac907
ldr r10, =0x0000ffff
ldr r11, =0x77ee3648
ldr r12, =0xaf524344
ldr r14, =0x0000ffff
cmp r3, r14
ldr r10, =0x1120
ldmdb r10, {r3,r5,r9}
ldr r10, =0x1120
stmdb r10, {r5,r11}
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
