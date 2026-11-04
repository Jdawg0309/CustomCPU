.syntax unified
.arm
.global _start
_start:
    ldr r4, =0x00001120
    mov r1,#0x41
    mov r2,#0x42
    stmdb r4!,{r1,r2}
    mov r1,#0
    mov r2,#0
    ldmia r4!,{r1,r2}
    mov r12,#0x1200
    str r1,[r12,#0]
    str r2,[r12,#4]
    mov r11,#0x5a
    str r11,[r12,#8]
    bx lr
