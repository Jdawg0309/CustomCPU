.syntax unified
.arm
.global _start
_start:
    mov r0,#0
    mov r1,#3
lp:
    add r0,r0,#10
    subs r1,r1,#1
    bne lp
    mov r12,#0x1200
    str r0,[r12,#0]
    str r1,[r12,#4]
    mov r11,#0x5a
    str r11,[r12,#8]
    bx lr
