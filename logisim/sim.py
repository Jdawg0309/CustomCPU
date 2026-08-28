"""A gate-level simulator for `.circ` files, in Python.

Why this exists: every other check in this repo is static, and the only way to
actually run the CPU was to copy the file, patch a ROM into the copy, and drive
a jar under xvfb.  The copy is a snapshot -- it goes stale the moment Logisim
saves, and reading the file mid-save is a real failure mode.  This reads the
design at call time, so what is on disk is what is simulated.

It is also a SECOND IMPLEMENTATION.  `check_stage_*.py` all share one library;
a blind spot in that library is a blind spot in every one of them.  Agreement
between this and Logisim Evolution on real ARM programs is worth more than any
number of static assertions written by the same author.

Design:
  - the hierarchy is FLATTENED to primitives, unifying each subcircuit
    instance's port nets with the corresponding interface pin's net inside;
  - evaluation is event-driven with an iteration cap, so combinational loops
    are reported rather than hung on;
  - sequential elements (Register, RAM) sample on a clock edge, everything
    else is pure.

Nothing here writes a `.circ`.
"""
from __future__ import annotations

from typing import Dict, List, Optional, Tuple

from . import geometry, netlist
from .model import Component, Design, Point

# --- small helpers ----------------------------------------------------------


def _mask(w: int) -> int:
    return (1 << w) - 1


def _sext(v: int, w: int) -> int:
    return v - (1 << w) if w and (v >> (w - 1)) & 1 else v


class Loop(Exception):
    """Combinational feedback that did not settle."""


class _DSU:
    def __init__(self):
        self.p: Dict[int, int] = {}

    def find(self, a: int) -> int:
        self.p.setdefault(a, a)
        while self.p[a] != a:
            self.p[a] = self.p[self.p[a]]
            a = self.p[a]
        return a

    def union(self, a: int, b: int) -> None:
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.p[rb] = ra


# --- per-circuit static analysis, cached ------------------------------------


class _CircuitInfo:
    """Nets of one circuit, and each component port's net index within it."""

    def __init__(self, design: Design, name: str):
        self.name = name
        circ = design.circuits[name]
        self.circ = circ
        nets = netlist.build(design, circ)
        self.point_net: Dict[Point, int] = {}
        for i, n in enumerate(nets):
            for p in n.points:
                self.point_net[p] = i
        self.count = len(nets)
        # Ports that touch no wire still need a net; two ports sharing a bare
        # point must share it.  Logisim connects by location, not only by wire.
        self.ports: List[Tuple[Component, List[Tuple[str, int]]]] = []
        for c in circ.components:
            if c.name == "Splitter":
                names = [p.name for p in geometry._splitter_ports(c)]
                pts = geometry._splitter_points(c)
            else:
                ps = geometry.ports(design, c)
                names = [p.name for p in ps]
                pts = [p.at(c) for p in ps]
            mapped = []
            for nm, pt in zip(names, pts):
                if pt not in self.point_net:
                    self.point_net[pt] = self.count
                    self.count += 1
                mapped.append((nm, self.point_net[pt]))
            self.ports.append((c, mapped))
        # interface pins by label, for wiring an instance from outside
        # Logisim binds instance ports by POSITION (outputs then inputs, each
        # sorted by (y,x)), not by label -- and some pins have no label at all,
        # e.g. condition_checker's only output.  Binding by name silently
        # leaves those unconnected.
        self.pin_seq: List[int] = [self.point_net[p.loc]
                                   for p in list(circ.outputs()) + list(circ.inputs())]
        self.pin_net: Dict[str, int] = {}
        self.pin_width: Dict[str, int] = {}
        self.pin_is_out: Dict[str, bool] = {}
        for p in circ.pins():
            lbl = p.label
            if not lbl:
                continue
            self.pin_net[lbl] = self.point_net[p.loc]
            self.pin_width[lbl] = int(p.attrs.get("width", 1))
            self.pin_is_out[lbl] = p.attrs.get("output") == "true"


# --- the simulator ----------------------------------------------------------


