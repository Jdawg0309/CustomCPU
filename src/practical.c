#include <stdint.h>

__attribute__((noinline))
uint32_t main(uint32_t limit)
{
    volatile uint32_t seed = 1;
    uint32_t value = seed;
    uint32_t sum = 0;

    for (uint32_t i = 1; limit != 0; ++i, --limit) {
        value += i;
        sum += value;
    }

    *(volatile uint32_t *)0x00000100 = sum;
    return sum;
}
