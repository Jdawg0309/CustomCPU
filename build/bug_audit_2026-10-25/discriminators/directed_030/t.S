.syntax unified
.arm
.global _start
_start:
mov r1,#0x1100
ldr r2,=0x7f0180ff
str r2,[r1]
ldrsb r0,[r1,#3]
mov r12,#0x1200
str r0,[r12]
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
