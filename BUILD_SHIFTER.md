# Building the Barrel Shifter — Offline Field Guide

> **Goal:** `in(32), amt(5), typ(2) → out(32)`. Any shift, any type, one gate delay
> chain of depth 5.
>
> This is the **last genuinely-new datapath block**. Everything after it is
> plumbing you've already done once.
>
> Everything here works with **no internet**. All the scripts are local.

---

## 0. The offline toolkit

```bash
cd ~/Desktop/HFS

python3 armv4t_alu.py --shiftstages          # ← THE BRING-UP TABLE. one stage at a time.
python3 armv4t_alu.py --shiftstages 0x9E3779B8   # same, second probe vector
python3 armv4t_alu.py --shiftsep             # PROVES why stage 1 needs TWO vectors
python3 armv4t_alu.py --shift 0x9E3779B9     # full amt-sweep table
python3 armv4t_alu.py --shiftproof           # proves 5 stages == 1 shift (1280 cases)
```

**Diagrams on disk** (open in a browser):

| file | what it shows |
|---|---|
| `barrel_chain.svg` | ← **the one to stare at.** The 5 stages in a row. |
| `bs_stage.svg` | one stage, opened up |

**Never memorize a number from this file.** `armv4t_alu.py` computes every value
below. It is the source of truth; this document is a map.

---

## 1. The whole block is TWO ideas

### Idea 1 — the shift amount is a SUM OF POWERS OF TWO

Any `amt` in 0..31 is `amt[4]·16 + amt[3]·8 + amt[2]·4 + amt[1]·2 + amt[0]·1`.

So don't build a 32-way shifter. Build **five** shifters and let each one decide
whether to fire:

```
in ─►[«1?]─►[«2?]─►[«4?]─►[«8?]─►[«16?]─► out
      amt0   amt1   amt2   amt3   amt4
```

Depth **5**, not 32. This is the *exact* same move as Kogge-Stone (prefix reach
1,2,4,8,16) and the CSA tree: **logarithmic beats linear.** You've made this
trade twice already. Third time.

### Idea 2 — the shift is WIRE PLACEMENT. The TYPE is the FILL.

All four types move the surviving bits to the same places. They differ **only in
what fills the vacated bits**:

| type | direction | vacated bits | filled with |
|---|---|---|---|
| `00` LSL | left by `d` | low `d` | **0** |
| `01` LSR | right by `d` | high `d` | **0** |
| `10` ASR | right by `d` | high `d` | **`in[31]`** (the sign) |
| `11` ROR | right by `d` | high `d` | **`in[d-1:0]`** (the bits that fell off) |

Look at rows 2, 3, 4: **LSR, ASR and ROR are the same right-shift.** The entire
difference between an arithmetic shift and a rotate is *which constant you jam
into the top `d` bits*.

> **There is no arithmetic in this block.** No carries, no propagation, no theory.
> It is routing and a fill. That's why nothing here can bite you the way the CSA
> tree did — and why the traps that *are* here are all **mux-order** traps.

---

## 2. The invariant: why 5 chained stages == 1 big shift

This is the thing that must stay true. If it doesn't, the whole log structure is
illegal.

- **LSL / LSR:** the fill is `0`, and shifting zeros produces more zeros. So
  `shift(shift(x, a), b) == shift(x, a+b)`. Trivially composes.
- **ROR:** rotations add mod 32. Trivially composes.
- **ASR:** ← *this is the non-obvious one.*

**Why ASR composes:** ASR fills the top bits with `in[31]` — **including bit 31
itself**. So an ASR *never changes the sign bit*. Which means stage 2's sign-fill
still reads the **true original sign**, even though it's looking at stage 1's
output. The sign is a fixed point of the operation.

If ASR did *not* preserve bit31, chaining would silently corrupt the fill on
every multi-stage shift, and you'd only notice on negative numbers shifted by
3+. It works — but it works *for a reason*, and that reason is the invariant.

