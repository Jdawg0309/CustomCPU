#!/usr/bin/env python3
"""Tamper-evident ledger of every change to Junaet's files.

The design question is what to trust. An agent that can run shell commands can
also rewrite a plain log, so a plain log proves nothing. Two things make this
one worth reading:

  1. It is content-addressed, not intent-addressed. Nothing here parses a
     command to guess what it meant to do. After every tool call the watched
     files are hashed and compared to the last recorded state. A change is
     recorded because the bytes changed -- it does not matter whether it came
     from Edit, a heredoc, `sed -i`, a Python script, or Logisim itself.

  2. It is a hash chain sealed with a key kept outside the repository. Every
     entry commits to the one before it, so a single edited line breaks every
     MAC after it. Re-sealing the chain requires the key, which lives in
     ~/.config/customcpu/audit.key with mode 600 and is blocked from agent
     reads by the PreToolUse hook.

That is tamper-EVIDENT, not tamper-proof. Anything running as your user could
read the key if it worked at it. The guarantee is narrower and still useful:
nothing can quietly alter the record, and `verify` will say so.

    python3 tools/audit.py init      # one time; creates the key
    python3 tools/audit.py verify    # chain intact? files match last entry?
    python3 tools/audit.py log       # recent history, newest last
    python3 tools/audit.py accept    # you made a change; record it as approved
    python3 tools/audit.py record --tool Edit --session abc   # called by hooks
"""
import argparse, hashlib, hmac, json, os, subprocess, sys, time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LEDGER = os.path.join(ROOT, ".audit", "ledger.jsonl")
KEY_PATH = os.path.expanduser("~/.config/customcpu/audit.key")

# Files whose every byte change is worth a ledger entry. The three owner-only
# files, plus the working circuit -- you want the working file's history too,
# you just don't want it locked.
WATCHED = [
    "armv4t.circ",
    "armv4t_2.circ",
    "CLAUDE.md",
    "debug_armv4t.circ",
    ".claude/hooks/protect_files.py",
    ".claude/settings.json",
]

def _owner_only():
    """The owner-only set, taken from the guard rather than restated here.

    These two lists drifted once already: CLAUDE.md was narrowed out of the
    guard's scope but stayed in this one, so an ordinary docs edit was reported
    as an unapproved change to an owner-only file. A false alarm is how an
    audit trail stops being read, so there is now a single source of truth and
    this falls back only if the guard cannot be imported.
    """
    try:
        import importlib.util
        spec = importlib.util.spec_from_file_location(
            "_guard", os.path.join(ROOT, ".claude", "hooks", "protect_files.py"))
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        # The guard also protects its own machinery; only the circuits are
        # "owner-only" in the sense the ledger means -- work Junaet did by hand.
        return {n for n in mod.PROTECTED if n.endswith(".circ")}
    except Exception:
        return {"armv4t.circ", "armv4t_2.circ"}


OWNER_ONLY = _owner_only()


# ---------------------------------------------------------------- key + chain

def load_key(create=False):
    if os.path.exists(KEY_PATH):
        with open(KEY_PATH, "rb") as f:
            return f.read()
    if not create:
        return None
    os.makedirs(os.path.dirname(KEY_PATH), exist_ok=True)
    key = os.urandom(32)
    # Written 600 before any bytes land in it, not after.
    fd = os.open(KEY_PATH, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, "wb") as f:
        f.write(key)
    return key


def seal(key, prev_mac, body):
    """MAC over the previous link and this entry's canonical body."""
    msg = prev_mac.encode() + json.dumps(body, sort_keys=True,
                                         separators=(",", ":")).encode()
    return hmac.new(key, msg, hashlib.sha256).hexdigest()


def read_ledger():
    if not os.path.exists(LEDGER):
        return []
    out = []
    with open(LEDGER) as f:
        for line in f:
            line = line.strip()
            if line:
                out.append(json.loads(line))
    return out


def append(key, body):
    entries = read_ledger()
    prev = entries[-1]["mac"] if entries else "genesis"
    body = dict(body)
    body["seq"] = len(entries)
    body["ts"] = time.strftime("%Y-%m-%dT%H:%M:%S%z")
    entry = dict(body, prev=prev, mac=seal(key, prev, body))
    os.makedirs(os.path.dirname(LEDGER), exist_ok=True)
    with open(LEDGER, "a") as f:
        f.write(json.dumps(entry, sort_keys=True) + "\n")
    return entry


# ------------------------------------------------------------------- hashing

