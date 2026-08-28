# stage_WB — electrical spec

Derived from `debug_armv4t.circ` by tracing the live netlist. This is the last
stage; after it, only `main` remains.

WB is **purely combinational** — no clock, no reset, no state. It decides three
things: what value the register file writes, whether it writes at all, and
whether that write lands on the PC.

---

## 0. What WB owns

```
wd            = the writeback value      -> stage_ID.wd  AND  stage_IF.wb_data
we            = the write enable         -> stage_ID.we
wb_writes_pc  = this write targets r15   -> stage_IF.wb_writes_pc
```

`CLAUDE.md` section 3 assigned `Rd==15 AND WE` here on purpose, to keep
`stage_IF` at 10 inputs. That decision holds.

---

## 1. One deliberate departure from the master — read this first

In `debug_armv4t.circ` the register-file write-enable multiplexer
(`Multiplexer@7890,9250`, facing north) has a **floating select**. Its `in0` is
the ordinary enable tree; its `in1` is `block_transfer_control.load_enable`.

Block loads work in Logisim anyway. They should not, and here is the proof
rather than an assertion:

- `LDMDB r4!,{...}` encodes `instr[24:21]` = P,U,S,W = `1001` = 9.
- `stage_ID`'s ALU control ROM word 9 is `0x2`, whose bit 0 — the ALU write
  enable — is **0**. (Word 9 is `TEQ`; the ROM is addressed by an opcode field
  that, for a block transfer, is really the addressing mode.)
- `sbwe`, `bl_taken` and `ldr_reg_we` are all 0 during a block transfer.
- So every input of the `in0` tree is 0, and yet Logisim loads `r6`, `r7` and
  writes back the base correctly.

The enable can only be arriving through `in1`, reached because the select is
undefined. **The master's LDM depends on undefined behaviour.**

`stage_WB` therefore does **not** reproduce that mux. The write enable is an
explicit OR that includes a block-load term. This is a fix, not a deviation for
its own sake, and it is the only place this spec knowingly differs from the
master.

> Tooling note: `tools/pysim.py` models a floating input as 0, so it selects
> `in0` and loses block loads entirely. Any statement it makes about LDM/STM is
> unreliable; **Logisim is the authority there** until WB removes the floating
> select, after which both engines should agree.

---

## 2. Interface

Widths are load-bearing. Names must match exactly — `tools/check_stage_fit.py`
resolves the seams by name.

### Inputs (14)

| name | width | from | why WB needs it |
|---|---|---|---|
| `alu_result` | 32 | `stage_EX.alu_result` | the ordinary writeback value |
| `alu_we` | 1 | `stage_EX.alu_we` | the ALU control ROM's write bit |
| `cond_pass` | 1 | `stage_EX.cond_pass` | gates every write |
| `bl_taken` | 1 | `stage_EX.bl_taken` | BL writes the link value to r14 |
| `branch_taken` | 1 | `stage_EX.branch_taken` | a branch must not write a register |
| `bx_taken` | 1 | `stage_EX.bx_taken` | nor a BX |
| `pc_plus4` | 32 | `stage_IF.pc_plus4` | the BL link value |
| `load_data` | 32 | `stage_MEM.load_data` | |
| `mem_read` | 1 | `stage_MEM.mem_read` | `is_LDR OR bt_load_enable` |
| `memory_up_base` | 32 | `stage_MEM.memory_up_base` | store-with-writeback value |
| `sbwe` | 1 | `stage_MEM.sbwe` | store-with-writeback |
| `data_ram_we` | 1 | `stage_MEM.data_ram_we` | a store must not write a register |
| `wa` | 4 | `stage_ID.wa` | for the `== 15` test |
| `bt_active` | 1 | `stage_MEM.bt_active` | a block transfer is scanning; the ALU write must be off |

### Outputs (3)

| name | width | to |
|---|---|---|
| `wd` | 32 | `stage_ID.wd` **and** `stage_IF.wb_data` |
| `we` | 1 | `stage_ID.we` |
| `wb_writes_pc` | 1 | `stage_IF.wb_writes_pc` |

`wd` fans to two destinations. That is one net in `main`, not two outputs.

---

## 3. Group A — the writeback-data chain

Three muxes in series. Order matters: later muxes override earlier ones.

