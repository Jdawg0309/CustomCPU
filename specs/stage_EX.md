# stage_EX — execute

Third block, and the largest. Every net, splitter map, constant and gate
polarity below was read out of `debug_armv4t.circ` with `logisim.graph`. Nothing
here is reconstructed from memory.

## The line I drew

**EX owns everything that computes a value or a decision from decoded fields.**
Four things it does not own:

- the register file and the fields themselves — ID
- memory access and block transfer — MEM
- choosing what gets written back — WB
- the PC itself — IF. EX produces `branch_taken`, `bx_taken`, `bx_target` and
  `branch_offset`; IF decides what to do with them. Those four are already
  inputs on `stage_IF`, so this contract is fixed.

Three subcircuits come in whole: `ALU`, `barrel_32b`, `condition_checker`. All
three are already in `armv4t_2.circ`. The work here is glue, not depth — but
there is a lot of glue, so it is split into four groups you can wire in
sittings.

---

## Ports

Sorted by `(y, x)` as always. Inputs at `x=100`, outputs at `x=2600`.

### Inputs

| y | label | width | from |
|---|---|---|---|
| 100 | `clk` | 1 | main |
| 140 | `rst` | 1 | main |
| 180 | `rd_a` | 32 | **ID** — operand A, PC+8 substituted |
| 220 | `rd_b` | 32 | **ID** — operand B, PC+8 substituted |
| 260 | `alu_ctrl` | 10 | **ID** — the control ROM word |
| 300 | `cond` | 4 | ID — `instr[31:28]` |
| 340 | `class_bits` | 3 | ID — `instr[27:25]` |
| 380 | `opcode` | 4 | ID — `instr[24:21]` |
| 420 | `imm_bit` | 1 | ID — `instr[25]` |
| 460 | `imm8` | 8 | ID — `instr[7:0]` |
| 500 | `rot` | 4 | ID — `instr[11:8]`; **this is ID's `rs` pin**, see below |
| 540 | `shift_type` | 2 | ID — `instr[6:5]` |
| 580 | `shift_amount` | 5 | ID — `instr[11:7]` |
| 620 | `s_bit` | 1 | ID — `instr[20]` |
| 660 | `instr_27_4` | 24 | ID — the BX comparison |
| 700 | `branch_imm24` | 24 | ID — `instr[23:0]` |

Two notes on the ID side of this interface.

**`rot` and `rs` are the same four bits.** ARM reuses `instr[11:8]` as the
register-specified shift amount in one encoding and the immediate's rotate
field in another; which one it means is decided by `instr[25]`, and that
decision happens here, not in ID. Wire ID's existing `rs` pin to this `rot`
input — do not add a second pin for it.

**`branch_imm24` is a new export from ID.** Add a splitter there: `incoming=32
fanout=2`, fan0 = bits 23:0, fan1 = bits 31:24, fed from `instruction`. Put its
pin at the **bottom** of ID's port list, below every existing pin. Port order
is positional and sorted by `(y, x)`, so a pin inserted anywhere above shifts
every port after it on the instance — silently, and only visibly once `main` is
wired.

### Outputs

| y | label | width | to |
|---|---|---|---|
| 1000 | `alu_result` | 32 | MEM, WB |
| 1040 | `alu_we` | 1 | WB |
| 1080 | `cond_pass` | 1 | MEM, WB, and back to ID's gates |
| 1120 | `branch_taken` | 1 | **IF** |
| 1160 | `bl_taken` | 1 | ID (`WA = r14`), WB |
| 1200 | `bx_taken` | 1 | **IF** |
| 1240 | `bx_target` | 32 | **IF** |
| 1280 | `branch_offset` | 32 | **IF** — already computed, see group D |
| 1320 | `cpsr` | 4 | WB, debug |

---

## Group A — operand B

ARM builds the ALU's second operand two ways, chosen by `instr[25]`:

- **`imm_bit = 0`** — a register, `Rm`, run through the barrel shifter by
  `shift_type` and `shift_amount`.
- **`imm_bit = 1`** — an 8-bit immediate, rotated right by `2 × rot`.

The elegant part of the existing design: **both go through the same barrel
shifter.** The immediate path just forces the shifter's type to ROR and feeds
it `rot × 2`. Three muxes on the shifter's three inputs, all sharing `imm_bit`
as select.

