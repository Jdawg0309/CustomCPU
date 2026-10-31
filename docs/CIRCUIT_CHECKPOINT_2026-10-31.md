# Saved circuit checkpoint — 2026-10-31

Published at the user's request before a read-only redundancy audit.

Master SHA-256:
`59bd2ea775fa52e50fd0379e528e4de5dac893f4b97556eba7848d9ebca108ba`.

D3 was already committed in `23c6097`. This newer saved circuit changes
`stage_EX` flag classification, adds an `is_hwxfer` input connected from
`IS_HWXFER` in `main`, and relocates the immediate-shift repair group.
The flag logic changes reuse existing gates and input inversions rather than
the earlier eight-part candidate implementation.

This is a source checkpoint, not a new regression-pass claim. Codex reviewed
the diff but did not rerun Logisim before publication. The master was not
edited by Codex. D1/D2 completion must be established from the current wiring
and behavioral tests, not inferred from this commit message.
