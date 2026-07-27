#!/usr/bin/env python3
"""
blockdiag.py  —  minimal schematic-symbol renderer for the CustomCPU build.
================================================================================
Draw a circuit as a NAMED BOX with labeled arrows going IN (left) and OUT (right).
Multi-bit signals get a bus tick with the width. Chain boxes left-to-right; ports
with the same label auto-wire. No dependencies — writes an SVG you open in a browser.

Usage (see __main__ at bottom):
    d = Diagram("partial-product slice")
    a = d.box("PP_row",  inputs=[("Rm",32), ("Rs[i]",1)], outputs=[("row",32)])
    b = d.box("shift <<i", inputs=[("row",32)],           outputs=[("P_i",32)])
    d.note("P_i = (Rm AND Rs[i]) << i   (low-32, top bits truncated)")
    d.save("pp_slice.svg")
"""

# ---- geometry knobs --------------------------------------------------------
BW, GAP   = 170, 130      # box width, gap between boxes
LM, RM    = 160, 160      # left / right margin (room for external labels)
TOP       = 70            # space above boxes (title)
PORTPITCH = 46            # vertical spacing per port
MINH      = 92            # minimum box height
STUB      = 95            # length of external in/out arrows


class Box:
    def __init__(self, name, inputs, outputs):
        self.name = name
        self.inputs  = [(str(l), str(w)) for l, w in inputs]
        self.outputs = [(str(l), str(w)) for l, w in outputs]
        self.x = 0
        self.h = max(MINH, PORTPITCH * max(len(inputs), len(outputs), 1) + 20)

    def _ports(self, ports, x):
        n = len(ports)
        return [(lbl, w, x, self.cy - self.h / 2 + self.h * (k + 1) / (n + 1))
                for k, (lbl, w) in enumerate(ports)]

    def in_ports(self):  return self._ports(self.inputs,  self.x)
    def out_ports(self): return self._ports(self.outputs, self.x + BW)


