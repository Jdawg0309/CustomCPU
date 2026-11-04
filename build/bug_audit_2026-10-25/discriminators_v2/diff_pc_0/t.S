.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000002
str r0, [r12, #0]
ldr r0, =0x12345678
str r0, [r12, #4]
ldr r0, =0xce99b47a
str r0, [r12, #8]
ldr r0, =0xbd253191
str r0, [r12, #12]
ldr r0, =0x6b0656dc
str r0, [r12, #16]
ldr r0, =0x657a2f16
str r0, [r12, #20]
ldr r0, =0x12345678
str r0, [r12, #24]
ldr r0, =0x7ffffffe
str r0, [r12, #28]
ldr r0, =0x931d965d
str r0, [r12, #32]
ldr r0, =0x36bd3869
str r0, [r12, #36]
ldr r0, =0xd14cc67c
str r0, [r12, #40]
ldr r0, =0x80000001
str r0, [r12, #44]
ldr r0, =0x00000000
str r0, [r12, #48]
ldr r0, =0x00000000
str r0, [r12, #52]
ldr r0, =0xc124ef79
str r0, [r12, #56]
ldr r0, =0x00000002
str r0, [r12, #60]
ldr r0, =0x5fea672c
ldr r1, =0x000000ff
ldr r2, =0xbcc429bb
ldr r3, =0x00000002
ldr r4, =0x7fffffff
ldr r5, =0xd9308317
ldr r6, =0x3dfba319
ldr r7, =0x80000000
ldr r8, =0x00000001
ldr r9, =0x000000ff
ldr r10, =0x04797752
ldr r11, =0x8ba0fc27
ldr r12, =0x00000002
ldr r14, =0xebe72e2a
cmn r6, r3
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
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
ldr r0, =0x522ace56
ldr r1, =0x00000000
ldr r2, =0x00000021
ldr r3, =0x554a3e7f
ldr r4, =0x0000001f
ldr r5, =0xcafebabe
ldr r6, =0x53c5db47
ldr r7, =0x00000101
ldr r8, =0x00000100
ldr r9, =0x00000000
ldr r10, =0x6920989f
ldr r11, =0x0000001f
ldr r12, =0x00000101
ldr r14, =0xa1719d98
cmp r14, r0
adr r3, 1f
mov pc, r3
add r0, r0, #1
1:
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
ldr r0, =0x00000001
ldr r1, =0x527f9da9
ldr r2, =0x00000020
ldr r3, =0x2bb2bbe6
ldr r4, =0x80000000
ldr r5, =0x52e5956a
ldr r6, =0x411ac237
ldr r7, =0x00000000
ldr r8, =0x00000000
ldr r9, =0x00000001
ldr r10, =0x00000021
ldr r11, =0x00000001
ldr r12, =0x7fffffff
ldr r14, =0x0000ffff
cmn r8, r12
adr r3, 1f
mov pc, r3
add r0, r0, #1
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
ldr r0, =0xffffffff
ldr r1, =0x1422dec3
ldr r2, =0x7fffffff
ldr r3, =0xb7d3934f
ldr r4, =0x00000020
ldr r5, =0xb74ae5a6
ldr r6, =0x0000001f
ldr r7, =0xe96a68b6
ldr r8, =0x00000021
ldr r9, =0x00000000
ldr r10, =0xe0fa549b
ldr r11, =0x00000002
ldr r12, =0xd9cb36a7
ldr r14, =0x84061950
teq r6, r12
adr r3, 1f
movge pc, r3
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
ldr r0, =0x575ed236
ldr r1, =0x00000101
ldr r2, =0xd3893c76
ldr r3, =0x00000100
ldr r4, =0x4c623886
ldr r5, =0x00000021
ldr r6, =0x000000ff
ldr r7, =0x0eec0451
ldr r8, =0x000000ff
ldr r9, =0x80000001
ldr r10, =0xa1053325
ldr r11, =0x7fffffff
ldr r12, =0xca9892e2
ldr r14, =0x000000ff
teq r8, r7
ldr r2, [pc, #4]
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
ldr r0, =0xcafebabe
ldr r1, =0xfff88cb2
ldr r2, =0x60d5caf2
ldr r3, =0x00000100
ldr r4, =0xa1eeaba6
ldr r5, =0x985406cd
ldr r6, =0x2e5f2641
ldr r7, =0x12345678
ldr r8, =0x00000001
ldr r9, =0x88c03ef4
ldr r10, =0x368991a6
ldr r11, =0xc78f1461
ldr r12, =0x00000001
ldr r14, =0x7f93f2e5
tst r5, r9
addcc pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r1, =0xeccd5e20
ldr r2, =0x00000021
ldr r3, =0xffffffff
ldr r4, =0x36a5f9c8
ldr r5, =0x0000ffff
ldr r6, =0x2abdf5db
ldr r7, =0x00000001
ldr r8, =0x12345678
ldr r9, =0x91a8fc35
ldr r10, =0x9e0124c3
ldr r11, =0x7dd630ca
ldr r12, =0x7fffffff
ldr r14, =0x12345678
tst r3, r7
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
ldr r0, =0x7ffffffe
ldr r1, =0x1b5732f2
ldr r2, =0xeaf1a74a
ldr r3, =0x0000ffff
ldr r4, =0x80000001
ldr r5, =0x80000001
ldr r6, =0x00000021
ldr r7, =0x8485a424
ldr r8, =0xc8677808
ldr r9, =0x9f11974f
ldr r10, =0x78878495
ldr r11, =0x18611a84
ldr r12, =0xbe302f4e
ldr r14, =0x00000001
cmn r0, r5
adr r3, 1f
movvs pc, r3
add r0, r0, #1
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
