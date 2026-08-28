#!/usr/bin/env python3
"""Generate the complete circuit graph atlas and comparative notebooks."""
from __future__ import annotations

import argparse
import json
from pathlib import Path

import nbformat as nbf

from ipynb.circuit_atlas import export_design, export_diff, slug


ROOT = Path(__file__).resolve().parents[1]
ATLAS = ROOT / "ipynb"


def _cell(code: str):
    return nbf.v4.new_code_cell(code)


def _md(text: str):
    return nbf.v4.new_markdown_cell(text)


def _base_cells(title: str):
    return [
        _md(f"# {title}\n\nGenerated from read-only Logisim source files. "
            "The port/net graph is canonical; visual trees are derived views."),
        _cell(
            "from pathlib import Path\n"
            "import json\n"
            "import networkx as nx\n"
            "import pandas as pd\n"
            "import matplotlib.pyplot as plt\n\n"
            "ROOT = Path.cwd()\n"
            "while not (ROOT / 'armv4t.circ').exists() and ROOT != ROOT.parent:\n"
            "    ROOT = ROOT.parent\n"
            "assert (ROOT / 'armv4t.circ').exists(), 'Run from inside the CustomCPU repository'\n"
            "ATLAS = ROOT / 'ipynb'\n"
        ),
    ]


def overview_notebook(arm_manifest: dict, debug_manifest: dict, delta_manifest: dict) -> nbf.NotebookNode:
    cells = _base_cells("CustomCPU graph atlas")
    cells += [
        _md(
            "## Reading the atlas\n\n"
            "- `*.json` contains every parsed component, port, raw wire segment, net, and directed connection.\n"
            "- `*.port_net.graphml` is the lossless bipartite electrical view.\n"
            "- `*.signal.graphml` directs every modeled driver toward its sinks.\n"
            "- `*.component.graphml` collapses ports for readable block diagrams.\n"
            "- `*.condensation.graphml` collapses feedback strongly-connected components into a DAG.\n"
            "- `data/diff/` compares `armv4t.circ` with `debug_armv4t.circ`.\n\n"
            "Human instructions use `source.output.wire -> destination.input_pin`; coordinates are machine identifiers only."
        ),
        _cell(
            "arm = json.loads((ATLAS/'data/armv4t/manifest.json').read_text())\n"
            "debug = json.loads((ATLAS/'data/debug/manifest.json').read_text())\n"
            "delta = json.loads((ATLAS/'data/diff/manifest.json').read_text())\n"
            "pd.DataFrame([{\n"
            " 'file': arm['source'], 'sha256': arm['sha256'], 'circuits': arm['circuit_count']},\n"
            " {'file': debug['source'], 'sha256': debug['sha256'], 'circuits': debug['circuit_count']}])"
        ),
        _md("## Complete circuit inventory"),
        _cell(
            "a = pd.DataFrame(arm['circuits']).set_index('name').add_prefix('arm_')\n"
            "b = pd.DataFrame(debug['circuits']).set_index('name').add_prefix('debug_')\n"
            "a.join(b, how='outer')"
        ),
        _md("## Hierarchy graph"),
        _cell(
            "h = nx.read_graphml(ATLAS/'data/armv4t/hierarchy.graphml')\n"
            "plt.figure(figsize=(18, 14))\n"
            "pos = nx.spring_layout(h, seed=7, k=1.2)\n"
            "nx.draw_networkx(h, pos, node_size=1400, font_size=7, arrows=True)\n"
            "plt.axis('off'); plt.show()"
        ),
        _md("## File-to-file changes"),
        _cell("pd.DataFrame(delta['circuits']).query('changed == True')"),
    ]
    return nbf.v4.new_notebook(cells=cells, metadata={"kernelspec": {
        "display_name": "Python 3", "language": "python", "name": "python3"}})


