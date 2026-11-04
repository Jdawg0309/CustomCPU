.syntax unified
.arm
.global _start
_start:
mov sp,#0x13f0
mov r0,#0
bl f
bl f
b done
f:
push {r4,lr}
add r0,r0,#1
pop {r4,pc}
done:
mov r12,#0x1200
str r0,[r12]
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