| part | attrs |
|---|---|
| `EXT_IMM` | Bit Extender, in 8, out 32, type zero |
| `S_ROT` | Splitter, `incoming=5 fanout=2 facing=west appear=right`; fan0 = bit 0, fan1 = bits 4:1 |
| `K_ROT0` | Constant, width 1, value `0` |
| `K_ROR` | Constant, width 2, value `0x3` |
| `M_SHIN` | Multiplexer, width 32, 2 inputs |
| `M_SHAMT` | Multiplexer, width 5, 2 inputs |
| `M_SHTYP` | Multiplexer, width 2, 2 inputs |
| `shifter` | `barrel_32b` instance |

```
imm8 (pin)               -> EXT_IMM.in
EXT_IMM.out              -> M_SHIN.in1
rd_b (pin)               -> M_SHIN.in0
imm_bit (pin)            -> M_SHIN.sel, M_SHAMT.sel, M_SHTYP.sel
M_SHIN.out               -> shifter.input_32b

K_ROT0.out               -> S_ROT.fan0
rot (pin)                -> S_ROT.fan1
S_ROT.combined           -> M_SHAMT.in1
shift_amount (pin)       -> M_SHAMT.in0
M_SHAMT.out              -> shifter.amnt

K_ROR.out                -> M_SHTYP.in1
shift_type (pin)         -> M_SHTYP.in0
M_SHTYP.out              -> shifter.typ
```

**`S_ROT` is the `× 2`.** A 5-bit bus whose bit 0 is tied to 0 and whose bits
4:1 carry `rot` *is* `rot × 2` — no multiplier, no shifter, just wiring. Get
the fan assignment backwards and every immediate rotates by half what it
should, which passes most tests because the common rotate is 0.

---

## Group B — the ALU

`alu_ctrl` arrives as one 10-bit bus and is split here, not in ID. Ten wires
across a stage boundary instead of one is exactly what this reorganization
exists to prevent.

| part | attrs |
|---|---|
| `S_CTRL` | Splitter, `incoming=10 fanout=10 facing=east appear=right`, identity map |
| `S_LOGIC` | Splitter, `incoming=3 fanout=3` |
| `S_CIN` | Splitter, `incoming=2 fanout=2` |
| `S_ENG` | Splitter, `incoming=2 fanout=2` |
| `K_UNUSED` | Constant, width 1, value `0` |
| `alu` | `ALU` instance |

Field assignment, read off the working circuit's splitter:

| `alu_ctrl` bit | field |
|---|---|
| 0 | `write_enable` |
| 3:1 | `logic_sel` |
| 5:4 | `cin_sel` |
| 6 | `b_inv` |
| 7 | `a_inv` |
| 9:8 | `engine_sel` |

```
alu_ctrl (pin)           -> S_CTRL.combined
S_CTRL.fan0              -> alu.write_enable
S_CTRL.fan1,2,3          -> S_LOGIC.fan0,1,2   then S_LOGIC.combined -> alu.logic_sel
S_CTRL.fan4,5            -> S_CIN.fan0,1       then S_CIN.combined   -> alu.cin_sel
S_CTRL.fan6              -> alu.b_inv
S_CTRL.fan7              -> alu.a_inv
S_CTRL.fan8,9            -> S_ENG.fan0,1       then S_ENG.combined   -> alu.engine_sel

rd_a (pin)               -> alu.A
shifter.outp             -> alu.B
K_UNUSED.out             -> alu.unused
alu.result               -> alu_result (pin)
alu.write_enable_out     -> alu_we (pin)
```

The three small splitters exist because the wide splitter emits single bits and
the ALU wants grouped buses. Copy the pattern; it is not worth redesigning.

**`alu.Cflag` is wired in group C**, from the CPSR. Leaving it on a constant
was the ADC bug — SBC and RSC passed for months only because their tests forced
C=0, which is exactly what the stuck constant supplied.

---

## Group C — flags and the CPSR

The CPSR here is four bits, N Z C V. Bit layout, confirmed identical on the
write and read splitters:

```
bit 3 = N     bit 2 = Z     bit 1 = C     bit 0 = V
```

**`bitK` in a Logisim splitter is the inverse map** — it names the fan that bus
bit K is routed to, not the bit that fan K carries. Both splitters below use
the same layout but different fan orders, so their raw attributes differ. Set
the fans by *meaning* and let the attributes fall where they may.

