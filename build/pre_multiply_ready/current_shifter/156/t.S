.syntax unified
.arm
.global _start
_start:
    mov r10,#0
    cmp r10,#1
    ldr r1,=0x80000001
    ldr r3,=0x00000021
    movs r0,r1,ror r3
    mov r2,#0
    movcs r2,#1
    ldr r11,=0x00001200
    str r0,[r11]
    str r2,[r11,#4]
    bx lr