class Diagram:
    def __init__(self, title=""):
        self.title = title
        self.boxes = []
        self.notes = []

    def box(self, name, inputs=(), outputs=()):
        b = Box(name, inputs, outputs)
        self.boxes.append(b)
        return b

    def note(self, text):
        self.notes.append(text)

    # -- svg primitives ------------------------------------------------------
    @staticmethod
    def _esc(s):
        return str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

    @classmethod
    def _txt(cls, x, y, s, size=13, anchor="middle", weight="normal", color="#222"):
        s = cls._esc(s)
        return (f'<text x="{x:.1f}" y="{y:.1f}" font-family="monospace" '
                f'font-size="{size}" text-anchor="{anchor}" '
                f'font-weight="{weight}" fill="{color}">{s}</text>')

    @staticmethod
    def _arrow(x1, y1, x2, y2):
        return (f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}" '
                f'stroke="#333" stroke-width="1.6" marker-end="url(#ah)"/>')

    def _bus_tick(self, mx, my, w):
        if w == "1":
            return ""   # single wire, no tick
        return (f'<line x1="{mx-6:.1f}" y1="{my+6:.1f}" x2="{mx+6:.1f}" '
                f'y2="{my-6:.1f}" stroke="#333" stroke-width="1.4"/>'
                + self._txt(mx, my - 11, w, size=11, color="#c0392b"))

    def save(self, path):
        # layout: place boxes, share a common centre line
        maxh = max((b.h for b in self.boxes), default=MINH)
        cy = TOP + maxh / 2
        for i, b in enumerate(self.boxes):
            b.x = LM + i * (BW + GAP)
            b.cy = cy

        # collect output ports for auto-wiring (label -> (box_index, port))
        out_index = {}
        for i, b in enumerate(self.boxes):
            for p in b.out_ports():
                out_index.setdefault(p[0], []).append((i, p))

        svg = []
        consumed_out = set()  # (box_index, label) outputs that feed a next box

        # --- boxes + names ---
        for b in self.boxes:
            top = b.cy - b.h / 2
            svg.append(f'<rect x="{b.x}" y="{top:.1f}" width="{BW}" height="{b.h:.1f}" '
                       f'rx="10" fill="#f4f6f8" stroke="#333" stroke-width="2"/>')
            svg.append(self._txt(b.x + BW / 2, b.cy + 5, b.name, size=15, weight="bold"))

        # --- wires ---
        for i, b in enumerate(self.boxes):
            # inputs: either wired from a previous box's output, or external
            for lbl, w, px, py in b.in_ports():
                src = None
                for (bi, sp) in out_index.get(lbl, []):
                    if bi < i:
                        src = (bi, sp)
                if src:
                    bi, (slbl, sw, sx, sy) = src
                    consumed_out.add((bi, slbl))
                    mx = (sx + px) / 2
                    # orthogonal route: out, vertical, in
                    svg.append(f'<polyline points="{sx:.1f},{sy:.1f} {mx:.1f},{sy:.1f} '
                               f'{mx:.1f},{py:.1f} {px:.1f},{py:.1f}" fill="none" '
                               f'stroke="#333" stroke-width="1.6" marker-end="url(#ah)"/>')
                    svg.append(self._bus_tick(mx, (sy + py) / 2, w))
                else:
                    svg.append(self._arrow(px - STUB, py, px, py))
                    svg.append(self._txt(px - STUB - 4, py - 8, lbl, anchor="end", weight="bold"))
                    svg.append(self._bus_tick(px - STUB / 2, py, w))

        # external outputs (not consumed by any later box)
        for i, b in enumerate(self.boxes):
            for lbl, w, px, py in b.out_ports():
                if (i, lbl) in consumed_out:
                    continue
                svg.append(self._arrow(px, py, px + STUB, py))
                svg.append(self._txt(px + STUB + 4, py - 8, lbl, anchor="start", weight="bold"))
                svg.append(self._bus_tick(px + STUB / 2, py, w))

        # canvas size
        width  = LM + len(self.boxes) * BW + (len(self.boxes) - 1) * GAP + RM
        height = TOP + maxh + 40 + 22 * len(self.notes)

        head = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" '
                f'height="{height}" viewBox="0 0 {width} {height}">',
                '<defs><marker id="ah" markerWidth="10" markerHeight="10" refX="8" '
                'refY="3" orient="auto" markerUnits="userSpaceOnUse">'
                '<path d="M0,0 L8,3 L0,6 Z" fill="#333"/></marker></defs>',
                f'<rect width="{width}" height="{height}" fill="white"/>']
        if self.title:
            head.append(self._txt(width / 2, 34, self.title, size=18, weight="bold"))

        # notes at the bottom
        ny = TOP + maxh + 28
        for n in self.notes:
            svg.append(self._txt(LM, ny, n, size=12, anchor="start", color="#444"))
            ny += 22

        with open(path, "w") as f:
            f.write("\n".join(head + svg) + "\n</svg>\n")
        print(f"wrote {path}  ({width}x{height})")


