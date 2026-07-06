#!/usr/bin/env python3
"""
armv4t_alu.py  —  Software model of the CustomCPU V2 ARMv4T ALU.
================================================================================
This file is built the way its author learns: MECHANISM-FIRST, INVARIANT-DRIVEN.
It is not a spec you read top-to-bottom; it is a working artifact you run, probe,
and reverse-derive the rules from. The TABLE below is the machine; the flags are
the invariants that must always hold; the self-test is the adversarial edge-case
battery. Configure any assisting model around these same principles:
  - start from the concrete artifact (this running model), not theory
  - express behavior as invariants / flows / constraints, not definitions
  - lead with structure (the datapath), then the values, then the words
  - allow pushback: run it on a new vector, force an edge case, verify
  - keep scopes tight: one opcode, one flag, one probe at a time
  - anchor to the build: this is the golden oracle the gate-level ALU must match
================================================================================

Follows the ULTIMATE ALU TABLE: every one of the 16 data-processing opcodes,
its control-signal settings (a_inv, b_inv, cin_sel, engine, logic_sel), the
result it produces, and the N/Z/C/V flags per ARM DDI 0084D §4.5 / §4.5.1.

INVARIANTS (what must always hold):
  N = result[31]
  Z = (result == 0)
  C (arith) = carry out of bit 31 ; subtract convention C=1 means NO borrow
  V (arith) = (Aeff31 XNOR Beff31) AND (result31 XOR Aeff31)
              Aeff31 = A[31]^a_inv, Beff31 = B[31]^b_inv   (effective-sign method)
  logic ops: N,Z from result; C from shifter (not modeled, '-'); V unaffected ('-')

CONTROL INPUTS (every pin on the Logisim canvas):
  A(32) B(32) a_inv(1) b_inv(1) Cflag(1) cin_sel(2) logic_sel(3) engine_sel(2)
OUTPUTS:
  result(32) N Z C V
"""

MASK = 0xFFFFFFFF
BIT31 = 0x80000000

# ---------------------------------------------------------------------------
# THE ULTIMATE TABLE  — opcode -> control signals (mirrors the Logisim decoder)
# cin_sel: 0 -> Cin=0, 1 -> Cin=1, 2 -> Cin=Cflag
# engine : 'A' arithmetic, 'L' logic
# ---------------------------------------------------------------------------
TABLE = {
    #                a_inv b_inv cin_sel engine logic_sel write
    0b0000: ("AND", 0,    0,    0,      'L',   0,        1),
    0b0001: ("EOR", 0,    0,    0,      'L',   1,        1),
    0b0010: ("SUB", 0,    1,    1,      'A',   None,     1),
    0b0011: ("RSB", 1,    0,    1,      'A',   None,     1),
    0b0100: ("ADD", 0,    0,    0,      'A',   None,     1),
    0b0101: ("ADC", 0,    0,    2,      'A',   None,     1),
    0b0110: ("SBC", 0,    1,    2,      'A',   None,     1),
    0b0111: ("RSC", 1,    0,    2,      'A',   None,     1),
    0b1000: ("TST", 0,    0,    0,      'L',   0,        0),  # as AND, no write
    0b1001: ("TEQ", 0,    0,    0,      'L',   1,        0),  # as EOR, no write
    0b1010: ("CMP", 0,    1,    1,      'A',   None,     0),  # as SUB, no write
    0b1011: ("CMN", 0,    0,    0,      'A',   None,     0),  # as ADD, no write
    0b1100: ("ORR", 0,    0,    0,      'L',   2,        1),
    0b1101: ("MOV", 0,    0,    0,      'L',   3,        1),
    0b1110: ("BIC", 0,    0,    0,      'L',   4,        1),
    0b1111: ("MVN", 0,    0,    0,      'L',   5,        1),
}

# logic_sel -> operation (mirrors the 6:1 mux in ALU_logic_engine)
def logic_op(sel, a, b):
    return {
        0: a & b,           # AND
        1: a ^ b,           # EOR
        2: a | b,           # ORR
        3: b & MASK,        # MOV  (operand1 ignored)
        4: a & (~b & MASK), # BIC  (A AND NOT B)
        5: (~b) & MASK,     # MVN  (NOT B)
    }[sel]


