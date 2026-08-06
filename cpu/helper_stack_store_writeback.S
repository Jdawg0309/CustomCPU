.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov sp, #0x100
    mov r0, #0xAA
    str r0, [sp, #-4]!
    mov r5, sp
    mov sp, #0x100
    mov r0, #0x55
    str r0, [sp], #4
    mov r0, #0x33
    str r0, [sp, #4]
stop:
    b stop
