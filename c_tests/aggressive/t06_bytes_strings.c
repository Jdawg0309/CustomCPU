#include <stdint.h>

#define OUT ((volatile uint32_t *)0x1000)

__attribute__((noinline))
static uint32_t my_strlen(const char *s)
{
    uint32_t n = 0;
    while (s[n] != 0) n++;
    return n;
}

__attribute__((noinline))
static void my_memcpy(uint8_t *dst, const uint8_t *src, uint32_t n)
{
    for (uint32_t i = 0; i < n; i++)
        dst[i] = src[i];
}

__attribute__((noinline))
static uint32_t my_memcmp(const uint8_t *a, const uint8_t *b, uint32_t n)
{
    for (uint32_t i = 0; i < n; i++)
        if (a[i] != b[i]) return (uint32_t)a[i] - (uint32_t)b[i];
    return 0;
}

__attribute__((noinline))
static uint32_t checksum8(const uint8_t *p, uint32_t n)
{
    uint32_t s = 0;
    for (uint32_t i = 0; i < n; i++)
        s = (s << 1) ^ p[i];
    return s;
}

__attribute__((noinline))
static int32_t to_upper_ascii(int32_t c)
{
    if (c >= 'a' && c <= 'z') return c - ('a' - 'A');
    return c;
}

uint32_t main(uint32_t unused)
{
    (void)unused;
    static const char msg[] = "the quick brown fox jumps over the lazy dog";
    OUT[0] = my_strlen(msg);

    uint8_t buf[64];
    for (uint32_t i = 0; i < 64; i++) buf[i] = 0;
    my_memcpy(buf, (const uint8_t *)msg, my_strlen(msg) + 1);
    OUT[1] = my_strlen((const char *)buf);
    OUT[2] = my_memcmp((const uint8_t *)msg, buf, my_strlen(msg));

    buf[0] = 'T';
    OUT[3] = my_memcmp((const uint8_t *)msg, buf, my_strlen(msg));  /* nonzero */

    OUT[4] = checksum8((const uint8_t *)msg, my_strlen(msg));

    uint32_t upcount = 0;
    for (uint32_t i = 0; i < 64 && buf[i]; i++) {
        int32_t up = to_upper_ascii((int32_t)(int8_t)buf[i]);
        if (up != (int32_t)(int8_t)buf[i]) upcount++;
    }
    OUT[5] = upcount;   /* number of lowercase letters converted */

    /* signed byte edge cases */
    int8_t neg = -1;
    OUT[6] = (uint32_t)(int32_t)neg;        /* sign-extends to 0xFFFFFFFF */
    uint8_t as_unsigned = (uint8_t)neg;
    OUT[7] = (uint32_t)as_unsigned;          /* 0x000000FF */

    return OUT[0];
}
