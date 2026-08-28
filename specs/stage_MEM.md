# stage_MEM — electrical spec

Derived from `debug_armv4t.circ` by tracing the live netlist, not from memory.
Every signal name below is the probe label the master already uses, so you can
cross-reference either direction.

Build it in five groups. Verify each before starting the next — that is what
made IF, ID and EX go cleanly, and MEM is bigger than any of them.

---

## 0. What MEM owns, and what it does not

**MEM owns:** the load/store class decode, the address computation, the RAM,
the literal-pool ROM and the `addr[12]` decode between them, the base-register
writeback (second write port), and the whole block-transfer engine.

**MEM does not own** the writeback-data mux (`load_data` vs `alu_result` vs the
BL link value) or the final register write enable. Those are WB's. MEM hands WB
the load data and the flags it needs to choose.

Two facts that shape everything:

- **The address adder is not the ALU.** The master computes `base + offset`
  with a dedicated 32-bit adder inside the memory path. Do not try to route it
  through EX.
- **Subtraction is done by inverting, not by a subtractor.** `U=0` means
  "subtract", and the master implements it as `offset XOR sign_extend(NOT U)`
  with `NOT U` also driving the adder's carry-in — the standard two's-complement
  trick. Both halves are required; one without the other is off by one.

---

## 1. Prerequisites — do these first

### 1a. `block_transfer_control` is the old version

Yours has six inputs: `clk, rst, start, is_pop, reg_list_in, base_value`.
The working one in `debug_armv4t.circ` has **eight** — it also takes `U` and `P`.
Group E cannot be wired without them.

Bring it up to the debug version: add input pins `U` (1 bit) and `P` (1 bit),
**placed below every existing pin in that circuit** so they land last in port
order and no existing instance port shifts, plus one NOT gate. Inside the debug
version, `U` feeds an AND input, a multiplexer select and a NOT gate; `P` feeds
only a NOT gate.

### 1b. `stage_ID` needs one new output

MEM needs `instruction[15:0]`:

- bits **11:0** are the LDR/STR offset,
- bits **15:0** are the LDM/STM register list.

One 16-bit output covers both.

| new `stage_ID` output | width | source |
|---|---|---|
| `instr_15_0` | 16 | `instruction[15:0]` |

Same method as `branch_imm24`: a splitter on the `instruction` net (the one
carrying the `S_BX` / `S_imm` / `S_main` probes), Bit Width In 32, Fan Out 2,
**Bit 0 … Bit 15 → 0**, **Bit 16 … Bit 31 → 1**, fan 0 to the new pin.
Everything you already know about that applies: Appearance Right, Facing East,
Spacing 4, and place the pin **below every existing pin**.

### 1c. `stage_ID` needs two new inputs — but only for Group E

During a block transfer the register file is addressed by the transfer engine,
not by the instruction fields. Two outer muxes are needed:

```
WA = bt_active ? bt_reg_idx : (sbwe ? Rn : (bl_taken ? R14 : Rd))
RB = bt_active ? bt_reg_idx : (data_ram_we ? Rd : Rm)
```

so `stage_ID` gains inputs `bt_active` (1) and `bt_reg_idx` (4). Leave this
until Group E; groups A–D work without it.

---

## 2. Interface

Widths are load-bearing. Names must match exactly — `tools/check_stage_fit.py`
resolves the seams by name.

### Inputs

| name | width | from | meaning |
|---|---|---|---|
| `clk` | 1 | — | |
| `rst` | 1 | — | |
| `rd_a` | 32 | `stage_ID.rd_a` | base register value (Rn) |
| `rd_b` | 32 | `stage_ID.rd_b` | store data (ID already steers this to Rd when `data_ram_we`) |
| `class_bits` | 3 | `stage_ID.class_bits` | `instr[27:25]`; bit0 = instr[25] |
| `opcode` | 4 | `stage_ID.opcode` | `instr[24:21]` = **P, U, B, W** — bit3=P, bit2=U, bit1=B, bit0=W |
| `s_bit` | 1 | `stage_ID.s_bit` | `instr[20]` = **L** for load/store |
| `rn` | 4 | `stage_ID.rn` | `instr[19:16]` — the base register index |
| `instr_15_0` | 16 | `stage_ID.instr_15_0` | offset (low 12) and register list (all 16) |
| `cond_pass` | 1 | `stage_EX.cond_pass` | |