def alu(opcode, A, B, Cflag=0):
    """Full ALU: returns dict with result, flags, and control signals used."""
    name, a_inv, b_inv, cin_sel, engine, logic_sel, write = TABLE[opcode]
    A &= MASK
    B &= MASK

    if engine == 'A':
        # --- arithmetic engine: ks_32b with invert layers + Cin mux ---
        Aeff = (A ^ MASK) if a_inv else A          # A-invert XOR layer
        Beff = (B ^ MASK) if b_inv else B          # B-invert XOR layer
        Cin  = {0: 0, 1: 1, 2: Cflag}[cin_sel]     # 4:1 Cin mux
        full = Aeff + Beff + Cin                   # 33-bit sum
        result = full & MASK
        Cout = 1 if full > MASK else 0

        # --- flags ---
        N = 1 if result & BIT31 else 0
        Z = 1 if result == 0 else 0
        C = Cout
        # V via effective sign bits (Option B-lite, exactly the gate build)
        Aeff31 = (A >> 31) ^ a_inv
        Beff31 = (B >> 31) ^ b_inv
        r31    = (result >> 31) & 1
        same_sign_in = 1 if Aeff31 == Beff31 else 0     # XNOR
        diff_sign_out = 1 if r31 != Aeff31 else 0       # XOR
        V = same_sign_in & diff_sign_out
    else:
        # --- logic engine ---
        result = logic_op(logic_sel, A, B) & MASK
        N = 1 if result & BIT31 else 0
        Z = 1 if result == 0 else 0
        C = None   # from barrel shifter (not modeled)
        V = None   # unaffected

    return {
        "op": name, "opcode": opcode, "A": A, "B": B, "Cflag": Cflag,
        "a_inv": a_inv, "b_inv": b_inv, "cin_sel": cin_sel,
        "engine": engine, "logic_sel": logic_sel, "write": write,
        "result": result, "N": N, "Z": Z, "C": C, "V": V,
    }


def fmt_flag(x):
    return "-" if x is None else str(x)


def print_legend():
    """Print the full meaning of every control signal and flag."""
    print("""
CONTROL SIGNAL LEGEND  (what every input means)
================================================================
a_inv    (1 bit)  invert operand A before the adder.  Aeff = A XOR a_inv
                    1 = invert  -> used by RSB, RSC  (compute B - A)
                    0 = pass    -> everyone else
b_inv    (1 bit)  invert operand B before the adder.  Beff = B XOR b_inv
                    1 = invert  -> used by SUB, SBC, CMP  (compute A - B)
                    0 = pass    -> everyone else
cin_sel  (2 bit)  selects the carry-in into the adder (4:1 mux):
                    00 -> Cin = 0        (ADD, CMN)
                    01 -> Cin = 1        (SUB, RSB, CMP)   the "+1" of two's-comp
                    10 -> Cin = Cflag    (ADC, SBC, RSC)   chain the carry flag
                    11 -> unused
engine   (1 bit)  output mux: which engine's result is selected
                    arith -> arithmetic_engine (ks_32b + invert + Cin mux)
                    logic -> logic_unit (6:1 bitwise mux)
logic_sel(3 bit)  selects the bitwise op inside logic_unit (6:1 mux):
                    000 = AND   A & B
                    001 = EOR   A ^ B
                    010 = ORR   A | B
                    011 = MOV   B            (A ignored)
                    100 = BIC   A & ~B
                    101 = MVN   ~B
write    (1 bit)  register write-enable.
                    1 = result written to Rd
                    0 = result DISCARDED (flags still update) -> TST/TEQ/CMP/CMN
Cflag    (1 bit)  the current carry flag, fed to cin_sel=10 (ADC/SBC/RSC)

FLAG LEGEND  (per ARM DDI 0084D 4.5.1)
================================================================
N  result[31]                         (sign bit)
Z  1 iff result == 0
C  arith: carry out of bit 31; subtract convention C=1 means NO borrow
   logic: from barrel shifter (not modeled here -> shown as '-')
V  arith: signed overflow = (Aeff31 XNOR Beff31) AND (result31 XOR Aeff31)
   logic: unaffected (shown as '-')
   where Aeff31 = A[31]^a_inv, Beff31 = B[31]^b_inv
================================================================
""")


