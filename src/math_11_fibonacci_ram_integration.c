unsigned math_11_fibonacci_ram_integration(void)
{
    unsigned ram[2];
    unsigned a = 0;
    unsigned b = 1;
    unsigned count = 10;

    while (count != 0) {
        unsigned next = a + b;
        a = b;
        b = next;
        count--;
    }

    ram[0] = a;
    ram[1] = b;
    return ram[0] + (ram[1] << 1);
}
