# CLAUDE.md — CustomCPU Project

> Persistent project memory for Claude Code. Read this first, every session.
> This is a gate-level CPU + NPU build. The whole point is **transparency**:
> every block is understood down to the gate. Respect that.

---

## 0. HOW TO WORK WITH ME (read before anything else)

**Learning profile — teach and build this way. This is canon.**

Systems-builder learner with invariant-based reasoning and visual-mechanistic
processing. Teach like an engineer assembling a machine, not a student reading
a chapter.

1. **Mechanism-first construction.** Start from a working/semi-working artifact,
   reverse-derive the rules. Abstract-first loses me; a concrete artifact sticks.
2. **Invariant-driven.** Anchor on "what must stay true?" (overflow flags,
   register flow, carry propagation), not definitions. Present concepts as
   constraints, flows, conserved properties.
3. **Diagram → relationship → language.** Lead with spatial/structural models
   (wiring, signal flow, state transitions). Words land after I can picture it.
4. **Iterative adversarial probing.** I learn by pushing back and forcing edge
   cases. Don't treat me as a passive learner; expect challenges.
5. **Tight feedback loops, short scopes.** Long narrative overwhelms. One block,
   one invariant, one probe at a time. Frame as progressing the system.
6. **Identity/output-anchored.** Connect to my builds (this CPU, the NPU, edge
   AI). Detached abstract examples don't stick.

**Communication:** Direct and brief. "Bro just give it" = stop explaining,
execute. Minimal padding; code/schematics over derivation prompts.

**Build rule:** "If I can't *explain* the block, I don't get to use it."
Logisim built-ins allowed if I can explain them. Structural VHDL = fine (it's
gates as text). Behavioral VHDL (`a*b`) = black box, only for oracles/testing.

**Verification standard:** every sealed block gets a **discriminator test** — a
single input that uniquely exposes the bug (e.g. all-zeros + Cin=1 → 0x1 for the
adder; 0xFFFFFFFF² → 0x1 for the multiplier). Trust the circuit, verify the human.

---

## 1. THE GOAL

Build a gate-level, transparent, open CPU + INT8 NPU, culminating in:
- A working ARMv4T CPU (the **learning artifact**), then
- A RISC-V/ARMv6-class **forever-machine**: open, customizable, ~1 GHz (ASIC),
  MMU → real Linux, with a hand-built INT8 systolic NPU benchmarked vs Hailo-8L.
- **Research target:** transparent gate-level NPU vs commercial silicon (ACM
  SIGCSE / IEEE FPGAworld). The *gap*, precisely measured and explained, is the thesis.

**North star (clarified):** something that computes, runs real Linux, is forever
mine, all open-source, customizable, fast enough (~1 GHz). This DERIVES to an
open ISA (RISC-V or a v6-class ARM), because "forever mine + customizable +
shippable" is structurally impossible on proprietary ARM. ARM = learning; the
open ISA = the machine I keep.

**Reference chip:** SOPHGO SG2002 (Milk-V Duo, ~$8) — 1GHz C906 RISC-V + INT8 TPU.
Can't clone the whole SoC (4 ISAs + codecs + ISP), but CAN clone its *brain*:
one core + INT8 NPU + DRAM + PCIe. The C906 is fully open (Apache 2.0,
github.com/XUANTIE-RV/openc906) — datasheet + RTL + testbench = spec + oracle.
Important boundary: the public OpenC906 RTL is open, but the complete SG2002 SoC,
its NPU, multimedia system, and physical implementation are not. Do not assume the
public RTL is bit-for-bit identical to SOPHGO's hardened C906 integration.

**Two parallel project tracks (do not merge their ISA-specific state):**

1. **ARM learning line:** finish ARMv4T single-cycle + C, pipeline it, then build
   independently designed ARMv5/v6/v7-A-inspired generations toward understanding
   the Raspberry Pi 2's Cortex-A7 class. A literal Cortex-A7 implementation is
   proprietary; ARM compatibility/distribution also carries ARM licensing issues.
2. **Open machine line:** fork only after the C-capable baseline is verified, replace
   ARM decode/CPSR with RV32I, then grow RV32M -> pipeline -> caches/DDR -> RV64 or
   OpenC906 integration -> NPU/GPU -> PCIe. This is the distributable forever-machine.

Shared library between tracks: adders, multipliers, shifters, RAM interfaces, DMA,
NPU/GPU blocks, test oracles, and FPGA/ASIC measurement. Do not carry ARM CPSR,
conditional execution, ARM decode, or ARM PC rules into the RISC-V core.

**Public-precedent audit:** individual pieces exist, but no publicly indexed exact
match was found for canonical ARMv4T + hand-built Logisim datapath + C toolchain +
shared gate-level INT8 systolic NPU + FPGA/ASIC measurements. Closest references:
OpenC906 (open production-class RISC-V), ZAP (Verilog ARMv4T core), Logisim ARM
textbook processors, and “Crabs All the Way Down” (ARM-ish gates running Rust).
Novelty is the transparent integration and apples-to-apples methodology, not the
individual adder, CPU, or systolic-array ideas. Never claim “first ever.”

---

## 2. CURRENT STATE — 🎉 M1 REACHED: THE CPU EXECUTES INSTRUCTIONS (2026-07-14)

