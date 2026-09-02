unsigned math_13_rule30_ram(unsigned *ram)
{
    unsigned row = 0x00010000;
    unsigned i;

    for (i = 0; i < 64; i++) {
        ram[i] = row;
        row = (row << 1) ^ (row | (row >> 1));
    }
    return ram[63];
}
