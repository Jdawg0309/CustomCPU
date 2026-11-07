.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000021
str r0, [r12, #0]
ldr r0, =0xcafebabe
str r0, [r12, #4]
ldr r0, =0x04948b2e
str r0, [r12, #8]
ldr r0, =0x790c2c4f
str r0, [r12, #12]
ldr r0, =0x00000021
str r0, [r12, #16]
ldr r0, =0xe7a1a66e
str r0, [r12, #20]
ldr r0, =0x62ddf56b
str r0, [r12, #24]
ldr r0, =0xa26b81ed
str r0, [r12, #28]
ldr r0, =0x0000001f
str r0, [r12, #32]
ldr r0, =0xd5a103d1
str r0, [r12, #36]
ldr r0, =0x7ffffffe
str r0, [r12, #40]
ldr r0, =0xb72a6b53
str r0, [r12, #44]
ldr r0, =0xffffffff
str r0, [r12, #48]
ldr r0, =0x80000000
str r0, [r12, #52]
ldr r0, =0x194afbd9
str r0, [r12, #56]
ldr r0, =0x7fffffff
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0x8d81fd49
ldr r2, =0x3da42b33
ldr r3, =0x00000021
ldr r4, =0x7ffffffe
ldr r5, =0x7fffffff
ldr r6, =0x4f4033c0
ldr r7, =0xe19a3fa6
ldr r8, =0x00000021
ldr r9, =0x8963ce01
ldr r10, =0xfcf8b738
ldr r11, =0x12345678
ldr r12, =0x00000100
ldr r14, =0xffffffff
cmp r14, r8
ldr r10, =0x1120
mov r9, #16
ldr r2, [r10, #-12]
ldrhlt r5, [r10, #-4]
ldrsh r14, [r10], #0
strh r11, [r10, #20]!
ldr r10, =0x1120
strh r3, [r10, r9]
ldrsb r11, [r10, #-9]
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
ldr r0, =0x42979a7e
ldr r1, =0x80000001
ldr r2, =0x578defd4
ldr r3, =0x21e7e3ce
ldr r4, =0xb62dd943
ldr r5, =0x7aa5f697
ldr r6, =0x000000ff
ldr r7, =0x4f28aaba
ldr r8, =0x49a7f84b
ldr r9, =0x8a755762
ldr r10, =0xe77e43fc
ldr r11, =0xffffffff
ldr r12, =0x26b2808e
ldr r14, =0xaebabe72
cmn r0, r8
ldr r10, =0x1120
mov r9, #16
ldrshvs r0, [r10, -r9]
ldrsh r11, [r10], #12
ldrsh r6, [r10], #4
ldr r10, =0x1120
strh r1, [r10, r9]
str r7, [r10], #4
ldr r10, =0x1120
strcc r1, [r10], #20
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
ldr r1, =0x00000001
ldr r2, =0x7fffffff
ldr r3, =0x41b2b4f4
ldr r4, =0x6c1aacbd
ldr r5, =0x00000000
ldr r6, =0x00000001
ldr r7, =0x00000100
ldr r8, =0x00000100
ldr r9, =0x0000001f
ldr r10, =0xffffffff
ldr r11, =0x052a1cef
ldr r12, =0x000000ff
ldr r14, =0x7ffffffe
tst r2, r0
ldr r10, =0x1120
mov r9, #0
ldrb r4, [r10, #5]
strhmi r7, [r10, #14]
strhcc r0, [r10, #2]
ldr r10, =0x1120
strle r14, [r10, #16]
ldr r10, =0x1120
ldrb r3, [r10, #8]!
ldr r10, =0x1120
strb r8, [r10, #0]!
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
ldr r0, =0x29d9c6e8
ldr r1, =0x63915391
ldr r2, =0x7e0c972b
ldr r3, =0xe37b634c
ldr r4, =0x12345678
ldr r5, =0xf77bc70f
ldr r6, =0x7fffffff
ldr r7, =0xc85fbbfb
ldr r8, =0x7ffffffe
ldr r9, =0x4d64b18a
ldr r10, =0x54c2b8aa
ldr r11, =0x7fffffff
ldr r12, =0x0000ffff
ldr r14, =0x552478a4
tst r2, r7
ldr r10, =0x1120
mov r9, #8
str r1, [r10, #12]
ldrsb r11, [r10, #-14]
ldrsb r11, [r10], #0
ldr r10, =0x1120
ldr r12, [r10], #0
ldr r7, [r10, #-24]
strh r14, [r10, #10]
strb r5, [r10], #16
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
ldr r0, =0xfb732d45
ldr r1, =0xa0da55fb
ldr r2, =0x38b6c9e8
ldr r3, =0xbb655980
ldr r4, =0x12345678
ldr r5, =0x14f28f7e
ldr r6, =0x07cd3bf3
ldr r7, =0x00000021
ldr r8, =0x8db518ee
ldr r9, =0xc30d1cdd
ldr r10, =0xffffffff
ldr r11, =0x80000001
ldr r12, =0x129d82ff
ldr r14, =0xdd251048
cmp r2, r1
ldr r10, =0x1120
mov r9, #12
ldr r5, [r10], r9
ldrblt r4, [r10, -r9]
ldrsb r2, [r10, #17]
ldr r10, =0x1120
strbmi r2, [r10, #3]
ldr r10, =0x1120
ldrh r3, [r10, #-0]
ldr r0, [r10, r9]
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
ldr r1, =0x680636d2
ldr r2, =0x0be7f4a4
ldr r3, =0x00000101
ldr r4, =0x7fffffff
ldr r5, =0x80000000
ldr r6, =0x12345678
ldr r7, =0xc71f95ea
ldr r8, =0xffffffff
ldr r9, =0x4082221a
ldr r10, =0x3fdf1cf2
ldr r11, =0xffffffff
ldr r12, =0xb3b71c9a
ldr r14, =0x510be1a8
teq r11, r3
ldr r10, =0x1120
mov r9, #0
ldrsbhi r0, [r10, r9]
ldrsb r14, [r10], #20
ldr r10, =0x1120
strbvc r5, [r10], -r9
ldrsb r2, [r10, #0]!
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
ldr r0, =0xc7173c48
ldr r1, =0x80000001
ldr r2, =0x80000001
ldr r3, =0x00000020
ldr r4, =0x0000001f
ldr r5, =0xc5766dbf
ldr r6, =0x06bc83cc
ldr r7, =0x0000ffff
ldr r8, =0x00000100
ldr r9, =0xfcb28200
ldr r10, =0x12345678
ldr r11, =0x00000000
ldr r12, =0x12345678
ldr r14, =0x80000001
tst r11, r11
ldr r10, =0x1120
mov r9, #12
strb r1, [r10], r9
strbmi r3, [r10], -r9
ldr r10, =0x1120
str r7, [r10], #4
str r3, [r10, r9]
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
ldr r0, =0xcafebabe
ldr r1, =0x0000001f
ldr r2, =0x80000000
ldr r3, =0x60f9f74b
ldr r4, =0x7e1b20e9
ldr r5, =0x1356d7c8
ldr r6, =0x80000001
ldr r7, =0x7fffffff
ldr r8, =0x80000000
ldr r9, =0x00627dc7
ldr r10, =0x80000000
ldr r11, =0x00000001
ldr r12, =0x00000100
ldr r14, =0x6145d23b
tst r5, r7
ldr r10, =0x1120
mov r9, #12
ldr r14, [r10, r9]
ldrhcs r7, [r10, #-14]
ldrb r14, [r10], r9
ldr r10, =0x1120
strb r14, [r10, #18]
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
