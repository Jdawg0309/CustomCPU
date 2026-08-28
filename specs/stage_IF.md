# stage_IF — electrical spec

**Written after the fact.** `stage_IF` was the first stage built and predates
this spec format; this is derived from the circuit as it stands in
`armv4t_2.circ`, verified against `debug_armv4t.circ`. It is a record, not
instructions — but it is the reference the other four specs were modelled on,
and the deferred-PC-write mechanism in section 4 is the least obvious thing in
the whole design.

Verified: `tests/check_stage.py` clean, `tools/check_stage_if.py` 68/68
(Group A 39 checks, B 11, C 18).

---

## 1. What IF owns

Instruction fetch and **every source of a PC redirect**. Five things can change
the PC, and IF resolves all of them:

```
  sequential          pc + 4                    the default
  branch / BL         pc + 8 + (imm24 << 2)     relative, from stage_EX
  BX                  register value            absolute, from stage_EX
  writeback to r15    register value            absolute, from stage_WB
  block transfer      released when it finishes from stage_MEM
```

What IF does **not** own: the `Rd==15 AND WE` test that produces
`wb_writes_pc`. That was deliberately assigned to `stage_WB`, which kept IF at
10 inputs instead of 12. See `CLAUDE.md` section 3.

---

## 2. Interface

### Inputs (10)

| name | width | from | meaning |
|---|---|---|---|
| `clk` | 1 | — | |
| `hold_pc` | 1 | `stage_MEM.hold_pc` | a block transfer is running; freeze the PC |
| `branch_offset` | 32 | `stage_EX.branch_offset` | already `(sext(imm24) << 2) + 8` |
| `rst` | 1 | — | |
| `wb_writes_pc` | 1 | `stage_WB.wb_writes_pc` | this instruction writes r15 |
| `bx_target` | 32 | `stage_EX.bx_target` | BX destination, already word-aligned |
| `wb_data` | 32 | `stage_WB.wd` | the value being written to r15 |
| `branch_taken` | 1 | `stage_EX.branch_taken` | |
| `bx_taken` | 1 | `stage_EX.bx_taken` | |
| `bt_done` | 1 | `stage_MEM.bt_done` | the block transfer has finished |

### Outputs (3)

| name | width | to |
|---|---|---|
| `pc_plus4` | 32 | `stage_ID` (unused today), `stage_WB.pc_plus4` — the BL link value |
| `pc_word_addr` | 10 | `stage_ID.pc_word_addr`, and the instruction ROM's address |
| `instruction` | 32 | `stage_ID.instruction` |

`pc_word_addr` is a **word** index, not a byte address. That distinction has
already cost this project a day: wiring the 10-bit `pc_out` into a 32-bit adder
left 22 bits undefined and presented as a silent hang. `stage_ID` reconstructs
the byte PC as `zext(pc_word_addr) << 2` before adding 8.

---

## 3. Components

| label | type | attributes |
|---|---|---|
| `pc_fetch` | subcircuit | the PC register and its adder |
| ROM | ROM | Address Bit Width **10**, Data Bit Width **32** |
| `pc_target` | Register | Data Bits **32** |
| `pc_pending` | Register | Data Bits **1** |
| `M_ABS_SRC` | Multiplexer | Data Bits 32, Select 1 |
| `M_ABS_NOW` | Multiplexer | Data Bits 32, Select 1 |
| `redirect_req` | OR Gate | 2 inputs |
| `branch_req` | OR Gate | **3 inputs** |
| `abs_req` | OR Gate | **3 inputs** |
| `pending_next` | OR Gate | 2 inputs |
| `pc_apply` | AND Gate | 2 inputs |
| `pc_defer` | AND Gate | 2 inputs |
| `still_pending` | AND Gate | 2 inputs |
| `not_bt_done` | NOT Gate | |

`pc_fetch`'s ports are `CLK, BRANCH, hold, IMM, abs_target, abs_select, RST`
in, `pc_plus4, pc_out` out.

---

## 4. The mechanism worth understanding: the deferred PC write

Everything else here is a mux. This is the part that is not obvious.

A block transfer takes many cycles and holds the PC frozen (`hold_pc`). But a
`POP {..,pc}` writes the PC **during** that transfer — the redirect arrives
while the PC is not allowed to move. So the target is **captured now and
applied later**:

```
pc_defer      = wb_writes_pc AND hold_pc          capture: a PC write arrived mid-transfer
still_pending = pc_pending AND NOT bt_done        hold it while the transfer runs
pending_next  = pc_defer OR still_pending         -> pc_pending.D and .en
pc_apply      = pc_pending AND bt_done            release it the cycle the transfer ends
```

`pc_pending` is a 1-bit latch that remembers "a PC write is owed". `pc_target`
is the 32-bit register holding the address, enabled by `wb_writes_pc`.

Two muxes choose what actually reaches `pc_fetch.abs_target`:

```
M_ABS_SRC : wb_writes_pc ? wb_data        : bx_target      -> pc_target.D
M_ABS_NOW : pc_apply     ? pc_target.Q    : M_ABS_SRC.out  -> pc_fetch.abs_target
```

