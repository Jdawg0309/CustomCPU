.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000101
str r0, [r12, #0]
ldr r0, =0xffffffff
str r0, [r12, #4]
ldr r0, =0xadb1c008
str r0, [r12, #8]
ldr r0, =0x104efb34
str r0, [r12, #12]
ldr r0, =0x39fd1cc3
str r0, [r12, #16]
ldr r0, =0x26f916ec
str r0, [r12, #20]
ldr r0, =0x4ab15af9
str r0, [r12, #24]
ldr r0, =0x4382c5ac
str r0, [r12, #28]
ldr r0, =0x80000000
str r0, [r12, #32]
ldr r0, =0xb79a7890
str r0, [r12, #36]
ldr r0, =0xcafebabe
str r0, [r12, #40]
ldr r0, =0x0000ffff
str r0, [r12, #44]
ldr r0, =0x00000001
str r0, [r12, #48]
ldr r0, =0x02a15eac
str r0, [r12, #52]
ldr r0, =0x13c9c4c2
str r0, [r12, #56]
ldr r0, =0x0d3e36e8
str r0, [r12, #60]
ldr r0, =0xc7459e15
ldr r1, =0x7ffffffe
ldr r2, =0x000000ff
ldr r3, =0x00000100
ldr r4, =0x00000001
ldr r5, =0x7fffffff
ldr r6, =0x98a133ee
ldr r7, =0xf540cc72
ldr r8, =0x12345678
ldr r9, =0xcafebabe
ldr r10, =0x885fde6a
ldr r11, =0x86fd3d6b
ldr r12, =0x80000001
ldr r14, =0x00000001
tst r11, r6
ldr r10, =0x1120
mov r9, #0
ldr r14, [r10], #0
ldrsh r3, [r10, r9]
ldrsb r1, [r10, #4]!
ldrsh r8, [r10, #20]!
ldr r10, =0x1120
ldrsb r7, [r10, #7]
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
ldr r0, =0x00000001
ldr r1, =0xa2d7ccad
ldr r2, =0x07613f06
ldr r3, =0x0000ffff
ldr r4, =0x7fffffff
ldr r5, =0x7fffffff
ldr r6, =0x9acc7bc9
ldr r7, =0x00000100
ldr r8, =0x0000001f
ldr r9, =0x74e80f54
ldr r10, =0x5f9db43e
ldr r11, =0x80000001
ldr r12, =0x00000021
ldr r14, =0xd78974b9
tst r14, r5
ldr r10, =0x1120
mov r9, #8
strvs r14, [r10], #12
ldr r10, =0x1120
ldr r3, [r10], #4
ldrsh r11, [r10], r9
ldrsh r8, [r10, #6]
strb r3, [r10, r9]
strge r14, [r10], -r9
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
ldr r0, =0x80000000
ldr r1, =0x9ceeb007
ldr r2, =0xc639c537
ldr r3, =0x1a25f02f
ldr r4, =0x506dcdf1
ldr r5, =0x00000100
ldr r6, =0x5a00810d
ldr r7, =0x00000002
ldr r8, =0x00000020
ldr r9, =0xe2b65658
ldr r10, =0xa08033b3
ldr r11, =0x00000002
ldr r12, =0x05885f65
ldr r14, =0x56b3a709
cmp r5, r3
ldr r10, =0x1120
mov r9, #4
ldr r4, [r10, r9]
ldr r10, =0x1120
str r6, [r10, #8]!
ldr r8, [r10, #16]
str r12, [r10, r9]
ldrsbcc r4, [r10, #0]
ldrsh r6, [r10], #12
ldrhge r7, [r10, r9]
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
ldr r0, =0x5cacf9f4
ldr r1, =0xcc8a0e04
ldr r2, =0xffffffff
ldr r3, =0x4cf694d5
ldr r4, =0x12345678
ldr r5, =0x80000001
ldr r6, =0x91e8fb6c
ldr r7, =0x00000002
ldr r8, =0xbf686d2c
ldr r9, =0xcafebabe
ldr r10, =0x00000002
ldr r11, =0x3b1ac099
ldr r12, =0x8b4eeb1f
ldr r14, =0xd738f559
teq r12, r2
ldr r10, =0x1120
mov r9, #16
ldrsh r0, [r10], r9
ldr r10, =0x1120
ldrsb r6, [r10, #20]!
ldr r2, [r10, #8]
ldrls r7, [r10, -r9]
strb r5, [r10, -r9]
ldrsh r8, [r10], #16
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
ldr r0, =0x3971bf8e
ldr r1, =0x80000000
ldr r2, =0x574151f2
ldr r3, =0x00000002
ldr r4, =0x6fbfbe16
ldr r5, =0x0000ffff
ldr r6, =0x7ffffffe
ldr r7, =0xf41f2fc6
ldr r8, =0xfb0b2f2e
ldr r9, =0xd475acbc
ldr r10, =0x2ef36e63
ldr r11, =0xf8d948bc
ldr r12, =0xffffffff
ldr r14, =0x00000001
teq r14, r9
ldr r10, =0x1120
mov r9, #16
strh r0, [r10, #-4]
strb r4, [r10], #4
ldr r10, =0x1120
strb r12, [r10, #8]
ldr r10, =0x1120
str r12, [r10, #-0]
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
ldr r0, =0x8cf842de
ldr r1, =0xcafebabe
ldr r2, =0xf0003963
ldr r3, =0xce8c0777
ldr r4, =0x80000000
ldr r5, =0x0000ffff
ldr r6, =0xb5e0c663
ldr r7, =0x00000100
ldr r8, =0x00000000
ldr r9, =0x7e75057a
ldr r10, =0x63ba7444
ldr r11, =0xde77067f
ldr r12, =0xc018b518
ldr r14, =0xce6b3332
cmp r0, r10
ldr r10, =0x1120
mov r9, #16
strb r4, [r10], r9
ldr r10, =0x1120
strvc r12, [r10, #-16]
ldrsh r0, [r10, #-0]
ldrh r2, [r10], #4
strhne r1, [r10], -r9
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
ldr r0, =0x2e79b391
ldr r1, =0x8ab0124b
ldr r2, =0x94baea9c
ldr r3, =0xd7e43ff7
ldr r4, =0xf754e4f6
ldr r5, =0x04c6f90b
ldr r6, =0xcafebabe
ldr r7, =0x1ba7f06f
ldr r8, =0x46d0a405
ldr r9, =0xffffffff
ldr r10, =0x5ca3bf11
ldr r11, =0x000000ff
ldr r12, =0x00000000
ldr r14, =0x0000001f
tst r3, r11
ldr r10, =0x1120
mov r9, #4
ldrh r1, [r10, r9]
ldr r10, =0x1120
strhi r12, [r10], r9
ldrh r7, [r10], #4
ldrb r8, [r10], r9
strbcs r5, [r10, #-15]
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
ldr r1, =0x7fffffff
ldr r2, =0x7ffffffe
ldr r3, =0x003b4409
ldr r4, =0xfd508fc4
ldr r5, =0x14822d3b
ldr r6, =0xe7a507e5
ldr r7, =0x00000021
ldr r8, =0x000000ff
ldr r9, =0xbc601e44
ldr r10, =0x6022250b
ldr r11, =0x80000001
ldr r12, =0x7fffffff
ldr r14, =0x395450fa
cmp r1, r12
ldr r10, =0x1120
mov r9, #16
ldrsb r7, [r10, #16]
str r5, [r10, #20]
ldr r10, =0x1120
strb r5, [r10, #19]
ldr r10, =0x1120
ldrsh r1, [r10, #4]!
ldr r10, =0x1120
str r7, [r10], -r9
ldr r10, =0x1120
ldrsh r6, [r10, #-10]
ldr r10, =0x1120
ldr r12, [r10, #-16]
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
