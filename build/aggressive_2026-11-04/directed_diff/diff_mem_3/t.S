.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x0fe10138
str r0, [r12, #0]
ldr r0, =0x00000000
str r0, [r12, #4]
ldr r0, =0xcafebabe
str r0, [r12, #8]
ldr r0, =0xe21b9708
str r0, [r12, #12]
ldr r0, =0xd9391dee
str r0, [r12, #16]
ldr r0, =0x12345678
str r0, [r12, #20]
ldr r0, =0xd904241e
str r0, [r12, #24]
ldr r0, =0x6258bb56
str r0, [r12, #28]
ldr r0, =0x16f2f5d5
str r0, [r12, #32]
ldr r0, =0x55c101ac
str r0, [r12, #36]
ldr r0, =0xd5681693
str r0, [r12, #40]
ldr r0, =0x00000100
str r0, [r12, #44]
ldr r0, =0xcafebabe
str r0, [r12, #48]
ldr r0, =0x7fffffff
str r0, [r12, #52]
ldr r0, =0x7fffffff
str r0, [r12, #56]
ldr r0, =0x86646c82
str r0, [r12, #60]
ldr r0, =0x341ceb3c
ldr r1, =0x00000021
ldr r2, =0xd2142291
ldr r3, =0x7fffffff
ldr r4, =0x5e197840
ldr r5, =0x12345678
ldr r6, =0x72191f80
ldr r7, =0x00000020
ldr r8, =0xe4b7f80c
ldr r9, =0x80000000
ldr r10, =0xabe9f863
ldr r11, =0x00000021
ldr r12, =0x7fffffff
ldr r14, =0xcafebabe
cmp r11, r4
ldr r10, =0x1120
mov r9, #0
str r11, [r10], #0
ldrb r6, [r10, r9]
ldr r10, =0x1120
ldrshcs r11, [r10, #-12]
ldrsb r1, [r10], r9
ldrsh r2, [r10], -r9
strh r0, [r10], r9
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
ldr r1, =0x70524623
ldr r2, =0x7fffffff
ldr r3, =0x000000ff
ldr r4, =0x00000000
ldr r5, =0xe6a9c972
ldr r6, =0xffffffff
ldr r7, =0x7fffffff
ldr r8, =0x2d99dfaf
ldr r9, =0x00000020
ldr r10, =0x80000001
ldr r11, =0xf4dff7fa
ldr r12, =0x7ffffffe
ldr r14, =0x000000ff
tst r11, r6
ldr r10, =0x1120
mov r9, #4
strhge r0, [r10, #4]
ldrsb r11, [r10], #4
ldr r10, =0x1120
ldrh r1, [r10, r9]
str r5, [r10], #8
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
ldr r0, =0x7fffffff
ldr r1, =0xcafebabe
ldr r2, =0xfb84bb32
ldr r3, =0xffffffff
ldr r4, =0x00000020
ldr r5, =0x7fffffff
ldr r6, =0x0000ffff
ldr r7, =0x00000021
ldr r8, =0x00000021
ldr r9, =0x7fffffff
ldr r10, =0x00000001
ldr r11, =0x0000ffff
ldr r12, =0x0000001f
ldr r14, =0x7db54ed7
teq r14, r9
ldr r10, =0x1120
mov r9, #12
str r5, [r10, #4]!
strh r6, [r10, #16]!
ldrb r4, [r10, #10]
str r6, [r10, r9]
ldrb r11, [r10, #10]
ldrheq r7, [r10], #16
ldr r10, =0x1120
ldr r12, [r10, #0]!
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
ldr r0, =0xebcafdde
ldr r1, =0x7dac4726
ldr r2, =0xf774ac5f
ldr r3, =0x7695cdfc
ldr r4, =0x0ddd8074
ldr r5, =0x00000002
ldr r6, =0x0000001f
ldr r7, =0x3d965c11
ldr r8, =0xffffffff
ldr r9, =0x8fc8e4f1
ldr r10, =0x08a36757
ldr r11, =0x811a8353
ldr r12, =0x7fffffff
ldr r14, =0x000000ff
teq r1, r6
ldr r10, =0x1120
mov r9, #8
strb r12, [r10, #-11]
ldrhle r6, [r10], #20
ldr r10, =0x1120
strh r0, [r10, #8]
ldrshlt r0, [r10, #0]!
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
ldr r0, =0xcafebabe
ldr r1, =0xd5f00e7d
ldr r2, =0x0aad7135
ldr r3, =0xcafebabe
ldr r4, =0x0000ffff
ldr r5, =0x00000001
ldr r6, =0x824c0435
ldr r7, =0xcafebabe
ldr r8, =0x574148e0
ldr r9, =0x12d84429
ldr r10, =0xd616b7b5
ldr r11, =0xdc214798
ldr r12, =0x00000001
ldr r14, =0x83a776df
cmp r1, r0
ldr r10, =0x1120
mov r9, #12
strb r0, [r10], #4
ldr r10, =0x1120
ldrshcc r0, [r10, #-12]
strh r2, [r10, -r9]
ldrshne r8, [r10, #14]
ldrsh r6, [r10], -r9
ldrb r1, [r10], #12
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
ldr r0, =0x0000ffff
ldr r1, =0x00000002
ldr r2, =0x00000101
ldr r3, =0xeab4a8c7
ldr r4, =0x00000101
ldr r5, =0x00000001
ldr r6, =0xbeb566ec
ldr r7, =0x73365cd0
ldr r8, =0x79f74468
ldr r9, =0x00000100
ldr r10, =0xd8f756fc
ldr r11, =0x6375799a
ldr r12, =0x0000001f
ldr r14, =0x7ffffffe
cmp r11, r8
ldr r10, =0x1120
mov r9, #8
strh r4, [r10], -r9
ldrh r8, [r10], -r9
ldrh r7, [r10, -r9]
ldr r10, =0x1120
str r1, [r10], #8
strh r2, [r10, #-14]
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
ldr r0, =0xac0868f7
ldr r1, =0x42d8fa91
ldr r2, =0xffffffff
ldr r3, =0x0f5b23a0
ldr r4, =0xfd86fc79
ldr r5, =0x48ef2153
ldr r6, =0xcafebabe
ldr r7, =0x9775e38e
ldr r8, =0x3777c298
ldr r9, =0x1c381d57
ldr r10, =0x4446cec1
ldr r11, =0x7fffffff
ldr r12, =0xffffffff
ldr r14, =0x00000101
teq r11, r12
ldr r10, =0x1120
mov r9, #12
str r1, [r10], -r9
ldrsbls r1, [r10, #-10]
ldrshcs r4, [r10], r9
str r0, [r10, #4]
ldrshls r5, [r10], -r9
ldr r10, =0x1120
ldrsb r14, [r10, #12]
ldr r0, [r10, #-28]
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
ldr r0, =0x04d5b3dd
ldr r1, =0x00000001
ldr r2, =0xf0defba2
ldr r3, =0x00000101
ldr r4, =0xd4f4e089
ldr r5, =0xffffffff
ldr r6, =0x12345678
ldr r7, =0x00000001
ldr r8, =0xa311a19e
ldr r9, =0xad6decc4
ldr r10, =0x4b0f304a
ldr r11, =0x8242e013
ldr r12, =0x7ffffffe
ldr r14, =0x7d6c9cd7
tst r6, r12
ldr r10, =0x1120
mov r9, #16
ldr r2, [r10, #4]!
ldr r4, [r10, #16]
ldrcs r11, [r10, #12]!
ldr r10, =0x1120
ldrshpl r5, [r10, -r9]
ldrsh r8, [r10, #0]!
ldrsbvs r14, [r10], #4
ldrsbeq r0, [r10, r9]
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
