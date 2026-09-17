#!/usr/bin/env python3
"""Dependency-free golden model and vector generator for the INT8 NPU.

The arithmetic contract is deliberately explicit:
  * A and B are signed INT8.
  * Products accumulate into signed INT32 (two's-complement wrap).
  * Per-output-column INT32 bias is optional.
  * ReLU is applied before requantization.
  * Requantization is an arithmetic right shift (floor for negatives).
  * INT8 output is saturated to [-128, 127].
"""

from __future__ import annotations

import argparse
import json
import random
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable, Sequence


def int8(value: int) -> int:
    if not -128 <= value <= 127:
        raise ValueError(f"INT8 operand out of range: {value}")
    return value


def wrap_i32(value: int) -> int:
    value &= 0xFFFF_FFFF
    return value - 0x1_0000_0000 if value & 0x8000_0000 else value


def saturate_i8(value: int) -> int:
    return max(-128, min(127, value))


def _shape(matrix: Sequence[Sequence[int]], name: str) -> tuple[int, int]:
    rows = len(matrix)
    cols = len(matrix[0]) if rows else 0
    if any(len(row) != cols for row in matrix):
        raise ValueError(f"{name} is ragged")
    return rows, cols


@dataclass(frozen=True)
class PostProcess:
    bias_enable: bool = False
    relu_enable: bool = False
    int8_enable: bool = True
    requant_shift: int = 0

    def __post_init__(self) -> None:
        if not 0 <= self.requant_shift <= 31:
            raise ValueError("requant_shift must be in [0, 31]")


@dataclass
class GemmResult:
    accumulator: list[list[int]]
    int8_output: list[list[int]]


def gemm(
    a: Sequence[Sequence[int]],
    b: Sequence[Sequence[int]],
    bias: Sequence[int] | None = None,
    post: PostProcess = PostProcess(),
) -> GemmResult:
    m, k_a = _shape(a, "A")
    k_b, n = _shape(b, "B")
    if not m or not n or not k_a or k_a != k_b:
        raise ValueError(f"incompatible GEMM shapes A={m}x{k_a}, B={k_b}x{n}")
    if post.bias_enable and (bias is None or len(bias) != n):
        raise ValueError(f"bias must have N={n} entries")
    for row in a:
        for value in row:
            int8(value)
    for row in b:
        for value in row:
            int8(value)

    acc = [[0 for _ in range(n)] for _ in range(m)]
    out = [[0 for _ in range(n)] for _ in range(m)]
    for i in range(m):
        for j in range(n):
            value = 0
            for k in range(k_a):
                value = wrap_i32(value + a[i][k] * b[k][j])
            if post.bias_enable:
                value = wrap_i32(value + int(bias[j]))  # type: ignore[index]
            if post.relu_enable and value < 0:
                value = 0
            acc[i][j] = value
            quantized = value >> post.requant_shift
            out[i][j] = saturate_i8(quantized if post.int8_enable else value)
    return GemmResult(accumulator=acc, int8_output=out)


def im2col_nhwc(
    image: Sequence[Sequence[Sequence[int]]],
    kernel_h: int,
    kernel_w: int,
    *,
    stride: tuple[int, int] = (1, 1),
    padding: tuple[int, int] = (0, 0),
    dilation: tuple[int, int] = (1, 1),
) -> tuple[list[list[int]], int, int]:
    """Lower one signed-INT8 HWC image to [OH*OW, KH*KW*C]."""
    h = len(image)
    w = len(image[0]) if h else 0
    c = len(image[0][0]) if w else 0
    if not h or not w or not c:
        raise ValueError("image must be non-empty HWC")
    if any(len(row) != w or any(len(pixel) != c for pixel in row) for row in image):
        raise ValueError("image is ragged")
    sh, sw = stride
    ph, pw = padding
    dh, dw = dilation
    effective_h = dh * (kernel_h - 1) + 1
    effective_w = dw * (kernel_w - 1) + 1
    out_h = (h + 2 * ph - effective_h) // sh + 1
    out_w = (w + 2 * pw - effective_w) // sw + 1
    if min(kernel_h, kernel_w, sh, sw, dh, dw, out_h, out_w) <= 0:
        raise ValueError("invalid convolution geometry")

    lowered: list[list[int]] = []
    for oy in range(out_h):
        for ox in range(out_w):
            row: list[int] = []
            for ky in range(kernel_h):
                iy = oy * sh + ky * dh - ph
                for kx in range(kernel_w):
                    ix = ox * sw + kx * dw - pw
                    if 0 <= iy < h and 0 <= ix < w:
                        row.extend(int8(v) for v in image[iy][ix])
                    else:
                        row.extend([0] * c)
            lowered.append(row)
    return lowered, out_h, out_w


