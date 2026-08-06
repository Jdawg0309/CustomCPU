.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #4
    mov r1, #3
    mov r2, #5
    add r3, r0, r0, lsl #1
    add r3, r3, r1, lsl #1
    sub r3, r3, r2
    sub r3, r3, #10
    cmp r3, #0
    movlt r3, #0
stop:
    b stop
