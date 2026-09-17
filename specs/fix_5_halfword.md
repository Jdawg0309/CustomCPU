# Halfword / signed transfer — LDRH, STRH, LDRSB, LDRSH

Closes both remaining `memory` failures (`halfword`, `signed byte`) in one
feature — they're the same ARM instruction *format*, just different `SH`
bits. Confirmed against the real Logisim engine: this is genuinely unbuilt,
not a wiring gap like fixes 1–3. Bigger than any single prior fix; broken
into four additive stages, each independently checkable.

---

## 0. Why these two are one feature, not two

Real ARM has no `LDRSB` in the ordinary LDR/STR encoding — signed-byte and
all halfword loads live in a *different* instruction format entirely
(`instr[27:25]=000`, `instr[7]=1`, `instr[4]=1`, `instr[6:5]=SH`):

```
SH = 01  ->  LDRH / STRH   (unsigned halfword)
SH = 10  ->  LDRSB          (signed byte)
SH = 11  ->  LDRSH          (signed halfword)
```

One decode signal, one address-computation path, one read-extraction mux
serves all three.

---

## 1. Decode — `stage_ID`, new output `is_hwxfer`

**What already exists and should be reused, not rebuilt:**

- `instr_7_4` — a 4-bit probe already extracting `instr[7:4]`, built for the
  MUL/MLA decode you just did. It already carries exactly the bits this
  needs.
- `shift_type` — already `instr[6:5]`, already an output of `stage_ID`,
  already reaching `stage_EX` *and* `stage_MEM` (fix 3 added that second
  path). No new wiring needed to get `SH` into `stage_MEM` — it's already
  there.
- `class_bits` — already extracted.

**What's new — match the comparator style your MUL decode already uses**
(three `instr_7_4`-vs-constant comparators, the same shape as `mul_signature`):

| part | attributes |
|---|---|
| `CMP_HW1` | Comparator, width 4, `a`=`instr_7_4`, `b`=Constant `0xB` |
| `CMP_HW2` | Comparator, width 4, `a`=`instr_7_4`, `b`=Constant `0xD` |
| `CMP_HW3` | Comparator, width 4, `a`=`instr_7_4`, `b`=Constant `0xF` |
| `OR_HWPAT` | OR Gate, **3 inputs** |
| `CMP_CLASS0` | Comparator, width 3, `a`=`class_bits`, `b`=Constant `0x0` |
| `AND_HWXFER` | AND Gate, 2 inputs |

```
CMP_HW1.eq, CMP_HW2.eq, CMP_HW3.eq  -> OR_HWPAT   (= instr[7:4] is B, D, or F)
OR_HWPAT.out, CMP_CLASS0.eq          -> AND_HWXFER -> pin  is_hwxfer
```

`0xB=1011, 0xD=1101, 0xF=1111` — all three have bit7=1 and bit4=1 with
`SH != 00` (00 is the MUL/SWP space you already decode separately). The
`class_bits==0` gate matters: without it, nothing stops an unrelated
instruction whose low nibble happens to match from mis-firing this.

**New `stage_ID` output pin:** `is_hwxfer`, width 1, placed **below every
existing output** (currently `rm_val` is last).

---

## 2. Address offset — different encoding, same output slot

Ordinary LDR/STR's offset is `instr[11:0]` immediate or a shifted `Rm`.
This format's offset is unrelated to that:

```
instr[22] == 1  ->  immediate = zeroExtend( instr[11:8] : instr[3:0] )   (8 bits)
instr[22] == 0  ->  register  = Rm  (instr[3:0], unshifted)
```

