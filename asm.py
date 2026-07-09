#!/usr/bin/env python3
"""
asm.py  —  tiny ARMv4T assembler + simulator for the CustomCPU bring-up.
================================================================================
Encodes the DATA-PROCESSING / REGISTER form only — which is exactly what the
single-cycle CPU can execute today (no barrel shifter, no immediates, no
condition codes, no memory, no branches).

    cond(4) 00 I(1) opcode(4) S(1) Rn(4) Rd(4) shift(8) Rm(4)
      1110   00  0    ....     0   ....  ....  00000000 ....
       AL        reg                                shift = LSL #0 = a WIRE

Why this is safe: `ADD R3,R1,R2` encodes operand2 as "Rm shifted LSL #0".
A shift of zero is a wire, so the barrel shifter can be skipped entirely.

USAGE
-----
  python3 asm.py --demo                     # the standard bring-up program
  python3 asm.py --demo --init R1=5,R2=3    # same, with different seed regs
  python3 asm.py "ADD R3,R1,R2" "MVN R4,R3" --init R1=9,R2=4
  python3 asm.py --demo --rom instr_rom     # also WRITE the Logisim ROM image

It prints, for every instruction: the machine word, the decode-ROM address and
word it will drive, and what the destination register becomes.  That is your
expected-value table for poking through Logisim, offline.
================================================================================
"""
import sys
import armv4t_alu as m

# opcode[24:21] for every data-processing mnemonic
OPS = {
    'AND': 0x0, 'EOR': 0x1, 'SUB': 0x2, 'RSB': 0x3,
    'ADD': 0x4, 'ADC': 0x5, 'SBC': 0x6, 'RSC': 0x7,
    'TST': 0x8, 'TEQ': 0x9, 'CMP': 0xA, 'CMN': 0xB,
    'ORR': 0xC, 'MOV': 0xD, 'BIC': 0xE, 'MVN': 0xF,
}
# these ignore Rn (operand1 unused)         -> assemble with Rn = R0
NO_RN = {'MOV', 'MVN'}
# these do not write a register (write=0)   -> no Rd field, Rd = R0
NO_RD = {'TST', 'TEQ', 'CMP', 'CMN'}

COND_AL = 0xE       # 1110 = always execute


def encode(op, Rd=0, Rn=0, Rm=0):
    """Build the 32-bit instruction word. I=0 (register), S=0, shift=0."""
    return ((COND_AL << 28) | (0b00 << 26) | (0 << 25) | (OPS[op] << 21)
            | (0 << 20) | (Rn << 16) | (Rd << 12) | (0 << 4) | Rm)


def _reg(tok):
    tok = tok.strip().upper()
    if not tok.startswith('R'):
        raise ValueError(f"expected a register like R3, got {tok!r}")
    n = int(tok[1:])
    if not 0 <= n <= 15:
        raise ValueError(f"register out of range: {tok}")
    return n


def parse(line):
    """'ADD R3,R1,R2' -> ('ADD', Rd, Rn, Rm)."""
    line = line.replace(',', ' ').split()
    op = line[0].upper()
    if op not in OPS:
        raise ValueError(f"unknown op {op!r}. known: {' '.join(sorted(OPS))}")
    args = [_reg(a) for a in line[1:]]

    if op in NO_RD:                 # CMP R1,R2   -> Rn=R1, Rm=R2, no Rd
        if len(args) != 2:
            raise ValueError(f"{op} takes 2 registers: {op} Rn,Rm")
        return op, 0, args[0], args[1]
    if op in NO_RN:                 # MOV R3,R2   -> Rd=R3, Rm=R2, no Rn
        if len(args) != 2:
            raise ValueError(f"{op} takes 2 registers: {op} Rd,Rm")
        return op, args[0], 0, args[1]
    if len(args) != 3:              # ADD R3,R1,R2
        raise ValueError(f"{op} takes 3 registers: {op} Rd,Rn,Rm")
    return op, args[0], args[1], args[2]