def pp_array(path="pp_array.svg", shown=(0, 1, 2, 3, "gap", 31)):
    """The full partial_products block: Rm shared bus + Rs splitter feeding
    32 row slices (PP_row -> shift<<i).  Abbreviated: rows 4..30 are identical."""
    g = Diagram()                      # reuse its svg helpers
    W = 770
    y0, pitch = 120, 72
    ys = [None if r == "gap" else y0 + k * pitch for k, r in enumerate(shown)]
    bottom = y0 + (len(shown) - 1) * pitch
    H = bottom + 90

    Xrm, XrsL, XrsR = 250, 150, 214    # Rm trunk x ; Rs splitter box l/r
    Xpp, XppR = 300, 430               # PP_row box
    Xsh, XshR = 500, 584               # shift box
    Xout = 674                         # P_i arrow end

    s = ['<svg xmlns="http://www.w3.org/2000/svg" '
         f'width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
         '<defs><marker id="ah" markerWidth="10" markerHeight="10" refX="8" refY="3" '
         'orient="auto" markerUnits="userSpaceOnUse"><path d="M0,0 L8,3 L0,6 Z" '
         'fill="#333"/></marker></defs>',
         f'<rect width="{W}" height="{H}" fill="white"/>',
         g._txt(W / 2, 34, "partial_products  —  32-row AND array", 18, weight="bold")]

    # shared Rm bus (vertical trunk) + its top input
    s.append(f'<line x1="{Xrm}" y1="90" x2="{Xrm}" y2="{bottom+12}" stroke="#333" stroke-width="2"/>')
    s.append(g._arrow(Xrm, 60, Xrm, 90))
    s.append(g._txt(Xrm, 52, "Rm  /32", 13, weight="bold"))

    # Rs splitter box + its input
    yc = (96 + bottom + 12) / 2
    s.append(f'<rect x="{XrsL}" y="96" width="{XrsR-XrsL}" height="{bottom+12-96}" '
             f'rx="8" fill="#eef2f5" stroke="#333" stroke-width="2"/>')
    s.append(g._txt((XrsL+XrsR)/2, yc-6, "Rs", 15, weight="bold"))
    s.append(g._txt((XrsL+XrsR)/2, yc+12, "32→1", 11, color="#555"))
    s.append(g._arrow(70, yc, XrsL, yc))
    s.append(g._txt(66, yc-6, "Rs", 13, anchor="end", weight="bold"))
    s.append(g._bus_tick((70+XrsL)/2, yc, "32"))

    for r, ry in zip(shown, ys):
        if ry is None:                 # ellipsis break: three drawn dots (font-safe)
            gy = y0 + shown.index("gap") * pitch
            for x in (Xrm, (XrsL+XrsR)/2, (Xpp+XppR)/2, (Xsh+XshR)/2, Xout+10):
                for dy in (-9, 0, 9):
                    s.append(f'<circle cx="{x:.1f}" cy="{gy+dy:.1f}" r="2.4" fill="#888"/>')
            continue
        # PP_row box
        s.append(f'<rect x="{Xpp}" y="{ry-24}" width="{XppR-Xpp}" height="48" rx="8" '
                 f'fill="#f4f6f8" stroke="#333" stroke-width="2"/>')
        s.append(g._txt((Xpp+XppR)/2, ry+5, "PP_row", 14, weight="bold"))
        # shift box
        s.append(f'<rect x="{Xsh}" y="{ry-24}" width="{XshR-Xsh}" height="48" rx="8" '
                 f'fill="#f4f6f8" stroke="#333" stroke-width="2"/>')
        s.append(g._txt((Xsh+XshR)/2, ry+5, f"«{r}", 15, weight="bold"))
        # Rm tap (32) into PP_row top-left
        s.append(g._arrow(Xrm, ry-12, Xpp, ry-12))
        s.append(g._bus_tick((Xrm+Xpp)/2, ry-12, "32"))
        # Rs[r] tap (1 bit) into PP_row bottom-left
        s.append(g._arrow(XrsR, ry+12, Xpp, ry+12))
        s.append(g._txt(XrsR+3, ry+12-5, f"Rs[{r}]", 10, anchor="start", color="#555"))
        # PP_row -> shift
        s.append(g._arrow(XppR, ry, Xsh, ry))
        s.append(g._bus_tick((XppR+Xsh)/2, ry, "32"))
        # shift -> P_r out
        s.append(g._arrow(XshR, ry, Xout, ry))
        s.append(g._bus_tick((XshR+Xout)/2, ry, "32"))
        s.append(g._txt(Xout+6, ry+4, f"P_{r}", 13, anchor="start", weight="bold"))

    s.append(g._txt(150, bottom+56, "row i = Rm AND sext(Rs[i]);  P_i = row << i  (low-32).  "
                    "rows 4..30 identical.", 12, anchor="start", color="#444"))
    s.append(g._txt(150, bottom+76, "P_0..P_31  →  CSA tree (block 4).  probe: Rm=13 Rs=11 → "
                    "P0=0xD P1=0x1A P3=0x68, Σ=143.", 12, anchor="start", color="#444"))

    with open(path, "w") as f:
        f.write("\n".join(s) + "\n</svg>\n")
    print(f"wrote {path}  ({W}x{H})")


# ---------------------------------------------------------------------------
if __name__ == "__main__":
    # ONE SLICE of the multiplier array: the repeating row unit (instanced x32).
    d = Diagram("multiplier — one row slice  (repeat x32, i = 0..31)")
    d.box("PP_row",   inputs=[("Rm", 32), ("Rs[i]", 1)], outputs=[("row", 32)])
    d.box("shift <<i", inputs=[("row", 32)],             outputs=[("P_i", 32)])
    d.note("row  = Rm AND sext(Rs[i])      (Rs[i] broadcast to 32 lanes)")
    d.note("P_i  = row << i                (shift = wire placement; low-32 truncates top i bits)")
    d.note("probe: Rm=0xD, Rs[3]=1  ->  row=0x0000000D,  P_3=0x00000068")
    d.save("pp_slice.svg")

    # THE FULL ARRAY: 32 rows, abbreviated.
    pp_array("pp_array.svg")

    # BLOCK 3: the 3:2 compressor tile the whole tree is built from.
    c = Diagram("csa_3to2  —  3:2 compressor (one tile of the tree)")
    c.box("csa_3to2", inputs=[("X", 32), ("Y", 32), ("Z", 32)],
                      outputs=[("sum", 32), ("carry", 32)])
    c.note("sum   = X ^ Y ^ Z              (per-bit, NO carry chain — constant delay)")
    c.note("carry = maj(X,Y,Z) << 1        (maj = XY + XZ + YZ)")
    c.note("invariant: X+Y+Z == sum+carry (mod 2^32).   probe (1,1,1) -> sum=0x1 carry=0x2")
    c.save("csa_slice.svg")


