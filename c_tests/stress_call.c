#include <stdint.h>

__attribute__((noinline))
static uint32_t transform(uint32_t value)
{
    return (value << 1) + 3;
}

__attribute__((noinline))
uint32_t main(uint32_t limit)
{
    uint32_t total = 0;
    for (uint32_t i = 0; i < limit; ++i) {
        total += transform(i);
    }

    *(volatile uint32_t *)0x0000010C = total;
    return total;
}

