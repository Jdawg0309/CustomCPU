#!/usr/bin/env python3
"""PostToolUse: record any watched file whose bytes changed.

Runs after every tool call and hands off to tools/audit.py, which does the
hashing and the sealing. Nothing here inspects the command or guesses intent --
the ledger records what actually changed, so it catches Edit, Write, a heredoc,
`sed -i`, a Python one-liner, and a `git checkout` identically.

Never blocks. An audit failure must not stop work; it exits 0 no matter what.
"""
import json, os, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
AUDIT = os.path.join(ROOT, "tools", "audit.py")


def main():
    try:
        ev = json.load(sys.stdin)
    except Exception:
        return 0
    if not os.path.exists(AUDIT):
        return 0
    cmd = [sys.executable, AUDIT, "record", "--actor", "agent",
           "--tool", str(ev.get("tool_name") or "?")]
    sid = ev.get("session_id")
    if sid:
        cmd += ["--session", str(sid)[:12]]
    try:
        subprocess.run(cmd, capture_output=True, timeout=20)
    except Exception:
        pass
    return 0


if __name__ == "__main__":
    sys.exit(main())
