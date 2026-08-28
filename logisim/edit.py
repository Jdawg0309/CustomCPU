"""Surgical, text-level edits to a .circ file.

Edits go through the original source text rather than an XML round-trip, so
untouched bytes stay byte-identical -- important when the file is someone's
hand-drawn work and every diff has to be reviewable.
"""
from __future__ import annotations

from typing import Dict, Iterable, List, Sequence, Tuple

from .model import Design, Point, Wire

WIRE = '    <wire from="(%d,%d)" to="(%d,%d)"/>\n'


def _circuit_span(text: str, name: str) -> Tuple[int, int]:
    a = text.index('<circuit name="%s"' % name)
    return a, text.index("\n  </circuit>", a)


def add_wires(text: str, circuit: str, segs: Iterable[Tuple[int, int, int, int]]) -> str:
    a, b = _circuit_span(text, circuit)
    body = text[a:b]
    block = "".join(WIRE % s for s in segs)
    return text[:a] + body.replace("    <wire", block + "    <wire", 1) + text[b:]


def remove_wire(text: str, circuit: str, seg: Tuple[int, int, int, int]) -> str:
    a, b = _circuit_span(text, circuit)
    body = text[a:b]
    line = WIRE % seg
    if line not in body:
        raise KeyError("no such wire %s in %s" % (seg, circuit))
    return text[:a] + body.replace(line, "", 1) + text[b:]


def add_component(text: str, circuit: str, lib: str, name: str, loc: Point,
                  attrs: Dict[str, str] = None) -> str:
    a, b = _circuit_span(text, circuit)
    body = text[a:b]
    # A subcircuit instance carries no lib attribute -- writing lib="None"
    # produces a file Logisim will not open.
    libattr = '' if lib is None else ' lib="%s"' % lib
    xml = '    <comp%s loc="(%d,%d)" name="%s">\n' % (libattr, loc[0], loc[1], name)
    for k, v in (attrs or {}).items():
        xml += '      <a name="%s" val="%s"/>\n' % (k, v)
    xml += "    </comp>\n"
    # Anchor on the first wire, then the first comp, and fall back to the end of
    # the circuit body -- an empty circuit has neither, and inserting before a
    # marker that isn't there silently drops the component.
    for anchor in ("    <wire", "    <comp"):
        if anchor in body:
            return text[:a] + body.replace(anchor, xml + anchor, 1) + text[b:]
    return text[:a] + body + xml + text[b:]


def safe_to_remove(design: Design, circuit: str, seg: Tuple[int, int, int, int]) -> List[Wire]:
    """Wires that T-join `seg` mid-span and would be orphaned by deleting it.

    This is the trap that makes wire deletion dangerous: other segments often
    touch a wire partway along, so removing it silently breaks nets that looked
    unrelated.  Empty list means the deletion is safe.
    """
    circ = design[circuit]
    target = Wire((seg[0], seg[1]), (seg[2], seg[3]))
    out = []
    for w in circ.wires:
        if (w.a, w.b) == (target.a, target.b):
            continue
        touches = target.contains(w.a) or target.contains(w.b)
        mutual = w.contains(target.a) or w.contains(target.b)
        if touches and not mutual:
            out.append(w)
    return out
