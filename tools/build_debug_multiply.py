#!/usr/bin/env python3
"""Add verified multiply-family blocks to debug_armv4t_2.circ only."""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from logisim import geometry, model

PATH = Path("debug_armv4t_2.circ")


def attrs_xml(attrs):
    return "".join('      <a name="%s" val="%s"/>\n' % x for x in attrs.items())


def comp(lib, name, loc, **attrs):
    return ('    <comp lib="%s" loc="(%d,%d)" name="%s">\n%s    </comp>\n'
            % (lib, loc[0], loc[1], name, attrs_xml(attrs)))


def subcomp(name, loc):
    return '    <comp loc="(%d,%d)" name="%s"/>\n' % (loc[0], loc[1], name)


def tunnel(loc, label, width=1, facing="east"):
    a = {"facing": facing, "label": label}
    if width != 1:
        a["width"] = str(width)
    return comp("0", "Tunnel", loc, **a)


def pin(loc, label, width=1, output=False):
    a = {"appearance": "classic", "label": label}
    if width != 1:
        a["width"] = str(width)
    if output:
        a["facing"] = "west"
        a["output"] = "true"
    else:
        a["facing"] = "east"
    return comp("0", "Pin", loc, **a)


def circuit(name, body):
    return ('  <circuit name="%s">\n'
            '    <a name="appearance" val="logisim_evolution"/>\n'
            '    <a name="circuit" val="%s"/>\n%s  </circuit>\n'
            % (name, name, body))


def multiply_execute():
    b = []
    ports = [((100, 200), "rm", 32, False), ((100, 260), "rs", 32, False),
             ((100, 320), "acc_lo", 32, False), ((100, 380), "acc_hi", 32, False),
             ((100, 440), "acc", 1, False), ((100, 500), "signed", 1, False),
             ((1100, 240), "lo", 32, True), ((1100, 360), "hi", 32, True)]
    for loc, lab, width, out in ports:
        b += [pin(loc, lab, width, out), tunnel(loc, lab.upper(), width)]

    # Multiplier ports: A(-40,-10), B(-40,+10), low(0,0), cin(-20,-20), high(-20,+20).
    for loc, mode, prefix in (((400, 230), "unsigned", "U"),
                              ((400, 350), "twosComplement", "S")):
        b.append(comp("3", "Multiplier", loc, width="32", mode=mode,
                      label=prefix + "MUL"))
        for pt, lab in (((loc[0]-40, loc[1]-10), "RM"),
                        ((loc[0]-40, loc[1]+10), "RS"),
                        ((loc[0]-20, loc[1]-20), "ZERO32"),
                        ((loc[0], loc[1]), prefix + "LOW"),
                        ((loc[0]-20, loc[1]+20), prefix + "HIGH")):
            b.append(tunnel(pt, lab, 32))

    b += [comp("0", "Constant", (180, 560), width="32", value="0x0"),
          tunnel((180, 560), "ZERO32", 32),
          comp("0", "Constant", (180, 600), value="0x0"),
          tunnel((180, 600), "ZERO1")]

    # Select signed/unsigned raw product halves.
    for loc, raw in (((600, 240), "RAW_LOW"), ((600, 360), "RAW_HIGH")):
        b.append(comp("4", "Multiplexer", loc, width="32"))
        b += [tunnel((loc[0]-30, loc[1]-10), "U" + ("LOW" if "LOW" in raw else "HIGH"), 32),
              tunnel((loc[0]-30, loc[1]+10), "S" + ("LOW" if "LOW" in raw else "HIGH"), 32),
              tunnel((loc[0]-20, loc[1]+20), "SIGNED"),
              tunnel(loc, raw, 32)]

    # 64-bit accumulate: low first, then high + carry.
    b += [comp("3", "Adder", (760, 240), width="32", label="ADD_LOW"),
          tunnel((720, 230), "RAW_LOW", 32), tunnel((720, 250), "ACC_LO", 32),
          tunnel((740, 220), "ZERO1"), tunnel((760, 240), "SUM_LOW", 32),
          tunnel((740, 260), "LOW_CARRY"),
          comp("3", "Adder", (760, 360), width="32", label="ADD_HIGH"),
          tunnel((720, 350), "RAW_HIGH", 32), tunnel((720, 370), "ACC_HI", 32),
          tunnel((740, 340), "LOW_CARRY"), tunnel((760, 360), "SUM_HIGH", 32)]

    for loc, raw, summed, out in (((920, 240), "RAW_LOW", "SUM_LOW", "LO"),
                                  ((920, 360), "RAW_HIGH", "SUM_HIGH", "HI")):
        b += [comp("4", "Multiplexer", loc, width="32"),
              tunnel((890, loc[1]-10), raw, 32), tunnel((890, loc[1]+10), summed, 32),
              tunnel((900, loc[1]+20), "ACC"), tunnel(loc, out, 32)]
    return circuit("multiply_execute", "".join(b))


