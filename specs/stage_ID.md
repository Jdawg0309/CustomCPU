# stage_ID — decode and register read

Second block. Everything here was read out of `debug_armv4t.circ` with
`logisim.graph`, not reconstructed from memory — every net, splitter bit map and
constant below is what the working circuit actually does today.

## The line I drew

**ID owns the instruction fields, the register file, and every register
*index*. It does not own any register *data* or *write-enable*** — those arrive
from WB as inputs.

That split is what keeps ID from swallowing the whole CPU. Three consequences:

- The `bl_taken` / `sbwe` / `data_ram_we` mux chain that picks *which* register
  is read or written stays here, because it is decode output.
- `wd`, `we`, `wd2`, `we2` come in as ports. ID never computes them.
- `condition_checker` is **not** here. It consumes NZCV, which EX produces.

The r15-as-operand fix lives in this stage. It is one of the four fixes that
must survive the reorganization, so it is specified in full in group C.

---

## Subcircuits to copy from `armv4t.circ`

Only one, and it is already in `armv4t_2.circ`:

- **`reg16x32_1`** — the 16×32 register file. Note the trailing `_1`. Plain
  `reg16x32` is the older dead copy; it is on the delete list.

---

## Ports

Pin order on a subcircuit instance is positional, sorted by `(y, x)`. Use these
y-values so the order is fixed now and nothing shifts when we wire `main`.
Inputs sit at `x=100`, outputs at `x=2400`.

### Inputs

| y | label | width | from |
|---|---|---|---|
| 100 | `clk` | 1 | main clock |
| 140 | `rst` | 1 | reset |
| 180 | `instruction` | 32 | **IF** |
| 220 | `pc_word_addr` | 10 | **IF** |
| 260 | `bl_taken` | 1 | EX — force write address to r14 |
| 300 | `sbwe` | 1 | MEM — base writeback, force write address to Rn |
| 340 | `data_ram_we` | 1 | MEM — store, read Rd on port B instead of Rm |
| 380 | `wd` | 32 | **WB** — write data |
| 420 | `we` | 1 | **WB** — write enable |
| 460 | `wd2` | 32 | MEM — second write port (block transfer) |
| 500 | `we2` | 1 | MEM |
| 540 | `wa2` | 4 | MEM — second write address |

### Outputs

| y | label | width | to |
|---|---|---|---|
| 1000 | `rd_a` | 32 | EX — operand A, PC+8 substituted |
| 1040 | `rd_b` | 32 | EX — operand B, PC+8 substituted; also the BX target |
| 1080 | `pc_plus8` | 32 | EX |
| 1120 | `rn` | 4 | MEM, WB |
| 1160 | `rm` | 4 | EX |
| 1200 | `rd` | 4 | MEM, WB |
| 1240 | `rs` | 4 | EX — register-specified shift amount |
| 1280 | `opcode` | 4 | EX |
| 1320 | `cond` | 4 | EX |
| 1360 | `class_bits` | 3 | EX, MEM — `instr[27:25]` |
| 1400 | `imm_bit` | 1 | EX — `instr[25]` |
| 1440 | `imm8` | 8 | EX — `instr[7:0]` |
| 1480 | `shift_type` | 2 | EX |
| 1520 | `shift_amount` | 5 | EX |
| 1560 | `reg_shift` | 1 | EX — `instr[4]`, shift amount comes from Rs |
| 1600 | `s_bit` | 1 | EX — `instr[20]` |
| 1640 | `instr_27_4` | 24 | EX — the BX comparison |
| 1680 | `alu_ctrl` | 10 | EX |
| 1720 | `wa` | 4 | WB — the `Rd==15` test |

---

## Group A — instruction field extraction

Five splitters. **Set `incoming`, `fanout`, `facing` and `appear` before
touching the bit map**, because changing `fanout` resets every `bitN`.

Fan numbering is a screen convention, not something `appear` controls: facing
east, **fan 0 is the topmost fan and the indices run downward**.

### A1 `S_MAIN` — the master field splitter
`incoming=32  fanout=7  facing=east  appear=right`

| fan | bits | carries |
|---|---|---|
| 0 | 3:0 | `rm` |
| 1 | 11:4 | `shift_field` (to A4) |
| 2 | 15:12 | `rd` |
| 3 | 19:16 | `rn` |
| 4 | 20 | `s_bit` |
| 5 | 24:21 | `opcode` |
| 6 | 31:25 | `instr_31_25` (to A2) |

