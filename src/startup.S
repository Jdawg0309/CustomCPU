.syntax unified
.cpu arm7tdmi
.arm

.section .text.startup, "ax", %progbits
.global _start
.type _start, %function
_start:
    mov sp, #0x1400
    mov r0, #4
    bl main
1:
    b 1b
.size _start, . - _start