```
COMPUTE CORE ................ 100% ✅ DONE (3 engines: logic, arith, mul)
  ks_32b (Kogge-Stone adder) ....... sealed, verified
  arithmetic_engine (8 ops) ........ sealed, verified   → out_mux slot 01
  logic_unit (6 ops) ............... sealed, verified   → out_mux slot 00
  mul_32b (multiplier engine) ...... sealed, verified   → out_mux slot 10
  ALU (16 ops + MUL) ............... SEALED — 16 ops vs oracle + MUL slot 10 verified
  decode ROM (opcode → controls) ... built, verified
  (out_mux slot 11 reserved for future FPU)

MULTIPLIER .................. ~95%  ✅ WORKS (32×32→low32, verified)
  PP_row ........................... SEALED (Bit Extender 1→32 sign + 32-bit AND)
  partial_products ................. SEALED (32× PP_row + per-row shift«i)
  csa_3to2 ......................... SEALED (chained-2 XOR sum + maj + «1 carry)
  csa_reduction_chain .............. SEALED (30 tiles, 32 vectors → 2)
  mul_32b (chain + ks_32b) ......... SEALED & WIRED into ALU out_mux slot 10
                                     (engine_sel=10), sibling to arith/logic engines.
                                     verified standalone AND through ALU:
                                     DEADBEEF²=0x216DA321, FFFFFFFF²=1, 255²=0xFE01,
                                     13×11=0x8F, 9E3779B9×7F4A7C15=0xCFFC982D (N=1 Z=0)
  mul_32b final ks_32b add ......... ✅ VERIFIED in ALU/PE result paths

DATAPATH / CONTROL FLOW ..... ~99% ✅ OPERAND2 + CPSR + B + BL + BX
  register file (16×32) ............ ✅ imported from V1 (reg16x32, 2R/1W) + verified in V2
  PC / fetch ....................... ✅ imported from V1 (PC_fetch) + verified in V2
  instr_rom (16×32) ................ ✅ built & wired (addr = PC[5:2], word-addressed)
  integration → FIRST INSTRUCTION .. ✅✅ DONE — the "it's alive" milestone. M1 REACHED.
                                     pc_fetch → instr_rom → splitters → decode_rom
                                     → reg16x32 → ALU → writeback.  Wired per BUILD_CPU.md.
                                     Ran `boot_rom` (16 instrs) clean end-to-end.
  write_enable suppress path ....... ✅ VERIFIED (CMP leaves Rd untouched — see below)
  barrel shifter ................... ✅ BUILT & STANDALONE-VERIFIED (bs_stage_1/2/4/8/16 + barrel_32b)
  operand2 register path ........... ✅ VERIFIED (immediate-shift LSL/LSR/ASR/ROR)
  operand2 immediate path .......... ✅ VERIFIED (zext imm8, rotate*2, I-bit muxes)
                                     MOV #FF -> R3=FF; MOV #80000000 -> R4=80000000;
                                     ADD R5,R3,#80000000 -> R5=800000FF
  CPSR flag register ............... ✅ VERIFIED for arithmetic NZCV + S-bit gating
                                     regression: 0 -> 6 -> 6 -> 9 -> 8 -> A
  shifter carry into CPSR.C ........ todo for flag-setting logical instructions
  condition check .................. ✅ VERIFIED (cond[4] × NZCV → condition_pass)
                                     MI/EQ committed; PL/NE suppressed writes
                                     reg_WE = ALU.write_enable AND condition_pass
                                     CPSR.enable = S AND condition_pass
  decoder extension ................ todo (top-level MUL selection, LDR/STR)
  ARM B branch ..................... ✅ VERIFIED (forward skip, backward BNE loop, self-loop)
  ARM BL call ...................... ✅ VERIFIED (PC+4 -> R14, function call + BX LR return)
  ARM-state BX ..................... ✅ VERIFIED (`BX R2`, `BX LR`, absolute target)
  compiled C leaf test ............. ✅ TOOLCHAIN + TEST ADDED (`c_tests/add.c`)
                                     GCC targets ARM7TDMI/ARM state and emits
                                     `ADD R0,R0,R1; BX LR`; see C_LEAF_CPU_TEST.md

  ### boot_rom — THE BRING-UP PROGRAM (self-bootstrapping, needs NO poked registers)
  The old `instr_rom` required poking R1=5, R2=3 by hand. `boot_rom` does not:
  every register resets to 0, and the program MANUFACTURES its own constants.
    MVN R1,R0     → R1 = 0xFFFFFFFF   (turn the reset-zero into all-ones)
    SUB R2,R0,R1  → R2 = 0x00000001   (0 − 0xFFFFFFFF = 1 → now you have a ONE)
    ...ADD chain builds 3 and 5...
    ADD R3,R5,R4  → R3 = 0x00000008   ★ M1
    CMP R5,R4     → R3 STAYS 0x8      ★ write_enable suppress
    ...AND/ORR/EOR/BIC/MOV/MVN/RSB/SUB exercise every remaining engine path...
  Final regfile: R1=FFFFFFFF R2=1 R3=8 R4=3 R5=5 R6=1 R7=7 R8=6 R9=4 R10=5
                 R11=FFFFFFFC R12=2 R13=FFFFFFFE
  Regenerate:  python3 asm.py --init R0=0 "MVN R1,R0" "SUB R2,R0,R1" ... --rom boot_rom

  **TWO DISCRIMINATORS THIS PROGRAM CARRIES (both passed):**
   1. `SUB R2,R0,R1` (= 0 − 0xFFFFFFFF = 1) is the ARITH discriminator. It is the
      ONLY instruction that proves b_inv AND cin_sel=01 BOTH work. b_inv dead →
      0xFFFFFFFF; Cin mux stuck at 0 → 0x00000000. A plain `5−3` test passes with
      EITHER bug and still prints a plausible number. Same shape as the dropped-carry
      trap: one input in the whole program can see it.
   2. `CMP R5,R4` is the WRITE_ENABLE discriminator. ALU.result legitimately shows
      0x2 (CMP really does compute 5−3 and throw it away) — the test is that the
      CLOCK EDGE WRITES NOTHING, so R3 must still read 0x8 after the tick. If
      write_enable never reaches reg16x32's load-enable gating, all 15 OTHER
      instructions still give perfect answers and only R3 quietly becomes 0x2.

  **THE CLOCK-EDGE INVARIANT (the off-by-one that confuses every probe):**
  ONE edge does TWO things at once — it captures the ALU result into Rd AND advances
  the PC. So the instruction displayed on `instr_rom.data` is NEVER the one whose
  result just landed.
    · COMBINATIONAL (settled BEFORE the tick, no clock needed): instr_rom.data,
      dec_addr, decode_rom.data, RD_A, RD_B, ALU.result, N/Z/C/V.
      → the ALU answer is ALREADY on the wire before you press Ctrl+T.
    · CLOCKED (changes ONLY on the edge): the PC register, the 16 registers.
      → the tick merely STORES what was already there.
  **Probe rule: read ALU.result BEFORE the tick, read the register AFTER it.**
  `boot_rom` is ORDER-DEPENDENT (registers carry state forward) — run it from PC=0
  straight through. Ctrl+R mid-run wipes the constants it built. Tick 16 wraps the
  4-bit ROM address back to 0 and re-runs MVN on top of your finished state; stop at 16.

MEMORY ...................... 0%   ☐
  LDR/STR, data RAM, load writeback mux, stack. B/BL/BX are done; memory is next.

PIPELINE .................... 0%   ☐  (the clock lever, AFTER single-cycle works)
NPU ......................... ~35% ✅ 4×4 GATE-LEVEL NPU WORKS (32-bit) — M2 core done
  mul_32 .......................... partial_products + 30× csa_3to_2 + ks_32b → product(32)
                                    (the internal ks_32b is MANDATORY — see dropped-carry trap)
  PE_cell ......................... weight-stationary MAC, FULLY GATE-LEVEL:
                                    mul_32 + ks_32b(accumulator) + 3 Registers.
                                    Both Logisim black boxes (Multiplier, Adder) REMOVED.
                                    ✅ VERIFIED: w=5,a=7,psum=3 → 0x26 ·
                                    w=a=0xFFFFFFFF,psum=0 → 0x1 · w=0 → psum passes through
  systolic_4x4 (16 PEs) ........... works
  matmul4x4 ....................... FIXED: ripped out the hardwired Constant 0xF;
                                    now 16 real weight pins (w00..w33).
                                    ✅ identity test PASSES (diag w=1, a=(1,2,3,4) → 1,2,3,4)
  ** every gate from matmul4x4 down to the last AND is hand-built. **

  COST: mul_32b ≈ 7,300 gates × 16 PEs ≈ 117,000 gates. Logisim crawls at 4×4.
  Verify bottom-up (PE_cell alone → Systollic_2x2 → matmul4x4 once).

  REMAINING (parked, in payoff order):
   1. INT8 (mul_8b, 8×8→16) ....... ✅ BUILT & SEALED (~950 gates, 8× lighter)
      pp_row_16 → partial_products_8 → csa_chain_8 (6 tiles) → ks_32b → product(16)
      verified: 0xFF×0xFF=0xFE01, 0xBE×0xEF=0xB162, 13×11=0x8F, 0x7F²=0x3F01
      **TWO EXTENDER GOTCHAS (cost real time, do not repeat):**
        · Rm 8→16 must be **ZERO** extend (widening a VALUE).
          Sign-extend bug → 0xBE became 0xFFBE → rows read FFBE,FF7C,FEF8...
        · Rs_bit 1→16 must be **SIGN** extend (broadcasting a MASK, 1→0xFFFF).
      **The chain NEVER outputs the product** — only (sum,carry) that ADD to it.
        Reading chain.sum as the product gives 0x7E81 instead of 0xFE01.
        ks_32b resolves them: zext(sum,16→32) + zext(carry,16→32) → low 16 = product.
      NEXT: swap mul_8b into PE_cell (needs port re-width: w_in/a_in 32→8, psum stays 32,
      plus a SEPARATE ks_32b for the accumulate — mul_8b already has one inside).
   2. TREE not CHAIN ............... csa chain is 30-deep (mul_32b) / 6-deep (mul_8b).
      Fine for the single-cycle CPU; it CAPS THE CLOCK for a 150MHz NPU. Wallace tree ~3-deep.
   3. pipeline the PE (reg between multiply and accumulate)
   4. THEN scale the grid. Array size is a PARAMETER, not a design — build the PE right,
      tile it N×N. 8×8 INT8 ≈ 35K LUTs (fits Arty A7). 16×16 ≈ 140K. 32×32 ≈ 560K (ASIC only).
   5. streaming/tiling control layer + CPU dispatch (MMIO / undefined-instr space)
   6. synthesize → measure real GOPS → benchmark vs Hailo-8L (13 TOPS). The gap IS the thesis.
```

