.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    stmdb sp!, {r4, lr}
    ldmia sp!, {r4, lr}
    mov r0, #1
1:
    b 1b

