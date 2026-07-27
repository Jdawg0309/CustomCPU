# Building the Single-Cycle CPU — Offline Field Guide

> **Goal:** get one instruction to execute. `ADD R3, R1, R2` → `R3 = 8`.
> That's **M1**. Everything after is expansion.
>
> Everything in this guide works with **no internet**. All the scripts are local.

---

## 0. The offline toolkit

```bash
cd ~/Desktop/HFS

python3 asm.py --demo                      # the bring-up program + expected values
python3 asm.py --demo --rom instr_rom      # ALSO write the Logisim ROM image
python3 asm.py "ADD R4,R1,R2" --init R1=9,R2=4   # make your own program

python3 armv4t_alu.py --decoder            # every ROM addr -> word -> controls -> result
python3 armv4t_alu.py --rom                # regenerate the decode ROM (opcode file)
python3 armv4t_alu.py --test               # 15 golden cases, must ALL PASS
python3 armv4t_alu.py --shift 0x9E3779B9   # barrel shifter values (for later)
python3 armv4t_alu.py --shiftproof         # proves the barrel shifter design

python3 blockdiag.py                       # regenerate every diagram
```

**Diagrams on disk** (open in a browser, no internet needed):

| file | what it shows |
|---|---|
| `cpu_datapath.svg` | ← **the one to stare at.** The whole thing on one sheet. |
| `barrel_chain.svg` | the barrel shifter's 5 stages (for later) |
| `bs_stage.svg` | one barrel-shifter stage |
| `pp_array.svg`, `csa_tree.svg`, `csa_slice.svg`, `pp_slice.svg` | the multiplier (done) |

**Never memorize a number from this file.** If you need a value, `asm.py` and
`armv4t_alu.py` will compute it. They are the source of truth; this document is
just a map.

---

## 1. What you're building, and what you're deliberately NOT building

You already have every hard block. This session is **plumbing**.

### What goes in

| block | status |
|---|---|
| `pc_fetch` | ✅ built (32-bit PC, `+4`, branch mux already stubbed) |
| `instr_rom` | new — a ROM, 16 words × 32 bits |
| `decode_rom` | ✅ built (64K × 10, already loaded with the right words) |
| `reg16x32` | ✅ built (2-read / 1-write) |
| `ALU` | ✅ sealed (16 ops + MUL) |
| 3 splitters | new — pure wiring |

### What you are SKIPPING, and why each skip is legal

| skipped | why it's safe |
|---|---|
| **barrel shifter** | `ADD R3,R1,R2` encodes operand2 as `Rm LSL #0`. **A shift of zero is a wire.** |
| **operand2 mux (I-bit)** | Every instruction below has `I=0`. Register operands only. |
| **condition check** | Every instruction has `cond=1110` (AL, always). |
| **CPSR** | Tie `Cflag=0`. Only `ADC/SBC/RSC` need it — the demo program avoids them. |
| **immediates** | Seed the registers by **poking them** instead. |
| **memory, branch** | Not needed to execute one instruction. |

> This is not cheating. It is **scoping**. Every one of these plugs in later
> without touching what you build today.

---

## 2. Wire it in six stages. Verify each. Do not skip ahead.

This is the same discipline that sealed the multiplier: **one block, one
invariant, one probe.** The reason you debug for 5 minutes instead of 5 hours is
that you never let two unknowns exist at once.

Open `cpu_datapath.svg` alongside this.

`Project → Add Circuit… → cpu_single_cycle`

---

### STAGE A — Fetch

```
CLK             ──► pc_fetch.CLK
Constant 0 (1b) ──► pc_fetch.RST
Constant 0 (1b) ──► pc_fetch.BRANCH
Constant 0 (32b)──► pc_fetch.IMM

pc_fetch.out (4b) ──► instr_rom.address
```

- `instr_rom`: **ROM**, Addr Bit Width **4**, Data Bit Width **32**
- Label `pc_fetch`'s output pin **`PC_word`** — it's currently unlabeled
- **Simulate → uncheck Ticks Enabled.** You want manual `Ctrl+T` stepping.

Load `instr_rom` (right-click → Load Image, pick the `instr_rom` file `asm.py` wrote):

```
v3.0 hex words plain
e0813002 e0413002 e0013002 e1813002 e1a03002 e1e03002 e1410002
```

**✅ Verify A** — probe `PC_word` and `instr_rom.data`, hit `Ctrl+T`:

| clock | `PC_word` | `instr_rom.data` |
|---|---|---|
| 0 | `0` | `0xE0813002` |
| 1 | `1` | `0xE0413002` |
| 2 | `2` | `0xE0013002` |

