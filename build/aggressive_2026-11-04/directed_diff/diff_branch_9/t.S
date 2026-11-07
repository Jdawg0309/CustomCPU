.syntax unified
.arm
.global _start
_start:
ldr r12, =0x1100
ldr r0, =0x80000001
str r0, [r12, #0]
ldr r0, =0xbe39694e
str r0, [r12, #4]
ldr r0, =0x00000101
str r0, [r12, #8]
ldr r0, =0x909efc37
str r0, [r12, #12]
ldr r0, =0x2d85a1a4
str r0, [r12, #16]
ldr r0, =0x369ab36b
str r0, [r12, #20]
ldr r0, =0x000000ff
str r0, [r12, #24]
ldr r0, =0xfc2a4d88
str r0, [r12, #28]
ldr r0, =0x7fffffff
str r0, [r12, #32]
ldr r0, =0x0000ffff
str r0, [r12, #36]
ldr r0, =0x00000020
str r0, [r12, #40]
ldr r0, =0x0b933dae
str r0, [r12, #44]
ldr r0, =0x191521ea
str r0, [r12, #48]
ldr r0, =0x80000000
str r0, [r12, #52]
ldr r0, =0x80000001
str r0, [r12, #56]
ldr r0, =0x7cdbc29b
str r0, [r12, #60]
ldr r0, =0x00000000
ldr r1, =0x0d49c051
ldr r2, =0x65094534
ldr r3, =0x0000001f
ldr r4, =0xfc78d2cf
ldr r5, =0x00000101
ldr r6, =0x06501074
ldr r7, =0x00000001
ldr r8, =0x0000001f
ldr r9, =0x00a04125
ldr r10, =0x00000002
ldr r11, =0x0000ffff
ldr r12, =0x3540f91e
ldr r14, =0x5543a97c
cmn r1, r0
blle 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0xd70a3ac2
ldr r1, =0x00000000
ldr r2, =0x80000001
ldr r3, =0x69ba937f
ldr r4, =0x80000000
ldr r5, =0x0000001f
ldr r6, =0x12345678
ldr r7, =0x83521d7d
ldr r8, =0xcd28b294
ldr r9, =0x00000100
ldr r10, =0x7fffffff
ldr r11, =0x899d475b
ldr r12, =0x00000101
ldr r14, =0x7842de55
cmp r8, r7
blhi 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x00000101
ldr r1, =0x12345678
ldr r2, =0x12345678
ldr r3, =0xccaae0a1
ldr r4, =0xcafebabe
ldr r5, =0xab562428
ldr r6, =0x00000002
ldr r7, =0x6a254e2b
ldr r8, =0x46018699
ldr r9, =0xcafebabe
ldr r10, =0x7ffffffe
ldr r11, =0x000000ff
ldr r12, =0x7ffffffe
ldr r14, =0xa4a00ff8
teq r7, r3
blmi 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0xc9e1cd9f
ldr r1, =0x7fffffff
ldr r2, =0x0000001f
ldr r3, =0xc3d0eb55
ldr r4, =0x0000ffff
ldr r5, =0x7ffffffe
ldr r6, =0xb9ffc891
ldr r7, =0xda49819e
ldr r8, =0xeae3b0fc
ldr r9, =0x8cf30289
ldr r10, =0x9cc7ea7b
ldr r11, =0xc1f996dd
ldr r12, =0x00000002
ldr r14, =0xff5d185e
cmn r1, r7
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x00000101
ldr r1, =0x00000000
ldr r2, =0x1bdb33fb
ldr r3, =0xd0d18c35
ldr r4, =0xcafebabe
ldr r5, =0x0000001f
ldr r6, =0x7ffffffe
ldr r7, =0x0000ffff
ldr r8, =0x00000101
ldr r9, =0xd637a1fd
ldr r10, =0x60a326fe
ldr r11, =0x000000ff
ldr r12, =0x00000021
ldr r14, =0x0000001f
cmn r4, r5
mov r8, #3
1:
add r0, r0, #2
subs r8, r8, #1
bne 1b
bne 2f
add r1, r1, #7
2:
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
ldr r1, =0x00000002
ldr r2, =0xc779de20
ldr r3, =0xec1c8ba6
ldr r4, =0x00000100
ldr r5, =0x7837fa47
ldr r6, =0x74ff688c
ldr r7, =0x01c08c0b
ldr r8, =0x9e250a0e
ldr r9, =0x00000000
ldr r10, =0x15db8bb1
ldr r11, =0xfd63b805
ldr r12, =0x86b2108a
ldr r14, =0x0000001f
cmp r1, r1
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x3cad5d21
ldr r1, =0x00b4a26b
ldr r2, =0x9a9f81c5
ldr r3, =0xcafebabe
ldr r4, =0x80000001
ldr r5, =0x00000101
ldr r6, =0x00000100
ldr r7, =0x12345678
ldr r8, =0x7ffffffe
ldr r9, =0x00000020
ldr r10, =0x80ac16a3
ldr r11, =0x00000000
ldr r12, =0x72886947
ldr r14, =0x00000101
tst r12, r10
bl 1f
b 2f
1:
add r0, r0, #5
mov pc, lr
2:
add r1, r1, #1
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
ldr r0, =0x7ffffffe
ldr r1, =0x7ffffffe
ldr r2, =0x418a4fc6
ldr r3, =0xf207a18f
ldr r4, =0xe237229d
ldr r5, =0x0000ffff
ldr r6, =0x8be9489d
ldr r7, =0xb38d891d
ldr r8, =0xe41394c1
ldr r9, =0xd9766f19
ldr r10, =0x00000100
ldr r11, =0x45117b70
ldr r12, =0x52108bc9
ldr r14, =0x206cb7b5
cmn r9, r5
ble 1f
add r0, r0, #1
add r1, r1, #2
1:
add r2, r2, #3
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
