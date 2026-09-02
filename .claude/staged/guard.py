#!/usr/bin/env python3
"""Block every agent write to the files only Junaet edits.

Claude Code's `permissions.deny` list covers Edit/Write/NotebookEdit, but an
agent working through Bash never touches those tools -- it can reach the same
file with `sed -i`, a heredoc, a redirect, or a two-line Python script, and the
deny rule never sees it. This hook closes that path: it inspects the tool call
before it runs and refuses on exit code 2, which returns the message on stderr
to the model as feedback.

Two lists, because they need different treatment:

  PROTECTED   writes refused, reads allowed. Two groups: the two hand-wired
              masters, which are Junaet's alone, and the monitor's own files.
              Agents MUST be able to read the master -- it is the reference the
              whole reorganization is checked against. The debug circuits and
              CLAUDE.md are deliberately NOT protected; those are the agent's
              to edit.

  SECRETS     any mention refused, read or write. The audit HMAC key. Reading
              it is the whole attack -- with the key the ledger can be resealed
              around a deleted entry.

This is a guardrail, not a sandbox. It stops the realistic failure (an agent
"helpfully" fixing one wire in the master), not a determined attempt to evade
it. The audit ledger is the second layer: it records what actually changed,
whatever route the change took.

Because the guard protects itself, an agent cannot install a new version --
only Junaet can, by running ./install_protections.sh. Change the lists here and
the deny list in .claude/settings.json together, then run:

    python3 tests/test_protect_hook.py
"""
import json, os, re, sys

PROTECTED = (
    "armv4t.circ",
    "armv4t_2.circ",
    # CLAUDE.md and both debug circuits are deliberately absent. Junaet owns
    # the two masters; the docs and the working circuits are the agent's to
    # edit. Everything below is the monitor protecting itself -- an agent that
    # can rewrite the guard or the ledger is not being monitored at all.
    "protect_files.py",      # the guard
    "audit_log.py",          # the recorder
    "audit.py",              # the ledger implementation
    "ledger.jsonl",          # the record itself
    "settings.json",         # the deny list and the hook wiring
    "test_protect_hook.py",  # the test that proves the guard works
)

SECRETS = ("audit.key",)

REASON = {
    "armv4t.circ":          "the hand-wired master; read-only reference, nothing else",
    "armv4t_2.circ":        "the reorganization Junaet is hand-wiring",
    "protect_files.py":     "this guard -- an agent that can edit it has no guard",
    "audit_log.py":         "the change recorder",
    "audit.py":             "the audit ledger implementation",
    "ledger.jsonl":         "the tamper-evident record of every change",
    "settings.json":        "the permission deny list and hook wiring",
    "test_protect_hook.py": "the test that proves this guard still works",
    "audit.key":            "the key that seals the audit ledger",
}

# Two false positives shaped this. Both came from asking "does the command
# contain a write pattern anywhere?", which is the wrong question -- the right
# one is "is the protected name itself in a write position?".
#
#   * a bare `>` matched the `2>&1` in `... armv4t.circ 2>&1 | head`, so
#     reading the master through a pipe was refused;
#   * `open\([^)]*['\"][wax]` matched the OPENING quote of
#     `open('armv4t.circ')` followed by the `a` of armv4t, so every plain read
#     looked like a write. The mode is always a second argument -- anchor on
#     the comma.
#
# So each pattern below is built around the filename, not beside it. NAME is
# substituted with the escaped protected name.
WRITE_FORMS = (
    # redirection onto it:  > file   >> file
    r">>?\s*['\"]?NAME",
    # commands that write EVERY file they name. `mv` belongs here, not with the
    # destination-only group: moving the master away destroys it just as surely
    # as overwriting it.
    r"\b(?:sed\s+-i\S*|tee|mv|rm|truncate|dd|chmod|chown|chattr"
    r"|patch|shred|touch)\b[^|;&]*?NAME",
    # commands that write only their LAST argument. `cp armv4t.circ /tmp/ref`
    # reads the master and must stay allowed; `cp sandbox.circ armv4t.circ`
    # must not.
    r"\b(?:cp|install|ln|rsync)\b[^|;&]*?NAME['\"]?\s*(?:[|;&]|$)",
    # git commands that overwrite the working tree
    r"\bgit\b[^|;&]*?\b(?:checkout|restore|clean|reset)\b[^|;&]*?NAME",
    # python writing it
    r"open\s*\(\s*['\"]?[^)]*?NAME[^)]*?,\s*(?:mode\s*=\s*)?['\"][wax]",
    r"\b(?:shutil\.(?:copy\w*|move)|os\.(?:remove|unlink|rename|replace))"
    r"\s*\([^)]*?NAME",
    r"NAME['\"]?\s*\)\s*\.\s*write_(?:text|bytes)\b",
)


def _rx(name):
    # A plain substring test is wrong here: "debug_armv4t.circ" ends with
    # "armv4t.circ", so it would lock the agent out of the one circuit it is
    # supposed to edit. Require a real token boundary before the name.
    return re.compile(r"(?<![\w.-])" + re.escape(name))


def _write_rx(name):
    """The patterns that mean *this* name is being written."""
    esc = r"(?<![\w.-])" + re.escape(name)
    return [re.compile(f.replace("NAME", esc), re.S) for f in WRITE_FORMS]


PROTECTED_RE = [(n, _rx(n)) for n in PROTECTED]
PROTECTED_WRITE_RE = [(n, _write_rx(n)) for n in PROTECTED]
SECRET_RE = [(n, _rx(n)) for n in SECRETS]


def hit(text, table):
    for name, rx in table:
        if rx.search(text):
            return name
    return None


def write_hit(cmd):
    for name, rxs in PROTECTED_WRITE_RE:
        for rx in rxs:
            if rx.search(cmd):
                return name
    return None


def block(name, how):
    sys.stderr.write(
        "BLOCKED: %s is protected -- %s.\n"
        "Only Junaet changes it. %s\n"
        "Work in debug_armv4t.circ, or ask Junaet to make the change.\n"
        % (name, REASON.get(name, "owner-only"), how)
    )
    sys.exit(2)


def main():
    try:
        ev = json.load(sys.stdin)
    except Exception:
        sys.exit(0)                      # never break the session on a bad event

    tool = ev.get("tool_name", "")
    inp = ev.get("tool_input", {}) or {}

    if tool in ("Edit", "Write", "NotebookEdit", "MultiEdit"):
        path = inp.get("file_path") or inp.get("notebook_path") or ""
        base = os.path.basename(path)
        name = hit(base, SECRET_RE) or hit(base, PROTECTED_RE)
        if name:
            block(name, "This was a %s call." % tool)

    elif tool == "Read":
        base = os.path.basename(inp.get("file_path", "") or "")
        name = hit(base, SECRET_RE)
        if name:
            block(name, "Reading it is the whole attack.")

    elif tool == "Bash":
        cmd = inp.get("command", "") or ""
        name = hit(cmd, SECRET_RE)
        if name:
            block(name, "This command names it at all, which is enough.")
        name = write_hit(cmd)
        if name:
            block(name, "This command puts it in a write position. "
                        "Reading it (cat, grep, python open() for read, and "
                        "anything piped or redirected elsewhere) is fine.")

    sys.exit(0)


if __name__ == "__main__":
    main()
