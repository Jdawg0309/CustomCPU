.syntax unified
.cpu arm7tdmi
.arm

.section .text.startup, "ax", %progbits
.global _start
.type _start, %function
_start:
    mov sp, #0x1400          @ top of data RAM stack (RAM = 0x1000..0x1FFF)
    mov r0, #4               @ limit argument for main()
    bl main
1:
    b 1b
.size _start, . - _start
