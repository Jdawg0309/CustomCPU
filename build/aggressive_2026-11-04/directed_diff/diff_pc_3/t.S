.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000001
str r0, [r12, #0]
ldr r0, =0x2ce5feed
str r0, [r12, #4]
ldr r0, =0x80000000
str r0, [r12, #8]
ldr r0, =0x75d55557
str r0, [r12, #12]
ldr r0, =0x9a41eeb9
str r0, [r12, #16]
ldr r0, =0x12345678
str r0, [r12, #20]
ldr r0, =0x25f79218
str r0, [r12, #24]
ldr r0, =0x00000001
str r0, [r12, #28]
ldr r0, =0x6a0fcaa8
str r0, [r12, #32]
ldr r0, =0xf82d63d8
str r0, [r12, #36]
ldr r0, =0x56cffb48
str r0, [r12, #40]
ldr r0, =0x2cb56731
str r0, [r12, #44]
ldr r0, =0x00000100
str r0, [r12, #48]
ldr r0, =0xcafebabe
str r0, [r12, #52]
ldr r0, =0xb918cd2b
str r0, [r12, #56]
ldr r0, =0x00000000
str r0, [r12, #60]
ldr r0, =0xe06e9d35
ldr r1, =0x0000ffff
ldr r2, =0x000000ff
ldr r3, =0x95b88a44
ldr r4, =0x0000001f
ldr r5, =0x0000ffff
ldr r6, =0xa252a470
ldr r7, =0x80000001
ldr r8, =0x0000001f
ldr r9, =0x7ffffffe
ldr r10, =0xa627d512
ldr r11, =0x000000ff
ldr r12, =0xf26a1b66
ldr r14, =0x2e316b80
tst r12, r12
addmi pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x54c1fae3
ldr r1, =0x8d8dfcd4
ldr r2, =0x7ffffffe
ldr r3, =0xbf940691
ldr r4, =0x00000100
ldr r5, =0xadf31973
ldr r6, =0x00000020
ldr r7, =0x0000ffff
ldr r8, =0x0000ffff
ldr r9, =0xbdb29b83
ldr r10, =0x80000001
ldr r11, =0x7fffffff
ldr r12, =0x837a68b1
ldr r14, =0x12345678
cmp r12, r9
ldrb r7, [pc, #-7]
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
ldr r0, =0x454f6052
ldr r1, =0x80000001
ldr r2, =0xefdbb09a
ldr r3, =0x00000020
ldr r4, =0x80000000
ldr r5, =0xf84a741d
ldr r6, =0x7fffffff
ldr r7, =0x00000020
ldr r8, =0x80000001
ldr r9, =0x398e669c
ldr r10, =0x91659c26
ldr r11, =0x7ffffffe
ldr r12, =0x16cdbb0e
ldr r14, =0x000000ff
cmn r6, r3
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x2899402f
ldr r1, =0x00000100
ldr r2, =0x00000020
ldr r3, =0x0000001f
ldr r4, =0x65c4dbcc
ldr r5, =0x00000100
ldr r6, =0x4a0dc5da
ldr r7, =0xa69e1956
ldr r8, =0xe021805c
ldr r9, =0xcbdc2369
ldr r10, =0x80000000
ldr r11, =0x7fffffff
ldr r12, =0xcafebabe
ldr r14, =0xcafebabe
cmp r2, r7
add r4, pc, r7, lsl #2
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
ldr r0, =0xb50493af
ldr r1, =0x00000021
ldr r2, =0x00000000
ldr r3, =0x00000101
ldr r4, =0x53965319
ldr r5, =0xffffffff
ldr r6, =0xcdba0058
ldr r7, =0x4ec79b16
ldr r8, =0x7ffffffe
ldr r9, =0xcafebabe
ldr r10, =0xc7f8742f
ldr r11, =0xb04e3eec
ldr r12, =0x0000001f
ldr r14, =0x3f375572
tst r7, r4
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
ldr r0, =0x7ffffffe
ldr r1, =0x00000021
ldr r2, =0x7ffffffe
ldr r3, =0x00000100
ldr r4, =0x7fffffff
ldr r5, =0x72d16a7e
ldr r6, =0x00000002
ldr r7, =0x4931d266
ldr r8, =0x7fffffff
ldr r9, =0x00000021
ldr r10, =0xf579c400
ldr r11, =0xc1ec8653
ldr r12, =0xb09ecf6b
ldr r14, =0x096ae902
teq r1, r12
sub r0, pc, #56
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
ldr r0, =0xae23fb88
ldr r1, =0x00000021
ldr r2, =0x7ffffffe
ldr r3, =0x16b18967
ldr r4, =0x5c85b10c
ldr r5, =0x7fffffff
ldr r6, =0x0eacd524
ldr r7, =0x7ffffffe
ldr r8, =0x1fbed138
ldr r9, =0xcafebabe
ldr r10, =0x00000021
ldr r11, =0x7a489d12
ldr r12, =0x00000021
ldr r14, =0x00000001
teq r6, r7
ldr r1, [pc, #4]
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
ldr r0, =0x0000ffff
ldr r1, =0x70eeee2c
ldr r2, =0x0000ffff
ldr r3, =0x00000002
ldr r4, =0xdefa4b92
ldr r5, =0x7fffffff
ldr r6, =0x33565345
ldr r7, =0xff356d09
ldr r8, =0xcafebabe
ldr r9, =0x00000002
ldr r10, =0x238f0d86
ldr r11, =0xa0a5fb14
ldr r12, =0x7fffffff
ldr r14, =0x0000ffff
teq r9, r14
add pc, pc, #0
add r1, r1, #1
add r2, r2, #1
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
