#!/usr/bin/env python3
import random
import unittest

from golden_npu import PostProcess, conv2d_nhwc, gemm, im2col_nhwc, random_case


class GoldenNpuTests(unittest.TestCase):
    def test_signed_dot_product(self):
        got = gemm([[-128, -1, 0, 1, 127]], [[1], [-2], [3], [-4], [-5]])
        self.assertEqual(got.accumulator, [[-765]])
        self.assertEqual(got.int8_output, [[-128]])

    def test_bias_relu_shift_and_saturation(self):
        post = PostProcess(True, True, True, 2)
        got = gemm([[100, 100], [-100, -100]], [[100, -100], [100, -100]],
                   [0, 100], post)
        self.assertEqual(got.accumulator, [[20000, 0], [0, 20100]])
        self.assertEqual(got.int8_output, [[127, 0], [0, 127]])

    def test_negative_arithmetic_shift(self):
        post = PostProcess(False, False, True, 2)
        got = gemm([[-3]], [[1]], post=post)
        self.assertEqual(got.int8_output, [[-1]])

    def test_im2col_padding_stride_dilation(self):
        image = [[[y * 3 + x] for x in range(3)] for y in range(3)]
        col, oh, ow = im2col_nhwc(image, 2, 2, padding=(1, 1))
        self.assertEqual((oh, ow), (4, 4))
        self.assertEqual(col[0], [0, 0, 0, 0])
        self.assertEqual(col[5], [0, 1, 3, 4])
        dilated, dh, dw = im2col_nhwc(image, 2, 2, dilation=(2, 2))
        self.assertEqual((dh, dw), (1, 1))
        self.assertEqual(dilated, [[0, 2, 6, 8]])

    def test_conv_matches_hand_calculation(self):
        image = [[[1], [2], [3]], [[4], [5], [6]], [[7], [8], [9]]]
        weights = [[[[1, -1]], [[0, 1]]], [[[0, 1]], [[-1, 0]]]]
        result, oh, ow = conv2d_nhwc(image, weights, [1, -2],
                                     PostProcess(True, False, True, 0))
        self.assertEqual((oh, ow), (2, 2))
        self.assertEqual(result.accumulator, [[-3, 3], [-3, 4], [-3, 6], [-3, 7]])

    def test_random_cases_are_reproducible_and_in_range(self):
        first = random_case(random.Random(123), 0, 8)
        second = random_case(random.Random(123), 0, 8)
        self.assertEqual(first, second)
        self.assertTrue(all(-128 <= x <= 127 for x in first["expected_i8_row_major"]))

    def test_random_gemm_against_independent_scalar_sum(self):
        rng = random.Random(0xC0FFEE)
        for _ in range(100):
            m, n, k = (rng.randint(1, 6) for _ in range(3))
            a = [[rng.randint(-128, 127) for _ in range(k)] for _ in range(m)]
            b = [[rng.randint(-128, 127) for _ in range(n)] for _ in range(k)]
            got = gemm(a, b)
            expected = [[sum(a[i][q] * b[q][j] for q in range(k))
                         for j in range(n)] for i in range(m)]
            self.assertEqual(got.accumulator, expected)


if __name__ == "__main__":
    unittest.main(verbosity=2)
