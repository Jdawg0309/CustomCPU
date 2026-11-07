.syntax unified
.arm
.global _start
_start:
    mov r0,#1
    b nxt
nxt:
    add r0,r0,#1
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