### A2 `S_HI` — condition and class
`incoming=7  fanout=2  facing=east  appear=right`
fan0 = bits 2:0 → `class_bits` (`instr[27:25]`) · fan1 = bits 6:3 → `cond`

### A3 `S_IMM` — immediate and shift register
`incoming=32  fanout=3  facing=east  appear=right`
fan0 = bits 7:0 → `imm8` · fan1 = bits 11:8 → `rs` · fan2 = bit 25 → `imm_bit`

**Every other bit must be set to `none`** — bits 12–24 and 26–31. A bit left on
a fan it does not belong to silently widens that fan.

### A4 `S_SHIFT` — shift operand decode
`incoming=8  fanout=3  facing=east  appear=right`
fan0 = bit 0 → `reg_shift` · fan1 = bits 2:1 → `shift_type` · fan2 = bits 7:3 → `shift_amount`

Input is `shift_field` from `S_MAIN` fan 1, so its bit 0 is `instr[4]`.

### A5 `S_BX` — the BX comparison field
`incoming=32  fanout=3  facing=east  appear=right`
fan0 = bits 3:0 · fan1 = bits 27:4 → `instr_27_4` · fan2 = bits 31:28

Only fan 1 is used; the other two exist so the bit map stays contiguous.

**Connections**

```
instruction (pin)        -> S_MAIN.combined, S_IMM.combined, S_BX.combined
S_MAIN.fan6              -> S_HI.combined            [instr_31_25]
S_MAIN.fan1              -> S_SHIFT.combined         [shift_field]
S_MAIN.fan0              -> rm (pin), M_RB.in0
S_MAIN.fan2              -> rd (pin), M_WA_BL.in0, M_RB.in1
S_MAIN.fan3              -> rn (pin), regfile.RA, CMP_RN.a
S_MAIN.fan4              -> s_bit (pin)
S_MAIN.fan5              -> opcode (pin), S_ROMADDR.fan0
S_HI.fan0                -> class_bits (pin)
S_HI.fan1                -> cond (pin)
S_IMM.fan0               -> imm8 (pin)
S_IMM.fan1               -> rs (pin)
S_IMM.fan2               -> imm_bit (pin)
S_SHIFT.fan0             -> reg_shift (pin)
S_SHIFT.fan1             -> shift_type (pin)
S_SHIFT.fan2             -> shift_amount (pin)
S_BX.fan1                -> instr_27_4 (pin)
```

---

## Group B — register file and index selection

Three 4-bit muxes pick the indices. The order matters: BL first, then base
writeback, because a `BL` and a base writeback never co-occur but the second
must win if they ever did.

| part | attrs | purpose |
|---|---|---|
| `K_LR` | Constant, width 4, value `0xe` | r14, the link register |
| `M_WA_BL` | Multiplexer, width 4, 2 inputs | `bl_taken ? r14 : Rd` |
| `M_WA_SB` | Multiplexer, width 4, 2 inputs | `sbwe ? Rn : (above)` |
| `M_RB` | Multiplexer, width 4, 2 inputs | `data_ram_we ? Rd : Rm` |
| `regfile` | `reg16x32_1` instance | |

```
K_LR.out                 -> M_WA_BL.in1
S_MAIN.fan2 (rd)         -> M_WA_BL.in0
bl_taken (pin)           -> M_WA_BL.sel
M_WA_BL.out              -> M_WA_SB.in0
S_MAIN.fan3 (rn)         -> M_WA_SB.in1
sbwe (pin)               -> M_WA_SB.sel
M_WA_SB.out              -> regfile.WA, wa (pin)

S_MAIN.fan0 (rm)         -> M_RB.in0
S_MAIN.fan2 (rd)         -> M_RB.in1
data_ram_we (pin)        -> M_RB.sel
M_RB.out                 -> regfile.RB, CMP_RM.a

S_MAIN.fan3 (rn)         -> regfile.RA
clk (pin)                -> regfile.CLK
rst (pin)                -> regfile.RST
wd  (pin)                -> regfile.WD
we  (pin)                -> regfile.WE
wd2 (pin)                -> regfile.WD2
we2 (pin)                -> regfile.WE2
wa2 (pin)                -> regfile.WA2
```

`regfile`'s sixteen `R0_OUTPUT … R15_OUTPUT` ports stay unconnected. They are
the debug inspection taps; leaving them open is correct and the checker will
not flag them.

