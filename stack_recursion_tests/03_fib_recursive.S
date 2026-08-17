.syntax unified
.arm
.global _start

@ The actual target behavior: a self-recursive function that only works if
@ every call frame's PUSH/POP round-trips correctly through RAM and SP is
@ restored exactly on every return path, at recursion depth > 1.
@
@ Recursive Fibonacci, additive only (no MUL, which is not a completed path
@ yet -- see PROJECT_STATUS.md Known Limits). fib(6) = 8.
@
@   fib(n):
@       if n <= 1: return n
@       return fib(n-1) + fib(n-2)

_start:
    mov sp, #0x400
    mov r0, #6
    bl fib
    mov r7, r0          @ expected r7 = 0x8

halt:
    b halt

fib:
    push {r4, r5, lr}
    cmp r0, #1
    ble fib_base
    mov r4, r0
    sub r0, r0, #1
    bl fib              @ r0 = fib(n-1)
    mov r5, r0
    sub r0, r4, #2
    bl fib              @ r0 = fib(n-2)
    add r0, r0, r5
    pop {r4, r5, lr}
    bx lr
fib_base:
    pop {r4, r5, lr}
    bx lr