def assemble(lines):
    return [(op, rd, rn, rm, encode(op, rd, rn, rm)) for op, rd, rn, rm in map(parse, lines)]


def rom_image(prog):
    """Logisim 'v3.0 hex words plain' image for the instruction ROM."""
    words = " ".join(f"{w:08x}" for *_ , w in prog)
    return "v3.0 hex words plain\n" + words + "\n"


def simulate(prog, init):
    """Run the program on the oracle. Returns the trace + final register file."""
    regs = [0] * 16
    for k, v in init.items():
        regs[k] = v & m.MASK
    Cflag = 0                      # no CPSR yet -> Cflag is tied to 0 in hardware
    trace = []
    for addr, (op, rd, rn, rm, word) in enumerate(prog):
        r = m.alu(OPS[op], regs[rn], regs[rm], Cflag)
        wrote = None
        if r["write"]:
            regs[rd] = r["result"]
            wrote = rd
        trace.append((addr, op, rd, rn, rm, word, r, wrote))
    return trace, regs


def main():
    argv = sys.argv[1:]
    demo = "--demo" in argv
    rom_out = None
    if "--rom" in argv:
        i = argv.index("--rom")
        rom_out = argv[i + 1]
        del argv[i:i + 2]

    init = {1: 5, 2: 3}
    if "--init" in argv:
        i = argv.index("--init")
        init = {}
        for pair in argv[i + 1].split(','):
            k, v = pair.split('=')
            init[_reg(k)] = int(v, 0)
        del argv[i:i + 2]

    lines = [a for a in argv if not a.startswith("--")]
    if demo or not lines:
        lines = ["ADD R3,R1,R2", "SUB R3,R1,R2", "AND R3,R1,R2",
                 "ORR R3,R1,R2", "MOV R3,R2", "MVN R3,R2", "CMP R1,R2"]

    prog = assemble(lines)
    trace, regs = simulate(prog, init)

    seed = "  ".join(f"R{k}=0x{v:08X}" for k, v in sorted(init.items()))
    print(f"\n  SEED REGISTERS (poke these into reg16x32):  {seed}\n")
    print("  " + "-" * 104)
    print(f"  {'addr':5}{'instruction':16}{'word':12}{'dec.addr':10}{'ROMword':10}"
          f"{'eng':5}{'wr':4}{'destination becomes':22}")
    print("  " + "-" * 104)
    for addr, op, rd, rn, rm, word, r, wrote in trace:
        w = m.rom_word(OPS[op])
        eng = f"{m.ENGINE[r['engine']]:02b}"
        dest = (f"R{wrote} = 0x{r['result']:08X}" if wrote is not None
                else "(no write - flags only)")
        print(f"  0x{addr:02X}  {op + ' ' + ','.join('R'+str(x) for x in ((rd,rn,rm) if op not in NO_RD|NO_RN else ((rn,rm) if op in NO_RD else (rd,rm)))):15}"
              f"0x{word:08X}  0x{OPS[op]:04X}    0x{w:03x}     {eng}   {r['write']}   {dest}")
    print("  " + "-" * 104)

    print("\n  FINAL REGISTER FILE")
    for row in range(0, 16, 4):
        print("   " + "  ".join(f"R{i:<2}=0x{regs[i]:08X}" for i in range(row, row + 4)))

    print("\n  INSTRUCTION ROM IMAGE  (load into instr_rom)")
    print("  " + "-" * 60)
    for line in rom_image(prog).rstrip().split("\n"):
        print("  " + line)
    print("  " + "-" * 60)
    print("  Clock once per instruction (Ctrl+T). Watch R3_OUTPUT.\n")

    if rom_out:
        with open(rom_out, "w") as f:
            f.write(rom_image(prog))
        print(f"  wrote {rom_out}\n")


if __name__ == "__main__":
    main()
