# Math ROM Pack

Load one `*_rom` file into `instr_rom`, reset the CPU, and tick until the final
self-loop. All programs target ARM7TDMI in ARM state and fit the 16-word ROM.

| ROM | Algorithm | Expected result |
|---|---|---|
| `01_gcd_rom` | Euclidean GCD of 48 and 18 | R0=6, R1=6 |
| `02_fibonacci_rom` | Fibonacci F(10) | R0=55, R1=89 |
| `03_factorial_rom` | 5! using repeated-add multiplication | R1=120 |
| `04_integer_sqrt_rom` | floor(sqrt(81)) by odd subtraction | R1=9, R0=0 |
| `05_collatz_rom` | Collatz trajectory from 13 | R0=1, R1=9 steps |
| `06_popcount_rom` | popcount(0xB5) | R1=5 |
| `07_array_sum_ram_rom` | sum RAM array {3,5,7} | R2=15 |
| `08_derivative_x2_rom` | central difference of x^2 at x=5 | R5=10 |
| `09_taylor_e_q8_8_rom` | Taylor approximation of e in Q8.8 | R0=0x2B8 = 2.71875 |
| `10_relu_perceptron_rom` | ReLU(3*x0 + 2*x1 - x2 - 10) | R3=3 |

The derivative computes `(f(6)-f(4))/2` with squares formed by repeated
addition. The Taylor ROM accumulates rounded Q8.8 terms through `1/5!`; it is a
fixed-input demonstration until CPU MUL/division support is integrated.

Regenerate ROMs and disassemblies with:

```text
python3 build_math_roms.py
```

Longer and parameterized numerical kernels require a wider instruction ROM.
ONNX support later needs a compiler/runtime that lowers graph operators into CPU
control code plus NPU kernels; ONNX itself is not executed directly by hardware.
