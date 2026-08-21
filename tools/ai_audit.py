#!/usr/bin/env python3
"""Exhaustive audit of AI file-writing activity across every Claude Code
transcript on this machine, restricted to CustomCPU paths.

Reports every Write/Edit/MultiEdit call: which file, how many times, when
first and last, and whether the file was created outright or only modified.
"""
import json, glob, os, re, collections

TRANSCRIPTS = sorted(glob.glob(os.path.expanduser("~/.claude/projects/*/*.jsonl")))
CUSTOMCPU = re.compile(r'CustomCPU', re.I)

rec_by_file = collections.defaultdict(lambda: {
    "Write": 0, "Edit": 0, "MultiEdit": 0,
    "first": None, "last": None, "sessions": set(), "projects": set()})

scanned = 0
for path in TRANSCRIPTS:
    proj = os.path.basename(os.path.dirname(path))
    sess = os.path.basename(path)[:8]
    scanned += 1
    for line in open(path, errors="ignore"):
        if "file_path" not in line:
            continue
        try:
            rec = json.loads(line)
        except Exception:
            continue
        ts = (rec.get("timestamp") or "")[:19]
        for c in (rec.get("message", {}).get("content") or []):
            if not isinstance(c, dict) or c.get("type") != "tool_use":
                continue
            name = c.get("name")
            if name not in ("Write", "Edit", "MultiEdit"):
                continue
            fp = (c.get("input") or {}).get("file_path", "")
            if not fp or not CUSTOMCPU.search(fp):
                continue
            if "/scratchpad/" in fp or "/tmp/" in fp or "/.claude/" in fp:
                continue                      # scratch files, never part of the repo
            e = rec_by_file[fp]
            e[name] += 1
            e["sessions"].add(sess)
            e["projects"].add(proj)
            if e["first"] is None or ts < e["first"]: e["first"] = ts
            if e["last"] is None or ts > e["last"]:  e["last"] = ts

def bucket(p):
    b = os.path.basename(p)
    if b.endswith(".circ"):                     return "CIRCUIT"
    if "/tools/" in p or "/c_tests/" in p:      return "tooling"
    if b.endswith((".md", ".txt")):             return "docs"
    if b.endswith((".py", ".sh", ".tcl")):      return "tooling"
    if b.endswith((".S", ".rom", ".ld", ".c")): return "test/ROM"
    return "other"

rows = []
for fp, e in rec_by_file.items():
    total = e["Write"] + e["Edit"] + e["MultiEdit"]
    rows.append((bucket(fp), os.path.relpath(fp, "/home/junaet/Documents/CustomCPU"),
                 e["Write"], e["Edit"] + e["MultiEdit"], total,
                 e["first"][:10] if e["first"] else "", e["last"][:10] if e["last"] else "",
                 len(e["sessions"])))

order = {"CIRCUIT": 0, "tooling": 1, "test/ROM": 2, "docs": 3, "other": 4}
rows.sort(key=lambda r: (order[r[0]], -r[4]))

print(f"scanned {scanned} transcripts\n")
print(f"| {'kind':<9} | {'file':<44} | {'new':>3} | {'edit':>4} | {'first':<10} | {'last':<10} |")
print(f"|{'-'*11}|{'-'*46}|{'-'*5}|{'-'*6}|{'-'*12}|{'-'*12}|")
for k, f, w, ed, t, fst, lst in [(r[0], r[1], r[2], r[3], r[4], r[5], r[6]) for r in rows]:
    print(f"| {k:<9} | {f[:44]:<44} | {w:>3} | {ed:>4} | {fst:<10} | {lst:<10} |")

tot = collections.Counter()
for r in rows: tot[r[0]] += r[4]
print(f"\n{len(rows)} distinct repo files ever written by AI")
for k in sorted(tot, key=lambda x: order[x]):
    print(f"   {k:<9} {tot[k]:>4} tool calls across {sum(1 for r in rows if r[0]==k)} files")
