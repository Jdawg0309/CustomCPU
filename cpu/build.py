#!/usr/bin/env python3
"""Build and validate the flat CustomCPU ROM release bundle."""

from __future__ import annotations

import argparse
import re
import subprocess
import tempfile
from pathlib import Path


HERE = Path(__file__).resolve().parent
PLAIN_HEADER = "v3.0 hex words plain"
ADDRESSED_HEADER = "v3.0 hex words addressed"
WORD_RE = re.compile(r"^[0-9a-fA-F]{8}$")


def rom_words(path: Path) -> list[str]:
    lines = [line.strip() for line in path.read_text().splitlines() if line.strip()]
    if not lines or lines[0] != PLAIN_HEADER:
        raise ValueError(f"{path.name}: expected a plain Logisim ROM image")
    words = " ".join(lines[1:]).split()
    if any(not WORD_RE.fullmatch(word) for word in words):
        raise ValueError(f"{path.name}: expected one 32-bit hexadecimal word per line")
    return [word.lower() for word in words]


def assemble(source: Path) -> list[str]:
    with tempfile.TemporaryDirectory(prefix="customcpu-") as temp_dir:
        obj = Path(temp_dir) / "program.o"
        binary = Path(temp_dir) / "program.bin"
        subprocess.run(
            ["arm-none-eabi-as", "-mcpu=arm7tdmi", "-o", obj, source],
            check=True,
        )
        subprocess.run(
            ["arm-none-eabi-objcopy", "-O", "binary", obj, binary],
            check=True,
        )
        data = binary.read_bytes()
    if len(data) % 4:
        raise ValueError(f"{source.name}: output size is not word aligned")
    return [data[i : i + 4][::-1].hex() for i in range(0, len(data), 4)]


def write_rom(path: Path, words: list[str]) -> None:
    path.write_text(PLAIN_HEADER + "\n" + " ".join(words) + "\n")


def build_math_roms(check_only: bool) -> None:
    for source in sorted(HERE.glob("[0-9][0-9]_*.S")):
        output = HERE / f"math_{source.stem}.rom"
        words = assemble(source)
        if len(words) > 16:
            raise ValueError(f"{source.name}: {len(words)} words exceed the 16-word ROM")
        if check_only:
            if not output.exists() or rom_words(output) != words:
                raise ValueError(f"{output.name}: stale; run python3 build.py")
        else:
            write_rom(output, words)
        print(f"{output.name}: {len(words):2d} words")


def validate_bundle() -> None:
    roms = sorted(HERE.glob("*.rom"))
    if not roms:
        raise ValueError("no ROM files found")
    for rom in roms:
        if rom.name == "decode_opcode.rom":
            if not rom.read_text().startswith(ADDRESSED_HEADER + "\n"):
                raise ValueError("decode_opcode.rom: expected an addressed Logisim image")
            continue
        words = rom_words(rom)
        if len(words) > 16:
            raise ValueError(f"{rom.name}: {len(words)} words exceed the 16-word ROM")
    print(f"validated {len(roms)} ROM files")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="fail if generated ROMs are stale")
    args = parser.parse_args()
    build_math_roms(args.check)
    validate_bundle()


if __name__ == "__main__":
    main()
