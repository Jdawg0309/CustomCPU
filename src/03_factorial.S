.syntax unified
.cpu arm7tdmi
.arm
.global _start
_start:
    mov r0, #5
    mov r1, #1
outer:
    mov r2, r1
    mov r3, r0
    mov r1, #0
inner:
    add r1, r1, r2
    subs r3, r3, #1
    bne inner
    subs r0, r0, #1
    cmp r0, #1
    bgt outer
stop:
    b stop