---

## 3. SEALED BLOCKS (do NOT reopen — verified & locked)

### ks_32b — 32-bit Kogge-Stone adder/subtractor
- Structure: `kogge_stone_1b` (g=A·B, p=A⊕B, sum=p⊕Cin); `pg_cell`
  (G_out=G+P·G_prev, P_out=P·P_prev); 5 prefix stages (reach 1,2,4,8,16).
- **CRITICAL ASYMMETRY (do not "clean up" on port):** `s1_1` must read BOTH
  G_prev and P_prev from `s1_0`'s *outputs* (Cin-folded values), not raw g0/p0.
  `s1_0.P_prev` tied to Constant 0. This propagates Cin into upper carries.
- **Discriminator test:** all-zeros + Cin=1 → must give 0x1 (bad wiring → 0x55555554).
- Subtract: beff = B XOR SUB (32-bit XOR + Bit Extender 1→32 broadcasting SUB);
  Cin=SUB; Cout=1 means no borrow.

### arithmetic_engine
- Wraps ks_32b with A-invert + B-invert XOR layers (inline, not subcircuits) +
  4:1 Cin mux (inputs: 0, 1, Cflag; slot 3 unused).
- Interface: A(32), B(32), Ainv(1), Binv(1), Cin_sel(2), Cflag(1) → result(32), Cout(1).
- Control: ADD(0,0,00), SUB(0,1,01), RSB(1,0,01), ADC(0,0,10), SBC(0,1,10), RSC(1,0,10).

### ALU (alu_32b) — SEALED, all 16 ops verified
- Inputs: A(32), B(32), a_inv, b_inv, Cflag, cin_sel(2), logic_sel(3),
  engine_sel(2), unused, write_enable.
- Outputs: result(32), N, Z, C, V, write_enable (pass-through).
- **out_mux is 4:1** (engine_sel 2 bits): 00=logic, 01=arith, **10=mul_32b (WIRED,
  verified)**, 11=RESERVED (FPU). The multiplier dropped into slot 10 with zero
  changes to the sealed logic/arith paths — designed headroom worked exactly as planned.
  N/Z auto-correct for MUL (computed off the muxed result); C/V are don't-care for MUL.
- Flags: N=result[31]; Z=32-in OR→NOT; C=arith Cout; V via Option-B-lite:
  Aeff31=A[31]⊕a_inv, Beff31=B[31]⊕b_inv, V=XNOR(Aeff31,Beff31) AND XOR(res31,Aeff31).
- **write_enable = pass-through pin.** ALU carries it, register file obeys it,
  DECODER computes it (write=0 for 10xx = TST/TEQ/CMP/CMN). Flags still update
  for those; only register write is suppressed.
- Verified: 0x7FFFFFFF+1→0x80000000 N1Z0C0V1; 0xFFFFFFFF+1→0 N0Z1C1V0
  (C/V independence); AND(0x9E3779B9,0x7F4A7C15)=0x1E027811.

### decode ROM — SEALED
- 16 entries × 10-bit control words, addressed by opcode[24:21].
- Layout MSB→LSB: `[engine_sel(2) | a_inv | b_inv | cin_sel(2) | logic_sel(3) | write]`
- **ROM is now GENERATED from the oracle's TABLE — never hand-type it:**
  `python3 armv4t_alu.py --rom` rewrites `opcode`. `--decoder` prints the full
  addr→ROMword→controls→result+flags table for all 16 ops **+ MUL**.
- **ROM load string (32 words, 5-bit address, 10-bit data):**
```
v3.0 hex words addressed
0000: 001 003 151 191 101 121 161 1a1 000 002 150 100 005 007 009 00b
0010: 201 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000
```
- **MUL = ROM addr 0x10, word 0x201** (engine_sel=10, write=1, rest 0).
  MUL is NOT a data-proc opcode — real ARM's MUL has opcode[24:21]==0000 which
  COLLIDES with AND (distinguished by bits[7:4]==1001). So the ROM address widens
  to 5 bits; bit4 = `is_MUL`. Set **ROM Data Bits = 10** (0x201 needs bit 9).
- Old `opcode` file had stale junk at 0x10/0x11 (duplicate BIC/MVN) — fixed.
- **CRITICAL:** splitter must map engine_sel to ROM output bits **[9:8]** (the two
  HIGHEST bits). Bug found & fixed: engine_sel was reading low bits → ran ADD
  instead of AND. Fix: bit[9:8]→engine_sel, [7]→a_inv, [6]→b_inv, [5:4]→cin_sel,
  [3:1]→logic_sel, [0]→write.
- LOGIC addresses (engine=00): 0,1,8,9,C,D,E,F.  ARITH (engine=01): 2,3,4,5,6,7,A,B.
- Any ROM word starting 0x1 = arith; 0x0 = logic (engine_sel bit visible in top hex digit).

### PP_row — one partial-product row — SEALED
- `row = Rm AND sext(Rs_bit)`. Bit Extender 1→32 **Sign** broadcasts the single Rs bit
  across all 32 lanes; 32-bit AND with Rm.
- **Discriminator:** Rs_bit=1, Rm=0xDEADBEEF → 0xDEADBEEF; Rs_bit=0 → 0.
  (Zero-extend-by-mistake bug → 0x00000001.)

### partial_products — 32-row AND array — SEALED
- 32× PP_row. Row i fed **Rm (shared bus, read-only net)** + **Rs[i]** (from a 32-fanout
  splitter). Rm = the multiplicand broadcast; Rs = the per-row selector.
- Each row shifted left by i via **Shifter (Logical Left, constant amount = row index i)**;
  row 0 = plain wire. Shift = wire placement; low-32 truncates any bit ≥ 32.
