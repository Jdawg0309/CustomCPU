#include <stdint.h>

__attribute__((noinline))
uint32_t main(uint32_t limit)
{
    volatile uint32_t *cursor = (volatile uint32_t *)0x00000120;
    uint32_t value = 3;
    uint32_t total = 0;
    while (limit != 0) {
        *cursor = value;
        total += *cursor++;
        value += 2;
        --limit;
    }

    *(volatile uint32_t *)0x00000108 = total;
    return total;
}
