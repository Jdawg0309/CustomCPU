#!/usr/bin/env python3
from pathlib import Path


ROMS = {
    "01_compute_rom": [
        0xE1E01000, 0xE0402001, 0xE0823002, 0xE0834002,
        0xE0845003, 0xE082E202, 0xE0853004, 0xE1450004,
        0xE0056004, 0xE1857004, 0xE0258004, 0xE1C59004,
        0xE1A0A005, 0xE1E0B004, 0xE064C005, 0xE044D005,
    ],
    "02_barrel_rom": [
        0xE1E01000, 0xE0402001, 0xE1A03082, 0xE1A04102,
        0xE1A05202, 0xE1A06402, 0xE1A07802, 0xE1A08F82,
        0xE1A09FA8, 0xE1A0AFC8, 0xE1A0B0E2, 0xE1A0C862,
        0xE1A0DFE2, 0xE082E202, 0xE02130A1, 0xE1C140A1,
    ],
    "03_immediate_rom": [0xE3A030FF, 0xE3A04102, 0xE2835102],
    "04_cpsr_rom": [
        0xE1E01000, 0xE2912001, 0xE3E03102,
        0xE2934001, 0xE2505001, 0xE2516001,
    ],
    "05_condition_rom": [
        0xE3A00000, 0xE2501001, 0x43A02022, 0x53A03033,
        0xE2904000, 0x03A05055, 0x13A06066, 0xE3A07077,
    ],
    "06_branch_rom": [
        0xE3A00001, 0xEA000000, 0xE3A00002, 0xE2801004, 0xEAFFFFFE,
    ],
    "07_branch_cond_rom": [
        0xE3A00002, 0xE2500001, 0x1AFFFFFD, 0xE3A01055, 0xEAFFFFFE,
    ],
    "08_bx_rom": [
        0xE3A02010, 0xE12FFF12, 0xE3A00001,
        0xE3A01002, 0xE3A03033, 0xEAFFFFFE,
    ],
    "09_bx_lr_rom": [
        0xE3A0E010, 0xE12FFF1E, 0xE3A00001,
        0xE3A01002, 0xE3A03033, 0xEAFFFFFE,
    ],
    "10_bl_rom": [
        0xE3A00005, 0xEB000001, 0xE3A01033,
        0xEAFFFFFE, 0xE2800001, 0xE12FFF1E,
    ],
    "11_compiled_c_rom": [
        0xE3A00005, 0xE3A01003, 0xE3A0E014,
        0xE0800001, 0xE12FFF1E, 0xEAFFFFFE,
    ],
    "12_memory_rom": [
        0xE3A000AA, 0xE3A01020, 0xE5810004, 0xE5912004,
        0xE3A03055, 0xE5013004, 0xE5114004, 0xE3500000,
        0xE3A05033, 0x05810008, 0x05915008, 0xEAFFFFFE,
    ],
}


def main():
    output_dir = Path(__file__).parent / "regression_roms"
    output_dir.mkdir(exist_ok=True)

    for name, words in ROMS.items():
        if len(words) > 16:
            raise ValueError(f"{name} exceeds the 16-word instruction ROM")
        image = "v3.0 hex words plain\n" + " ".join(f"{word:08x}" for word in words) + "\n"
        (output_dir / name).write_text(image, encoding="ascii")

    print(f"generated {len(ROMS)} regression ROMs in {output_dir}")


if __name__ == "__main__":
    main()
