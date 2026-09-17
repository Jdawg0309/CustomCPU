# Fix 2 — logical ops must not write C and V

Re-derived from `armv4t_2.circ` on 2026-08-31, after fix 1 landed.
Everything below is inside **`stage_EX`**. No new pins. `main` is untouched.

---

## 1. Mechanism

`stage_EX` builds the CPSR write value with one 4-bit combining splitter whose
combined side is `CPSR_reg.D`. Its four fans are wired straight to the ALU:

    ALU.C ─┐
    ALU.Z ─┤
    ALU.N ─┼─► [4-bit splitter] ─► CPSR_reg.D   (probe S_flagw)
    ALU.V ─┘

Inside `ALU`, only two of those four are engine-independent:

| ALU output | driven by | correct for a logical op? |
|---|---|---|
| `N` | bit 31 of the engine mux result | yes |
| `Z` | NOT(OR-reduce of the result)     | yes |
| `C` | `ALU_arithmetic_engine.Cout`     | **no — adder carry, always** |
| `V` | an AND gate off the adder        | **no — adder overflow, always** |

So `ands`, `orrs`, `eors`, `bics`, `tst`, `teq`, `movs`, `mvns` all stamp the
adder's carry and overflow into CPSR. ARM says C and V are preserved (C changes
only when the *barrel shifter* emits a carry, which `barrel_32b` does not).

Measured consequence: `deep_matrix` flags-logical is 5/19.

## 2. The select signal already exists

`ALU.engine_sel` is a **2-bit** bus (probe `S_eng`) selecting the ALU's engine
mux: `in0` = `ALU_logic_engine`, `in1` = `ALU_arithmetic_engine`, `in2`/`in3`
reserved for the multiplier. Measured on `armv4t_2.circ`, every opcode:

    S_eng = 0 : and eor tst teq orr mov bic mvn      <- preserve C and V
    S_eng = 1 : sub rsb add adc sbc rsc cmp cmn      <- take C and V from the ALU
    S_eng = 2,3 : never asserted today (multiplier unwired)

No new decode is needed. The control ROM already separates the two classes.

## 3. What to build

Two identical 1-bit muxes, one for C and one for V.

**Components (add 2):**

| part | attributes |
|---|---|
| Multiplexer | `Select Bits = 2`, `Data Bits = 1`  (x2) |

**Existing nets, named by their endpoints — none of them carry a label:**

| name here | how to identify it in Logisim |
|---|---|
| `ALU_C_RAW`  | the wire from `ALU.C` to the CPSR-write splitter |
| `ALU_V_RAW`  | the wire from `ALU.V` to the CPSR-write splitter |
| `CUR_C`      | the wire that reaches **both** `ALU.Cflag` and `condition_checker.C` |
| `CUR_V`      | the wire that reaches `condition_checker.V` |
| `S_eng`      | the 2-bit bus into `ALU.engine_sel` (probe `S_eng` sits on it) |

`CUR_C` and `CUR_V` come off the CPSR **read** splitter on `CPSR_reg.Q`. They
are the live flag values, and tapping them adds a branch, not a driver.

**Connections — C mux:**

    ALU.C            -> MUX_C.in1        (arithmetic: use the adder carry)
    CUR_C            -> MUX_C.in0        (logical: hold the current C)
    CUR_C            -> MUX_C.in2
    CUR_C            -> MUX_C.in3
    S_eng            -> MUX_C.sel
    MUX_C.out        -> the CPSR-write splitter fan that `ALU.C` used to reach

**Connections — V mux:** identical, with `ALU.V`, `CUR_V`, and the fan that
`ALU.V` used to reach.

**Leave alone:** the `ALU.N` and `ALU.Z` fans, the splitter itself (do not
change its bit map or fan count), and `AND_CPSRW` — the `cond_pass & S` enable
is already correct.

Wiring `in2` and `in3` to the current flag is not padding. When the multiplier
is wired to engine mux inputs 2 and 3, `muls`/`mlas` must also preserve C and V,
and this makes that true by construction rather than by a later edit.

## 4. Traps

- Do **not** drop a Probe on a wire that crosses another wire. A probe on a
  crossing joins the two nets. Four of `stage_EX`'s nets pass through this area.
- The two new muxes have no pins, so `stage_EX`'s port order cannot shift and
  `main` needs no change. Confirm anyway with the check in §5.

## 5. Verification

    python3 tests/check_stage.py armv4t_2.circ stage_EX        # expect: clean
    python3 tools/main_suite.py  armv4t_2.circ                 # expect: 13/15, no regression

Discriminator — the case that can only pass with the fix:

    mov r0,#1
    cmp r0,#0          @ C=1 (no borrow)
    ands r1,r0,r0      @ must NOT touch C
    movhi r5,#1        @ HI = C set AND Z clear

`r5 == 1` after the fix; `r5 == 0` before it, because `ands` overwrote C with
the adder's carry-out of `1 AND 1`.

Full sweep: `deep_matrix` flags-logical should go 5/19 -> 19/19, and
flags-adds/subs/cmp/cmn must stay 196/196.

## 6. What this does not fix

Shifted logical operands. `movs r0,r1,lsl #1` should set C from the bit shifted
out; `barrel_32b` has no carry-out port, so C will be preserved instead of
updated. That is a separate change (a carry-out pin on `barrel_32b`, and a
third input to the C mux path) and it is strictly less wrong than today, where
C comes from an adder that was not even asked to add.
