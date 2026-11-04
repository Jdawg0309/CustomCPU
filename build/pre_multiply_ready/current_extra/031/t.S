.syntax unified
.arm
.global _start
_start:
    mov r9,#0x80000000
    cmp r9,#1
    ldr r1,=0xf0f0f0f0
    ldr r2,=0x80000001
    tst r1,r2,lsl #1
    mov r12,#0x1200
    mov r10,#0
    movmi r10,#1
    str r10,[r12,#0]
    mov r10,#0
    moveq r10,#1
    str r10,[r12,#4]
    mov r10,#0
    movcs r10,#1
    str r10,[r12,#8]
    mov r10,#0
    movvs r10,#1
    str r10,[r12,#12]
    mov r11,#0x5a
    str r11,[r12,#16]
    bx lr