```bash
python3 armv4t_alu.py --shiftproof
#   staged-vs-direct: 1280 combinations, 0 mismatches
#   COMPOSITION INVARIANT HOLDS ✅
```

**Already proved.** You are building against a known-good spec.

---

## 3. What you are deliberately NOT building (yet)

| skipped | why it's safe |
|---|---|
| **`shifter_carry`** | Only feeds the **C flag on logic ops**. The ALU is sealed and takes `Cflag` as an input — tie it to 0, exactly as the CPU does today. See §7; it's a *separate* block, not part of the chain. |
| **`LSR #0` = `LSR #32`** | An **encoding** quirk (§4.5.2), not a datapath quirk. The barrel shifter takes `amt` 0–31 and means it. Fix it in operand2 decode later. |
| **`ROR #0` = `RRX`** | Same — encoding, not datapath. RRX needs the C flag, so it lands with CPSR. |
| **operand2 mux (I-bit)** | Next block, not this one. Build the shifter standalone first. |

> Same discipline as M1: **one block, one invariant, one probe.** Build the 32-bit
> data path, verify it against the oracle, *then* bolt on carry.

---

## 4. Build it in three stages. Verify each.

`Project → Add Circuit… → bs_stage_1`

### STAGE A — ONE stage. Get this exactly right, then clone it 4×.

Interface: `in(32)`, `typ(2)`, `en(1)` → `out(32)`

```
                      ┌─ Shifter: Logical Left,     const 1 ─┐ 0
                      ├─ Shifter: Logical Right,    const 1 ─┤ 1     ┌────────┐
   in (32) ───────────┼─ Shifter: Arithmetic Right, const 1 ─┤ 2 ──► │ MUX    │
                      └─ Shifter: Rotate Right,     const 1 ─┘ 3     │  4:1   │──► shifted
                                                                     └────────┘
                                                        typ (2) ──────────┘

   in ──────────────────────────────────────────────► 0 ┌────────┐
   shifted ─────────────────────────────────────────► 1 │ MUX 2:1│──► out
                                                         └────────┘
                                                 en ─────────┘
```

- **4 Shifter components** (Arithmetic lib), each with **Shift Type** set to the
  four kinds and a **Constant `1`** on the shift-amount input.
- **4:1 Multiplexer**, Data Bits **32**, Select Bits **2** ← `typ`
- **2:1 Multiplexer**, Data Bits **32**, Select Bits **1** ← `en`
- **Set "Include Enable?" to No on BOTH muxes.** (Logisim defaults it to Yes.)

> ### Is a Shifter component cheating?
> **No — and precedent says so.** `partial_products` is *sealed* and it uses
> `Shifter (Logical Left, constant amount = i)` for all 32 row shifts. A
> **constant-amount** shifter is pure wire placement — bit `n` goes to bit `n+1`,
> and a constant fills the hole. You can explain every wire of it, which is the
> build rule.
>
> What would be cheating is a **variable-amount** Shifter — that *is* a barrel
> shifter, and dropping one in would be building the block out of itself. Don't.
> **The shift amount into every Shifter here is a hard Constant.**
>
> Want zero built-ins? Replace each Shifter with a 32-way Splitter → re-merge with
> the strands offset by `d`, and a Constant / sign-broadcast / wrap into the
> vacated lanes. It's ~640 hand-placed strands across the block and it teaches you
> nothing the constant Shifter doesn't. Your call; both are legal.

**Mux input order is the whole ballgame.** `typ` = `00`→LSL, `01`→LSR, `10`→ASR,
`11`→ROR. Input `2` is ASR. Input `3` is ROR. **Get these backwards and §5 is the
only thing that will catch you.**

---

### ✅ Verify A — the two-vector stage probe

```bash
python3 armv4t_alu.py --shiftstages           # vector A: 0x9E3779B9
python3 armv4t_alu.py --shiftstages 0x9E3779B8   # vector B: bit0 flipped
```

Poke `en=1`, sweep `typ` through all four:

