# Direct Logisim audit and harness review — 2026-10-25

The master was read only. Its SHA-256 before and after this audit was:
`637a37ed5f2f921eb34ddc276df92b6cb41fd99577d98cfa1171d7b3c91d5ecb`.
All hardware executions used the frozen copy at
`build/bug_audit_2026-10-25/source.circ`, with ROM contents replaced only in
per-test copies. Engine: Logisim-evolution 5.0.0. Differential oracle:
Unicorn 2.1.4, TI925T CPU model. No flag masking or flag-refresh workaround
was used in this audit's differential runs.

## Results

| Suite | Result | Evidence under `build/bug_audit_2026-10-25/` |
|---|---|---|
| Register offsets, writeback, condition-failed extra transfers | 15/15 | `discriminators_v2/results.json`, cases 0–14 |
| Byte/halfword lanes and signed extension | 19/19 | same, cases 15–33 |
| Deep matrix, actual ROM execution in Logisim | 243/244; only SWP fails | `deep/deep.json` |
| Additional arithmetic and logical flag checks | 34/34 | `extra/extra.json` |
| Targeted bug/control programs | 9 pass, 7 value mismatches, 3 timeouts | `discriminators_v2/results.json`, cases 34–52 |
| Unmasked differential programs | 8/14 programs identical; 112 contained tests | same, `Unicorn ...` rows |
| Adder `ks_32b` | 4/5 vectors pass | `components/ks_32b.log` |
| Multiplier `mul_32`, zero-product inputs | 0/4; both outputs E/oscillating | `components/mul_32.log` |

The original standalone register-offset suite also passed 15/15 before the
retained completion-marker version ran. It is duplicate coverage, not 15
additional distinct cases. This session did not rerun the prior 204-case
shifter suite; its historical result remains documented separately.

## Reproduced defects

1. **Flags clobbered by LDRH, LDRSB, LDRSH, and LDM.** Set NZCV to `1000`,
   execute the load, and capture flags through conditional instructions.
   Each returns `0000`, while Unicorn preserves `1000`. LDR, LDRB, STRH,
   and STM controls preserve flags. See `directed_036`–`038` and `040`.
   The existing `specs/fix_7_flag_clobber.md` describes a candidate repair;
   this audit did not implement it.
2. **A block transfer after LDM-to-PC does not complete.** Both
   `ldmia r10,{r4,pc}` followed by STM and followed by LDM time out after
   30 seconds. Two push/pop-return calls also time out. Controls pass:
   LDM-to-PC followed by an ordinary LDR, LDM without PC followed by STM,
   LDR-to-PC followed by STM, and two calls returning via MOV PC,LR.
   The LDM-to-PC/STM sequence was repeated at **120 seconds** with the
   corrected timeout wrapper and still timed out; see `timeout_recheck/`.
   This strongly reproduces the noncompletion bug but does not establish
   the exact internal controller state causing it.
