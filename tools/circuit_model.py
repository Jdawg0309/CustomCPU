#!/usr/bin/env python3
"""Comprehensive structural model of armv4t.circ.

Parses every <circuit> in the file, builds T-junction-aware nets (a wire
endpoint landing on another wire's *interior* is a real Logisim connection,
not just two endpoints matching -- naive endpoint-only union-find misses
this and reports false disconnects), and derives a one-hop symbolic
equation for every combinational component. Named signals (Pin/Probe
labels) are used as the readable "API" of each circuit; unlabeled
intermediate nets are inlined into the expression of whatever consumes
them, up to a depth cap, so the output reads like the BUILD_*.md docs
rather than a raw netlist dump.

Usage:
    python3 circuit_model.py map                 # full markdown map -> stdout
    python3 circuit_model.py map > circuit_map.md
    python3 circuit_model.py summary              # just component counts per circuit
    python3 circuit_model.py circuit <name>       # one circuit's equations
"""
import re
import sys
from pathlib import Path

CIRC = Path(__file__).resolve().parent.parent / "armv4t.circ"

# ---------------------------------------------------------------- parsing --

def circuit_spans(src):
    """Return {name: (start, end)} for every <circuit> block (non-greedy,
    matched against its own closing tag, not the nearest one)."""
    spans = {}
    for m in re.finditer(r'<circuit name="([^"]+)">', src):
        name = m.group(1)
        start = m.start()
        end = src.index('\n  </circuit>', start) + len('\n  </circuit>')
        spans[name] = (start, end)
    return spans


COMP_RE = re.compile(
    r'<comp (?:lib="([^"]*)" )?loc="\((-?\d+),(-?\d+)\)" name="([^"]+)"'
    r'(?:\s*/>|>(.*?)</comp>)', re.S)
ATTR_RE = re.compile(r'<a name="([^"]+)" val="([^"]*)"')
WIRE_RE = re.compile(r'<wire from="\((-?\d+),(-?\d+)\)" to="\((-?\d+),(-?\d+)\)"/>')


def parse_circuit(body):
    comps = []
    for m in COMP_RE.finditer(body):
        lib, x, y, name, inner = m.groups()
        attrs = dict(ATTR_RE.findall(inner or ""))
        comps.append({"lib": lib, "loc": (int(x), int(y)), "name": name, "attrs": attrs})
    wires = [((int(a), int(b)), (int(c), int(d))) for a, b, c, d in WIRE_RE.findall(body)]
    return comps, wires


def load_all(path=CIRC):
    src = open(path).read()
    spans = circuit_spans(src)
    circuits = {}
    for name, (i, j) in spans.items():
        circuits[name] = parse_circuit(src[i:j])
    return circuits


# ------------------------------------------------------- T-junction nets --

class UF:
    def __init__(self):
        self.p = {}

    def find(self, x):
        self.p.setdefault(x, x)
        while self.p[x] != x:
            self.p[x] = self.p[self.p[x]]
            x = self.p[x]
        return x

    def union(self, a, b):
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.p[ra] = rb


def on_segment(p, seg):
    (x1, y1), (x2, y2) = seg
    if x1 == x2 == p[0]:
        return min(y1, y2) <= p[1] <= max(y1, y2)
    if y1 == y2 == p[1]:
        return min(x1, x2) <= p[0] <= max(x1, x2)
    return False


def build_nets(wires):
    """T-junction-aware union-find: endpoints of the same wire are unioned,
    AND any endpoint lying on another wire's span is unioned into it too
    (iterated to a fixpoint). This is what actual Logisim connectivity
    does; endpoint-only union-find silently misses branch/trunk topology."""
    uf = UF()
    for a, b in wires:
        uf.union(a, b)
    allpts = set()
    for a, b in wires:
        allpts.add(a)
        allpts.add(b)
    changed = True
    while changed:
        changed = False
        for a, b in wires:
            for p in allpts:
                if uf.find(p) != uf.find(a) and on_segment(p, (a, b)):
                    uf.union(p, a)
                    changed = True
                if uf.find(p) != uf.find(b) and on_segment(p, (a, b)):
                    uf.union(p, b)
                    changed = True
    nets = {}
    for a, b in wires:
        nets.setdefault(uf.find(a), set()).update([a, b])
    return uf, nets


