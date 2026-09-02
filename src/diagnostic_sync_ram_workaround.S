.syntax unified
.arm
.global _start

_start:
    mov sp, #0x100
    mov r0, #0xaa
    str r0, [sp, #-4]!
    mov r0, #0

    @ With synchronous RAM reads, this sacrificial load primes RAM.out.
    ldr r12, [sp]
    ldr r1, [sp], #4
    mov r2, sp

halt:
    b halt
