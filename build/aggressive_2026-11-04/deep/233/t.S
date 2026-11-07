.syntax unified
.arm
.global _start
_start:
    ldr r4, =0x00001100
    mov r1,#0x5A
    stmia r4!,{r1}
    mov r1,#0
    ldr r5, =0x00001100
    ldmia r5!,{r1}
    mov r12,#0x1200
    str r1,[r12,#0]
    str r4,[r12,#4]
    str r5,[r12,#8]
    mov r11,#0x5a
    str r11,[r12,#12]
    bx lr