class Sim:
    """Flatten a set of subcircuit instances and run them.

    The top level is built here rather than read from a `main` circuit, so a
    design whose `main` is still empty can be simulated exactly as it will
    behave once `main` is wired.  Instances are named; every external
    connection is made by PORT NAME.
    """

    def __init__(self, path: str):
        from .model import load
        self.design = load(path)
        self.path = path
        self._info: Dict[str, _CircuitInfo] = {}
        self.dsu = _DSU()
        self.nid = 0
        self.prims: List[dict] = []
        self.inst_port: Dict[str, int] = {}    # "INST.port" -> raw net id
        self._inst_map: Dict[str, str] = {}
        self.rom_data: Dict[int, List[int]] = {}
        self._built = False
        self._pending: List[Tuple[str, str]] = []
        self._ties: List[Tuple[str, int]] = []
        self._pin_widths: List[Tuple[int, int]] = []
        self._src_pins: List[int] = []
        self.labels: Dict[str, int] = {}   # "IF/pc_fetch:PC_NEXT" -> raw net

    # -- construction --------------------------------------------------------

    def info(self, name: str) -> _CircuitInfo:
        if name not in self._info:
            self._info[name] = _CircuitInfo(self.design, name)
        return self._info[name]

    def _fresh(self, n: int) -> int:
        base = self.nid
        self.nid += n
        for i in range(base, self.nid):
            self.dsu.find(i)
        return base

    def add_instance(self, inst: str, circuit: str) -> None:
        """Elaborate `circuit` under the name `inst` and expose its pins."""
        if self._built:
            raise RuntimeError("add_instance after build()")
        self._inst_map[inst] = circuit
        base = self._elaborate(circuit, inst)
        ci = self.info(circuit)
        # Only a TOP-LEVEL instance's inputs are driven from outside.  Marking
        # every interior pin as a driver is wrong: a subcircuit's input pin is
        # a SINK from its parent's side, and treating it as a source turns the
        # control-word merge splitters around.
        for p in ci.circ.inputs():
            self._src_pins.append(base + ci.point_net[p.loc])
        for lbl, local in ci.pin_net.items():
            self.inst_port["%s.%s" % (inst, lbl)] = base + local

    def _elaborate(self, circuit: str, path: str) -> int:
        ci = self.info(circuit)
        base = self._fresh(ci.count)
        for c, mapped in ci.ports:
            nets = {nm: base + idx for nm, idx in mapped}
            if c.is_subcircuit and c.name in self.design.circuits:
                sub = self.info(c.name)
                sbase = self._elaborate(c.name, "%s/%s" % (path, c.name))
                # `mapped` is in geometry.subcircuit_ports order, which is
                # outputs-then-inputs -- the same order as sub.pin_seq.
                for (_, outer_idx), local in zip(mapped, sub.pin_seq):
                    self.dsu.union(base + outer_idx, sbase + local)
                continue
            lbl = c.attrs.get("label")
            if lbl:
                for nm, idx in mapped:
                    key = "%s:%s" % (path, lbl) if len(mapped) == 1 else \
                          "%s:%s.%s" % (path, lbl, nm)
                    self.labels.setdefault(key, base + idx)
            if c.name == "Pin":
                self._pin_widths.append((nets["p"], int(c.attrs.get("width", 1))))
                continue          # a Pin's net is already the net outside it
            if c.name in ("Probe", "Tunnel"):
                continue          # Probe is inert; Tunnel handled below
            self.prims.append({"c": c, "nets": nets, "path": path})
        # tunnels join by label within one circuit instance
        by_label: Dict[str, List[int]] = {}
        for c, mapped in ci.ports:
            if c.name == "Tunnel":
                by_label.setdefault(c.attrs.get("label", ""), []).append(base + mapped[0][1])
        for lbl, ids in by_label.items():
            for other in ids[1:]:
                self.dsu.union(ids[0], other)
        return base

    def connect(self, a: str, b: str) -> None:
        # Validate NOW, not in build().  A caller wiring a stage that is only
        # partly built wants to skip the ports that do not exist yet, and it
        # cannot do that if the error surfaces two calls later.
        for q in (a, b):
            if q not in self.inst_port:
                raise KeyError("no such port: %s" % q)
        self._pending.append((a, b))

    def tie(self, port: str, value: int) -> None:
        self._ties.append((port, value))

    # -- build ---------------------------------------------------------------

    def build(self) -> "Sim":
        for a, b in self._pending:
            for q in (a, b):
                if q not in self.inst_port:
                    raise KeyError("no such port: %s" % q)
            self.dsu.union(self.inst_port[a], self.inst_port[b])
        self.net = {k: self.dsu.find(v) for k, v in self.inst_port.items()}
        for p in self.prims:
            p["nets"] = {k: self.dsu.find(v) for k, v in p["nets"].items()}
        for i, p in enumerate(self.prims):
            p["i"] = i

        tied = {self.dsu.find(self.inst_port[pt]) for pt, _ in self._ties}
        self._resolve_splitters(tied)

        # --- widths -----------------------------------------------------
        self.width: Dict[int, int] = {}

        def widen(n, w):
            if n is not None:
                self.width[n] = max(self.width.get(n, 0), w)

        for nid, w in self._pin_widths:
            widen(self.dsu.find(nid), w)
        for p in self.prims:
            for nm, w in self._out_widths(p).items():
                widen(p["nets"].get(nm), w)
        for p in self.prims:                       # the side a splitter reads
            if p["c"].name != "Splitter":
                continue
            inc, fan, m = self._splitter_map(p["c"])
            if p["split"]:
                widen(p["nets"].get("combined"), inc)
            else:
                for k in range(fan):
                    if m[k]:
                        widen(p["nets"].get("bit%d" % k), len(m[k]))

        # --- indices ----------------------------------------------------
        self.value: Dict[int, Optional[int]] = {}
        self.state: Dict[int, object] = {}
        self._readers: Dict[int, List[int]] = {}
        self.has_driver = set()
        for i, p in enumerate(self.prims):
            outs = set(self._out_widths(p))
            for nm, n in p["nets"].items():
                if nm in outs:
                    self.has_driver.add(n)
                else:
                    self._readers.setdefault(n, []).append(i)
        self.has_driver.update(self.dsu.find(n) for n in self._src_pins)
        self._dirty = set(range(len(self.prims)))
        self._built = True
        for pt, v in self._ties:
            self.poke(pt, v)
        return self

    def _resolve_splitters(self, tied) -> None:
        """A splitter is not a gate: which side it drives depends on wiring.

        Resolved to a fixed point, not in one pass -- stage_ID splits the
        instruction with a splitter whose fans feed two MORE splitters, and a
        single pass leaves those two with no driver and turns them around.
        """
        drivers = set(tied)
        drivers.update(self.dsu.find(n) for n in self._src_pins)
        for p in self.prims:
            if p["c"].name == "Splitter":
                continue
            for nm in self._out_widths(p):
                n = p["nets"].get(nm)
                if n is not None:
                    drivers.add(n)

        spl = [p for p in self.prims if p["c"].name == "Splitter"]
        for p in spl:
            p["split"] = None
        changed = True
        while changed:
            changed = False
            for p in spl:
                if p["split"] is not None:
                    continue
                inc, fan, m = self._splitter_map(p["c"])
                comb = p["nets"]["combined"]
                fans = [p["nets"].get("bit%d" % k) for k in range(fan) if m[k]]
                if comb in drivers:
                    p["split"] = True
                    drivers.update(n for n in fans if n is not None)
                    changed = True
                elif any(n in drivers for n in fans if n is not None):
                    p["split"] = False
                    drivers.add(comb)
                    changed = True
        for p in spl:                      # isolated: assume it splits
            if p["split"] is None:
                p["split"] = True

    # -- component semantics -------------------------------------------------

    @staticmethod
    def _w(c: Component, default: int = 1) -> int:
        return int(c.attrs.get("width", default))

    def _out_widths(self, p: dict) -> Dict[str, int]:
        """Which ports this primitive DRIVES, and how wide."""
        c = p["c"]
        n = c.name
        if n in ("AND Gate", "OR Gate", "NOT Gate", "XOR Gate", "XNOR Gate",
                 "NAND Gate", "NOR Gate", "Buffer"):
            return {"out": self._w(c)}
        if n == "Constant":
            return {"p": self._w(c)}
        if n == "Multiplexer":
            return {"out": self._w(c)}
        if n == "Decoder":
            return {"out%d" % i: 1 for i in range(1 << int(c.attrs.get("select", 1)))}
        if n == "Adder":
            return {"out": self._w(c), "cout": 1}
        if n == "Multiplier":
            return {"out": self._w(c), "cout": self._w(c)}
        if n == "Comparator":
            return {"gt": 1, "eq": 1, "lt": 1}
        if n == "Shifter":
            return {"out": self._w(c)}
        if n == "Bit Extender":
            return {"out": int(c.attrs.get("out_width", 32))}
        if n == "Register":
            return {"Q": self._w(c)}
        if n in ("ROM", "RAM"):
            return {"data_out": int(c.attrs.get("dataWidth", 8))}
        if n == "Clock":
            return {"out": 1}
        if n == "Splitter":
            return self._splitter_widths(p)
        return {}

    def _splitter_map(self, c: Component):
        inc = int(c.attrs.get("incoming", 2))
        fan = int(c.attrs.get("fanout", 2))
        # An absent bitK is NOT "fan 0", and it is NOT the even distribution
        # either.  Measured against Logisim 3.8.0: for incoming=8 fanout=3 with
        # bit0 and bit1 both absent, bit 0 lands on fan 0 and bit 1 on fan 1.
        # The rule that fits is the identity map saturating at the last fan:
        #
        #     absent bitK  ->  fan min(K, fanout-1)
        #
        # Cross-checked against all six splitters in stage_ID: every fan width
        # then matches the width of the pin it drives.  Note the file's own
        # <tool name="Splitter"> default block says bit1=0, which is NOT what
        # Logisim does -- do not trust that block.
        out: Dict[int, List[int]] = {k: [] for k in range(fan)}
        for b in range(inc):
            a = c.attrs.get("bit%d" % b)
            if a is None:
                tgt = min(b, fan - 1)
            elif a == "none":
                continue
            else:
                tgt = int(a)
            out[tgt].append(b)
        return inc, fan, out

    def _splitter_widths(self, p: dict) -> Dict[str, int]:
        c = p["c"]
        inc, fan, m = self._splitter_map(c)
        if p.get("split", True):
            return {"bit%d" % k: len(m[k]) for k in range(fan) if m[k]}
        return {"combined": inc}

    # -- evaluation ----------------------------------------------------------

    def _get(self, n: Optional[int], w: int = 1) -> int:
        if n is None:
            return 0
        v = self.value.get(n)
        return 0 if v is None else v & _mask(w)

    def _in(self, p: dict, nm: str) -> int:
        n = p["nets"].get(nm)
        return self._get(n, self.width.get(n, 1) if n is not None else 1)

    def _has(self, p: dict, nm: str) -> bool:
        n = p["nets"].get(nm)
        return n is not None and self.value.get(n) is not None

    def _eval(self, p: dict) -> Dict[int, int]:
        c = p["c"]
        n = c.name
        nets = p["nets"]
        out: Dict[int, int] = {}

        def put(port: str, val: int, w: int):
            nid = nets.get(port)
            if nid is not None:
                out[nid] = val & _mask(w)

        if n in ("AND Gate", "OR Gate", "XOR Gate", "NAND Gate", "NOR Gate", "XNOR Gate"):
            w = self._w(c)
            k = int(c.attrs.get("inputs", 2))
            vals = [self._in(p, "in%d" % i) for i in range(k)]
            if n in ("AND Gate", "NAND Gate"):
                r = _mask(w)
                for v in vals:
                    r &= v
            elif n in ("OR Gate", "NOR Gate"):
                r = 0
                for v in vals:
                    r |= v
            else:
                r = 0
                for v in vals:
                    r ^= v
            if n in ("NAND Gate", "NOR Gate", "XNOR Gate"):
                r = ~r
            put("out", r, w)

        elif n in ("NOT Gate",):
            w = self._w(c)
            put("out", ~self._in(p, "in"), w)

        elif n == "Buffer":
            put("out", self._in(p, "in"), self._w(c))

        elif n == "Constant":
            # Logisim's Constant defaults to 1, not 0 -- this has cost the
            # project three separate bugs.  Reproduce it exactly.
            put("p", int(c.attrs.get("value", "0x1"), 0), self._w(c))

        elif n == "Multiplexer":
            w = self._w(c)
            sel = int(c.attrs.get("select", 1))
            put("out", self._in(p, "in%d" % self._in(p, "sel")), w)
            del sel

        elif n == "Decoder":
            sel = self._in(p, "sel")
            en = self._in(p, "en") if self._driven(p, "en") else 1
            for i in range(1 << int(c.attrs.get("select", 1))):
                put("out%d" % i, 1 if (en and i == sel) else 0, 1)

        elif n == "Adder":
            w = self._w(c)
            s = self._in(p, "a") + self._in(p, "b") + self._in(p, "cin")
            put("out", s, w)
            put("cout", s >> w, 1)

        elif n == "Multiplier":
            w = self._w(c)
            a, b = self._in(p, "a"), self._in(p, "b")
            if c.attrs.get("mode", "twosComplement") == "twosComplement":
                a, b = _sext(a, w), _sext(b, w)
            product = a * b + self._in(p, "cin")
            put("out", product, w)
            put("cout", product >> w, w)

        elif n == "Comparator":
            w = self._w(c)
            mode = c.attrs.get("mode", "twosComplement")
            a, b = self._in(p, "a"), self._in(p, "b")
            if mode == "twosComplement":
                a, b = _sext(a, w), _sext(b, w)
            put("gt", 1 if a > b else 0, 1)
            put("eq", 1 if a == b else 0, 1)
            put("lt", 1 if a < b else 0, 1)

        elif n == "Shifter":
            w = self._w(c)
            v, d = self._in(p, "in"), self._in(p, "dist") % (2 * w)
            kind = c.attrs.get("shift", "ll")
            d = min(d, w) if kind in ("ll", "lr", "ar") else d % w
            if kind == "ll":
                r = v << d
            elif kind == "lr":
                r = v >> d
            elif kind == "ar":
                r = _sext(v, w) >> d
            elif kind == "rr":
                r = (v >> d) | (v << (w - d)) if d else v
            else:
                r = (v << d) | (v >> (w - d)) if d else v
            put("out", r, w)

        elif n == "Bit Extender":
            iw = int(c.attrs.get("in_width", 8))
            ow = int(c.attrs.get("out_width", 32))
            v = self._in(p, "in") & _mask(iw)
            # `type` absent means SIGN, not zero.
            t = c.attrs.get("type", "sign")
            if t == "zero":
                r = v
            elif t == "one":
                r = v | (~_mask(iw))
            elif t == "input":
                r = v | ((_mask(ow) ^ _mask(iw)) if self._in(p, "extend") else 0)
            else:
                r = _sext(v, iw)
            put("out", r, ow)

        elif n == "Register":
            put("Q", self.state.get(id(p), 0), self._w(c))

        elif n == "ROM":
            aw = int(c.attrs.get("addrWidth", 8))
            dw = int(c.attrs.get("dataWidth", 8))
            mem = self.rom_data.get(id(p))
            if mem is None:
                mem = self.rom_data[id(p)] = _parse_contents(c, aw)
            a = self._in(p, "addr") & _mask(aw)
            put("data_out", mem[a] if a < len(mem) else 0, dw)

        elif n == "RAM":
            # Logisim's RAM read is SYNCHRONOUS unless `asyncread` is true, and
            # `asyncread` defaults to FALSE (RamAttributes ctor: iconst_0).
            # This design leaves it absent and sets trigger=falling, giving a
            # HALF-CYCLE memory: the address settles in the first half of the
            # cycle, the falling edge latches the read, and the loaded word is
            # ready for the rising edge that writes the register file.
            # Modelling this read as combinational silently disagrees with
            # Logisim on every load.
            dw = int(c.attrs.get("dataWidth", 8))
            st = self.state.setdefault(id(p), {"mem": {}, "out": 0})
            if c.attrs.get("asyncread") == "true":
                aw = int(c.attrs.get("addrWidth", 8))
                put("data_out", st["mem"].get(self._in(p, "addr") & _mask(aw), 0), dw)
            else:
                put("data_out", st["out"], dw)

        elif n == "Clock":
            put("out", self.value.get(nets.get("out"), 0) or 0, 1)

        elif n == "Splitter":
            inc, fan, m = self._splitter_map(c)
            if p["split"]:
                v = self._in(p, "combined")
                for k in range(fan):
                    if not m[k]:
                        continue
                    r = 0
                    for j, b in enumerate(m[k]):
                        r |= ((v >> b) & 1) << j
                    put("bit%d" % k, r, len(m[k]))
            else:
                r = 0
                for k in range(fan):
                    if not m[k]:
                        continue
                    fv = self._in(p, "bit%d" % k)
                    for j, b in enumerate(m[k]):
                        r |= ((fv >> j) & 1) << b
                put("combined", r, inc)

        return out

    # -- driving -------------------------------------------------------------

    def poke(self, port: str, val: int) -> None:
        n = self.net[port] if port in self.net else port
        self.value[n] = val & _mask(self.width.get(n, 32))
        self._dirty.update(self._readers.get(n, ()))

    def peek(self, port: str) -> int:
        n = self.net[port]
        return self._get(n, self.width.get(n, 1))

    def find(self, pattern: str) -> List[Tuple[str, int]]:
        """Labelled points whose key contains `pattern`, with their values.

        Every probe, pin and tunnel label in the design is addressable this
        way, so a defect can be reported by NAME instead of coordinate.
        """
        out = []
        for k, raw in sorted(self.labels.items()):
            if pattern.lower() in k.lower():
                n = self.dsu.find(raw)
                out.append((k, self._get(n, self.width.get(n, 1))))
        return out

    def width_conflicts(self) -> List[str]:
        """Nets whose endpoints disagree about how many bits they carry.

        Logisim shows these as an orange wire; nothing else in this toolkit
        checks them.  It also double-checks the splitter bit-map inference: a
        wrong absent-bit rule shows up here as a fan that is the wrong width
        for the pin it drives.
        """
        want: Dict[int, List[Tuple[str, int]]] = {}

        def note(n, who, w):
            if n is not None and w:
                want.setdefault(n, []).append((who, w))

        for raw, w in self._pin_widths:
            note(self.dsu.find(raw), "Pin", w)
        for p in self.prims:
            c = p["c"]
            who = "%s/%s" % (p["path"], c.attrs.get("label") or c.name)
            for nm, w in self._out_widths(p).items():
                note(p["nets"].get(nm), "%s.%s" % (who, nm), w)
            if c.name == "Splitter":
                inc, fan, m = self._splitter_map(c)
                if p["split"]:
                    note(p["nets"].get("combined"), "%s.combined" % who, inc)
                else:
                    for k in range(fan):
                        if m[k]:
                            note(p["nets"].get("bit%d" % k), "%s.bit%d" % (who, k), len(m[k]))
                continue
            for nm, n in p["nets"].items():
                if nm in self._out_widths(p):
                    continue
                w = self._in_width(c, nm)
                note(n, "%s.%s" % (who, nm), w)
        out = []
        for n, lst in sorted(want.items()):
            ws = {w for _, w in lst}
            if len(ws) > 1:
                out.append("net %d carries %s: %s"
                           % (n, sorted(ws),
                              ", ".join("%s=%d" % (a, b) for a, b in sorted(lst))))
        return out

    def _in_width(self, c: Component, nm: str) -> int:
        n = c.name
        if n in ("AND Gate", "OR Gate", "XOR Gate", "XNOR Gate", "NAND Gate",
                 "NOR Gate", "NOT Gate", "Buffer"):
            return self._w(c)
        if n == "Multiplexer":
            # sel is `select` bits wide, not 1 -- the mux is 2**select-to-1.
            if nm == "sel":
                return int(c.attrs.get("select", 1))
            return 1 if nm == "en" else self._w(c)
        if n == "Adder":
            return 1 if nm == "cin" else self._w(c)
        if n == "Multiplier":
            return self._w(c)
        if n == "Comparator":
            return self._w(c)
        if n == "Decoder":
            return int(c.attrs.get("select", 1)) if nm == "sel" else 1
        if n == "Shifter":
            return self._w(c) if nm == "in" else 0
        if n == "Bit Extender":
            return int(c.attrs.get("in_width", 8)) if nm == "in" else 0
        if n == "Register":
            return self._w(c) if nm == "D" else 1
        if n == "ROM":
            return int(c.attrs.get("addrWidth", 8)) if nm == "addr" else 0
        return 0

    def show(self, pattern: str) -> None:
        for k, v in self.find(pattern):
            print("   %-52s = 0x%x" % (k, v))

    def settle(self, limit: int = 400) -> int:
        rounds = 0
        while self._dirty and rounds < limit:
            rounds += 1
            todo, self._dirty = self._dirty, set()
            for i in sorted(todo):
                p = self.prims[i]
                for nid, v in self._eval(p).items():
                    if self.value.get(nid) != v:
                        self.value[nid] = v
                        self._dirty.update(self._readers.get(nid, ()))
        if self._dirty:
            raise Loop("did not settle in %d rounds (%d components still active)"
                       % (limit, len(self._dirty)))
        return rounds

    # -- sequential ----------------------------------------------------------

    def _driven(self, p: dict, nm: str) -> bool:
        n = p["nets"].get(nm)
        return n is not None and n in self.has_driver

    def reset(self) -> None:
        self.value = {}
        self.state = {}
        self._dirty = set(range(len(self.prims)))
        for pt, v in self._ties:
            self.poke(pt, v)
        self.settle()

    def tick(self, clk: str) -> None:
        """One full clock cycle: rising edge, then falling edge.

        Both edges are modelled because this design deliberately puts the data
        memory on the FALLING edge while every register is on the rising one --
        a half-cycle memory.  A rising-edge-only model reads loads a cycle late.
        """
        self.poke(clk, 0)
        self.settle()
        self._edge(clk, 1)
        self._edge(clk, 0)

    def _trigger(self, c: Component) -> str:
        t = c.attrs.get("trigger", "rising")
        return "falling" if t.startswith("fall") else "rising"

    def _edge(self, clk: str, level: int) -> None:
        want = "rising" if level else "falling"
        pend = []
        for p in self.prims:
            n = p["c"].name
            if n == "Register" and self._trigger(p["c"]) == want:
                pend.append((p, self._in(p, "D"),
                             self._in(p, "en") if self._driven(p, "en") else 1,
                             self._in(p, "clr") if self._driven(p, "clr") else 0))
            elif n == "RAM" and self._trigger(p["c"]) == want:
                aw = int(p["c"].attrs.get("addrWidth", 8))
                pend.append((p, (self._in(p, "addr") & _mask(aw), self._in(p, "data_in")),
                             self._in(p, "we") if self._driven(p, "we") else 0,
                             self._in(p, "oe") if self._driven(p, "oe") else 1))
        self.poke(clk, level)
        for p, d, en, extra in pend:
            if p["c"].name == "Register":
                cur = self.state.get(id(p), 0)
                new = 0 if extra else (d if en else cur)
                if new != cur:
                    self.state[id(p)] = new
                    self._dirty.add(p["i"])
                    q = p["nets"].get("Q")
                    if q is not None:
                        self._dirty.update(self._readers.get(q, ()))
            else:
                addr, din = d
                st = self.state.setdefault(id(p), {"mem": {}, "out": 0})
                if en:                                   # `en` here is `we`
                    st["mem"][addr] = din
                # READAFTERWRITE is Logisim's default: a write in the same
                # cycle is visible to that cycle's read.
                if extra:                                # `extra` here is `oe`
                    st["out"] = st["mem"].get(addr, 0)
                self._dirty.add(p["i"])
                o = p["nets"].get("data_out")
                if o is not None:
                    self._dirty.update(self._readers.get(o, ()))
        self.settle()

    # -- memory --------------------------------------------------------------

    def roms(self, data_width: int = None) -> List[dict]:
        return [p for p in self.prims if p["c"].name == "ROM"
                and (data_width is None
                     or int(p["c"].attrs.get("dataWidth", 8)) == data_width)]

    def load_rom(self, words: List[int], data_width: int = 32) -> int:
        """Patch every ROM of this data width, IN MEMORY.  The file is untouched.

        A design with a literal-pool read port has two identical instruction
        ROMs; patching all of them keeps one code path for either case.
        """
        hit = 0
        for p in self.roms(data_width):
            aw = int(p["c"].attrs.get("addrWidth", 8))
            if len(words) > (1 << aw):
                raise ValueError("ROM holds %d words, program needs %d"
                                 % (1 << aw, len(words)))
            mem = [0] * (1 << aw)
            mem[:len(words)] = words
            self.rom_data[id(p)] = mem
            self._dirty.add(p["i"])
            hit += 1
        return hit

    def ram_dump(self) -> Dict[int, int]:
        out = {}
        for p in self.prims:
            if p["c"].name == "RAM":
                out.update(self.state.get(id(p), {}).get("mem", {}))
        return out


def _parse_contents(c: Component, aw: int) -> List[int]:
    """Logisim's ROM image format: a header line, then hex words.

    Runs are written `N*V`, which a naive split silently turns into one word and
    shifts the whole image.
    """
    raw = c.attrs.get("contents", "")
    mem = [0] * (1 << aw)
    i = 0
    for line in raw.splitlines():
        if line.startswith("addr/data"):
            continue
        for tok in line.split():
            if "*" in tok:
                n, _, v = tok.partition("*")
                n, v = int(n, 0), int(v, 16)
            else:
                n, v = 1, int(tok, 16)
            for _ in range(n):
                if i < len(mem):
                    mem[i] = v
                i += 1
    return mem