- **Verified:** walking-1 (Rm=1, Rs=0xFFFFFFFF → P_i = 1<<i staircase); truncation
  (Rm=0x80000000, Rs=3 → P_0=0x80000000, P_1=0); 13×11 (P0=0xD, P1=0x1A, P3=0x68).
- Outputs P_0..P_31 feed the CSA tree (no summation in this block).

### ⚠ THE DROPPED-CARRY TRAP (false positives that fooled us twice)
A CSA chain outputs **(sum, carry)** — NEVER the product. `product = sum + carry`.
If you wire only `sum` downstream, **most tests still pass**, because the final carry is
frequently 0 for sparse/typical operands:
```
DEADBEEF²          sum=0x216DA321  carry=0x00000000   sum alone LOOKS right  ✓ (lucky)
9E3779B9×7F4A7C15  sum=0xCFFC982D  carry=0x00000000   sum alone LOOKS right  ✓ (lucky)
FFFFFFFF²          sum=0x80000001  carry=0x80000000   sum alone = 0x80000001 ✗ CAUGHT
```
**ONLY the all-ones case forces a nonzero final carry.** Hence `0xFFFFFFFF² == 0x1` is THE
discriminator — never seal a multiplier without it. (Same at 8-bit: `0xFF² == 0xFE01`;
`mul_8b` briefly read 0x7E81 = its `sum` vector.)

Corollary for **PE_cell**: identity tests use w=0/1, and with w=1 the partial products are
disjoint bits → carry is ALWAYS 0 → a dropped carry hides. Probe with **w=5, a=7,
psum_in=3 → psum_out=0x26** (w≥2 generates real carries).

**THE FIX (one change fixed both the ALU and the NPU):** put the final `ks_32b` INSIDE
`mul_32`, so it exports a single `product(32)` pin instead of `sum`/`carry`. Then:
  · ALU out_mux slot 10 takes `mul_32.product`  → MUL correct
  · PE_cell's existing `ks_32b` becomes the ACCUMULATOR: `product + psum_in → psum_reg`
A CSA-chain block must ALWAYS export the resolved product, never the raw (sum,carry).
Anything that exports two vectors WILL eventually get one of them dropped.

**PE_cell verified:** w=5,a=7,psum_in=3 → 0x26 · w=a=0xFFFFFFFF,psum=0 → 0x1 ·
w=0,a=0xDEADBEEF,psum=0x1234 → 0x1234 (pass-through). a_out passes activation untouched.
Note: tick the clock TWICE (a_reg latches, then psum_reg captures) with inputs held.

### csa_3to2 — 3:2 carry-save compressor — SEALED
- **LOGISIM XOR TRAP (cost hours):** Logisim's multi-input XOR gate does NOT compute odd
  parity for ≥3 inputs — it computes "exactly one input high" (1-of-n). So a 3-input XOR
  gives `4⊕4⊕4 = 0` and `7⊕14⊕28 = 0x11` (1-of-n per bit), NOT the parity `0x15`.
  2-input XOR is parity AND 1-of-n at once, so every 2-input discriminator passed and hid
  the bug. FIX: build sum as CHAINED two 2-input XORs → `(X⊕Y)⊕Z`. Never trust a 3-in XOR.
  (3-input OR is fine — "any high" is unambiguous — which is why the maj/carry path was
  always correct; only the sum/XOR path was poisoned.)
- `sum = (X⊕Y)⊕Z` (TWO chained 2-in XORs, 32b). `maj = XY+XZ+YZ` (three 32b ANDs + one 3-in OR).
  `carry = maj << 1` (Shifter Logical-Left const 1). All 32 lanes parallel, **carry NOT
  chained between bits** → constant delay, no ripple. This is the "carry-save" trick.
- **Invariant:** `X + Y + Z == sum + carry`  (mod 2³²).
- **Verified:** (1,1,1)→sum=1 carry=2; (1,1,0)→sum=0 carry=2; (1,0,0)→sum=1 carry=0;
  (0x80000000, 0x80000000, 0)→sum=0 carry=0 (top-carry truncation, low-32).

---

## 4. THE ORACLE — armv4t_alu.py

Python software model = golden reference the gate ALU must match. Encodes the
16-op TABLE, models the arith engine (invert layers + Cin mux + add), V via
Option-B-lite, and the decode ROM (rom_word()).

```
python3 armv4t_alu.py               # clean box table (default)
python3 armv4t_alu.py --decoder     # FULL decode test: addr → ROM word → controls
                                    #   → result+flags, all 16 ops + MUL @ 0x10
python3 armv4t_alu.py --rom         # REGENERATE the `opcode` ROM image from TABLE
python3 armv4t_alu.py --md          # markdown table (for docs)
python3 armv4t_alu.py --legend      # box table + full signal reference
python3 armv4t_alu.py --test        # 15 golden-case selftest incl. MUL (ALL PASS)
python3 armv4t_alu.py 0xAA 0xBB 1   # any A, B, Cflag

BARREL SHIFTER (see BUILD_SHIFTER.md):
python3 armv4t_alu.py --shiftstages          # ← BRING-UP TABLE: one stage at a time,
                                             #   WITH per-stage type-COLLISION detection
python3 armv4t_alu.py --shiftstages 0x9E3779B8   # the second (bit0=0) probe vector
python3 armv4t_alu.py --shiftsep    # PROVES no single vector separates all 4 types at «1
python3 armv4t_alu.py --shift X     # full amt-sweep table
python3 armv4t_alu.py --shiftproof  # 5 staged shifts == 1 direct shift (1280 cases, 0 bad)

`rom_word(addr)` is the single source of truth: engine_sel<<8 | a_inv<<7 |
b_inv<<6 | cin_sel<<4 | logic_sel<<1 | write. Verified: the 16 generated words
reproduce the hand-typed ROM byte-for-byte, and MUL adds 0x201 at addr 0x10.
```

Header contains the full learning profile + invariants + control interface +
ROM contents. Self-test = 10 discriminator cases incl. both C/V independence proofs.

---

## 5. THE MULTIPLIER — DONE & WIRED INTO THE ALU

**STATUS:** MULTIPLIER WORKS AND IS LIVE IN THE ALU (out_mux slot 10, engine_sel=10).
Verified standalone and through the ALU: DEADBEEF²=0x216DA321, FFFFFFFF²=0x1,
255²=0xFE01, 13×11=0x8F, 8²=0x40, 9E3779B9×7F4A7C15=0xCFFC982D (N=1 Z=0).
Structure: partial_products → csa_reduction_chain (30 tiles) → ks_32b.
Per-row shift = Shifter(Logical Left, const=i). Sum path uses CHAINED 2-in XORs
(Logisim 3-in XOR = 1-of-n, not parity — see §3 trap).

**Scope decided:** MUL first (32×32 → low 32 bits, ARM §4.7). Then MLA
(multiply-accumulate = the MAC = bridge to NPU). MULL (64-bit) later.

**Architecture (carry-save tree — the real-CPU way, NOT shift-and-add):**
```
partial_products (AND array)  →  csa_tree (3→2 compressors)  →  ks_32b (final add)
```
- **partial_products invariant:** row i = Rm masked by Rs[i] (AND via Bit Extender
  1→32 broadcast), shifted left by i (shift = WIRE PLACEMENT, not logic). Low-32
  MUL → only columns 0-31 matter.
  - Build as `PP_row` subcircuit (Bit Extender + 32-bit AND), instanced 32×.
  - Test: Rs_bit=1 → row=Rm; Rs_bit=0 → row=0. Then Rm=1101,Rs=1011 → 4 rows sum to 143.