```
wd = sbwe     ? memory_up_base
   : mem_read ? load_data
   : bl_taken ? pc_plus4
   :            alu_result
```

| label | type | attributes |
|---|---|---|
| `M_BL` | Multiplexer | Data Bits 32, Select Bits 1 |
| `M_LOAD` | Multiplexer | Data Bits 32, Select Bits 1 |
| `M_SBWE` | Multiplexer | Data Bits 32, Select Bits 1 |

**Connections**

- `alu_result` → `M_BL.in0`; `pc_plus4` → `M_BL.in1`; `bl_taken` → `M_BL.sel`
- `M_BL.out` → `M_LOAD.in0`; `load_data` → `M_LOAD.in1`; `mem_read` → `M_LOAD.sel`
- `M_LOAD.out` → `M_SBWE.in0`; `memory_up_base` → `M_SBWE.in1`; `sbwe` → `M_SBWE.sel`
- `M_SBWE.out` → output pin `wd`

> The nesting order is the master's and it matters. A store with writeback is
> also a memory operation, so `sbwe` must be the OUTERMOST select or
> `mem_read` would steer `load_data` into Rn.

---

## 4. Group B — the write enable

```
suppress  = mem_read OR data_ram_we OR branch_taken OR bl_taken OR bx_taken
          OR bt_active
normal_we = alu_we AND cond_pass AND NOT suppress
load_we   = mem_read AND cond_pass
we        = sbwe OR bl_taken OR load_we OR normal_we
```

| label | type | attributes |
|---|---|---|
| `OR_SUPPRESS` | OR Gate | **6 inputs** |
| `NOT_SUPPRESS` | NOT Gate | |
| `AND_NORMWE` | AND Gate | **3 inputs** |
| `AND_LOADWE` | AND Gate | 2 inputs |
| `OR_WE` | OR Gate | **4 inputs** |

**Connections**

- `OR_SUPPRESS` inputs ← `mem_read`, `data_ram_we`, `branch_taken`, `bl_taken`, `bx_taken`
- `OR_SUPPRESS.out` → `NOT_SUPPRESS.in`
- `AND_NORMWE` ← `alu_we`, `cond_pass`, `NOT_SUPPRESS.out`
- `AND_LOADWE` ← `mem_read`, `cond_pass`
- `OR_WE` ← `sbwe`, `bl_taken`, `AND_LOADWE.out`, `AND_NORMWE.out`
- `OR_WE.out` → output pin `we`

Two things to understand rather than copy:

**Why `AND_LOADWE` uses `mem_read` and not `ldr_reg_we`.** `stage_MEM` computes
`mem_read = is_LDR OR bt_load_enable`, so this single term covers an ordinary
LDR *and* every register of a block load. `ldr_reg_we` would cover only the
former, which is exactly the hole the master papers over with the floating
select. This is the fix from section 1.

**Why `bt_active` is in the suppress list, measured not assumed.** A block
transfer walks `bt_reg_idx` through the register list, and `stage_ID` steers
`WA` to it for the whole transfer. Without this term, `normal_we` stays high on
every scan cycle -- `alu_we` comes from the ALU control ROM addressed by the
addressing-mode bits, which for most LDM/STM forms reads as a writing opcode --
so the ALU result is written into each register the scan passes over.

Measured on `ldmia r4,{r0,r3}`: **17 spurious writes**, corrupting r1, r2, r4,
r6, r7, r8 and r9. Every one had `bt_active=1` and `mem_read=0`; the two
legitimate loads both had `mem_read=1`. So this term removes exactly the
spurious writes and nothing else -- the real loads arrive through `AND_LOADWE`,
which `suppress` does not gate.

This also refines section 1: the master's floating select was not merely
*admitting* the block-load enable, it was *excluding* an `in0` that would have
corrupted registers. Two bugs, one undefined signal hiding both.

**Why the suppress list uses the `_taken` signals.** The master suppresses on
`is_BX OR branch_class OR mem_class`, which are ungated. The `_taken` versions
are the same signals ANDed with `cond_pass` — and `normal_we` is already ANDed
with `cond_pass`, so the two are equivalent. Using the taken forms means WB
needs no new outputs from EX or MEM.

Note on `bl_taken` appearing in both the suppress list and `OR_WE`: that is
correct and not a duplication. BL must not write via the ALU path, but must
write r14 via its own term.

