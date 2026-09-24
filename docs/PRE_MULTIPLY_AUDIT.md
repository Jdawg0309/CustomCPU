# Pre-multiply audit and hand-wiring guide

The protected hand-built source is `arm_custom_subset.circ`. This audit only
edits `build/pre_multiply_audit/candidate.circ` and the Python test tools.

Audited source SHA-256:
`476946cd4571d4dcf7e5bd6234c53f23d379c98618a0ff8c2aa89046189cd991`.
The byte-identical input snapshot is `build/pre_multiply_audit/baseline.circ`.

## Confirmed circuit findings

Direct Logisim 3.8.0 execution found 41 failing shifter cases in the source:
145/186 passed. Six cases return incorrect immediate LSR/ASR #32 results;
37 cases produce incorrect carry, with two cases overlapping both categories.
The candidate passes the same 186/186 cases, plus 12 ROR-with-Rs=r0 cases and
six rotated/unrotated immediate carry cases.

The RRX **result** path already works. Its carry fails because the completed
Operand2 carry logic does not reach the logical input of the CPSR carry mux.

Final sandbox candidate SHA-256:
`b620c26b8be405d45c2f8dc78138e222b1c20933be9a58e79fa09d3d34577a79`.

## Final direct-Logisim results

These were run against `build/pre_multiply_audit/candidate.circ`, not the
protected source:

| Suite | Result | Notes |
| --- | ---: | --- |
| Original shifter discriminator | 186/186 | Baseline source was 145/186 |
| Extra ROR register amount zero cases | 12/12 | Distinguishes register ROR #0 from RRX |
| Extra immediate Operand2 carry cases | 6/6 | Rotated and unrotated immediates |
| Extra ADC/SBC/RSC/logical flag cases | 34/34 | Includes V preservation for logical ops |
| Deep matrix, direct Logisim | 243/244 | Only `SWP` fails |
| Memory lane regression, direct Logisim | 19/19 | Byte, halfword, signed loads, register offsets |
| Adversarial regression, direct Logisim | 51/54 | Only MUL, MLA, and SWP fail |

`tools/deep_matrix.py` still reports `242/244` on the Python simulator: `SWP`
plus `byte lane 1 isolated`. The byte-lane case passes direct Logisim and the
standalone memory-lane regression, so treat that as a simulator mismatch, not
as another circuit wiring defect.

## Wire Operand2 carry into CPSR

Work in `stage_EX`. Add a two-input mux with **Data Bits = 1** and
**Select Bits = 1**:

| Pin | Signal |
| --- | --- |
| Input 0 | REGISTER_SHIFTER_CARRY |
| Input 1 | IMMEDIATE_CARRY |
| Select | imm_bit |
| Output | OPERAND2_CARRY |

`REGISTER_SHIFTER_CARRY` is the output of your completed four-way carry mux
selecting LSL, LSR, ASR, and ROR/RRX carry by `shift_type`.
`IMMEDIATE_CARRY` is the rotated-immediate carry result: old CPSR.C when the
immediate rotation is zero, otherwise bit 31 of the rotated immediate.

Some of these names currently label **probes**. A probe does not join nets.
Attach a one-bit tunnel to the actual source wire if using tunnels to connect
the new mux. Match tunnel labels exactly.

Find the existing four-input mux that selects the next CPSR carry. Replace
only its **input 0** connection with `OPERAND2_CARRY`:

| Existing CPSR carry mux pin | Signal after repair |
| --- | --- |
| Input 0 | OPERAND2_CARRY |
| Input 1 | Existing arithmetic ALU carry |
| Input 2 | Existing old CPSR.C |
| Input 3 | Existing old CPSR.C |
| Select/output | Keep existing connections |

Remove only the branch feeding input 0; preserve old-C connections used by
the other inputs and by the shifter. No new logical-opcode decoder is needed.
The existing ALU control already selects the logical and arithmetic cases.

