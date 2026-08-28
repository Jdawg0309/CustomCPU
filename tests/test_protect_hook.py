#!/usr/bin/env python3
"""Regression test for .claude/hooks/protect_files.py.

The guard has to get two things right at once: refuse every write to the
owner-only files, and stay out of the way of everything else. The second half
is not decoration -- two real bugs were caught by the ALLOW cases alone:

  * filenames matched as substrings, so "debug_armv4t.circ" matched
    "armv4t.circ" and the guard locked agents out of the working circuit;
  * the open()-mode pattern matched the opening quote of `open('armv4t.circ')`
    followed by the `a` of armv4t, so every plain read looked like a write.

Both were silent. Keep the ALLOW half.

    python3 tests/test_protect_hook.py            # the installed guard
    python3 tests/test_protect_hook.py path/to/guard.py   # a candidate
"""
import json, os, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HOOK = (sys.argv[1] if len(sys.argv) > 1
        else os.path.join(ROOT, ".claude", "hooks", "protect_files.py"))

BLOCK = [
    ("Write master",     {"tool_name": "Write",
                          "tool_input": {"file_path": os.path.join(ROOT, "armv4t.circ")}}),
    ("Edit v2",          {"tool_name": "Edit", "tool_input": {"file_path": "armv4t_2.circ"}}),
    ("Edit guard",       {"tool_name": "Edit",
                          "tool_input": {"file_path": ".claude/hooks/protect_files.py"}}),
    ("Edit ledger",      {"tool_name": "Edit",
                          "tool_input": {"file_path": ".audit/ledger.jsonl"}}),
    ("Edit settings",    {"tool_name": "Edit",
                          "tool_input": {"file_path": ".claude/settings.json"}}),
    ("Read key",         {"tool_name": "Read",
                          "tool_input": {"file_path": "~/.config/customcpu/audit.key"}}),
    ("Bash cat key",     {"tool_name": "Bash",
                          "tool_input": {"command": "cat ~/.config/customcpu/audit.key"}}),
    ("Bash sed -i v2",   {"tool_name": "Bash",
                          "tool_input": {"command": "sed -i s/a/b/ armv4t_2.circ"}}),
    ("Bash redirect",    {"tool_name": "Bash",
                          "tool_input": {"command": "cat > armv4t.circ <<EOF\nx\nEOF"}}),
    ("Bash python w",    {"tool_name": "Bash",
                          "tool_input": {"command": "python3 -c \"open('armv4t.circ','w').write(s)\""}}),
    ("Bash python mode", {"tool_name": "Bash",
                          "tool_input": {"command": "python3 -c \"open('armv4t.circ', mode='a')\""}}),
    ("Bash cp over",     {"tool_name": "Bash",
                          "tool_input": {"command": "cp sandbox.circ armv4t.circ"}}),
    ("Bash git restore", {"tool_name": "Bash",
                          "tool_input": {"command": "git checkout -- armv4t_2.circ"}}),
    ("Bash rm",          {"tool_name": "Bash",
                          "tool_input": {"command": "rm -f armv4t.circ"}}),
    ("Bash rm ledger",   {"tool_name": "Bash",
                          "tool_input": {"command": "rm -f .audit/ledger.jsonl"}}),
]

ALLOW = [
    ("Bash cat master",   {"tool_name": "Bash",
                           "tool_input": {"command": "cat armv4t.circ | head -40"}}),
    ("Bash grep master",  {"tool_name": "Bash",
                           "tool_input": {"command": "grep -n 'circuit name' armv4t.circ"}}),
    ("Bash python read",  {"tool_name": "Bash",
                           "tool_input": {"command": "python3 -c \"s=open('armv4t.circ').read()\""}}),
    ("Bash read v2",      {"tool_name": "Bash",
                           "tool_input": {"command": "python3 -c \"s=open('armv4t_2.circ').read()\""}}),
    ("Bash logisim show", {"tool_name": "Bash",
                           "tool_input": {"command": "python3 -m logisim show armv4t.circ ALU"}}),
    ("Read master",       {"tool_name": "Read", "tool_input": {"file_path": "armv4t.circ"}}),
    ("Bash audit verify", {"tool_name": "Bash",
                           "tool_input": {"command": "python3 tools/audit.py verify"}}),
    # The scope is the two masters, not "everything Junaet cares about". These
    # three must stay writable or the agent cannot do its job at all.
    ("Edit brief",        {"tool_name": "Edit", "tool_input": {"file_path": "CLAUDE.md"}}),
    ("Write debug copy",  {"tool_name": "Write", "tool_input": {"file_path": "debug_armv4t.circ"}}),
    ("Write debug2",      {"tool_name": "Write", "tool_input": {"file_path": "sandbox.circ"}}),
    ("Bash sed -i debug", {"tool_name": "Bash",
                           "tool_input": {"command": "sed -i s/a/b/ debug_armv4t.circ"}}),
    ("Bash write debug",  {"tool_name": "Bash",
                           "tool_input": {"command": "python3 -c \"open('debug_armv4t.circ','w').write(s)\""}}),
    ("Bash unrelated",    {"tool_name": "Bash",
                           "tool_input": {"command": "python3 tests/push_suite.py"}}),
    # A bare `>` in the write pattern matched the `2>&1` here and refused a
    # plain read. The name has to be in a write POSITION, not merely present
    # somewhere on a line that also contains a redirect.
    ("Bash stderr pipe",  {"tool_name": "Bash",
                           "tool_input": {"command": "python3 tests/check_stage.py armv4t_2.circ stage_IF 2>&1 | head -40"}}),
    ("Bash out elsewhere",{"tool_name": "Bash",
                           "tool_input": {"command": "grep circuit armv4t.circ > /tmp/out.txt"}}),
    ("Bash cp FROM it",   {"tool_name": "Bash",
                           "tool_input": {"command": "cp armv4t.circ /tmp/reference.circ"}}),
    ("Bash diff",         {"tool_name": "Bash",
                           "tool_input": {"command": "diff armv4t.circ debug_armv4t.circ | head"}}),
]


def rc(event):
    p = subprocess.run([sys.executable, HOOK], input=json.dumps(event),
                       capture_output=True, text=True)
    return p.returncode


def main():
    print("guard: %s\n" % HOOK)
    fails = 0
    for want, cases in ((2, BLOCK), (0, ALLOW)):
        for label, ev in cases:
            got = rc(ev)
            ok = got == want
            fails += not ok
            print("[%s] %-6s %-18s rc=%d" %
                  ("ok" if ok else "FAIL", "BLOCK" if want else "ALLOW", label, got))
        print()
    total = len(BLOCK) + len(ALLOW)
    print("%d/%d correct" % (total - fails, total))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
