.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #13
    mov r1, #0
loop:
    cmp r0, #1
    beq stop
    tst r0, #1
    moveq r0, r0, lsr #1
    addne r0, r0, r0, lsl #1
    addne r0, r0, #1
    add r1, r1, #1
    b loop
stop:
    b stop
