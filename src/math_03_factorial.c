unsigned math_03_factorial(void)
{
    unsigned factor = 5;
    unsigned product = 1;

    while (factor > 1) {
        unsigned old_product = product;
        unsigned count = factor;
        product = 0;
        while (count != 0) {
            product += old_product;
            count--;
        }
        factor--;
    }
    return product;
}
