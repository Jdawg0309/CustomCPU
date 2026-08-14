.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #3
    mov r1, #0x20
    str r0, [r1]
    mov r0, #5
    str r0, [r1, #4]
    mov r0, #7
    str r0, [r1, #8]
    mov r2, #0
    ldr r3, [r1]
    add r2, r2, r3
    ldr r3, [r1, #4]
    add r2, r2, r3
    ldr r3, [r1, #8]
    add r2, r2, r3
stop:
    b stop