| part | attrs |
|---|---|
| `S_FLAGW` | Splitter, `incoming=4 fanout=4 facing=west appear=right`; fan0=C fan1=Z fan2=N fan3=V |
| `S_FLAGR` | Splitter, `incoming=4 fanout=4 facing=east appear=right`; fan0=N fan1=Z fan2=C fan3=V |
| `CPSR` | Register, width 4 |
| `cond_chk` | `condition_checker` instance |
| `OR_NOFLAG` | OR Gate, 2 inputs |
| `OR_NOFLAG2` | OR Gate, 2 inputs |
| `NOT_DP` | NOT Gate |
| `AND_CPSRW` | AND Gate, 3 inputs |

```
alu.C  -> S_FLAGW.fan0        alu.Z  -> S_FLAGW.fan1
alu.N  -> S_FLAGW.fan2        alu.V  -> S_FLAGW.fan3
S_FLAGW.combined              -> CPSR.D
clk (pin)                     -> CPSR.clk
rst (pin)                     -> CPSR.clr
AND_CPSRW.out                 -> CPSR.en

CPSR.Q                        -> S_FLAGR.combined, cpsr (pin)
S_FLAGR.fan0                  -> cond_chk.N
S_FLAGR.fan1                  -> cond_chk.Z
S_FLAGR.fan2                  -> cond_chk.C, alu.Cflag        <-- the ADC fix
S_FLAGR.fan3                  -> cond_chk.V
cond (pin)                    -> cond_chk.cond
cond_chk.out0                 -> cond_pass (pin)
```

The write gate — flags update only on a data-processing instruction whose S bit
is set and whose condition passed:

```
bx_match (group D)       -> OR_NOFLAG.in0
branch_class (group D)   -> OR_NOFLAG.in1
OR_NOFLAG.out            -> OR_NOFLAG2.in0
mem_class (group D)      -> OR_NOFLAG2.in1
OR_NOFLAG2.out           -> NOT_DP.in
cond_chk.out0            -> AND_CPSRW.in0
NOT_DP.out               -> AND_CPSRW.in1
s_bit (pin)              -> AND_CPSRW.in2
```

`S_FLAGR.fan2` drives **two** sinks — the condition checker and the ALU's carry
input. That single wire is the whole of ADC, SBC and RSC.

---

## Group D — class decode, branches and BX

### Class decode

`class_bits` is `instr[27:25]`. Split it and build two class signals:

| part | attrs |
|---|---|
| `S_CLASS` | Splitter, `incoming=3 fanout=3 facing=east appear=right`; fan0 = `instr[25]`, fan1 = `instr[26]`, fan2 = `instr[27]` |
| `NOT_26` | NOT Gate |
| `NOT_27` | NOT Gate |
| `AND_BRCLASS` | AND Gate, 3 inputs |
| `AND_MEMCLASS` | AND Gate, 2 inputs |

```
class_bits (pin) -> S_CLASS.combined
S_CLASS.fan1     -> NOT_26.in, AND_MEMCLASS.in0
S_CLASS.fan2     -> NOT_27.in, AND_BRCLASS.in2
S_CLASS.fan0     -> AND_BRCLASS.in0
NOT_26.out       -> AND_BRCLASS.in1
NOT_27.out       -> AND_MEMCLASS.in1
AND_BRCLASS.out  -> branch_class     [class_bits == 0b101]
AND_MEMCLASS.out -> mem_class        [instr[26] AND NOT instr[27]]
```

### B and BL

`L` is `instr[24]`, which is `opcode[3]`. Split it out of `opcode` rather than
adding a port.

| part | attrs |
|---|---|
| `S_OPC` | Splitter, `incoming=4 fanout=2 facing=east appear=right`; fan0 = bits 2:0, fan1 = bit 3 |
| `AND_ISBL` | AND Gate, 2 inputs |
| `NOT_L` | NOT Gate |
| `AND_ISB` | AND Gate, 2 inputs |
| `AND_BLTAKEN` | AND Gate, 2 inputs |
| `AND_BTAKEN` | AND Gate, 2 inputs |

