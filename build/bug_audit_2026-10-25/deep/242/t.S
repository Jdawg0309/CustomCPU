.syntax unified
.arm
.global _start
_start:
    mov r0,#1
    ldr r1, =0x00001100
    adr r2,tgt
    str r2,[r1]
    ldr pc,[r1]
    mov r0,#99
tgt:
    mov r0,#7
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
