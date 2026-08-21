.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #5
    add r1, r0, #1
    mov r2, #0
    mov r3, r1
plus_square:
    add r2, r2, r1
    subs r3, r3, #1
    bne plus_square
    sub r1, r0, #1
    mov r4, #0
    mov r3, r1
minus_square:
    add r4, r4, r1
    subs r3, r3, #1
    bne minus_square
    sub r5, r2, r4
    mov r5, r5, lsr #1
stop:
    b stop
