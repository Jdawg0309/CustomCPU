unsigned math_12_fibonacci_ram_0_to_46(unsigned *ram)
{
    unsigned a = 0;
    unsigned b = 1;
    unsigned i;

    for (i = 0; i < 47; i++) {
        unsigned next;

        ram[i] = a;
        next = a + b;
        a = b;
        b = next;
    }
    return ram[46];
}
