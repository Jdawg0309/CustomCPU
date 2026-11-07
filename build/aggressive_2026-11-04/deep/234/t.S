.syntax unified
.arm
.global _start
_start:
    ldr r4, =0x00001100
    mov r1,#0x11
    stmia r4!,{r1,r4}
    ldr r5, =0x00001100
    ldr r0,[r5,#4]
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
