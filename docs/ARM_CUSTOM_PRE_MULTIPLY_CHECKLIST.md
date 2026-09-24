# ARM custom subset: pre-multiply completion checklist

Date: 2026-09-23

## Protected source and sandbox

The protected hand-built source was read but not modified during this audit:

```text
arm_custom_subset.circ
SHA-256: 2a2d5444f7ee10202647c41ebf736985ce2c707effbb6e0f8b438cc8b77a0fbe
```

The disposable, repaired circuit is:

```text
build/pre_multiply_ready/arm_custom_subset_pre_mul.circ
SHA-256: 9e3defa137ed5b15b254dd6ba3ceaf1d023af77f55e84c258eab149855e5cd13
```

Rebuild it from the current source with:

```bash
python3 tools/build_pre_multiply_ready_sandbox.py
```

## Bottom line

The current source has **three remaining pre-multiply repairs**:

1. Change the register shift-amount boundary comparison to unsigned.
2. Route immediate `LSR #32` and `ASR #32` through the existing large-shift
   result path.
3. Complete extra-transfer control for halfword/signed load-store writeback,
   normal-write suppression, and condition-failed store suppression.

This is one component setting, one shifter decode block, and one memory-control
block. A direct implementation uses about ten small gates/comparators plus
tunnel taps and five rerouted control inputs. No new 32-bit arithmetic datapath,
register-file port, RAM, barrel shifter, or controller state is required.

The Operand2 carry repair already present in the source works. Do not rebuild
it. Its `OPERAND2_CARRY` label is attached to the register-carry side rather
than the selected output side; moving that label is optional cleanup, not a
functional repair.

## Repair 1: unsigned register shift boundary

- [ ] Find the comparator that determines whether the register shift amount is
      at least 32.
- [ ] Its A input must be the full low byte `Rs[7:0]`, not five bits.
- [ ] Set **Data Bits = 8**.
- [ ] Set **Numeric Type = Unsigned**.
- [ ] Compare against an 8-bit constant `0x20`.
- [ ] Keep the existing result and carry paths for amount 0, 32, greater than
      32, and low-byte wraparound.

Why: signed comparison interprets `0xff` as `-1`. That produced four wrong
carry results at register shift amount 255 even though the shifted values were
correct.

## Repair 2: immediate LSR/ASR encoded zero

ARM encodes immediate `LSR #32` and `ASR #32` with a five-bit shift field of
zero. The current normal shifter therefore returns the unshifted operand.

- [ ] Decode `IS_LSR` from `shift_type == 01`.
- [ ] Decode `IS_ASR` from `shift_type == 10`.
- [ ] OR those into `IS_LSR_OR_ASR`.
- [ ] Invert `reg_shift` into `NOT_REG_SHIFT`.
- [ ] Invert `imm_bit` into `NOT_IMMEDIATE_OPERAND`.
- [ ] Build:

```text
IMM_SHIFT32_ACTIVE = IS_LSR_OR_ASR
                     AND IMM_ZERO
                     AND NOT_REG_SHIFT
                     AND NOT_IMMEDIATE_OPERAND
```

- [ ] `IMM_ZERO` must be the zero detector for the five-bit immediate shift
      field, not the register shift amount.
- [ ] Preserve the current select that chooses the register large-shift result;
      call it `REG_LARGE_RESULT`.
- [ ] Build `USE_LARGE_FINAL = REG_LARGE_RESULT OR IMM_SHIFT32_ACTIVE`.
- [ ] Drive the existing final normal-versus-large shifter result mux select
      with `USE_LARGE_FINAL`.

Do not alter `RRX_ACTIVE`, `RRX_RESULT`, or the Operand2 carry mux. Immediate
`LSL #0`, register shifts, rotated immediate Operand2, and RRX must bypass this
new immediate-32 term.

## Repair 3: extra-transfer memory control

The address and data paths for `LDRH`, `STRH`, `LDRSB`, and `LDRSH` already
work. The missing behavior is control integration for base writeback and
condition suppression.

Use the existing decoders to form these signals:

```text
EXTRA_LOAD_CONTROL  = IS_HWXFER AND s_bit
EXTRA_STORE_CONTROL = IS_HWXFER AND NOT s_bit

ALL_LOAD_CONTROL  = NORMAL_LOAD_CONTROL OR EXTRA_LOAD_CONTROL
ALL_STORE_CONTROL = NORMAL_STORE_CONTROL OR EXTRA_STORE_CONTROL

NORMAL_STORE_ACTIVE = NORMAL_STORE_CONTROL AND cond_pass
EXTRA_STORE_ACTIVE  = EXTRA_STORE_CONTROL AND cond_pass
ALL_STORE_ACTIVE    = NORMAL_STORE_ACTIVE OR EXTRA_STORE_ACTIVE
```

`s_bit` is instruction bit 20 in this instruction format: one means load and
zero means store.

