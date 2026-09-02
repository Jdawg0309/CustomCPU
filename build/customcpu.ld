ENTRY(_start)

/*
 * CustomCPU memory map (matches the hardware address decode in armv4t_2.circ):
 *   0x0000_0000 .. 0x0000_0FFF   instruction ROM  (LDR-literal pools read here)
 *   0x0000_1000 .. 0x0000_1FFF   data RAM         (1024 x 32-bit, addrWidth=10)
 *
 * Loads below 0x1000 hit the instruction ROM, so every writable object -- the
 * stack and all `volatile` MMIO-style pointers in the test sources -- MUST live
 * at 0x1000 or above or a store/reload round-trip silently reads ROM.
 */
MEMORY
{
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00001000
    RAM (rwx) : ORIGIN = 0x00001000, LENGTH = 0x00001000
}

SECTIONS
{
    .text :
    {
        KEEP(*(.text.startup))
        *(.text*)
        *(.rodata*)
    } > ROM

    .bss (NOLOAD) :
    {
        *(.bss*)
        *(COMMON)
    } > RAM

    /* Full-descending stack. 0x1400 leaves >2 KB of RAM below it for results
     * (the test sources write 0x1100..0x1120) and ~2.75 KB of stack growth. */
    __stack_top = 0x00001400;

    /DISCARD/ :
    {
        *(.ARM.attributes)
        *(.comment)
        *(.note*)
    }
}
