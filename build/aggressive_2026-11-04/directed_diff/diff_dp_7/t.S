.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x7ffffffe
str r0, [r12, #0]
ldr r0, =0x00000000
str r0, [r12, #4]
ldr r0, =0x0000ffff
str r0, [r12, #8]
ldr r0, =0x000000ff
str r0, [r12, #12]
ldr r0, =0x92586b7a
str r0, [r12, #16]
ldr r0, =0x571dc305
str r0, [r12, #20]
ldr r0, =0x00000002
str r0, [r12, #24]
ldr r0, =0x00000020
str r0, [r12, #28]
ldr r0, =0x00000021
str r0, [r12, #32]
ldr r0, =0xcafebabe
str r0, [r12, #36]
ldr r0, =0x04c27aa6
str r0, [r12, #40]
ldr r0, =0x7fffffff
str r0, [r12, #44]
ldr r0, =0x7fffffff
str r0, [r12, #48]
ldr r0, =0x80000001
str r0, [r12, #52]
ldr r0, =0x000000ff
str r0, [r12, #56]
ldr r0, =0x12345678
str r0, [r12, #60]
ldr r0, =0x1d31f123
ldr r1, =0xe2fe2e5a
ldr r2, =0x00000020
ldr r3, =0xba64863d
ldr r4, =0x443f2673
ldr r5, =0xfc4fa852
ldr r6, =0xda1e4115
ldr r7, =0x000000ff
ldr r8, =0x8bcf09e7
ldr r9, =0xef5902cc
ldr r10, =0x8f691b36
ldr r11, =0xf4447d3f
ldr r12, =0x574cd153
ldr r14, =0x7ffffffe
teq r3, r6
sbc r10, r6, #0x230
orr r0, r1, r1
mvn r11, r10
orrs r1, r0, #0x200000
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
ldr r0, =0xbb8fc0f3
ldr r1, =0xcafebabe
ldr r2, =0x6a7413dc
ldr r3, =0xa1416da8
ldr r4, =0x00000001
ldr r5, =0x7ffffffe
ldr r6, =0x7217c860
ldr r7, =0xffffffff
ldr r8, =0x00000020
ldr r9, =0x03c8c3de
ldr r10, =0x89dab7c2
ldr r11, =0x0ff3f3a4
ldr r12, =0x7ffffffe
ldr r14, =0x12345678
teq r11, r5
cmp r6, r11, lsr #11
rscsls r6, r10, #0x2b000000
cmphi r6, r14, lsr r6
rsc r11, r7, #0x940000
eorlt r1, r1, r6, lsl #13
eors r5, r3, r11, lsl #5
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
ldr r1, =0x00000000
ldr r2, =0x968c5b55
ldr r3, =0xcafebabe
ldr r4, =0x2255c2de
ldr r5, =0x00000001
ldr r6, =0xe1656af9
ldr r7, =0x00000001
ldr r8, =0x00000001
ldr r9, =0x660faae9
ldr r10, =0xcafebabe
ldr r11, =0x41df3424
ldr r12, =0x7ffffffe
ldr r14, =0x1ecd4d8f
cmn r8, r12
mov r0, r10
cmn r0, r12, lsr #14
rsbseq r4, r3, r6, ror #25
and r12, r2, r11, lsl #13
teq r12, r7, asr r14
sbcs r4, r8, r12
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
ldr r1, =0x80000001
ldr r2, =0x0e74b7ce
ldr r3, =0x075d01f3
ldr r4, =0x51d5db0a
ldr r5, =0xc510d384
ldr r6, =0x00000020
ldr r7, =0x00000020
ldr r8, =0x00000021
ldr r9, =0x97894509
ldr r10, =0x4d94b6d6
ldr r11, =0x00000000
ldr r12, =0x80000001
ldr r14, =0x6b83158d
cmp r7, r11
bics r10, r14, #0x10c0000
subslt r7, r6, r8, rrx
bic r11, r10, r14, asr #10
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
ldr r0, =0x62c4349f
ldr r1, =0x00000020
ldr r2, =0x0ba4a801
ldr r3, =0x80000001
ldr r4, =0xc9ac7e19
ldr r5, =0x00000021
ldr r6, =0x00000000
ldr r7, =0xae598b48
ldr r8, =0x75141c46
ldr r9, =0x80000000
ldr r10, =0x80000001
ldr r11, =0x81f810cf
ldr r12, =0x00000020
ldr r14, =0xaf3622ac
cmp r6, r9
mvnlt r1, r2, lsr r9
mvn r4, r5, asr #29
adds r0, r1, #0x1c800000
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
ldr r0, =0x484e82ac
ldr r1, =0x3816cbd4
ldr r2, =0x80000001
ldr r3, =0x0000ffff
ldr r4, =0x422f68ea
ldr r5, =0x263a8edb
ldr r6, =0xfce697c0
ldr r7, =0x00000002
ldr r8, =0x7ffffffe
ldr r9, =0x37e0aed9
ldr r10, =0xffffffff
ldr r11, =0xa47e465a
ldr r12, =0x7fffffff
ldr r14, =0x80000001
cmn r2, r14
cmp r14, r6, lsr r3
movs r6, r12, rrx
adcsmi r5, r2, r5
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
ldr r0, =0xcc0f6cd0
ldr r1, =0x3eaa4284
ldr r2, =0xd0dba21e
ldr r3, =0x0000001f
ldr r4, =0xb89cfbee
ldr r5, =0x00000100
ldr r6, =0x00000020
ldr r7, =0x80000001
ldr r8, =0x805a6dae
ldr r9, =0x39a4898e
ldr r10, =0x0000ffff
ldr r11, =0x00000001
ldr r12, =0x00000101
ldr r14, =0x0eda2c47
cmn r12, r6
cmn r5, #0x4000000d
andle r0, r6, r12
cmn r10, #0x2c00
orrshi r8, r5, r8
add r14, r7, r5, asr #22
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
ldr r0, =0x22418092
ldr r1, =0xa4dba807
ldr r2, =0x908bffff
ldr r3, =0x00000101
ldr r4, =0x0000ffff
ldr r5, =0xf11abeb3
ldr r6, =0x12345678
ldr r7, =0xb1745265
ldr r8, =0x2dc5350e
ldr r9, =0xf1da84af
ldr r10, =0xf2954f73
ldr r11, =0xcfba4b13
ldr r12, =0x00000020
ldr r14, =0x7fffffff
tst r1, r2
sbcs r2, r6, r4, ror r9
cmp r11, r3, lsl #24
cmpls r2, r6, lsr r8
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