- **csa_3to2:** a full adder used with carries UNCHAINED (constant delay, no ripple).
  sum[i]=x⊕y⊕z, carry[i]=majority(x,y,z) shifted <<1.
- **csa_tree:** stack CSAs, 3→2 each layer, 32 rows → 2 vectors (~8 layers).
- **mul_32b:** tie the 2 vectors into ks_32b (the ONE real carry-propagate add).
- **Discriminator test:** 0xFFFFFFFF × 0xFFFFFFFF = 0x00000001 (low 32 bits).
- **KEY:** MUL low-32 signed == unsigned (no sign handling needed).

**This multiplier is the SHARED PRIMITIVE:** it's the CPU's MUL/MLA *and* the cell
inside every NPU systolic PE. V1's PE_cell uses Logisim's built-in Multiplier
(black box) — the gate multiplier REPLACES it, making the array fully gate-level.
PE_cell (Multiplier+Adder+Register) = a MAC = MLA (same primitive).

---

## 6. DATAPATH — register file + fetch imported; barrel shifter built

### register file (16×32) — ✅ IMPORTED FROM V1, verified in V2
Copied `reg16x32` out of `ALU_modular_design.circ` (V1) into `armv4t.circ`. Came over
intact: 59 comps / 466 wires = 16× Register, 1× Decoder (write select), 2× Multiplexer
(the two read ports), 16× AND (write-enable gating). Already 2-read/1-write — no rebuild.

**Interface (the invariant):**
```
READ  (combinational): Rn_addr(4), Rm_addr(4) → Rn_data(32), Rm_data(32)  [two 16:1 muxes]
WRITE (clocked):       Rd_addr(4) → 4:16 decoder, each line AND write_enable → load enable
```
- write_enable (from the decoder) finally ACTS here: register i loads ⟺
  (Rd_addr==i) AND write_enable. For TST/TEQ/CMP/CMN, no register loads.
- R15/PC: in-file slot for first-light single-cycle; refactor to separate-PC
  mapped into address 15 when building fetch.
- This establishes the clean **memory seam** the future MMU plugs into (VA=PA now).

### PC / fetch — ✅ IMPORTED FROM V1, verified in V2
Copied `PC_fetch` → `pc_fetch` (14 comps: PC Register + 2 Adders + branch Multiplexer
+ Splitter + 4 Constants). Drives the instruction stream.

**COPY NOTE (do not raw-merge the .circ files):** V1 and V2 have DIFFERENT library id
tables (V1: Plexers=2, Arithmetic=3, Memory=4 · V2: Memory=2, Base=3, Plexers=4,
Arithmetic=5). A file-level XML merge mis-maps every component. Copy INSIDE Logisim
(Ctrl+A / Ctrl+C in source circuit → Project→Add Circuit → Ctrl+V) — Logisim remaps libs.

### barrel_32b — ✅ BUILT, standalone-verified
```
input_32b(32), amnt(5), typ(2) → outp(32)
  typ: 00=LSL  01=LSR  10=ASR  11=ROR
```
- **Structure:** 5 sealed fixed-shift subcircuits chained in order:
  `bs_stage_1 → bs_stage_2 → bs_stage_4 → bs_stage_8 → bs_stage_16`.
  `amnt[0]..amnt[4]` drive each stage's enable; `typ` fans out to all stages.
  The data path is CHAINED, not parallel.
- **Stage interface:** `input_32(32), enable(1), typ_2(2) → out_1(32)`.
  Each stage uses four constant-amount Shifters feeding a 4:1 type mux, then a 2:1
  bypass mux (`enable=0` passes input unchanged; `enable=1` selects shifted).
- **Fill** into vacated bits encodes the type: 0 for LSL/LSR, sign bit for ASR,
  wrapped bits for ROR.
- **Standalone verification passed in Logisim:** with `input_32b=0x9E3779B9`,
  `amnt=0x1F`, `typ=10` produced `0xFFFFFFFF`; `amnt=0` bypasses unchanged; `amnt=1`,
  `0x11`, and `0x1F` matched the Python oracle.
- **Stage-1 discriminator:** `0x9E3779B9` alone is blind to ASR/ROR swap. The second
  probe `0x9E3779B8` exposes it: `ROR #1 → 0x4F1BBCDC`, while `ASR #1 → 0xCF1BBCDC`.
- `shifter_carry` is still NOT built. It cannot be tapped from the last stage; it is a
  separate parallel carry block from original input + total amount.

### Operand2 — ✅ REGISTER + IMMEDIATE PATHS VERIFIED
The top-level CPU shares one `barrel_32b` between both ARM Operand2 forms.

```
I=0: reg16x32.RD_B + instr[11:7] + instr[6:5] -> barrel_32b -> ALU.B
I=1: zext(instr[7:0]) + {instr[11:8],0} + type=ROR -> barrel_32b -> ALU.B
```

Three I-bit muxes select barrel input(32), amount(5), and type(2). Verification ROM:
`MOV R3,#FF; MOV R4,#80000000; ADD R5,R3,#80000000`. Final values:
`R3=000000FF`, `R4=80000000`, `R5=800000FF`. Diagnostic signature: if the final
immediate-amount wires are missing, R4 becomes `00000002` and R5 becomes
`00000101`; that proves imm8 selection works but rotation amount is stuck at zero.

### CPSR flag storage — ✅ VERIFIED

The 4-bit register stores `CPSR[3:0]=NZCV`. Its final enable is
`S AND condition_pass AND not_control_flow`. Arithmetic regression ROM:
`MVN; ADDS; MVN; ADDS; SUBS; SUBS` produced the required CPSR sequence
`0 -> 6 -> 6 -> 9 -> 8 -> A`. The repeated `6` proves S=0 preserves flags.
See `CPSR_CPU_TEST.md` and `cpsr_rom`.

### Condition execution — ✅ VERIFIED

`condition_checker` implements all ARM condition selections from stored
`CPSR.NZCV`. The CPU regression proved `MI` and `EQ` commit while false `PL` and
`NE` instructions leave their destination registers unchanged. Both register
writeback and CPSR enable are gated by `condition_pass`.

See `BUILD_CONDITION.md`, `CONDITION_CPU_TEST.md`, and `condition_rom`.

### ARM B branch — ✅ VERIFIED

`instr[27:25]=101`, `L=0`, and `condition_pass` drive `pc_fetch.BRANCH`.
`pc_fetch.IMM = sign_extend(instr[23:0] << 2) + 8`. The unconditional regression
jumped `pc_out 1 -> 3`, skipped `MOV R0,#2`, produced R1=5, then self-looped.
The conditional regression counted R0 from 2 to 0 with `BNE`, fell through with
CPSR=6, wrote R1=55, and self-looped.

See `BUILD_BRANCH.md`, `BRANCH_CPU_TEST.md`, `branch_rom`, and `branch_cond_rom`.

### ARM-state BX — ✅ VERIFIED

Exact `instr[27:4]=12FFF1` detection, condition gating, even-target gating,
`RD_B & FFFFFFFC` alignment, and the absolute-target path through `pc_fetch` are
integrated. Both `BX R2` and `BX LR` jumped `pc_out 1 -> 4`, skipped two MOVs,
wrote R3=33, and entered the expected self-loop.

