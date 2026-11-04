.syntax unified
.arm
.global _start
_start:
    ldr r0, =0x80000000
    ldr r1, =0x7fffffff
    subs r2,r0,r1
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
