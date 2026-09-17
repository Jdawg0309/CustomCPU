#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

__attribute__((noinline))
static uint32_t sum_array(const uint32_t *a, uint32_t n)
{
    uint32_t s = 0;
    for (uint32_t i = 0; i < n; i++)
        s += a[i];
    return s;
}

__attribute__((noinline))
static uint32_t nested_loop(uint32_t rows, uint32_t cols)
{
    uint32_t acc = 0;
    for (uint32_t r = 0; r < rows; r++) {
        for (uint32_t c = 0; c < cols; c++) {
            acc += r * 0 + c;   /* avoid a real multiply while still using r */
            if (c == cols - 1) acc += r;
        }
    }
    return acc;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    uint32_t arr[8];
    for (uint32_t i = 0; i < 8; i++)
        arr[i] = i * i - i;   /* small values, computed without relying on mul working */

    /* build arr without multiply: successive differences of squares */
    uint32_t v = 0, d = 1;
    for (uint32_t i = 0; i < 8; i++) {
        arr[i] = v;
        v += d;
        d += 2;
    }

    uint32_t s = sum_array(arr, 8);
    OUT[0] = s;

    uint32_t nl = nested_loop(5, 6);
    OUT[1] = nl;

    /* reverse the array in place */
    for (uint32_t i = 0, j = 7; i < j; i++, j--) {
        uint32_t t = arr[i];
        arr[i] = arr[j];
        arr[j] = t;
    }
    OUT[2] = sum_array(arr, 8);   /* sum is order-independent, should match OUT[0] */
    OUT[3] = arr[0];              /* was arr[7] */
    OUT[4] = arr[7];              /* was arr[0] */

    return s;
}
