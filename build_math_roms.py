#!/usr/bin/env python3
import struct
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SOURCE_DIR = ROOT / "math_roms" / "src"
OUTPUT_DIR = ROOT / "math_roms"


def run(command):
    subprocess.run(command, check=True)


def main():
    sources = sorted(SOURCE_DIR.glob("*.S"))
    with tempfile.TemporaryDirectory() as temporary:
        temporary = Path(temporary)
        for source in sources:
            stem = source.stem
            obj = temporary / f"{stem}.o"
            binary = temporary / f"{stem}.bin"
            dump = OUTPUT_DIR / f"{stem}.dump"
            rom = OUTPUT_DIR / f"{stem}_rom"

            run(["arm-none-eabi-as", "-mcpu=arm7tdmi", "-o", obj, source])
            run(["arm-none-eabi-objcopy", "-O", "binary", "-j", ".text", obj, binary])
            with dump.open("w", encoding="ascii") as output:
                subprocess.run(["arm-none-eabi-objdump", "-d", obj], check=True, stdout=output)

            data = binary.read_bytes()
            if len(data) % 4:
                raise ValueError(f"{source.name}: non-word-aligned output")
            words = struct.unpack(f"<{len(data) // 4}I", data)
            if len(words) > 16:
                raise ValueError(f"{source.name}: {len(words)} words exceeds the 16-word ROM")

            rom.write_text(
                "v3.0 hex words plain\n" + " ".join(f"{word:08x}" for word in words) + "\n",
                encoding="ascii",
            )
            print(f"{rom.name}: {len(words)} words")


if __name__ == "__main__":
    main()
