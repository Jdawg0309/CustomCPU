# CustomCPU

**A gate-level ARMv4T CPU (and INT8 NPU), built from scratch in Logisim — every block understood down to the gate.**

The rule of the project: *if I can't explain a block, I don't get to use it.* No behavioral shortcuts in the datapath — built-ins are allowed only where the underlying gates are understood, and `a*b`-style behavior is used only as a test oracle, never as hardware.

The ARMv4T CPU is the learning artifact. The long-term target is an open-ISA machine with a hand-built INT8 systolic NPU, benchmarked gate-for-gate against commercial silicon (Hailo-8L).

---

## Progress

```
OVERALL (practical C-capable target)         █████████████████░░░░░  80%

  Compute core (ALU + multiplier + decode)   ██████████████████████  100%
  Datapath (regfile, fetch, shifter, CPSR)   ██████████████████████  100%
  Control flow (conditions, B, BL, BX)       ██████████████████████  100%
  Memory (LDR/STR, data RAM, stack)          █████████████░░░░░░░░░  60%
  Pipeline (5-stage)                         ░░░░░░░░░░░░░░░░░░░░░░  0%
  NPU (gate-level systolic array)            ████████░░░░░░░░░░░░░░  35%
```

**M1 is complete:** the CPU executes instructions end to end. GCC-generated
ARMv4T C also runs using the standard R0/R1 argument, R0 result, and LR return
convention.

**Next block:** stack-compatible addressing and R13 writeback. Canonical
positive/negative immediate word `LDR`/`STR`, data RAM, and load writeback work.

---

## What's done, block by block

### ✅ Compute core — 100%
| Block | Status | Notes |
|-------|--------|-------|
| `ks_32b` | ✅ sealed | 32-bit Kogge-Stone adder/subtractor (parallel-prefix carry) |
| `ALU_logic_engine` | ✅ sealed | AND · EOR · ORR · MOV · BIC · MVN → out_mux slot 00 |
| `ALU_arithmetic_engine` | ✅ sealed | ADD · SUB · RSB · ADC · SBC · RSC (invert layers + Cin mux) → slot 01 |
| `mul_32b` | ✅ sealed | gate-level 32×32 → low-32 multiplier → slot 10 |
| `ALU` | ✅ sealed | 16 data-processing ops + MUL, N/Z/C/V flags, verified vs oracle |
| decode ROM (`opcode`) | ✅ sealed | opcode → 10-bit control word |

### ✅ Datapath and control flow — verified
| Block | Status | Notes |
|-------|--------|-------|
| `reg16x32` — register file (16×32) | ✅ **in V2, verified** | 2-read / 1-write. 16 regs + write decoder + 2 read muxes + 16 write-enable ANDs. Where `write_enable` finally acts. |
| `pc_fetch` — PC + fetch | ✅ **in V2, verified** | PC register + 2 adders + branch mux |
| barrel shifter | ✅ verified | LSL/LSR/ASR/ROR through five 1/2/4/8/16 stages |
| Operand2 mux (I-bit) | ✅ verified | register shifts and rotated immediates |
| CPSR (flag register) | ✅ verified | arithmetic N/Z/C/V with S-bit gating |
| condition check | ✅ verified | all condition classes; failed conditions suppress commits |
| decoder extension | ☐ todo | add top-level MUL selection and LDR/STR controls |
| B / BL / BX | ✅ verified | relative branch, link write to R14, and register return |
| integration → first instruction | ✅ **M1 complete** | full fetch/decode/execute/writeback path works |

Both `reg16x32` and `pc_fetch` were carried over from the V1 build and re-verified in place — the register file and instruction fetch are done, not rebuilt.

### ⏳ Memory — basic word transfers verified
Positive/negative immediate word LDR/STR, 1 KiB data RAM, conditional store
suppression, and conditional load writeback are verified. R13 stack addressing,
base writeback, and byte/halfword transfers remain.

### ☐ Pipeline — 0%
5-stage, added *after* single-cycle works.

### ✅ NPU — 4×4 gate-level systolic array works (35%)

A 4×4 weight-stationary systolic array with **no black boxes anywhere**.

```
matmul4x4  →  systolic_4x4 (16 PEs)  →  PE_cell
                                          ├── mul_32b   (carry-save, hand-built)
                                          ├── ks_32b    (Kogge-Stone accumulator)
                                          └── 3 registers (W, activation, psum)
```

Logisim's built-in `Multiplier` and `Adder` have both been ripped out of `PE_cell` and replaced with the gate-level blocks from the CPU. **The multiplier is the shared primitive** — the CPU's `MUL` and the NPU's MAC are the same circuit.

| Block | Status |
|-------|--------|
| `PE_cell` (weight-stationary MAC) | ✅ fully gate-level — `w=5, a=7, psum_in=3 → 0x26` |
| `systolic_4x4` (16 PEs) | ✅ works |
| `matmul4x4` (+ skew registers) | ✅ 16 real weight inputs; identity test passes |
| INT8 (`mul_8b`) | ☐ 8× lighter → 8× more PEs per LUT |
| Wallace tree (vs CSA chain) | ☐ raises clock (6-deep → ~3-deep) |
| pipelined PE · scale · CPU dispatch | ☐ |

