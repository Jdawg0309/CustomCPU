.syntax unified
.arm
.global _start
_start:
mov r10,#0x1100
mov r2,#0x55
str r2,[r10]
mov r0,#0
cmp r0,#1
ldrh r2,[r10]
mov r0,#0
orrmi r0,r0,#8
orreq r0,r0,#4
orrcs r0,r0,#2
orrvs r0,r0,#1
mov r12,#0x1200
str r0,[r12]
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
