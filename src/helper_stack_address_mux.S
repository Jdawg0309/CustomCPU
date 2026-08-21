.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov sp, #0x100
    mov r0, #0xAA
    str r0, [sp, #-4]!
    str r0, [sp], #-4
stop:
    b stop
