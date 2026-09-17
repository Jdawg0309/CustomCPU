#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

__attribute__((noinline))
static int32_t my_abs(int32_t x)
{
    return x < 0 ? -x : x;
}

__attribute__((noinline))
static int32_t clamp(int32_t x, int32_t lo, int32_t hi)
{
    if (x < lo) return lo;
    if (x > hi) return hi;
    return x;
}

__attribute__((noinline))
static int32_t sign(int32_t x)
{
    if (x > 0) return 1;
    if (x < 0) return -1;
    return 0;
}

__attribute__((noinline))
static uint32_t count_negatives(const int32_t *a, uint32_t n)
{
    uint32_t c = 0;
    for (uint32_t i = 0; i < n; i++)
        if (a[i] < 0) c++;
    return c;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    OUT[0] = (uint32_t)my_abs(-42);
    OUT[1] = (uint32_t)my_abs(42);
    OUT[2] = (uint32_t)my_abs(0);
    OUT[3] = (uint32_t)my_abs((int32_t)0x80000000); /* overflow edge: stays 0x80000000 */

    OUT[4] = (uint32_t)clamp(50, 0, 100);
    OUT[5] = (uint32_t)clamp(-10, 0, 100);
    OUT[6] = (uint32_t)clamp(200, 0, 100);

    OUT[7] = (uint32_t)sign(-5);
    OUT[8] = (uint32_t)sign(5);
    OUT[9] = (uint32_t)sign(0);

    int32_t arr[6] = { -3, 5, -7, 0, 2, -1 };
    OUT[10] = count_negatives(arr, 6);   /* 3 */

    /* signed comparisons across the int32 boundary */
    int32_t big_pos = 0x7FFFFFFF;
    int32_t big_neg = (int32_t)0x80000000;
    OUT[11] = (uint32_t)(big_pos > big_neg);   /* 1: signed compare */
    OUT[12] = (uint32_t)((uint32_t)big_pos < (uint32_t)big_neg); /* 1: unsigned compare flips */

    /* arithmetic vs logical shift on negatives */
    int32_t neg = -16;
    OUT[13] = (uint32_t)(neg >> 2);             /* arithmetic: -4 -> 0xFFFFFFFC */
    OUT[14] = ((uint32_t)neg) >> 2;             /* logical: huge positive */

    /* subtract with borrow chain, done as 64-bit via two 32-bit halves */
    uint32_t a_lo = 0x00000000, a_hi = 0x00000001;
    uint32_t b_lo = 0x00000001, b_hi = 0x00000000;
    uint32_t r_lo = a_lo - b_lo;
    uint32_t borrow = (a_lo < b_lo) ? 1 : 0;
    uint32_t r_hi = a_hi - b_hi - borrow;
    OUT[15] = r_lo;   /* 0xFFFFFFFF */
    OUT[16] = r_hi;   /* 0x00000000 */

    return OUT[0];
}
