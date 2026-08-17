.syntax unified
.arm
.global _start

@ Smallest possible PUSH/POP round trip: one register, no nesting.
@ Isolates register-list capture + single-index select + RAM store/load +
@ SP writeback for the simplest case before trying multi-register lists.

_start:
    mov sp, #0x400
    mov r0, #0xaa
    push {r0}
    mov r0, #0
    pop {r0}
    mov r1, sp

halt:
    b halt
