# Claude handoff — memory lanes and multiply-family stop point

Date: 2026-09-02  
Branch observed: `pc-read-and-memory-map`  
HEAD observed: `500d42f`

## Read this first

The user explicitly required that neither protected master circuit be edited:

- **never write `armv4t.circ`;**
- **never write `armv4t_2.circ`;**
- experiments and automated fixes belong in `debug_armv4t_2.circ`.

That rule was followed during this work. `armv4t_2.circ` is currently dirty in
the worktree from user work; preserve it exactly as found. Do not use a broad
checkout, reset, formatter, or mechanical rewrite that could destroy it.

The user also instructed us to stop once the multiply family was complete. Do
not silently begin `SWP`, block-transfer edge work, shifter edge work, or master
circuit wiring as part of this handoff.

## Current measured outcome

| Verification | Result |
|---|---:|
| Full adversarial CPU suite | **53/54** |
| Dedicated byte/halfword lane suite | **19/19** |
| Dedicated multiply-family result words | **27/27** |
| Direct long-multiply `stage_EX` vector | **4/4** |
| Logisim graph/geometry Python unit tests | **18/18** |
| `stage_ID` structural check | clean |
| `stage_EX` structural check | clean |
| `stage_WB` structural check | clean |
| `main` structural check | clean |
| `stage_MEM` structural check | one undriven select; see below |

The only failure in the 54-case suite is:

```text
[ WRONG ] SWP got=00000000 expected=000000aa
PASS=53  WRONG=1
Architectural checks: 53/54 passed
```

The complete multiply family passes:

```text
[PASS] MUL MLA UMULL UMLAL SMULL SMLAL
[PASS] 64-bit accumulate carry and signed high halves
[PASS] MULS/SMULLS N/Z condition behavior
27/27 result words correct
```

## File hashes at handoff

These identify the exact files that were measured:

```text
armv4t.circ
ee58cb397dd9db6b471e011cdf2541ad9835632d5b8ff4602a179d2712dcdf84

armv4t_2.circ
7e12411be43b1cff74707ac578c5ca90e42738b086614e1edff1b2727c65b69b

debug_armv4t_2.circ
6237cc61f303cbfbada08ba82bcac0f40ce084c443b94976193eaf96918bb27e
```

If the debug hash changes, re-run the focused and full regressions before using
the numbers above.

## What is complete in `debug_armv4t_2.circ`

### Byte and halfword transfers

The RAM now uses real byte enables. Working behavior includes:

- `STRB` on all four byte lanes without corrupting neighboring bytes;
- `LDRB` on all four lanes with zero extension;
- `STRH` on both aligned halfword lanes without corrupting the other half;
- `LDRH` on both lanes with zero extension;
- `LDRSB` on all lanes with positive and negative sign extension;
- `LDRSH` on both lanes with positive and negative sign extension.

The actual design does **not** use the older read-modify-write proposal in
`specs/fix_5_halfword.md`. It replicates the low byte or halfword on the RAM data
input and selects the committing lanes with `BE[3:0]`.

Detailed implementation document:

```text
docs/HALFWORD_BYTE_ACCESS_IMPLEMENTATION.md
```

Focused regression:

```bash
python3 -u tests/memory_lane_regression.py debug_armv4t_2.circ
```

Expected final result: `Memory lane checks: 19/19 passed`.

### Short multiply

`MUL`, `MLA`, `MULS`, and `MLAS` use Logisim's built-in 32-bit multiplier.
Short multiplication writes the low 32-bit result through the normal primary
write port. `MLA` adds the correctly routed third operand. Conditional-false
writes are suppressed. `N` and `Z` are derived from the 32-bit result.

### Long multiply

`UMULL`, `UMLAL`, `SMULL`, and `SMLAL` are implemented.

`stage_ID` provides:

```text
mul_long
mul_signed
mul_long_acc
```

`stage_EX` provides:

```text
alu_result   = long low half for a long multiply
mul_hi       = long high half
mul_long_we  = mul_long AND condition_passed
```

One unsigned 32-by-32 multiplier generates the 64-bit unsigned product. Signed
high-half correction is:

```text
signed_hi = unsigned_hi
          - (Rm[31] ? Rs : 0)
          - (Rs[31] ? Rm : 0)
          mod 2^32
```