| in | typ | out |
|---|---|---|
| `0x9E3779B9` | `00` LSL | `0x3C6EF372` |
| `0x9E3779B9` | `01` LSR | `0x4F1BBCDC` |
| `0x9E3779B9` | `10` ASR | `0xCF1BBCDC` |
| `0x9E3779B9` | `11` ROR | `0xCF1BBCDC` ← **same as ASR. read §5 NOW.** |
| `0x9E3779B8` | `11` ROR | `0x4F1BBCDC` ← and *now* it differs. |

Then `en=0` → `out` **must equal `in`**, all four types. That's the bypass path.

---

### STAGE B — clone to 5 stages

`bs_stage_2`, `bs_stage_4`, `bs_stage_8`, `bs_stage_16` are **identical** to
`bs_stage_1` except the Constant feeding the four Shifters is `2`, `4`, `8`, `16`.

> Copy the circuit, change **one constant**, four times. If you find yourself
> changing anything else, stop — you've diverged.

**✅ Verify B** — probe each stage standalone with `en=1`, `in=0x9E3779B9`, against
its row in `--shiftstages`. One stage at a time. Never two unknowns at once.

The `«2`, `«4`, `«8`, `«16` rows have **no collisions** — all four types give four
distinct values, so a single vector seals them. **Only stage 1 is degenerate.**

---

### STAGE C — chain them ← this is the block

`Project → Add Circuit… → barrel_32b`

Interface: `in(32)`, `amt(5)`, `typ(2)` → `out(32)`

```
amt (5) ──► Splitter, Bits In 5, Fan Out 5  →  amt[0] amt[1] amt[2] amt[3] amt[4]

in ─► bs_stage_1 ─► bs_stage_2 ─► bs_stage_4 ─► bs_stage_8 ─► bs_stage_16 ─► out
        en=amt[0]     en=amt[1]     en=amt[2]     en=amt[3]     en=amt[4]

typ (2) ──► fans out to ALL FIVE stages (same typ everywhere)
```

**`typ` is a shared read-only bus** — every stage gets the same 2 bits. Exactly
like `Rm` broadcast across all 32 `PP_row`s in the multiplier.

**✅ Verify C** — `python3 armv4t_alu.py --shift 0x9E3779B9`

| `amt` | `typ` | `out` | what it proves |
|---|---|---|---|
| `0` | any | `0x9E3779B9` | **all 5 stages bypass.** The `en=0` path. |
| `1` | `10` ASR | `0xCF1BBCDC` | stage 1 alone |
| `16` | `11` ROR | `0x79B99E37` | stage 16 alone — halves swapped, eyeball it |
| `31` | `10` ASR | `0xFFFFFFFF` | **all 5 stages on**, sign floods the register |
| `31` | `01` LSR | `0x00000001` | all 5 on, zero-fill — the ASR/LSR pair |
| `31` | `11` ROR | `0x3C6EF373` | all 5 on, rotations add to 31 |

`amt=31` is the composition test: `1+2+4+8+16 = 31`, every stage firing, and the
answer still matches a single 31-bit shift. **That is the invariant from §2,
executing in gates.**

---

## 5. 🔴 THE STAGE-1 DEGENERACY — the discriminator that isn't there

**At stage 1, NO single input can separate all four shift types.** This is not bad
luck. It is structural:

```
ROR«1 fills bit31 with in[0].
ASR«1 fills bit31 with in[31].
LSR«1 fills bit31 with 0.

  in[31]=1 and in[0]=1  →  ROR == ASR   (both fill a 1)
  in[0]=0               →  ROR == LSR   (both fill a 0)
```

One bit of fill, and every input drives it to agree with *something*. There is no
escape.

```bash
python3 armv4t_alu.py --shiftsep
#   brute force over 1048576 vectors: 0 separate all four types at «1
```

**Zero. Out of a million.** So if you probe stage 1 with the obvious vector
`0x9E3779B9`, and you have **swapped mux inputs 2 and 3** (ASR↔ROR — a one-wire
mistake, the easiest error in this entire block), **your test passes.** Every
other stage passes too, because they're not degenerate. You'd seal a broken
shifter and find out three blocks later, on a negative number, in the middle of
debugging something else.

