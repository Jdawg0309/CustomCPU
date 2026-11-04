# Fix 6 — extra-transfer control (repair 3), `arm_custom_subset.circ`

Derived 2026-10-24 by diffing the hand-wired master against the repaired
sandbox (`build/pre_multiply_ready/arm_custom_subset_pre_mul.circ`) in
`stage_MEM`, then re-reading the master's own nets. Nothing here was written to
the master. Part names are labels where they exist, otherwise `(x,y)` of the
part's anchor in `stage_MEM`.

Scope: `stage_MEM` only. `stage_ID`, `stage_EX`, `stage_WB` and `main` need no
change for this repair.

## Behaviour being added

```text
extra load  with writeback -> secondary port writes memory_up_base to Rn
extra store with writeback -> primary port writes memory_up_base to Rn
condition false            -> no RAM write, no Rd write, no Rn writeback
```

"Extra" = `LDRH / STRH / LDRSB / LDRSH` (`is_hwxfer`). `s_bit` = 1 load, 0 store.

## Signals that already exist in the master

| name | what it is | where |
|---|---|---|
| `NORMAL_LOAD_CONTROL` | `m_class AND s_bit` (probe `is_LDR`) | AND (890,970) |
| `ALL_LOAD_CONTROL` | `NORMAL_LOAD_CONTROL OR HW_LOAD` (label `combined`) | OR (1040,970) |
| `NORMAL_STORE_CONTROL` | `m_class AND NOT s_bit` (probe `is_STR`) | AND (890,1080) |
| `EXTRA_STORE_CONTROL` | `NOT s_bit AND is_hwxfer` | AND (2720,1340) |
| `NORMAL_STORE_ACTIVE` | `is_STR AND cond_pass` | AND (1790,1050) |
| `load_base_write_enable` | `cond_pass, is_LDR, wb_requested` | AND (1790,1150) |
| `sbwe` | `cond_pass, is_STR, wb_requested` | AND (1790,850) |
| RAM write OR | in0 `NORMAL_STORE_ACTIVE`, in1 raw `EXTRA_STORE_CONTROL`, in2 block `store_enable` | OR `RAM_WE` (2210,1040) |

`ALL_LOAD_CONTROL` is already built; it feeds `ldr_reg_we` and `mem_read` today
but not `load_base_write_enable`.

## New parts (3 gates)

1. OR `ALL_STORE_CONTROL` (2 inputs): in0 = `NORMAL_STORE_CONTROL`, in1 = `EXTRA_STORE_CONTROL`.
2. AND `EXTRA_STORE_ACTIVE` (2 inputs): in0 = `EXTRA_STORE_CONTROL`, in1 = `cond_pass`.
3. OR `ALL_STORE_ACTIVE` (2 inputs): in0 = `NORMAL_STORE_ACTIVE`, in1 = `EXTRA_STORE_ACTIVE`.

## Five connection changes

| # | on this input | currently | change to |
|---|---|---|---|
| 1 | `load_base_write_enable`.in1 — AND (1790,1150) | `NORMAL_LOAD_CONTROL` | `ALL_LOAD_CONTROL` |
| 2 | `sbwe`.in1 — AND (1790,850) | `NORMAL_STORE_CONTROL` | `ALL_STORE_CONTROL` (new OR) |
| 3 | `data_ram_we` output pin | `NORMAL_STORE_ACTIVE` | `ALL_STORE_ACTIVE` (new OR) |
| 4 | RAM write OR `RAM_WE`.in1 | raw `EXTRA_STORE_CONTROL` | `EXTRA_STORE_ACTIVE` (new AND) |
| 5 | (none) | — | leave as is, see below |

Change 5 is a non-change: the NOT gate (2810,1340) that drives the halfword
byte-enable logic stays on **raw** `EXTRA_STORE_CONTROL`. Byte-lane selection
does not depend on the condition; only the actual RAM write must.

Keep `RAM_WE`.in0 on `NORMAL_STORE_ACTIVE` (the AND (1790,1050) output). After
change 3 the `data_ram_we` pin and `RAM_WE`.in0 are no longer the same net;
that is expected.

Do not touch: `memory_up_base`, the immediate/register offset mux, U/P address
selection, `wa2 = rn`, the load-data extraction muxes, `base_writeback_en`.

## Why `data_ram_we` gets `ALL_STORE_ACTIVE`

`data_ram_we` is also what suppresses the ordinary ALU register write
downstream. An extra store must suppress it too, or `STRH` would write its
ALU result into `Rd`.

## Acceptance

```bash
xvfb-run -a logisim-evolution --no-splash --test-vector stage_MEM \
    tests/pre_mul_mem_writeback_vector.txt arm_custom_subset.circ
```

| | master before | sandbox | target |
|---|---|---|---|
| vectors passed | 1 / 3 | 3 / 3 | 3 / 3 |
| failing before | vec 1 `we2`; vec 2 `sbwe`, `data_ram_we` | — | — |

Then: `register_offset_regression.py` 15/15, `memory_lane_regression.py` 19/19,
`pre_multiply_audit.py --suite shifter` 204/204 (must not regress),
`--suite extra` 34/34, `--suite deep` 243/244, `adversarial_regression.py`
51/54 (only MUL, MLA, SWP fail).

## Blind spot in the 3-vector test

Vector 3 (condition false) passes on the **unrepaired** master, because extra
stores never reach `data_ram_we` there. It cannot see change 4. Change 4 needs
its own discriminator: a condition-false `STRH` followed by a read-back of the
target word, which must be unchanged. Add that before trusting 3/3.
