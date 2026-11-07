.syntax unified
.arm
.global _start
_start:
    mov r0,pc
    mov r1,pc
    mov r12,#0x1200
    str r0,[r12,#0]
    str r1,[r12,#4]
    mov r11,#0x5a
    str r11,[r12,#8]
    bx lr
