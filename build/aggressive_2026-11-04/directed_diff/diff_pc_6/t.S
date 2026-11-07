.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xf8215691
str r0, [r12, #0]
ldr r0, =0x1144ff1c
str r0, [r12, #4]
ldr r0, =0x000000ff
str r0, [r12, #8]
ldr r0, =0x00000020
str r0, [r12, #12]
ldr r0, =0xcafebabe
str r0, [r12, #16]
ldr r0, =0x0000ffff
str r0, [r12, #20]
ldr r0, =0x00000021
str r0, [r12, #24]
ldr r0, =0xa914360e
str r0, [r12, #28]
ldr r0, =0x00000002
str r0, [r12, #32]
ldr r0, =0x2dbb3301
str r0, [r12, #36]
ldr r0, =0xc15dcf53
str r0, [r12, #40]
ldr r0, =0x306a1e9c
str r0, [r12, #44]
ldr r0, =0x0000ffff
str r0, [r12, #48]
ldr r0, =0xe00ba32b
str r0, [r12, #52]
ldr r0, =0x00000021
str r0, [r12, #56]
ldr r0, =0xf7b7543d
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0x6dd6cdec
ldr r2, =0xda6327b8
ldr r3, =0x12345678
ldr r4, =0x00000020
ldr r5, =0xf48e9b89
ldr r6, =0x33a5ffc3
ldr r7, =0x6a76b28b
ldr r8, =0x9835cd91
ldr r9, =0x156f2b9e
ldr r10, =0xd083a737
ldr r11, =0x0000ffff
ldr r12, =0x5ec66877
ldr r14, =0x00000001
cmn r5, r12
sub r0, pc, #56
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
ldr r0, =0x00000020
ldr r1, =0x18659143
ldr r2, =0x00000002
ldr r3, =0x7ffffffe
ldr r4, =0x80000001
ldr r5, =0xf412e2b2
ldr r6, =0x7fffffff
ldr r7, =0x80000000
ldr r8, =0x0b81912d
ldr r9, =0xf7c74037
ldr r10, =0x00000101
ldr r11, =0xa08e3dee
ldr r12, =0x8ab76386
ldr r14, =0xa65435bd
cmp r4, r3
ldr pc, =1f
add r0, r0, #3
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
ldr r0, =0x5a26c56e
ldr r1, =0x00000000
ldr r2, =0x4fa7dac6
ldr r3, =0x80000000
ldr r4, =0x00000021
ldr r5, =0x7fffffff
ldr r6, =0x00000100
ldr r7, =0x00000001
ldr r8, =0x00000101
ldr r9, =0x00000100
ldr r10, =0x4fe9649e
ldr r11, =0x90a0b7e2
ldr r12, =0x95cd8be2
ldr r14, =0xf53c823f
cmn r5, r8
ldr pc, =1f
add r0, r0, #3
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
ldr r0, =0x0000ffff
ldr r1, =0x43d0eaec
ldr r2, =0x8ad934ea
ldr r3, =0xd72145fa
ldr r4, =0x45fd9bc3
ldr r5, =0x00000100
ldr r6, =0x2c460948
ldr r7, =0x9be7a312
ldr r8, =0x00000020
ldr r9, =0xb4552ecb
ldr r10, =0x00000100
ldr r11, =0x00000020
ldr r12, =0x80000000
ldr r14, =0xd0f9e83e
tst r4, r8
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x00000002
ldr r1, =0x947eeee2
ldr r2, =0xcafebabe
ldr r3, =0x00000002
ldr r4, =0x00000020
ldr r5, =0xcafebabe
ldr r6, =0x12345678
ldr r7, =0x37eaf7ab
ldr r8, =0xffffffff
ldr r9, =0xd4051d7f
ldr r10, =0x00000002
ldr r11, =0x000000ff
ldr r12, =0x00000100
ldr r14, =0x00000020
cmn r10, r1
adr r3, 1f
mov pc, r3
add r0, r0, #1
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
ldr r0, =0x7fffffff
ldr r1, =0x00000001
ldr r2, =0xfb24db3e
ldr r3, =0xee69ff8c
ldr r4, =0x96567dde
ldr r5, =0x00000020
ldr r6, =0xfefc52d8
ldr r7, =0x05a46eba
ldr r8, =0x00000002
ldr r9, =0x02c3e21e
ldr r10, =0xa2bcd5d9
ldr r11, =0x7fffffff
ldr r12, =0x00000001
ldr r14, =0xcafebabe
tst r12, r1
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
ldr r0, =0x12345678
ldr r1, =0xedb62b82
ldr r2, =0x72b12cfa
ldr r3, =0x12345678
ldr r4, =0x12345678
ldr r5, =0xffffffff
ldr r6, =0x690ee967
ldr r7, =0x00000020
ldr r8, =0x5fa9975e
ldr r9, =0x36bff6ec
ldr r10, =0xd971ec9e
ldr r11, =0x827c65ab
ldr r12, =0xcafebabe
ldr r14, =0x00000021
teq r14, r4
ldr r7, [pc, #4]
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
ldr r0, =0xd74c4ba5
ldr r1, =0x28b59862
ldr r2, =0x00000001
ldr r3, =0x8e9885cb
ldr r4, =0x000000ff
ldr r5, =0x58128cb9
ldr r6, =0x483142f1
ldr r7, =0xdf3795b1
ldr r8, =0x7a228d87
ldr r9, =0xcafebabe
ldr r10, =0x97506c23
ldr r11, =0x00000101
ldr r12, =0x9eacd9a3
ldr r14, =0xffffffff
cmp r5, r2
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
