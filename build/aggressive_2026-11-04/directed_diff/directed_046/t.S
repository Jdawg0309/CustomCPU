.syntax unified
.arm
.global _start
_start:
mov r10,#0x1100
mov r1,#17
str r1,[r10]
adr r3,after
str r3,[r10,#4]
ldmia r10,{r4,pc}
b .
after:
mov r1,#0x55
stmia r10,{r1}
mov r0,#0x5a
mov r12,#0x1200
str r0,[r12]
ldr r12,=0x13fc
mov r11,#0x5a
str r11,[r12]
mov lr,#0
halt_here:
bx lr
.ltorg
