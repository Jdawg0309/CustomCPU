#!/usr/bin/env python3
"""Run an ARM program on the CPU through GHDL, using the VHDL that Logisim
itself exports from the circuit.  Nothing here models the CPU.

    circuit.circ --(Logisim HDL export, program in ROM)--> VHDL
                 --(GHDL + tests/vhdl/tb_main.vhd)-------> VCD waveform
                 --(this file reads the waveform)--------> RAM / registers

The testbench only drives clock and reset.  Results come from the waveform:
RAM contents are rebuilt from the exported RAM's own write strobes, sampled on
the clock edge that performs the write, and registers are the final value of
each exported REGISTER_FLIP_FLOP.

    python3 tests/vhdl_run.py arm_custom_subset.circ prog.S [max_cycles]

`run()` returns (status, ram, regs) where status is "OK" (halted) or "HANG",
ram maps word index (from RAM base) -> "%08x" for every nonzero word, the same
convention as tests/push_suite.py, and regs maps instance label -> value.
Register *labels* are Logisim instance labels inside reg16x32 -- a label is
not proof of architectural register number.
"""
import hashlib
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "tests"))
import vhdl_export                                          # noqa: E402
import push_suite as ps                                     # noqa: E402  (assembler only)

TB = ROOT / "tests" / "vhdl" / "tb_main.vhd"
CACHE = ROOT / "build" / "vhdl"
GHDL = ["ghdl"]
STD = "--std=08"
HEADER = ".syntax unified\n.arm\n.global _start\n_start:\n"

MEM = "/tb_main/dut/stage_mem_1/"
SIGNALS = {
    "gclk": "/tb_main/gclk",
    "cpsr": "/tb_main/dut/stage_ex_1/cpsr_reg/s_currentstate",
    "pc": "/tb_main/dut/stage_if_1/pc_fetch_1/pc/s_currentstate",
}
for _n in range(16):
    SIGNALS["R%d" % _n] = "/tb_main/dut/stage_id_1/reg16x32_1_1/r%d/s_currentstate" % _n


def ram_signals(src):
    """Per byte lane j: write strobe weJ, address addrJ, data dinJ, plus the
    bit range of dinJ that lane j writes.  Two layouts are understood:
      DATA_RAM            one 32-bit RAM with byte enables (s_we0..s_we3)
      DATA_RAM_B0..B3     four 8-bit RAMs, one per lane (s_we each)"""
    mem_vhd = (src / "circuit" / "stage_MEM_behavior.vhd").read_text()
    sig, lanes = {}, {}
    for j in range(4):
        if "DATA_RAM_B0 :" in mem_vhd:
            base = MEM + "data_ram_b%d/" % j
            sig["we%d" % j] = base + "s_we"
            lanes[j] = (0, 8)
        else:
            base = MEM + "data_ram/"
            sig["we%d" % j] = base + "s_we%d" % j
            lanes[j] = (8 * j, 32)
        sig["addr%d" % j] = base + "s_ramaddress"
        sig["din%d" % j] = base + "s_datainreg"
    return sig, lanes

def _sync_tree(src, dst):
    """Copy src over dst, rewriting only files whose bytes changed, so GHDL's
    make step recompiles only what actually differs between programs."""
    changed = 0
    for f in src.rglob("*.vhd"):
        out = dst / f.relative_to(src)
        data = f.read_bytes()
        if not out.exists() or out.read_bytes() != data:
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_bytes(data)
            changed += 1
    return changed


def build(circ, words):
    """Export + compile; returns the GHDL work directory holding tb_main."""
    key = hashlib.sha256(Path(circ).read_bytes()).hexdigest()[:16]
    work = CACHE / key
    src = work / "src"
    src.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="vhdl_prog_") as td:
        exported = vhdl_export.export(circ, Path(td) / "vhdl", words)
        _sync_tree(exported, src)
    tb = src / TB.name
    if not tb.exists() or tb.read_bytes() != TB.read_bytes():
        shutil.copy2(TB, tb)
    files = sorted(str(f) for f in src.rglob("*.vhd"))
    lib = work / "lib"
    lib.mkdir(exist_ok=True)
    for step in (["-i", STD, "--workdir=" + str(lib), *files],
                 ["-m", STD, "--workdir=" + str(lib), "tb_main"]):
        p = subprocess.run(GHDL + step, cwd=lib, capture_output=True, text=True)
        if p.returncode:
            raise RuntimeError("ghdl %s failed:\n%s" % (step[0], (p.stdout + p.stderr)[-3000:]))
    return lib


