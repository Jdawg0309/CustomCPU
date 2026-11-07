.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x12345678
str r0, [r12, #0]
ldr r0, =0x00000002
str r0, [r12, #4]
ldr r0, =0xf8d717a1
str r0, [r12, #8]
ldr r0, =0xffffffff
str r0, [r12, #12]
ldr r0, =0x00000002
str r0, [r12, #16]
ldr r0, =0x000000ff
str r0, [r12, #20]
ldr r0, =0x7141d794
str r0, [r12, #24]
ldr r0, =0x00000002
str r0, [r12, #28]
ldr r0, =0x0000ffff
str r0, [r12, #32]
ldr r0, =0x00000021
str r0, [r12, #36]
ldr r0, =0x7ffffffe
str r0, [r12, #40]
ldr r0, =0x514429ba
str r0, [r12, #44]
ldr r0, =0x126ea5c9
str r0, [r12, #48]
ldr r0, =0x7a49388f
str r0, [r12, #52]
ldr r0, =0x7ffffffe
str r0, [r12, #56]
ldr r0, =0xcff055b6
str r0, [r12, #60]
ldr r0, =0x80000000
ldr r1, =0x24d9b042
ldr r2, =0x796e1d17
ldr r3, =0x6370e044
ldr r4, =0x00000001
ldr r5, =0x12345678
ldr r6, =0xcafebabe
ldr r7, =0xeaf954e2
ldr r8, =0x418eaf89
ldr r9, =0x707bd9e3
ldr r10, =0x7ffffffe
ldr r11, =0x0000001f
ldr r12, =0xbf987524
ldr r14, =0x0000001f
tst r8, r3
ldr r10, =0x1120
stmdane r10, {r0,r6}
ldr r10, =0x1120
stmib r10!, {r2,r7}
ldr r10, =0x1120
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
ldr r0, =0x76024a8e
ldr r1, =0x630ae233
ldr r2, =0x47788b82
ldr r3, =0x6fc751f2
ldr r4, =0xbc32223e
ldr r5, =0xf8bb7bf8
ldr r6, =0x12d4c251
ldr r7, =0x13813340
ldr r8, =0x80000000
ldr r9, =0x12345678
ldr r10, =0x00000021
ldr r11, =0x12345678
ldr r12, =0x00000001
ldr r14, =0x95948f63
tst r12, r9
ldr r10, =0x1120
stmda r10, {r1,r4,r8,r12,lr}
ldr r10, =0x1120
ldmia r10, {r2,r3,r5,r12}
ldr r10, =0x1120
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
ldr r1, =0x00000101
ldr r2, =0x46d97c40
ldr r3, =0x00000000
ldr r4, =0x0beec06e
ldr r5, =0x319b559d
ldr r6, =0xcc0be50e
ldr r7, =0xd22cf285
ldr r8, =0x00000020
ldr r9, =0x7fffffff
ldr r10, =0x0d160645
ldr r11, =0xd4370dc0
ldr r12, =0xffffffff
ldr r14, =0x00000001
tst r3, r9
ldr r10, =0x1120
ldmdb r10!, {r0,r2,r4,r12}
ldr r10, =0x1120
ldmib r10!, {r1}
ldr r10, =0x1120
ldmdb r10, {r9}
ldr r10, =0x1120
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
ldr r1, =0x0000001f
ldr r2, =0x63e418bd
ldr r3, =0x0000ffff
ldr r4, =0x00000001
ldr r5, =0x7fffffff
ldr r6, =0x18b7eb8e
ldr r7, =0x0000001f
ldr r8, =0xffffffff
ldr r9, =0x00000101
ldr r10, =0x37cf32e9
ldr r11, =0x0000001f
ldr r12, =0x1acd975c
ldr r14, =0xc934caea
teq r11, r0
ldr r10, =0x1120
ldmia r10, {r8,r11}
ldr r10, =0x1120
stmib r10, {r0,r2,r8,lr}
ldr r10, =0x1120
ldmiahi r10, {r5}
ldr r10, =0x1120
stmda r10, {r2}
ldr r10, =0x1120
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
ldr r1, =0xffffffff
ldr r2, =0x4b6aecfc
ldr r3, =0xc6f08226
ldr r4, =0x0000ffff
ldr r5, =0x7fffffff
ldr r6, =0xcafebabe
ldr r7, =0x80000000
ldr r8, =0x76952ea4
ldr r9, =0x3a0e0342
ldr r10, =0x858f3490
ldr r11, =0xcafebabe
ldr r12, =0x00000002
ldr r14, =0x12345678
teq r11, r8
ldr r10, =0x1120
stmib r10!, {r0,r8,r9}
ldr r10, =0x1120
stmdb r10!, {r2}
ldr r10, =0x1120
ldmdblt r10!, {r1,r3,r8,r11,lr}
ldr r10, =0x1120
ldmib r10!, {r1,r3,r6,r11,r12}
ldr r10, =0x1120
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
ldr r0, =0x84369ea4
ldr r1, =0x80000001
ldr r2, =0xb4e162b6
ldr r3, =0x3491257c
ldr r4, =0x12345678
ldr r5, =0x00000100
ldr r6, =0x7fffffff
ldr r7, =0xcafebabe
ldr r8, =0x00000020
ldr r9, =0x00000101
ldr r10, =0x3dc4224e
ldr r11, =0x00000100
ldr r12, =0x1f13dd27
ldr r14, =0xbd260a68
teq r6, r11
ldr r10, =0x1120
ldmda r10, {r3,r11}
ldr r10, =0x1120
stmdb r10!, {r0,r8,r12,lr}
ldr r10, =0x1120
ldmda r10, {r0,r4,r8}
ldr r10, =0x1120
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
ldr r0, =0x00000100
ldr r1, =0x0000ffff
ldr r2, =0xb209a3f6
ldr r3, =0x1e408404
ldr r4, =0xb697baa5
ldr r5, =0xd5674341
ldr r6, =0x0000ffff
ldr r7, =0x7fffffff
ldr r8, =0xa45ef620
ldr r9, =0x4d74fff7
ldr r10, =0xdae14bb9
ldr r11, =0x00000000
ldr r12, =0x4f94cdde
ldr r14, =0x12345678
teq r4, r14
ldr r10, =0x1120
stmia r10!, {r2,r4,r5,lr}
ldr r10, =0x1120
ldmib r10, {r0,r3,r4,r11,lr}
ldr r10, =0x1120
stmdb r10!, {r5}
ldr r10, =0x1120
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
ldr r0, =0xe971bcea
ldr r1, =0x505438f9
ldr r2, =0x00000001
ldr r3, =0x00000002
ldr r4, =0x0000ffff
ldr r5, =0x00000100
ldr r6, =0xed3b6d48
ldr r7, =0x00000100
ldr r8, =0x12345678
ldr r9, =0x451ee686
ldr r10, =0x0000ffff
ldr r11, =0x00000000
ldr r12, =0xf795dea5
ldr r14, =0x7ffffffe
cmn r0, r14
ldr r10, =0x1120
ldmdb r10!, {r11}
ldr r10, =0x1120
stmda r10!, {r2}
ldr r10, =0x1120
ldmia r10!, {r0,r2,r9,r11}
ldr r10, =0x1120
stmia r10!, {r4,r11,lr}
ldr r10, =0x1120
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