def multiply_decode():
    b = []
    for loc, lab, width, out in [((100, 200), "instr_27_4", 24, False),
                                 ((100, 500), "opcode", 4, False),
                                 ((1100, 200), "mul_any", 1, True),
                                 ((1100, 260), "mul_short", 1, True),
                                 ((1100, 320), "mul_long", 1, True),
                                 ((1100, 380), "mul_acc", 1, True),
                                 ((1100, 440), "mul_signed", 1, True)]:
        b += [pin(loc, lab, width, out), tunnel(loc, lab.upper(), width)]

    # instr_27_4 -> low nibble instr[7:4], middle, high nibble instr[27:24].
    split_attrs = {"incoming": "24", "fanout": "3", "appear": "right", "spacing": "4"}
    for bit in range(24):
        split_attrs["bit%d" % bit] = "0" if bit < 4 else ("1" if bit < 20 else "2")
    sp = model.Component("Splitter", "0", (300, 200), split_attrs)
    b.append(comp("0", "Splitter", sp.loc, **split_attrs))
    p = {x.name: x.at(sp) for x in geometry.ports(None, sp)}
    b += [tunnel(p["combined"], "INSTR_27_4", 24), tunnel(p["bit0"], "I7_4", 4),
          tunnel(p["bit2"], "I27_24", 4)]

    # Comparators for the two fixed nibbles.
    for loc, signal, value, out in (((520, 180), "I7_4", 9, "LOW9"),
                                    ((520, 280), "I27_24", 0, "HIGH0")):
        b += [comp("5", "Comparator", loc, width="4"),
              tunnel((loc[0]-40, loc[1]-10), signal, 4),
              comp("0", "Constant", (loc[0]-40, loc[1]+10), width="4", value="0x%x" % value),
              tunnel((loc[0], loc[1]), out)]  # equality output is centre/east

    b += [comp("1", "AND Gate", (680, 230), label="MUL_SIGNATURE"),
          tunnel((630, 210), "LOW9"), tunnel((630, 250), "HIGH0"),
          tunnel((680, 230), "SIG")]

    # Split opcode to bits 0..3.
    opattrs = {"incoming": "4", "fanout": "4", "appear": "right", "spacing": "4"}
    osp = model.Component("Splitter", "0", (300, 500), opattrs)
    b.append(comp("0", "Splitter", osp.loc, **opattrs))
    op = {x.name: x.at(osp) for x in geometry.ports(None, osp)}
    b.append(tunnel(op["combined"], "OPCODE", 4))
    for k in range(4):
        b.append(tunnel(op["bit%d" % k], "OP%d" % k))

    b += [comp("1", "NOT Gate", (520, 480)), tunnel((490, 480), "OP2"), tunnel((520, 480), "N_OP2"),
          comp("1", "NOT Gate", (520, 540)), tunnel((490, 540), "OP1"), tunnel((520, 540), "N_OP1")]

    # short = signature & !bit23 & !bit22; long = signature & bit23.
    b += [comp("1", "AND Gate", (760, 480), inputs="3", label="SHORT"),
          tunnel((710, 460), "SIG"), tunnel((710, 480), "N_OP2"), tunnel((710, 500), "N_OP1"),
          tunnel((760, 480), "MUL_SHORT"),
          comp("1", "AND Gate", (760, 560), label="LONG"),
          tunnel((710, 540), "SIG"), tunnel((710, 580), "OP2"), tunnel((760, 560), "MUL_LONG"),
          comp("1", "OR Gate", (900, 520), label="ANY"),
          tunnel((850, 500), "MUL_SHORT"), tunnel((850, 540), "MUL_LONG"), tunnel((900, 520), "MUL_ANY"),
          comp("1", "AND Gate", (900, 620), label="ACC"),
          tunnel((850, 600), "SIG"), tunnel((850, 640), "OP0"), tunnel((900, 620), "MUL_ACC"),
          comp("1", "AND Gate", (900, 700), label="SIGNED_LONG"),
          tunnel((850, 680), "MUL_LONG"), tunnel((850, 720), "OP1"), tunnel((900, 700), "MUL_SIGNED")]
    return circuit("multiply_decode", "".join(b))


def main():
    text = PATH.read_text()
    if '<circuit name="multiply_execute"' in text:
        raise SystemExit("multiply blocks already present")
    anchor = text.index("  <circuit name=\"main\"")
    text = text[:anchor] + multiply_decode() + multiply_execute() + text[anchor:]
    PATH.write_text(text)
    print("added multiply_decode and multiply_execute to", PATH)


if __name__ == "__main__":
    main()
