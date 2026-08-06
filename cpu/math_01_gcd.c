unsigned math_01_gcd(void)
{
    unsigned a = 48;
    unsigned b = 18;

    while (a != b) {
        if (a > b)
            a -= b;
        else
            b -= a;
    }
    return a;
}
