"""Wire routing that respects how Logisim actually connects things.

Two rules drive everything here:

  * wires join only where an ENDPOINT touches -- a perpendicular crossing with
    no endpoint is not a connection, so a route may pass straight through one;
  * a route may not turn or stop on a crossing (that would put an endpoint on
    the other wire), run collinear with an existing wire, or touch a pin it is
    not meant to reach.

Subcircuit instance pins are included in the obstacle set.  They are invisible
to a naive component scan -- an instance is a single <comp> -- yet a route that
merely passes over one silently connects to it.
"""
from __future__ import annotations

from collections import deque
from typing import Dict, FrozenSet, Iterable, List, Optional, Sequence, Set, Tuple

from .model import Circuit, Design, Point, Wire
from . import geometry as geo

DIRS = ((10, 0), (-10, 0), (0, 10), (0, -10))


class Obstacles:
    """orientations of wires through each point, wire endpoints, and pin pads."""

    def __init__(self, orient: Dict[Point, Set[str]], ends: Set[Point], pads: Set[Point]):
        self.orient, self.ends, self.pads = orient, ends, pads

    def without(self, points: Iterable[Point]) -> "Obstacles":
        drop = set(points)
        return Obstacles(self.orient, self.ends - drop, self.pads - drop)


# Components whose true footprint isn't known (see geometry.UNMODELLED --
# currently ROM/RAM, whose "logisim_evolution" appearance box size isn't
# recorded in the file) get a much wider keep-out than an ordinary gate.
# Without this, a route can pass right next to one, undetected, and land on
# a real pin the geometry model doesn't know exists -- which happened here:
# a route skimmed past the instruction ROM and silently shorted onto its
# (unmapped) data-output bus, closing a genuine fetch/decode feedback loop.
UNKNOWN_FOOTPRINT_PAD = 150


def obstacles(design: Design, circ: Circuit, wires: Sequence[Wire] = None,
              pad: int = 30) -> Obstacles:
    wires = list(circ.wires if wires is None else wires)
    orient: Dict[Point, Set[str]] = {}
    ends: Set[Point] = set()
    for w in wires:
        o = "V" if w.vertical else "H"
        for p in w.points():
            orient.setdefault(p, set()).add(o)
        ends.add(w.a); ends.add(w.b)
    pads: Set[Point] = set()
    for c in circ.components:
        for p in geo.port_points(design, c):
            pads.add(p)
        x, y = c.loc
        this_pad = UNKNOWN_FOOTPRINT_PAD if c.name in geo.UNMODELLED else pad
        for dx in range(-this_pad, this_pad + 1, 10):
            for dy in range(-this_pad, this_pad + 1, 10):
                pads.add((x + dx, y + dy))
    return Obstacles(orient, ends, pads)


def net_points(wires: Sequence[Wire], pt: Point) -> Set[Point]:
    """Points of the wire net containing `pt`, using the endpoint-touch rule."""
    members = [i for i, w in enumerate(wires) if w.contains(pt)]
    if not members:
        return {pt}
    cur = set(members)
    changed = True
    while changed:
        changed = False
        for j, w in enumerate(wires):
            if j in cur:
                continue
            for i in cur:
                a = wires[i]
                if (w.contains(a.a) or w.contains(a.b)
                        or a.contains(w.a) or a.contains(w.b)):
                    cur.add(j); changed = True; break
    pts = {pt}
    for i in cur:
        pts.update(wires[i].points())
    return pts


def route(obs: Obstacles, src, dst: Point, bounds: Tuple[int, int, int, int],
          free: FrozenSet[Point] = frozenset()) -> Optional[List[Point]]:
    """Shortest legal path from any point of `src` to `dst`.

    State is (point, entry direction) so the "must pass straight through a
    crossing" rule can be enforced -- a plain grid BFS cannot express it.
    """
    x0, x1, y0, y1 = bounds
    starts = set(src) if not isinstance(src, tuple) else {src}
    free = set(free) | starts

    def enterable(p: Point, d: Tuple[int, int], stopping: bool) -> bool:
        if not (x0 <= p[0] <= x1 and y0 <= p[1] <= y1):
            return False
        if p in free:
            return True
        if p in obs.pads or p in obs.ends:
            return False
        o = obs.orient.get(p)
        if o:
            if ("H" if d[0] else "V") in o:
                return False            # collinear overlap
            if stopping:
                return False            # cannot turn or stop on a crossing
        return True

    seen: Set[Tuple[Point, Tuple[int, int]]] = set()
    prev: Dict[Tuple[Point, Tuple[int, int]], Tuple[Point, Tuple[int, int]]] = {}
    q: deque = deque()
    for p in starts:
        for d in DIRS:
            seen.add((p, d)); q.append((p, d))
    while q:
        cur, d = q.popleft()
        if cur == dst and cur not in starts:
            path = [cur]; k = (cur, d)
            while k in prev:
                k = prev[k]; path.append(k[0])
            return path[::-1]
        crossing = cur not in free and bool(obs.orient.get(cur))
        for nd in DIRS:
            if crossing and nd != d:
                continue
            n = (cur[0] + nd[0], cur[1] + nd[1])
            st = (n, nd)
            if st in seen or not enterable(n, nd, stopping=(n == dst)):
                continue
            seen.add(st); prev[st] = (cur, d); q.append(st)
    return None


def to_segments(path: Sequence[Point]) -> List[Tuple[int, int, int, int]]:
    """Collapse a lattice path into the fewest straight wire segments."""
    if len(path) < 2:
        return []
    segs: List[Tuple[int, int, int, int]] = []
    run = [path[0], path[1]]
    for p in path[2:]:
        d_prev = (run[-1][0] - run[-2][0], run[-1][1] - run[-2][1])
        d_next = (p[0] - run[-1][0], p[1] - run[-1][1])
        if d_next == d_prev:
            run.append(p)
        else:
            segs.append((run[0][0], run[0][1], run[-1][0], run[-1][1]))
            run = [run[-1], p]
    segs.append((run[0][0], run[0][1], run[-1][0], run[-1][1]))
    return segs
