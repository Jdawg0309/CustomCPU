unsigned math_05_collatz(void)
{
    unsigned value = 13;
    unsigned steps = 0;

    while (value != 1) {
        if ((value & 1u) == 0)
            value >>= 1;
        else
            value = value + (value << 1) + 1;
        steps++;
    }
    return steps;
}