def circuit_notebook(name: str) -> nbf.NotebookNode:
    s = slug(name)
    cells = _base_cells(f"Circuit: `{name}`")
    cells += [
        _cell(
            f"CIRCUIT = {name!r}\nSLUG = {s!r}\n"
            "arm = json.loads((ATLAS/f'data/armv4t/{SLUG}.json').read_text())\n"
            "debug = json.loads((ATLAS/f'data/debug/{SLUG}.json').read_text())\n"
            "delta = json.loads((ATLAS/f'data/diff/{SLUG}.json').read_text())"
        ),
        _md("## Purpose and human audit"),
        _cell(
            "from IPython.display import Markdown, display\n"
            "paths = sorted((ATLAS/'audits').glob(f'**/{SLUG}*.md'))\n"
            "if paths:\n"
            "    for path in paths:\n"
            "        display(Markdown(f'### {path.relative_to(ATLAS)}\\n' + path.read_text()))\n"
            "else:\n"
            "    display(Markdown('*Semantic audit pending; machine graph below is complete.*'))"
        ),
        _md("## Interface and component inventory"),
        _cell(
            "def interface_rows(data):\n"
            "    wanted = set(data['interface']['inputs'] + data['interface']['outputs'])\n"
            "    rows = []\n"
            "    for c in data['components']:\n"
            "        if c['id'] in wanted:\n"
            "            rows.append({'component': c['id'], 'label': c['label'],\n"
            "                         'direction': 'input' if c['id'] in data['interface']['inputs'] else 'output',\n"
            "                         'width': c['attributes'].get('width', '1'), 'facing': c['facing']})\n"
            "    return pd.DataFrame(rows)\n"
            "display(interface_rows(arm))\n"
            "display(pd.DataFrame({'armv4t': arm['inventory'], 'debug': debug['inventory']}).fillna(0).astype(int))"
        ),
        _md("## Every component and port"),
        _cell(
            "component_rows = []\n"
            "for c in arm['components']:\n"
            "    if c['ports']:\n"
            "        for p in c['ports']:\n"
            "            component_rows.append({'component': c['id'], 'type': c['type'], 'label': c['label'],\n"
            "                'port': p['name'], 'direction': p['direction'], 'width': p['width'],\n"
            "                'pin': tuple(p['pin']), 'attributes': c['attributes']})\n"
            "    else:\n"
            "        component_rows.append({'component': c['id'], 'type': c['type'], 'label': c['label'],\n"
            "            'port': None, 'direction': None, 'width': None, 'pin': None, 'attributes': c['attributes']})\n"
            "components = pd.DataFrame(component_rows)\ncomponents"
        ),
        _md("## Every electrical net"),
        _cell(
            "nets = pd.DataFrame(arm['graph']['nets'])\n"
            "nets[['index', 'name', 'status', 'drivers', 'ports', 'labels']]"
        ),
        _md("## Every directed signal connection"),
        _cell(
            "connections = pd.DataFrame(arm['graph']['edges'])\n"
            "connections['instruction'] = connections['src'] + '.wire -> ' + connections['dst']\n"
            "connections[['net', 'instruction', 'src', 'dst']]"
        ),
        _md("## State, feedback, and condensation tree"),
        _cell(
            "signal = nx.read_graphml(ATLAS/f'data/armv4t/{SLUG}.signal.graphml')\n"
            "scc = sorted(nx.strongly_connected_components(signal), key=len, reverse=True)\n"
            "pd.DataFrame([{'size': len(group), 'members': sorted(group)} for group in scc if len(group) > 1])"
        ),
        _md("## Component-level graph"),
        _cell(
            "cg = nx.read_graphml(ATLAS/f'data/armv4t/{SLUG}.component.graphml')\n"
            "plt.figure(figsize=(18, 12))\n"
            "pos = {node: (float(data.get('x', 0)), -float(data.get('y', 0))) for node, data in cg.nodes(data=True)}\n"
            "nx.draw_networkx_nodes(cg, pos, node_size=300, alpha=.75)\n"
            "nx.draw_networkx_edges(cg, pos, arrows=True, width=.6, alpha=.45)\n"
            "if len(cg) <= 80:\n"
            "    nx.draw_networkx_labels(cg, pos, font_size=5)\n"
            "plt.axis('off'); plt.show()"
        ),
        _md("## Health and model coverage"),
        _cell(
            "display(pd.DataFrame([{'file': 'armv4t', **arm['coverage'], **arm['health']},\n"
            "                      {'file': 'debug', **debug['coverage'], **debug['health']}]))"
        ),
        _md("## `armv4t` → `debug` delta"),
        _cell(
            "display(Markdown('**' + delta['summary'] + '**'))\n"
            "display(pd.DataFrame({\n"
            " 'only_arm_node': pd.Series(delta['only_a_nodes']),\n"
            " 'only_debug_node': pd.Series(delta['only_b_nodes'])}))\n"
            "display(pd.DataFrame({\n"
            " 'only_arm_connection': pd.Series([' -> '.join(x) for x in delta['only_a_connections']]),\n"
            " 'only_debug_connection': pd.Series([' -> '.join(x) for x in delta['only_b_connections']])}))"
        ),
    ]
    return nbf.v4.new_notebook(cells=cells, metadata={"kernelspec": {
        "display_name": "Python 3", "language": "python", "name": "python3"}})


def build(execute: bool = False) -> None:
    arm = export_design(ROOT / "armv4t.circ", ATLAS / "data/armv4t")
    debug = export_design(ROOT / "debug_armv4t.circ", ATLAS / "data/debug")
    delta = export_diff(ROOT / "armv4t.circ", ROOT / "debug_armv4t.circ", ATLAS / "data/diff")
    notebooks = ATLAS / "notebooks"
    notebooks.mkdir(parents=True, exist_ok=True)
    nbf.write(overview_notebook(arm, debug, delta), notebooks / "00_architecture_overview.ipynb")
    for index, record in enumerate(arm["circuits"], start=1):
        name = record["name"]
        nbf.write(circuit_notebook(name), notebooks / f"{index:02d}_{slug(name)}.ipynb")

    if execute:
        from nbclient import NotebookClient
        for path in sorted(notebooks.glob("*.ipynb")):
            notebook = nbf.read(path, as_version=4)
            NotebookClient(notebook, timeout=600, kernel_name="python3").execute(cwd=str(ROOT))
            nbf.write(notebook, path)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--execute", action="store_true", help="execute and save every notebook")
    args = parser.parse_args()
    build(execute=args.execute)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