Long accumulation is:

```text
low_sum, carry = product_lo + RdLo
high_sum       = product_hi + RdHi + carry
```

The low half uses the primary write port. The high half arbitrates onto the
existing secondary write port in `main`:

```text
WD2 = mul_long_we ? MUL_HI : MEM_WD2
WA2 = mul_long_we ? RdHi   : MEM_WA2
WE2 = mul_long_we OR MEM_WE2
```

Long `N` comes from bit 63. Long `Z` requires both halves to be zero. During
multiply, the implementation preserves current `C` and `V`; this gives a
deterministic choice where short-multiply `C` is architecturally unpredictable
and `V` is unaffected.

Detailed implementation document:

```text
docs/MULTIPLY_FAMILY_IMPLEMENTATION.md
```

Focused regression:

```bash
python3 -u tests/debug_multiply_suite.py debug_armv4t_2.circ
```

Direct vector:

```bash
logisim-evolution --no-splash \
  --test-vector stage_EX tests/multiply_long_ex_vector.txt \
  debug_armv4t_2.circ
```

## Files created or intentionally changed in this work

The multiply/memory stop-point work includes at least:

- `debug_armv4t_2.circ` — experimental CPU implementation;
- `tests/memory_lane_regression.py` — 19 subword-memory discriminators;
- `tests/debug_multiply_suite.py` — 27 multiply result checks;
- `tests/multiply_long_ex_vector.txt` — four direct execute-stage vectors;
- `logisim/geometry.py` — explicit `BitSelector` port geometry;
- `docs/HALFWORD_BYTE_ACCESS_IMPLEMENTATION.md` — actual memory implementation;
- `docs/MULTIPLY_FAMILY_IMPLEMENTATION.md` — actual multiply implementation;
- `docs/ULTIMATE_CHECKLIST.md` — measured status through Priority 5. Priority 2
  remains open only because its register-offset halfword form still needs a
  dedicated discriminator; the aligned low/high immediate-offset paths pass.

There are many other dirty and untracked files in the shared worktree. They are
not all owned by this specific change. Inspect `git status --short` and do not
stage everything blindly.

## Known structural warning

This command:

```bash
python3 tests/check_stage.py debug_armv4t_2.circ stage_MEM
```

reports:

```text
UNDRIVEN NETS (1)
net#163 feeds Multiplexer@760,1830.sel
```

All 19 focused memory checks and every memory test in the full suite pass, so
this is not being claimed as a current functional failure. It is nevertheless a
real structural warning. Trace it and either connect the intended control or
remove the unused mux before calling the entire netlist electrically clean.

Do not conflate this warning with `SWP`; the remaining 54-suite failure is a
missing/unimplemented atomic swap behavior, not a diagnosed consequence of
this select.

## Tooling bug fixed during multiply

Signed operand sign extraction initially used splitter endpoints. The Python
geometry model considered them connected while real Logisim propagated an
undefined value. The circuit now uses explicit 32-bit `BitSelector` components
with selector `31`, and `logisim/geometry.py` contains the matching port model.

Verify the tooling change with:

```bash
python3 -m unittest discover -s tests -p 'test_logisim.py'
```

Current expected result: 18 tests, `OK`.

## Exact full-regression command

```bash
python3 -u tests/adversarial_regression.py debug_armv4t_2.circ
```

This takes roughly 2.5 minutes on the current machine. Do not replace the real
Logisim result with the faster Python simulator when reporting architectural
acceptance.

## Recommended next step after the user resumes

The immediate 54-suite gap is `SWP`. However, the user asked to stop at the
multiply-family boundary. On resumption:

1. confirm the protected-file rule again;
2. re-run 53/54 if `debug_armv4t_2.circ` changed;
3. decide whether to implement `SWP`/`SWPB` or deliberately omit them;
4. separately continue Priority 6 block-transfer edge cases and Priority 7
   shifter edge semantics from `docs/ULTIMATE_CHECKLIST.md`;
5. do not hand-wire the protected master until the user explicitly asks for
   instructions—never edit it automatically.

## Git state

No commit or push was performed as part of this handoff. Signing has previously
required user interaction, and the shared worktree contains unrelated user
changes. Make a narrow commit only after reviewing the exact path list.
