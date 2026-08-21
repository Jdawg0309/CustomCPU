unsigned math_02_fibonacci(void)
{
    unsigned a = 0;
    unsigned b = 1;
    unsigned count = 10;

    while (count != 0) {
        unsigned next = a + b;
        a = b;
        b = next;
        count--;
    }
    return a;
}