def csa_chain(path="csa_tree.svg"):
    """CSA reduction chain: a running (sum,carry) pair, each tile absorbs one P_k.
    30 identical csa_3to2 tiles: 32 partial products -> 2 vectors -> ks_32b."""
    g = Diagram()
    CY, th, tw = 220, 56, 72
    x1, x2, x3, x30, xks, ksw = 130, 270, 410, 650, 810, 94
    W, H = 1080, 340
    top = CY - th / 2

    def csa(x, lab):
        return (f'<rect x="{x}" y="{top:.1f}" width="{tw}" height="{th}" rx="8" '
                f'fill="#f4f6f8" stroke="#333" stroke-width="2"/>'
                + g._txt(x + tw / 2, CY - 3, "csa", 13, weight="bold")
                + g._txt(x + tw / 2, CY + 14, lab, 11, color="#555"))

    s = ['<svg xmlns="http://www.w3.org/2000/svg" '
         f'width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
         '<defs><marker id="ah" markerWidth="10" markerHeight="10" refX="8" refY="3" '
         'orient="auto" markerUnits="userSpaceOnUse"><path d="M0,0 L8,3 L0,6 Z" '
         'fill="#333"/></marker></defs>',
         f'<rect width="{W}" height="{H}" fill="white"/>',
         g._txt(W / 2, 34, "csa reduction chain  —  30 tiles: 32 vectors → 2 → ks_32b",
                17, weight="bold")]

    for x, lab in [(x1, "#1"), (x2, "#2"), (x3, "#3"), (x30, "#30")]:
        s.append(csa(x, lab))
    s.append(f'<rect x="{xks}" y="{top:.1f}" width="{ksw}" height="{th}" rx="8" '
             f'fill="#eef2f5" stroke="#333" stroke-width="2"/>')
    s.append(g._txt(xks + ksw / 2, CY + 5, "ks_32b", 14, weight="bold"))

    # tile #1 seeds: P0, P1, P2 from the left
    for k, dy in [(0, -16), (1, 0), (2, 16)]:
        s.append(g._arrow(x1 - 72, CY + dy, x1, CY + dy))
        s.append(g._txt(x1 - 76, CY + dy - 5, f"P{k}", 12, anchor="end", weight="bold"))
        s.append(g._bus_tick(x1 - 36, CY + dy, "32"))

    # inter-tile (sum,carry) links
    def link(px, nx, label=False):
        for dy, nm in ((-12, "sum"), (12, "carry")):
            s.append(g._arrow(px + tw, CY + dy, nx, CY + dy))
            s.append(g._bus_tick((px + tw + nx) / 2, CY + dy, "32"))
            if label:
                s.append(g._txt((px + tw + nx) / 2, CY + dy - 21, nm, 10, color="#888"))
    link(x1, x2, label=True)
    link(x2, x3)

    # top P_k feeds for #2,#3,#30
    for x, lbl in [(x2, "P3"), (x3, "P4"), (x30, "P31")]:
        mx = x + tw / 2
        s.append(g._arrow(mx, top - 34, mx, top))
        s.append(g._txt(mx, top - 40, lbl, 12, weight="bold"))

    # ellipsis between #3 and #30
    for dx in (0, 18, 36):
        s.append(f'<circle cx="{x3+tw+52+dx}" cy="{CY}" r="2.6" fill="#888"/>')

    # #30 left inputs continue from the dots (short stubs)
    for dy in (-12, 12):
        s.append(g._arrow(x30 - 46, CY + dy, x30, CY + dy))
        s.append(g._bus_tick(x30 - 23, CY + dy, "32"))

    # #30 -> ks_32b
    for dy, nm in ((-12, "sum"), (12, "carry")):
        s.append(g._arrow(x30 + tw, CY + dy, xks, CY + dy))
        s.append(g._bus_tick((x30 + tw + xks) / 2, CY + dy, "32"))
        s.append(g._txt((x30 + tw + xks) / 2, CY + dy - 21, nm, 10, color="#888"))

    # ks_32b -> product
    s.append(g._arrow(xks + ksw, CY, xks + ksw + 78, CY))
    s.append(g._bus_tick(xks + ksw + 39, CY, "32"))
    s.append(g._txt(xks + ksw + 82, CY + 4, "product", 13, anchor="start", weight="bold"))

    s.append(g._txt(130, CY + 78, "tile #1 = csa(P0,P1,P2);  tile #k (k≥2) = csa(prev_sum, "
                    "prev_carry, P_{k+1}).   30 tiles total.", 12, anchor="start", color="#444"))
    s.append(g._txt(130, CY + 98, "each tile removes one vector: 32 − 2 = 30 tiles.  final "
                    "(sum,carry) → ks_32b = the ONE real add.", 12, anchor="start", color="#444"))

    with open(path, "w") as f:
        f.write("\n".join(s) + "\n</svg>\n")
    print(f"wrote {path}  ({W}x{H})")


