.syntax unified
.arm
.global _start

@ Typical GCC function-prologue/epilogue shape: {r4, r5, lr} in, {r4, r5, lr}
@ out. Exercises the full 16-bit register-list scan (non-contiguous indices)
@ and multi-word SP movement (three words down, three words up) in one block
@ transfer, without recursion.

_start:
    mov sp, #0x400
    mov r4, #0x11
    mov r5, #0x22
    bl callee
    mov r6, sp

halt:
    b halt

callee:
    push {r4, r5, lr}
    mov r4, #0x33
    mov r5, #0x44
    pop {r4, r5, lr}
    bx lr
