.syntax unified
.arm
.global _start
_start:
mov r1,#0x1100
ldr r2,=0xcafebabe
str r2,[r1,#12]
mov r3,#12
ldr r0,[r1,r3]
mov r12,#0x1200
str r0,[r12]
mov r12,#0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