### The fix: **two vectors that differ only in bit 0.**

| | `0x9E3779B9` (bit0=**1**) | `0x9E3779B8` (bit0=**0**) |
|---|---|---|
| LSL | `0x3C6EF372` | `0x3C6EF370` |
| LSR | `0x4F1BBCDC` | `0x4F1BBCDC` |
| ASR | `0xCF1BBCDC` | `0xCF1BBCDC` |
| ROR | `0xCF1BBCDC` | `0x4F1BBCDC` |
| **blind to** | **ASR↔ROR swap** | LSR↔ROR swap |

Vector A cannot see an ASR/ROR swap. Vector B **can** — under B, ROR drops to
`0x4F1BBCDC` while ASR stays `0xCF1BBCDC`. Run **both**. Neither alone seals
stage 1.

> **This is the same species as the dropped carry.** `DEADBEEF²` and
> `9E3779B9×7F4A7C15` both *passed* on a multiplier that was silently discarding
> its final carry, because those operands happened to produce `carry == 0`. Only
> `0xFFFFFFFF²` forced it. Here, only a bit0-flipped twin forces the ASR/ROR fill
> to disagree.
>
> **The rule this project keeps re-learning:** a test that passes proves nothing
> until you know *which bug it would have caught*. Find the input that
> **uniquely** exposes the failure, or you haven't tested — you've been lucky.

---

## 6. If it's wrong — debug in this exact order

Never probe randomly. Each step halves the search space.

| # | probe | expect | if wrong |
|---|---|---|---|
| 1 | `amt=0`, any `typ` | `out == in` | an `en` line is stuck high, or a 2:1 mux has inputs swapped (pass on `1` instead of `0`) |
| 2 | one stage, `en=1`, `typ=00` (LSL) | `--shiftstages` row | the Constant into that stage's Shifters is the wrong `d` |
| 3 | same stage, `typ=01` vs `10` on a **negative** input | ASR fills `F…`, LSR fills `0…` | 4:1 mux inputs 1 and 2 swapped, **or** you set a Shifter to Logical Right where you meant Arithmetic Right |
| 4 | **stage 1, BOTH vectors** | §5 table | **ASR↔ROR mux swap** ← the one that hides |
| 5 | `typ=11` (ROR), `amt=16` | `0x79B99E37` | Shifter set to **Rotate Left** instead of Rotate Right |
| 6 | `amt=31`, `typ=10` | `0xFFFFFFFF` | a stage isn't chaining — check the `in`→`out` wire *between* stages |

**Steps 1–3 are one stage. Steps 4–6 are the chain.** Step 4 is the seam — probe
it first if you want to be efficient. It is the historical failure point of this
*shape* of block, and it's the one your instincts won't catch.

---

## 7. `shifter_carry` — the block that is NOT in the chain

When you come back for the C flag, know this up front:

**The carry-out cannot be tapped from the last stage.** It depends on the
**original input** and the **total shift amount** — not on any intermediate
value. Per ARM DDI 0084D §4.5.2:

| type | `shifter_carry` |
|---|---|
| LSL `#n` | `in[32-n]` |
| LSR `#n` | `in[n-1]` |
| ASR `#n` | `in[n-1]` |
| ROR `#n` | `in[n-1]` |
| any `#0` | **C flag unchanged** (pass the old C through) |

So it's a **32:1 mux on `in`**, with the select being `32-amt` for LSL and
`amt-1` for the three right shifts — a small index-select block hanging off the
*input*, parallel to the chain, not inside it.

> **⚠ The oracle does NOT model `shifter_carry`.** `--shiftproof` proves the
> 32-bit data path and nothing else. There is no golden reference for the carry
> yet. Build it against §4.5.2 directly, and **write the oracle first** if you
> want a discriminator — otherwise you're testing a circuit against your own
> memory of a datasheet, which is exactly how the `engine_sel` bug survived a
> whole session.

