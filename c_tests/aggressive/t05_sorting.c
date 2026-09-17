#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)
#define N 12

__attribute__((noinline))
static void bubble_sort(uint32_t *a, uint32_t n)
{
    for (uint32_t i = 0; i < n; i++)
        for (uint32_t j = 0; j + 1 < n - i; j++)
            if (a[j] > a[j + 1]) {
                uint32_t t = a[j];
                a[j] = a[j + 1];
                a[j + 1] = t;
            }
}

__attribute__((noinline))
static uint32_t is_sorted(const uint32_t *a, uint32_t n)
{
    for (uint32_t i = 0; i + 1 < n; i++)
        if (a[i] > a[i + 1]) return 0;
    return 1;
}

__attribute__((noinline))
static uint32_t linear_search(const uint32_t *a, uint32_t n, uint32_t key)
{
    for (uint32_t i = 0; i < n; i++)
        if (a[i] == key) return i;
    return 0xFFFFFFFF;
}

__attribute__((noinline))
static uint32_t binary_search(const uint32_t *a, uint32_t n, uint32_t key)
{
    uint32_t lo = 0, hi = n;
    while (lo < hi) {
        uint32_t mid = lo + ((hi - lo) >> 1);
        if (a[mid] == key) return mid;
        if (a[mid] < key) lo = mid + 1;
        else hi = mid;
    }
    return 0xFFFFFFFF;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    uint32_t arr[N] = { 42, 7, 19, 3, 88, 1, 55, 23, 0, 99, 61, 30 };

    OUT[0] = is_sorted(arr, N);      /* 0 */
    bubble_sort(arr, N);
    OUT[1] = is_sorted(arr, N);      /* 1 */
    for (uint32_t i = 0; i < N; i++)
        OUT[2 + i] = arr[i];         /* the sorted sequence, words 2..13 */

    OUT[14] = linear_search(arr, N, 55);
    OUT[15] = linear_search(arr, N, 12345);
    OUT[16] = binary_search(arr, N, 55);
    OUT[17] = binary_search(arr, N, 0);
    OUT[18] = binary_search(arr, N, 99);

    return OUT[1];
}