See `BUILD_BX.md`, `BX_CPU_TEST.md`, `bx_rom`, and `bx_lr_rom`.

Next: BL/link writeback, memory, then shifter-carry cleanup.

---

## 7. ROADMAP (dependency order)

```
multiplier ─┬─► CPU MUL/MLA
            └─► NPU MAC → PE → systolic array → YOLO

register file ─► shifter/CPSR/cond/PC ─► integrate ─► FIRST INSTRUCTION (alive)
                    ↓
              single-cycle CPU ─► +memory/branch ─► runs compiled C
                    ↓
              5-stage pipeline ─► ~150 MHz (Arty A7)  [ONLY after single-cycle works]
                    ↓
              NPU (16×16 INT8) ─► ~77 GOPS ─► YOLOv8n ~9 FPS
```

**Milestones:**
- **M1:** ✅ **DONE (2026-07-14)** — datapath integrated, first instruction executed.
  `boot_rom` runs 16 instructions clean; `ADD R3,R5,R4 → R3 = 0x00000008`.
  Both discriminators passed (arith `0 − 0xFFFFFFFF = 1`; CMP write-suppress).
- **M2 core:** ✅ gate-level MAC and 4×4 systolic array work. Next NPU work is
  replacing each 32-bit PE multiplier with sealed `mul_8`, then pipelining/tiling.

**Minimum path to C from the current checkpoint:**

```text
BL + R14 link write
-> LDR/STR address/control
-> data RAM + ALU/load writeback mux
-> initialize R13 stack
-> startup assembly + linker script
-> compile freestanding ARMv4T C
```

After BX, a manually invoked leaf C function such as `ADD R0,R0,R1; BX LR` is
already nearly testable by seeding R0/R1/R14. A self-contained C program with
calls, locals, and a stack still needs BL and memory. Estimate from the observed
pace: leaf C ~1 focused session; stack-based C ~3-6 sessions; useful freestanding
C ~5-8 sessions. Memory is the remaining integration-heavy block.

---

## 8. KEY DECISIONS & INVARIANTS (learned the hard way)

- **Complete ≠ full.** Empty reserved mux slots = designed headroom, not unfinished
  work. ALU/decoder are DONE for the data-processing class; multiplier is a sibling
  unit that plugs into the reserved slot.
- **Sealed blocks are non-negotiable.** Once verified & sealed, don't reopen.
  Modularity is the project's structural integrity.
- **Asymmetries can be features.** The ks_32b Cin-fold asymmetry is correct; "cleaning
  it up" on port destroys correctness. Document invariants per subcircuit.
- **CSA vs chained KS:** chaining 31 adders pays carry-resolution 31× (~310 gate
  delays) for values nobody reads. CSA keeps partial sums redundant until one final
  add (~26 delays). That's why the multiplier uses a CSA tree.
- **Fixed-point is interpretive, not structural.** The ALU hardware is identical for
  integer and fixed-point; the binary point is a convention. Q16.16 add = integer add.
  Only MULTIPLY differs (keep a shifted window of the 64-bit product). Float needs a
  separate FPU (reserved out_mux slot 3). INT8 inference IS fixed-point → the NPU is
  the right regime.
- **The machine does OPS, not FLOPS** (no FPU). NPU throughput = MACs × clock × 2.
  A 4×4 array has 16 MAC/cycle (3.2 GMAC/s theoretical at 200 MHz); 16×16 has
  51.2 GMAC/s theoretical at 200 MHz. Real utilization may be 20-60% because of
  tiling and memory. Fifteen-FPS detection is model/resolution dependent: a 4×4 is
  too small for ordinary YOLO; a pipelined 16×16 or 32×16 INT8 array plus local
  DDR/BRAM/DMA is the plausible regime. Never state FPS from peak GOPS alone.
- **Pipeline AFTER single-cycle works.** Can't pipeline a datapath that doesn't exist;
  pipelining early = debugging correctness AND hazards on unproven logic. Order:
  datapath → single-cycle correct → verify → slice into 5-stage + forwarding.
- **200 MHz FPGA target:** 5 ns/stage. Likely stages are IF/ID/EX/MEM/WB with
  ~350-450 new pipeline-register bits, ~450-700 logical signal bits, and roughly
  1,000-2,500 additional Logisim wire segments. Current file has ~3,500 wire
  segments total. Pipelining alone is insufficient: multiplier must use DSPs or
  multiple stages, BRAM is synchronous, and forwarding/stall/flush logic is required.
  Modern midrange FPGA RTL may reach 150-250 MHz; direct structural Logisim export
  is likely much lower. Exact Fmax/LUTs come only from Quartus/Vivado timing reports.
