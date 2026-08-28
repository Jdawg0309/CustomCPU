#!/usr/bin/env python3
"""Run real assembled ARM through the smoke-test main and print the trace.

usage: smoke_run.py <file.circ> <asm-file-or-'-'> [max_seconds]

Patches every 32-bit ROM in the file with the program image (same rule the
push/pop suites use: a design with a literal-pool port has two identical ROMs),
then runs headless with --tty table,halt and prints the output-pin table.
"""
import os, re, subprocess, sys, tempfile

AS = "arm-none-eabi-as"
OC = "arm-none-eabi-objcopy"
JAR = "/snap/logisim-evolution/current/logisim-evolution/logisim-evolution.jar"


def assemble(asm, wd):
    src, obj, binf = (os.path.join(wd, n) for n in ("t.S", "t.o", "t.bin"))
    open(src, "w").write(asm)
    subprocess.run([AS, "-march=armv4t", "-o", obj, src], check=True)
    subprocess.run([OC, "-O", "binary", obj, binf], check=True)
    data = open(binf, "rb").read()
    return ["%08x" % int.from_bytes(data[i:i+4], "little")
            for i in range(0, len(data), 4)]


def patch(circ, words, wd):
    src = open(circ).read()
    roms, pos = [], 0
    while True:
        m = re.search(r'<comp lib="2"[^>]*name="ROM">.*?</comp>', src[pos:], re.S)
        if not m:
            break
        if 'val="32"' in m.group(0):
            roms.append(m.group(0))
        pos += m.end()
    assert roms, "no 32-bit ROM anywhere in the file"
    for rom in roms:
        aw = int(re.search(r'addrWidth" val="(\d+)"', rom).group(1))
        assert len(words) <= (1 << aw), "program too big for addrWidth=%d" % aw
        new = re.sub(r'<a name="contents">.*?</a>',
                     '<a name="contents">addr/data: %d 32\n%s\n</a>' % (aw, " ".join(words)),
                     rom, flags=re.S)
        src = src.replace(rom, new, 1)
    out = os.path.join(wd, "t.circ")
    open(out, "w").write(src)
    return out, len(roms)


def main():
    circ = sys.argv[1]
    asm = sys.stdin.read() if sys.argv[2] == "-" else open(sys.argv[2]).read()
    timeout = int(sys.argv[3]) if len(sys.argv) > 3 else 60
    wd = tempfile.mkdtemp(prefix="smoke_")
    words = assemble(asm, wd)
    print("program: %d words" % len(words))
    for i, w in enumerate(words):
        print("   %02d  0x%s" % (i, w))
    path, nrom = patch(circ, words, wd)
    print("patched %d ROM(s)\n" % nrom)
    cmd = ["xvfb-run", "-a", "java", "-jar", JAR,
           "--tty", "table,halt", "--toplevel-circuit", "main", path]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired as e:
        print("TIMEOUT after %ds -- never reached the halt pin" % timeout)
        print((e.stdout or b"").decode()[-4000:])
        return 2
    print(p.stdout[-8000:])
    if p.stderr.strip():
        print("--- stderr ---")
        print(p.stderr[-4000:])
    return 0


sys.exit(main())
