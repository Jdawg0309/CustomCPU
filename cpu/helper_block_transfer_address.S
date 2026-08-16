.syntax unified
.cpu arm7tdmi
.arm
.global _start

/*
 * Isolate block-transfer address sequencing before RAM/SP integration.
 * With the current controller, PUSH observes 0x3fc then 0x3f8. Because final
 * SP writeback is intentionally not connected yet, the standalone POP starts
 * again from 0x400 and observes 0x400 then 0x404.
 */
_start:
    mov sp, #0x400
    push {r4, lr}
    pop {r4, lr}
1:
    b 1b
