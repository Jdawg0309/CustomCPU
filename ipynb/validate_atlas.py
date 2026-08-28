#!/usr/bin/env python3
"""Validate that the generated atlas covers both source circuit files."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

import nbformat
import networkx as nx

from ipynb.circuit_atlas import slug
from logisim.graph import Graph
from logisim.model import load


ROOT = Path(__file__).resolve().parents[1]
ATLAS = ROOT / "ipynb"


def validate_source(filename: str, data_dir: str) -> list[str]:
    errors: list[str] = []
    source = ROOT / filename
    design = load(str(source))
    root = ATLAS / "data" / data_dir
    manifest = json.loads((root / "manifest.json").read_text())
    expected_hash = hashlib.sha256(source.read_bytes()).hexdigest()
    if manifest["sha256"] != expected_hash:
        errors.append(f"{filename}: stale manifest hash")
    if manifest["circuit_count"] != len(design.circuits):
        errors.append(f"{filename}: circuit-count mismatch")

    records = {record["name"]: record for record in manifest["circuits"]}
    if set(records) != set(design.circuits):
        errors.append(f"{filename}: manifest circuit names differ from source")

    for name, circuit in design.circuits.items():
        s = slug(name)
        required = [
            root / f"{s}.json",
            root / f"{s}.port_net.graphml",
            root / f"{s}.signal.graphml",
            root / f"{s}.component.graphml",
            root / f"{s}.condensation.graphml",
        ]
        for path in required:
            if not path.is_file():
                errors.append(f"{filename}/{name}: missing {path.name}")
        if any(not path.is_file() for path in required):
            continue
        raw = json.loads(required[0].read_text())
        graph = Graph(design, name)
        if len(raw["components"]) != len(circuit.components):
            errors.append(f"{filename}/{name}: component coverage mismatch")
        if len(raw["wires"]) != len(circuit.wires):
            errors.append(f"{filename}/{name}: wire coverage mismatch")
        if len(raw["graph"]["nodes"]) != len(graph.nodes):
            errors.append(f"{filename}/{name}: port-node coverage mismatch")
        if len(raw["graph"]["nets"]) != len(graph.nets):
            errors.append(f"{filename}/{name}: net coverage mismatch")
        if len(raw["graph"]["edges"]) != len(graph.edges):
            errors.append(f"{filename}/{name}: signal-edge coverage mismatch")
        for path in required[1:]:
            try:
                nx.read_graphml(path)
            except Exception as exc:  # pragma: no cover - diagnostic path
                errors.append(f"{filename}/{name}: unreadable {path.name}: {exc}")
    return errors


def validate_notebooks() -> list[str]:
    errors: list[str] = []
    manifest = json.loads((ATLAS / "data/armv4t/manifest.json").read_text())
    paths = sorted((ATLAS / "notebooks").glob("*.ipynb"))
    if len(paths) != manifest["circuit_count"] + 1:
        errors.append(f"expected {manifest['circuit_count'] + 1} notebooks, found {len(paths)}")
    for path in paths:
        try:
            notebook = nbformat.read(path, as_version=4)
            nbformat.validate(notebook)
        except Exception as exc:  # pragma: no cover - diagnostic path
            errors.append(f"invalid notebook {path.name}: {exc}")
    return errors


def main() -> int:
    errors = []
    errors += validate_source("armv4t.circ", "armv4t")
    errors += validate_source("debug_armv4t.circ", "debug")
    errors += validate_notebooks()
    if errors:
        print("Atlas validation failed:")
        for error in errors:
            print(f"- {error}")
        return 1
    print("Atlas validation passed: both source files, every circuit, every generated graph, and every notebook.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

