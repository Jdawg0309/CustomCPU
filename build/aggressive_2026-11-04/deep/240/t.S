.syntax unified
.arm
.global _start
_start:
    mov r0,#5
    cmp r0,#5
    bne away
    mov r1,#7
    b end
away:
    mov r1,#99
end:
    mov r12,#0x1200
    str r1,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
