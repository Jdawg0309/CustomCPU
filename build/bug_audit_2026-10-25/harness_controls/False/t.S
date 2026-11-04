.syntax unified
.arm
mov lr,#0
mov r0,#0
mov r12,#0x1200
str r0,[r12]
ldr r12,=0x13fc
mov r11,#0x5a
str r11,[r12]
bx lr
