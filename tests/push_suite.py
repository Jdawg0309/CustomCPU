#!/usr/bin/env python3
"""10-ROM PUSH discriminator suite. Each test:
  - sets SP and a distinct value per register under test (MOV-immediate only,
    so every value is trivially achievable in ARMv4T without a literal pool)
  - executes one or two STMDB SP!,{...} (i.e. `push {...}`) forms
  - returns via `bx lr` so the headless harness halts cleanly
Expected RAM layout is computed independently from ARM STMDB semantics
(ascending register number -> ascending address, lowest reg at final SP)
and checked against the actual RAM dump.
"""
import subprocess, sys, re, tempfile, os

AS = "arm-none-eabi-as"
OC = "arm-none-eabi-objcopy"
JAR = "/snap/logisim-evolution/current/logisim-evolution/logisim-evolution.jar"
# Overridable so a candidate build can be tested without editing this file.
# It silently tested the wrong circuit when passed a path it ignored.
CIRC = sys.argv[1] if len(sys.argv) > 1 else "/home/junaet/Documents/CustomCPU/debug_armv4t.circ"

# ROM occupies 0x0000-0x0FFF, so RAM starts immediately above it. The two used
# to overlap at zero, which made an address decode impossible -- see the
# memory-map note in main. Programs must place data at or above this.
RAM_BASE = 0x1000

def mov_imm(reg, val):
    """Emit MOV (or MVN for all-ones) -- every value used in this suite is
    a plain 0-255 byte or 0xFFFFFFFF, both directly encodable."""
    if val == 0xFFFFFFFF:
        return f"    mvn r{reg}, #0\n"
    assert 0 <= val <= 0xFF, "test values must be single-byte or 0xFFFFFFFF"
    return f"    mov r{reg}, #{val}\n"

def build_asm(sp_init, pushes):
    """pushes: list of {reg: val} dicts, one per sequential `push {...}` block.
    Registers targeting 0 skip their MOV -- every GP register resets to 0,
    so this is a free word-count saving, not a correctness assumption."""
    lines = [".syntax unified", ".arm", ".global _start", "_start:",
             f"    mov sp, #{sp_init}"]
    for regvals in pushes:
        for r, v in sorted(regvals.items()):
            if v == 0:
                continue
            lines.append(mov_imm(r, v).rstrip("\n"))
        reglist = ",".join(f"r{r}" for r in sorted(regvals))
        lines.append(f"    push {{{reglist}}}")
    lines.append("    bx lr")
    return "\n".join(lines) + "\n"

def assemble(asm_text, workdir):
    src = os.path.join(workdir, "t.S")
    obj = os.path.join(workdir, "t.o")
    binf = os.path.join(workdir, "t.bin")
    open(src, "w").write(asm_text)
    subprocess.run([AS, "-march=armv4t", "-o", obj, src], check=True)
    subprocess.run([OC, "-O", "binary", obj, binf], check=True)
    data = open(binf, "rb").read()
    return ["%08x" % int.from_bytes(data[i:i+4], "little")
            for i in range(0, len(data), 4)]

def run_rom(words, workdir):
    """Patch every 32-bit-data ROM in `main` with the same program image.

    A design that gives LDR a second read port into program memory (for
    literal pools) has TWO such ROMs -- the instruction fetch ROM and a
    byte-for-byte duplicate addressed by the load path. Both must hold the
    identical image or a literal-pool load reads stale data. Patching every
    match here (not just the first) keeps this working whether the circuit
    has one ROM or two, with no separate code path for either case.
    """
    src = open(CIRC).read()
    # Search the WHOLE file, not just main.  Once the design is split into
    # pipeline stages the instruction ROM lives inside stage_IF, and a
    # main-only search finds nothing and asserts.
    mstart, mend = 0, len(src)
    body = src
    roms = []
    pos = 0
    while True:
        m = re.search(r'<comp lib="2"[^>]*name="ROM">.*?</comp>', body[pos:], re.S)
        if not m:
            break
        if 'val="32"' in m.group(0):
            roms.append(m.group(0))
        pos += m.end()
    assert roms, "no 32-bit-data ROM found anywhere in the file"
    body2 = body
    for rom in roms:
        aw = int(re.search(r'addrWidth" val="(\d+)"', rom).group(1))
        assert len(words) <= (1 << aw), (
            f"ROM only holds {1 << aw} words (addrWidth={aw}); "
            f"this test needs {len(words)} -- shrink the test, don't expand the ROM."
        )
        new = re.sub(r'(addrWidth" val=")\d+(")', r"\g<1>%d\g<2>" % aw, rom)
        new = re.sub(r'<a name="contents">.*?</a>',
                     '<a name="contents">addr/data: %d 32\n%s\n</a>' % (aw, " ".join(words)),
                     new, flags=re.S)
        body2 = body2.replace(rom, new, 1)
    src2 = src[:mstart] + body2 + src[mend:]
    src2 = src2.replace('label" val="is_BX"', 'label" val="halt"')
    circ = os.path.join(workdir, "t.circ")
    open(circ, "w").write(src2)
    ram_img = os.path.join(workdir, "ram.txt")
    cmd = ["xvfb-run", "-a", "java", "-jar", JAR, "--tty", "halt",
           "--save", ram_img, "--toplevel-circuit", "main", circ]
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
    halted_clean = "halted due to halt pin" in (p.stdout + p.stderr)
    oscillated = "oscillation" in (p.stdout + p.stderr).lower()
    ram = {}
    if os.path.exists(ram_img):
        toks = []
        for line in open(ram_img):
            if line.startswith(("v2.0", "v3.0", "addr/data")):
                continue
            toks += line.split()
        for i, t in enumerate(toks):
            if t != "00000000":
                ram[i] = t
    return halted_clean, oscillated, ram

