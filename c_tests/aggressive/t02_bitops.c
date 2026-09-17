#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

__attribute__((noinline))
static uint32_t popcount(uint32_t x)
{
    uint32_t n = 0;
    while (x) {
        n += x & 1;
        x >>= 1;
    }
    return n;
}

__attribute__((noinline))
static uint32_t reverse_bits(uint32_t x)
{
    uint32_t r = 0;
    for (int i = 0; i < 32; i++) {
        r = (r << 1) | (x & 1);
        x >>= 1;
    }
    return r;
}

__attribute__((noinline))
static uint32_t rotl(uint32_t x, uint32_t n)
{
    return (x << n) | (x >> (32 - n));
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    OUT[0] = popcount(0xDEADBEEF);
    OUT[1] = popcount(0);
    OUT[2] = popcount(0xFFFFFFFF);
    OUT[3] = reverse_bits(0x00000001);
    OUT[4] = reverse_bits(0x80000000);
    OUT[5] = reverse_bits(0x12345678);
    OUT[6] = rotl(0x00000001, 4);
    OUT[7] = rotl(0xF0000000, 4);
    OUT[8] = (0xAAAAAAAA & 0x55555555);
    OUT[9] = (0xAAAAAAAA | 0x55555555);
    OUT[10] = (0xAAAAAAAA ^ 0xFFFFFFFF);
    OUT[11] = (~0x0F0F0F0Fu);
    return OUT[0];
}