# --------------------------------------------------- component port geometry --

def gate_ports(loc, attrs, kind):
    """Return (out, [inputs]) for a 1- or 2-input Gates-library component,
    east-facing default. Verified empirically against this file's own
    2-input AND/OR/NOT gates (see session notes / block_transfer_control
    work) -- offsets are -50/-20,+20 for 2-input, -30/0 for NOT, all at
    the library's default size=50."""
    f = attrs.get("facing", "east")
    size = int(attrs.get("size", 50))
    x, y = loc
    if kind == "NOT Gate":
        d = 30
        off = {"east": (-d, 0), "west": (d, 0), "north": (0, d), "south": (0, -d)}[f]
        return loc, [(x + off[0], y + off[1])]
    d = size
    span = 20 if size >= 50 else 10
    if f == "east":
        ins = [(x - d, y - span), (x - d, y + span)]
    elif f == "west":
        ins = [(x + d, y - span), (x + d, y + span)]
    elif f == "north":
        ins = [(x - span, y + d), (x + span, y + d)]
    else:
        ins = [(x - span, y - d), (x + span, y - d)]
    return loc, ins


def mux_ports(loc, attrs):
    """2-way multiplexer (select width 1): out=loc, in0/in1 at -30,mp10,
    select at -20,+20 -- matches every mux resolved in block_transfer_control."""
    x, y = loc
    sel_bits = int(attrs.get("select", 1))
    if sel_bits == 1:
        return loc, [(x - 30, y - 10), (x - 30, y + 10)], (x - 20, y + 20)
    # wider selects (e.g. the 16-way reg_list mux) -- inputs fan in from the
    # west at 10-unit spacing per prior empirical mapping; select at (-20,+80)
    n = 1 << sel_bits
    ins = [(x - 30, y - 10 * (n - 1) + 20 * k) for k in range(n)]
    return loc, ins, (x - 20, y + 20 * (sel_bits + 2))


def reg_ports(loc, attrs):
    """D=(0,+30) CLK=(0,+70) Q=(+60,+30); width>=2 regs sometimes carry an
    extra Enable pin at (0,+50) -- only present if something is wired there."""
    x, y = loc
    return {
        "D": (x, y + 30),
        "CLK": (x, y + 70),
        "Q": (x + 60, y + 30),
        "EN": (x, y + 50),
    }


def not_gate_input(loc, attrs):
    return gate_ports(loc, attrs, "NOT Gate")[1][0]


# ------------------------------------------------------- naming & equations --

GATE_KINDS = {"AND Gate", "OR Gate", "NOT Gate", "XOR Gate", "NAND Gate", "NOR Gate"}