def expected_ram(sp_init, pushes):
    """ARM STMDB SP!,{list}: ascending reg# -> ascending address, lowest reg
    lands at the final SP. The RAM dump is indexed from RAM's own base, so a
    byte address converts as (addr - RAM_BASE) // 4, not addr // 4."""
    sp = sp_init
    expect = {}
    for regvals in pushes:
        regs = sorted(regvals)
        sp -= 4 * len(regs)
        for k, r in enumerate(regs):
            byte_addr = sp + 4 * k
            expect[(byte_addr - RAM_BASE) // 4] = "%08x" % regvals[r]
    return expect, sp

TESTS = [
    ("two_low",        0x1400, [{0: 0xAA, 1: 0xBB}]),
    ("two_high",       0x1400, [{10: 0x10, 11: 0x11}]),
    ("three_scattered",0x1400, [{0: 0x01, 5: 0x05, 9: 0x09}]),
    ("four_consecutive",0x1400,[{4: 0x44, 5: 0x55, 6: 0x66, 7: 0x77}]),
    ("callee_saved_lr",0x1400, [{4:0x04,5:0x05,6:0x06,7:0x07,8:0x08,9:0x09,10:0x0A,11:0x0B,14:0x0E}]),
    ("fourteen_regs",  0x1400, [{i: i for i in range(13)} | {14: 0x0E}]),
    ("zero_then_ones",  0x1400, [{0: 0x00, 1: 0xFFFFFFFF}]),
    ("all_ones_pair",  0x1400, [{2: 0xFFFFFFFF, 3: 0xFFFFFFFF}]),
    ("middle_regs",    0x1400, [{6: 0x60, 7: 0x70, 8: 0x80}]),
    ("sp_continuity",  0x1400, [{0: 0x01, 1: 0x02}, {2: 0x03, 3: 0x04}]),
]

def main():
    results = []
    for name, sp_init, pushes in TESTS:
        with tempfile.TemporaryDirectory() as wd:
            asm = build_asm(sp_init, pushes)
            words = assemble(asm, wd)
            halted, oscillated, ram = run_rom(words, wd)
            expect, final_sp = expected_ram(sp_init, pushes)
            mismatches = []
            for waddr, exp_val in expect.items():
                got = ram.get(waddr, "00000000")
                if got != exp_val:
                    mismatches.append((waddr, exp_val, got))
            extra = [waddr for waddr in ram if waddr not in expect]
            ok = halted and not oscillated and not mismatches and not extra
            results.append((name, ok, halted, oscillated, mismatches, extra, expect))
            status = "PASS" if ok else "FAIL"
            print(f"[{status}] {name}")
            if not halted:
                print("    did not halt cleanly")
            if oscillated:
                print("    OSCILLATION DETECTED")
            for waddr, exp_val, got in mismatches:
                print(f"    RAM[{waddr:02x}] expected {exp_val} got {got}")
            for waddr in extra:
                print(f"    unexpected write at RAM[{waddr:02x}] = {ram[waddr]}")
    print()
    npass = sum(1 for r in results if r[1])
    print(f"{npass}/{len(results)} passed")
    return 0 if npass == len(results) else 1

if __name__ == "__main__":
    sys.exit(main())