```
opcode (pin)     -> S_OPC.combined
S_OPC.fan1       -> AND_ISBL.in1            [the L bit]
branch_class     -> AND_ISBL.in0, AND_ISB.in0
AND_ISBL.out     -> NOT_L.in, AND_BLTAKEN.in1
NOT_L.out        -> AND_ISB.in1
AND_ISB.out      -> AND_BTAKEN.in1
cond_pass        -> AND_BLTAKEN.in0, AND_BTAKEN.in0
AND_BLTAKEN.out  -> bl_taken (pin)
AND_BTAKEN.out   -> branch_taken (pin)
```

### Branch target

`branch_offset = sign_extend(instr[23:0]) << 2 + 8`. The `+8` is the same
pipeline offset as ID's PC+8 — a branch is relative to the instruction's
address plus two words.

| part | attrs |
|---|---|
| `EXT_BR` | Bit Extender, in 24, out 32, **type sign** |
| `SHL_BR` | Shifter, width 32, type `ll` |
| `K_SH2` | Constant, width 5, value `2` |
| `ADD_BR` | Adder, width 32 |
| `K_BR8` | Constant, width 32, value `8` |
| `K_BRCIN` | Constant, width 1, value `0` |

```
branch_imm24 (pin) -> EXT_BR.in
EXT_BR.out         -> SHL_BR.in
K_SH2.out          -> SHL_BR.dist
SHL_BR.out         -> ADD_BR.a
K_BR8.out          -> ADD_BR.b
K_BRCIN.out        -> ADD_BR.cin
ADD_BR.out         -> branch_offset (pin)
```

> **This fixes a defect.** In `debug_armv4t.circ` the equivalent adder's `cin`
> is on a net with no driver at all — `Adder@8640,10400.cin` is floating. The
> PC+8 adder next to it correctly ties its carry-in to a constant 0; this one
> was missed. It has not caused a visible failure, which is exactly why it
> survived: Logisim usually resolves a floating carry-in to 0, so the bug is
> invisible until it isn't. `K_BRCIN` above ties it off. Set `EXT_BR` to
> **sign** extension, not zero — a backward branch is a negative offset, and
> zero-extending turns every loop into a forward jump into nowhere.

### BX

`BX Rm` is `cond 0001 0010 1111 1111 1111 0001 Rm`, i.e. `instr[27:4] ==
0x12FFF1`. Two extra conditions: the condition must pass, and the target's bit
0 must be clear — bit 0 set means Thumb, which this core does not implement.

| part | attrs |
|---|---|
| `K_BXPAT` | Constant, width 24, value `0x12fff1` |
| `CMP_BX` | Comparator, width 24 |
| `S_BXT` | Splitter, `incoming=32 fanout=2 facing=east appear=left`; fan0 = bit 0, fan1 = bits 31:1 |
| `NOT_THUMB` | NOT Gate |
| `AND_BXTAKEN` | AND Gate, 3 inputs |
| `K_ALIGN` | Constant, width 32, value `0xfffffffc` |
| `AND_ALIGN` | AND Gate, 2 inputs, **width 32** |

```
instr_27_4 (pin) -> CMP_BX.a
K_BXPAT.out      -> CMP_BX.b
CMP_BX.eq        -> AND_BXTAKEN.in0, OR_NOFLAG.in0    [bx_match, also group C]

rd_b (pin)       -> S_BXT.combined, AND_ALIGN.in0
S_BXT.fan0       -> NOT_THUMB.in
NOT_THUMB.out    -> AND_BXTAKEN.in1
cond_pass        -> AND_BXTAKEN.in2
AND_BXTAKEN.out  -> bx_taken (pin)

K_ALIGN.out      -> AND_ALIGN.in1
AND_ALIGN.out    -> bx_target (pin)
```

`AND_ALIGN` is a 32-bit AND gate, not a 1-bit one — it masks the low two bits
off the target so the fetch address is word-aligned. Set its data width to 32
or it will silently reduce to a single bit.

---

## When you are done

```bash
python3 tests/check_stage.py armv4t_2.circ stage_EX
```

Then tell me and I will diff it against `debug_armv4t.circ` net by net, the way
ID was checked. Group C is the one to check twice: the CPSR bit layout and the
`S_FLAGR.fan2` fan-out to both `cond_chk.C` and `alu.Cflag` are each a single
wire that silently breaks a whole instruction class.
