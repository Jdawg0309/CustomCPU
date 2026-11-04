.syntax unified
.arm
.global _start
_start:
    mov sp,#0x1400
    mov r0,#0
    bl f1
    add r0,r0,#1
    b done
f1:
    push {lr}
    bl f2
    pop {lr}
    add r0,r0,#10
    mov pc,lr
f2:
    add r0,r0,#100
    mov pc,lr
done:
    mov r12,#0x1200
    str r0,[r12,#0]
    mov r11,#0x5a
    str r11,[r12,#4]
    bx lr
