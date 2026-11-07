.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x0000ffff
str r0, [r12, #0]
ldr r0, =0x00000002
str r0, [r12, #4]
ldr r0, =0xa6956374
str r0, [r12, #8]
ldr r0, =0x0000001f
str r0, [r12, #12]
ldr r0, =0x00000020
str r0, [r12, #16]
ldr r0, =0x799ed755
str r0, [r12, #20]
ldr r0, =0x00000021
str r0, [r12, #24]
ldr r0, =0xe6643ea2
str r0, [r12, #28]
ldr r0, =0x00000002
str r0, [r12, #32]
ldr r0, =0x7ffffffe
str r0, [r12, #36]
ldr r0, =0xcafebabe
str r0, [r12, #40]
ldr r0, =0xcafebabe
str r0, [r12, #44]
ldr r0, =0x0f3e8964
str r0, [r12, #48]
ldr r0, =0x00000101
str r0, [r12, #52]
ldr r0, =0x00000002
str r0, [r12, #56]
ldr r0, =0x4665094f
str r0, [r12, #60]
ldr r0, =0x7fc6cd57
ldr r1, =0x000000ff
ldr r2, =0x00000021
ldr r3, =0xcd2c00ec
ldr r4, =0x00000100
ldr r5, =0x80000000
ldr r6, =0xcfce44a2
ldr r7, =0x5a2281cb
ldr r8, =0x1fd7a2cb
ldr r9, =0xcecf5607
ldr r10, =0x00000002
ldr r11, =0xd2c035a1
ldr r12, =0x7ffffffe
ldr r14, =0x7ffffffe
cmp r0, r9
rsbs r0, r11, r8, lsr r12
rscsge r2, r5, r0, ror r14
tst r0, r3, lsl r1
andspl r5, r12, r0
mvnscc r8, r1
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
ldr r0, =0x80000001
ldr r1, =0xce2e180b
ldr r2, =0x97ec1e51
ldr r3, =0x1159398f
ldr r4, =0x00000002
ldr r5, =0x768b1e59
ldr r6, =0x14db7389
ldr r7, =0x12345678
ldr r8, =0xa422aa42
ldr r9, =0x0000001f
ldr r10, =0xb2e0e637
ldr r11, =0x00000021
ldr r12, =0xd5482ca1
ldr r14, =0x80000001
tst r12, r10
and r8, r3, #0x2000
cmp r10, #0x2800000
rsb r0, r8, r5, asr #17
cmn r2, #0xd8000000
cmn r0, r14
mvnsgt r0, #0x94
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
ldr r0, =0x00000001
ldr r1, =0x000000ff
ldr r2, =0x1a298c86
ldr r3, =0x349e6edb
ldr r4, =0xe3f2866a
ldr r5, =0x563bc1c6
ldr r6, =0x20e09da4
ldr r7, =0x7ffffffe
ldr r8, =0x494b2fe2
ldr r9, =0x8af83bb2
ldr r10, =0xc7d9a916
ldr r11, =0xffffffff
ldr r12, =0x80000000
ldr r14, =0x00000001
cmp r1, r8
rsbsne r10, r12, r5
bic r5, r2, r7, lsl r8
subs r14, r5, r10, ror #11
teqne r0, r9, lsl r3
orr r6, r4, r11
teqpl r7, r10, lsl #30
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
ldr r0, =0x7fffffff
ldr r1, =0xcafebabe
ldr r2, =0x5c0a5422
ldr r3, =0x00000001
ldr r4, =0x00000001
ldr r5, =0x5451c51c
ldr r6, =0x000000ff
ldr r7, =0x80000001
ldr r8, =0x85d62c01
ldr r9, =0xfa121983
ldr r10, =0x4cf665ab
ldr r11, =0x12345678
ldr r12, =0x000000ff
ldr r14, =0x00000002
cmp r1, r5
teq r11, r12
rsbs r9, r12, #0xa40
subne r8, r3, r5, rrx
add r0, r10, #0x1f000000
subs r10, r2, r5, lsl #24
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
ldr r0, =0x00000000
ldr r1, =0x00000100
ldr r2, =0x00000000
ldr r3, =0x43dd792f
ldr r4, =0x136097cb
ldr r5, =0x00000100
ldr r6, =0xb86902dd
ldr r7, =0x80000001
ldr r8, =0xe852eb06
ldr r9, =0xd30cb0c6
ldr r10, =0x000000ff
ldr r11, =0xcec4812c
ldr r12, =0x00000002
ldr r14, =0xc50fd55c
cmp r14, r6
mov r12, r12, ror r11
sbc r14, r12, r0, lsr #29
rsc r1, r14, r9
sub r1, r12, r4, lsl #3
biccc r12, r5, r3, lsr #1
bics r4, r6, r0, ror #16
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
ldr r0, =0x80000000
ldr r1, =0x93c68104
ldr r2, =0x7fffffff
ldr r3, =0x0000001f
ldr r4, =0x000000ff
ldr r5, =0x00000020
ldr r6, =0x00000021
ldr r7, =0x542cf983
ldr r8, =0x00000001
ldr r9, =0x80000001
ldr r10, =0x00000021
ldr r11, =0xb2a40f3c
ldr r12, =0x00000000
ldr r14, =0x0000ffff
cmn r11, r1
sbcs r1, r9, r6
cmnge r6, r14
orr r14, r12, r12, asr r10
teq r1, #0xb3
rscvc r7, r10, r7, ror #20
subs r0, r2, r0, lsl r1
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
ldr r0, =0x1b32c8e5
ldr r1, =0xf3457a95
ldr r2, =0x60ceb52b
ldr r3, =0x0000ffff
ldr r4, =0x80000000
ldr r5, =0xea406955
ldr r6, =0x00000020
ldr r7, =0x0000001f
ldr r8, =0x1f56c86f
ldr r9, =0x000000ff
ldr r10, =0x80000000
ldr r11, =0x7ffffffe
ldr r12, =0x03265ffb
ldr r14, =0x00000002
tst r8, r14
bic r3, r11, r8, ror r5
teq r1, r7, lsr r14
bicsvc r3, r8, r8, lsl r8
teq r11, #0xb00000
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
ldr r0, =0xd49932d1
ldr r1, =0x12345678
ldr r2, =0x12345678
ldr r3, =0x660b3cfa
ldr r4, =0x8678524a
ldr r5, =0x00000021
ldr r6, =0x64c03f2b
ldr r7, =0xffffffff
ldr r8, =0x00000100
ldr r9, =0x4a7cacc5
ldr r10, =0xcafebabe
ldr r11, =0x80000000
ldr r12, =0x000000ff
ldr r14, =0xde080d21
tst r5, r4
rsb r2, r0, #0x22000000
movscc r11, r4, lsr #19
add r3, r3, #0xec000002
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
