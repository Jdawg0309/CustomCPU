# The multiply family — spec

Derived from the live netlist, 2026-08-27. Covers `MUL` and `MLA`; the 64-bit
long multiplies are scoped in section 7.

Current state: **`got=00000000`** for both, in `debug_armv4t.circ` and the
rebuild alike. Two of the eleven remaining architectural failures.

---

## 1. Encoding, and the field surprise

```
MUL   cond 0000 000S  Rd[19:16] SBZ[15:12] Rs[11:8] 1001 Rm[3:0]
MLA   cond 0000 001S  Rd[19:16] Rn[15:12]  Rs[11:8] 1001 Rm[3:0]
```

Class test: **`instr[27:24] == 0000` AND `instr[7:4] == 1001`**. Then
`instr[23:21]` picks the variant (`000` MUL, `001` MLA, `1xx` the long forms).

**The register fields are not where they are for every other instruction:**

| field | normal position | multiply position |
|---|---|---|
| destination `Rd` | `[15:12]` | **`[19:16]`** — where `Rn` normally sits |
| accumulate `Rn` | -- | **`[15:12]`** — where `Rd` normally sits |
| `Rs` | `[11:8]` | `[11:8]` (same) |
| `Rm` | `[3:0]` | `[3:0]` (same) |

Rd and Rn are **swapped** relative to data-processing. `stage_ID` currently
routes `[19:16]` to the RA read port and `[15:12]` to the WA mux; for a multiply
both must be inverted. That is the single most likely thing to get wrong here.

---

## 2. The three-operand problem, and why it is solvable

`MUL` needs two reads (`Rm`, `Rs`). `MLA` needs **three** (`Rm`, `Rs`, `Rn`),
and `reg16x32_1` has two read ports.

But it also exposes **all sixteen register outputs** as pins -- `R0_OUTPUT`
through `R15_OUTPUT` -- alongside `RD_A` and `RD_B`. A third read port is
therefore one 16-to-1 multiplexer:

```
   R0_OUTPUT ─┐
   R1_OUTPUT ─┤
      ...     ├─► Multiplexer (Data Bits 32, Select Bits 4) ─► RD_C
   R15_OUTPUT ┘            sel = the third register index
```

**This same mux also solves the scaled-register-offset store** from
`specs/stage_MEM.md` section 8a, which needs `Rn`, `Rm` and `Rd` simultaneously.
Two P0-class problems, one component. Build it once, in `stage_ID`, and expose
`rd_c` plus an `rc` index input.

---

## 3. Group A — decode, in `stage_ID`

This is the `instr[7]` / `instr[4]` gap, which also gates SWP, halfword
transfers and register-specified shifts. Doing it here does most of the work
for those.

```
is_mul_class = (instr[27:24] == 0000) AND (instr[7:4] == 1001)
is_MUL       = is_mul_class AND NOT instr[23] AND NOT instr[22] AND NOT instr[21]
is_MLA       = is_mul_class AND NOT instr[23] AND NOT instr[22] AND     instr[21]
```

**New in `stage_ID`:** a splitter giving `instr[7:4]`, a 4-bit comparator
against `Constant 0x9`, a comparator or gate tree on `instr[27:24]` against
`0x0`, and the two variant ANDs.

**New `stage_ID` outputs** (all placed **below every existing pin**):

| name | width | meaning |
|---|---|---|
| `is_mul` | 1 | `is_MUL OR is_MLA` -- the datapath switch |
| `is_mla` | 1 | accumulate |

`stage_ID` already extracts `reg_shift` = `instr[4]` and nothing consumes it;
that wire is the start of this.

---

## 4. Group B — operand routing, in `stage_ID`

Three muxes, all selected by `is_mul`:

```
RA  = is_mul ? Rm[3:0]   : <existing>      the multiplicand
RB  = is_mul ? Rs[11:8]  : <existing>      the multiplier
WA  = is_mul ? Rd[19:16] : <existing>      note: NOT [15:12]
RC  = is_mla ? Rn[15:12] : <don't care>    the addend, via the Group 2 mux
```

Place each **outside** the existing chain, the way `bt_active` was added in E4 --
`is_mul ? <multiply field> : <the whole existing mux tree>`. Do not try to fold
it into an existing select.

> `Rs` is already an output of `stage_ID` (it doubles as `rot`), and `Rm` is
> already extracted. Neither needs a new splitter.

---

## 5. Group C — the multiplier itself. **Read this before wiring anything.**

`mul_32` is **structurally incomplete**, not merely disconnected. Mapped from
the netlist:

```
30 csa_3to_2 stages, arranged as TWO parallel chains:

  chain A   dos(p0,p1,p2) -> ... -> csa@7320(p30)   -> sum/carry pins   OK
  chain B   un(nothing)   -> ... -> csa@7100(p29)   -> NOWHERE          DEAD END

  csa `un`                three inputs X, Y, Z all UNCONNECTED
  partial_products.p31    consumed by NOTHING
```

