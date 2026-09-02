unsigned math_07_array_sum_ram(void)
{
    unsigned values[3] = {3, 5, 7};
    unsigned sum = 0;
    unsigned i;

    for (i = 0; i < 3; i++)
        sum += values[i];
    return sum;
}