if __name__ == "__main__":
    # BLOCK 4: the reduction chain — 30 tiles absorb 32 vectors down to 2.
    csa_chain("csa_tree.svg")


def barrel_diagrams():
    """Barrel shifter: one stage symbol + the 5-stage chain."""
    # --- one stage ---
    d = Diagram("bs_stage_d  —  one barrel-shifter stage (d = 1,2,4,8,16)")
    d.box("bs_stage_d", inputs=[("in", 32), ("en", 1), ("type", 2)],
                        outputs=[("out", 32)])
    d.note("en = amt[k]   type: 00=LSL 01=LSR 10=ASR 11=ROR")
    d.note("shifted = 4:1 mux(type) over four WIRE-PLACED variants of in:")
    d.note("   LSL: {in[31-d:0], d'b0}      LSR: {d'b0, in[31:d]}")
    d.note("   ASR: {d{in[31]}, in[31:d]}   ROR: {in[d-1:0], in[31:d]}")
    d.note("out = 2:1 mux(en) : en=0 -> in (pass) ; en=1 -> shifted")
    d.save("bs_stage.svg")

    # --- the 5-stage chain ---
    c = Diagram("barrel_shifter  —  5 stages, shift = amt[4:0]")
    c.box("bs_stage_1",  inputs=[("in", 32),  ("amt0", 1), ("type", 2)], outputs=[("x1", 32)])
    c.box("bs_stage_2",  inputs=[("x1", 32),  ("amt1", 1), ("type", 2)], outputs=[("x2", 32)])
    c.box("bs_stage_4",  inputs=[("x2", 32),  ("amt2", 1), ("type", 2)], outputs=[("x3", 32)])
    c.box("bs_stage_8",  inputs=[("x3", 32),  ("amt3", 1), ("type", 2)], outputs=[("x4", 32)])
    c.box("bs_stage_16", inputs=[("x4", 32),  ("amt4", 1), ("type", 2)], outputs=[("out", 32)])
    c.note("stage k shifts by 2^k iff amt[k]=1.  1+2+4+8+16 covers every shift 0..31.")
    c.note("depth = log2(32) = 5.  Same reason the CSA tree beats a ripple chain.")
    c.note("COMPOSITION INVARIANT (proved, 1280 cases): staged == direct shift.")
    c.save("barrel_chain.svg")


if __name__ == "__main__":
    barrel_diagrams()


