#!/usr/bin/env python3
"""Export a CPU .circ to VHDL with Logisim-evolution's own HDL generator.

Nothing here translates gates.  Logisim writes every line of the VHDL; this
script only prepares a temp copy for its exporter and collects the output:

  1. copy the circuit (the original is never opened for writing),
  2. load a program image into every 32-bit ROM, the same way tests/push_suite
     does for the jar, so Logisim bakes the program into the HDL,
  3. add a board map that marks `main`'s rst pin as constant 0 and halt as
     open -- Logisim refuses to export a top level whose pins are unmapped,
  4. run `logisim-evolution -f <circ> main BASYS3 HDLONLY` (no synthesis).

The board name only satisfies the exporter; the testbench instantiates `main`
directly and never uses Logisim's FPGA top-level shell.

    python3 tools/vhdl_export.py arm_custom_subset.circ build/vhdl/out [prog.hex]
"""
import os
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
_JAR_CANDIDATES = (
    os.environ.get("LOGISIM_JAR"),
    "/home/junaet/Applications/logisim-evolution/logisim-evolution-5.0.0-all.jar",
    "/snap/logisim-evolution/current/logisim-evolution/logisim-evolution.jar",
)
JAR = next((p for p in _JAR_CANDIDATES if p and os.path.isfile(p)), _JAR_CANDIDATES[-1])
BOARD = "BASYS3"


def load_rom_image(text, words):
    """Write `words` (hex strings) into every 32-bit-data ROM in the file."""
    roms, pos = [], 0
    while True:
        m = re.search(r'<comp lib="2"[^>]*name="ROM">.*?</comp>', text[pos:], re.S)
        if not m:
            break
        attrs = {a.get("name"): a.get("val") for a in ET.fromstring(m.group(0)).findall("a")}
        if attrs.get("dataWidth") == "32":
            roms.append(m.group(0))
        pos += m.end()
    if not roms:
        raise SystemExit("no 32-bit-data ROM found anywhere in the file")
    for rom in roms:
        aw = int(re.search(r'addrWidth" val="(\d+)"', rom).group(1))
        if len(words) > (1 << aw):
            raise SystemExit("program is %d words; ROM holds %d" % (len(words), 1 << aw))
        new = re.sub(r'<a name="contents">.*?</a>',
                     '<a name="contents">addr/data: %d 32\n%s\n</a>' % (aw, " ".join(words)),
                     rom, flags=re.S)
        text = text.replace(rom, new, 1)
    return text


def add_board_map(text):
    """rst tied to 0, halt left open: the only two pins on `main`."""
    a = text.index('<circuit name="main">')
    b = text.index("\n  </circuit>", a)
    if "<boardmap" in text[a:b]:
        raise SystemExit("main already carries a board map; refusing to guess")
    bm = ('\n    <boardmap boardname="%s">\n'
          '      <mc key="/rst" vconst="0"/>\n'
          '      <mc key="/halt" open="open"/>\n'
          '    </boardmap>' % BOARD)
    return text[:b] + bm + text[b:]


def export(circ, out_dir, words=()):
    """Export `circ` (with `words` in ROM) and copy the VHDL tree to out_dir."""
    circ, out_dir = Path(circ).resolve(), Path(out_dir).resolve()
    with tempfile.TemporaryDirectory(prefix="vhdl_export_") as wd:
        wd = Path(wd)
        text = circ.read_text()
        if words:
            text = load_rom_image(text, list(words))
        tmp = wd / "cpu.circ"
        tmp.write_text(add_board_map(text))
        home = wd / "home"            # keeps Logisim's prefs and workspace contained
        home.mkdir()
        cmd = ["xvfb-run", "-a", "java", "-Duser.home=%s" % home, "-jar", JAR,
               "-f", str(tmp), "main", BOARD, "HDLONLY"]
        p = subprocess.run(["timeout", "--kill-after=5s", "600", *cmd],
                           capture_output=True, text=True)
        log = p.stdout + p.stderr
        vhdl = home / "logisim_evolution_workspace" / "cpu" / "main" / "vhdl"
        if p.returncode or not vhdl.is_dir():
            errors = [l for l in log.splitlines() if "ERROR" in l]
            raise SystemExit("Logisim export failed (exit %d):\n%s"
                             % (p.returncode, "\n".join(errors[-10:]) or log[-2000:]))
        if out_dir.exists():
            shutil.rmtree(out_dir)
        shutil.copytree(vhdl, out_dir)
        (out_dir / "export.log").write_text(log)
    return out_dir


def main():
    if len(sys.argv) not in (3, 4):
        raise SystemExit(__doc__)
    words = Path(sys.argv[3]).read_text().split() if len(sys.argv) == 4 else ()
    out = export(sys.argv[1], sys.argv[2], words)
    print("%d VHDL files in %s" % (len(list(out.rglob("*.vhd"))), out))


if __name__ == "__main__":
    main()
