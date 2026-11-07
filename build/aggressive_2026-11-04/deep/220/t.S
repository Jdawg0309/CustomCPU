.syntax unified
.arm
.global _start
_start:
    ldr r1, =0x00001100
    ldr r2, =0x0000abcd
    strh r2,[r1]
    ldrh r0,[r1]
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