def cpu_datapath(path="cpu_datapath.svg"):
    """The whole single-cycle datapath on one sheet."""
    g = Diagram()
    W, H = 1260, 700

    def box(x, y, w, h, title, sub="", fill="#f4f6f8"):
        out = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="9" '
               f'fill="{fill}" stroke="#333" stroke-width="2"/>']
        out.append(g._txt(x + w/2, y + h/2 + (-3 if sub else 5), title, 14, weight="bold"))
        if sub:
            out.append(g._txt(x + w/2, y + h/2 + 14, sub, 10, color="#666"))
        return out

    def arr(x1, y1, x2, y2, label="", w="", ldy=-9):
        o = [g._arrow(x1, y1, x2, y2)]
        mx, my = (x1+x2)/2, (y1+y2)/2
        if w:     o.append(g._bus_tick(mx, my, w))
        if label: o.append(g._txt(mx, my + ldy, label, 10, color="#555"))
        return o

    s = ['<svg xmlns="http://www.w3.org/2000/svg" '
         f'width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
         '<defs><marker id="ah" markerWidth="10" markerHeight="10" refX="8" refY="3" '
         'orient="auto" markerUnits="userSpaceOnUse"><path d="M0,0 L8,3 L0,6 Z" '
         'fill="#333"/></marker></defs>',
         f'<rect width="{W}" height="{H}" fill="white"/>',
         g._txt(W/2, 32, "cpu_single_cycle  —  the whole datapath", 18, weight="bold")]

    # ---- FETCH row ----
    s += box(50, 100, 130, 70, "pc_fetch", "PC += 4")
    s += box(250, 100, 130, 70, "instr_rom", "16 x 32")
    s += box(450, 80, 110, 110, "instr_fields", "split 32->7")
    s += arr(180, 135, 250, 135, "PC_word", "4")
    s += arr(380, 135, 450, 135, "instr", "32")

    # ---- DECODE row (up) ----
    s += box(640, 60, 110, 60, "dec_addr", "combine 16")
    s += box(800, 60, 130, 60, "decode_rom", "64K x 10")
    s += box(980, 60, 120, 60, "ctrl_fields", "split 10->6")
    s += arr(560, 110, 640, 92, "opcode instr[24:21]", "4", -8)
    s += arr(750, 90, 800, 90, "", "16")
    s += arr(930, 90, 980, 90, "", "10")
    s += [g._txt(690, 145, "bit4=is_MUL=0", 9, color="#c0392b")]
    s += [g._txt(690, 158, "bits15..5 = 0", 9, color="#c0392b")]

    # ---- EXECUTE row ----
    s += box(620, 300, 160, 150, "reg16x32", "RA RB WA WD WE")
    s += box(880, 300, 140, 150, "ALU", "3 engines")
    s += arr(560, 150, 620, 330, "Rn -> RA", "4", -6)
    s += arr(560, 165, 620, 360, "Rm -> RB", "4", 12)
    s += arr(560, 180, 620, 390, "Rd -> WA", "4", 12)
    s += arr(780, 340, 880, 340, "RD_A -> A", "32")
    s += arr(780, 375, 880, 375, "RD_B -> B", "32")
    s += [g._txt(830, 402, "shifter", 9, color="#c0392b"),
          g._txt(830, 413, "BYPASSED", 9, color="#c0392b")]

    # control down into ALU
    s += arr(1040, 120, 1040, 300, "engine_sel a_inv b_inv", "", -6)
    s += [g._txt(1105, 200, "cin_sel logic_sel", 9, color="#555"),
          g._txt(1105, 213, "write_enable", 9, color="#555")]

    # ---- WRITEBACK loop ----
    s += [f'<polyline points="1020,430 1060,430 1060,500 560,500 560,430 620,430" '
          f'fill="none" stroke="#333" stroke-width="1.8" marker-end="url(#ah)"/>']
    s += [g._txt(800, 492, "ALU.result -> WD   (writeback)", 11, weight="bold", color="#222")]
    s += [g._txt(800, 520, "ALU.write_enable_out -> WE   <-- the signal that finally ACTS",
                 10, color="#c0392b")]

    # ---- clock ----
    s += box(50, 560, 110, 50, "CLK", "Ctrl+T", "#eef2f5")
    s += arr(105, 560, 105, 175, "", "")
    s += [f'<polyline points="160,585 700,585 700,450" fill="none" stroke="#333" '
          f'stroke-width="1.6" marker-end="url(#ah)"/>']
    s += [g._txt(400, 578, "CLK -> pc_fetch.CLK  and  reg16x32.CLK", 10, color="#555")]

    # ---- R3 tap ----
    s += arr(700, 300, 700, 250, "", "")
    s += [g._txt(700, 240, "R3_OUTPUT -> probe", 10, weight="bold", color="#c0392b")]

    # ---- notes ----
    ny = 630
    for n in ["Constants to tie: pc_fetch.RST=0 .BRANCH=0 .IMM=0(32) | reg16x32.RST=0 | ALU.Cflag=0 ALU.unused=0",
              "Preload R1=5 R2=3 (descend into reg16x32).  Clock once -> R3 = 0x00000008.  THAT IS M1."]:
        s.append(g._txt(50, ny, n, 11, anchor="start", color="#444")); ny += 20

    with open(path, "w") as f:
        f.write("\n".join(s) + "\n</svg>\n")
    print(f"wrote {path}  ({W}x{H})")


if __name__ == "__main__":
    cpu_datapath()
