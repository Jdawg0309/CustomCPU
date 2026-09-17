#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

typedef struct {
    uint32_t a;
    uint32_t b;
    uint32_t c;
    uint32_t d;
} quad_t;

__attribute__((noinline))
static uint32_t sum_quad(const quad_t *q)
{
    return q->a + q->b + q->c + q->d;
}

__attribute__((noinline))
static void rotate_quad(quad_t *q)
{
    uint32_t t = q->a;
    q->a = q->b;
    q->b = q->c;
    q->c = q->d;
    q->d = t;
}

typedef struct {
    quad_t inner;
    uint32_t tag;
} tagged_t;

__attribute__((noinline))
static uint32_t sum_array_of_quads(const quad_t *arr, uint32_t n)
{
    uint32_t s = 0;
    for (uint32_t i = 0; i < n; i++)
        s += sum_quad(&arr[i]);
    return s;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    quad_t q = { 1, 2, 3, 4 };
    OUT[0] = sum_quad(&q);        /* 10 */
    rotate_quad(&q);
    OUT[1] = q.a;                 /* 2 */
    OUT[2] = q.b;                 /* 3 */
    OUT[3] = q.c;                 /* 4 */
    OUT[4] = q.d;                 /* 1 */
    OUT[5] = sum_quad(&q);        /* still 10 */

    tagged_t t;
    t.inner.a = 10; t.inner.b = 20; t.inner.c = 30; t.inner.d = 40;
    t.tag = 0xABCD;
    OUT[6] = sum_quad(&t.inner);  /* 100 */
    OUT[7] = t.tag;

    quad_t arr[4] = {
        {1,1,1,1}, {2,2,2,2}, {3,3,3,3}, {4,4,4,4}
    };
    OUT[8] = sum_array_of_quads(arr, 4);  /* 4+8+12+16 = 40 */

    quad_t *p = &arr[2];
    p++;                            /* pointer arithmetic across struct-sized elements */
    OUT[9] = p->a;                  /* arr[3].a = 4 */
    p--; p--;
    OUT[10] = p->a;                 /* arr[1].a = 2 */

    return OUT[0];
}