def print_markdown(A, B, Cflag=0):
    """Print the ULTIMATE TABLE with ALL canvas inputs as columns (no write col)."""
    cin_names = {0: "00", 1: "01", 2: "10"}
    eng_sel   = {'L': "00", 'A': "01"}   # engine_sel encoding on the canvas
    print(f"\n**A = 0x{A:08X}"
          + ("  (bit31=1 -> signed negative)" if A & BIT31 else "  (bit31=0 -> signed positive)")
          + f"**  \n**B = 0x{B:08X}"
          + ("  (bit31=1 -> signed negative)" if B & BIT31 else "  (bit31=0 -> signed positive)")
          + f"**  \n**Cflag = {Cflag}**\n")
    # header: every INPUT pin on the canvas, then result, then flags
    print("| opcode | mnem | A | B | a_inv | b_inv | Cflag | cin_sel | logic_sel | engine_sel | result | N | Z | C | V |")
    print("|--------|------|---|---|-------|-------|-------|---------|-----------|------------|--------|---|---|---|---|")
    for opcode in range(16):
        r = alu(opcode, A, B, Cflag)
        is_logic = (r["engine"] == 'L')
        ai = "-" if is_logic else str(r["a_inv"])
        bi = "-" if is_logic else str(r["b_inv"])
        cf = "-" if is_logic else str(Cflag)
        cs = "-" if is_logic else cin_names[r["cin_sel"]]
        ls = f"{r['logic_sel']:03b}" if r["logic_sel"] is not None else "-"
        es = eng_sel[r["engine"]]
        C  = "-" if r["C"] is None else str(r["C"])
        V  = "-" if r["V"] is None else str(r["V"])
        print(f"| {opcode:04b} | {r['op']} | 0x{A:08X} | 0x{B:08X} | {ai} | {bi} | {cf} | "
              f"{cs} | {ls} | {es} | 0x{r['result']:08X} | {r['N']} | {r['Z']} | {C} | {V} |")


def print_table(A, B, Cflag=0):
    """Print the ULTIMATE TABLE as a clean aligned box table (all canvas inputs)."""
    cin_names = {0: "00", 1: "01", 2: "10"}
    eng_sel   = {'L': "00", 'A': "01"}
    cols = ["opc", "mnem", "a_inv", "b_inv", "Cflag", "cin_sel",
            "logic_sel", "eng_sel", "result", "N", "Z", "C", "V"]
    widths = [4, 4, 5, 5, 5, 7, 9, 7, 10, 1, 1, 1, 1]

    rows = []
    for opcode in range(16):
        r = alu(opcode, A, B, Cflag)
        is_logic = (r["engine"] == 'L')
        rows.append([
            f"{opcode:04b}", r["op"],
            "-" if is_logic else str(r["a_inv"]),
            "-" if is_logic else str(r["b_inv"]),
            "-" if is_logic else str(Cflag),
            "-" if is_logic else cin_names[r["cin_sel"]],
            f"{r['logic_sel']:03b}" if r["logic_sel"] is not None else "-",
            eng_sel[r["engine"]],
            f"0x{r['result']:08X}",
            str(r["N"]), str(r["Z"]),
            "-" if r["C"] is None else str(r["C"]),
            "-" if r["V"] is None else str(r["V"]),
        ])

    def bar(ch_l, ch_m, ch_r):
        return ch_l + ch_m.join("─" * (w + 2) for w in widths) + ch_r

    def line(cells):
        return "│" + "│".join(f" {c:<{w}} " for c, w in zip(cells, widths)) + "│"

    signA = "neg" if A & BIT31 else "pos"
    signB = "neg" if B & BIT31 else "pos"
    print(f"\n  ARMv4T ALU  |  A=0x{A:08X} ({signA})  B=0x{B:08X} ({signB})  Cflag={Cflag}")
    print(bar("┌", "┬", "┐"))
    print(line(cols))
    print(bar("├", "┼", "┤"))
    for row in rows:
        print(line(row))
    print(bar("└", "┴", "┘"))
    print("  a_inv/b_inv/Cflag/cin_sel = '-' for logic ops; logic_sel = '-' for arith ops")
    print("  C/V = '-' for logic ops (C from shifter, V unaffected).  eng_sel: 00=logic 01=arith\n")


