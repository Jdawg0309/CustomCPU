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
    mov r4, #0x20
    str r0, [r4]
    str r1, [r4, #4]
    ldr r5, [r4]
    ldr r6, [r4, #4]
    add r7, r5, r6, lsl #1
    cmp r7, #0xE9
stop:
    beq stop