**Cost of transparency:** `mul_32b` ≈ 7,300 gates × 16 PEs ≈ **117,000 gates**. Logisim crawls — which is exactly the argument for INT8 (`mul_8b` ≈ 950 gates). Array size is a *parameter*, not a design: get the PE right, then tile it N×N to whatever the silicon allows.

---

## Architecture — the compute core

```
        A(32)   B(32)
          │       │
   ┌──────┴───────┴─────────────────────────┐
   │  logic_unit ──────────► out_mux 00      │
   │  arithmetic_engine ───► out_mux 01      │   engine_sel(2) picks one
   │    (ks_32b + invert + Cin mux)          │
   │  mul_32b ─────────────► out_mux 10      │
   │  (reserved: FPU) ─────► out_mux 11      │
   └───────────────┬─────────────────────────┘
                   ▼
              result(32) ─► N Z C V
```

All three engines read the same operands and compute in parallel every cycle; the 4:1 `out_mux` selects one. Slot 11 is reserved headroom for a future FPU.

### The multiplier — carry-save, fully gate-level

`mul_32b` computes `Rm × Rs → low 32 bits` (ARM `MUL`, §4.7) the way a real CPU does — a carry-save reduction tree, **not** shift-and-add:

```
partial_products ──► CSA reduction (30 × 3:2 compressors) ──► ks_32b ──► product
  32 AND rows            32 vectors → 2 vectors               one real add
```

- **partial_products** — 32 rows, `row_i = (Rm AND broadcast(Rs[i])) << i`. Broadcast is a sign-extended single bit; the shift is pure wire placement.
- **csa_3to_2** — 3:2 compressor: `sum = X⊕Y⊕Z`, `carry = maj(X,Y,Z) << 1`, inter-bit carry **unchained** → constant delay, no ripple. That is the carry-save trick.
- **csa_reduction_chain** — 30 tiles collapse 32 vectors to 2 (`32 − 2 = 30`; each 3:2 tile removes one vector).
- **ks_32b** — the single carry-propagate add resolving the final `(sum, carry)` pair.

Verified: `0xFFFFFFFF² = 0x1`, `0xDEADBEEF² = 0x216DA321`, `255² = 0xFE01`, `13×11 = 0x8F`, `0x9E3779B9 × 0x7F4A7C15 = 0xCFFC982D`.

---

## Verification — *trust the circuit, verify the human*

Every sealed block gets a **discriminator test**: a single input that uniquely exposes the bug (e.g. all-zeros + Cin=1 → `0x1` for the adder; `0xFFFFFFFF² → 0x1` for the multiplier).

`armv4t_alu.py` is the **golden software oracle** — the ALU's 16-op table, flag logic, and decode ROM modeled in Python. The gate-level ALU must match it bit-for-bit.

```bash
python3 armv4t_alu.py --test        # 10 golden edge cases (all pass)
python3 armv4t_alu.py --decoder     # opcode → ROM word → controls → result + flags
python3 armv4t_alu.py --legend      # full control-signal + flag reference
python3 armv4t_alu.py 0xAA 0xBB 1   # any A, B, Cflag
python3 build_regression_roms.py     # regenerate 12 CPU regression ROMs
```

The complete CPU regression procedure and expected signatures are in
[`regression_roms/README.md`](regression_roms/README.md). All 12 tests pass.

---

## Repository

```
armv4t.circ             Logisim Evolution project — the V2 build (sealed compute core + multiplier)
ALU_modular_design.circ V1 build — datapath primitives (reg16x32, PC_fetch, ...) + V1 systolic NPU
armv4t_alu.py           golden software oracle for the ALU
opcode                  decode ROM image (Logisim v3.0 hex)
regression_roms/        12 verified CPU instruction images, including RAM
c_tests/                GCC ARM7TDMI/ARM-state leaf-C build and ROM generator
```

---

## Roadmap

```
multiplier ─┬─► CPU MUL/MLA                              ✅ done
            └─► NPU MAC → PE → systolic array → YOLO     (reuses mul_32b)

register file ✅ ─► fetch ✅ ─► shifter ✅ ─► CPSR/conditions ✅
                                                              ↓
                                              B/BL/BX + compiled leaf C ✅
        ↓
  LDR/STR + RAM + stack ─► practical compiled C
        ↓
  5-stage pipeline ─► NPU (INT8) ─► benchmark vs Hailo-8L
```

---

## A lesson worth keeping

Logisim's multi-input XOR gate computes **"exactly one input high" (1-of-n), not odd parity**, for 3+ inputs — so a 3-input XOR gives `4 ⊕ 4 ⊕ 4 = 0`. Build parity from **chained 2-input XORs**. Every 2-input test passes, so this hides beautifully until a carry-save sum quietly drops bits.

---

## Hardware & references

- **Design:** Logisim Evolution · **Synthesis:** Quartus Prime Lite
- **Boards:** DE10-Lite (MAX 10) now; Arty A7 for the NPU scale-up
- **Spec / oracle:** ARM DDI 0084D (ARM7TDMI-S)
- **NPU benchmark target:** Hailo-8L + Raspberry Pi 5