def conv2d_nhwc(
    image: Sequence[Sequence[Sequence[int]]],
    weights: Sequence[Sequence[Sequence[Sequence[int]]]],
    bias: Sequence[int] | None = None,
    post: PostProcess = PostProcess(),
    **geometry: object,
) -> tuple[GemmResult, int, int]:
    """Convolution using weights [KH][KW][C][OC], returned flattened spatially."""
    kh = len(weights)
    kw = len(weights[0]) if kh else 0
    channels = len(weights[0][0]) if kw else 0
    outputs = len(weights[0][0][0]) if channels else 0
    if not all((kh, kw, channels, outputs)):
        raise ValueError("weights must be non-empty KHxKWxCxOC")
    if any(len(weights[y]) != kw for y in range(kh)):
        raise ValueError("weights are ragged")
    lowered, out_h, out_w = im2col_nhwc(image, kh, kw, **geometry)
    kernel = [[0 for _ in range(outputs)] for _ in range(kh * kw * channels)]
    q = 0
    for ky in range(kh):
        for kx in range(kw):
            for ch in range(channels):
                if len(weights[ky][kx][ch]) != outputs:
                    raise ValueError("weights are ragged")
                kernel[q] = [int8(v) for v in weights[ky][kx][ch]]
                q += 1
    return gemm(lowered, kernel, bias, post), out_h, out_w


def random_case(rng: random.Random, case_id: int, max_dim: int = 40) -> dict:
    # Bias dimensions around array/tile boundaries without assuming a tile size.
    edges = [1, 2, 3, 7, 15, 31, 32, 33, max_dim]
    m = rng.choice([v for v in edges if v <= max_dim])
    n = rng.choice([v for v in edges if v <= max_dim])
    k = rng.choice([v for v in edges if v <= max_dim])
    a = [[rng.randint(-128, 127) for _ in range(k)] for _ in range(m)]
    b = [[rng.randint(-128, 127) for _ in range(n)] for _ in range(k)]
    bias = [rng.randint(-200_000, 200_000) for _ in range(n)]
    post = PostProcess(
        bias_enable=rng.choice([False, True]),
        relu_enable=rng.choice([False, True]),
        int8_enable=True,
        requant_shift=rng.randint(0, 15),
    )
    result = gemm(a, b, bias, post)
    return {
        "id": case_id,
        "m": m,
        "n": n,
        "k": k,
        "a_row_major": [x for row in a for x in row],
        "b_row_major": [x for row in b for x in row],
        "bias": bias,
        "config": asdict(post),
        "expected_acc_row_major": [x for row in result.accumulator for x in row],
        "expected_i8_row_major": [x for row in result.int8_output for x in row],
    }


def generate_vectors(path: Path, seed: int, count: int, max_dim: int) -> None:
    rng = random.Random(seed)
    payload = {
        "format": "customcpu-npu-v1",
        "seed": seed,
        "arithmetic": "signed-i8 multiply, wrapping signed-i32 accumulate",
        "cases": [random_case(rng, i, max_dim) for i in range(count)],
    }
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seed", type=lambda x: int(x, 0), default=0x4E5055)
    parser.add_argument("--count", type=int, default=25)
    parser.add_argument("--max-dim", type=int, default=40)
    args = parser.parse_args()
    generate_vectors(args.output, args.seed, args.count, args.max_dim)


if __name__ == "__main__":
    main()
