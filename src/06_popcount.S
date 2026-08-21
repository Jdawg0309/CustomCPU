.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #0xB5
    mov r1, #0
loop:
    ands r2, r0, #1
    addne r1, r1, #1
    mov r0, r0, lsr #1
    cmp r0, #0
    bne loop
stop:
    b stop
