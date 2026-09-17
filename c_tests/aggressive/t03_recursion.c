#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

__attribute__((noinline))
static uint32_t fib(uint32_t n)
{
    if (n < 2) return n;
    return fib(n - 1) + fib(n - 2);
}

__attribute__((noinline))
static uint32_t fact(uint32_t n)
{
    if (n == 0) return 1;
    /* multiply-free factorial via repeated addition, since real MUL is a
       known gap right now -- this still exercises deep, real recursion. */
    uint32_t prev = fact(n - 1);
    uint32_t acc = 0;
    for (uint32_t i = 0; i < n; i++)
        acc += prev;
    return acc;
}

__attribute__((noinline))
static uint32_t gcd2(uint32_t a, uint32_t b)
{
    while (b != 0) {
        uint32_t t = b;
        while (a >= b) a -= b;
        b = a;
        a = t;
    }
    return a;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    OUT[0] = fib(10);          /* 55 */
    OUT[1] = fib(0);           /* 0 */
    OUT[2] = fib(1);           /* 1 */
    OUT[3] = fact(5);          /* 120 */
    OUT[4] = fact(0);          /* 1 */
    OUT[5] = gcd2(48, 18);     /* 6 */
    OUT[6] = gcd2(1071, 462);  /* 21 */
    return OUT[0];
}
