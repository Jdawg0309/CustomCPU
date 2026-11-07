.syntax unified
.arm
.global _start
_start:
    ldr r8, =0x00001100
    mov r0,#0
    mov r1,#1
    mov r2,#2
    mov r3,#3
    mov r4,#4
    mov r5,#5
    mov r6,#6
    mov r7,#7
    stmia r8!,{r0-r7}
    mov r0,#0
    mov r1,#0
    mov r2,#0
    mov r3,#0
    mov r4,#0
    mov r5,#0
    mov r6,#0
    mov r7,#0
    ldr r9, =0x00001100
    ldmia r9!,{r0-r7}
    mov r12,#0x1200
    str r0,[r12,#0]
    str r1,[r12,#4]
    str r2,[r12,#8]
    str r3,[r12,#12]
    str r4,[r12,#16]
    str r5,[r12,#20]
    str r6,[r12,#24]
    str r7,[r12,#28]
    mov r11,#0x5a
    str r11,[r12,#32]
    bx lr
