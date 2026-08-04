#!/usr/bin/env python3
import struct
from pathlib import Path


compiled = Path("add.bin").read_bytes()
if len(compiled) % 4:
    raise SystemExit("add.bin is not a whole number of ARM instructions")

compiled_words = struct.unpack(f"<{len(compiled) // 4}I", compiled)

# Initialize the ARM calling-convention inputs, execute compiled add(), then
# return through LR to a permanent loop at ROM word 5 (byte address 0x14).
words = (
    0xE3A00005,  # MOV R0,#5
    0xE3A01003,  # MOV R1,#3
    0xE3A0E014,  # MOV R14,#0x14
    *compiled_words,
    0xEAFFFFFE,  # B .
)

Path("add_rom").write_text(
    "v3.0 hex words plain\n" + " ".join(f"{word:08x}" for word in words) + "\n",
    encoding="ascii",
)
