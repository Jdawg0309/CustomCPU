"""Generate a self-contained HTML browser for every circuit in a design.

Everything is inlined -- schematics, net tables, lint results -- so the page
works from a file:// URL with no server and no assets.
"""
from __future__ import annotations

import json
from typing import Dict, List

from .model import Design
from . import lint as lintmod, netlist as nl, render as rendermod

MAX_PINS_PER_NET = 60


def _circuit_payload(design: Design, name: str) -> dict:
    circ = design[name]
    nets = nl.build(design, circ)
    rep = lintmod.report(design, circ)
    netinfo = []
    for i, n in enumerate(nets):
        pins = [[c.name, c.label, port, list(c.loc)] for c, port in n.pins[:MAX_PINS_PER_NET]]
        drivers = [[c.name, c.label, port] for c, port in n.drivers[:6]]
        netinfo.append({"i": i, "pts": len(n.points), "pins": pins,
                        "more": max(0, len(n.pins) - MAX_PINS_PER_NET),
                        "drv": drivers})
    parts: Dict[str, int] = {}
    for c in circ.components:
        parts[c.name] = parts.get(c.name, 0) + 1
    return {
        "name": name,
        "svg": rendermod.svg(design, circ),
        "comps": len(circ.components),
        "wires": len(circ.wires),
        "nets": len(nets),
        "inputs": [p.label or "?" for p in circ.inputs()],
        "outputs": [p.label or "?" for p in circ.outputs()],
        "parts": sorted(parts.items(), key=lambda kv: -kv[1]),
        "netinfo": netinfo,
        "coverage": list(rep["coverage"]),
        "near": [{"at": list(x["endpoint"]), "d": x["distance"],
                  "pin": list(x["pin"]), "comp": x["component"],
                  "label": x["label"], "port": x["port"]} for x in rep["near_misses"]],
        "stubs": [list(p) for p in rep["isolated_stubs"]],
    }


def _fingerprint(design: Design, name: str):
    """Cheap structural identity for a circuit, for spotting what differs
    between two versions of the same design."""
    circ = design[name]
    comps = sorted((c.name, c.loc, tuple(sorted(c.attrs.items()))) for c in circ.components)
    wires = sorted((w.a, w.b) for w in circ.wires)
    return (tuple(comps), tuple(wires))


def build(designs, title: str = None, changed_only: bool = True) -> str:
    """`designs` is one Design, or a list of (label, Design) shown side by side.

    With `changed_only`, every design after the first contributes just the
    circuits that actually differ from it -- the rest would be byte-identical
    schematics, and the payload has to stay small enough to publish.
    """
    if isinstance(designs, Design):
        designs = [(designs.path.split("/")[-1], designs)]

    base = designs[0][1]
    payload = []
    for label, d in designs:
        order = [d.main] + [n for n in d.circuits if n != d.main]
        circuits = [_circuit_payload(d, n) for n in order]
        if d is not base:
            for c in circuits:
                same = (c["name"] in base.circuits
                        and _fingerprint(d, c["name"]) == _fingerprint(base, c["name"]))
                c["changed"] = not same
            if changed_only:
                circuits = [c for c in circuits if c["changed"]]
        payload.append({"label": label, "file": d.path.split("/")[-1],
                        "main": d.main if any(c["name"] == d.main for c in circuits)
                                else (circuits[0]["name"] if circuits else d.main),
                        "partial": d is not base and changed_only,
                        "circuits": circuits})

    data = {"designs": payload}
    blob = json.dumps(data, separators=(",", ":")).replace("</", "<\\/")
    name = title or "Circuit Room"
    return _TEMPLATE.replace("__TITLE__", name).replace("/*__DATA__*/null", blob)


