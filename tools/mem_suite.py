#!/usr/bin/env python3
"""Discriminator suite for stage_MEM, groups A-C.

Runs against the LIVE armv4t_2.circ through the Python simulator -- no copy, no
jar.  stage_WB does not exist, so loaded data never reaches a register; these
cases observe MEM's own outputs and the RAM contents directly instead.

Timing note that cost me one wrong reading: the RAM read is latched on the
FALLING edge of the load's own cycle, so `load_data` is correct on the SAME row
as the load instruction, not the row after.  A test that reads the next row
reports a false failure.
"""
import sys
sys.path.insert(0, "/home/junaet/Documents/CustomCPU")
import tools.pysim as P

CIRC = sys.argv[1] if len(sys.argv) > 1 else P.CIRC


def run(asm, cycles=32):
    s = P.cpu(CIRC)
    words = P.assemble(asm)
    s.load_rom(words, 32)
    s.reset()
    for k, v in s.ties.items():
        s.poke(k, v)
    s.settle()
    rows = []
    for _ in range(cycles):
        rows.append(dict(pc=s.peek("IF.pc_word_addr"), instr=s.peek("IF.instruction"),
                         addr=s.peek("MEM.memory_up_base"), ld=s.peek("MEM.load_data"),
                         rd=s.peek("MEM.mem_read"), we=s.peek("MEM.data_ram_we"),
                         rdb=s.peek("ID.rd_b"), we2=s.peek("MEM.we2"),
                         wa2=s.peek("MEM.wa2"), wd2=s.peek("MEM.wd2"),
                         sbwe=s.peek("MEM.sbwe")))
        if s.peek("EX.bx_taken"):
            break
        s.tick("IF.clk")
    return rows, words, s


CASES = []


def case(fn):
    CASES.append(fn)
    return fn


def at(rows, pc):
    hit = [r for r in rows if r["pc"] == pc]
    return hit[0] if hit else None


@case
def store_then_load():
    """A store reaches RAM and a load reads it back."""
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r1, #0x1000
    mov r0, #0xAA
    str r0, [r1]
    ldr r2, [r1]
    bx  lr
""")
    e = []
    st, ld = at(rows, 2), at(rows, 3)
    if st is None or ld is None:
        return "store_then_load", ["program did not execute"]
    if st["addr"] != 0x1000: e.append("store address %08x, expected 00001000" % st["addr"])
    if st["we"] != 1:        e.append("data_ram_we low on the store")
    if st["rdb"] != 0xAA:    e.append("rd_b=%08x on the store, expected 000000aa "
                                      "(stage_ID must steer RB to Rd)" % st["rdb"])
    ram = s.ram_dump()
    if ram.get(0) != 0xAA:   e.append("RAM word 0 = %s, expected 0xaa" % ram.get(0))
    if ld["addr"] != 0x1000: e.append("load address %08x, expected 00001000" % ld["addr"])
    if ld["rd"] != 1:        e.append("mem_read low on the load")
    if ld["ld"] != 0xAA:     e.append("load_data=%08x, expected 000000aa" % ld["ld"])
    return "store_then_load", e


@case
def literal_pool():
    """A load from program space returns the program's own words.

    This is the discriminator the literal-pool ROM exists for: the value read
    back is the instruction encoding at that address, which nothing else in the
    design could produce.
    """
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r1, #0
    ldr r0, [r1]
    ldr r0, [r1, #4]
    bx  lr
""")
    e = []
    for pc, idx in ((1, 0), (2, 1)):
        r = at(rows, pc)
        if r is None:
            e.append("pc=%d never executed" % pc); continue
        if r["ld"] != w[idx]:
            e.append("load from address %d gave %08x, expected the program word %08x"
                     % (idx * 4, r["ld"], w[idx]))
        if r["rd"] != 1:
            e.append("mem_read low on the program-space load at pc=%d" % pc)
    return "literal_pool", e


