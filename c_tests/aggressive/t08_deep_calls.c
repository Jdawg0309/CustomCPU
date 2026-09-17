#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

/* A real call chain, six frames deep, each doing real work and touching the
   stack (locals + a save/restore-worthy register count) so the prologue/
   epilogue and LR handling get exercised for real, non-inlined calls. */

__attribute__((noinline)) static uint32_t level6(uint32_t x) {
    uint32_t local = x + 6;
    return local;
}
__attribute__((noinline)) static uint32_t level5(uint32_t x) {
    uint32_t a = x + 1, b = x + 2, c = x + 3;
    uint32_t r = level6(x + 5);
    return r + a - b + c - a;
}
__attribute__((noinline)) static uint32_t level4(uint32_t x) {
    uint32_t locals[4] = { x, x + 1, x + 2, x + 3 };
    uint32_t r = level5(x + 4);
    return r + locals[0] + locals[1] + locals[2] + locals[3] - x - (x+1) - (x+2) - (x+3);
}
__attribute__((noinline)) static uint32_t level3(uint32_t x) {
    return level4(x + 3) + 0;
}
__attribute__((noinline)) static uint32_t level2(uint32_t x) {
    uint32_t save = x * 0 + 1;  /* force a local that must survive the call */
    uint32_t r = level3(x + 2);
    return r + save - 1;
}
__attribute__((noinline)) static uint32_t level1(uint32_t x) {
    return level2(x + 1);
}

__attribute__((noinline))
static uint32_t mutual_a(uint32_t n);
__attribute__((noinline))
static uint32_t mutual_b(uint32_t n);

static uint32_t mutual_a(uint32_t n)
{
    if (n == 0) return 0;
    return 1 + mutual_b(n - 1);
}
static uint32_t mutual_b(uint32_t n)
{
    if (n == 0) return 0;
    return 1 + mutual_a(n - 1);
}

__attribute__((noinline))
static uint32_t sum_via_callback(uint32_t n, uint32_t (*f)(uint32_t))
{
    uint32_t s = 0;
    for (uint32_t i = 0; i < n; i++)
        s += f(i);
    return s;
}

__attribute__((noinline))
static uint32_t square_free(uint32_t x)
{
    /* x*x done without a real multiply: sum of first x odd numbers */
    uint32_t s = 0, odd = 1;
    for (uint32_t i = 0; i < x; i++) { s += odd; odd += 2; }
    return s;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    OUT[0] = level1(0);          /* deep, real call chain */
    OUT[1] = mutual_a(10);       /* 10, via 10 real mutual-recursion frames */
    OUT[2] = mutual_b(11);       /* 11 */
    OUT[3] = sum_via_callback(5, square_free);  /* 0+1+4+9+16 = 30, function-pointer call */
    return OUT[0];
}
