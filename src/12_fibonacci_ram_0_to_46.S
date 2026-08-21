.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #0
    mov r1, #1
    mov r2, #47
    mov r4, #0
loop:
    str r0, [r4]
    add r3, r0, r1
    mov r0, r1
    mov r1, r3
    add r4, r4, #4
    subs r2, r2, #1
    bne loop
stop:
    b stop