@case
def memory_map_decode():
    """Same word index, different memory -- only addr[12] tells them apart.

    Address 0x0000 is ROM word 0 and 0x1000 is RAM word 0.  Both resolve to word
    index 0, so a broken addr[12] decode makes the two reads agree.  Putting a
    distinct value in RAM word 0 first is what makes them disagree.
    """
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r1, #0x1000
    mov r0, #0x5A
    str r0, [r1]
    ldr r2, [r1]
    mov r1, #0
    ldr r2, [r1]
    bx  lr
""")
    e = []
    ram_read, rom_read = at(rows, 3), at(rows, 5)
    if ram_read is None or rom_read is None:
        return "memory_map_decode", ["program did not execute"]
    if ram_read["ld"] != 0x5A:
        e.append("RAM word 0 read %08x, expected 0000005a" % ram_read["ld"])
    if rom_read["ld"] != w[0]:
        e.append("ROM word 0 read %08x, expected %08x (the first instruction)"
                 % (rom_read["ld"], w[0]))
    if ram_read["ld"] == rom_read["ld"]:
        e.append("both reads returned the same value -- addr[12] is not selecting")
    return "memory_map_decode", e


@case
def pre_vs_post_index():
    """Pre- and post-index put the data at DIFFERENT addresses.

    `memory_up_base` is the writeback value, not the address used: for a
    post-index store the access happens at the ORIGINAL base and only the
    writeback sees base+offset.  Checking where the word actually lands is what
    tells the two apart -- checking memory_up_base alone cannot.
    """
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r0, #0x11
    mov r1, #0x1000
    str r0, [r1, #4]
    mov r0, #0x22
    str r0, [r1], #8
    bx  lr
""")
    e = []
    pre, post = at(rows, 2), at(rows, 4)
    if pre is None or post is None:
        return "pre_vs_post_index", ["program did not execute"]
    if pre["addr"] != 0x1004:
        e.append("pre-index memory_up_base %08x, expected 00001004" % pre["addr"])
    if post["addr"] != 0x1008:
        e.append("post-index writeback value %08x, expected 00001008" % post["addr"])
    ram = s.ram_dump()
    if ram.get(1) != 0x11:
        e.append("pre-indexed store: RAM word 1 = %s, expected 0x11 (dump %s)"
                 % (ram.get(1), {hex(k): hex(v) for k, v in sorted(ram.items())}))
    if ram.get(0) != 0x22:
        e.append("post-indexed store: RAM word 0 = %s, expected 0x22 -- a post-index "
                 "access must use the ORIGINAL base (dump %s)"
                 % (ram.get(0), {hex(k): hex(v) for k, v in sorted(ram.items())}))
    return "pre_vs_post_index", e


