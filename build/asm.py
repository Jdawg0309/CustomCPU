#!/usr/bin/env python3
"""
asm.py  —  tiny ARMv4T assembler + simulator for the CustomCPU bring-up.
================================================================================
Encodes the DATA-PROCESSING forms the single-cycle CPU is bringing up now:
register operand2 with immediate shifts, plus ARM rotated immediates.
Still no condition execution, memory, branches, CPSR, or register-specified
shifts.

    cond(4) 00 I(1) opcode(4) S(1) Rn(4) Rd(4) shift(8) Rm(4)
      1110   00  I    ....     0   ....  ....  operand2[11:0]

Register operand2:
    instr[11:7] = shift amount, instr[6:5] = type, instr[4] = 0, instr[3:0] = Rm

Immediate operand2:
    instr[11:8] = rotate/2, instr[7:0] = imm8

USAGE
-----
  python3 asm.py --demo                     # the standard bring-up program
  python3 asm.py --demo --init R1=5,R2=3    # same, with different seed regs
  python3 asm.py "ADD R3,R1,R2" "MVN R4,R3" --init R1=9,R2=4
  python3 asm.py "ADD R3,R1,R2,LSL #4"
  python3 asm.py "ADD R3,R1,#0x80000000"
  python3 asm.py --demo --rom instr_rom     # also WRITE the Logisim ROM image

It prints, for every instruction: the machine word, the decode-ROM address and
word it will drive, and what the destination register becomes.  That is your
expected-value table for poking through Logisim, offline.
================================================================================
"""
import sys
from dataclasses import dataclass
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
SHIFT_TYPES = {'LSL': 0b00, 'LSR': 0b01, 'ASR': 0b10, 'ROR': 0b11}
SHIFT_NAMES = {v: k for k, v in SHIFT_TYPES.items()}


@dataclass(frozen=True)
class Operand2:
    kind: str
    rm: int = 0
    shift_type: int = 0
    shift_amount: int = 0
    imm8: int = 0
    rot4: int = 0

    def bits(self):
        if self.kind == "reg":
            return ((self.shift_amount & 0x1F) << 7) | ((self.shift_type & 0x3) << 5) | self.rm
        return ((self.rot4 & 0xF) << 8) | (self.imm8 & 0xFF)

    def i_bit(self):
        return 1 if self.kind == "imm" else 0

    def value(self, regs):
        if self.kind == "reg":
            return m.barrel_shift(regs[self.rm], self.shift_amount, self.shift_type)
        return m.barrel_shift(self.imm8, self.rot4 * 2, SHIFT_TYPES['ROR'])

    def text(self):
        if self.kind == "imm":
            return f"#0x{self.value([0] * 16):X}"
        if self.shift_amount == 0 and self.shift_type == SHIFT_TYPES['LSL']:
            return f"R{self.rm}"
        return f"R{self.rm},{SHIFT_NAMES[self.shift_type]} #{self.shift_amount}"


def encode(op, Rd=0, Rn=0, op2=Operand2("reg")):
    """Build the 32-bit instruction word. S=0."""
    return ((COND_AL << 28) | (0b00 << 26) | (op2.i_bit() << 25) | (OPS[op] << 21)
            | (0 << 20) | (Rn << 16) | (Rd << 12) | op2.bits())


def _reg(tok):
    tok = tok.strip().upper()
    if not tok.startswith('R'):
        raise ValueError(f"expected a register like R3, got {tok!r}")
    n = int(tok[1:])
    if not 0 <= n <= 15:
        raise ValueError(f"register out of range: {tok}")
    return n


def _imm(tok):
    tok = tok.strip()
    if not tok.startswith('#'):
        raise ValueError(f"expected an immediate like #123 or #0xFF, got {tok!r}")
    return int(tok[1:], 0) & m.MASK


def _encode_arm_imm(value):
    """Return (imm8, rot4) for ARM's 8-bit rotated immediate, or raise."""
    value &= m.MASK
    for rot4 in range(16):
        for imm8 in range(256):
            if m.barrel_shift(imm8, rot4 * 2, SHIFT_TYPES['ROR']) == value:
                return imm8, rot4
    raise ValueError(f"immediate 0x{value:08X} is not encodable as ARM imm8 ROR #(2*rot4)")