---

## 8. What to avoid — the traps that apply here

### 🔴 Mux input order IS the shift type
`typ` `00`/`01`/`10`/`11` → mux inputs `0`/`1`/`2`/`3` → LSL/LSR/ASR/ROR. A single
transposed wire silently turns every arithmetic shift into a rotate. **§5 is the
only probe that catches the ASR/ROR case.** This is this block's `engine_sel`.

### 🔴 Multiplexer "Include Enable?"
Logisim Evolution defaults it to **Yes**, adding a phantom enable pin. Leave it
floating → the mux outputs error. **Set it to No.** Ten muxes in this block.

### 🔴 Arithmetic Right vs Logical Right
Two adjacent entries in the same dropdown, one letter apart in the label, and
**identical behavior on every positive number**. Test with `bit31 = 1` or you are
not testing.

> This is the **Sign-vs-Zero extender trap wearing a new hat.** It has now bitten
> `pp_row` (needed Sign, got Zero), `partial_products_8` (needed Zero, got Sign),
> and it is lying in wait here. **Rule: any time a design distinguishes "fill with
> the sign" from "fill with zero," your test vector must be negative.**

### 🔴 The shift amount into the Shifters must be a CONSTANT
A variable-amount Shifter *is* a barrel shifter. Using one here means the block
builds itself out of itself and you've learned nothing. Every Shifter in this
block takes a hard `Constant` of `1`, `2`, `4`, `8`, or `16`.

### 🔴 Tunnels with the same name are the same net
Five stages, and it's tempting to label every stage's output `shifted`. Two
tunnels with one name **short together** → oscillation. Unique names or plain wires.

### 🔴 `amt` is 5 bits, not 8
The instruction's shift field is 8 bits (`[11:4]`), but the *amount* is only
`[11:7]` — 5 bits. Feeding 8 bits into a 5-bit splitter is a width error;
Logisim will tell you, but you'll waste time looking in the wrong place.

---

## 9. When it works

You have the last new datapath block. The shifter is what makes operand2 *real* —
`ADD R3, R1, R2 LSL #4` stops being a wire and starts being an instruction, and
the C flag on logic ops finally has a source.

Then, in order of payoff:

1. **operand2 mux (I-bit).** `in ← Rm`, `amt ← instr[11:7]`, `typ ← instr[6:5]`.
   Then the immediate path: ARM immediates are an 8-bit value **ROR'd by
   `2 × rot4`** — which means **your new shifter already computes them.** The
   immediate path is a `typ=11` shortcut through the block you just built. That
   is not a coincidence; it's why ARM encodes them that way.
2. **CPSR + condition check.** `S` and `cond` stop being ignored. Now you can run
   a loop: `SUBS` / `BNE`.
3. **Decoder restructure.** The real architectural work — the current decode ROM
   is addressed by `opcode[24:21]` alone, which is a *data-processing-only*
   assumption. LDR/STR/B live in a different instruction class (`[27:26]`).
4. **Memory + branch.** `pc_fetch` already has `BRANCH` and `IMM` wired in.

---

## 10. The honest scoreboard

```
Compute core (ALU + mul + decode)  ████████████████████  100%
Datapath                           ██████████████░░░░░░   70%   ← today: → ~85%
Memory & control flow              ░░░░░░░░░░░░░░░░░░░░    0%
Pipeline                           ░░░░░░░░░░░░░░░░░░░░    0%
NPU (gate-level 4×4, separate)     ████████░░░░░░░░░░░░   35%
```

**Nothing gate-theoretical is left in this block.** No carries, no propagation, no
parity. It is muxes and routing — and the only way to get it wrong is to wire a
mux input to the wrong slot.

Which is why the *entire* discipline of this build is §5: **two vectors at stage
one.** Everything else will pass on the first try.

**`amt=31`, `typ=10`, `in=0x9E3779B9` → `0xFFFFFFFF`. Go get it.**