### Outputs

| name | width | to | meaning |
|---|---|---|---|
| `load_data` | 32 | WB | RAM or literal-pool word |
| `mem_read` | 1 | WB | select `load_data` as writeback data |
| `ldr_reg_we` | 1 | WB | a load wants to write its destination register |
| `memory_up_base` | 32 | WB | base + effective offset — the writeback value for STR with writeback |
| `data_ram_we` | 1 | `stage_ID.data_ram_we` | |
| `sbwe` | 1 | `stage_ID.sbwe` | store-with-base-writeback |
| `wa2` | 4 | `stage_ID.wa2` | |
| `wd2` | 32 | `stage_ID.wd2` | |
| `we2` | 1 | `stage_ID.we2` | |
| `hold_pc` | 1 | `stage_IF.hold_pc` | |
| `bt_done` | 1 | `stage_IF.bt_done` | |
| `bt_active` | 4→1 | `stage_ID.bt_active` | 1 bit |
| `bt_reg_idx` | 4 | `stage_ID.bt_reg_idx` | |

Pin **positions** do not matter and neither does the order I listed them in —
port index is derived, and `check_stage_fit.py` prints what each one landed on.
What matters: the names, the widths, and the rule that once `main` is wired you
never insert a pin above an existing one.

---

## 3. Group A — class decode and control

Pure combinational logic off `class_bits`, `opcode`, `s_bit` and `cond_pass`.

```
mem_class              = class_bits[1] AND NOT class_bits[2]      (instr[27:26] = 01)
is_LDR                 = mem_class AND s_bit
is_STR                 = mem_class AND NOT s_bit
wb_requested           = opcode[0] OR NOT opcode[3]               (W OR NOT P)
data_ram_we            = cond_pass AND is_STR
ldr_reg_we             = cond_pass AND is_LDR
sbwe                   = cond_pass AND is_STR AND wb_requested
load_base_write_enable = cond_pass AND is_LDR AND wb_requested
```

**Components**

| label | type | attributes |
|---|---|---|
| `S_MEMCLASS` | Splitter | Bit Width In 3, Fan Out 3, one bit per fan |
| `NOT_C27` | NOT Gate | |
| `AND_MEMCLASS` | AND Gate | 2 inputs |
| `NOT_L` | NOT Gate | |
| `AND_ISLDR` | AND Gate | 2 inputs |
| `AND_ISSTR` | AND Gate | 2 inputs |
| `S_PUBW` | Splitter | Bit Width In 4, Fan Out 4, one bit per fan |
| `NOT_P` | NOT Gate | |
| `OR_WBREQ` | OR Gate | 2 inputs |
| `AND_DATARAMWE` | AND Gate | 2 inputs |
| `AND_LDRREGWE` | AND Gate | 2 inputs |
| `AND_SBWE` | AND Gate | **3 inputs** |
| `AND_LDBASEWE` | AND Gate | **3 inputs** |

**Connections**

- `class_bits` → `S_MEMCLASS.combined`
- `S_MEMCLASS` fan 1 → `AND_MEMCLASS.in0`; fan 2 → `NOT_C27.in`; `NOT_C27.out` → `AND_MEMCLASS.in1`
- `AND_MEMCLASS.out` = **mem_class** → `AND_ISLDR.in0`, `AND_ISSTR.in0`
- `s_bit` → `AND_ISLDR.in1` and `NOT_L.in`; `NOT_L.out` → `AND_ISSTR.in1`
- `opcode` → `S_PUBW.combined`; fan 0 = W, fan 3 = P
- `S_PUBW` fan 3 → `NOT_P.in`; `NOT_P.out` → `OR_WBREQ.in1`; `S_PUBW` fan 0 → `OR_WBREQ.in0`
- `cond_pass` → `AND_DATARAMWE.in0`, `AND_LDRREGWE.in0`, `AND_SBWE.in0`, `AND_LDBASEWE.in0`
- `AND_ISSTR.out` → `AND_DATARAMWE.in1`, `AND_SBWE.in1`
- `AND_ISLDR.out` → `AND_LDRREGWE.in1`, `AND_LDBASEWE.in1`
- `OR_WBREQ.out` → `AND_SBWE.in2`, `AND_LDBASEWE.in2`
- `AND_DATARAMWE.out` → output pin `data_ram_we`
- `AND_LDRREGWE.out` → output pin `ldr_reg_we`
- `AND_SBWE.out` → output pin `sbwe`

