.syntax unified
.arm
.global _start
_start:
    mov r0,#1
    add pc,pc,#4
    mov r0,#99
    mov r0,#5
    mov r0,#7
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
