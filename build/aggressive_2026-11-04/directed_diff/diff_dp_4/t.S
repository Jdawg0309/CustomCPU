.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000001
str r0, [r12, #0]
ldr r0, =0xb081cc3d
str r0, [r12, #4]
ldr r0, =0x00000002
str r0, [r12, #8]
ldr r0, =0x0d9e1386
str r0, [r12, #12]
ldr r0, =0x0000001f
str r0, [r12, #16]
ldr r0, =0x6784a250
str r0, [r12, #20]
ldr r0, =0xbd79d90c
str r0, [r12, #24]
ldr r0, =0x80000001
str r0, [r12, #28]
ldr r0, =0x1f6bb40e
str r0, [r12, #32]
ldr r0, =0x12345678
str r0, [r12, #36]
ldr r0, =0x3acf9401
str r0, [r12, #40]
ldr r0, =0x8fe216e5
str r0, [r12, #44]
ldr r0, =0x48867e39
str r0, [r12, #48]
ldr r0, =0x00000100
str r0, [r12, #52]
ldr r0, =0x00000021
str r0, [r12, #56]
ldr r0, =0x7fffffff
str r0, [r12, #60]
ldr r0, =0xc8e41de7
ldr r1, =0x98c5b545
ldr r2, =0xa68b77df
ldr r3, =0x26a024ef
ldr r4, =0x80000001
ldr r5, =0x0000001f
ldr r6, =0x00000021
ldr r7, =0x0254d40a
ldr r8, =0x7fffffff
ldr r9, =0x0000001f
ldr r10, =0x91c89f83
ldr r11, =0x212891de
ldr r12, =0x00000021
ldr r14, =0xffffffff
tst r6, r4
rscle r14, r10, r5
eor r12, r1, r14, ror r5
subs r3, r10, #0x740000
eor r10, r11, r4, asr r4
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
ldr r0, =0xf98e9f4b
ldr r1, =0x00000101
ldr r2, =0x7dd77018
ldr r3, =0x7ffffffe
ldr r4, =0x077bc49f
ldr r5, =0x80000000
ldr r6, =0x0000ffff
ldr r7, =0xea900d07
ldr r8, =0x00000001
ldr r9, =0xcf35676f
ldr r10, =0xe702b928
ldr r11, =0x75c5e540
ldr r12, =0x00000002
ldr r14, =0x4fbb7c01
cmn r9, r12
teq r4, r10, lsl r8
bics r14, r0, r10
cmpge r1, r5, asr r3
adc r0, r1, r3, rrx
orrlt r0, r8, r6, ror #20
eor r1, r1, r0, asr #12
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
ldr r0, =0xcafebabe
ldr r1, =0x80000001
ldr r2, =0x00000001
ldr r3, =0x91ef7e08
ldr r4, =0x9fb4a8ac
ldr r5, =0x4adbb526
ldr r6, =0x7fffffff
ldr r7, =0xffffffff
ldr r8, =0x0000001f
ldr r9, =0x7fffffff
ldr r10, =0x94959048
ldr r11, =0x00000101
ldr r12, =0xb93d61a4
ldr r14, =0xe109f45c
cmp r12, r3
adcs r6, r3, r3
rsb r6, r3, r9, ror r1
orr r14, r2, r5, lsr #9
tst r9, r6, asr r7
sbcs r2, r14, r4, ror r6
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
ldr r0, =0x00000000
ldr r1, =0xa7691de0
ldr r2, =0xe6bf6af1
ldr r3, =0x00000101
ldr r4, =0x99dfaa85
ldr r5, =0xddc81869
ldr r6, =0x00000002
ldr r7, =0x6ea6235c
ldr r8, =0x00000100
ldr r9, =0xce9ff819
ldr r10, =0x000000ff
ldr r11, =0x927994f1
ldr r12, =0x00000021
ldr r14, =0x00000100
teq r3, r9
bic r12, r3, r0
andne r5, r0, #0x1000000
bic r7, r7, r8, asr #8
rsbs r8, r1, r14, lsl #9
rscseq r7, r12, r14, lsl r3
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
ldr r0, =0xac7157ee
ldr r1, =0x8789aec7
ldr r2, =0x00000100
ldr r3, =0x253c2250
ldr r4, =0x00000002
ldr r5, =0x14f6ce39
ldr r6, =0xdac96d6b
ldr r7, =0x41d7a841
ldr r8, =0x0000001f
ldr r9, =0xea07bf4b
ldr r10, =0x5807b67a
ldr r11, =0x01005cc0
ldr r12, =0x9706a5ca
ldr r14, =0x530ea283
cmp r5, r1
teq r12, #0xdf00000
cmp r8, r1, asr r12
orr r12, r1, r4
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
ldr r0, =0x00000101
ldr r1, =0x51182a6c
ldr r2, =0xdc582b3b
ldr r3, =0x00000100
ldr r4, =0x7ffffffe
ldr r5, =0x00000101
ldr r6, =0x354c3217
ldr r7, =0x00000000
ldr r8, =0x000000ff
ldr r9, =0x00000101
ldr r10, =0x31ab1e04
ldr r11, =0x859498e3
ldr r12, =0xa97939d7
ldr r14, =0xc456fcd1
cmn r8, r9
andsgt r1, r12, r12, lsr #8
adc r14, r11, #0x6c00
adcs r14, r7, r2, ror #18
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
ldr r0, =0x00000000
ldr r1, =0x0000ffff
ldr r2, =0x24233638
ldr r3, =0xb56bd44e
ldr r4, =0x80000000
ldr r5, =0x7fffffff
ldr r6, =0x7fffffff
ldr r7, =0x98794b79
ldr r8, =0xdbb648c0
ldr r9, =0x0000001f
ldr r10, =0x00000002
ldr r11, =0x7fffffff
ldr r12, =0x00000002
ldr r14, =0xc37ffa37
teq r6, r14
cmp r8, #0x50000001
cmp r0, r6
adcs r5, r1, #0x8f0000
teq r12, r10, ror r2
cmn r12, r3, ror #28
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
ldr r0, =0x00000021
ldr r1, =0x00000001
ldr r2, =0x152cfdf4
ldr r3, =0x0000001f
ldr r4, =0xb28d97ea
ldr r5, =0xffffffff
ldr r6, =0x00000021
ldr r7, =0xbe54c892
ldr r8, =0xe811ed1b
ldr r9, =0x00000020
ldr r10, =0x0000ffff
ldr r11, =0x00000001
ldr r12, =0x00000000
ldr r14, =0xb6cfde24
cmp r11, r2
rscs r9, r0, r14, ror r2
rsbs r0, r6, #0x8e
mvn r3, r14, lsl r8
sbc r7, r5, #0xca000000
tst r11, r14
addsgt r3, r14, #0x26
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