## Handle immediate LSR/ASR #32

ARM encodes these two shifts with a zero five-bit immediate shift amount.
Your normal shifter treats that amount as zero; use the existing large-result
path to obtain the required zero or sign-fill result.

Build these one-bit signals:

```text
IS_LSR = (shift_type == 01)
IS_ASR = (shift_type == 10)
IS_LSR_OR_ASR = IS_LSR OR IS_ASR

IMM_SHIFT32_ACTIVE = IS_LSR_OR_ASR
                     AND IMM_ZERO
                     AND NOT reg_shift
                     AND NOT imm_bit

USE_LARGE_FINAL = existing register-large-result select
                  OR IMM_SHIFT32_ACTIVE
```

Use two 2-bit comparators, an OR gate, two NOT gates, a four-input AND gate,
and the final OR gate. `IMM_ZERO` must mean the five-bit immediate shift
amount equals zero; it is not the register shift amount's zero detector.

Find the result mux that already selects between the normal barrel-shifter
result and the type-dependent large-shift result. Feed its select with
`USE_LARGE_FINAL`, replacing its old select connection. Retain that old signal
as the first input of the new OR gate.

Its existing data paths already provide:

```text
LSR large result = 0
ASR large result = Rm[31] replicated across all 32 bits
```

This does not alter immediate LSL #0 or RRX. Both guards are required:
register-specified shifts and rotated-immediate Operand2 must retain their
own behavior.

## Make register-amount comparison explicit

On the comparator comparing the full low byte of the register shift amount
against 32, verify **Data Bits = 8**, **Numeric Type = Unsigned**, and an
8-bit constant `0x20`. The candidate explicitly sets unsigned mode.
The source already passed the tested register-amount result cases; this
setting should not be described as another independently proven result bug.

## Connections to leave alone

- RRX_ACTIVE selecting normal result versus RRX_RESULT.
- BYTE_ACESS selecting the word versus zero-extended byte result.
- The immediate/register memory-offset mux.
- Arithmetic carry and the existing CPSR write enable.

The previous missing-select claims came from the Python geometry model.
It ignored mux select-side settings and mishandled rotated muxes. Verified
against Logisim's own Multiplexer implementation, these connections are
present. Both baseline stage_EX and stage_MEM check clean after correcting
the model. Do not use the earlier select-only sandbox as a wiring reference.

## Reproduce direct Logisim checks

```bash
python3 -u tools/pre_multiply_audit.py build/pre_multiply_audit/candidate.circ --output build/pre_multiply_audit/recheck_shifter
python3 -u tools/pre_multiply_audit.py build/pre_multiply_audit/candidate.circ --suite deep --output build/pre_multiply_audit/recheck_deep
python3 -u tools/pre_multiply_audit.py build/pre_multiply_audit/candidate.circ --suite extra --output build/pre_multiply_audit/recheck_extra
python3 -u tests/memory_lane_regression.py build/pre_multiply_audit/candidate.circ
python3 -u tests/adversarial_regression.py build/pre_multiply_audit/candidate.circ
```

The audit runner uses the installed Logisim JAR through Xvfb. Every test ROM,
assembly program, RAM dump, and Logisim stdout/stderr is retained under its
output directory. It checks successful halt as well as values. Deep/extra
cases also store an explicit completion marker so a missing store cannot
pass an expected-zero case.

The initial new deep adapter placed results outside RAM and later inserted a
stack initializer before the absolute-PC test. Those adapter errors were
corrected. Use the final deep report, not the intermediate reports.

`SWP` is an unsupported instruction and remains a failing deep-matrix case.
MUL and MLA also remain unimplemented. These are explicitly outside this
pre-multiply repair; a literal 244/244 deep score requires implementing SWP.
The scope is tested ARM-state controller behavior, not full ARMv4T compliance,
Thumb, privileged modes, exception handling, or an exhaustive proof of every
possible instruction sequence.
