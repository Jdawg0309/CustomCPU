# D3: pending PC redirect never clears

## Master repaired — 2026-10-31

The user has now hand-wired D3 into `arm_custom_subset.circ` and reports
verification with Claude. Codex inspected the saved file: relative to the
October 25 audited master, the only circuit change is removal of the wire
`(1380,830)`–`(1380,850)` and addition of a one-bit Constant 1 at
`(1380,850)`, driving `pc_pending.en`. No master edits were made by Codex.

Repaired master SHA-256:
`78675fd7480da033494a6c6d3ca098f3c31592eb78c814499edb439068814b52`.

The user's latest verification report did not supply a new master test count;
the 8/8 and 12/12 counts below refer to the earlier candidate comparison.
Codex did not rerun simulation for this publication.

**Remaining pre-multiply CPU fixes: D1 flag preservation and D2 unaligned
word-load rotation.** Unmasked regression remains necessary after those
repairs. Multiplier faults and integration remain separate work.

This circuit checkpoint also publishes the previously local extra-transfer
control repair (repair 3), which passed the October 25 direct Logisim
register-offset checks (15/15) and byte/halfword lane checks (19/19).

## Earlier candidate handoff

Handoff recorded 2026-10-31 from Claude's findings supplied by the user.
Codex independently inspected both circuit files on that date; no circuit was
modified and no simulation was rerun during this handoff.

## Root cause and repair

In the master's `stage_IF`, `pc_pending` receives `pending_next` at both its
data input and enable. Consequently, a zero next state disables the write
that would clear the register. After LDM loads PC, the saved redirect remains
armed and is reused after the next block transfer. This is pending-PC state
handling in `stage_IF`, not an established fault in `block_transfer_control`.

In `build/pre_multiply_final/arm_custom_subset_fixed.circ`, the wire joining
`(1380,830)` to `(1380,850)` is removed. A one-bit Constant, default value 1,
labeled `PENDING_EN` at `(1380,850)` drives the existing wire to the register
enable at `(1540,850)`. Data remains connected at `(1540,830)`. The register
can therefore clock both one and zero next states. This difference was
independently confirmed in the saved XML.

## Reported behavioral verification

Claude reports direct Logisim comparisons against both files:

| Suite | Master | Candidate |
|---|---|---|
| D3 return/block-transfer discriminators | Five hangs | 8/8 correct completions, including two push/pop-PC calls |
| D1 flag-preservation discriminators | Five wrong results | 12/12 correct |

These counts are attributed to Claude's conversation report. Raw artifacts
for that specific run were not inspected by Codex in this handoff. Codex's
earlier master failures are retained in `build/bug_audit_2026-10-25/`.

## Status at the earlier candidate handoff (superseded above)

- Master `arm_custom_subset.circ` still lacks D1 and D3 repairs as of this check.
- The candidate contains both the D1 flag circuit and the D3 enable repair.
- D2 unaligned word-load rotation remains unimplemented.
- Unmasked differential tests on the candidate remain the next acceptance
  check. Existing register/RAM differences may be downstream consequences
  of D1/D3; they are not established additional independent defects.
- Multiplier adder carry and multiplier oscillation remain separate work.

This supersedes the "exact D3 cause unconfirmed" status in the October 25
audit. It does not imply the master has been repaired or that broad candidate
regression has passed.