---

## 4. Group B — address computation

```
mem_offset             = zero_extend32(instr_15_0[11:0])
memory_offset_effective = mem_offset XOR sign_extend32(NOT U)
memory_up_base         = rd_a + memory_offset_effective + (NOT U)
memory_address_pre     = P ? memory_up_base : rd_a
```

**Components**

| label | type | attributes |
|---|---|---|
| `S_OFF12` | Splitter | Bit Width In 16, Fan Out 2, **Bit 0…Bit 11 → 0**, **Bit 12…Bit 15 → 1** |
| `EXT_OFF` | Bit Extender | In 12, Out 32, **Extension Type = Zero** |
| `NOT_U` | NOT Gate | |
| `EXT_UMASK` | Bit Extender | In 1, Out 32, **Extension Type = Sign** |
| `XOR_OFF` | XOR Gate | Data Bits 32 |
| `ADD_ADDR` | Adder | Data Bits 32 |
| `M_PREPOST` | Multiplexer | Data Bits 32, Select Bits 1 |

**Connections**

- `instr_15_0` → `S_OFF12.combined`; fan 0 (12 bits) → `EXT_OFF.in`; fan 1 unconnected
- `EXT_OFF.out` = **mem_offset** → `XOR_OFF.in0`
- `S_PUBW` fan 2 (U) → `NOT_U.in`
- `NOT_U.out` → `EXT_UMASK.in` **and** `ADD_ADDR.cin`
- `EXT_UMASK.out` → `XOR_OFF.in1`
- `XOR_OFF.out` = **memory_offset_effective** → `ADD_ADDR.b`
- `rd_a` → `ADD_ADDR.a` and `M_PREPOST.in0`
- `ADD_ADDR.out` = **memory_up_base** → `M_PREPOST.in1`, output pin `memory_up_base`
- `S_PUBW` fan 3 (P) → `M_PREPOST.sel`
- `ADD_ADDR.cout` — leave unconnected

> **`EXT_UMASK` must be SIGN, and this is the one place where Logisim's
> dangerous default is the right answer.** Sign-extending one bit gives
> `0x00000000` or `0xFFFFFFFF`, which is exactly the XOR mask wanted. If someone
> later "fixes" it to Zero, every subtracting load and store silently becomes an
> add. `EXT_OFF`, by contrast, must say **Zero** explicitly.

---

## 5. Group C — the memories

```
memory_address  = bt_active ? bt_transfer_address : memory_address_pre   (Group E)
is_program_addr = NOT memory_address[12]
load_data       = is_program_addr ? litpool_rom_data : ram_data_out
```

For groups A–D, drive `memory_address` straight from `M_PREPOST.out`; the
block-transfer mux goes in front of it in Group E.

**Components**

| label | type | attributes |
|---|---|---|
| `S_ADDR_RAM` | Splitter | Bit Width In 32, Fan Out 3 — **Bit 0,1 → 0; Bit 2…Bit 9 → 1; Bit 10…Bit 31 → 2** |
| `S_ADDR_ROM` | Splitter | Bit Width In 32, Fan Out 4 — **Bit 0,1 → 0; Bit 2…Bit 11 → 1; Bit 12 → 2; Bit 13…Bit 31 → 3** |
| `NOT_PROGADDR` | NOT Gate | |
| `DATA_RAM` | RAM | Data Bit Width **32**, Address Bit Width **8** (the default), **Trigger = Falling Edge**, Appearance `logisim_evolution` |
| `K_RAM_OE` | Constant | Data Bits 1, **Value 1** |
| `LITPOOL_ROM` | ROM | Address Bit Width **10**, Data Bit Width **32** |
| `OR_RAMWE` | OR Gate | 2 inputs |
| `M_LOADDATA` | Multiplexer | Data Bits 32, Select Bits 1 |

