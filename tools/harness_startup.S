/* Startup stub for the aggressive C test harness.
 *
 * Differs from src/startup.S only in how it signals "done": instead of
 * spinning forever after main() returns (which the jar-based push_suite
 * convention -- rename is_BX to halt, stop on the FIRST bx -- would
 * misread as "done" the moment ANY inner function returns), this jumps to
 * address 0 via `bx r0` with r0=0. That is the halt-on-bx-to-0 convention
 * (see CustomCPU-COT's tests/sim_halt.py): every ordinary `bx lr` return
 * from a real, non-inlined call has lr != 0 and falls through cleanly;
 * only this final jump halts the machine. Verilog testbenches stop on
 * o_bx_taken && o_bx_target==0, matching this exactly.
 */
.syntax unified
.cpu arm7tdmi
.arm

.section .text.startup, "ax", %progbits
.global _start
.type _start, %function
_start:
    mov sp, #0x1400

    /* zero .bss (uninitialized statics/globals) -- see tools/harness.ld.
       Without this, a static variable reads back whatever RAM happened to
       hold, which happens to be 0 in every simulator here by coincidence of
       how they reset, not because anything guarantees it. */
    ldr r1, =__bss_start
    ldr r2, =__bss_end
    mov r3, #0
1:  cmp r1, r2
    bge 2f
    str r3, [r1], #4
    b 1b
2:

    /* copy .data (initialized statics/globals) from its ROM home to RAM */
    ldr r1, =__data_lma
    ldr r2, =__data_start
    ldr r3, =__data_end
3:  cmp r2, r3
    bge 4f
    ldr r4, [r1], #4
    str r4, [r2], #4
    b 3b
4:

    mov r0, #4
    bl main
    mov r0, #0
    bx r0
.size _start, . - _start
