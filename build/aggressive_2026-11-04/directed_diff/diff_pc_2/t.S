.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x971c9c37
str r0, [r12, #0]
ldr r0, =0x2df55beb
str r0, [r12, #4]
ldr r0, =0x00000001
str r0, [r12, #8]
ldr r0, =0x000000ff
str r0, [r12, #12]
ldr r0, =0x8824603e
str r0, [r12, #16]
ldr r0, =0x00000100
str r0, [r12, #20]
ldr r0, =0x909335bb
str r0, [r12, #24]
ldr r0, =0x4895fe1e
str r0, [r12, #28]
ldr r0, =0x0000ffff
str r0, [r12, #32]
ldr r0, =0x80000000
str r0, [r12, #36]
ldr r0, =0x000000ff
str r0, [r12, #40]
ldr r0, =0x19c27075
str r0, [r12, #44]
ldr r0, =0x683b1b4d
str r0, [r12, #48]
ldr r0, =0x7e1d9241
str r0, [r12, #52]
ldr r0, =0xead38a3a
str r0, [r12, #56]
ldr r0, =0x00000100
str r0, [r12, #60]
ldr r0, =0x00000002
ldr r1, =0x00000002
ldr r2, =0x00000001
ldr r3, =0xa4b79690
ldr r4, =0x00000021
ldr r5, =0x00000020
ldr r6, =0x0521213d
ldr r7, =0x00000100
ldr r8, =0x0000001f
ldr r9, =0xcb238640
ldr r10, =0x000000ff
ldr r11, =0x00000000
ldr r12, =0x6a51c4d5
ldr r14, =0xf6f1a831
cmp r14, r1
adr r3, 1f
movvs pc, r3
add r0, r0, #1
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
ldr r0, =0xc797b2d7
ldr r1, =0x4c946306
ldr r2, =0xb7810ce3
ldr r3, =0xcafebabe
ldr r4, =0x10acfe38
ldr r5, =0x6341aebe
ldr r6, =0xb48c4c72
ldr r7, =0xf40aab56
ldr r8, =0x00000001
ldr r9, =0x0000001f
ldr r10, =0x2c67ee12
ldr r11, =0x12345678
ldr r12, =0x64c33c80
ldr r14, =0xee6acc41
cmn r12, r7
cmp pc, r2
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
ldr r1, =0x00000021
ldr r2, =0xdee31a69
ldr r3, =0x00000100
ldr r4, =0x7ffffffe
ldr r5, =0x7ffffffe
ldr r6, =0x0000ffff
ldr r7, =0x282b3d4a
ldr r8, =0x503dcd2b
ldr r9, =0x00000002
ldr r10, =0xcc1a646e
ldr r11, =0xb61f8615
ldr r12, =0x00000021
ldr r14, =0x70f261ef
tst r11, r11
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
ldr r0, =0x0c6ba9ba
ldr r1, =0x00000001
ldr r2, =0xb5866900
ldr r3, =0x7fffffff
ldr r4, =0x00000002
ldr r5, =0x00000100
ldr r6, =0xaa1f2421
ldr r7, =0x250fda15
ldr r8, =0x80000001
ldr r9, =0xb29860d9
ldr r10, =0x000000ff
ldr r11, =0x0000ffff
ldr r12, =0x12345678
ldr r14, =0x538babdf
teq r7, r9
adr r3, 1f
mov pc, r3
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
ldr r0, =0x1098d1d4
ldr r1, =0x0000001f
ldr r2, =0x6d7b9818
ldr r3, =0x26a6fb16
ldr r4, =0x00000101
ldr r5, =0xffffffff
ldr r6, =0xb7523633
ldr r7, =0xc6320fdf
ldr r8, =0x80000000
ldr r9, =0xef3e15fc
ldr r10, =0x6977155b
ldr r11, =0x12345678
ldr r12, =0x7fffffff
ldr r14, =0x558fbb15
cmp r3, r11
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x00000020
ldr r1, =0x00000101
ldr r2, =0x0000001f
ldr r3, =0xcafebabe
ldr r4, =0xffffffff
ldr r5, =0x59bea9fd
ldr r6, =0x11b372b5
ldr r7, =0xcafebabe
ldr r8, =0xa25260bd
ldr r9, =0x0000ffff
ldr r10, =0x67aed145
ldr r11, =0x80000001
ldr r12, =0xffffffff
ldr r14, =0x00000001
cmp r0, r5
adr r3, 1f
movls pc, r3
add r0, r0, #1
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
ldr r0, =0x00000020
ldr r1, =0x038b46a7
ldr r2, =0x00000020
ldr r3, =0x0000001f
ldr r4, =0x71469d6d
ldr r5, =0x36309082
ldr r6, =0xb89a647c
ldr r7, =0x1cda33cf
ldr r8, =0x00000101
ldr r9, =0x5af8e69c
ldr r10, =0x0000001f
ldr r11, =0x8ff8c6d0
ldr r12, =0x78d741e7
ldr r14, =0xcafebabe
teq r8, r8
adr r3, 1f
movle pc, r3
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
ldr r0, =0xf51c28c2
ldr r1, =0x00000021
ldr r2, =0xa35d5218
ldr r3, =0x6187c8da
ldr r4, =0xca160547
ldr r5, =0x0000001f
ldr r6, =0xe72537d2
ldr r7, =0x7ffffffe
ldr r8, =0x00000100
ldr r9, =0x58631489
ldr r10, =0x2ca7477c
ldr r11, =0x00000000
ldr r12, =0x0e2ddd98
ldr r14, =0x00000020
cmp r9, r11
adr r3, 1f
mov pc, r3
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
