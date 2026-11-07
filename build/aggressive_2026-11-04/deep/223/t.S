.syntax unified
.arm
.global _start
_start:
    ldr r1, =0x00001100
    ldr r4, =0x00001110
    ldr r2, =0x000000aa
    str r2,[r1]
    ldr r2, =0x000000bb
    str r2,[r4]
    mov r3,#16
    ldr r0,[r1,r3]
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
