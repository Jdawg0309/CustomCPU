.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #0x100
    add r0, r0, #0x100
    add r0, r0, #0x80
    add r0, r0, #0x2B
    add r0, r0, #0x0B
    add r0, r0, #2
stop:
    b stop
