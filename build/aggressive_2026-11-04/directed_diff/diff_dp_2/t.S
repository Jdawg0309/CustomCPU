.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x60903562
str r0, [r12, #0]
ldr r0, =0x4eb9e4b8
str r0, [r12, #4]
ldr r0, =0x80000000
str r0, [r12, #8]
ldr r0, =0x7b3078a5
str r0, [r12, #12]
ldr r0, =0x00000101
str r0, [r12, #16]
ldr r0, =0xffffffff
str r0, [r12, #20]
ldr r0, =0x8c5a8e85
str r0, [r12, #24]
ldr r0, =0x4666b1ea
str r0, [r12, #28]
ldr r0, =0x00000101
str r0, [r12, #32]
ldr r0, =0xd950478f
str r0, [r12, #36]
ldr r0, =0x09122619
str r0, [r12, #40]
ldr r0, =0x54899cba
str r0, [r12, #44]
ldr r0, =0x79abf33a
str r0, [r12, #48]
ldr r0, =0xcd4bd2a6
str r0, [r12, #52]
ldr r0, =0x11d6fec9
str r0, [r12, #56]
ldr r0, =0xb44db3d5
str r0, [r12, #60]
ldr r0, =0x00000021
ldr r1, =0x58900bf5
ldr r2, =0xaaad4a97
ldr r3, =0x00000100
ldr r4, =0x4d20b990
ldr r5, =0x00000001
ldr r6, =0x8910ccfd
ldr r7, =0x025411e4
ldr r8, =0x022220d8
ldr r9, =0x6d6d7e05
ldr r10, =0x927ebd3e
ldr r11, =0xffffffff
ldr r12, =0x61cf6baa
ldr r14, =0xdde8fc43
tst r10, r9
mov r12, r12, ror r2
add r1, r4, r2, asr #32
movs r1, r2, lsl #17
tstvs r7, r11, rrx
cmn r14, r10, asr #31
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
ldr r0, =0x00000002
ldr r1, =0x80000000
ldr r2, =0x0000ffff
ldr r3, =0xffffffff
ldr r4, =0x0000001f
ldr r5, =0xc0411315
ldr r6, =0xdab4a122
ldr r7, =0x80000001
ldr r8, =0x7ffffffe
ldr r9, =0xdda66a9e
ldr r10, =0x562e938a
ldr r11, =0x80000000
ldr r12, =0x12345678
ldr r14, =0x00000100
tst r5, r1
ands r5, r9, r1
add r1, r6, #0x2dc0000
rsbcs r8, r12, r14, asr r10
teq r5, r1, lsr r5
and r5, r9, r10, ror r2
subs r8, r9, #0xa8000000
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
ldr r0, =0xe336ab3b
ldr r1, =0x80000000
ldr r2, =0x72e07975
ldr r3, =0x00000000
ldr r4, =0x2b33d299
ldr r5, =0xa85b4550
ldr r6, =0x00000021
ldr r7, =0x80000001
ldr r8, =0x1596ebf8
ldr r9, =0xecd8d2e7
ldr r10, =0x85731c0c
ldr r11, =0x9953946f
ldr r12, =0x00000000
ldr r14, =0xac4e68cb
teq r4, r12
bics r4, r12, r14, lsr r7
mvn r14, #0xf0000
sub r7, r11, r6, lsr r14
rsbscc r3, r5, r5, lsr r12
andshi r3, r9, r9, lsl r4
rsc r12, r8, #0x4c0
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
ldr r0, =0x913096f3
ldr r1, =0xffffffff
ldr r2, =0x99a60e3a
ldr r3, =0x476c4b53
ldr r4, =0x3ba7de82
ldr r5, =0x00000002
ldr r6, =0xbeda50d3
ldr r7, =0xf6faf64f
ldr r8, =0x80406d96
ldr r9, =0x00000100
ldr r10, =0xbb168d82
ldr r11, =0xe37e6715
ldr r12, =0x12345678
ldr r14, =0x0000001f
tst r12, r0
and r11, r5, r8, lsl r7
cmnge r8, r6, ror r0
rsbspl r4, r0, r14, ror #8
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
ldr r0, =0x8e7c9657
ldr r1, =0xd018ae7b
ldr r2, =0x6fc5dc36
ldr r3, =0x12345678
ldr r4, =0x00000001
ldr r5, =0x572e2a85
ldr r6, =0x00000002
ldr r7, =0x7fffffff
ldr r8, =0x5a5778e4
ldr r9, =0xabeaa13b
ldr r10, =0x000000ff
ldr r11, =0x79cd9c12
ldr r12, =0x2c0cba5a
ldr r14, =0x00000020
tst r6, r12
subs r12, r2, r14, asr #17
teq r12, r7, rrx
tstpl r8, r3
ands r12, r12, r10, lsl #19
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
ldr r0, =0x000000ff
ldr r1, =0x00000020
ldr r2, =0x00000000
ldr r3, =0x00000101
ldr r4, =0xff4ee553
ldr r5, =0x7fffffff
ldr r6, =0x00000002
ldr r7, =0x00000021
ldr r8, =0x7ffffffe
ldr r9, =0x1ab7a7f8
ldr r10, =0x3478e06d
ldr r11, =0x8241f952
ldr r12, =0x00000100
ldr r14, =0x15efe5db
teq r12, r5
movscc r9, r6, asr r7
adcs r0, r9, r12, asr r6
rscs r14, r1, r12, lsl #16
movs r1, r4, asr #16
adcmi r12, r2, r11, lsl r0
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
ldr r1, =0x5bd14237
ldr r2, =0x00000021
ldr r3, =0x00000000
ldr r4, =0xeea2286e
ldr r5, =0x000000ff
ldr r6, =0x00000021
ldr r7, =0xe860504d
ldr r8, =0x4e14ac21
ldr r9, =0x670f64dc
ldr r10, =0x00000001
ldr r11, =0x00000101
ldr r12, =0x0000ffff
ldr r14, =0x8d7eac66
teq r4, r5
sbccc r10, r1, r14
subs r7, r0, r9
and r10, r8, r10, asr r4
bic r6, r7, r8, lsr #24
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
ldr r0, =0x00000002
ldr r1, =0xd75bd66c
ldr r2, =0x12345678
ldr r3, =0x4feda12b
ldr r4, =0x236013c6
ldr r5, =0x152e1ff7
ldr r6, =0x00000101
ldr r7, =0x91058af4
ldr r8, =0xbd263fb1
ldr r9, =0x6105dff8
ldr r10, =0x00000020
ldr r11, =0x149532df
ldr r12, =0x2c9c9c08
ldr r14, =0xcafebabe
tst r1, r11
mvn r6, r7
mov r10, #0x3e4000
orr r3, r2, r2, rrx
rsbs r4, r3, r1
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
