# Immediate shift-by-32 repair verified

On 2026-10-24, the hand-wired `arm_custom_subset.circ` passed **204/204 direct
Logisim shifter regression cases**, including all six previously failing
immediate `LSR #32` and `ASR #32` result/carry checks.

Circuit SHA-256:
`b6eae2d0394c15061dc70efdcbcb2e6ea734e345871c51d6b8c019d3d0e87217`

## Change

In `stage_EX`, two comparators decode raw `s_type` values 1 (LSR) and 2 (ASR).
Their combined result is gated with `IMM_ZERO`, NOT `reg_shift_edge`, and
NOT `imm_b` to form `IMM_SHIFT32_ACTIVE`. The final selector is:

```text
USE_LARGE_FINAL = use_large_shift_result OR IMM_SHIFT32_ACTIVE
```

The existing normal-versus-large result mux now uses this selector. The
existing large-shift datapath, RRX selection, and carry logic are preserved.
The user wired the master manually; verification used temporary copies.

The saved file also includes Logisim-evolution's 3.8.0-to-5.0.0 format
migration (output-pin attributes, library references, and editor metadata),
plus the main clock's appearance setting. These account for much of the diff.

## Verification

Execution engine: Logisim-evolution 5.0.0, via `xvfb-run` and the Java CLI.
Programs are assembled with GNU ARM binutils and loaded into ROMs in temporary
circuit copies. Python generates cases and checks expected results; it does
not simulate the CPU for this run. Each case checks the stored result and
carry flag, requires a halt, and rejects reported oscillation.

```bash
python3 tools/pre_multiply_audit.py arm_custom_subset.circ \
  --suite shifter --jobs 2 --output /tmp/customcpu_fix2_verified
```

Set `LOGISIM_JAR` to the installed Logisim-evolution JAR when necessary.
The accompanying runner update recognizes that override and the local 5.0.0
installation as well as the older Snap path.

Full per-case expected/actual results:
[fix2_shifter_2026-10-24.json](verification/fix2_shifter_2026-10-24.json).

Coverage includes immediate LSL/LSR/ASR/ROR, RRX with both incoming carry
values, register LSL/LSR/ASR/ROR at amounts 0, 1, 31, 32, 33, 63, 64, 255,
256, and 257, overlapping ROR amount/destination register `r0`, and rotated
immediate-operand carry behavior. The six repaired cases use operands
`0x80000001`, `0x7ffffffe`, and `0x12345678` with both LSR #32 and ASR #32.

## Remaining work

- Repair 1: unsigned register-shift boundary comparison was already committed.
- Repair 2: implemented in the master and verified by this 204-case run.
- Repair 3: extra-transfer base writeback, normal-write suppression, and
  condition-failed store suppression remain outstanding in the master.
- Multiply integration remains subsequent work.

This is a shifter regression milestone, not exhaustive CPU verification or a
claim of complete ARMv4T support. The older pre-multiply sandbox builder is
intended for the pre-repair source and rejects a source already containing
`IMM_SHIFT32_ACTIVE`; it is not the reproduction command for this checkpoint.
