.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #0x10000
    mov r1, #0
    mov r2, #64
loop:
    str r0, [r1]
    mov r3, r0, lsl #1
    orr r4, r0, r0, lsr #1
    eor r0, r3, r4
    add r1, r1, #4
    subs r2, r2, #1
    bne loop
stop:
    b stop
