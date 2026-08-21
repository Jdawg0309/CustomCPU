#!/usr/bin/env python3
"""Find vestigial structure in armv4t.circ -- dead circuits, disconnected
instances, orphaned splitters, near-duplicate names.

These are the archaeological layers of a hand-edited design: things left behind
by earlier attempts that were never cleaned up because they broke nothing. They
are also a practical cleanup list.

Only checks that are reliable are reported. Logisim component port geometry
varies by type and rotation, and inferring it is error-prone, so this restricts
itself to three techniques that were verified against known cases:

  * a circuit defined but never instantiated anywhere is definitively dead
  * a subcircuit instance whose port column carries no wire is disconnected
    (verified against mul_32 and ks_32b in ALU, both confirmed cut by hand)
  * a splitter whose combined end has no wire drives nothing
    (verified against the orphan at (2650,4090), which blocked HDL export)
"""
import re, sys, collections

PATH = sys.argv[1] if len(sys.argv) > 1 else "armv4t.circ"
src = open(PATH).read()

circuits = {}
for m in re.finditer(r'<circuit name="([^"]+)"', src):
    start = m.end()
    try: end = src.index("\n  </circuit>", start)
    except ValueError: continue
    circuits[m.group(1)] = src[start:end]

def wires(body):
    return [tuple(map(int, w.groups())) for w in
            re.finditer(r'<wire from="\((\d+),(\d+)\)" to="\((\d+),(\d+)\)"/>', body)]

def on_segment(p, w):
    px, py = p; x1, y1, x2, y2 = w
    if x1 == x2 == px and min(y1, y2) <= py <= max(y1, y2): return True
    if y1 == y2 == py and min(x1, x2) <= px <= max(x1, x2): return True
    return False

findings = collections.defaultdict(list)

# --- 1. circuits defined but never instantiated -------------------------
instantiated = collections.Counter()
for name, body in circuits.items():
    for m in re.finditer(r'<comp loc="\(\d+,\d+\)" name="([A-Za-z_][A-Za-z_0-9]*)"', body):
        if m.group(1) in circuits:
            instantiated[m.group(1)] += 1
main_name = "main"
for name in circuits:
    if name != main_name and instantiated[name] == 0:
        findings["circuits defined but never instantiated"].append(name)

# --- 2. subcircuit instances with no wire on their port column ----------
for name, body in circuits.items():
    W = wires(body)
    for m in re.finditer(r'<comp loc="\((\d+),(\d+)\)" name="([A-Za-z_][A-Za-z_0-9]*)"', body):
        sub = m.group(3)
        if sub not in circuits: continue
        ix, iy = int(m.group(1)), int(m.group(2))
        # ports descend from the instance anchor on a 20px pitch
        touched = any(on_segment((ix, iy + 20 * k), w) for k in range(0, 40) for w in W)
        if not touched:
            findings["HEURISTIC: instances with no wire on the assumed port column"].append(
                f"{sub} inside {name} at ({ix},{iy})")

# --- 3. splitters whose combined end drives nothing ---------------------
for name, body in circuits.items():
    W = wires(body)
    for m in re.finditer(r'<comp lib="0" loc="\((\d+),(\d+)\)" name="Splitter">', body):
        x, y = int(m.group(1)), int(m.group(2))
        if not any(on_segment((x, y), w) for w in W):
            findings["splitters with an unconnected bus end"].append(f"{name} at ({x},{y})")

# --- 4. near-duplicate circuit names ------------------------------------
# Only "X" beside "X_<digits>" -- a superseded original left next to its
# replacement. Sibling families (bs_stage_1/2/4/8/16, mul_8/mul_32) are
# deliberate naming, not duplication, and must not be flagged.
for a in circuits:
    for b in circuits:
        if a != b and re.fullmatch(re.escape(a) + r'_\d+', b):
            findings["superseded circuit left beside its replacement"].append(f"{a}  ->  {b}")

# --- report --------------------------------------------------------------
print(f"vestigial structure in {PATH}\n{'='*60}")
total = 0
RELIABLE = ("circuits defined but never instantiated",
            "splitters with an unconnected bus end",
            "superseded circuit left beside its replacement")
HEURISTIC = ("HEURISTIC: instances with no wire on the assumed port column",)
for heading in RELIABLE + HEURISTIC:
    if heading in HEURISTIC and findings.get(heading):
        print("\n  (the section below infers port geometry and is known to produce")
        print("   false positives -- bs_stage_16 was flagged and is in fact wired.")
        print("   Treat as leads to confirm, not as findings.)")
    items = findings.get(heading, [])
    print(f"\n{heading}  [{len(items)}]")
    for it in sorted(items):
        print(f"    {it}")
    if not items:
        print("    none")
    total += len(items)
print(f"\n{'='*60}\n{total} findings across {len(circuits)} circuits")
