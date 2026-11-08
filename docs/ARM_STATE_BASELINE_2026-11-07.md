# ARM-state baseline — 2026-11-07

Status: COMPLETE. Finalized 2026-11-08; run identifier retained from 2026-11-07.

## Frozen target

- User-owned master: `arm_custom_subset.circ`, kept read-only throughout this audit.
- Source commit: `95dd0a6bdd4ef4b84bef73c70139dcda243ee270` (D2 repair and its verification, pushed to GitHub).
- SHA-256: `0cff847845b6d324276c266dbff70c3b2d833c647a4be7b92bc2ff3e9236eea1`.
- Working evidence: `build/baseline_arm_state_2026-11-07/`.
- Target: little-endian ARM-state integer code within the existing ROM/RAM map. This is an empirical baseline, not a proof that every legal instruction encoding and operand combination works.

The principal results are actual ROM execution in Logisim Evolution 5.0.0. Python assembles inputs, launches the jar and checks outputs; it does not simulate this CPU. Unicorn 2.1.4 with the TI925T model supplies independent reference results for defined, aligned instruction sequences. Unaligned LDR expectations come from explicit rotation rules and separately retained D2 tests, not Unicorn's unaligned-load behavior.

## Results

| Test | Result | Evidence |
| --- | --- | --- |
| Deep matrix | 243/244; only unimplemented SWP fails | `deep/deep.json` |
| Operand2 shifter, result/carry/completion | 204/204 | `shifter/shifter.json` |
| Additional arithmetic/flag edges | 34/34 | `extra/extra.json` |
| Directed memory, flags and PC/stack regression | 53/53 | `directed_diff/results.json` |
| Unmasked differential programs | 84/84 programs, 672 generated blocks | `directed_diff/results.json` |
| Longer mixed-instruction stress | 16/16 programs, 128 generated blocks | `chaos/results.json` |
| Condition checker | 240/240: 15 defined conditions × 16 NZCV patterns | `components/condition_checker_corrected.log` |
| Actual ARM-to-ARM BX | 4/4 plus one MOV-PC termination control | `gaps/results.json`, first five named cases |
| LDM base-in-list without writeback; STM base-first with writeback | 2/2 | `boundary/results.json`, non-PC cases |
| D2 RAM/ROM patterns and writeback | 33/33, already measured on this exact hash | `d2_patterns/result.json` |
| Harness failure-path checks | 4/4 | `python3 tests/test_logisim_runner.py` |

Do not combine these into a single CPU percentage. Cases overlap, a vector is not an instruction, and random programs contain setup/checking instructions as well as the operations under test. The 84 differential programs contain 672 generated test blocks; the 16 longer mixed programs contain 128 blocks. Neither count is a distinct-mnemonic count.

## Confirmed repairs in implemented logic

### B1 — ROM halfword loads use RAM data

`LDRH` and `LDRSH` from program ROM fail at offsets 0 and 2. Word loads, unsigned byte loads, and signed byte loads from the same ROM data pass.

A discriminator initializes the corresponding RAM index to `0x12345678`, while ROM contains `0x80fe917f`. ROM `LDRH` returns `0x5678` instead of `0x917f`; ROM `LDRSH` at offset 2 returns `0x1234` instead of `0xffff80fe`. An ordinary word load still returns the correct ROM word. This directly establishes the wrong data source, rather than merely observing zero from uninitialized RAM.

The structural trace agrees: the 16-bit halfword-select mux in `stage_MEM` takes its inputs from the splitter on raw `DATA_RAM.data_out`. The byte-select mux takes its inputs from the selected RAM/ROM word. Repair the halfword extraction source while retaining the existing lane choice and sign/zero extension.

Evidence: ROM cases in `gaps/results.json` and `confirm ROM halfword source` in `confirm/results.json`.

### B2 — memory-address shifter special encodings

Memory addressing fails for:

- `LSR #32` with a nonzero offset register;
- `ASR #32` with a positive, nonzero offset register;
- `RRX`, including explicit carry=0 and carry=1 cases.

These failures are demonstrated on byte loads/stores and word loads/stores. For example, an offset register of 4 with `LSR #32` should contribute zero; the CPU accesses base+4. An all-ones negative ASR input passes because shifting it by either 0 or 32 produces the same value; that control does not validate the special encoding.

`stage_MEM` has its own `barrel_32b`, separate from the repaired Operand2 path in `stage_EX`. Its input interface has shift type and amount but no CPSR carry input. RRX requires carry, and immediate zero encodings need normalization for LSR/ASR. Reusing correct shifter logic is a possible future simplification, but requires a reviewed data/control routing change.

Evidence: `address_final/results.json` and word-load/store confirmations in `confirm/results.json`. The original eight address probes in `gaps/` failed assembly due to an unencodable MOV constant; those are test-construction errors superseded by `address_final/`, not CPU failures.

## Instruction coverage and unfinished features

| Family | Baseline status |
| --- | --- |
| AND, EOR, SUB, RSB, ADD, ADC, SBC, RSC, TST, TEQ, CMP, CMN, ORR, MOV, BIC, MVN | Broad direct and differential coverage; conditional and flag-setting forms included. No claim of exhaustive operands. |
| LSL, LSR, ASR, ROR, RRX in data-processing Operand2 | Separate result/carry boundary suite; distinguish this from B2's memory-address path. |
| LDR, STR, LDRB, STRB, LDRH, STRH, LDRSB, LDRSH | RAM paths and ordinary addressing covered; B1/B2 prevent complete addressing/data-source support. D2 unaligned word rotation is fixed. |
| LDM/STM IA, IB, DA, DB; PUSH/POP aliases | Covered by deep/differential and directed PC/stack tests, including base writeback and repeated returns. Privileged `^` forms are outside scope. |
| B, BL, BX to ARM targets; MOV/ADD/LDR/LDM writes to PC | Tested. BX is not an unimplemented ARM branch: the old runner stopped on it before it could execute. |
| MUL, MLA, UMULL, UMLAL, SMULL, SMLAL | **Not implemented yet**, per the user's project plan. Probes describe a future acceptance target, not regressions in completed functionality. |
| SWP, SWPB | Not implemented; old-value return and new memory contents fail the probes. |
| MRS / MSR CPSR flags | Not implemented. Known-NZCV MRS and ten immediate/register MSR discriminators fail. Full CPSR/SPSR/mode semantics are a larger separate scope. |

The unfinished multiplier component diagnostics are retained separately: `ks_32b` passes 548/549 vectors (the known carry-path discriminator fails), and `mul_32` fails all four zero-product vectors with error/oscillation. These are not evidence that the ordinary ADD instruction is broken; its arithmetic path is different. Logisim's vector command returns exit code zero even on failure, so the explicit Passed/Failed summary is authoritative.