**`instr[22]` is a bit you already extract** — it's `stage_MEM`'s `B` pin
(the byte-access bit for *ordinary* LDR/STR, same physical bit, unused
downstream today since byte-lane masking isn't built either). Reusing it
here doesn't conflict with anything — nothing currently consumes `B`.

**The register form is also already available** — `rm_val`, built in fix 3,
is exactly `Rm`'s value with no shift applied, which is exactly what this
format wants.

**Components, in `stage_MEM`:**

| part | attributes |
|---|---|
| `S_IMMH` | Splitter, 16→ fan for `instr_15_0[11:8]` (4 bits) |
| `S_IMML` | Splitter, 16→ fan for `instr_15_0[3:0]` (4 bits) — or reuse whatever
  fan already isolates the low nibble, if one exists |
| `COMB_HWIMM` | Splitter used as combiner: `immH`+`immL` → 8 bits |
| `EXT_HWIMM` | Bit Extender, in 8 / out 32, **zero** |
| `MUX_HWOFF` | Multiplexer, width 32 — `in0`=`rm_val`, `in1`=`EXT_HWIMM.out`,
  `sel`=`B` |

`sel=B` matches real ARM's polarity here: `instr[22]=1` selects the
immediate form.

**Splice point — additive, doesn't touch fix 3's mux:**

Fix 3 already built a mux that resolves the *ordinary* LDR/STR offset
(immediate-12 or scaled-register) and feeds it to the U-bit XOR. Leave that
mux exactly as it is. Add **one more 2-input mux** between that mux's output
and the XOR gate:

```
[fix-3 offset mux].out ──┐
                          ├─► [NEW MUX, sel=is_hwxfer] ──► XOR.in0
MUX_HWOFF.out            ──┘
```

When `is_hwxfer` is false, behavior is byte-for-byte what it is today.

---

## 3. The lane-select bits are already sitting there, unused

The splitter that turns the computed byte address into `RAM.addr` already
separates a 2-bit fan for `{address bit1, address bit0}` — it was built,
it's just never been wired to anything. Find it: it's the fan on the same
splitter as `RAM.addr` that ISN'T `RAM.addr` — currently dead-ends at the
splitter's own pin. Call its two bits `ADDR_1` (halfword-half select) and
`ADDR_0` (byte-within-halfword select, needed only for `LDRSB`).

Tap it. Don't rebuild it.

---

## 4. Write path — STRH (read-modify-write)

RAM here has no byte/halfword write-enable, so a halfword store has to read
the current word, replace one half, write the merged word back — in the
same cycle, since `RAM.data_out` already reflects the addressed location's
prior contents before this cycle's write commits (same half-cycle timing
fix 4 already relies on elsewhere in the design — nothing new to prove
here).

| part | attributes |
|---|---|
| `MUX_HI` | Multiplexer, width 16 — `in0`=`RAM.data_out[31:16]`,
  `in1`=`rd_b[15:0]`, `sel`=`ADDR_1` |
| `MUX_LO` | Multiplexer, width 16 — `in0`=`rd_b[15:0]`,
  `in1`=`RAM.data_out[15:16]`... i.e. `RAM.data_out[15:0]`, `sel`=`ADDR_1` |
