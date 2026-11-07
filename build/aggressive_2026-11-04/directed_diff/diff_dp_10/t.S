.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x6717407f
str r0, [r12, #0]
ldr r0, =0x9b28c141
str r0, [r12, #4]
ldr r0, =0x3b56fcd7
str r0, [r12, #8]
ldr r0, =0xf5508678
str r0, [r12, #12]
ldr r0, =0x67494698
str r0, [r12, #16]
ldr r0, =0x2e69f6fe
str r0, [r12, #20]
ldr r0, =0xa0a5b4c4
str r0, [r12, #24]
ldr r0, =0x0000001f
str r0, [r12, #28]
ldr r0, =0xa91ca437
str r0, [r12, #32]
ldr r0, =0x00000002
str r0, [r12, #36]
ldr r0, =0x00000021
str r0, [r12, #40]
ldr r0, =0x1aa54f67
str r0, [r12, #44]
ldr r0, =0x76ee047b
str r0, [r12, #48]
ldr r0, =0xf5feff42
str r0, [r12, #52]
ldr r0, =0xbfa586a3
str r0, [r12, #56]
ldr r0, =0x00000020
str r0, [r12, #60]
ldr r0, =0x0000ffff
ldr r1, =0x11a36546
ldr r2, =0x8ebaaf73
ldr r3, =0x00000000
ldr r4, =0x777189dc
ldr r5, =0x12345678
ldr r6, =0x7ffffffe
ldr r7, =0x9465add9
ldr r8, =0x80000001
ldr r9, =0x7fffffff
ldr r10, =0x12345678
ldr r11, =0x80000001
ldr r12, =0x0000001f
ldr r14, =0x80000000
cmn r3, r3
cmp r7, r5, ror #13
cmpcc r7, r7, asr r7
subgt r7, r2, r4
movvc r6, r8, lsl r4
mvnseq r0, r11, asr r14
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
ldr r1, =0x7fffffff
ldr r2, =0xeec35d3a
ldr r3, =0x11d56a3e
ldr r4, =0x00000002
ldr r5, =0x7b2c51d9
ldr r6, =0xd2ad9f88
ldr r7, =0xfb4a8ef1
ldr r8, =0x0000ffff
ldr r9, =0x00000001
ldr r10, =0x00000020
ldr r11, =0xa8bbe82e
ldr r12, =0x71669112
ldr r14, =0xf84b57aa
cmn r8, r6
addsle r10, r5, #0xd6000
cmp r14, r14, lsr r6
bic r4, r10, #0x100
mvnshi r8, r8, lsl r0
subsle r5, r3, r4
tstlt r3, r12, lsl #16
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
ldr r0, =0xdfe22c14
ldr r1, =0x00000020
ldr r2, =0x00000001
ldr r3, =0xf1867d31
ldr r4, =0x80000000
ldr r5, =0x00000021
ldr r6, =0xcafebabe
ldr r7, =0xcac35a30
ldr r8, =0x7b755333
ldr r9, =0x12345678
ldr r10, =0xffffffff
ldr r11, =0x608651c7
ldr r12, =0x0000001f
ldr r14, =0xe7515d16
tst r0, r2
adc r0, r11, r5, rrx
mvnsvc r9, r10, lsr r1
teq r2, r14, asr #11
adcsls r11, r7, r5, lsr #9
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
ldr r0, =0xcafebabe
ldr r1, =0xee6537ed
ldr r2, =0x00000020
ldr r3, =0x80000001
ldr r4, =0x5eccf4d5
ldr r5, =0x48d9ff77
ldr r6, =0xb8bcffc3
ldr r7, =0x49d069a6
ldr r8, =0xd0203cb7
ldr r9, =0x2d290c2b
ldr r10, =0x7fffffff
ldr r11, =0x33c8d528
ldr r12, =0x43c0f84b
ldr r14, =0x3ad38ddf
cmp r3, r10
cmp r6, r9, lsr #8
mvn r8, r0, lsl #11
bics r0, r0, r5, lsl r6
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
ldr r0, =0x1d6a672c
ldr r1, =0x80000000
ldr r2, =0x7fffffff
ldr r3, =0x98d3fc54
ldr r4, =0x00000001
ldr r5, =0x00000021
ldr r6, =0x54489629
ldr r7, =0xcb20f291
ldr r8, =0x00000100
ldr r9, =0x0000ffff
ldr r10, =0x7ffffffe
ldr r11, =0x78ff470c
ldr r12, =0x7fba5af2
ldr r14, =0xf4d10021
tst r4, r0
and r12, r3, #0x550
add r11, r2, r14
adds r4, r3, r4, ror r0
cmn r5, r10, lsl r14
cmn r1, r9, lsr #19
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
ldr r1, =0x99c29f9b
ldr r2, =0x3a891c1e
ldr r3, =0xca9ceed4
ldr r4, =0x7fffffff
ldr r5, =0x02d776b8
ldr r6, =0x00000021
ldr r7, =0xdda978d4
ldr r8, =0x44772e93
ldr r9, =0x467b3f72
ldr r10, =0x2f0632c3
ldr r11, =0x00000000
ldr r12, =0x00000000
ldr r14, =0x000000ff
teq r8, r2
rsbs r9, r2, r7, asr #7
sbc r2, r1, r14, ror #18
andle r2, r3, r6, lsr r14
adds r12, r12, r14, lsl #19
ands r1, r11, r10, rrx
cmn r7, r2
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
ldr r0, =0x00000002
ldr r1, =0x00000000
ldr r2, =0xb9e15883
ldr r3, =0x00000000
ldr r4, =0xb0a32ef0
ldr r5, =0x00000100
ldr r6, =0x6c683873
ldr r7, =0x0000ffff
ldr r8, =0x0be4b695
ldr r9, =0xb0b46eec
ldr r10, =0x00000001
ldr r11, =0xacb1ec10
ldr r12, =0xb74bec60
ldr r14, =0x000000ff
cmp r6, r4
sbcspl r0, r12, r7, lsl #26
adds r1, r5, r4, lsl r2
teqls r6, r6, lsr #20
eor r6, r10, r9, asr r14
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
ldr r0, =0x826d773f
ldr r1, =0x00000001
ldr r2, =0x600ccc54
ldr r3, =0xaf664b81
ldr r4, =0x33d5061b
ldr r5, =0x7ffffffe
ldr r6, =0x0692e97a
ldr r7, =0x78cda7ff
ldr r8, =0x00000021
ldr r9, =0x000000ff
ldr r10, =0x64276115
ldr r11, =0x83a3e62c
ldr r12, =0xbf52a742
ldr r14, =0x8744395f
cmn r0, r2
orr r11, r1, r11, ror #18
andseq r9, r5, r12, rrx
adcs r1, r12, r12, rrx
teq r10, r10, lsl r5
adds r9, r0, r8
subs r5, r2, r12, asr r12
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