- [ ] Replace the normal-load-only input of `load_base_write_enable` with
      `ALL_LOAD_CONTROL`.
- [ ] Keep the other load-base inputs as `wb_requested` and `cond_pass`.
- [ ] Replace the normal-store-only input of `sbwe` with `ALL_STORE_CONTROL`.
- [ ] Keep the other `sbwe` inputs as `wb_requested` and `cond_pass`.
- [ ] Drive the `data_ram_we` stage output with `ALL_STORE_ACTIVE`. This signal
      is also needed downstream to suppress the ordinary ALU register write.
- [ ] On the RAM write-enable OR, replace the raw extra-store input with
      `EXTRA_STORE_ACTIVE`.
- [ ] Leave raw `EXTRA_STORE_CONTROL` connected to the halfword byte-enable
      selection logic; only the actual RAM write must be condition-qualified.
- [ ] Leave `memory_up_base`, the immediate/register offset mux, U/P address
      selection, `wa2 = rn`, and the load-data extraction muxes unchanged.

The required writeback behavior after this repair is:

```text
extra load with writeback  -> secondary port writes memory_up_base to Rn
extra store with writeback -> primary port writes memory_up_base to Rn
condition false            -> no RAM write, no Rd write, no Rn writeback
```

## Wiring completion checks

- [ ] Every new tunnel label matches exactly; probes with matching text do not
      connect nets.
- [ ] `stage_ID`, `stage_EX`, `stage_MEM`, `stage_WB`, and `main` report no
      floating inputs, undriven nets, multiple drivers, or missed endpoints.
- [ ] `OPERAND2_CARRY` still feeds only the logical input of the CPSR carry mux.
- [ ] Arithmetic carry and old-C preservation inputs on that mux are unchanged.
- [ ] Byte enables still select one byte or one aligned halfword only.
- [ ] Conditional-false extra stores cannot reach RAM write enable.
- [ ] Conditional-false extra loads cannot write Rd or update Rn.

## Measured sandbox acceptance

All results below use Logisim directly against the sandbox circuit.

| Check | Result | Acceptance meaning |
| --- | ---: | --- |
| `stage_MEM` focused vector | 3/3 | load/store writeback and false-condition store control |
| Register/extra-offset matrix | 15/15 | word, shifted word, byte, halfword, signed, U/P/W, conditions |
| Memory lane matrix | 19/19 | all byte lanes, both halfword lanes, signed extension |
| Shifter matrix | 204/204 | immediate/register boundaries, RRX, carry |
| Extra flag matrix | 34/34 | ADC/SBC/RSC boundaries and logical C/V behavior |
| Adversarial memory group | 10/10 | addressing, writeback, literals, ROM reads |
| Adversarial block group | 5/5 | tested LDM/STM forms |
| Deep matrix | 243/244 | sole failure: `SWP` |
| Full adversarial matrix | 51/54 | expected failures: `MUL`, `MLA`, `SWP` |

Reproduce the important checks:

```bash
logisim-evolution --no-splash --test-vector stage_MEM tests/pre_mul_mem_writeback_vector.txt build/pre_multiply_ready/arm_custom_subset_pre_mul.circ
python3 -u tests/register_offset_regression.py build/pre_multiply_ready/arm_custom_subset_pre_mul.circ
python3 -u tests/memory_lane_regression.py build/pre_multiply_ready/arm_custom_subset_pre_mul.circ
python3 -u tools/pre_multiply_audit.py build/pre_multiply_ready/arm_custom_subset_pre_mul.circ --suite shifter --output build/pre_multiply_ready/recheck_shifter
python3 -u tools/pre_multiply_audit.py build/pre_multiply_ready/arm_custom_subset_pre_mul.circ --suite extra --output build/pre_multiply_ready/recheck_extra
python3 -u tools/pre_multiply_audit.py build/pre_multiply_ready/arm_custom_subset_pre_mul.circ --suite deep --output build/pre_multiply_ready/recheck_deep
python3 -u tests/adversarial_regression.py build/pre_multiply_ready/arm_custom_subset_pre_mul.circ
```

## Multiply-ready definition

After the three repairs above, the implemented pre-multiply datapaths are ready
for `MUL`/`MLA` integration. `MUL` and `MLA` are expected to fail until that
work begins.

`SWP` is also unimplemented. It is independent of the multiplier and requires
an atomic read-then-write sequence, not another small combinational wiring
repair. Choose one explicit gate before beginning multiply:

- **Practical multiplier-ready gate:** accept `SWP` as a documented omission;
  require deep matrix 243/244 and adversarial 51/54, with only `SWP`, `MUL`,
  and `MLA` failing.
- **Literal all-deep-cases gate:** implement `SWP` first and require deep matrix
  244/244. This is additional controller/state work and is outside the sandbox
  repairs documented here.

This checklist does not claim full ARMv4T. `MRS`/`MSR`, exceptions, privileged
modes, SPSRs, abort handling, coprocessor behavior, and Thumb remain separate
architecture work.