So chain B's fourteen partial products are computed and thrown away, `un`
injects an undefined value into the head of chain B, and one partial product is
never used at all. The product is wrong regardless of how the ALU is wired.

The component count is right for a 32→2 reduction (30 CSAs), so this is a
**topology** problem. I could not infer the intended structure with confidence
from what is there, and I am not going to guess at it.

### Two ways forward

**Option 1 — replace `mul_32` with Logisim's built-in Multiplier.** Recommended.

- **Precedent exists in this repo:** commit `852bfe1`, *"Swap ALU adder to a
  built-in: ALU 63->98 MHz, CPU 45->58 MHz."* The same trade was made once
  already and improved both correctness and speed.
- On the XC7K480T it maps to **DSP48E1 slices**, of which the board has 1,920
  and the design currently uses **zero**. The CSA tree costs roughly a thousand
  LUTs and has 30 levels of combinational depth -- on a design whose critical
  path is already 91% routing, that is the wrong place to spend.
- One component, three connections, no topology to reconstruct.

**Option 2 — repair the CSA tree.** Link chain B into chain A, give `un` real
inputs, and consume `p31`. Feasible, but the intended topology has to be
decided first, and 30 CSAs cannot do 17→2 plus 15→2 plus a merge.

Keep `mul_32` in the file either way -- it is a real artifact of the work and
the ALU is the right place to describe it in the paper. It just should not be
in the live datapath until it computes.

> If you take Option 1, tell me: `Multiplier` is not in `logisim/geometry.py`'s
> port model or my simulator's evaluator, and I will add both before you wire
> it. Without that, every tool here will be blind to it.

---

## 6. Group D — ALU integration

Measured state of the ALU today:

```
mul_32.A            (nothing)          <- floating
mul_32.B            (nothing)          <- floating
mul_32.sum/carry -> ks_32b.A/B          OK, the final adder IS wired
ks_32b.Cin          (nothing)          <- floating
engine mux in2      (nothing)          <- the product never reaches the output
engine mux in3      (nothing)
```

**Connections:**

- `A_eff` → `mul_32.A` (or the built-in's `a`); `B_eff` → `mul_32.B` / `b`
- `ks_32b.Cin` → an explicit **Constant 0** (a bare constant is 1 here -- the
  trap that has cost this project three bugs)
- the product bus → **engine mux `in2`**
- `engine_sel` = `2` for a multiply

`engine_sel` is 2 bits and comes from `alu_ctrl` bits 9:8, which come from the
16×10 control ROM addressed by `opcode`. **A multiply has no free opcode** --
`instr[24:21]` for MUL is `000S`, colliding with AND/EOR. So `engine_sel` must
be forced to 2 from the decode, not from the ROM: a mux on the `alu_ctrl` path
in `stage_EX`, selected by `is_mul`.

If you take Option 1, `ks_32b` is no longer needed as the final adder -- which
frees it for the add path (`CLAUDE.md` section 8 item 4) where it belongs, and
where it also enables lane-breaking if SIMD ever happens.

---

## 7. Group E — flags, and what is out of scope

`MULS`/`MLAS` set **N** and **Z** from the 32-bit result. **C is architecturally
UNPREDICTABLE** in ARMv4 and **V is unaffected**. So: reuse the existing NZ
logic, leave C and V alone. No new flag hardware.

**Out of scope for now:** `UMULL`, `UMLAL`, `SMULL`, `SMLAL`. They need a 64-bit
result written to two registers in one instruction -- which the register file
can actually do, since `wd`/`wa`/`we` and `wd2`/`wa2`/`we2` are both live and
`stage_MEM` is the only current user of the second port. Worth doing after
MUL/MLA, and it is a `stage_WB` change plus a wider multiplier.

---

## 8. Order of work

1. **Group A decode** -- also unlocks SWP, halfword and register shifts.
2. **The third read port** (section 2) -- also unlocks scaled-register-offset
   stores.
3. **Group C, Option 1** -- one component.
4. **Group B routing** and **Group D integration**.
5. **Group E** is nearly free.

Steps 1 and 2 are each worth doing for reasons beyond multiply. That is the
argument for taking this on before the remaining ARM work rather than after.

---

## 9. Verifying

The suite already has the discriminators:

```asm
MUL:  mov r1,#7  mov r2,#6  mul r0,r1,r2       -> 42
MLA:  mov r1,#7  mov r2,#6  mov r3,#2  mla r0,r1,r2,r3  -> 44
```

MLA is the one that proves the third read port; MUL passes without it. Check
both, and check a case where `Rd` and `Rm` differ from `Rn` in every field, so a
swapped `[19:16]`/`[15:12]` cannot pass by coincidence.