> **If `PC_word` counts `0,4,8,C`:** the splitter inside `pc_fetch` is tapping
> `PC[3:0]`. Repoint that output to the strand carrying bits **2,3,4,5**
> (`PC[5:2]`). The PC counts *bytes*; the ROM is addressed in *words*. The
> divide-by-4 is done by wire placement — exactly like the multiplier's shifts.
> **Do NOT change the `+4` constant.**

---

### STAGE B — Instruction fields

`instr_rom.data (32)` → **Splitter**, Bits In **32**, Fan Out **7**, label `instr_fields`:

| strand | bits | width | goes to |
|---|---|---|---|
| 0 | `3..0` | 4 | `reg16x32.RB` ← **Rm** |
| 1 | `11..4` | 8 | *unconnected* (shift field, always 0) |
| 2 | `15..12` | 4 | `reg16x32.WA` ← **Rd** |
| 3 | `19..16` | 4 | `reg16x32.RA` ← **Rn** |
| 4 | `20` | 1 | *unconnected* (S bit) |
| 5 | `24..21` | 4 | `dec_addr` strand 0 ← **opcode** |
| 6 | `31..25` | 7 | *unconnected* (cond, I) |

`4+8+4+4+1+4+7 = 32` ✅

**✅ Verify B** — at `PC_word = 0`, instruction `0xE0813002`:
```
opcode = 0100   (4 = ADD)      Rd = 0011  (R3)
Rn     = 0001   (R1)           Rm = 0010  (R2)
```

---

### STAGE C — Decode

`dec_addr` — **Splitter**, Bits In **16**, Fan Out **3**, used in *combine* direction:

| strand | bits | width | source |
|---|---|---|---|
| 0 | `3..0` | 4 | `instr_fields` strand 5 (opcode) |
| 1 | `4` | 1 | **Constant 0** (`is_MUL`) |
| 2 | `15..5` | 11 | **Constant 0, 11 bits** |

→ `decode_rom.address`

> **Tie bits `15..5`.** Floating address bits make the ROM read garbage.
> Logisim will *not* assume zero.

`decode_rom.data (10)` → **Splitter**, Bits In **10**, Fan Out **6**, label `ctrl_fields`:

| strand | bits | width | goes to |
|---|---|---|---|
| 0 | `0` | 1 | `ALU.write_enable` |
| 1 | `3..1` | 3 | `ALU.logic_sel` |
| 2 | `5..4` | 2 | `ALU.cin_sel` |
| 3 | `6` | 1 | `ALU.b_inv` |
| 4 | `7` | 1 | `ALU.a_inv` |
| 5 | `9..8` | 2 | `ALU.engine_sel` |

`1+3+2+1+1+2 = 10` ✅

**✅ Verify C** — at `PC_word = 0`:
```
dec_addr        = 0x0004
decode_rom.data = 0x101
engine_sel = 01   a_inv = 0   b_inv = 0   cin_sel = 00   logic_sel = 000   write = 1
```

> ### ⚠️ THE PROBE THAT MATTERS
> **`engine_sel` must read `01`.** If it reads `00`, strand 5 is on the wrong
> bits. `engine_sel` is the word's **TOP TWO** bits `[9:8]`.
>
> This exact bug already cost you a session once: it silently ran **ADD instead
> of AND**. The tell is that the top hex digit of the ROM word *is* `engine_sel`
> (`0x0xx`=logic, `0x1xx`=arith, `0x2xx`=mul). `0x101` starts with `1` → arith.

---

### STAGE D — Registers

```
instr_fields[19:16] ──► reg16x32.RA     (Rn)
instr_fields[3:0]   ──► reg16x32.RB     (Rm)
instr_fields[15:12] ──► reg16x32.WA     (Rd)
CLK                 ──► reg16x32.CLK
Constant 0 (1b)     ──► reg16x32.RST
```

**Seed the registers.** Right-click the `reg16x32` instance →
*View reg16x32 inside this instance* → Poke tool → set:

```
R1 = 0x00000005
R2 = 0x00000003
```

> `Ctrl+R` (Reset Simulation) zeroes these. **Poke AFTER any reset, never before.**

**✅ Verify D**
```
RD_A = 0x00000005      (Rn = R1)
RD_B = 0x00000003      (Rm = R2)
```

---

### STAGE E — Execute

```
reg16x32.RD_A ──► ALU.A
reg16x32.RD_B ──► ALU.B        ← barrel shifter bypassed; LSL #0 is a wire

ctrl_fields ──► ALU.engine_sel, a_inv, b_inv, cin_sel, logic_sel, write_enable

Constant 0 (1b) ──► ALU.Cflag
Constant 0 (1b) ──► ALU.unused
```

**✅ Verify E** — `ALU.result = 0x00000008`

