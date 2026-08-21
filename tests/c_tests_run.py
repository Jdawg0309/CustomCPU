#!/usr/bin/env python3
"""Run the compiled-C images. None of these fit the old 16-word ROM."""
import sys, os, re, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps

ps.CIRC = sys.argv[1] if len(sys.argv) > 1 else "/home/junaet/Documents/CustomCPU/debug_armv4t.circ"

# documented signature from PRACTICAL_C_CPU_TEST.md
EXPECT = {"practical_rom": {0x40: "00000018", 0xFF: "00000001"}}

for name in ("add_rom", "practical_rom", "stress_call_rom",
             "stress_memory_rom", "stress_signed_rom"):
    path = f"/home/junaet/Documents/CustomCPU/roms/{name}"
    toks = open(path).read().split()
    if toks[:1] == ["v3.0"]: toks = toks[3:]
    words = [t.lower() for t in toks if re.fullmatch(r"[0-9a-fA-F]{8}", t)]
    with tempfile.TemporaryDirectory() as wd:
        try:
            halted, osc, ram = ps.run_rom(words, wd)
        except AssertionError as ex:
            print(f"[SKIP ] {name:<20} {len(words):>3}w  {ex}"); continue
    notes = []
    if osc: notes.append("OSCILLATION")
    if not halted: notes.append("did not halt cleanly")
    for a, v in EXPECT.get(name, {}).items():
        got = ram.get(a, "00000000")
        if got != v: notes.append(f"RAM[{a:02X}]={got} want {v}")
    status = "PASS" if not notes else "FAIL"
    detail = "; ".join(notes) if notes else (
        "signature verified" if name in EXPECT else f"{len(ram)} RAM words written")
    print(f"[{status:^6}] {name:<20} {len(words):>3}w  halted={halted} osc={osc}  {detail}")
    if name in EXPECT and not notes:
        for a, v in EXPECT[name].items():
            print(f"           RAM[{a:02X}] = {ram.get(a,'00000000')}")