**Connections**

- `M_PREPOST.out` → `S_ADDR_RAM.combined` and `S_ADDR_ROM.combined` (and the
  output pin `memory_address` if you add one for observability)
- `S_ADDR_RAM` fan 1 (8 bits = address[9:2]) → `DATA_RAM.addr`
- `S_ADDR_ROM` fan 1 (10 bits = address[11:2]) → `LITPOOL_ROM.addr`
- `S_ADDR_ROM` fan 2 (address[12]) → `NOT_PROGADDR.in`
- `NOT_PROGADDR.out` = **is_program_addr** → `M_LOADDATA.sel`
- `DATA_RAM.data_out` → `M_LOADDATA.in0`
- `LITPOOL_ROM.data_out` → `M_LOADDATA.in1`
- `M_LOADDATA.out` → output pin `load_data`
- `rd_b` → `DATA_RAM.data_in`
- `clk` → `DATA_RAM.clk`
- `K_RAM_OE.out` → `DATA_RAM.oe`
- `AND_DATARAMWE.out` → `OR_RAMWE.in0`; `OR_RAMWE.out` → `DATA_RAM.we`
  (`OR_RAMWE.in1` comes from block transfer in Group E; until then tie it to 0
  with an explicit **Value 0** constant, and remember to remove that tie)
- `is_LDR` (`AND_ISLDR.out`) → output pin `mem_read` for now; Group E widens it

> **The RAM is a HALF-CYCLE memory, and this is the single most important thing
> on this page.** Leave `asyncread` alone (absent) and set `trigger` to
> **Falling Edge**. Logisim's `asyncread` defaults to FALSE, so the read is
> SYNCHRONOUS, latched on that same falling edge:
>
> ```
>   rising edge   PC advances, instruction fetched, address computed combinationally
>   falling edge  RAM latches the read AND commits any write
>   rising edge   register file writes the loaded word
> ```
>
> The address gets the first half of the cycle to settle; the loaded word gets
> the second half to reach the register file. Do NOT "fix" this by turning on
> Asynchronous read: it was tried twice in this project (`d32765d` 2026-08-13
> and `593a2cb` 2026-08-17) and backed out both times. A falling-edge memory
> also maps onto FPGA block RAM, which has no asynchronous read path at all;
> an async read would force distributed LUT RAM instead.

> **The literal pool must be a ROM, not a RAM.** `CONTENTS_ATTR` exists only on
> `Rom.java`; RAM contents are runtime state and are never written to the file,
> so a RAM cannot be preloaded and every harness here would read zeros from it.

> **`LITPOOL_ROM` must hold the same image as the instruction ROM in `stage_IF`.**
> Every harness in this repo writes the program into *every* 32-bit ROM in the
> design for exactly this reason, so you do not have to keep them in step by
> hand — but if you change one ROM's address width, change both.

> **Memory map:** ROM occupies `0x0000-0x0FFF`, RAM is based at `0x1000`, and
> loads pick between them on `address[12]`. The RAM's 8-bit address means it
> aliases every 1 KB above `0x1000`; that matches the master.

---

## 6. Group D — base-register writeback (second write port)

```
we2 = base_writeback_en OR load_base_write_enable
wd2 = bt_done ? bt_final_address : memory_up_base
wa2 = rn
```

`base_writeback_en = bt_done AND W` is block transfer's; wire it in Group E.
Until then, `we2 = load_base_write_enable` alone.

**Components**

| label | type | attributes |
|---|---|---|
| `OR_WE2` | OR Gate | 2 inputs |
| `M_WD2` | Multiplexer | Data Bits 32, Select Bits 1 |

**Connections**

- `AND_LDBASEWE.out` → `OR_WE2.in1`; `OR_WE2.out` → output pin `we2`
- `ADD_ADDR.out` (memory_up_base) → `M_WD2.in0`; `M_WD2.out` → output pin `wd2`
- `rn` → output pin `wa2` directly
- `M_WD2.in1` and `M_WD2.sel` come from Group E; until then tie `sel` to an
  explicit **Value 0** constant

