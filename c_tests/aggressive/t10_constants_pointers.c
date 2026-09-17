#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

/* Large constants that don't fit an ARM immediate force GCC to use a literal
   pool (LDR Rd, =const), exactly the mechanism math_09 etc. already exercise
   -- this pushes on it with more values and more call frames in between. */

__attribute__((noinline))
static uint32_t xor_with_const(uint32_t x)
{
    return x ^ 0xDEADBEEFu;
}

__attribute__((noinline))
static uint32_t big_const_sum(void)
{
    uint32_t a = 0x12345678u;
    uint32_t b = 0x87654321u;
    uint32_t c = 0xCAFEBABEu;
    return a + b + c;
}

__attribute__((noinline))
static uint32_t *advance(uint32_t *p, int32_t n)
{
    return p + n;
}

__attribute__((noinline))
static uint32_t deref_chain(uint32_t ***ppp)
{
    return ***ppp;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    OUT[0] = xor_with_const(0xFFFFFFFFu);   /* ~0xDEADBEEF */
    OUT[1] = big_const_sum();

    uint32_t local[10];
    for (uint32_t i = 0; i < 10; i++) local[i] = 1000 + i;

    uint32_t *p = &local[5];
    uint32_t *p2 = advance(p, -3);
    OUT[2] = *p2;              /* local[2] = 1002 */
    p2 = advance(p, 4);
    OUT[3] = *p2;              /* local[9] = 1009 */

    uint32_t v = 777;
    uint32_t *pv = &v;
    uint32_t **ppv = &pv;
    uint32_t ***pppv = &ppv;
    OUT[4] = deref_chain(pppv);   /* 777, through 3 levels of indirection */

    **ppv = 888;
    OUT[5] = v;                   /* write-through pointer chain lands on v */

    /* array of pointers into `local` */
    uint32_t *ptrs[5];
    for (uint32_t i = 0; i < 5; i++) ptrs[i] = &local[i];
    uint32_t acc = 0;
    for (uint32_t i = 0; i < 5; i++) acc += *ptrs[i];
    OUT[6] = acc;   /* 1000+1001+1002+1003+1004 = 5010 */

    return OUT[1];
}