class CircuitModel:
    def __init__(self, name, comps, wires):
        self.name = name
        self.comps = comps
        self.wires = wires
        self.uf, self.nets = build_nets(wires)
        self.names = {}       # net-root -> label
        self.drivers = {}     # net-root -> (kind, loc, label, [input net-roots])
        self._assign_names()
        self._assign_drivers()
        self._index_subcircuits()

    def _index_subcircuits(self):
        """For attributing an unresolved net to 'probably driven by this
        subcircuit instance' -- we don't know exact pin geometry for every
        instance, so this is a proximity hint, not a wire trace."""
        self.sub_instances = self.subcircuit_instances()

    def root(self, pt):
        return self.uf.find(pt) if pt in self.uf.p else ("iso", pt)

    def _assign_names(self):
        for c in self.comps:
            if c["name"] in ("Pin", "Probe") and c["attrs"].get("label"):
                self.names.setdefault(self.root(c["loc"]), c["attrs"]["label"])

    def _assign_drivers(self):
        for c in self.comps:
            kind, loc, attrs = c["name"], c["loc"], c["attrs"]
            if kind in GATE_KINDS:
                out, ins = gate_ports(loc, attrs, kind)
                self.drivers[self.root(out)] = (
                    kind.split()[0], loc, attrs.get("label", ""),
                    [self.root(p) for p in ins])
            elif kind == "Multiplexer":
                out, ins, sel = mux_ports(loc, attrs)
                w = attrs.get("width", "?")
                self.drivers[self.root(out)] = (
                    "MUX%s" % w, loc, attrs.get("label", ""),
                    [self.root(sel)] + [self.root(p) for p in ins])
            elif kind == "Constant":
                self.drivers[self.root(loc)] = (
                    "CONST", loc, attrs.get("value", "0x1"), [])
            elif kind == "Register":
                p = reg_ports(loc, attrs)
                self.drivers[self.root(p["Q"])] = (
                    "REG", loc, attrs.get("label", ""),
                    [self.root(p["D"]), self.root(p["CLK"])])
            elif kind in ("Adder", "Subtractor", "Comparator", "Shifter",
                          "Multiplier", "Divider"):
                # multi-pin arithmetic block -- record as opaque, named by
                # its own loc; inputs are whatever nets sit near it (not
                # geometrically resolved here, arithmetic blocks vary by
                # width/attrs too much to hardcode safely)
                self.drivers.setdefault(self.root(loc), (kind, loc, attrs.get("label", ""), []))

    def _nearest_subcircuit(self, pt, radius=900):
        best, bestd, tag = None, radius + 1, None
        for s in self.sub_instances:
            dx = abs(pt[0] - s["loc"][0])
            dy = abs(pt[1] - s["loc"][1])
            d = dx + dy
            if dx <= radius and dy <= radius and d < bestd:
                best, bestd, tag = s["name"], d, "instance"
        split_radius = 160
        for c in self.comps:
            if c["name"] != "Splitter":
                continue
            dx = abs(pt[0] - c["loc"][0])
            dy = abs(pt[1] - c["loc"][1])
            d = dx + dy
            if dx <= split_radius and dy <= split_radius and d < bestd:
                best, bestd, tag = "SPLIT@%s" % (c["loc"],), d, "splitter"
        return best

    def show(self, pt, depth=0, seen=None, maxdepth=6, top_label=None):
        """Entry point for a report line 'LABEL = <expr>'. top_label is the
        label of the pin being explained, so we don't just echo it back
        when it's the only thing tagging this net -- we resolve past it."""
        r = self.root(pt)
        seen = seen or frozenset()
        d = self.drivers.get(r)
        if d is None:
            for p in self.nets.get(r, (pt,)):
                near = self._nearest_subcircuit(p)
                if near:
                    return "<- %s" % near
            return "<external/undriven>"
        return self.show_net(r, 0, seen, maxdepth, skip_name_for=top_label)

    def show_net(self, r, depth, seen, maxdepth, skip_name_for=None):
        nm = self.names.get(r)
        if nm and not (depth == 0 and nm == skip_name_for):
            return nm
        d = self.drivers.get(r)
        if d is None:
            for pt in self.nets.get(r, ()):
                near = self._nearest_subcircuit(pt)
                if near:
                    return "<- %s" % near
            return nm or "<net>"
        kind, loc, label, ins = d
        if r in seen or depth > maxdepth:
            return "%s@%s(...)" % (kind, loc)
        seen2 = seen | {r}
        parts = [self.show_net(x, depth + 1, seen2, maxdepth) for x in ins]
        tag = kind + (":" + label if label and kind not in ("CONST",) else "")
        if kind.startswith("MUX"):
            sel, i0, i1 = parts[0], parts[1], parts[2] if len(parts) > 2 else "?"
            return "%s[sel=%s ? %s : %s]" % (tag, sel, i1, i0)
        if kind == "CONST":
            return "CONST(%s)" % label
        if kind == "REG":
            return "REG(D=%s)" % parts[0]
        return "%s(%s)" % (tag, ", ".join(parts))

    def pins(self):
        """(label, loc, is_output, width) for every labeled Pin -- the
        circuit's own declared interface."""
        out = []
        for c in self.comps:
            if c["name"] == "Pin" and c["attrs"].get("label"):
                out.append((c["attrs"]["label"], c["loc"],
                            c["attrs"].get("output") == "true",
                            c["attrs"].get("width", "1")))
        return sorted(out, key=lambda t: t[1][1])

    def subcircuit_instances(self):
        """comps with no lib= attribute at all -- Logisim omits it only for
        instances of another user-defined circuit in this same project."""
        return [c for c in self.comps if c["lib"] is None]

    def component_counts(self):
        from collections import Counter
        return Counter(c["name"] for c in self.comps)


# ------------------------------------------------------------------ report --

