.syntax unified
.arm
.global _start
_start:
    mov r10,#0
    cmp r10,#0
    ldr r1,=0xffffffff
    ldr r2,=0x0
    sbcs r0,r1,r2
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
