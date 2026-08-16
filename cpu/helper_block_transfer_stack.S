.syntax unified
.cpu arm7tdmi
.arm
.global _start

/*
 * End-to-end PUSH/POP acceptance test.
 *
 * Expected RAM words after the final BX is decoded:
 *   RAM[0x40] = 0x00000044  restored r4
 *   RAM[0x41] = 0x00000088  restored lr
 *   RAM[0x42] = 0x00000400  restored sp
 *   RAM[0xfe] = 0x00000044  pushed r4
 *   RAM[0xff] = 0x00000088  pushed lr
 */
_start:
    mov sp, #0x400
    mov r4, #0x44
    mov lr, #0x88

    push {r4, lr}

    mov r4, #0
    mov lr, #0
    pop {r4, lr}

    mov r0, #0
    str r4, [r0, #0x100]
    str lr, [r0, #0x104]
    str sp, [r0, #0x108]

    bx r0
