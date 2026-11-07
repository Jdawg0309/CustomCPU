.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x506e1217
str r0, [r12, #0]
ldr r0, =0x00000100
str r0, [r12, #4]
ldr r0, =0xd23c1a3b
str r0, [r12, #8]
ldr r0, =0xcce7a64f
str r0, [r12, #12]
ldr r0, =0x00000101
str r0, [r12, #16]
ldr r0, =0x541eaff5
str r0, [r12, #20]
ldr r0, =0x9ee043ea
str r0, [r12, #24]
ldr r0, =0x7ffffffe
str r0, [r12, #28]
ldr r0, =0x436cfd40
str r0, [r12, #32]
ldr r0, =0x00000101
str r0, [r12, #36]
ldr r0, =0x0000001f
str r0, [r12, #40]
ldr r0, =0x5f4d93cd
str r0, [r12, #44]
ldr r0, =0xffffffff
str r0, [r12, #48]
ldr r0, =0xb92e4af8
str r0, [r12, #52]
ldr r0, =0x00000100
str r0, [r12, #56]
ldr r0, =0x00000101
str r0, [r12, #60]
ldr r0, =0x12345678
ldr r1, =0xaedf7a3e
ldr r2, =0x3ea60953
ldr r3, =0x6b83ba50
ldr r4, =0x60df4320
ldr r5, =0x00000000
ldr r6, =0x664fd318
ldr r7, =0x60132345
ldr r8, =0x80000001
ldr r9, =0xcafebabe
ldr r10, =0x12345678
ldr r11, =0x0000001f
ldr r12, =0x00000100
ldr r14, =0x158cbaf2
tst r8, r2
addpl r4, r12, r6, lsl r7
movs r14, r9, asr r4
sbcs r9, r3, r12, ror r3
adcs r3, r5, r3, rrx
subs r4, r5, r9, lsr r9
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
ldr r0, =0xc22b9262
ldr r1, =0x000000ff
ldr r2, =0x00000001
ldr r3, =0x7a284fa5
ldr r4, =0x248867ca
ldr r5, =0xcafebabe
ldr r6, =0x00000000
ldr r7, =0x00000020
ldr r8, =0x7fffffff
ldr r9, =0x7ffffffe
ldr r10, =0x80000001
ldr r11, =0x433c1203
ldr r12, =0x7ffffffe
ldr r14, =0x636657a3
teq r14, r2
eor r11, r5, r4, rrx
adc r6, r12, r0, asr #21
adds r10, r7, r5, ror #22
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
ldr r0, =0x27ea55b7
ldr r1, =0x7fffffff
ldr r2, =0x00000100
ldr r3, =0xcafebabe
ldr r4, =0xe174d4ff
ldr r5, =0xc5a29afc
ldr r6, =0xdf57550b
ldr r7, =0xc4cab0ce
ldr r8, =0xf80a3d63
ldr r9, =0x70814316
ldr r10, =0xdeb9b949
ldr r11, =0x30be5f83
ldr r12, =0xbd32ce88
ldr r14, =0x7abc64fb
cmn r12, r1
subsvs r8, r4, r2, ror #14
rsb r11, r1, r11, ror r2
eors r14, r0, r8
movscs r0, r12, lsr r7
teq r5, r7, lsl #30
sbc r9, r3, r9, lsl r3
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
ldr r0, =0x00000101
ldr r1, =0x52ac292c
ldr r2, =0xe924db2e
ldr r3, =0x7f110677
ldr r4, =0xf4913a01
ldr r5, =0x74150b6c
ldr r6, =0x5a3cda7c
ldr r7, =0xb191cd32
ldr r8, =0x000000ff
ldr r9, =0x1cb946f7
ldr r10, =0x23185a96
ldr r11, =0x00000002
ldr r12, =0x00000001
ldr r14, =0x00000001
tst r1, r7
tstcs r7, r2, lsr r0
eors r9, r8, r5, lsl #1
tst r12, r12, lsl r0
adcs r0, r8, r9, rrx
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
ldr r0, =0xffffffff
ldr r1, =0x7ffffffe
ldr r2, =0xc5930b19
ldr r3, =0x80000001
ldr r4, =0x80000001
ldr r5, =0x56ca2a7b
ldr r6, =0x7ffffffe
ldr r7, =0x00000002
ldr r8, =0xf5c08092
ldr r9, =0x28501b25
ldr r10, =0x7ffffffe
ldr r11, =0x00000020
ldr r12, =0x7fffffff
ldr r14, =0xd1890005
tst r4, r2
rsbs r8, r6, r4
teqge r3, #0x28c00
bicgt r14, r3, #0xf0000006
subs r12, r7, r4, ror r10
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
ldr r0, =0xa93c3862
ldr r1, =0x00000001
ldr r2, =0xd5aeffc8
ldr r3, =0xbd40f1a1
ldr r4, =0x00000002
ldr r5, =0x000000ff
ldr r6, =0x12345678
ldr r7, =0x4fb846e9
ldr r8, =0xa81bc868
ldr r9, =0x0fa6a78b
ldr r10, =0x22a05bf5
ldr r11, =0x0000ffff
ldr r12, =0x0000001f
ldr r14, =0x040c088c
cmn r14, r7
orrhi r10, r8, r5, ror #27
cmp r2, r14, lsl #28
rsc r8, r10, r3
eor r3, r9, r0, asr #1
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
ldr r0, =0x3be29407
ldr r1, =0x00000021
ldr r2, =0x00000020
ldr r3, =0xd232480d
ldr r4, =0x27d00eb4
ldr r5, =0x686918f9
ldr r6, =0x00000002
ldr r7, =0x00000002
ldr r8, =0x7ffffffe
ldr r9, =0xe2a462cf
ldr r10, =0xf4859d0a
ldr r11, =0xe94fffa4
ldr r12, =0x80000001
ldr r14, =0x0000001f
cmp r2, r11
cmp r6, r0
orrs r14, r7, #0x1e0
mvn r0, r12, asr r10
sbcsls r0, r12, #0x9600
mvns r12, r1, lsr r11
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
ldr r0, =0x84516352
ldr r1, =0x00000021
ldr r2, =0x80000001
ldr r3, =0x00000101
ldr r4, =0x54f23e01
ldr r5, =0xc9673d0b
ldr r6, =0x333f48be
ldr r7, =0x35085f30
ldr r8, =0x80000000
ldr r9, =0x3731619b
ldr r10, =0x9d5023d8
ldr r11, =0x00000002
ldr r12, =0x644c65d7
ldr r14, =0xdadc41cd
tst r8, r0
orrs r8, r3, #0x14
rscs r8, r3, r1, lsl r1
rsbshi r3, r10, r3, rrx
cmnpl r9, r11, asr r11
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
