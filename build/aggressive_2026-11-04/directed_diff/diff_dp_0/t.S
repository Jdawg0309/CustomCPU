.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x14bf681b
str r0, [r12, #0]
ldr r0, =0xa3fc6b7d
str r0, [r12, #4]
ldr r0, =0x8ff4671c
str r0, [r12, #8]
ldr r0, =0x80000001
str r0, [r12, #12]
ldr r0, =0xca597e87
str r0, [r12, #16]
ldr r0, =0xa98349e4
str r0, [r12, #20]
ldr r0, =0x00000020
str r0, [r12, #24]
ldr r0, =0xcafebabe
str r0, [r12, #28]
ldr r0, =0x30728a60
str r0, [r12, #32]
ldr r0, =0x0000001f
str r0, [r12, #36]
ldr r0, =0x429b9a7b
str r0, [r12, #40]
ldr r0, =0x7fffffff
str r0, [r12, #44]
ldr r0, =0x00000021
str r0, [r12, #48]
ldr r0, =0xffffffff
str r0, [r12, #52]
ldr r0, =0xda6bec05
str r0, [r12, #56]
ldr r0, =0xcafebabe
str r0, [r12, #60]
ldr r0, =0xfdcb8297
ldr r1, =0x4f65c875
ldr r2, =0xaf4409e0
ldr r3, =0x0000ffff
ldr r4, =0x80000001
ldr r5, =0x12345678
ldr r6, =0x670f6c58
ldr r7, =0x12345678
ldr r8, =0x580963e5
ldr r9, =0xffffffff
ldr r10, =0x80000001
ldr r11, =0x00000002
ldr r12, =0x12345678
ldr r14, =0x00000101
teq r7, r3
adcspl r4, r14, r4
rsbs r9, r2, r3, ror r0
rscs r4, r4, r8, ror #5
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
ldr r0, =0x155e0987
ldr r1, =0x80000001
ldr r2, =0x3aeeca01
ldr r3, =0xa19d87df
ldr r4, =0x6498baa5
ldr r5, =0x80000000
ldr r6, =0xa6867ec4
ldr r7, =0xbb63bb8e
ldr r8, =0x1acc43cf
ldr r9, =0x7ffffffe
ldr r10, =0x7ffffffe
ldr r11, =0xb6aaf275
ldr r12, =0x00000020
ldr r14, =0x81331375
cmn r8, r8
sbcs r1, r12, r12, asr r14
rsb r8, r12, r0, lsr r12
bicscc r10, r14, r0, ror #2
subcc r2, r6, r3, ror #23
sub r7, r9, r7, lsl #11
cmpgt r2, r9, lsl #26
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
ldr r0, =0x12345678
ldr r1, =0x04090478
ldr r2, =0x45d5e082
ldr r3, =0x12345678
ldr r4, =0xcc5b8622
ldr r5, =0x9e31d862
ldr r6, =0x7fffffff
ldr r7, =0xae06f34d
ldr r8, =0x2a9b6c6a
ldr r9, =0x0dd7769d
ldr r10, =0x0000001f
ldr r11, =0xa64bdb4b
ldr r12, =0xc29b9b81
ldr r14, =0x000000ff
teq r4, r4
orrs r2, r8, r8, lsr r6
rsb r6, r14, r14, lsr r10
orrlt r4, r11, r11
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
ldr r0, =0x77d3cba1
ldr r1, =0xc848d3b8
ldr r2, =0x2aeef663
ldr r3, =0x00000002
ldr r4, =0x05d72386
ldr r5, =0xb93fd3b6
ldr r6, =0xab9d4855
ldr r7, =0xa1370c6a
ldr r8, =0x506fa162
ldr r9, =0x0000ffff
ldr r10, =0x9506d352
ldr r11, =0x3fa97d5c
ldr r12, =0x00000000
ldr r14, =0xf9cbf6d3
cmn r3, r7
andvc r11, r10, r4, ror #23
orrs r14, r12, r8, rrx
subslt r7, r6, r12
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
ldr r0, =0x18b69f11
ldr r1, =0xe4c99b8a
ldr r2, =0xcafebabe
ldr r3, =0x80000001
ldr r4, =0x00000020
ldr r5, =0xed2a5d96
ldr r6, =0x51124c23
ldr r7, =0x3d87c6b6
ldr r8, =0x00000000
ldr r9, =0x24d6f7d0
ldr r10, =0x830018ff
ldr r11, =0x181e374f
ldr r12, =0x9508b716
ldr r14, =0xae4c6178
tst r8, r7
adcs r5, r10, r0, lsr r3
rscspl r4, r1, r9, asr #22
subeq r8, r9, #0x23c
orrs r11, r5, r11, rrx
tstls r10, r3, ror r6
adc r1, r14, r8, rrx
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
ldr r0, =0xb7367a4e
ldr r1, =0xe1182f5c
ldr r2, =0x0000001f
ldr r3, =0xc44ad760
ldr r4, =0x2392efa1
ldr r5, =0x93407725
ldr r6, =0x00000021
ldr r7, =0x1dd52780
ldr r8, =0x8b9d0662
ldr r9, =0xc1c99cd8
ldr r10, =0x9c79be32
ldr r11, =0x00000002
ldr r12, =0x0000001f
ldr r14, =0xe51b0c4b
teq r2, r1
mvns r4, r11, asr #10
adds r6, r5, r2, lsl r11
mvns r6, r9, asr #2
orrls r1, r10, r8, asr r1
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
ldr r0, =0x7ffffffe
ldr r1, =0xe2605863
ldr r2, =0x7fffffff
ldr r3, =0xbf2ee64c
ldr r4, =0x710d78d6
ldr r5, =0xb21052c4
ldr r6, =0xcafebabe
ldr r7, =0x06032633
ldr r8, =0xef72de4e
ldr r9, =0x9da75bc8
ldr r10, =0x8d6d1fd9
ldr r11, =0x0000ffff
ldr r12, =0xffffffff
ldr r14, =0x00000021
teq r8, r7
andgt r3, r10, r6, ror r12
sbc r12, r6, r10, ror r12
eorcs r9, r12, r6, lsr #21
subs r7, r11, r14, ror r0
ands r5, r9, r8, lsr #17
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
ldr r0, =0x2ab6d98b
ldr r1, =0x00000000
ldr r2, =0x2db7073f
ldr r3, =0xf524e5cf
ldr r4, =0xc9f387ab
ldr r5, =0x4f94edef
ldr r6, =0x80000000
ldr r7, =0x00000020
ldr r8, =0x00000020
ldr r9, =0x80000000
ldr r10, =0x00000021
ldr r11, =0x80000000
ldr r12, =0x251a12b7
ldr r14, =0x00000101
cmn r6, r4
mvns r3, r3, ror r0
adds r1, r9, r12
teq r6, r4
cmn r11, r10, rrx
and r14, r0, r12, lsr #13
sbcsle r5, r5, #0x89000000
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