def _operand2(args, op):
    if not args:
        raise ValueError(f"{op} is missing operand2")
    if args[0].startswith('#'):
        if len(args) != 1:
            raise ValueError("immediate operand2 takes one token, e.g. #0xFF")
        imm8, rot4 = _encode_arm_imm(_imm(args[0]))
        return Operand2("imm", imm8=imm8, rot4=rot4)

    rm = _reg(args[0])
    if len(args) == 1:
        return Operand2("reg", rm=rm)
    if len(args) != 3 or args[2][0] != '#':
        raise ValueError("register shifts use: Rm,LSL #n / Rm,LSR #n / Rm,ASR #n / Rm,ROR #n")
    shift = args[1].upper()
    if shift not in SHIFT_TYPES:
        raise ValueError(f"unknown shift {shift!r}. known: {' '.join(SHIFT_TYPES)}")
    amt = _imm(args[2])
    if not 0 <= amt <= 31:
        raise ValueError(f"shift amount out of range: {amt}; register-immediate shifts use 0..31")
    return Operand2("reg", rm=rm, shift_type=SHIFT_TYPES[shift], shift_amount=amt)


def parse(line):
    """'ADD R3,R1,R2,LSL #4' -> ('ADD', Rd, Rn, Operand2)."""
    line = line.replace(',', ' ').split()
    op = line[0].upper()
    if op not in OPS:
        raise ValueError(f"unknown op {op!r}. known: {' '.join(sorted(OPS))}")
    args = line[1:]

    if op in NO_RD:                 # CMP R1,R2   -> Rn=R1, Rm=R2, no Rd
        if len(args) < 2:
            raise ValueError(f"{op} takes Rn,operand2")
        return op, 0, _reg(args[0]), _operand2(args[1:], op)
    if op in NO_RN:                 # MOV R3,R2   -> Rd=R3, Rm=R2, no Rn
        if len(args) < 2:
            raise ValueError(f"{op} takes Rd,operand2")
        return op, _reg(args[0]), 0, _operand2(args[1:], op)
    if len(args) < 3:               # ADD R3,R1,R2
        raise ValueError(f"{op} takes Rd,Rn,operand2")
    return op, _reg(args[0]), _reg(args[1]), _operand2(args[2:], op)


def assemble(lines):
    return [(op, rd, rn, op2, encode(op, rd, rn, op2)) for op, rd, rn, op2 in map(parse, lines)]


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
    for addr, (op, rd, rn, op2, word) in enumerate(prog):
        B = op2.value(regs)
        r = m.alu(OPS[op], regs[rn], B, Cflag)
        wrote = None
        if r["write"]:
            regs[rd] = r["result"]
            wrote = rd
        trace.append((addr, op, rd, rn, op2, B, word, r, wrote))
    return trace, regs


def instr_text(op, rd, rn, op2):
    if op in NO_RD:
        return f"{op} R{rn},{op2.text()}"
    if op in NO_RN:
        return f"{op} R{rd},{op2.text()}"
    return f"{op} R{rd},R{rn},{op2.text()}"


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
    print(f"  {'addr':5}{'instruction':26}{'word':12}{'op2':12}{'dec.addr':10}{'ROMword':10}"
          f"{'eng':5}{'wr':4}{'destination becomes':22}")
    print("  " + "-" * 104)
    for addr, op, rd, rn, op2, B, word, r, wrote in trace:
        w = m.rom_word(OPS[op])
        eng = f"{m.ENGINE[r['engine']]:02b}"
        dest = (f"R{wrote} = 0x{r['result']:08X}" if wrote is not None
                else "(no write - flags only)")
        print(f"  0x{addr:02X}  {instr_text(op, rd, rn, op2):25}"
              f"0x{word:08X}  0x{B:08X}  0x{OPS[op]:04X}    0x{w:03x}     "
              f"{eng}   {r['write']}   {dest}")
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