def build_models(path=CIRC):
    raw = load_all(path)
    return {name: CircuitModel(name, comps, wires) for name, (comps, wires) in raw.items()}


def report_summary(models):
    lines = []
    for name, m in models.items():
        counts = m.component_counts()
        subs = m.subcircuit_instances()
        lines.append("%-24s %4d comps  %4d wires  %3d nets  %2d subcircuit instances"
                      % (name, len(m.comps), len(m.wires), len(m.nets), len(subs)))
        if subs:
            sub_names = sorted(set(s["name"] for s in subs))
            lines.append("    uses: " + ", ".join(sub_names))
    return "\n".join(lines)


def report_circuit(m):
    lines = [f"## `{m.name}`", ""]
    counts = m.component_counts()
    lines.append("**Components:** " + ", ".join(f"{k}×{v}" for k, v in sorted(counts.items())))
    lines.append("")

    pins = m.pins()
    ins = [p for p in pins if not p[2]]
    outs = [p for p in pins if p[2]]
    if ins:
        lines.append("**Inputs:** " + ", ".join(f"`{lbl}`({w})" for lbl, loc, o, w in ins))
    if outs:
        lines.append("**Outputs:** " + ", ".join(f"`{lbl}`({w})" for lbl, loc, o, w in outs))
    lines.append("")

    subs = m.subcircuit_instances()
    if subs:
        from collections import Counter
        counts = Counter(s["name"] for s in subs)
        if len(subs) <= 12:
            lines.append("**Subcircuit instances:**")
            for s in subs:
                lines.append(f"  - `{s['name']}` @ {s['loc']}")
        else:
            lines.append("**Subcircuit instances:** " +
                          ", ".join(f"{k}×{v}" for k, v in counts.items()) +
                          " (tiled array -- locations omitted)")
        lines.append("")

    if outs:
        lines.append("**Equations (outputs, one-hop-named, depth-capped):**")
        lines.append("```")
        for lbl, loc, o, w in outs:
            expr = m.show(loc, maxdepth=5, top_label=lbl)
            lines.append(f"{lbl} = {expr}")
        lines.append("```")
        lines.append("")

    # also show any labeled Probe (internal named signal, not a top pin)
    probes = [c for c in m.comps if c["name"] == "Probe" and c["attrs"].get("label")]
    if probes:
        lines.append("**Named internal probes:**")
        lines.append("```")
        seen_labels = set()
        for c in probes:
            lbl = c["attrs"]["label"]
            if lbl in seen_labels:
                continue
            seen_labels.add(lbl)
            expr = m.show(c["loc"], depth=0, maxdepth=5)
            lines.append(f"{lbl} = {expr}")
        lines.append("```")
        lines.append("")

    return "\n".join(lines)


def report_full_map(models):
    order = ["main", "block_transfer_control", "reg16x32_1", "pc_fetch",
             "condition_checker", "ALU", "ALU_airthmetic_engine",
             "ALU_logic_engine", "a_invert", "ks_32b", "ks_4b", "pg_cell",
             "kogge_stone_1b", "kogge_stone_2b", "mul_32", "partial_products",
             "pp_row_32", "csa_3to_2", "barrel_32b", "bs_stage_1", "bs_stage_2",
             "bs_stage_4", "bs_stage_8", "bs_stage_16", "reg16x32",
             "PE_cell", "systolic_4x4", "matmul4x4", "pp_row_16", "csa_16",
             "pp_8", "mul_8"]
    seen = set()
    parts = ["# armv4t.circ — structural map", "",
             "Auto-generated by `tools/circuit_model.py map`. Every output pin's",
             "equation is shown one level deep with named signals; unlabeled",
             "intermediate nets are inlined up to depth 5.", ""]
    for name in order:
        if name in models:
            parts.append(report_circuit(models[name]))
            seen.add(name)
    for name in models:
        if name not in seen:
            parts.append(report_circuit(models[name]))
    return "\n".join(parts)


def main():
    args = sys.argv[1:]
    models = build_models()
    if not args or args[0] == "map":
        print(report_full_map(models))
    elif args[0] == "summary":
        print(report_summary(models))
    elif args[0] == "circuit" and len(args) > 1:
        print(report_circuit(models[args[1]]))
    else:
        print(__doc__)


if __name__ == "__main__":
    main()
