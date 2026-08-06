unsigned math_06_popcount(void)
{
    unsigned value = 0xB5;
    unsigned count = 0;

    while (value != 0) {
        if ((value & 1u) != 0)
            count++;
        value >>= 1;
    }
    return count;
}