> Note the asymmetry, and it is correct: a **store** with writeback uses the
> PRIMARY port (`sbwe` steers ID's WA to Rn), while a **load** with writeback
> uses the SECOND port — because the primary port is already carrying the
> loaded value to Rd. Getting this backwards makes `ldr r0,[r1],#4` write the
> address into r0.

---

## 7. Group E — block transfer

```
block_transfer       = (class_bits == 0b100)
block_transfer_valid = block_transfer AND cond_pass
is_pop               = block_transfer_valid AND L
is_push              = block_transfer_valid AND NOT L
start                = is_pop OR is_push
base_writeback_en    = bt_done AND W
memory_address       = bt_active ? bt_transfer_address : memory_address_pre
ram_we               = data_ram_we OR bt_store_enable
mem_read             = is_LDR OR bt_load_enable
```

**Components**

| label | type | attributes |
|---|---|---|
| `BTC` | `block_transfer_control` | the upgraded 8-input version from §1a |
| `K_BLOCKCLASS` | Constant | Data Bits **3**, **Value 4** |
| `CMP_BLOCK` | Comparator | Data Bits 3 |
| `AND_BTVALID` | AND Gate | 2 inputs |
| `AND_ISPOP` | AND Gate | 2 inputs |
| `AND_ISPUSH` | AND Gate | 2 inputs |
| `OR_START` | OR Gate | 2 inputs |
| `AND_BASEWBEN` | AND Gate | 2 inputs |
| `M_ADDR` | Multiplexer | Data Bits 32, Select Bits 1 |
| `OR_MEMREAD` | OR Gate | 2 inputs |

**Connections**

- `class_bits` → `CMP_BLOCK.a`; `K_BLOCKCLASS.out` → `CMP_BLOCK.b`
- `CMP_BLOCK.eq` AND `cond_pass` → `AND_BTVALID`
- `AND_BTVALID.out` → `AND_ISPOP.in0`, `AND_ISPUSH.in0`
- `s_bit` (L) → `AND_ISPOP.in1`; `NOT_L.out` → `AND_ISPUSH.in1`
- `AND_ISPOP.out` → `OR_START.in0` **and** `BTC.is_pop`
- `AND_ISPUSH.out` → `OR_START.in1`
- `OR_START.out` → `BTC.start`
- `instr_15_0` → `BTC.reg_list_in` (all 16 bits, straight through)
- `rd_a` → `BTC.base_value`
- `S_PUBW` fan 2 (U) → `BTC.U`; fan 3 (P) → `BTC.P`
- `clk` → `BTC.clk`; `rst` → `BTC.rst`
- `BTC.hold_pc` → output pin `hold_pc`
- `BTC.done` → output pin `bt_done`, `M_WD2.sel`, `AND_BASEWBEN.in0`
- `BTC.active` → output pin `bt_active` and `M_ADDR.sel`
- `BTC.reg_idx` → output pin `bt_reg_idx`
- `BTC.transfer_address` → `M_ADDR.in1`; `M_PREPOST.out` → `M_ADDR.in0`
- `M_ADDR.out` → `S_ADDR_RAM.combined`, `S_ADDR_ROM.combined` (**move these off
  `M_PREPOST.out`; delete the Group C tie**)
- `BTC.final_address` → `M_WD2.in1`
- `BTC.store_enable` → `OR_RAMWE.in1` (**delete the Group C zero tie**)
- `BTC.load_enable` → `OR_MEMREAD.in1`; `AND_ISLDR.out` → `OR_MEMREAD.in0`;
  `OR_MEMREAD.out` → output pin `mem_read`
- `S_PUBW` fan 0 (W) → `AND_BASEWBEN.in1`; `AND_BASEWBEN.out` → `OR_WE2.in0`
- `BTC.reg_selected` and `BTC.phase_reg_q` — leave unconnected (debug only)

Then in `stage_ID`, add the two outer muxes from §1c.

---

## 8. Traps specific to this stage

1. **`EXT_UMASK` is the one Bit Extender that must stay on the SIGN default.**
   Everything else in this project wants Zero. See Group B.
2. **The RAM is a half-cycle memory: SYNCHRONOUS read latched on the
   falling edge, while every register is rising-edge.** `asyncread` stays
   absent (its default is false). Not a mistake, and not async.
3. **`K_RAM_OE` wants Value 1.** In the master it is an attribute-less Constant,
   which works only because Logisim's default is 1. Write the 1 explicitly —
   `tools/check_defaults.py` will flag it as REVIEW either way, and an explicit
   value means the next reader does not have to know the trap.
4. **`ADD_ADDR.cin` must come from `NOT_U`, not a constant.** This is the same
   adder-carry-in slot that has already produced two bugs in this project, but
   here it is genuinely a signal.
5. **Store-with-writeback uses the primary port; load-with-writeback uses the
   second.** See Group D.
6. **`instr_15_0` goes to `BTC.reg_list_in` whole.** The register list is
   `instr[15:0]` with bit *n* meaning register *n*; no reordering.

## 8a. A P0 defect this spec deliberately reproduces - decide before wiring

`ARM_STATE_AUDIT.md` lists as **P0**: *"Shifted register-offset memory fails --
`[base,index,LSL #2]` reads zero while the word exists"*. Ordinary C array
indexing compiles to exactly that form.

Group B as written reproduces it, because it takes the offset only from
`instr[11:0]` zero-extended. In ARM, `instr[25]` selects: **0 = 12-bit
immediate, 1 = shifted register**. Note the polarity is the OPPOSITE of
data-processing, where `I=1` means immediate.

Fixing it is not a MEM-local change, and there is a hard reason:

- a register-offset **load** needs two register reads - `Rn` (base) and `Rm`
  (offset) - which the file can do;
- a register-offset **store** needs *three* - `Rn`, `Rm`, and `Rd` for the
  data - and `reg16x32_1` has only **two read ports**.

So register-offset stores need either a third read port or a second cycle.
Loads alone could be fixed by routing a shifted `Rm` into the offset mux, but
`stage_EX`'s shifter input mux is selected by `imm_bit` with data-processing
polarity, so that needs an EX change too.

**Recommendation: build Group B as specced, and treat scaled register offsets
as a named follow-up touching EX, MEM and possibly the register file together.**
It is a real gap, it is already on the audit, and it is not something to
discover halfway through Group C.


## 9. Known gap, inherited from the master — do not reproduce it blind

In `debug_armv4t.circ` the register-file write-enable multiplexer has a
**floating select**, so `block_transfer_control.load_enable` never reaches the
write enable through it. LDM nevertheless writes registers, which means it is
getting its enable from the normal ALU write-enable path — that is, from
whatever the ALU control ROM happens to emit for the `instr[24:21]` field of an
LDM encoding. That is accidental, not designed.

I have not resolved it, and I am not going to guess. When you build WB, this is
the first thing to pin down, and the discriminator is an LDM whose `instr[24:21]`
field would map to an ALU opcode with write-enable **clear**.

`HANDOFF.md` already carries the execution trace for this, reached
independently from the other direction: with a non-SP base, `ldmia r4,{r0}`
recognises the instruction and asserts `load_enable`, then **`ldr_reg_we` stays
0 for the whole run while the scan never terminates**. POP still works, so the
working path is SP-specific somewhere not yet found. Two descriptions, one bug.

---

## 10. Verifying as you go

```bash
python3 tests/check_stage.py armv4t_2.circ stage_MEM     # structural
python3 tools/check_stage_fit.py armv4t_2.circ           # the seams, by name
python3 tools/check_defaults.py armv4t_2.circ stage_MEM  # Logisim's traps
```

`check_stage_fit.py` already carries MEM's contract, so it will tell you exactly
which ports are missing or the wrong width from the moment the circuit exists.

Once Group C is in, the Python simulator can execute real loads and stores
against the live design:

```bash
python3 tools/smoke_suite.py --engine=python
python3 tools/pysim.py prog.S
```

`tools/pysim.py` wires `stage_MEM` automatically when it finds it, and ties the
same signals off when it does not — so nothing needs editing to start testing.
