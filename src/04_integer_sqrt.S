.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #81
    mov r1, #0
    mov r2, #1
loop:
    cmp r0, r2
    blt stop
    sub r0, r0, r2
    add r2, r2, #2
    add r1, r1, #1
    b loop
stop:
    b stop
