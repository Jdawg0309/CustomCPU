#!/usr/bin/env python3
"""Small deterministic convolution-to-GEMM reference for the NPU baseline."""

def im2col(image, kernel_h, kernel_w):
    height, width = len(image), len(image[0])
    rows = []
    for oy in range(height - kernel_h + 1):
        for ox in range(width - kernel_w + 1):
            rows.append([
                image[oy + ky][ox + kx]
                for ky in range(kernel_h)
                for kx in range(kernel_w)
            ])
    return rows


def gemm(a, b):
    return [[sum(a[i][k] * b[k][j] for k in range(len(b)))
             for j in range(len(b[0]))]
            for i in range(len(a))]


def main():
    image = [
        [1,  2,  3,  4],
        [5,  6,  7,  8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
    ]
    # Two 3x3 output channels, stored as K x N for the accelerator.
    filters = [
        [1, 0], [0, 1], [-1, 0],
        [1, 0], [0, 1], [-1, 0],
        [1, 0], [0, 1], [-1, 0],
    ]
    a = im2col(image, 3, 3)
    got = gemm(a, filters)
    expected = [[-6, 18], [-6, 21], [-6, 30], [-6, 33]]
    assert got == expected, (got, expected)
    print("PASS im2col convolution maps to GEMM M=4 K=9 N=2")
    print("A =", a)
    print("B =", filters)
    print("C =", got)


if __name__ == "__main__":
    main()
