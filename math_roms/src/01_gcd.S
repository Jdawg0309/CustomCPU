.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #48
    mov r1, #18
loop:
    cmp r0, r1
    subgt r0, r0, r1
    sublt r1, r1, r0
    bne loop
stop:
    b stop
