static unsigned square_by_addition(unsigned value)
{
    unsigned square = 0;
    unsigned count = value;

    while (count != 0) {
        square += value;
        count--;
    }
    return square;
}

unsigned math_08_derivative_x2(void)
{
    unsigned x = 5;
    return (square_by_addition(x + 1) - square_by_addition(x - 1)) >> 1;
}
