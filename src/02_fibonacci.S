.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #0
    mov r1, #1
    mov r2, #10
loop:
    add r3, r0, r1
    mov r0, r1
    mov r1, r3
    subs r2, r2, #1
    bne loop
stop:
    b stop
