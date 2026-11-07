.syntax unified
.arm
.global _start
_start:
mov r1,#0x1100
mov r2,#0x55
mov r3,#2
strh r2,[r1],r3
mov r0,r1
mov r12,#0x1200
str r0,[r12]
ldr r12,=0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
