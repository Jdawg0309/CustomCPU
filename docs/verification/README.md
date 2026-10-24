# Verification records

## Master repair 2, 2026-10-24

`fix2_shifter_2026-10-24.json`: 204/204 direct Logisim cases passed on the
hand-wired master. See [the checkpoint](../FIX2_VERIFIED_2026-10-24.md) for the
exact source hash, reproduction command, coverage, and remaining work.

## Earlier repaired-sandbox checks from this session

These results apply to `build/pre_multiply_ready/arm_custom_subset_pre_mul.circ`,
SHA-256 `9e3defa137ed5b15b254dd6ba3ceaf1d023af77f55e84c258eab149855e5cd13`,
which includes memory repair 3 as well as the shifter repairs:

- `sandbox_shifter_2026-10-24.json`: 204/204 passed.
- `sandbox_extra_flags_2026-10-24.json`: 34/34 passed.

They do not establish that memory repair 3 is implemented in the master.
Run `tools/pre_multiply_audit.py` against that sandbox with `--suite shifter`
or `--suite extra` to reproduce these suites in Logisim. Temporary ROM-patched
circuit copies, object files, and RAM dumps remain local; these JSON files
preserve the per-case expected values, observed values, and execution status.

The sandbox-builder adjustment committed with these records accepts an
already-unsigned register-boundary comparator in a pre-repair-2 source.
The builder still rejects a source containing `IMM_SHIFT32_ACTIVE`; it is
not a general idempotent updater for the newly repaired master.
