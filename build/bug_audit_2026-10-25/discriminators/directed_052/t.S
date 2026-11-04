.syntax unified
.arm
.global _start
_start:
mov r0,#0
bl f
bl f
b done
f:
add r0,r0,#1
mov pc,lr
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
