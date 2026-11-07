.syntax unified
.arm
.global _start
_start:
    ldr r4, =0x00001100
    mov r1,#0x31
    mov r2,#0x32
    str r1,[r4]
    str r2,[r4,#4]
    mov r0,#0x99
    ldmia r4!,{r6,r7}
    mov r12,#0x1200
    str r0,[r12,#0]
    str r6,[r12,#4]
    str r7,[r12,#8]
    mov r11,#0x5a
    str r11,[r12,#12]
    bx lr