- **Clock is substrate-bound:** FPGA soft-core ceiling ~200-300 MHz. Real GBA
  ARM7TDMI = 16.78 MHz, so even a 3-stage pipe (~60-80 MHz on DE10-Lite) beats it.
  1 GHz needs ASIC. Gate-level design ports CLEANLY to ASIC (it's already a netlist);
  open tapeout (Tiny Tapeout / SkyWater 130nm) is reachable (~$100-300).
- **74HC is wrong-scale:** ~4 gates/chip → hundreds of chips + thousands of wires for
  32-bit, ~1-5 MHz, NO NPU possible. FPGA is the right home; ASIC is the endgame.
- **YouTube is NOT a core-count problem:** the wall is video-decode hardware + GPU +
  MMU/Linux, none of which multicore fixes. Multicore gives parallel throughput, not
  app capability.
- **"iGPU":** GPU-as-COMPUTE (widen NPU to SIMD + dispatch) is achievable & natural;
  GPU-as-GRAPHICS (rasterizer) is a separate ~0%-reuse build; framebuffer+VGA is a
  modest separate block for pixels-on-screen.
- **Real Python:** MicroPython on v4T (bare-metal, real Python, reachable); full
  CPython needs v6+MMU+Linux (the forever-machine endgame).

---

## 9. v4T → v6 UPGRADE (the forever-machine path)

**~85% of the datapath transfers unchanged.** v6 is a BREADTH upgrade, not a rewrite.
- **Transfers:** ks_32b, arithmetic_engine, logic_unit, ALU, flags, register file
  (SAME 16×32), barrel shifter, multiplier, decode METHOD.
- **Add:** SIMD (your adder lane-split at bits 8/16/24 → 2×16 or 4×8 parallel — and
  SIMD INT8 directly helps the NPU), LDREX/STREX atomics, more multiply ops, wider
  decode (extend the table), and the **MMU**.
- **MMU** (the one big new subsystem, v6-only — needs CP15 + aborts v4T lacks):
  a block on the MEMORY SEAM (VA in → PA out). Sub-blocks: page-table walker (core
  state machine), TLB (translation cache — makes it fast enough for Linux), CP15
  (config), abort/permission (page faults → OS). ≈ as hard as the whole ALU+datapath.
- **v4T CANNOT run real Linux** (no MMU; kernel dropped ARMv4T). Real Linux = Tier B.

**Alternative endgame:** fresh RISC-V RV32I → RV64GC core. ~85% of the datapath
transfers; RISC-V decode is SIMPLER than ARM. Reference/oracle = openc906 RTL +
datasheet + Milk-V Duo silicon. This is the true "forever-machine" per the north star.

**OpenC906 reuse boundary:** treat OpenC906 as a complete RV64 CPU IP block, not a
place to splice ARM control. Directly reusable around it: INT8 PE/systolic array,
mul_8, INT32 accumulation, DMA/scratchpads, arithmetic primitives, and verification
methodology. Rough estimates: ARM CPU circuitry 10-20% directly reusable; NPU
70-90%; verification 60-80%; architectural knowledge 80%+.

---

## 10. MEMORY WALL + PCIe ARCHITECTURE

PCIe is the host interface, not the PE memory interface:

```text
host -> PCIe endpoint -> command queue/DMA -> local DDR
                                      -> double-buffered BRAM tiles -> NPU/GPU
```

The CPU submits descriptors (input/weight/output addresses, dimensions,
quantization, opcode, START). PCIe moves jobs and large buffers; DDR holds the
working set; DMA moves aligned bursts; BRAM feeds compute each cycle. Never send
individual MAC operands or intermediate feature maps across PCIe when local reuse
is possible. Required techniques: tiling, double buffering, burst transfers, INT8
packing, operator fusion, and explicit measurement of arithmetic intensity, PE
utilization, effective bandwidth, and compute/transfer overlap.

One sufficiently large FPGA with shared DDR is the preferred first implementation.
Three FPGAs add clock-domain crossings, packet links, separate memories, boot
coordination, and bandwidth bottlenecks. Multi-FPGA is a later chiplet/interconnect
project, not the shortest path to 15 FPS.

---

## 11. CANONICAL ARMv4T GAP (AFTER FIRST C)

First C is not full ARMv4T. Remaining canonical work includes:

```text
ARM: BL; MUL/MLA selection; long multiplies; register-specified shifts; RRX and
shift-by-zero rules; MRS/MSR; complete LDR/STR byte/halfword/signed/address modes;
LDM/STM; SWP/SWPB; SWI; undefined/coprocessor trapping.

State: full CPSR (NZCV,I,F,T,mode), SPSRs, privileged modes, banked registers,
Reset/Undefined/SWI/Abort/IRQ/FIQ entry and return, and precise R15 semantics.

Thumb: 16-bit fetch/decode, Thumb ALU/load/store/branch/BL/PUSH/POP, PC rules,
and BX-driven ARM/Thumb state switching.
```

Caches and MMU are not required merely for ARMv4T architectural correctness.
Broad canonical ARMv4T remains much larger than the first-C milestone; Thumb,
modes/exceptions, and compliance testing are the long tail.

---

## 12. TOOLS & HARDWARE

- **Logisim Evolution** — primary gate-level design environment.
- **Quartus Prime Lite** — FPGA synthesis (schematic entry / structural VHDL).
- **Target board:** DE10-Lite (MAX 10, ~50K LEs, ~87 DSP) now; Arty A7 (~240 DSP)
  for the NPU scale-up. MAX 10 has NO PCIe hard block (PCIe = Tier B, ~2 yrs out).
- **ARM DDI 0084D** (ARM7TDMI-S Data Sheet) — primary spec; cite section per claim.
  Local copy: arminstructionset.pdf. §4.5 data-proc, §4.5.1 flags, §4.7 MUL, §4.17 undefined.
- **armv4t_alu.py** — behavioral oracle for ALU verification.
- **openc906** — XuanTie C906 open RISC-V core (Apache 2.0) — Tier B spec + oracle.
- **Hailo-8L + Raspberry Pi 5** — benchmark target (Prof. Gertner's lab).

**Pre-synthesis FPGA resource bounds (not measurements):** current ARM CPU roughly
2.5-5.5K LUTs and 600-900 FFs; current 4×4 array with sixteen structural 32×32
multipliers may cost ~25-55K LUTs; converting it to INT8 may reduce the 4×4 array
to ~3-8K LUTs and CPU+INT8 NPU to ~6-14K. Structural multipliers may not infer DSPs.
Only a device-specific Quartus/Vivado synthesis report gives real LUT/FF/DSP/Fmax.

## 13. PROJECT FILES (Logisim)
- `CPU_round2.circ` / `customCPU.circ` / `CPU_noram.circ` — V1 (has ALU_32bit,
  reg4x32file, reg16x32, PC_fetch, decoder2x4, mux_4_to_1, reg32bit; customCPU also
  has systolic: PE_cell = Multiplier+Adder+3 Registers, Systollic_2x2, systolic_4x4,
  matmul4x4, Systolic_2x1).
- V2 working file — the current ARMv4T build (sealed ALU + decode ROM).
- `full_adder_1bit.circ`, `Subtractor4Bit/8Bit.circ` — primitives.
- `blockdiag.py` — schematic-symbol renderer (named box + labeled in/out arrows, bus
  ticks, auto-wire on matching port names). `python3 blockdiag.py` → pp_slice.svg,
  pp_array.svg, csa_slice.svg, csa_tree.svg, bs_stage.svg, barrel_chain.svg,
  **cpu_datapath.svg**. New block = a 3-line call; open SVG in browser.
- **`BUILD_SHIFTER.md`** — the offline field guide for the BARREL SHIFTER (built).
  3 stages, two ideas (log network + fill-encodes-type), the composition invariant
  (**ASR composes because ASR never changes bit31** — the sign is a fixed point),
  a 6-step debug order, and **§5: THE STAGE-1 DEGENERACY** (below). READ §5 FIRST.
  **⚠ NEW TRAP CLASS — a discriminator that DOESN'T EXIST.** At «1 the fill is ONE
  bit, so `in[0]=1,in[31]=1 → ROR==ASR` and `in[0]=0 → ROR==LSR`. Brute force over
  2²⁰ vectors: **ZERO separate all four types at stage 1.** So the obvious probe
  (0x9E3779B9) PASSES with mux inputs 2/3 swapped (ASR↔ROR) — a one-wire mistake.
  **FIX: TWO vectors differing only in bit0** — 0x9E3779B9 (blind to ASR↔ROR) AND
  0x9E3779B8 (EXPOSES it: ROR→0x4F1BBCDC, ASR stays 0xCF1BBCDC). Neither alone seals it.
  Same species as the dropped carry: the test passes for a reason unrelated to
  correctness. Stages 2/4/8/16 are NOT degenerate — one vector seals each.
  Also: `shifter_carry` CANNOT be tapped from the last stage (it depends on the
  ORIGINAL input + TOTAL amt) → it's a 32:1 mux on `in`, parallel to the chain.
  **The oracle does NOT model shifter_carry** — no golden reference exists yet.
- **`BUILD_CPU.md`** — the offline field guide for wiring the single-cycle CPU.
  Six stages, a verify probe per stage, an 8-step debug order, and the full
  "what to avoid" list (splitter bits, Sign-vs-Zero extender, 3-in XOR parity,
  dropped carry, tunnel shorts, V1/V2 library-ID mismatch). READ THIS FIRST.
- **`BUILD_OPERAND2.md`** — the offline field guide for the completed Operand2
  register and immediate paths.
- **`BUILD_CONDITION.md`** — the completed condition-execution field guide:
  canonical condition decoding, enable gating, CPU test words, clock table, and
  diagnostic signatures.
- **`BUILD_BRANCH.md`** — the completed canonical ARM `B` field guide:
  signed `imm24<<2`, the `PC+8` correction, conditional branch gating, and two
  per-clock regressions.
- **`BUILD_BX.md`** — the completed ARM-state BX field guide: exact pattern detection,
  register target alignment, absolute-target extension of `pc_fetch`, write
  suppression, and `BX LR` regression.
- **`BX_CPU_TEST.md` / `bx_rom` / `bx_lr_rom`** — verified absolute `BX R2` and
  function-return `BX LR` regressions.
- **`BRANCH_CPU_TEST.md` / `branch_rom` / `branch_cond_rom`** — verified forward
  skip, stable self-loop, and terminating conditional backward loop.
- **`CONDITION_CPU_TEST.md` / `condition_rom`** — verified condition regression:
  MI/EQ pass, PL/NE fail, final R2=22, R3=0, R5=55, R6=0, CPSR=4.
- **`OPERAND2_CPU_TEST.md` / `operand2_rom`** — verified immediate Operand2 CPU
  regression: R3=FF, R4=80000000, R5=800000FF.
- **`asm.py`** — tiny ARMv4T data-processing assembler + oracle simulator.
  `--demo` prints the bring-up program, its machine words, the decode-ROM address
  and word each drives, and what each destination register becomes. `--rom FILE`
  writes the Logisim instruction-ROM image. Runs offline.
- `instr_rom` — the OLD bring-up image. **Requires poking R1=5, R2=3 by hand.**
- **`boot_rom`** — the M1 image, and the one to use. **SELF-BOOTSTRAPPING: poke
  NOTHING.** Every register resets to 0; `MVN R1,R0` makes 0xFFFFFFFF and
  `SUB R2,R0,R1` makes a ONE, then ADD builds every constant it needs. 16
  instructions, ends R3=8. Carries both discriminators (see §2). Load via
  right-click `instr_rom` → Load Image → `boot_rom`.
- MULTIPLIER circuits (in armv4t.circ, all SEALED): `pp_row_32`, `partial_products`,
  `csa_3to_2`, `mul_32` (30 CSA tiles), + ks_32b finisher → wired to ALU slot 10.
- **armv4t.circ (V2) now contains 30 circuits / ~3,500 wire segments:** `main`, `koggle_stone_1b`,
  `koggle_stone_2b`, `pg_cell`, `ks_4b`, `ks_32b`, `ALU_airthmetic_engine`, `ALU`,
  `a_invert`, `ALU_logic_engine`, `pp_row_32`, `partial_products`, `csa_3to_2`,
  `mul_32`, **`reg16x32`** (imported), **`pc_fetch`** (imported),
  `PE_cell`, `systolic_4x4`, `matmul4x4`, `pp_row_16`, `csa_16`, `pp_8`,
  `mul_8`, **`bs_stage_1`**, **`bs_stage_2`**, **`bs_stage_4`**, **`bs_stage_8`**,
  **`bs_stage_16`**, **`barrel_32b`**, **`condition_checker`**.
- `ALU_modular_design.circ` (V1) — source of the imports. Still holds the V1 systolic
  NPU (`PE_cell` = built-in Multiplier + Adder + 3 Registers, `Systollic_2x2`,
  `systolic_4x4`, `matmul4x4`, `Systolic_2x1`) and a full single-cycle datapath
  blueprint (`main`/`main_v2` = ROM → PC_fetch → reg16x32 → ALU_32bit → RAM).
  The current V2 `PE_cell` is already gate-level (`mul_32` + `ks_32b` + registers).
- Custom instructions: use ARMv4T undefined-instruction space (§4.17) → decoder adds
  a case → new control line → routes to custom unit → result through open out_mux slot.
  This is how NPU dispatch (MMIO) will work.

---

## IMMEDIATE NEXT STEP
COMPUTE CORE DONE. **M1 DONE — THE SINGLE-CYCLE CPU EXECUTES INSTRUCTIONS.**
pc_fetch → instr_rom → decode_rom → reg16x32 → ALU → writeback, all wired,
`boot_rom` runs 16 instructions clean, R3 = 0x00000008, both discriminators passed.
The authoritative list of tested instruction/decode images is `VERIFIED_ROMS.md`.
Before memory integration, run the complete generated pack in
`regression_roms/README.md`; regenerate it with `python3 build_regression_roms.py`.

**CURRENT START POINT 2026-08-02: BUILD `LDR/STR` + DATA RAM.**
Condition execution and `B`/`BL`/ARM-state `BX` are complete. Preserve the commit
invariant: branch, memory, and link writes are gated by `condition_pass`.

  ~~1. WIRE THE SINGLE-CYCLE CPU~~ ✅ **DONE 2026-07-14.** (Guide: `BUILD_CPU.md`.)

  ~~1. BARREL SHIFTER~~ ✅ **DONE 2026-07-26.**
     `bs_stage_1/2/4/8/16` and `barrel_32b` are built in `armv4t.circ`, XML-valid,
     and standalone-verified against the Python oracle. `shifter_carry` remains a
     separate future block.
  ~~2. OPERAND2 REGISTER PATH~~ ✅ **DONE 2026-07-27.**
  ~~3. OPERAND2 IMMEDIATE PATH~~ ✅ **DONE 2026-07-27.**
     Shared barrel input/amount/type muxes selected by I=instr[25].
  ~~4. CPSR FLAG REGISTER + S-BIT GATING~~ ✅ **DONE 2026-07-27.**
     Arithmetic NZCV sequence verified: 0 -> 6 -> 6 -> 9 -> 8 -> A.
     Shifter carry remains required for logical instructions that set C.
  ~~5. CONDITION CHECK~~ ✅ **DONE 2026-07-28.**
     `instr[31:28] + CPSR.NZCV -> condition_pass`; failed conditions suppress
     register writes and CPSR updates. Regression ends R2=22, R3=0, R5=55, R6=0.
  6. ~~B BRANCH~~ ✅ **DONE 2026-07-28.**
     Forward skip, backward conditional loop, fall-through, and self-loop passed.
  7. ~~BX CONTROL FLOW~~ ✅ **DONE 2026-08-02.**
     `BX R2` and `BX LR` absolute redirects passed with write suppression.
  8. ~~BL LINK WRITEBACK~~ ✅ **DONE 2026-08-02.**
     `BL -> function -> BX LR -> caller` passed; PC+4 correctly writes R14.
  9. **LDR / STR decoder extension + data RAM** ← START HERE
  10. Stack/ABI cleanup and shifter-carry correctness

The gate-theory fights (CSA tree, Logisim XOR-parity trap) are behind us, and the
integration fight is now behind us too. What's left is 2 small comb blocks + memory.

**HONEST COMPLETION (reuse allowed):** compute core 100% · **M1 100% ✅** ·
toward a practical C-capable single-cycle CPU ~80%. Compiler-generated leaf C and
function-call control flow run. Must-build: decoder extension, data memory/load
writeback, and stack/ABI support. Shifter carry remains a
correctness cleanup.

FUTURE (parked, not now):
- out_mux slot 11 = FPU (float). Fixed-point/INT8 covers the NPU regime, so FPU waits
  until fixed-point is genuinely insufficient. Slot is reserved; drops in like mul did.
- mul_32b is the shared primitive → reused as the MAC in every NPU systolic PE (M2).
