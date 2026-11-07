.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0xcafebabe
str r0, [r12, #0]
ldr r0, =0x7ffffffe
str r0, [r12, #4]
ldr r0, =0xffffffff
str r0, [r12, #8]
ldr r0, =0xcfc47bd8
str r0, [r12, #12]
ldr r0, =0x00000000
str r0, [r12, #16]
ldr r0, =0x12345678
str r0, [r12, #20]
ldr r0, =0x47d86145
str r0, [r12, #24]
ldr r0, =0x7ffffffe
str r0, [r12, #28]
ldr r0, =0x61b8a24f
str r0, [r12, #32]
ldr r0, =0x00000002
str r0, [r12, #36]
ldr r0, =0xc6c7f016
str r0, [r12, #40]
ldr r0, =0x2d0a854a
str r0, [r12, #44]
ldr r0, =0x6d416f7c
str r0, [r12, #48]
ldr r0, =0x80000000
str r0, [r12, #52]
ldr r0, =0xda8fbd0d
str r0, [r12, #56]
ldr r0, =0xaedeb88d
str r0, [r12, #60]
ldr r0, =0x00000100
ldr r1, =0xcafebabe
ldr r2, =0x7ffffffe
ldr r3, =0x00000100
ldr r4, =0x00000100
ldr r5, =0x00000021
ldr r6, =0x000000ff
ldr r7, =0xe4e21467
ldr r8, =0x7ffffffe
ldr r9, =0xb792094b
ldr r10, =0x00000002
ldr r11, =0x12345678
ldr r12, =0x3327ae4b
ldr r14, =0xcafebabe
tst r11, r8
orr r2, r14, r0, lsl r3
ands r6, r8, r4, rrx
bic r12, r11, #0xed0
cmn r14, r7, asr r11
movs r6, r2, lsl #14
rsc r7, r12, r11, lsr r7
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
ldr r0, =0x73f65136
ldr r1, =0xd00c781b
ldr r2, =0x80000000
ldr r3, =0x29ae4138
ldr r4, =0xcafebabe
ldr r5, =0xb2edad65
ldr r6, =0x58508b98
ldr r7, =0x00000001
ldr r8, =0x00000020
ldr r9, =0x0000ffff
ldr r10, =0xcafebabe
ldr r11, =0x202d5ad0
ldr r12, =0x113aa041
ldr r14, =0xb15881e8
tst r0, r0
eorsge r9, r9, r5, asr #9
rsbge r11, r0, r7
rsbs r14, r14, r7
teqcc r11, r8, asr r6
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
ldr r0, =0x798c92b6
ldr r1, =0x983d4263
ldr r2, =0xbc083457
ldr r3, =0xd92a5122
ldr r4, =0x46b908c4
ldr r5, =0xf27a40be
ldr r6, =0xffffffff
ldr r7, =0xcafebabe
ldr r8, =0x12345678
ldr r9, =0x11f72d96
ldr r10, =0x80000000
ldr r11, =0xf358f66d
ldr r12, =0x64d15872
ldr r14, =0x2308836a
cmp r10, r3
teqle r7, r12, lsl r2
bics r1, r5, r11, lsr #1
cmn r10, r5, asr r8
adcs r1, r10, r4, asr r4
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
ldr r0, =0x7ffffffe
ldr r1, =0x36e621db
ldr r2, =0xd36b3350
ldr r3, =0x00000000
ldr r4, =0x7ffffffe
ldr r5, =0xffffffff
ldr r6, =0xe2c50322
ldr r7, =0x00000021
ldr r8, =0x4b7255ea
ldr r9, =0x00000002
ldr r10, =0xf93b845f
ldr r11, =0xf7cb96e1
ldr r12, =0x2056b087
ldr r14, =0xe0566d23
cmp r2, r6
cmn r14, r10, lsl #11
cmn r1, #0xa8000000
orrs r3, r3, r7
orrslt r8, r2, #0xcc000
rscs r3, r10, #0x12
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
ldr r0, =0x7fffffff
ldr r1, =0x12345678
ldr r2, =0x42204cf7
ldr r3, =0x7fffffff
ldr r4, =0x27ca335f
ldr r5, =0x5c919905
ldr r6, =0x00000100
ldr r7, =0xac3d7f37
ldr r8, =0xf1c097cd
ldr r9, =0x23cb5098
ldr r10, =0x7ffffffe
ldr r11, =0x049347d5
ldr r12, =0x0000ffff
ldr r14, =0x7ffffffe
teq r7, r11
bic r7, r5, r10, rrx
adds r4, r5, r11
adc r1, r7, r0, ror r12
andvs r1, r11, r9, lsl r1
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
ldr r1, =0xfed90b5a
ldr r2, =0x93fba9be
ldr r3, =0x0000ffff
ldr r4, =0x2238ef82
ldr r5, =0x12345678
ldr r6, =0x578ec106
ldr r7, =0xf8779adf
ldr r8, =0x648b83d3
ldr r9, =0x850a5e80
ldr r10, =0x0000ffff
ldr r11, =0x000000ff
ldr r12, =0x456be6ca
ldr r14, =0xeeb59aac
cmn r6, r0
orrs r14, r0, r0, lsr #12
sbc r6, r2, r6
cmplt r10, r1, asr #11
mvns r5, r3
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
ldr r0, =0x8001a256
ldr r1, =0x0000ffff
ldr r2, =0x00000002
ldr r3, =0x0000001f
ldr r4, =0x00000000
ldr r5, =0x7ffffffe
ldr r6, =0x00000020
ldr r7, =0x0000ffff
ldr r8, =0x00000002
ldr r9, =0x00000001
ldr r10, =0x00000001
ldr r11, =0x8776c75e
ldr r12, =0xf0ef99ae
ldr r14, =0x63f80888
cmp r14, r6
orr r5, r0, r3, lsl r12
cmp r1, r14, asr r1
mov r11, r10, ror r7
rscs r7, r0, r7, lsl #27
cmp r4, r9
teq r12, r4, lsr #16
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
ldr r0, =0x4e3659f5
ldr r1, =0x73a0cc99
ldr r2, =0x00000002
ldr r3, =0x05d0c333
ldr r4, =0x000000ff
ldr r5, =0x80000001
ldr r6, =0xe276d1c7
ldr r7, =0xffffffff
ldr r8, =0x0f7b07fb
ldr r9, =0x80000001
ldr r10, =0x00000101
ldr r11, =0xc6a8dbb1
ldr r12, =0x00000101
ldr r14, =0xcb361d41
cmn r10, r10
movs r4, r11, rrx
teqne r4, r12, asr r12
tst r0, r0, lsl r3
cmp r9, r8, ror r10
add r5, r14, r11, asr r1
mvns r2, r11, asr r1
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