# ---------------------------------------------------------------------------
# Self-test: the golden edge cases the gate-level ALU was verified against
# ---------------------------------------------------------------------------
def selftest():
    checks = [
        # (opcode, A, B, Cflag, exp_result, N, Z, C, V, note)
        (0b0100, 0x7FFFFFFF, 0x00000001, 0, 0x80000000, 1,0,0,1, "ADD signed overflow"),
        (0b0100, 0xFFFFFFFF, 0x00000001, 0, 0x00000000, 0,1,1,0, "ADD C=1 V=0 (independence)"),
        (0b0010, 0x9E3779B9, 0x7F4A7C15, 0, 0x1EECFDA4, 0,0,1,1, "SUB big, V=1"),
        (0b0100, 0x9E3779B9, 0x7F4A7C15, 0, 0x1D81F5CE, 0,0,1,0, "ADD big, V=0"),
        (0b0011, 0x9E3779B9, 0x7F4A7C15, 0, 0xE113025C, 1,0,0,1, "RSB B-A, V=1"),
        (0b0010, 0x0000000A, 0x00000005, 0, 0x00000005, 0,0,1,0, "SUB 10-5"),
        (0b0110, 0x00000005, 0x00000003, 1, 0x00000002, 0,0,1,0, "SBC Cflag=1 -> SUB"),
        (0b0110, 0x00000005, 0x00000003, 0, 0x00000001, 0,0,1,0, "SBC Cflag=0 -> -1"),
        (0b1111, 0x9E3779B9, 0x7F4A7C15, 0, 0x80B583EA, 1,0,None,None, "MVN ~B"),
        (0b0000, 0x9E3779B9, 0x7F4A7C15, 0, 0x1E027811, 0,0,None,None, "AND"),
    ]
    print("SELF-TEST (golden edge cases):\n")
    allok = True
    for opcode, A, B, Cf, er, en, ez, ec, ev, note in checks:
        r = alu(opcode, A, B, Cf)
        ok = (r["result"] == er and r["N"] == en and r["Z"] == ez
              and r["C"] == ec and r["V"] == ev)
        allok &= ok
        tag = "PASS" if ok else "FAIL"
        print(f"[{tag}] {r['op']:4} A=0x{A:08X} B=0x{B:08X} Cf={Cf} -> "
              f"0x{r['result']:08X} N{r['N']} Z{r['Z']} "
              f"C{fmt_flag(r['C'])} V{fmt_flag(r['V'])}   {note}")
        if not ok:
            print(f"       expected 0x{er:08X} N{en} Z{ez} C{fmt_flag(ec)} V{fmt_flag(ev)}")
    print("\n" + ("ALL PASS ✅" if allok else "SOME FAILED ❌"))
    return allok


if __name__ == "__main__":
    import sys
    # DEFAULT: clean aligned box table.
    # Flags:  --md (markdown for docs)   --legend (signal reference)   --test (selftest)
    args   = [a for a in sys.argv[1:] if not a.startswith("--")]
    md     = "--md" in sys.argv
    legend = "--legend" in sys.argv
    test   = "--test" in sys.argv

    if len(args) >= 2:
        A = int(args[0], 0) & MASK
        B = int(args[1], 0) & MASK
        Cf = int(args[2], 0) if len(args) >= 3 else 0
    else:
        A, B, Cf = 0x9E3779B9, 0x7F4A7C15, 0

    if test:
        selftest()
    elif md:
        print_markdown(A, B, Cf)
    else:
        if legend:
            print_legend()
        print_table(A, B, Cf)   # DEFAULT: clean box table