def sha(path):
    full = os.path.join(ROOT, path)
    if not os.path.exists(full):
        return None
    h = hashlib.sha256()
    with open(full, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def snapshot():
    return {p: sha(p) for p in WATCHED}


def last_state(entries):
    """Newest recorded hash for each watched file, walking backwards."""
    state = {}
    for e in reversed(entries):
        for p, v in (e.get("state") or {}).items():
            state.setdefault(p, v)
    return state


def git_head():
    try:
        return subprocess.run(["git", "-C", ROOT, "rev-parse", "--short", "HEAD"],
                              capture_output=True, text=True,
                              timeout=5).stdout.strip() or None
    except Exception:
        return None


# ------------------------------------------------------------------ commands

def cmd_init(args):
    if os.path.exists(KEY_PATH) and not args.force:
        print("key already exists at %s (use --force to replace, which "
              "invalidates the existing chain)" % KEY_PATH)
        return 1
    if args.force and os.path.exists(LEDGER):
        os.rename(LEDGER, LEDGER + ".superseded." + time.strftime("%Y%m%d-%H%M%S"))
    key = load_key(create=True)
    append(key, {"event": "init", "actor": "owner", "state": snapshot(),
                 "git": git_head()})
    print("key:    %s (mode 600)" % KEY_PATH)
    print("ledger: %s" % LEDGER)
    print("watching %d files" % len(WATCHED))
    return 0


def cmd_record(args):
    """Record a change if -- and only if -- watched bytes actually changed."""
    key = load_key()
    if key is None:
        return 0                       # not initialised; never block a tool call
    entries = read_ledger()
    prev, now = last_state(entries), snapshot()
    changed = {p: now[p] for p in WATCHED if prev.get(p) != now[p]}
    if not changed:
        return 0
    append(key, {"event": "change", "actor": args.actor, "tool": args.tool,
                 "session": args.session, "changed": sorted(changed),
                 "owner_only": sorted(set(changed) & OWNER_ONLY),
                 "state": now, "git": git_head()})
    return 0


def cmd_accept(args):
    key = load_key()
    if key is None:
        print("not initialised -- run: python3 tools/audit.py init")
        return 1
    e = append(key, {"event": "accept", "actor": "owner", "note": args.note,
                     "state": snapshot(), "git": git_head()})
    print("recorded as approved (seq %d)" % e["seq"])
    return 0


def cmd_verify(args):
    key = load_key()
    if key is None:
        print("FAIL  no key at %s -- run: python3 tools/audit.py init" % KEY_PATH)
        return 1
    entries = read_ledger()
    if not entries:
        print("FAIL  empty ledger")
        return 1

    bad = []
    prev = "genesis"
    for e in entries:
        body = {k: v for k, v in e.items() if k not in ("mac", "prev")}
        if e.get("prev") != prev or seal(key, prev, body) != e.get("mac"):
            bad.append(e.get("seq"))
        prev = e.get("mac", "")

    if bad:
        print("FAIL  chain broken at %s -- entries were altered or removed"
              % ", ".join("seq %s" % s for s in bad[:5]))
    else:
        print("ok    chain intact, %d entries" % len(entries))

    drift = {p: (last_state(entries).get(p), snapshot()[p])
             for p in WATCHED if last_state(entries).get(p) != snapshot()[p]}
    if drift:
        print("WARN  %d file(s) changed since the last ledger entry:" % len(drift))
        for p, (was, now) in sorted(drift.items()):
            mark = "  <-- OWNER-ONLY" if p in OWNER_ONLY else ""
            print("        %-34s %s -> %s%s" %
                  (p, (was or "absent")[:12], (now or "absent")[:12], mark))
        print("      If that was you, run: python3 tools/audit.py accept")

    unapproved = []
    for e in reversed(entries):
        if e.get("event") == "accept":
            break
        if e.get("event") == "change" and e.get("owner_only"):
            unapproved.append(e)
    if unapproved:
        print("WARN  %d unapproved change(s) to owner-only files:" % len(unapproved))
        for e in reversed(unapproved):
            print("        seq %-4s %s  %s  by %s/%s" %
                  (e["seq"], e["ts"], ",".join(e["owner_only"]),
                   e.get("actor"), e.get("tool")))

    return 1 if (bad or drift or unapproved) else 0


def cmd_log(args):
    entries = read_ledger()[-args.n:]
    for e in entries:
        who = e.get("actor") or "?"
        tool = e.get("tool")
        what = ",".join(e.get("changed", [])) or e.get("note") or ""
        print("%-4s %s  %-8s %-8s %-6s %s" %
              (e.get("seq"), e.get("ts"), e.get("event"), who,
               tool or "-", what))
    if not entries:
        print("(empty)")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("init"); p.set_defaults(fn=cmd_init)
    p.add_argument("--force", action="store_true")

    p = sub.add_parser("record"); p.set_defaults(fn=cmd_record)
    p.add_argument("--tool", default=None)
    p.add_argument("--session", default=None)
    p.add_argument("--actor", default="agent")

    p = sub.add_parser("accept"); p.set_defaults(fn=cmd_accept)
    p.add_argument("--note", default=None)

    p = sub.add_parser("verify"); p.set_defaults(fn=cmd_verify)

    p = sub.add_parser("log"); p.set_defaults(fn=cmd_log)
    p.add_argument("-n", type=int, default=20)

    args = ap.parse_args()
    return args.fn(args)


if __name__ == "__main__":
    sys.exit(main())