3. **Unaligned word LDR returns the unrotated aligned word.** With
   `0x11223344` in RAM, offsets 1/2/3 return that same value instead of
   `0x44112233`, `0x33441122`, and `0x22334411`. Offset 0 passes. Expectations
   follow ARM's legacy word-load rule, not Unicorn's unaligned behavior:
   [ARM Architecture Reference Manual, LDR, architecture v5 and below](https://kib.kiev.ua/x86docs/ARM/ARMARMv5/DDI0100F-02.pdf#page=193).
4. **Multiplier adder carry failure.** `ks_32b` with A=`0x3fc00000`,
   B=`0x00400000`, Cin=0 produces SUM30=0, expected 1. Four control vectors
   pass. This confirms the behavioral fault; the proposed two-wire repair
   in the previous audit was not applied.
5. **Multiplier block reports oscillation/error outputs.** Direct vectors
   for 0×0, 0×1, 1×0, and `0xffffffff`×0 produce E on both `sum` and `carry`.
   These are internal multiplier issues, separate from integration into the
   CPU instruction decoder and result selection.

SWP remains an unimplemented instruction, accounting for the deep-matrix
failure (result 0 rather than 0xaa). This audit does not reclassify all other
unimplemented ARM instructions as newly discovered bugs.

## Differential evidence and limitations

Two programs per category, eight tests per program, deterministic seeds
`20261025-<category>-<program index>`:

- DP, condition codes, branches, and PC: 2/2 programs pass per category.
- Memory, block transfers, and mixed: 0/2 programs pass per category.

Failing programs include flag, register, and RAM differences. The isolated
flag bug can affect later conditional instructions, but this audit has NOT
proved it explains every differential mismatch. Preserve and rerun these
programs after fixing flags; do not label all residual mismatches explained.
The retained `.S`, `.bin`, `.circ`, `.log`, expected RAM JSON, and actual RAM
dump files allow individual failures to be examined.

The deep matrix includes a base-register-in-store-list case with an assembler
warning. Its pass is an observed implementation behavior, not a portable
architectural guarantee. Sample counts do not prove exhaustive ISA coverage.

## Harness defects and changes

In `tests/push_suite.py`:

- Replaced an import-time argv-dependent, stale circuit default with the
  repository master; standalone invocation still accepts an explicit path.
- Select ROMs by the actual `dataWidth` attribute instead of any `val="32"`.
- Delete a stale RAM dump before execution and reject a missing new dump.
- Check process exit status and retain stdout/stderr in `t.log`.
- Validate the observed `v3.0 hex words plain` dump format and all **256**
  words, rejecting empty, truncated, malformed, or unexpected formats.
  Preserve the sparse RAM dictionary API for existing callers.
- Use GNU timeout to bound the simulator process tree, including Java/Xvfb,
  and distinguish timeout from a value mismatch. Default remains 120 seconds.

In `tests/unicorn_diff.py`, verify PC reached `halt_here` after reference
execution; exhausting the instruction budget is now a harness error.

In `tools/current_cpu_bug_audit.py`, retain reproductions, distinguish
HARNESS_ERROR/TIMEOUT/FAIL/PASS, require a nonzero end-of-program RAM marker,
and validate directed expected values against Unicorn (except unaligned LDR,
whose oracle is the architecture rule). Snapshot registers before marker
scratch-register use. All seven categories run without masking flags.

Important remaining constraints:

- The circuit's halt pin is driven by taken BX. A BX inside a program stops
  the testbench. The new marker detects premature completion, but normal BX
  return behavior still needs a dedicated testbench. Random tests omit BX.
- `--test-vector` **returns exit status 0 even when vectors fail** on this
  installation. The adder/multiplier results above were classified from the
  actual `Passed: ..., Failed: ...` summary and error output, never exit code.
- Unicorn is not the unaligned-LDR oracle. Tests use aligned random memory
  operations and separate hand-derived unaligned discriminators.
- Random snapshots cover r0–r12 and r14 plus NZCV and 1 KiB RAM; SP is used
  by the snapshot mechanism. This is not full-state or exhaustive testing.
- Some generated flag setters are TST/TEQ, which preserve parts of prior
  flag state. Whole-program comparison is valid, but isolated reruns can
  change inherited state; they are not automatically independent tests.

## Harness validation

`python3 tests/test_logisim_runner.py`: 4/4 tests pass, including malformed
dumps, stale/missing dumps, engine failure, and timeout classification.
Live negative controls in `harness_controls/results.json` all pass:

- A reference infinite loop is rejected instead of supplying partial results.
- A legitimate zero-result hardware program with a completion marker passes.
- An early BX halts but lacks the marker and is correctly rejected.

An initial draft of the new audit script used a non-encodable MOV immediate
for the marker address. Those 67 assembly failures in `discriminators/` were
HARNESS_ERROR, not CPU failures. The corrected run is `discriminators_v2/`.

## Reproduction

Use a Python environment containing Unicorn 2.1.4 and installed ARM binutils,
Java, Xvfb, GNU timeout, and Logisim-evolution 5.0.0. Set LOGISIM_JAR if needed.

```bash
python tools/current_cpu_bug_audit.py build/bug_audit_2026-10-25/source.circ \
  --output /tmp/customcpu-audit-repeat
python tools/pre_multiply_audit.py build/bug_audit_2026-10-25/source.circ \
  --suite deep --jobs 1 --output /tmp/customcpu-deep-repeat
python tools/pre_multiply_audit.py build/bug_audit_2026-10-25/source.circ \
  --suite extra --jobs 1 --output /tmp/customcpu-extra-repeat
```

Fix the flags and LDM-to-PC controller behavior before declaring the current
subset stable. Repair the multiplier's adder and oscillation before integrating
multiply. Unaligned word rotation remains separate work. No circuit changes,
commits, or pushes were performed in this audit.
