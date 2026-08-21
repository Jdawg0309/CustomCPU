int math_10_relu_perceptron(void)
{
    int x0 = 4;
    int x1 = 3;
    int x2 = 5;
    int value = (x0 + (x0 << 1)) + (x1 << 1) - x2 - 10;

    return value < 0 ? 0 : value;
}
