#!/usr/bin/env python3
"""Classify adversarial GCC images before they are loaded into the CPU."""

from pathlib import Path


HERE = Path(__file__).resolve().parent
RUNNABLE = {
    "stress_signed": {"mvn", "sub", "str", "subs", "ldr", "beq", "mov", "add", "eor", "cmp", "bne", "bl", "bx", "b"},
    "stress_memory": {"subs", "beq", "mov", "str", "ldr", "add", "bne", "bl", "bx", "b"},
}


def mnemonics(path: Path) -> set[str]:
    found = set()
    for line in path.read_text(encoding="ascii").splitlines():
        fields = line.split("\t")
        if len(fields) >= 3 and fields[0].strip().endswith(":"):
            found.add(fields[2].split()[0])
    return found


def main() -> None:
    for name, allowed in RUNNABLE.items():
        found = mnemonics(HERE / f"{name}.dump")
        unsupported = found - allowed
        if unsupported:
            raise SystemExit(f"{name}: unexpected instructions: {sorted(unsupported)}")
        print(f"{name}: implemented instruction subset PASS")

    call_instructions = mnemonics(HERE / "stress_call.dump")
    missing = {"push", "pop"} - call_instructions
    if missing:
        raise SystemExit("stress_call no longer exposes the expected PUSH/POP boundary")
    print("stress_call: expected unsupported PUSH/POP boundary PASS")


if __name__ == "__main__":
    main()
