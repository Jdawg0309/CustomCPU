unsigned math_04_integer_sqrt(void)
{
    unsigned remainder = 81;
    unsigned root = 0;
    unsigned odd = 1;

    while (remainder >= odd) {
        remainder -= odd;
        odd += 2;
        root++;
    }
    return root;
}