Nothing has been written yet. The ALU is just *computing*. This proves the whole
combinational path before you let anything latch.

---

### STAGE F — Writeback ← **this is M1**

```
ALU.result           ──► reg16x32.WD
ALU.write_enable_out ──► reg16x32.WE
reg16x32.R3_OUTPUT   ──► output pin, label "R3"
```

> `ALU.write_enable_out` is the pass-through pin you built into the ALU a long
> time ago and have never used. The decoder *computes* it, the ALU *carries* it,
> and here — finally — the register file **obeys** it.

**✅ Verify F** — `Ctrl+T` once. Watch `R3`.

| clock | instruction | `R3` |
|---|---|---|
| 1 | `ADD R3,R1,R2` | **`0x00000008`** ← **YOU ARE ALIVE** |
| 2 | `SUB R3,R1,R2` | `0x00000002` |
| 3 | `AND R3,R1,R2` | `0x00000001` |
| 4 | `ORR R3,R1,R2` | `0x00000007` |
| 5 | `MOV R3,R2` | `0x00000003` |
| 6 | `MVN R3,R2` | `0xFFFFFFFC` |
| 7 | `CMP R1,R2` | **unchanged** (`0xFFFFFFFC`) |

---

## 3. The `write_enable` discriminator (do not skip)

Clock 7 runs `CMP R1,R2`. Its ROM word is `0x150` → **`write = 0`**.

**`R3` must NOT change.**

If it does, `write_enable_out` isn't reaching `WE`, and every `TST/TEQ/CMP/CMN`
will silently corrupt a register. This is the *only* test that exercises the
write-suppress path. It is the single input that uniquely exposes that bug —
your discriminator, in the usual style.

---

## 4. If `R3` stays 0 — debug in this exact order

Never probe randomly. Each step here cuts the search space in half.

