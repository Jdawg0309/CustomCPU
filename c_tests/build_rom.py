#!/usr/bin/env python3
import argparse
import struct
from pathlib import Path


def binary_words(path: Path) -> tuple[int, ...]:
    compiled = path.read_bytes()
    if len(compiled) % 4:
        raise SystemExit(f"{path} is not a whole number of ARM instructions")
    return struct.unpack(f"<{len(compiled) // 4}I", compiled)


def write_rom(source: Path, destination: Path, prefix: tuple[int, ...] = ()) -> None:
    words = (*prefix, *binary_words(source))
    destination.write_text(
        "v3.0 hex words plain\n" + " ".join(f"{word:08x}" for word in words) + "\n",
        encoding="ascii",
    )
    print(f"{destination}: {len(words)} words")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", nargs="?", default="add.bin", type=Path)
    parser.add_argument("destination", nargs="?", default="add_rom", type=Path)
    parser.add_argument(
        "--add-harness",
        action="store_true",
        help="prepend the historical MOV/MOV/MOV harness and append B .",
    )
    args = parser.parse_args()

    prefix: tuple[int, ...] = ()
    if args.add_harness:
        prefix = (0xE3A00005, 0xE3A01003, 0xE3A0E014)
        compiled = binary_words(args.source)
        words = (*prefix, *compiled, 0xEAFFFFFE)
        args.destination.write_text(
            "v3.0 hex words plain\n"
            + " ".join(f"{word:08x}" for word in words)
            + "\n",
            encoding="ascii",
        )
        print(f"{args.destination}: {len(words)} words")
        return

    write_rom(args.source, args.destination)


if __name__ == "__main__":
    main()
