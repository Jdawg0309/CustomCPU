#include <stdio.h>

unsigned math_01_gcd(void);
unsigned math_02_fibonacci(void);
unsigned math_03_factorial(void);
unsigned math_04_integer_sqrt(void);
unsigned math_05_collatz(void);
unsigned math_06_popcount(void);
unsigned math_07_array_sum_ram(void);
unsigned math_08_derivative_x2(void);
unsigned math_09_taylor_e_q8_8(void);
int math_10_relu_perceptron(void);
unsigned math_11_fibonacci_ram_integration(void);
unsigned math_12_fibonacci_ram_0_to_46(unsigned *ram);
unsigned math_13_rule30_ram(unsigned *ram);

static int check(const char *name, unsigned actual, unsigned expected)
{
    printf("%-28s actual=0x%08X expected=0x%08X %s\n",
           name, actual, expected, actual == expected ? "PASS" : "FAIL");
    return actual != expected;
}

int main(void)
{
    int failures = 0;
    unsigned fibonacci_ram[47];
    unsigned rule30_ram[64];

    failures += check("gcd(48, 18)", math_01_gcd(), 6);
    failures += check("fibonacci(10)", math_02_fibonacci(), 55);
    failures += check("factorial(5)", math_03_factorial(), 120);
    failures += check("floor(sqrt(81))", math_04_integer_sqrt(), 9);
    failures += check("collatz_steps(13)", math_05_collatz(), 9);
    failures += check("popcount(0xB5)", math_06_popcount(), 5);
    failures += check("sum({3, 5, 7})", math_07_array_sum_ram(), 15);
    failures += check("derivative(x^2, x=5)", math_08_derivative_x2(), 10);
    failures += check("taylor_e_q8_8", math_09_taylor_e_q8_8(), 0x2B8);
    failures += check("relu_perceptron", (unsigned)math_10_relu_perceptron(), 3);
    failures += check("fibonacci RAM integration",
                      math_11_fibonacci_ram_integration(), 0xE9);
    failures += check("F0..F46 RAM fill",
                      math_12_fibonacci_ram_0_to_46(fibonacci_ram), 0x6D73E55F);
    failures += check("RAM[0]", fibonacci_ram[0], 0);
    failures += check("RAM[1]", fibonacci_ram[1], 1);
    failures += check("RAM[10]", fibonacci_ram[10], 55);
    failures += check("RAM[46]", fibonacci_ram[46], 0x6D73E55F);
    failures += check("Rule 30 generation 63",
                      math_13_rule30_ram(rule30_ram), 0x44955555);

    return failures != 0;
}