_TEMPLATE = r"""<title>__TITLE__</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap">
<style>
:root{
  --ground:#f4f6f5; --surface:#ffffff; --raised:#eef1ef;
  --ink:#16211f; --muted:#5d6b68; --faint:#8b9995;
  --rule:#dce3e0; --accent:#1f6f5c; --accent-soft:#e3efeb;
  --flag:#b4432f; --flag-soft:#f7e6e1;
  --sch-bg:#fbfcfb; --sch-wire1:#2f7a58; --sch-wiren:#25332f;
  --sch-body:#ffffff; --sch-stroke:#25332f; --sch-sub:#eaf1ee;
  --sch-pin:#1f6f5c; --sch-label:#25332f; --sch-dim:#93a29d;
  --shadow:0 1px 2px rgba(20,35,30,.06),0 8px 24px rgba(20,35,30,.06);
}
@media (prefers-color-scheme:dark){
  :root:not([data-theme="light"]){
    --ground:#0e1413; --surface:#151d1b; --raised:#1c2523;
    --ink:#e7edea; --muted:#93a49f; --faint:#6d7d78;
    --rule:#26312e; --accent:#4fbfa0; --accent-soft:#17302a;
    --flag:#ef8b6c; --flag-soft:#33211b;
    --sch-bg:#0f1615; --sch-wire1:#4fbf85; --sch-wiren:#c3cfcb;
    --sch-body:#18211f; --sch-stroke:#b8c6c2; --sch-sub:#1d2b28;
    --sch-pin:#4fbfa0; --sch-label:#cad6d2; --sch-dim:#5f706b;
    --shadow:0 1px 2px rgba(0,0,0,.4),0 8px 24px rgba(0,0,0,.35);
  }
}
:root[data-theme="dark"]{
  --ground:#0e1413; --surface:#151d1b; --raised:#1c2523;
  --ink:#e7edea; --muted:#93a49f; --faint:#6d7d78;
  --rule:#26312e; --accent:#4fbfa0; --accent-soft:#17302a;
  --flag:#ef8b6c; --flag-soft:#33211b;
  --sch-bg:#0f1615; --sch-wire1:#4fbf85; --sch-wiren:#c3cfcb;
  --sch-body:#18211f; --sch-stroke:#b8c6c2; --sch-sub:#1d2b28;
  --sch-pin:#4fbfa0; --sch-label:#cad6d2; --sch-dim:#5f706b;
  --shadow:0 1px 2px rgba(0,0,0,.4),0 8px 24px rgba(0,0,0,.35);
}
*{box-sizing:border-box}
body{
  margin:0;background:var(--ground);color:var(--ink);
  font-family:Archivo,system-ui,-apple-system,"Segoe UI",sans-serif;
  font-size:14px;line-height:1.5;height:100vh;overflow:hidden;
  display:grid;grid-template-columns:296px 1fr;grid-template-rows:auto 1fr;
  grid-template-areas:"head head" "rail stage";
}
.mono{font-family:"IBM Plex Mono",ui-monospace,SFMono-Regular,Menlo,monospace}
header{
  grid-area:head;display:flex;align-items:baseline;gap:18px;flex-wrap:wrap;
  padding:14px 22px;border-bottom:1px solid var(--rule);background:var(--surface);
}
header h1{
  margin:0;font-size:15px;font-weight:700;letter-spacing:-.01em;
}
header .file{
  font-family:"IBM Plex Mono",monospace;font-size:12px;color:var(--muted);
}
.switch{display:flex;gap:2px;background:var(--raised);padding:2px;border-radius:7px}
.switch button{
  border:0;background:none;color:var(--muted);cursor:pointer;font:inherit;font-weight:600;
  font-size:12px;padding:4px 11px;border-radius:5px;font-family:"IBM Plex Mono",monospace;
}
.switch button:hover{color:var(--ink)}
.switch button:focus-visible{outline:2px solid var(--accent);outline-offset:1px}
.switch button[aria-pressed="true"]{background:var(--surface);color:var(--accent);box-shadow:var(--shadow)}
.tag-diff{font-size:10px;font-weight:600;letter-spacing:.03em;text-transform:uppercase;
  padding:1px 5px;border-radius:3px;background:var(--flag-soft);color:var(--flag)}
header .facts{margin-left:auto;display:flex;gap:20px;color:var(--muted);font-size:12px}
header .facts b{
  color:var(--ink);font-family:"IBM Plex Mono",monospace;font-weight:600;
  font-variant-numeric:tabular-nums;
}
#rail{
  grid-area:rail;border-right:1px solid var(--rule);background:var(--surface);
  overflow-y:auto;display:flex;flex-direction:column;
}
.search{padding:12px 14px;border-bottom:1px solid var(--rule);position:sticky;top:0;background:var(--surface);z-index:2}
.search input{
  width:100%;padding:7px 10px;border:1px solid var(--rule);border-radius:6px;
  background:var(--ground);color:var(--ink);font-family:"IBM Plex Mono",monospace;font-size:12px;
}
.search input:focus{outline:2px solid var(--accent);outline-offset:1px;border-color:transparent}
.railnote{margin:8px 0 0;font-size:11.5px;line-height:1.45;color:var(--muted)}
.railnote:empty{display:none}
.clist{list-style:none;margin:0;padding:6px 0 20px}
.clist li{margin:0}
.clist button{
  width:100%;text-align:left;background:none;border:0;cursor:pointer;color:inherit;
  padding:8px 14px;display:grid;grid-template-columns:1fr auto;gap:2px 8px;font:inherit;
  border-left:3px solid transparent;
}
.clist button:hover{background:var(--raised)}
.clist button:focus-visible{outline:2px solid var(--accent);outline-offset:-2px}
.clist button[aria-current="true"]{background:var(--accent-soft);border-left-color:var(--accent)}
.cname{font-family:"IBM Plex Mono",monospace;font-size:12.5px;font-weight:500;overflow:hidden;text-overflow:ellipsis}
.cmeta{
  grid-column:1/-1;display:flex;align-items:center;gap:8px;
  font-size:11px;color:var(--muted);font-variant-numeric:tabular-nums;
}
.bar{height:3px;border-radius:2px;background:var(--accent);opacity:.5;min-width:2px}
.chip{
  font-size:10px;font-weight:600;letter-spacing:.03em;text-transform:uppercase;
  padding:1px 5px;border-radius:3px;background:var(--flag-soft);color:var(--flag);
}
.tag-main{font-size:10px;font-weight:600;letter-spacing:.03em;text-transform:uppercase;
  padding:1px 5px;border-radius:3px;background:var(--accent-soft);color:var(--accent)}
#stage{grid-area:stage;position:relative;overflow:hidden;background:var(--sch-bg)}
#canvas{position:absolute;inset:0;cursor:grab;touch-action:none}
#canvas.drag{cursor:grabbing}
#canvas svg{position:absolute;transform-origin:0 0;width:auto;height:auto}
.toolbar{
  position:absolute;top:14px;right:14px;display:flex;gap:6px;z-index:3;
  background:var(--surface);border:1px solid var(--rule);border-radius:8px;padding:5px;box-shadow:var(--shadow);
}
.toolbar button{
  border:0;background:none;color:var(--muted);cursor:pointer;font:inherit;
  font-size:12px;padding:5px 9px;border-radius:5px;font-family:"IBM Plex Mono",monospace;
}
.toolbar button:hover{background:var(--raised);color:var(--ink)}
.toolbar button:focus-visible{outline:2px solid var(--accent);outline-offset:1px}
.toolbar button[aria-pressed="true"]{background:var(--accent-soft);color:var(--accent)}
#inspector{
  position:absolute;left:14px;bottom:14px;width:340px;max-height:56%;z-index:3;
  background:var(--surface);border:1px solid var(--rule);border-radius:10px;
  box-shadow:var(--shadow);display:flex;flex-direction:column;overflow:hidden;
}
#inspector h2{
  margin:0;padding:10px 14px;font-size:11px;letter-spacing:.06em;text-transform:uppercase;
  color:var(--muted);border-bottom:1px solid var(--rule);display:flex;justify-content:space-between;align-items:center;
}
#inspector .body{padding:10px 14px 14px;overflow-y:auto;font-size:12px}
#inspector table{width:100%;border-collapse:collapse;font-family:"IBM Plex Mono",monospace;font-size:11.5px}
#inspector td{padding:3px 6px 3px 0;vertical-align:top;border-bottom:1px solid var(--rule)}
#inspector td:last-child{text-align:right;color:var(--muted);font-variant-numeric:tabular-nums}
.hint{color:var(--faint);font-size:12px}
.pill{display:inline-block;padding:1px 6px;border-radius:3px;background:var(--raised);color:var(--muted);font-size:11px}
.w.sel{stroke:var(--flag)!important;stroke-width:4!important}
.j.sel{fill:var(--flag)!important;r:5}
.lintrow{display:flex;gap:8px;padding:4px 0;border-bottom:1px solid var(--rule);font-family:"IBM Plex Mono",monospace;font-size:11px}
.lintrow b{color:var(--flag);font-weight:600}
@media (max-width:820px){
  body{grid-template-columns:1fr;grid-template-areas:"head" "stage"}
  #rail{display:none}
}
@media (prefers-reduced-motion:reduce){*{transition:none!important;animation:none!important}}
</style>

<header>
  <h1>Circuit Room</h1>
  <div class="switch" id="switch" role="group" aria-label="Which design to view"></div>
  <span class="file mono" id="fileName"></span>
  <div class="facts">
    <span><b id="fCirc">0</b> circuits</span>
    <span><b id="fComp">0</b> components</span>
    <span><b id="fWire">0</b> wires</span>
    <span><b id="fCov">0%</b> pins resolved</span>
  </div>
</header>

<nav id="rail">
  <div class="search">
    <input id="q" type="search" placeholder="Filter circuits  /" aria-label="Filter circuits">
    <p class="railnote" id="railnote"></p>
  </div>
  <ul class="clist" id="clist"></ul>
</nav>

<main id="stage">
  <div id="canvas"></div>
  <div class="toolbar">
    <button id="zoomOut" title="Zoom out">&minus;</button>
    <button id="zoomIn" title="Zoom in">+</button>
    <button id="fit" title="Fit to window">fit</button>
    <button id="labels" aria-pressed="true" title="Toggle component labels">labels</button>
  </div>
  <aside id="inspector">
    <h2><span id="insTitle">Circuit</span><span class="pill" id="insTag"></span></h2>
    <div class="body" id="insBody"></div>
  </aside>
</main>

<script>
const ALL = /*__DATA__*/null;
let DATA = ALL.designs[0], byName = {};
let current = null, scale = 1, tx = 0, ty = 0, showLabels = true, selNet = null;

const $ = id => document.getElementById(id);
const canvas = $("canvas");

function facts() {
  byName = Object.fromEntries(DATA.circuits.map(c => [c.name, c]));
  $("fileName").textContent = DATA.file;
  $("fCirc").textContent = DATA.circuits.length;
  $("fComp").textContent = DATA.circuits.reduce((a, c) => a + c.comps, 0).toLocaleString();
  $("fWire").textContent = DATA.circuits.reduce((a, c) => a + c.wires, 0).toLocaleString();
  const m = DATA.circuits.reduce((a, c) => a + c.coverage[0], 0);
  const t = DATA.circuits.reduce((a, c) => a + c.coverage[1], 0);
  $("fCov").textContent = (100 * m / t).toFixed(1) + "%";
}

function railNote() {
  $("railnote").textContent = DATA.partial
    ? "Showing only the circuits that differ from " + ALL.designs[0].label + "."
    : "";
}

function renderSwitch() {
  const box = $("switch");
  box.textContent = "";
  if (ALL.designs.length < 2) { box.style.display = "none"; return; }
  ALL.designs.forEach(dz => {
    const b = document.createElement("button");
    b.type = "button";
    b.textContent = dz.label;
    b.setAttribute("aria-pressed", String(dz === DATA));
    b.onclick = () => {
      if (dz === DATA) return;
      const keep = current && current.name;
      DATA = dz; facts(); renderSwitch(); railNote();
      select(byName[keep] ? keep : DATA.main);
    };
    box.append(b);
  });
}

/* ---- circuit rail ---- */
const maxComps = Math.max(...ALL.designs.flatMap(d => d.circuits.map(c => c.comps)));
function renderList(filter) {
  const ul = $("clist"); ul.textContent = "";
  for (const c of DATA.circuits) {
    if (filter && !c.name.toLowerCase().includes(filter)) continue;
    const li = document.createElement("li");
    const b = document.createElement("button");
    b.type = "button";
    b.setAttribute("aria-current", c.name === (current && current.name) ? "true" : "false");
    const n = document.createElement("span");
    n.className = "cname"; n.textContent = c.name;
    const meta = document.createElement("span");
    meta.className = "cmeta";
    const bar = document.createElement("span");
    bar.className = "bar";
    bar.style.width = Math.max(2, Math.round(60 * c.comps / maxComps)) + "px";
    meta.append(bar, txt(c.comps + " parts"), txt("·"), txt(c.nets + " nets"));
    if (c.name === DATA.main) meta.append(tagEl("tag-main", "main"));
    if (c.changed) meta.append(tagEl("tag-diff", "changed"));
    if (c.near.length) meta.append(tagEl("chip", c.near.length + " near"));
    b.append(n, meta);
    b.onclick = () => select(c.name);
    li.append(b); ul.append(li);
  }
}
const txt = s => { const e = document.createElement("span"); e.textContent = s; return e; };
const tagEl = (cls, s) => { const e = document.createElement("span"); e.className = cls; e.textContent = s; return e; };

/* ---- viewport ---- */
function applyTransform() {
  const svg = canvas.querySelector("svg");
  if (svg) svg.style.transform = `translate(${tx}px,${ty}px) scale(${scale})`;
}
function fit() {
  const svg = canvas.querySelector("svg");
  if (!svg) return;
  const vb = svg.viewBox.baseVal;
  const r = canvas.getBoundingClientRect();
  scale = Math.min((r.width - 40) / vb.width, (r.height - 40) / vb.height);
  tx = (r.width - vb.width * scale) / 2 - vb.x * scale;
  ty = (r.height - vb.height * scale) / 2 - vb.y * scale;
  applyTransform();
}
function zoomAt(cx, cy, factor) {
  const next = Math.min(12, Math.max(0.02, scale * factor));
  tx = cx - (cx - tx) * (next / scale);
  ty = cy - (cy - ty) * (next / scale);
  scale = next; applyTransform();
}

canvas.addEventListener("wheel", e => {
  e.preventDefault();
  const r = canvas.getBoundingClientRect();
  zoomAt(e.clientX - r.left, e.clientY - r.top, e.deltaY < 0 ? 1.12 : 1 / 1.12);
}, { passive: false });

let drag = null;
canvas.addEventListener("pointerdown", e => {
  drag = { x: e.clientX, y: e.clientY, tx, ty, moved: false };
  canvas.setPointerCapture(e.pointerId); canvas.classList.add("drag");
});
canvas.addEventListener("pointermove", e => {
  if (!drag) return;
  tx = drag.tx + (e.clientX - drag.x); ty = drag.ty + (e.clientY - drag.y);
  if (Math.abs(e.clientX - drag.x) + Math.abs(e.clientY - drag.y) > 3) drag.moved = true;
  applyTransform();
});
canvas.addEventListener("pointerup", e => {
  const wasDrag = drag && drag.moved;
  drag = null; canvas.classList.remove("drag");
  if (!wasDrag) pick(e);
});

$("zoomIn").onclick = () => { const r = canvas.getBoundingClientRect(); zoomAt(r.width / 2, r.height / 2, 1.25); };
$("zoomOut").onclick = () => { const r = canvas.getBoundingClientRect(); zoomAt(r.width / 2, r.height / 2, 1 / 1.25); };
$("fit").onclick = fit;
$("labels").onclick = () => {
  showLabels = !showLabels;
  $("labels").setAttribute("aria-pressed", String(showLabels));
  canvas.querySelectorAll("text.lab").forEach(t => t.style.display = showLabels ? "" : "none");
};

/* ---- selection ---- */
function pick(e) {
  const t = e.target.closest("[data-net]");
  if (!t) { clearSel(); showCircuit(); return; }
  selectNet(parseInt(t.getAttribute("data-net"), 10));
}
function clearSel() {
  canvas.querySelectorAll(".sel").forEach(n => n.classList.remove("sel"));
  selNet = null;
}
function selectNet(id) {
  clearSel(); selNet = id;
  canvas.querySelectorAll(`[data-net="${id}"]`).forEach(n => n.classList.add("sel"));
  const info = current.netinfo[id];
  $("insTitle").textContent = "Net " + id;
  $("insTag").textContent = info ? info.pts + " pts" : "";
  const body = $("insBody"); body.textContent = "";
  if (!info) { body.append(txt("No pins on this net.")); return; }
  if (info.drv.length) {
    const d = document.createElement("div");
    d.className = "hint";
    d.textContent = "Driven by " + info.drv.map(x => x[0] + (x[1] ? "[" + x[1] + "]" : "") + "." + x[2]).join(", ");
    body.append(d);
  } else {
    const d = document.createElement("div"); d.className = "hint";
    d.textContent = "No driver found on this net.";
    body.append(d);
  }
  const tb = document.createElement("table");
  for (const [nm, lab, port, loc] of info.pins) {
    const tr = tb.insertRow();
    tr.insertCell().textContent = nm + (lab ? " [" + lab + "]" : "") + " · " + port;
    tr.insertCell().textContent = loc[0] + "," + loc[1];
  }
  body.append(tb);
  if (info.more) { const m = document.createElement("div"); m.className = "hint"; m.textContent = "+" + info.more + " more pins"; body.append(m); }
}

function showCircuit() {
  const c = current;
  $("insTitle").textContent = c.name;
  $("insTag").textContent = c.nets + " nets";
  const body = $("insBody"); body.textContent = "";
  const io = document.createElement("div");
  io.className = "hint";
  io.textContent = (c.inputs.length ? "in: " + c.inputs.join(", ") : "no inputs")
    + (c.outputs.length ? "  →  out: " + c.outputs.join(", ") : "");
  body.append(io);
  const tb = document.createElement("table");
  for (const [nm, n] of c.parts.slice(0, 12)) {
    const tr = tb.insertRow();
    tr.insertCell().textContent = nm;
    tr.insertCell().textContent = "×" + n;
  }
  body.append(tb);
  if (c.near.length) {
    const h = document.createElement("div");
    h.className = "hint"; h.style.marginTop = "10px";
    h.textContent = "Wire ends that stop short of a pin:";
    body.append(h);
    for (const x of c.near.slice(0, 12)) {
      const r = document.createElement("div");
      r.className = "lintrow";
      const b = document.createElement("b"); b.textContent = x.d + "u";
      r.append(b, txt(`(${x.at[0]},${x.at[1]}) → ${x.comp}${x.label ? "[" + x.label + "]" : ""}.${x.port}`));
      body.append(r);
    }
  }
  if (c.changed) {
    const ch = document.createElement("div");
    ch.className = "hint"; ch.style.marginTop = "10px"; ch.style.color = "var(--flag)";
    ch.textContent = "This circuit differs from " + ALL.designs[0].label + ".";
    body.append(ch);
  }
  const cov = document.createElement("div");
  cov.className = "hint"; cov.style.marginTop = "10px";
  cov.textContent = `geometry resolves ${c.coverage[0]}/${c.coverage[1]} wire endpoints`;
  body.append(cov);
}

function select(name) {
  current = byName[name];
  canvas.innerHTML = current.svg;
  canvas.querySelectorAll("text.lab").forEach(t => t.style.display = showLabels ? "" : "none");
  renderList($("q").value.trim().toLowerCase());
  fit(); showCircuit();
}

$("q").addEventListener("input", () => renderList($("q").value.trim().toLowerCase()));
document.addEventListener("keydown", e => {
  if (e.key === "/" && document.activeElement !== $("q")) { e.preventDefault(); $("q").focus(); }
  else if (e.key === "Escape") { clearSel(); showCircuit(); $("q").blur(); }
  else if (e.key === "f") fit();
});
window.addEventListener("resize", () => { if (current) fit(); });

facts();
renderSwitch();
railNote();
renderList("");
select(DATA.main);
</script>
"""
