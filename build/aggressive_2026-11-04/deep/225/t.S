.syntax unified
.arm
.global _start
_start:
    ldr r1, =0x00001100
    mov r3,#3
    ldr r2, =0x000000cc
    str r2,[r1,#12]
    ldr r0,[r1,r3,lsl #2]
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
