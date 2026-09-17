#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

__attribute__((noinline))
static uint32_t classify(int32_t x)
{
    if (x == 0) return 0;
    else if (x < 0 && x > -10) return 1;
    else if (x <= -10) return 2;
    else if (x > 0 && x < 10) return 3;
    else return 4;
}

__attribute__((noinline))
static uint32_t fizzbuzz_code(uint32_t n)
{
    uint32_t div3 = 0, div5 = 0;
    uint32_t t = n;
    while (t >= 3) t -= 3;
    if (t == 0) div3 = 1;
    t = n;
    while (t >= 5) t -= 5;
    if (t == 0) div5 = 1;

    if (div3 && div5) return 15;
    if (div3) return 3;
    if (div5) return 5;
    return 0;
}

__attribute__((noinline))
static uint32_t switch_test(uint32_t x)
{
    switch (x) {
        case 0: return 100;
        case 1: return 101;
        case 2: return 102;
        case 3: return 103;
        case 10: return 110;
        case 20: return 120;
        default: return 999;
    }
}

__attribute__((noinline))
static uint32_t ternary_chain(uint32_t a, uint32_t b, uint32_t c)
{
    return a > b ? (a > c ? a : c) : (b > c ? b : c);   /* max of 3 */
}

__attribute__((noinline))
static uint32_t short_circuit_count(void)
{
    static volatile uint32_t calls = 0;
    calls++;
    return calls;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    OUT[0] = classify(0);
    OUT[1] = classify(-5);
    OUT[2] = classify(-20);
    OUT[3] = classify(5);
    OUT[4] = classify(50);

    for (uint32_t i = 1; i <= 16; i++)
        OUT[4 + i] = fizzbuzz_code(i);   /* words 5..20 */

    OUT[21] = switch_test(0);
    OUT[22] = switch_test(2);
    OUT[23] = switch_test(10);
    OUT[24] = switch_test(20);
    OUT[25] = switch_test(999);

    OUT[26] = ternary_chain(3, 7, 5);
    OUT[27] = ternary_chain(9, 2, 4);
    OUT[28] = ternary_chain(1, 1, 1);

    /* short-circuit evaluation must not call the RHS when LHS decides it */
    uint32_t zero = 0;
    uint32_t r = (zero != 0) && (short_circuit_count() > 0);
    OUT[29] = r;                          /* 0 */
    OUT[30] = short_circuit_count();      /* first real call -> 1 */
    r = (zero == 0) || (short_circuit_count() > 100);
    OUT[31] = r;                          /* 1, RHS short-circuited away */
    OUT[32] = short_circuit_count();      /* 2, confirming RHS above didn't run */

    return OUT[0];
}
