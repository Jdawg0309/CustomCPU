# main — electrical spec

The top level. Five stage instances, a Clock, a reset pin, and output pins.

**Zero logic gates.** If you find yourself wanting a gate here, it belongs
inside a stage. That rule is what makes the pipeline refactor later a change to
one file instead of a rewrite -- `CLAUDE.md` section 3.

Every connection below was derived from the five stage interfaces, not written
from memory: 64 input pins across the five stages, of which 62 resolve to a
same-named output on exactly one other stage. The two that do not are called
out in section 3, and they are the only places you have to think.

---

## 1. Layout

Left to right, dataflow order:

```
   CLK ──┬──────┬──────┬──────┐
   RST ──┼──────┼──────┼──────┤
         │      │      │      │
     stage_IF  stage_ID  stage_EX  stage_MEM  stage_WB
         │      │        │          │           │
         └──────┴────────┴──────────┴───────────┘
                    45 signal nets
```

`stage_WB` takes no clock and no reset -- it is purely combinational.

You will be drawing 45 nets, several with three or four destinations. Tunnels
are worth considering over routed wires: a tunnel connects by label, so there is
no routing to get wrong and the labels become a readable netlist. That is how
the scaffolded `main` in `debug_armv4t_2.circ` is built, if you want to look at
one first.

---

## 2. Before you start: settle the pin order

`stage_ID`'s ports have shifted four times -- `branch_imm24`, `instr_15_0`,
`bt_reg_idx` and `bt_active` all landed mid-list rather than below the existing
pins. That has cost nothing so far because `main` was empty and the checkers
derive indices.

**Once `main` is wired, that stops being free.** Subcircuit ports bind by
position, so a pin inserted above an existing one silently moves every wire
onto the wrong port, and every structural and semantic check still passes.

Drag the newer pins below the older ones now, re-run `check_stage_fit.py` to see
the resulting indices, and then treat every stage's pin list as append-only.

---

## 3. The two connections that are not name-matched

| destination | source | why |
|---|---|---|
| `stage_EX.rot` | **`stage_ID.rs`** | rotate is `instr[11:8]`; Rs is `instr[11:8]`. The same four bits, so one output serves both. |
| `stage_IF.wb_data` | **`stage_WB.wd`** | the same net that feeds `stage_ID.wd`. One net, two destinations -- not two outputs. |

Everything else connects output-to-input by identical name.

---

## 4. The net list

### Clock and reset

- `CLK` → `stage_IF.clk`, `stage_ID.clk`, `stage_EX.clk`, `stage_MEM.clk`
- `RST` → `stage_IF.rst`, `stage_ID.rst`, `stage_EX.rst`, `stage_MEM.rst`

`stage_WB` has neither.

### stage_IF outputs

| from | to |
|---|---|
| `instruction` | `stage_ID.instruction` |
| `pc_word_addr` | `stage_ID.pc_word_addr` |
| `pc_plus4` | `stage_WB.pc_plus4` |

### stage_ID outputs

| from | to |
|---|---|
| `rd_a` | `stage_EX.rd_a`, `stage_MEM.rd_a` |
| `rd_b` | `stage_EX.rd_b`, `stage_MEM.rd_b` |
| `class_bits` | `stage_EX.class_bits`, `stage_MEM.class_bits` |
| `opcode` | `stage_EX.opcode`, `stage_MEM.opcode` |
| `s_bit` | `stage_EX.s_bit`, `stage_MEM.s_bit` |
| `alu_ctrl` | `stage_EX.alu_ctrl` |
| `cond` | `stage_EX.cond` |
| `imm_bit` | `stage_EX.imm_bit` |
| `imm8` | `stage_EX.imm8` |
| `shift_amount` | `stage_EX.shift_amount` |
| `shift_type` | `stage_EX.shift_type` |
| `instr_27_4` | `stage_EX.instr_27_4` |
| `branch_imm24` | `stage_EX.branch_imm24` |
| **`rs`** | **`stage_EX.rot`** |
| `rn` | `stage_MEM.rn` |
| `instr_15_0` | `stage_MEM.instr_15_0` |
| `wa` | `stage_WB.wa` |

### stage_EX outputs

| from | to |
|---|---|
| `branch_offset` | `stage_IF.branch_offset` |
| `bx_target` | `stage_IF.bx_target` |
| `branch_taken` | `stage_IF.branch_taken`, `stage_WB.branch_taken` |
| `bx_taken` | `stage_IF.bx_taken`, `stage_WB.bx_taken`, **the `halt` pin** |
| `bl_taken` | `stage_ID.bl_taken`, `stage_WB.bl_taken` |
| `cond_pass` | `stage_MEM.cond_pass`, `stage_WB.cond_pass` |
| `alu_result` | `stage_WB.alu_result` |
| `alu_we` | `stage_WB.alu_we` |
| `cpsr` | observation pin only |

