.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xc117a82a
str r0, [r12, #0]
ldr r0, =0x80000001
str r0, [r12, #4]
ldr r0, =0x776351ab
str r0, [r12, #8]
ldr r0, =0x00000100
str r0, [r12, #12]
ldr r0, =0xcafebabe
str r0, [r12, #16]
ldr r0, =0xeb544d9d
str r0, [r12, #20]
ldr r0, =0x36effa5f
str r0, [r12, #24]
ldr r0, =0x5fc52ec9
str r0, [r12, #28]
ldr r0, =0xffffffff
str r0, [r12, #32]
ldr r0, =0x0000ffff
str r0, [r12, #36]
ldr r0, =0x000000ff
str r0, [r12, #40]
ldr r0, =0x76f384b0
str r0, [r12, #44]
ldr r0, =0x2ab33b68
str r0, [r12, #48]
ldr r0, =0xac053abf
str r0, [r12, #52]
ldr r0, =0x66e186cd
str r0, [r12, #56]
ldr r0, =0x0000ffff
str r0, [r12, #60]
ldr r0, =0x4c000c85
ldr r1, =0x00000100
ldr r2, =0x12345678
ldr r3, =0x80000000
ldr r4, =0x00000101
ldr r5, =0xc7fb1fdd
ldr r6, =0xfa9b3746
ldr r7, =0xffffffff
ldr r8, =0x87eee331
ldr r9, =0x49d44321
ldr r10, =0xc07df6c5
ldr r11, =0x12345678
ldr r12, =0xf43feb27
ldr r14, =0x5820f271
teq r2, r1
add r4, pc, #24
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
ldr r0, =0x7fffffff
ldr r1, =0x14703921
ldr r2, =0x88a54b3f
ldr r3, =0x80789902
ldr r4, =0x80000000
ldr r5, =0x7ffffffe
ldr r6, =0x992e4d98
ldr r7, =0x00000100
ldr r8, =0xffffffff
ldr r9, =0xddea2c55
ldr r10, =0x3e082d23
ldr r11, =0x00000020
ldr r12, =0x00000100
ldr r14, =0x6cbce813
cmn r12, r3
addvs pc, pc, #0
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
ldr r0, =0x12345678
ldr r1, =0xa6877c09
ldr r2, =0x7ffffffe
ldr r3, =0x96757caf
ldr r4, =0x00000100
ldr r5, =0x5a4dd87e
ldr r6, =0x00000101
ldr r7, =0x00000020
ldr r8, =0x19537b8f
ldr r9, =0x217cbee4
ldr r10, =0x7a883c30
ldr r11, =0x83615802
ldr r12, =0x00000100
ldr r14, =0x65671d47
cmn r10, r8
add r0, r7, pc
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
ldr r0, =0x732654ce
ldr r1, =0xcafebabe
ldr r2, =0xcafebabe
ldr r3, =0xd705068d
ldr r4, =0x00000020
ldr r5, =0x0000001f
ldr r6, =0xab2dc6b1
ldr r7, =0x00000020
ldr r8, =0x9f671c49
ldr r9, =0x9b7ebc18
ldr r10, =0x00000020
ldr r11, =0x857a7bd6
ldr r12, =0x8b2c8a04
ldr r14, =0xcda11263
teq r14, r11
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
ldr r0, =0x6bc29c77
ldr r1, =0x00000100
ldr r2, =0x7c364e82
ldr r3, =0x7fffffff
ldr r4, =0x285541d0
ldr r5, =0x073ccbf3
ldr r6, =0x00000001
ldr r7, =0xe9cf0cef
ldr r8, =0x62471135
ldr r9, =0xb9787437
ldr r10, =0x00000000
ldr r11, =0xf576dae8
ldr r12, =0x56edda34
ldr r14, =0x0000ffff
cmp r12, r9
ldr r10, =0x1120
adr r3, 1f
str r3, [r10]
ldr pc, [r10]
add r0, r0, #5
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
ldr r0, =0xa8e27a85
ldr r1, =0x00000002
ldr r2, =0x00000002
ldr r3, =0xffffffff
ldr r4, =0xaf31336f
ldr r5, =0x9752dbb7
ldr r6, =0x00000101
ldr r7, =0xc23f716a
ldr r8, =0x9fd3437b
ldr r9, =0x54a807bd
ldr r10, =0x00000000
ldr r11, =0x357972b7
ldr r12, =0x90ebe350
ldr r14, =0xf111afbf
teq r0, r3
ldr pc, =1f
add r0, r0, #3
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
ldr r0, =0xbc71e185
ldr r1, =0xffffffff
ldr r2, =0x00000101
ldr r3, =0x5216a77c
ldr r4, =0x2faf514d
ldr r5, =0x434c2f0f
ldr r6, =0x00000101
ldr r7, =0x00000100
ldr r8, =0x0000001f
ldr r9, =0xcafebabe
ldr r10, =0xce7251db
ldr r11, =0x07bf0f9c
ldr r12, =0xf9244110
ldr r14, =0x00000001
teq r6, r1
adr r3, 1f
movcs pc, r3
add r0, r0, #1
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
ldr r0, =0x8cb18618
ldr r1, =0x00000001
ldr r2, =0x80000001
ldr r3, =0xcafebabe
ldr r4, =0xeb457f5f
ldr r5, =0x16ce190b
ldr r6, =0x8b567098
ldr r7, =0x000000ff
ldr r8, =0xaf52f045
ldr r9, =0x000000ff
ldr r10, =0x71e3095e
ldr r11, =0x00000101
ldr r12, =0xcb0c3dbf
ldr r14, =0xcafebabe
tst r12, r0
add r5, r0, pc
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
