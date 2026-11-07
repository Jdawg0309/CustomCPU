.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000000
str r0, [r12, #0]
ldr r0, =0x306944cf
str r0, [r12, #4]
ldr r0, =0x0000ffff
str r0, [r12, #8]
ldr r0, =0x12345678
str r0, [r12, #12]
ldr r0, =0x24646dea
str r0, [r12, #16]
ldr r0, =0x00000002
str r0, [r12, #20]
ldr r0, =0x00000000
str r0, [r12, #24]
ldr r0, =0x7fffffff
str r0, [r12, #28]
ldr r0, =0x715a6b16
str r0, [r12, #32]
ldr r0, =0xffffffff
str r0, [r12, #36]
ldr r0, =0x66aec166
str r0, [r12, #40]
ldr r0, =0x80000000
str r0, [r12, #44]
ldr r0, =0x00000021
str r0, [r12, #48]
ldr r0, =0x4b697ae9
str r0, [r12, #52]
ldr r0, =0x00000002
str r0, [r12, #56]
ldr r0, =0x000000ff
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0xbf3414d8
ldr r2, =0x00000000
ldr r3, =0xe67c9d38
ldr r4, =0x8f67d7ef
ldr r5, =0x3de0a56d
ldr r6, =0x00000101
ldr r7, =0x8a1950a4
ldr r8, =0x3d42fe85
ldr r9, =0x0000ffff
ldr r10, =0x000000ff
ldr r11, =0xb06bff59
ldr r12, =0xcafebabe
ldr r14, =0xa5532f68
cmn r9, r12
tst r11, #0x40000
adc r11, r5, r2, lsl r12
add r12, r14, r14
adcle r9, r5, r3
sbcs r8, r0, r1, lsl r10
adcs r0, r2, r2, lsl r12
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
ldr r0, =0xcafebabe
ldr r1, =0x00000020
ldr r2, =0x9c23ed71
ldr r3, =0xdf53c945
ldr r4, =0x031dad19
ldr r5, =0x6b4febe6
ldr r6, =0x95725415
ldr r7, =0x7ffffffe
ldr r8, =0x7fffffff
ldr r9, =0x7fffffff
ldr r10, =0x41735f05
ldr r11, =0x4ee9b62c
ldr r12, =0xffb183a8
ldr r14, =0x56b721e3
tst r0, r14
cmn r1, r0
tst r6, r0, lsl r1
sbc r9, r3, r5, asr #3
sbcvs r14, r11, r5, lsl r0
tst r0, r12, lsl #5
eorne r9, r9, r10, ror r6
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
ldr r0, =0xa6b481b5
ldr r1, =0x12345678
ldr r2, =0xcafebabe
ldr r3, =0x7fffffff
ldr r4, =0xd2476209
ldr r5, =0x7ffffffe
ldr r6, =0x209faaac
ldr r7, =0x61572060
ldr r8, =0x0000ffff
ldr r9, =0x1239cba6
ldr r10, =0x68016256
ldr r11, =0x9f8fe05e
ldr r12, =0x00000021
ldr r14, =0x43f4321b
teq r9, r9
bichi r7, r10, r14, ror #25
rscs r4, r9, r7, lsl #13
biceq r14, r14, r3, asr #6
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
ldr r0, =0x01fc9506
ldr r1, =0x6afb6f22
ldr r2, =0x00000001
ldr r3, =0xbbc0b9d1
ldr r4, =0x833f4a45
ldr r5, =0x944b7a36
ldr r6, =0x0c3c2d66
ldr r7, =0x12345678
ldr r8, =0x74763314
ldr r9, =0xcafebabe
ldr r10, =0xb502fa45
ldr r11, =0x8deb84eb
ldr r12, =0x12345678
ldr r14, =0xe0ca1065
teq r12, r9
rsbs r2, r4, r4, ror r0
sbcspl r2, r8, r0, lsr #14
bics r5, r3, r3, lsl r2
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
ldr r1, =0x7fffffff
ldr r2, =0x4b103000
ldr r3, =0x0000ffff
ldr r4, =0x336a4caf
ldr r5, =0x28553f24
ldr r6, =0x00000021
ldr r7, =0x9dbdcc50
ldr r8, =0xb28e05d5
ldr r9, =0x84f7f808
ldr r10, =0x000000ff
ldr r11, =0x0000001f
ldr r12, =0x20360e32
ldr r14, =0x5a9dcb7d
teq r12, r14
rscs r4, r3, #0x6800
eorsgt r7, r8, r4
teqle r8, r14, lsr #14
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
ldr r0, =0x80000001
ldr r1, =0x00000001
ldr r2, =0x00000002
ldr r3, =0x00000021
ldr r4, =0x00000002
ldr r5, =0xf3d6b248
ldr r6, =0x00000020
ldr r7, =0x00000021
ldr r8, =0x00000101
ldr r9, =0x7ffffffe
ldr r10, =0x00000020
ldr r11, =0x00000000
ldr r12, =0x08090662
ldr r14, =0x215d76fd
tst r3, r6
rscs r1, r6, r2, lsr r9
mvns r0, #0x83000
teq r3, #0x174
orrhi r8, r1, r4
teq r0, #0x78000001
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
ldr r0, =0x0c05eb4e
ldr r1, =0x80000001
ldr r2, =0x00000100
ldr r3, =0xa46c582a
ldr r4, =0x00000020
ldr r5, =0x7579e8dd
ldr r6, =0x7ffffffe
ldr r7, =0x875a428c
ldr r8, =0x7ffffffe
ldr r9, =0xdb9a81e2
ldr r10, =0x000000ff
ldr r11, =0x00000101
ldr r12, =0x00000021
ldr r14, =0x000000ff
cmp r0, r3
cmn r12, r8, lsl #5
rsc r1, r8, r0
sbcs r2, r5, r7, asr #1
eors r11, r3, #0x3fc0
mvn r14, r2, lsl #27
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
ldr r0, =0x0a8d6739
ldr r1, =0x12345678
ldr r2, =0xcafebabe
ldr r3, =0x8d5d3701
ldr r4, =0x80000000
ldr r5, =0x508eb742
ldr r6, =0xaeb64ed8
ldr r7, =0x7f67d99a
ldr r8, =0x395c6095
ldr r9, =0x00000000
ldr r10, =0x9df75eca
ldr r11, =0x5de615c1
ldr r12, =0x4cb34ec6
ldr r14, =0x00000020
teq r5, r2
mvns r9, r10, asr r2
ands r11, r10, r5, lsr #4
bic r2, r8, r0, asr #15
eorlt r9, r2, r6, lsr r8
cmnls r2, r6, ror r1
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