`bl_taken` **has now been folded into `branch_taken` inside `stage_EX`** (see
`specs/stage_IF.md` trap 5), so `branch_taken` already covers BL and the
separate `bl_taken` entry in `OR_SUPPRESS` is redundant. **Leave it in anyway**
-- it costs one gate input, it is correct with or without the fold, and removing
it would make WB's correctness depend on a decision made in another stage.

That fold changes nothing else here. On a BL, `branch_taken` and `bl_taken` are
both high; `normal_we` is suppressed either way, and `we` still comes from the
`bl_taken` term in `OR_WE`.

---

## 5. Group C — writes that land on the PC

```
wb_writes_pc = (wa == 15) AND we
```

| label | type | attributes |
|---|---|---|
| `K_R15` | Constant | Data Bits **4**, **Value 15** |
| `CMP_RDPC` | Comparator | **Data Bits 4** |
| `AND_WBPC` | AND Gate | 2 inputs |

**Connections**

- `wa` → `CMP_RDPC.a`; `K_R15.out` → `CMP_RDPC.b`
- `CMP_RDPC.eq` → `AND_WBPC.in0`; `OR_WE.out` → `AND_WBPC.in1`
- `AND_WBPC.out` → output pin `wb_writes_pc`
- leave `CMP_RDPC.gt` and `.lt` unconnected

> **Set the Comparator's Data Bits to 4.** Its default is 1, and a 1-bit
> compare against `0xF` tests only `wa[0]` — so every odd destination register
> would look like the PC. This exact defect was caught in `stage_MEM`'s
> `CMP_BLOCK` by `Sim.width_conflicts()`; expect that check to catch it again
> if you miss it.

> `wa` already accounts for `sbwe`, `bl_taken` and `bt_active`, because
> `stage_ID`'s mux chain resolves all of them before the `wa` pin. WB compares
> the final address, which is what makes `POP {pc}` and `LDR pc,[..]` work.

---

## 6. Traps

1. **`sbwe` is the outermost writeback-data select.** See Group A.
2. **`CMP_RDPC` must be 4 bits.** See Group C.
3. **`OR_SUPPRESS` has five inputs and `OR_WE` has four.** Logisim defaults a
   gate to 2; the extra inputs are silent if you forget.
4. **Do not add a mux for the block-load enable.** The whole point of Group B
   is that it is an OR term, not a select. See section 1.
5. **WB has no clock.** If you find yourself wanting a register here, the
   design has changed and this spec no longer applies.

---

## 7. Verifying

```bash
python3 tests/check_stage.py armv4t_2.circ stage_WB
python3 tools/check_stage_fit.py armv4t_2.circ
python3 tools/check_defaults.py armv4t_2.circ stage_WB
```

Once WB exists, `main` is five instances, a Clock and a reset pin — and then
the project's own suites run against the rebuilt CPU on the same 54-case scale
as `debug_armv4t.circ`'s 43.

### Discriminator 1 -- BL, because it is half-built and WB closes it

`stage_EX` already redirects the PC on a BL. What is missing is the link value,
and that is entirely WB's:

```asm
    mov  r0, #1
    bl   sub1
    mov  r2, #0x33      @ must be reached again after the return
    b    done
sub1:
    mov  r1, #0x11
    bx   lr             @ needs r14, which only WB can have written
done:
```

Today the trace shows `wa=14` with `we=0` at the BL -- the destination is right
and the write never happens -- so `bx lr` jumps to 0 instead of returning.
After WB: `M_BL` supplies `pc_plus4`, `OR_WE`'s `bl_taken` term supplies the
enable, and execution must return to the `mov r2,#0x33`.

Because the redirect half is already known-good, any failure here is the link
mux or the enable, not the branch.

### Discriminator 2 -- LDMDB, because it is the one this spec changes

```asm
    mov r4,#0x1100
    mov r1,#0x51
    mov r2,#0x52
    str r1,[r4]
    str r2,[r4,#4]
    add r4,r4,#8
    ldmdb r4!,{r6,r7}       @ opcode field 1001 -> ALU ROM says write_enable=0
```

`r6` must be `0x51`, `r7` must be `0x52`, and `r4` must come back to `0x1100`.
In the master this passes only because a floating select happens to admit the
block-load enable. In the rebuild it must pass because Group B says so.