ARMv4T also includes privileged/status/exception behavior and Thumb. This baseline does not certify Thumb switching, exceptions/interrupts, banked registers/modes, SPSR/exception returns, user-privilege transfers, or coprocessor/undefined-instruction handling. Instruction families and restrictions were checked against the [ARM7TDMI instruction summary](https://documentation-service.arm.com/static/5f4786a179ff4c392c0ff819) and [ARM Architecture Reference Manual, DDI 0100I](https://documentation-service.arm.com/static/5f8dacc8f86e16515cdb865a).

Two experimental PC/register-shift cases were discarded from acceptance: DDI 0100I A5.1.6 defines R15 operands in register-specified shifts as UNPREDICTABLE. The observed PC+8/+12 oracle disagreement is not a new CPU defect. The original raw outcomes remain in `boundary/` for provenance; neither its apparent pass nor its harness error is counted as architectural coverage.

## Harness and export limitations

- Ordinary runs halt on `BX_TAKEN`. BX tests instead remove only the halt output pin from that signal on a disposable copy and drive it with a comparator observing terminal `PC_PLUS4`. CPU state/control wires are unchanged. Every such program must also write a completion marker. The observer's positive control passes.
- Deep/extra cases and all retained reference-comparison programs require completion markers. The shifter runner was strengthened to require one too, including cases whose expected result and carry are both zero.
- Comparisons do not mask NZCV or refresh flags after loads. Reference-budget exhaustion, simulator timeout, assembly failure and malformed/missing RAM dumps are not passes.
- The original stress generator excludes B1/B2 and unaligned loads; those are covered by explicit directed tests instead. A frozen committed generator was used for mixed stress, not the concurrently edited working-tree version with a patched unaligned-load oracle.
- Generated ROMs are loaded into both instruction and data-side program ROMs. Programs fit the existing 1024-word ROM and use the 256-word RAM; large-program/address-space support is not established. The RAM address width allows aliasing outside its intended 1 KiB window.

### Secondary VHDL check, not a CPU oracle

The runner freshly exported the frozen D2 circuit through Logisim for each program. It reuses compilation only for unchanged exported files; these were not tests of an old pre-D2 export.

The identical byte/halfword memory program passes all seven observed words in Logisim but differs in GHDL: a byte store selects another lane and a halfword store introduces unknown values. D2's 33-check word-rotation program agrees in GHDL. Evidence is in `vhdl/`.

Treat the lane discrepancy as an **export/testbench-path blocker to investigate before FPGA work**, separate from the direct-Logisim CPU baseline. The testbench reconstructs memory writes from exported strobes and waveform values; this is not physical FPGA validation, a golden ISA oracle, or proof that the exporter alone is at fault. The existing four-bank RAM candidate is a proposed remedy, not an applied repair to this master.

## Before customization

Preserve this source hash and the named expected failures. A structural cleanup should retain every required pass; fixing B1/B2 should change their named failures to passes without changing the other results. Do not hide those cases with masks or exclusions in the final acceptance suite.

Recommended functional sequence: fix B1, fix B2, rerun the baseline, then add the planned multiply family, swap support and CPSR flag access. Keep the FPGA export discrepancy and memory-map expansion as separately tracked work.

Replay the main suites from the repository root:

```sh
python3 tools/pre_multiply_audit.py arm_custom_subset.circ --suite deep --jobs 2 --output build/recheck/deep
python3 tools/pre_multiply_audit.py arm_custom_subset.circ --suite shifter --jobs 2 --output build/recheck/shifter
python3 tools/pre_multiply_audit.py arm_custom_subset.circ --suite extra --jobs 2 --output build/recheck/extra
# Use a Python environment with unicorn==2.1.4 for these two:
python tools/current_cpu_bug_audit.py arm_custom_subset.circ --programs 12 --timeout 90 --output build/recheck/differential
python tests/arm_state_baseline.py arm_custom_subset.circ --output build/recheck/gaps
```

The gap suite intentionally exits nonzero until missing features and B1/B2 are implemented. Interpret its named cases, not a blanket green/red total. Raw failing assembly/circuit/logs, oracle expectations, snapshot hash and tool versions are retained so future cleanup does not erase what was actually tested.

## Preserved baseline bundle

Machine-readable results: `docs/verification/arm_state_baseline_2026-11-07.json`. Raw source, test programs, dumps, logs and harness snapshots are in `docs/verification/arm_state_baseline_2026-11-07.tar.gz`; its SHA-256 is recorded beside it. Extract from the repository root with:

```sh
mkdir -p build
tar -xzf docs/verification/arm_state_baseline_2026-11-07.tar.gz -C build
```

The initial component-vector formatting error and eight invalid address-test assemblies are retained as superseded harness attempts. The single 30-second confirmation timeout was rerun at 120 seconds and completed with a reproducible RRX data mismatch. No unresolved harness errors/timeouts are included in the final supplemental verdicts.
