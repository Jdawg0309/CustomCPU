#!/usr/bin/env python3
"""Turn the git history of armv4t.circ into a readable engineering record.

A .circ file diffs as unreadable XML, so the commit history -- which is the
strongest evidence of how this design was actually built -- is invisible to
anyone reviewing it. This walks every revision and reports what changed in
structural terms: which circuits gained or lost components, which subcircuits
appeared, how the design grew.

    python3 tools/provenance.py                 # timeline to stdout
    python3 tools/provenance.py --csv out.csv   # metrics per revision
    python3 tools/provenance.py --diff A B      # two revisions, semantic diff
"""
import re, sys, subprocess, collections

FILE = "armv4t.circ"

def rev_content(rev):
    r = subprocess.run(["git", "show", f"{rev}:{FILE}"],
                       capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None

def parse(src):
    """-> {circuit_name: {'comps': Counter, 'wires': int, 'total': int}}"""
    out = {}
    for m in re.finditer(r'<circuit name="([^"]+)"', src):
        name = m.group(1)
        start = m.end()
        try:
            end = src.index("\n  </circuit>", start)
        except ValueError:
            continue
        body = src[start:end]
        comps = collections.Counter()
        for c in re.finditer(r'<comp(?: lib="\d+")? loc="\(\d+,\d+\)" name="([^"]+)"', body):
            comps[c.group(1)] += 1
        out[name] = {
            "comps": comps,
            "wires": len(re.findall(r'<wire ', body)),
            "total": sum(comps.values()),
        }
    return out

def history():
    r = subprocess.run(
        ["git", "log", "--follow", "--reverse", "--format=%H\t%ad\t%s",
         "--date=short", "--", FILE],
        capture_output=True, text=True)
    rows = []
    for line in r.stdout.strip().splitlines():
        h, d, s = line.split("\t", 2)
        rows.append((h, d, s))
    return rows

def describe_delta(prev, cur):
    """Human-readable summary of what changed between two parsed revisions."""
    notes = []
    added = sorted(set(cur) - set(prev))
    removed = sorted(set(prev) - set(cur))
    for n in added:   notes.append(f"+circuit {n}")
    for n in removed: notes.append(f"-circuit {n}")
    for name in sorted(set(cur) & set(prev)):
        dc = cur[name]["total"] - prev[name]["total"]
        dw = cur[name]["wires"] - prev[name]["wires"]
        if dc or dw:
            bits = []
            if dc: bits.append(f"{dc:+d} comps")
            if dw: bits.append(f"{dw:+d} wires")
            notes.append(f"{name} ({', '.join(bits)})")
    return notes

def main():
    args = sys.argv[1:]

    if "--diff" in args:
        i = args.index("--diff")
        a, b = args[i + 1], args[i + 2]
        pa, pb = parse(rev_content(a)), parse(rev_content(b))
        print(f"=== {a} -> {b} ===")
        for n in describe_delta(pa, pb):
            print("   ", n)
        print("\n--- component-level, per circuit ---")
        for name in sorted(set(pa) & set(pb)):
            ca, cb = pa[name]["comps"], pb[name]["comps"]
            for kind in sorted(set(ca) | set(cb)):
                d = cb[kind] - ca[kind]
                if d: print(f"    {name:<28} {kind:<22} {d:+d}")
        return

    rows = history()
    csv_path = None
    if "--csv" in args:
        csv_path = args[args.index("--csv") + 1]

    prev = None
    recs = []
    print(f"{'date':<11} {'commit':<9} {'circ':>5} {'comps':>6} {'wires':>6}  what changed")
    print("-" * 108)
    for h, d, subj in rows:
        src = rev_content(h)
        if src is None:
            continue
        cur = parse(src)
        ncirc = len(cur)
        ncomp = sum(v["total"] for v in cur.values())
        nwire = sum(v["wires"] for v in cur.values())
        if prev is None:
            what = "initial import"
        else:
            notes = describe_delta(prev, cur)
            what = "; ".join(notes[:3]) + (f" … +{len(notes)-3} more" if len(notes) > 3 else "")
            what = what or "no structural change"
        print(f"{d:<11} {h[:8]:<9} {ncirc:>5} {ncomp:>6} {nwire:>6}  {what[:70]}")
        recs.append((d, h[:8], ncirc, ncomp, nwire, subj))
        prev = cur

    print("-" * 108)
    if recs:
        first, last = recs[0], recs[-1]
        print(f"{len(recs)} revisions of {FILE} from {first[0]} to {last[0]}")
        print(f"grew from {first[3]} to {last[3]} components "
              f"({last[3]-first[3]:+d}), {first[4]} to {last[4]} wires "
              f"({last[4]-first[4]:+d}), {first[2]} to {last[2]} subcircuits")

    if csv_path:
        with open(csv_path, "w") as f:
            f.write("date,commit,subcircuits,components,wires,subject\n")
            for d, h, c, co, w, s in recs:
                f.write(f'{d},{h},{c},{co},{w},"{s.replace(chr(34), "")}"\n')
        print(f"\nwrote {csv_path}")

if __name__ == "__main__":
    main()
