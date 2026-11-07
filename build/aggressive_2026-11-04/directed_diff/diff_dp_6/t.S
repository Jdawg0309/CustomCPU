.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x00000101
str r0, [r12, #0]
ldr r0, =0x7ffffffe
str r0, [r12, #4]
ldr r0, =0x80000001
str r0, [r12, #8]
ldr r0, =0x00000002
str r0, [r12, #12]
ldr r0, =0xc21663a5
str r0, [r12, #16]
ldr r0, =0x9ecd072b
str r0, [r12, #20]
ldr r0, =0x12345678
str r0, [r12, #24]
ldr r0, =0x00000001
str r0, [r12, #28]
ldr r0, =0x12345678
str r0, [r12, #32]
ldr r0, =0x7fffffff
str r0, [r12, #36]
ldr r0, =0x0000001f
str r0, [r12, #40]
ldr r0, =0x00000100
str r0, [r12, #44]
ldr r0, =0x80000000
str r0, [r12, #48]
ldr r0, =0xefc8306d
str r0, [r12, #52]
ldr r0, =0xf0ea49ae
str r0, [r12, #56]
ldr r0, =0x594f6928
str r0, [r12, #60]
ldr r0, =0x00000020
ldr r1, =0xccf4ace4
ldr r2, =0x060f6adb
ldr r3, =0x14bd4293
ldr r4, =0x7fffffff
ldr r5, =0xe8105f44
ldr r6, =0x7fffffff
ldr r7, =0x7f5a0b4c
ldr r8, =0x00000101
ldr r9, =0x245dad0f
ldr r10, =0x000000ff
ldr r11, =0x00000020
ldr r12, =0x00000002
ldr r14, =0x80000001
tst r2, r11
eorsvs r0, r6, r12, lsr #17
andsle r11, r14, #0xb9
mvn r4, r3, lsl #16
cmp r9, r11, ror #28
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
ldr r0, =0x15af9cfb
ldr r1, =0x7056936a
ldr r2, =0x80000000
ldr r3, =0x7ffffffe
ldr r4, =0x00000001
ldr r5, =0x000000ff
ldr r6, =0xcafebabe
ldr r7, =0xac0d39e1
ldr r8, =0x00000021
ldr r9, =0x0000001f
ldr r10, =0x000000ff
ldr r11, =0x7fffffff
ldr r12, =0x810bb1ee
ldr r14, =0xcafebabe
cmp r12, r2
eors r2, r5, r12, ror r3
cmnge r14, r2, lsr r0
orrs r8, r8, r5, ror r10
tst r1, #0x40000032
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
ldr r0, =0xd0268dde
ldr r1, =0x00000002
ldr r2, =0xad3e2270
ldr r3, =0x00000100
ldr r4, =0x46f7173f
ldr r5, =0x675280c1
ldr r6, =0x7fffffff
ldr r7, =0xb045a593
ldr r8, =0x00000100
ldr r9, =0x0000001f
ldr r10, =0x80000001
ldr r11, =0xfc2c1b5e
ldr r12, =0x80000000
ldr r14, =0x906904b3
teq r10, r1
subslt r12, r1, #0x300000
addsle r8, r12, #0x50000002
sbcs r12, r5, r11, lsr r2
orr r1, r5, r4, asr r9
add r5, r12, r2, lsl r4
cmn r14, r3, asr #31
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
ldr r0, =0x00000020
ldr r1, =0x873f65a4
ldr r2, =0x707b03d8
ldr r3, =0xffffffff
ldr r4, =0xeef42380
ldr r5, =0x6bc76d30
ldr r6, =0x07c8f07a
ldr r7, =0x1b08ffd4
ldr r8, =0x00000021
ldr r9, =0xf1bfcf12
ldr r10, =0x7fffffff
ldr r11, =0x7ffffffe
ldr r12, =0x0000ffff
ldr r14, =0x00000002
cmn r3, r4
rsc r7, r14, r5, lsr r9
ands r4, r7, r9
rsb r9, r14, #0x14
cmngt r14, r3, asr r7
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
ldr r0, =0x80000001
ldr r1, =0x7fffffff
ldr r2, =0x00000101
ldr r3, =0x3ee55ffe
ldr r4, =0xa0b3dd25
ldr r5, =0x8988fef7
ldr r6, =0x12345678
ldr r7, =0xa9583371
ldr r8, =0xa6d2ac20
ldr r9, =0x00000021
ldr r10, =0x49b06ab8
ldr r11, =0x12345678
ldr r12, =0x00000000
ldr r14, =0x00000021
teq r9, r12
subs r12, r14, #0x21000000
eors r6, r8, r1, ror r7
bic r14, r6, r7, asr #27
cmp r1, r0, lsl r4
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
ldr r0, =0xddbdbe53
ldr r1, =0x683860ef
ldr r2, =0xd8685a87
ldr r3, =0x00000002
ldr r4, =0x00000020
ldr r5, =0x80000000
ldr r6, =0x80000000
ldr r7, =0xe75e7f9a
ldr r8, =0xffffffff
ldr r9, =0x33afdfc4
ldr r10, =0x12345678
ldr r11, =0x00000002
ldr r12, =0xae09b552
ldr r14, =0x253f0728
teq r7, r4
movgt r9, r8, rrx
teqge r11, r4
movs r3, r7, asr #22
mov r5, r2
rsbs r1, r12, r6, ror #5
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
ldr r0, =0x80000001
ldr r1, =0x00000000
ldr r2, =0x1be1dfba
ldr r3, =0x0000ffff
ldr r4, =0x743e4008
ldr r5, =0x00000001
ldr r6, =0x00000020
ldr r7, =0x843bb537
ldr r8, =0x7fffffff
ldr r9, =0x74a74345
ldr r10, =0xb55c55b5
ldr r11, =0x0000ffff
ldr r12, =0x00000101
ldr r14, =0x28d799df
teq r4, r14
tst r5, #0x3c8000
sub r11, r14, #0x3f00000
sublt r6, r11, #0xb900000
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
ldr r0, =0x80000000
ldr r1, =0x00000000
ldr r2, =0xcafebabe
ldr r3, =0x5a1635b0
ldr r4, =0x00000021
ldr r5, =0x12345678
ldr r6, =0x9b954bf3
ldr r7, =0xdbb2b643
ldr r8, =0x7ffffffe
ldr r9, =0x00000002
ldr r10, =0x7fffffff
ldr r11, =0x0000ffff
ldr r12, =0x79c1be41
ldr r14, =0x00000021
tst r7, r4
tstcs r14, r0, lsr r1
rscs r0, r9, r9, asr r4
mvns r9, r6, ror r2
cmn r10, r11, lsl r11
and r0, r4, r5, lsr r9
eors r2, r12, r9
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