| `COMB_MERGE` | Splitter used as combiner: `MUX_HI`+`MUX_LO` → 32 bits |
| `MUX_DATAIN` | Multiplexer, width 32 — `in0`=`rd_b` (today's direct wire),
  `in1`=`COMB_MERGE.out`, `sel`=`is_hwxfer` |

`MUX_DATAIN.out` replaces the existing direct `rd_b → RAM.data_in` wire —
break that wire, insert the mux, `out` goes where `rd_b` used to.

`RAM.we` also needs `is_hwxfer` in its enable OR (alongside whatever already
asserts it for ordinary `STR`) so a store actually fires for this
instruction class.

---

## 5. Read path — LDRH / LDRSB / LDRSH

`shift_type` (`SH`) is *already* the exact 2-bit selector needed — no new
decode:

```
SH=01 (LDRH)  -> zero-extend the 16-bit half
SH=10 (LDRSB) -> sign-extend the 8-bit byte
SH=11 (LDRSH) -> sign-extend the 16-bit half
```

| part | attributes |
|---|---|
| `MUX_HALF` | Multiplexer, width 16 — `in0`=`RAM.data_out[15:0]`,
  `in1`=`RAM.data_out[31:16]`, `sel`=`ADDR_1` |
| `S_HALFBYTE` | Splitter on `MUX_HALF.out`: low 8 bits vs high 8 bits |
| `MUX_BYTESEL` | Multiplexer, width 8 — picks the addressed byte using
  `ADDR_0` (needed because `LDRSB` isn't halfword-aligned like the other two) |
| `EXT_ZH` | Bit Extender, 16→32, **zero** — for LDRH |
| `EXT_SB` | Bit Extender, 8→32, **sign** — for LDRSB |
| `EXT_SH` | Bit Extender, 16→32, **sign** — for LDRSH |
| `MUX_HWRESULT` | Multiplexer, **select 2**, width 32 — `sel`=`shift_type` directly:
  `in0`=don't-care (SH=00 never reaches here, `is_hwxfer` gates it out upstream),
  `in1`=`EXT_ZH.out`, `in2`=`EXT_SB.out`, `in3`=`EXT_SH.out` |
| `MUX_LOADSEL` | Multiplexer, width 32 — `in0`=existing RAM/ROM-select mux
  output, `in1`=`MUX_HWRESULT.out`, `sel`=`is_hwxfer` |

`MUX_LOADSEL.out` replaces the direct wire that currently feeds `load_data`.

**Why `shift_type` as a direct 2-bit select works cleanly:** its three live
values (01, 10, 11) map one-to-one onto `MUX_HWRESULT`'s inputs 1, 2, 3.
That's not a coincidence to preserve carefully — it's just what `SH` already
encodes.

---

## 6. New pins, summarized

| stage | new pin | width | placement |
|---|---|---|---|
| `stage_ID` | `is_hwxfer` | 1 | below every existing output |
| `stage_MEM` | `is_hwxfer` | 1 | below `shift_type` (currently last input) |

One new tunnel in `main`: `stage_ID.is_hwxfer → stage_MEM.is_hwxfer`.

---

## 7. Traps

- **`OR_HWPAT` is 3 inputs, `AND_HWXFER` is 2.** Logisim defaults to 2 and
  the missing input is silent — same warning as the MUL/MLA spec, worth
  repeating because it's an easy miss.
- **Don't touch fix 3's offset mux.** The new `is_hwxfer` mux goes *after*
  it, not inside it.
- **`B` is dual-purpose now** — `instr[22]` means "byte access" for ordinary
  LDR/STR and "immediate-offset form" for this instruction class. That's
  correct (same physical bit, different instruction, different meaning) —
  don't try to give it a second, separate pin.
- **`shift_type=00` must never reach `MUX_HWRESULT`'s output** — it can't,
  because `is_hwxfer` is false whenever `SH=00` (that's the MUL/SWP space),
  so `MUX_LOADSEL` selects the ordinary path instead. `MUX_HWRESULT.in0` is
  genuinely never selected; leave it tied to anything.

---

## 8. Verify

```bash
python3 tests/check_stage.py armv4t_2.circ stage_ID
python3 tests/check_stage.py armv4t_2.circ stage_MEM
python3 tests/check_stage.py armv4t_2.circ main
python3 tests/adversarial_regression.py armv4t_2.circ --case "halfword"
python3 tests/adversarial_regression.py armv4t_2.circ --case "signed byte"
```

Both are real-Logisim runs (not the Python engine — trust this one, given
today). Discriminator worth adding by hand once it's in: store a different
value in each half of the same word and read both back independently, to
prove `ADDR_1` selection actually works and isn't accidentally always
picking one half:

```asm
    ldr r1,=0x1100
    ldr r2,=0x1111
    strh r2,[r1]         @ low half  = 0x1111
    ldr r2,=0x2222
    strh r2,[r1,#2]      @ high half = 0x2222
    ldrh r0,[r1]         @ must be 0x1111
    ldrh r3,[r1,#2]      @ must be 0x2222, not 0x1111
```