@case
def store_below_the_map_is_unchecked():
    """A store below 0x1000 still writes RAM. Known gap, asserted so it stays visible.

    ARM_STATE_AUDIT records this: stores are not range-checked, so a `str` into
    program space writes RAM at the aliased word and a later read of the same
    address returns the ROM word instead. The proper fix is a data abort, which
    needs exceptions. This case exists so the behaviour cannot change silently.
    """
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r0, #0x33
    mov r1, #0x1000
    str r0, [r1, #-4]
    bx  lr
""")
    e = []
    st = at(rows, 2)
    if st is None:
        return "store_below_the_map_is_unchecked", ["program did not execute"]
    if st["addr"] != 0x0FFC:
        e.append("address %08x, expected 00000ffc" % st["addr"])
    ram = s.ram_dump()
    # 0x0ffc -> RAM word index bits[9:2] = 0xff
    if ram.get(0xFF) != 0x33:
        e.append("expected the unchecked write to alias to RAM word 0xff, got %s"
                 % {hex(k): hex(v) for k, v in sorted(ram.items())})
    return "store_below_the_map_is_unchecked", e


@case
def base_writeback_ports():
    """Load writeback uses the SECOND port; store writeback uses the FIRST.

    The primary port is already carrying the loaded word to Rd, so a load that
    also updates its base needs the second port.  A store's primary port is
    free, so `sbwe` steers it to Rn instead.  Getting this backwards makes
    `ldr r0,[r1],#4` write the address into r0.
    """
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r1, #0x1000
    ldr r0, [r1, #4]
    ldr r0, [r1, #4]!
    ldr r0, [r1], #4
    str r0, [r1, #4]!
    bx  lr
""")
    e = []
    # pc, description, we2, sbwe
    want = [(1, "ldr no writeback   (P=1 W=0)", 0, 0),
            (2, "ldr pre-index  wb  (P=1 W=1)", 1, 0),
            (3, "ldr post-index wb  (P=0)    ", 1, 0),
            (4, "str pre-index  wb  (P=1 W=1)", 0, 1)]
    for pc, what, we2, sbwe in want:
        r = at(rows, pc)
        if r is None:
            e.append("pc=%d never executed" % pc); continue
        if r["we2"] != we2:
            e.append("%s: we2=%d expected %d" % (what.strip(), r["we2"], we2))
        if r["sbwe"] != sbwe:
            e.append("%s: sbwe=%d expected %d" % (what.strip(), r["sbwe"], sbwe))
    r = at(rows, 2)
    if r:
        if r["wa2"] != 1:
            e.append("wa2=%d on `ldr r0,[r1,#4]!`, expected 1 (Rn)" % r["wa2"])
        if r["wd2"] != 0x1004:
            e.append("wd2=%08x on `ldr r0,[r1,#4]!`, expected 00001004" % r["wd2"])
    return "base_writeback_ports", e


@case
def writeback_actually_lands():
    """The second write port reaches the register file, not just the pins.

    Three consecutive writeback loads must WALK the base: 0x1000 -> 0x1004 ->
    0x1008 -> 0x100c.  If we2/wa2/wd2 were correct at MEM's pins but never
    committed, every one of these would compute from 0x1000 and the addresses
    would not advance.  This is what distinguishes a wired output from a
    working one.
    """
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r1, #0x1000
    ldr r0, [r1], #4
    ldr r0, [r1], #4
    ldr r0, [r1], #4
    bx  lr
""")
    e = []
    for pc, base in ((1, 0x1000), (2, 0x1004), (3, 0x1008)):
        r = at(rows, pc)
        if r is None:
            e.append("pc=%d never executed" % pc); continue
        if r["addr"] != base + 4:
            e.append("pc=%d: writeback value %08x, expected %08x -- the base did "
                     "not advance, so the second write port is not committing"
                     % (pc, r["addr"], base + 4))
        if r["we2"] != 1:
            e.append("pc=%d: we2 low on a post-index load" % pc)
    return "writeback_actually_lands", e


@case
def wa2_is_rn():
    """wa2 must follow Rn, not Rd -- they differ in every one of these."""
    rows, w, s = run("""
.syntax unified
.arm
.global _start
_start:
    mov r5, #0x1000
    ldr r3, [r5, #4]!
    ldr r7, [r5], #4
    bx  lr
""")
    e = []
    for pc in (1, 2):
        r = at(rows, pc)
        if r is None:
            e.append("pc=%d never executed" % pc); continue
        if r["wa2"] != 5:
            e.append("pc=%d: wa2=%d, expected 5 (Rn=r5, not Rd)" % (pc, r["wa2"]))
    return "wa2_is_rn", e


def main():
    bad = 0
    for fn in CASES:
        name, errs = fn()
        if errs:
            bad += 1
            print("[WRONG] %-22s %s" % (name, (fn.__doc__ or "").splitlines()[0]))
            for x in errs:
                print("           ! %s" % x)
        else:
            print("[ PASS ] %-22s %s" % (name, (fn.__doc__ or "").splitlines()[0]))
    print("\n%d/%d passed   (stage_MEM groups A-C, live %s)"
          % (len(CASES) - bad, len(CASES), CIRC.split("/")[-1]))
    return 1 if bad else 0


sys.exit(main())