| # | probe | expect | if wrong |
|---|---|---|---|
| 1 | `PC_word` steps | `0,1,2…` | clock not connected, or `pc_fetch.RST` stuck high |
| 2 | `instr_rom.data` | `0xE0813002` | ROM not loaded, or address unwired |
| 3 | `dec_addr` | `0x0004` | opcode strand wrong, or bits `15..5` floating |
| 4 | `decode_rom.data` | `0x101` | ROM contents wrong → `python3 armv4t_alu.py --rom` |
| 5 | **`engine_sel`** | **`01`** | **strand 5 not on bits `[9:8]`** ← most likely |
| 6 | `RD_A`, `RD_B` | `5`, `3` | registers not poked, or `RA`/`RB` swapped |
| 7 | `ALU.result` | `8` | (it won't be wrong — the ALU is sealed & verified) |
| 8 | `WE` | `1` | `write_enable_out` not reaching `reg16x32.WE` |

**Steps 1–4 are fetch/decode. Steps 6–8 are execute/writeback. Step 5 is the
seam.** Probe step 5 *first* if you want to be efficient — it's the historical
failure point and it splits the circuit in half.

---

## 5. What to avoid — every trap this project has actually hit

These are not hypotheticals. Each one cost real hours.

### 🔴 The splitter bit-mapping trap
`engine_sel` comes from the ROM word's **top two bits** `[9:8]`. Reading the low
bits ran **ADD where AND belonged**, and every value looked *plausible*.
**Rule:** the top hex digit of the ROM word IS `engine_sel`.

### 🔴 The Bit Extender: Sign vs Zero
This has bitten **three separate blocks**.

| purpose | type |
|---|---|
| broadcasting a single bit across lanes (a *mask*) | **Sign** |
| widening a number to more bits (a *value*) | **Zero** |

`pp_row` needed Sign, got Zero → `0xDEADBEEF` became `0x00000001`.
`partial_products_8` needed Zero on `Rm`, got Sign → `0xBE` became `0xFFBE`.

### 🔴 Logisim's 3-input XOR is NOT parity
For 3+ inputs it computes **"exactly one input high" (1-of-n)**, not odd parity.
So `4 ⊕ 4 ⊕ 4 = 0`. A 2-input XOR is *both* parity and 1-of-n, so every 2-input
test passed and hid the bug for hours.
**Rule:** build parity from **chained 2-input XORs**. Never trust a 3-in XOR.
(3-input OR is fine — "any high" is unambiguous.)

### 🔴 The dropped carry — false positives that look like passes
A CSA chain outputs `(sum, carry)`. **`product = sum + carry`.** Wiring only
`sum` downstream still passes most tests, because the final carry is often zero:

```
DEADBEEF²           sum=0x216DA321  carry=0  → sum alone LOOKS right ✓ (luck)
9E3779B9×7F4A7C15   sum=0xCFFC982D  carry=0  → sum alone LOOKS right ✓ (luck)
FFFFFFFF²           sum=0x80000001  carry=0x80000000 → CAUGHT ✗
```
**Rule:** `0xFFFFFFFF² == 0x00000001` is *the* multiplier discriminator. It is
the only case that forces a nonzero final carry. Never seal a multiplier without it.

### 🔴 Tunnels with the same name are the same net
Two tunnels labeled `sum` in different places **short together**. With 30 CSA
tiles that's 30 outputs on one wire → oscillation. Use unique names or plain wires.

### 🔴 "Oscillation apparent" means a FEEDBACK LOOP
A combinational circuit has zero loops. If Logisim says oscillation, a wire runs
*backward*, or two outputs drive one net. Bisect: tap the chain halfway, see
which half still oscillates.

### 🔴 Multiplexer "Include Enable?"
Logisim Evolution defaults it to **Yes**, adding a phantom enable pin. Leave it
floating → the mux outputs error. **Set it to No.**

### 🔴 Floating address bits are not zero
`decode_rom` has a 16-bit address. Tie bits `15..5` to a Constant. Logisim reads
garbage otherwise.

### 🔴 `Ctrl+R` wipes your poked registers
Reset Simulation zeroes `R1`/`R2`. Re-poke after every reset.

### 🔴 V1 and V2 have different library ID tables
`ALU_modular_design.circ`: `Plexers=2, Arithmetic=3, Memory=4`
`armv4t.circ`: `Memory=2, Base=3, Plexers=4, Arithmetic=5`
**Never merge the `.circ` files by hand.** Copy *inside* Logisim (`Ctrl+A` /
`Ctrl+C` in the source circuit → `Project → Add Circuit` → `Ctrl+V`). Logisim
remaps library references for you.

---

## 6. Logisim, practically

| thing | how |
|---|---|
| **Edit tool** (arrow) | select, move, drag wires |
| **Poke tool** (hand) | set input pins, click registers — *simulation only* |
| Make a gate physically bigger | select it → **`Gate Size`** → `Wide` |
| Rotate a component | the **`Facing`** attribute |
| Change bus width | **`Data Bits`** (does not change the drawing) |
| Poke a register inside a subcircuit | right-click instance → *View … inside this instance* |
| Assign splitter bits | select splitter → attribute panel lists **`Bit 0`, `Bit 1`, …** → set strand |
| See a value on canvas | drop a **Probe** (Wiring lib) |
| Edit ROM contents | right-click ROM → **Edit Contents** / **Load Image** |
| Tick once | `Ctrl+T` |
| Auto-clock on/off | `Ctrl+K` |
| Reset simulation | `Ctrl+R` |

> The menus print the real binding next to each command. **Trust the menus over
> any list, including this one.**

**For CPU bring-up: turn Auto-Tick OFF.** Step one instruction at a time.

---

## 7. When it works

You have a CPU. Say it out loud. It fetches, decodes, reads registers, computes
in a hand-built ALU, and writes back — every gate of it yours.

Then, in rough order of payoff:

1. **Extend the program.** `python3 asm.py "ADD R4,R1,R2" "MVN R5,R4" --init R1=9,R2=4`
   → it prints the ROM image *and* the expected register values.
2. **Prove MUL executes.** Wire `is_MUL` (`dec_addr` strand 1) to a switch.
   Set it high, opcode `0000`, `R1=0xDEADBEEF`, `R2=0xDEADBEEF` → `R3 = 0x216DA321`.
   Both machines now share the same multiplier.
3. **Barrel shifter.** Fully specced already — `barrel_chain.svg`, `bs_stage.svg`,
   and `python3 armv4t_alu.py --shiftproof` (already proved: 1280 cases, 0
   mismatches). Then operand2 gets real shifts.
4. **CPSR + condition check.** Small combinational blocks. Then `S` and `cond`
   stop being ignored.
5. **LDR/STR, branch.** `pc_fetch` already has `BRANCH` and `IMM` wired in.

---

## 8. The honest scoreboard

```
Compute core (ALU + mul + decode)  ████████████████████  100%
Datapath                           ██████░░░░░░░░░░░░░░   25%   ← today: → ~60%
Memory & control flow              ░░░░░░░░░░░░░░░░░░░░    0%
Pipeline                           ░░░░░░░░░░░░░░░░░░░░    0%
NPU (gate-level 4×4, separate)     ████████░░░░░░░░░░░░   35%
```

**Nothing gate-theoretical is left on the CPU.** The Kogge-Stone prefix network,
the carry-save tree, the XOR-parity trap, the dropped-carry trap — those fights
are over and written down. What remains is plumbing you already know how to do.

**One clock. `R3 = 0x00000008`. Go get it.**
