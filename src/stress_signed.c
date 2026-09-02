#include <stdint.h>

__attribute__((noinline))
uint32_t main(uint32_t limit)
{
    volatile int32_t initial = -7;
    int32_t value = initial;
    uint32_t total = 0;

    for (uint32_t i = 0; i < limit; ++i) {
        total += value < 0 ? (uint32_t)-value : (uint32_t)value;
        value += 3;
    }

    *(volatile uint32_t *)0x00000104 = total;
    return total;
}