def parse_vcd(path, wanted, lanes):
    """Stream a VCD.  Returns (final values, list of RAM writes)."""
    ids, scope, by_path = {}, [], {}
    for k, v in wanted.items():          # one signal may feed several names
        by_path.setdefault(v, []).append(k)
    vals, writes = {}, []
    with open(path) as f:
        for line in f:
            tok = line.split()
            if not tok:
                continue
            if tok[0] == "$scope":
                scope.append(tok[2].lower())
            elif tok[0] == "$upscope":
                scope.pop()
            elif tok[0] == "$var":
                # vectors are written as "name[31:0]"
                name = "/" + "/".join(scope + [tok[4].lower().split("[", 1)[0]])
                if name in by_path:
                    ids[tok[3]] = by_path[name]
            elif tok[0] == "$enddefinitions":
                break
        block = []

        def flush():
            # A rising gclk edge in this block: the RAM writes with the values
            # its strobes held just BEFORE the edge.
            # Only the address and the *enabled* lanes must be valid: a halfword
            # store can leave the unused half of the data bus undriven (X/U).
            rising = any(k == "gclk" and v == "1" for k, v in block) and vals.get("gclk") == "0"
            for lane, (lo, width) in (lanes.items() if rising else ()):
                addr = vals.get("addr%d" % lane)
                if vals.get("we%d" % lane) != "1" or not addr or not set(addr) <= set("01"):
                    continue
                din = vals.get("din%d" % lane, "").rjust(width, "0")  # VCD drops leading zeros
                byte = din[width - lo - 8:width - lo]
                writes.append((int(addr, 2), lane,
                               int(byte, 2) if set(byte) <= set("01") else None))
            for k, v in block:
                vals[k] = v
            block.clear()

        for line in f:
            if line[0] == "#":
                flush()
                continue
            c = line[0]
            if c in "01xXuUzZ-WLH":
                for k in ids.get(line[1:].strip(), ()):
                    block.append((k, c.lower()))
            elif c == "b":
                bits, ident = line[1:].split()
                for k in ids.get(ident, ()):
                    block.append((k, bits.lower()))
        flush()
    return vals, writes


def _num(bits):
    if bits is None or any(c not in "01" for c in bits):
        return None
    return int(bits, 2)


def run(circ, asm_body, max_cycles=3000, words=None):
    """Assemble `asm_body` (no header), run it, return (status, ram, regs)."""
    with tempfile.TemporaryDirectory(prefix="vhdl_run_") as td:
        td = Path(td)
        if words is None:
            words = ps.assemble(HEADER + asm_body, str(td))
        lib = build(circ, words)
        ram_sig, lanes = ram_signals(lib.parent / "src")
        wanted = {**SIGNALS, **ram_sig}
        opt = td / "wave.opt"
        opt.write_text("$ version 1.1\n" + "\n".join(sorted(set(wanted.values()))) + "\n")
        vcd = td / "run.vcd"
        p = subprocess.run(GHDL + ["-r", STD, "--workdir=" + str(lib), "tb_main",
                                   "-gMAX_CYCLES=%d" % max_cycles, "--ieee-asserts=disable",
                                   "--read-wave-opt=" + str(opt), "--vcd=" + str(vcd)],
                           cwd=lib, capture_output=True, text=True)
        out = p.stdout + p.stderr
        line = next((l for l in out.splitlines() if l.startswith("CYCLES")), None)
        if p.returncode or not line:
            raise RuntimeError("simulation failed:\n" + out[-3000:])
        halted = line.split()[3] == "1"
        vals, writes = parse_vcd(vcd, wanted, lanes)
    mem, bad = {}, set()             # bad: (word, lane) last written with X/U
    for a, lane, byte in writes:
        word = mem.get(a, 0)
        if byte is None:
            bad.add((a, lane))
            byte = 0
        else:
            bad.discard((a, lane))
        mem[a] = (word & ~(0xFF << (8 * lane))) | (byte << (8 * lane))
    ram = {}
    for a, w in sorted(mem.items()):
        if any((a, lane) in bad for lane in range(4)):
            ram[a] = "".join("XX" if (a, lane) in bad else "%02x" % ((w >> (8 * lane)) & 0xFF)
                             for lane in (3, 2, 1, 0))
        elif w:
            ram[a] = "%08x" % w
    regs = {k: _num(vals.get(k)) for k in SIGNALS if k.startswith("R") or k in ("cpsr", "pc")}
    regs["cycles"] = int(line.split()[1])
    return ("OK" if halted else "HANG"), ram, regs


def main():
    if len(sys.argv) not in (3, 4):
        raise SystemExit(__doc__)
    body = Path(sys.argv[2]).read_text()
    if body.lstrip().startswith(".syntax"):
        body = body.split("_start:", 1)[1]
    status, ram, regs = run(sys.argv[1], body, int(sys.argv[3]) if len(sys.argv) == 4 else 3000)
    print("status", status, "cycles", regs["cycles"])
    for a, v in ram.items():
        print("RAM[%02x] (0x%04x) = %s" % (a, 0x1000 + 4 * a, v))
    for k in ["R%d" % n for n in range(16)] + ["cpsr", "pc"]:
        v = regs[k]
        print("%-4s %s" % (k, "%08x" % v if v is not None else "X/U"))


if __name__ == "__main__":
    main()
