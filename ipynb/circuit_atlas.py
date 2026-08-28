"""Lossless-ish graph exports and notebook data for Logisim Evolution files.

The electrical model is deliberately graph-first.  Circuit feedback makes a
tree an invalid canonical representation, so trees are derived from a complete
port/net graph and never used as the source of truth.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path
from typing import Dict, Iterable, Mapping, Optional

import networkx as nx

from logisim import geometry as geo
from logisim.graph import Graph, comp_id, diff
from logisim.model import Component, Design, load
from logisim.netlist import coverage


def slug(name: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", name).strip("_") or "circuit"


def _jsonable_attrs(attrs: Mapping[str, str]) -> Dict[str, str]:
    return {str(k): str(v) for k, v in sorted(attrs.items())}


def _port_width(comp: Component, port: str) -> Optional[int]:
    """Return a width only when it can be inferred without guessing."""
    if comp.name in {"ROM", "RAM"}:
        if port == "addr":
            return int(comp.attrs.get("addrWidth", 8))
        if port in {"data_in", "data_out"}:
            return int(comp.attrs.get("dataWidth", 8))
        return 1
    if comp.name == "Splitter":
        incoming = int(comp.attrs.get("incoming", comp.attrs.get("width", 1)))
        if port == "combined":
            return incoming
        if port.startswith("bit"):
            fan = int(port[3:])
            assigned = []
            for bit in range(incoming):
                value = comp.attrs.get(f"bit{bit}", "0")
                if value != "none" and int(value) == fan:
                    assigned.append(bit)
            return len(assigned)
    if port in {"sel", "dist"}:
        if comp.name in {"Multiplexer", "Demultiplexer", "Decoder"}:
            return int(comp.attrs.get("select", 1))
        if comp.name == "Shifter":
            return max(1, (int(comp.attrs.get("width", 1)) - 1).bit_length())
    if port in {"en", "clk", "clr", "cin", "cout", "gt", "eq", "lt", "we"}:
        return 1
    if comp.name in {"AND Gate", "OR Gate", "NAND Gate", "NOR Gate",
                     "XOR Gate", "XNOR Gate", "NOT Gate", "Buffer"}:
        return int(comp.attrs.get("width", 1))
    if comp.name == "Pin":
        return int(comp.attrs.get("width", 1))
    if comp.name == "Constant":
        return int(comp.attrs.get("width", 1))
    if "width" in comp.attrs:
        return int(comp.attrs["width"])
    return None


def _component_lookup(design: Design, circuit: str) -> Dict[str, Component]:
    return {comp_id(c): c for c in design[circuit].components}


def port_net_graph(graph: Graph) -> nx.MultiGraph:
    """Bipartite representation: ports on one side, electrical nets on the other."""
    out = nx.MultiGraph(circuit=graph.circuit_name, source=graph.design.path,
                        graph_kind="port_net")
    comps = _component_lookup(graph.design, graph.circuit_name)
    for node in graph.nodes.values():
        comp = comps[node.comp]
        out.add_node(
            f"port:{node.id}", bipartite="port", node_kind="port",
            component=node.comp, component_type=node.kind, port=node.port,
            direction=node.direction, label=node.label or "", x=node.pin[0], y=node.pin[1],
            width=_port_width(comp, node.port) or 0,
        )
    for net in graph.nets:
        nid = f"net:{net.index}"
        out.add_node(nid, bipartite="net", node_kind="net", index=net.index,
                     name=net.name, status=net.status, labels="|".join(net.labels),
                     points=len(net.points), drivers=len(net.drivers))
        for port in net.ports:
            if f"port:{port}" in out:
                out.add_edge(f"port:{port}", nid, relation="attached")
    return out


def signal_graph(graph: Graph) -> nx.MultiDiGraph:
    out = nx.MultiDiGraph(circuit=graph.circuit_name, source=graph.design.path,
                          graph_kind="signal")
    comps = _component_lookup(graph.design, graph.circuit_name)
    for node in graph.nodes.values():
        comp = comps[node.comp]
        out.add_node(node.id, component=node.comp, component_type=node.kind,
                     port=node.port, direction=node.direction, label=node.label or "",
                     x=node.pin[0], y=node.pin[1], width=_port_width(comp, node.port) or 0)
    for edge in graph.edges:
        net_name = "splitter-through" if edge.net < 0 else graph.nets[edge.net].name
        out.add_edge(edge.src, edge.dst, net=edge.net, net_name=net_name)
    return out


def component_graph(graph: Graph) -> nx.MultiDiGraph:
    out = nx.MultiDiGraph(circuit=graph.circuit_name, source=graph.design.path,
                          graph_kind="component")
    comps = _component_lookup(graph.design, graph.circuit_name)
    for cid, comp in comps.items():
        out.add_node(cid, component_type=comp.name, label=comp.label or "",
                     x=comp.loc[0], y=comp.loc[1], facing=comp.facing,
                     is_subcircuit=comp.is_subcircuit)
    for edge in graph.edges:
        src = graph.nodes[edge.src]
        dst = graph.nodes[edge.dst]
        if src.comp == dst.comp:
            continue
        net_name = "splitter-through" if edge.net < 0 else graph.nets[edge.net].name
        out.add_edge(src.comp, dst.comp, src_port=src.port, dst_port=dst.port,
                     source_node=edge.src, destination_node=edge.dst,
                     net=edge.net, net_name=net_name)
    return out


def hierarchy_graph(design: Design) -> nx.MultiDiGraph:
    out = nx.MultiDiGraph(source=design.path, graph_kind="hierarchy")
    for name in design.circuits:
        out.add_node(name, top=name == design.main)
    for parent, circuit in design.circuits.items():
        for comp in circuit.components:
            if comp.is_subcircuit and comp.name in design.circuits:
                out.add_edge(parent, comp.name, instance=comp_id(comp),
                             x=comp.loc[0], y=comp.loc[1], label=comp.label or "")
    return out


def _raw_circuit(design: Design, graph: Graph) -> dict:
    circuit = design[graph.circuit_name]
    lookup = _component_lookup(design, graph.circuit_name)
    components = []
    for component in circuit.components:
        cid = comp_id(component)
        ports = []
        for node in sorted(graph.ports_of(cid), key=lambda item: item.port):
            ports.append({"id": node.id, "name": node.port, "direction": node.direction,
                          "anchor": list(node.loc), "pin": list(node.pin),
                          "width": _port_width(component, node.port)})
        components.append({"id": cid, "type": component.name, "library": component.lib,
                           "location": list(component.loc), "facing": component.facing,
                           "label": component.label, "is_subcircuit": component.is_subcircuit,
                           "attributes": _jsonable_attrs(component.attrs), "ports": ports})

    problems = graph.problems()
    return {
        "source": design.path,
        "circuit": graph.circuit_name,
        "attributes": _jsonable_attrs(circuit.attrs),
        "bounding_box": list(circuit.bbox()),
        "interface": {
            "inputs": [comp_id(c) for c in circuit.inputs()],
            "outputs": [comp_id(c) for c in circuit.outputs()],
        },
        "inventory": dict(sorted(Counter(c.name for c in circuit.components).items())),
        "components": components,
        "wires": [{"index": i, "from": list(w.a), "to": list(w.b),
                   "diagonal": w.diagonal} for i, w in enumerate(circuit.wires)],
        "graph": graph.to_dict(),
        "coverage": coverage(design, circuit),
        "health": {
            "undriven_nets": [n.index for n in problems["undriven"]],
            "multi_driver_nets": [n.index for n in problems["multi_driver"]],
            "dangling_nets": [n.index for n in problems["dangling"]],
            "dead_components": graph.dead(),
        },
    }


def _write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def _write_graphml(graph: nx.Graph, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    safe = graph.copy()

    def clean(value: object) -> str | int | float | bool:
        if isinstance(value, (str, int, float, bool)):
            return value
        return json.dumps(value, sort_keys=True, default=str)

    safe.graph.update({key: clean(value) for key, value in safe.graph.items()})
    for _, attrs in safe.nodes(data=True):
        attrs.update({key: clean(value) for key, value in attrs.items()})
    for edge in safe.edges(data=True, keys=True) if safe.is_multigraph() else safe.edges(data=True):
        attrs = edge[-1]
        attrs.update({key: clean(value) for key, value in attrs.items()})
    nx.write_graphml(safe, path)


def export_design(source: str | Path, destination: str | Path) -> dict:
    source = Path(source)
    destination = Path(destination)
    design = load(str(source))
    destination.mkdir(parents=True, exist_ok=True)
    manifest = {
        "source": str(source),
        "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "main": design.main,
        "circuit_count": len(design.circuits),
        "circuits": [],
    }
    for name in design.circuits:
        graph = Graph(design, name)
        base = destination / slug(name)
        raw = _raw_circuit(design, graph)
        _write_json(base.with_suffix(".json"), raw)
        png = port_net_graph(graph)
        sig = signal_graph(graph)
        cmp = component_graph(graph)
        condensed = nx.condensation(nx.DiGraph(sig))
        for _, attrs in condensed.nodes(data=True):
            attrs["members"] = "|".join(sorted(str(item) for item in attrs["members"]))
        _write_graphml(png, base.with_suffix(".port_net.graphml"))
        _write_graphml(sig, base.with_suffix(".signal.graphml"))
        _write_graphml(cmp, base.with_suffix(".component.graphml"))
        _write_graphml(condensed, base.with_suffix(".condensation.graphml"))
        manifest["circuits"].append({
            "name": name,
            "slug": slug(name),
            "components": len(design[name].components),
            "wire_segments": len(design[name].wires),
            "ports": len(graph.nodes),
            "nets": len(graph.nets),
            "signal_edges": len(graph.edges),
            "strongly_connected_components": nx.number_strongly_connected_components(nx.DiGraph(sig)),
        })
    hierarchy = hierarchy_graph(design)
    _write_graphml(hierarchy, destination / "hierarchy.graphml")
    _write_json(destination / "hierarchy.json", nx.node_link_data(hierarchy))
    _write_json(destination / "manifest.json", manifest)
    return manifest


def export_diff(a_source: str | Path, b_source: str | Path, destination: str | Path) -> dict:
    a = load(str(a_source))
    b = load(str(b_source))
    destination = Path(destination)
    destination.mkdir(parents=True, exist_ok=True)
    common = sorted(set(a.circuits) & set(b.circuits))
    result = {"a": str(a_source), "b": str(b_source), "circuits": []}
    for name in common:
        ga, gb = Graph(a, name), Graph(b, name)
        d = diff(ga, gb)
        record = {
            "circuit": name,
            "only_a_nodes": d.only_a_nodes,
            "only_b_nodes": d.only_b_nodes,
            "only_a_connections": [list(edge) for edge in d.only_a_edges],
            "only_b_connections": [list(edge) for edge in d.only_b_edges],
            "summary": d.summary(),
        }
        _write_json(destination / f"{slug(name)}.json", record)
        result["circuits"].append({"name": name, "summary": d.summary(),
                                    "changed": any(record[k] for k in (
                                        "only_a_nodes", "only_b_nodes",
                                        "only_a_connections", "only_b_connections"))})
    result["only_a_circuits"] = sorted(set(a.circuits) - set(b.circuits))
    result["only_b_circuits"] = sorted(set(b.circuits) - set(a.circuits))
    _write_json(destination / "manifest.json", result)
    return result