`M_ABS_SRC` picks between a live BX target and a live r15 writeback.
`M_ABS_NOW` picks between "use it now" and "use the one we stored earlier".

And the two request lines into `pc_fetch`:

```
redirect_req = branch_taken OR bx_taken
branch_req   = redirect_req OR pc_apply OR wb_writes_pc     -> pc_fetch.BRANCH
abs_req      = bx_taken     OR pc_apply OR wb_writes_pc     -> pc_fetch.abs_select
```

`BRANCH` means "redirect at all". `abs_select` means "the target is absolute,
not PC-relative". A branch sets the first and not the second; BX, an r15
writeback, and a deferred apply set both.

> **`pc_target.en` is `wb_writes_pc`, not `pc_defer`.** The target register
> loads on *every* PC write, whether deferred or not — `pc_pending` only decides
> whether the write is *applied* now or later. Gating the register on
> `pc_defer` would lose the ordinary `MOV pc,rN` case.

> **`pc_pending.en` is tied to its own `D`.** The latch only clocks when
> something wants it set or held; that makes it self-clearing the cycle after
> `bt_done`, with no explicit reset term.

---

## 5. Connections, by name

- `clk` → `pc_fetch.CLK`, `pc_target.clk`, `pc_pending.clk`
- `rst` → `pc_fetch.RST`, `pc_target.clr`, `pc_pending.clr`
- `hold_pc` → `pc_fetch.hold` and `pc_defer.in1`
- `branch_offset` → `pc_fetch.IMM`
- `branch_taken` → `redirect_req.in0`; `bx_taken` → `redirect_req.in1` and `abs_req.in0`
- `wb_writes_pc` → `pc_defer.in0`, `pc_target.en`, `M_ABS_SRC.sel`, `branch_req.in2`, `abs_req.in2`
- `bx_target` → `M_ABS_SRC.in0`; `wb_data` → `M_ABS_SRC.in1`
- `M_ABS_SRC.out` → `pc_target.D` and `M_ABS_NOW.in0`
- `pc_target.Q` → `M_ABS_NOW.in1`; `M_ABS_NOW.out` → `pc_fetch.abs_target`
- `bt_done` → `pc_apply.in1` and `not_bt_done.in`
- `pc_pending.Q` → `pc_apply.in0` and `still_pending.in1`
- `not_bt_done.out` → `still_pending.in0`
- `pc_defer.out` → `pending_next.in0`; `still_pending.out` → `pending_next.in1`
- `pending_next.out` → `pc_pending.D` **and** `pc_pending.en`
- `pc_apply.out` → `M_ABS_NOW.sel`, `branch_req.in1`, `abs_req.in1`
- `branch_req.out` → `pc_fetch.BRANCH`; `abs_req.out` → `pc_fetch.abs_select`
- `pc_fetch.pc_out` → ROM `addr` **and** the `pc_word_addr` pin
- `pc_fetch.pc_plus4` → the `pc_plus4` pin
- ROM `data_out` → the `instruction` pin

---

## 6. Traps

1. **`pc_out` is a word index (10 bits), not a byte address.** Feeding it to
   anything 32-bit needs `zext -> shift left 2` first. This is the bug that
   presented as a silent hang with no error message.
2. **`branch_req` and `abs_req` are 3-input gates.** Logisim defaults to 2, and
   the missing input is silent — you lose the deferred-apply path, which only
   shows up on `POP {pc}`.
3. **The ROM must be Address Bit Width 10, Data Bit Width 32**, and identical to
   `stage_MEM`'s literal-pool ROM. The harnesses write the program into every
   32-bit ROM in the file for exactly that reason.
4. **A freshly created ROM has no `contents` element** until something is stored
   in it, so contents-by-substitution silently no-ops and every fetch reads 0.
5. **IF has no `bl_taken` input, and that is now deliberate.** In
   `debug_armv4t.circ` the redirect is
   `OR(branch_taken, bl_taken, bx_taken, pc_apply, pc_write)`. Here `bl_taken`
   is folded into `branch_taken` inside `stage_EX` instead:

       branch_taken = cond_pass AND branch_class        (branch_class = B or BL)

   so IF stays at 10 inputs, `main` stays gate-free, and a single "a PC-relative
   branch was taken" signal reaches the front end — which is also the shape a
   pipeline wants. `bl_taken` remains a separate `stage_EX` output for
   `stage_ID`'s WA mux and `stage_WB`'s link-value mux.

   Cost of the choice: `branch_taken` now means "B or BL was taken", not "B was
   taken". `tools/check_stage_ex.py` accepts either shape and reports which one
   the circuit has.


---

## 7. Verifying

```bash
python3 tests/check_stage.py armv4t_2.circ stage_IF
python3 tools/check_stage_if.py armv4t_2.circ
```

The second is semantic and location-independent: it derives roles from
electrical behaviour rather than position, so moving parts does not invalidate
it. Current state: 68/68.