### stage_MEM outputs

| from | to |
|---|---|
| `hold_pc` | `stage_IF.hold_pc` |
| `bt_done` | `stage_IF.bt_done` |
| `wd2` | `stage_ID.wd2` |
| `we2` | `stage_ID.we2` |
| `wa2` | `stage_ID.wa2` |
| `bt_active` | `stage_ID.bt_active`, **`stage_WB.bt_active`** |
| `bt_reg_idx` | `stage_ID.bt_reg_idx` |
| `sbwe` | `stage_ID.sbwe`, `stage_WB.sbwe` |
| `data_ram_we` | `stage_ID.data_ram_we`, `stage_WB.data_ram_we` |
| `load_data` | `stage_WB.load_data` |
| `mem_read` | `stage_WB.mem_read` |
| `memory_up_base` | `stage_WB.memory_up_base` |
| `ldr_reg_we` | nothing -- superseded by `mem_read` in WB's `OR_WE` |

### stage_WB outputs

| from | to |
|---|---|
| `wd` | `stage_ID.wd` **and** `stage_IF.wb_data` |
| `we` | `stage_ID.we` |
| `wb_writes_pc` | `stage_IF.wb_writes_pc` |

---

## 5. Top-level pins

| pin | direction | width | driven by | why |
|---|---|---|---|---|
| `halt` | **output** | 1 | `stage_EX.bx_taken` | **required.** Every harness runs `--tty halt` and stops on a pin with this name. |
| `RST` | input | 1 | -- | leave unconnected; Logisim holds an unconnected input at 0, and the registers power up cleared |

Plus a Clock component driving `CLK`. No attributes needed -- the default
high/low duration is what every existing suite assumes.

Useful observation outputs, optional but cheap, and what the smoke suites read:

```
o_pc      10   stage_IF.pc_word_addr
o_instr   32   stage_IF.instruction
o_wd      32   stage_WB.wd
o_wa       4   stage_ID.wa
o_we       1   stage_WB.we
o_cpsr     4   stage_EX.cpsr
o_pass     1   stage_EX.cond_pass
```

> **Probe the WRITEBACK, not the ALU.** An earlier version of my smoke suite
> read `stage_EX.alu_result` and `stage_EX.alu_we`, which are the raw ALU
> outputs before WB's mux chain and enable tree. It was blind to the entire
> writeback path and reported "BL does not write r14" with a working WB sitting
> right there. `o_wd` and `o_we` must come from `stage_WB`.

---

## 6. Traps

1. **Zero gates.** `wd` fanning to two destinations is one net, not an OR.
2. **`stage_EX.rot` takes `stage_ID.rs`.** The only cross-named connection in
   the design.
3. **`stage_WB` has no clock or reset.** Do not wire them; there is nowhere for
   them to go.
4. **Settle the pin order first.** Section 2.
5. **`halt` must be spelled exactly that.** The harnesses also rename any pin
   labelled `is_BX` to `halt`; if you have both, you will get two.
6. **The RAM lives inside `stage_MEM`.** `--save` finds it there; nothing needs
   to be exposed at the top level for the RAM dump to work.

---

## 7. Verifying

```bash
python3 tests/check_stage.py armv4t_2.circ main
python3 tools/check_stage_fit.py armv4t_2.circ
python3 -m logisim validate armv4t_2.circ
```

`check_stage` on `main` should report clean: no floating inputs, no undriven
nets, no multiple drivers. A missed connection shows up as an undriven net named
after the pin it feeds.

Then the whole thing becomes testable on the project's own terms:

```bash
python3 tests/push_suite.py armv4t_2.circ
python3 tests/pop_suite.py armv4t_2.circ
python3 tests/isa_coverage.py armv4t_2.circ
python3 tests/adversarial_regression.py armv4t_2.circ
```

**The number to beat is 43/54**, `debug_armv4t.circ`'s measured score. Parity
means the rebuild reproduces the master exactly; the 11 remaining failures are
missing ARM features, not wiring, and they are the same 11 in both circuits.

If a case fails in the rebuild that passes in the master, that is a wiring
difference and worth chasing before anything else. `tools/cross_check.py` and
the two smoke suites narrow it down quickly.