---

## Group C — r15 reads as PC+8

This is the fix. ARM specifies that reading r15 as an operand yields the
address of the current instruction **plus 8**, not the PC itself. Without it,
`ADD Rd, PC, #imm` and every PC-relative form computes against the wrong base.

The chain converts IF's word address into a byte address and adds 8, then
substitutes it on either read port whenever that port selected r15.

| part | attrs |
|---|---|
| `EXT` | Bit Extender, in 10, out 32, type zero |
| `SHL2` | Shifter, width 32, shift type `ll` (logical left) |
| `K_2` | Constant, width 5, value `2` |
| `ADD8` | Adder, width 32 |
| `K_8` | Constant, width 32, value `8` |
| `K_0` | Constant, width 1, value `0` |
| `K_15` | Constant, width 4, value `0xf` |
| `CMP_RN` | Comparator, width 4 |
| `CMP_RM` | Comparator, width 4 |
| `M_RDA` | Multiplexer, width 32, 2 inputs |
| `M_RDB` | Multiplexer, width 32, 2 inputs |

```
pc_word_addr (pin)       -> EXT.in
EXT.out                  -> SHL2.in
K_2.out                  -> SHL2.dist          [word addr -> byte addr]
SHL2.out                 -> ADD8.a
K_8.out                  -> ADD8.b
K_0.out                  -> ADD8.cin
ADD8.out                 -> M_RDA.in1, M_RDB.in1, pc_plus8 (pin)

S_MAIN.fan3 (rn)         -> CMP_RN.a
M_RB.out                 -> CMP_RM.a
K_15.out                 -> CMP_RN.b, CMP_RM.b
CMP_RN.eq                -> M_RDA.sel
CMP_RM.eq                -> M_RDB.sel

regfile.RD_A             -> M_RDA.in0
regfile.RD_B             -> M_RDB.in0
M_RDA.out                -> rd_a (pin)
M_RDB.out                -> rd_b (pin)
```

Only `eq` is used on both comparators. `gt` and `lt` stay open.

**`CMP_RM.a` takes `M_RB.out`, not `rm` directly.** On a store the B port reads
Rd, so the r15 test has to follow whatever the mux selected — testing `rm`
would miss `STR r15, [...]`.

---

## Group D — ALU control decode ROM

| part | attrs |
|---|---|
| `S_ROMADDR` | Splitter, `incoming=16 fanout=3 facing=west appear=left`; fan0 = bits 3:0, fan1 = bit 4, fan2 = bits 15:5 |
| `K_ROM_B4` | Constant, width 1, value `0` |
| `K_ROM_HI` | Constant, width 11, value `0` |
| `CTRL_ROM` | ROM, `addrWidth=16 dataWidth=10` |

```
S_MAIN.fan5 (opcode)     -> S_ROMADDR.fan0
K_ROM_B4.out             -> S_ROMADDR.fan1
K_ROM_HI.out             -> S_ROMADDR.fan2
S_ROMADDR.combined       -> CTRL_ROM.addr
CTRL_ROM.data_out        -> alu_ctrl (pin)
```

ROM contents, verbatim — 17 words, addresses 0x00–0x10:

```
addr/data: 16 10
1 3 151 191 101 121 161 1a1
0 2 150 100 5 7 9 b
201
```

Two things worth knowing before you wire it.

**The address is just the opcode, zero-extended.** Fans 1 and 2 are tied to
constants, so only entries 0–15 are reachable and the 17th word (`201`) is dead
today. Keep the splitter and both constants anyway: bit 4 is the natural place
to hang the bits-7/4 decode fix, which is the change that unlocks eight of the
nine remaining ISA failures. Wiring it flat as a 4-bit address now means
rebuilding it later.

**`alu_ctrl` leaves as one 10-bit bus.** The working circuit splits it into
`alu_a_inv`, `alu_b_inv`, `alu_logic_sel`, `alu_cin_sel`, `alu_engine_sel` and
`alu_write_enable` — but every one of those is consumed in EX, so the splitter
belongs in EX, not here. Ten wires across the stage boundary instead of one is
exactly the thing this reorganization exists to stop.

---

## When you are done

```bash
python3 tests/check_stage.py armv4t_2.circ stage_ID
```

Clean means: no floating inputs, no undriven nets, no multiple drivers, no dead
components, 100% endpoint coverage. Then tell me and I will diff it against
`debug_armv4t.circ` connection by connection.
