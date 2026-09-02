#!/usr/bin/env bash
# Install or update the file protections. Run this yourself -- that is the
# point. The guard protects its own source, so no agent can put a new version
# in place; every change to how you are protected passes through your hand.
#
#   ./install_protections.sh
#
# Idempotent. Tests the candidate BEFORE installing it, and refuses to install
# a guard that fails its own test suite.
set -euo pipefail
cd "$(dirname "$0")"

S=.claude/staged
GUARD=.claude/hooks/protect_files.py
TEST=tests/test_protect_hook.py
SETTINGS=.claude/settings.json

for f in "$S/guard.py" "$S/guard_test.py" "$S/settings_new.txt"; do
  [ -f "$f" ] || { echo "missing staged file: $f"; exit 1; }
done

echo "== testing the candidate guard before installing it =="
if ! python3 "$S/guard_test.py" "$S/guard.py"; then
  echo
  echo "REFUSED: the candidate guard fails its own tests. Nothing installed."
  exit 1
fi

echo
echo "== installing =="
mkdir -p .claude/hooks tests tools .audit
install -m 755 "$S/guard.py"      "$GUARD"
install -m 755 "$S/guard_test.py" "$TEST"
install -m 644 "$S/settings_new.txt" "$SETTINGS"
# audit.py protects itself like the guard does, so it is installed here too
# rather than edited in place.
[ -f "$S/audit_new.py" ] && install -m 755 "$S/audit_new.py" tools/audit.py
[ -f .claude/hooks/audit_log.py ] && chmod 755 .claude/hooks/audit_log.py
echo "  $GUARD"
echo "  $TEST"
echo "  $SETTINGS"

echo
echo "== verifying the installed guard =="
python3 "$TEST" >/dev/null && echo "  guard tests pass"

echo
echo "== audit ledger =="
if [ -f "$HOME/.config/customcpu/audit.key" ]; then
  echo "  key already present; leaving the existing chain intact"
else
  python3 tools/audit.py init
fi
python3 tools/audit.py verify || true

echo
echo "Done. Day to day:"
echo "  python3 tools/audit.py verify   # did anything touch the masters?"
echo "  python3 tools/audit.py log      # recent history"
echo "  python3 tools/audit.py accept   # that change was me"
