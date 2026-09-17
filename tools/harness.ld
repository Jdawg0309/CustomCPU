/* Linker script for the aggressive C test harness (tools/aggressive_c_harness.py).
 *
 * Separate from build/customcpu.ld so the harness can use the CPU's full
 * instruction-ROM capacity (1024 words / 4KB, matching stage_IF's real
 * addrWidth=10) without touching the shared production build.
 *
 * RAM origin matches the fix in build/customcpu.ld: the hardware's
 * is_program_addr = NOT(address bit 12), so real data RAM only starts at
 * 0x1000. RAM itself is 256 words (addrWidth=8) -- confirmed by tracing the
 * hardware directly -- so stay within 0x1000-0x13FF.
 */
ENTRY(_start)

MEMORY
{
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00001000
    RAM (rwx) : ORIGIN = 0x00001000, LENGTH = 0x00000400
}

SECTIONS
{
    .text :
    {
        KEEP(*(.text.startup))
        *(.text*)
        *(.rodata*)
    } > ROM

    /* Initialized globals: stored in ROM (LMA), copied to RAM (VMA) by
       harness_startup.S before main() runs -- standard embedded convention.
       Without an explicit home for .data/.bss the linker drops them wherever
       is next in address order, which previously put a .bss variable at
       0x29c -- inside ROM space, where every LOAD reads back 0 regardless
       of what was stored (see is_program_addr in the CPU). */
    .data : { __data_start = .; *(.data*) __data_end = .; } > RAM AT> ROM
    __data_lma = LOADADDR(.data);

    .bss (NOLOAD) : { __bss_start = .; *(.bss*) *(COMMON) __bss_end = .; } > RAM

    /DISCARD/ :
    {
        *(.ARM.attributes)
        *(.comment)
        *(.note*)
    }
}
