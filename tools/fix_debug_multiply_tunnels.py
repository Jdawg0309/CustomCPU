#!/usr/bin/env python3
"""Move multiply-era tunnels off component ports and add explicit wire stubs."""
from pathlib import Path
import re, sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from logisim import edit, geometry, model

PATH=Path("debug_armv4t_2.circ")
TARGETS={"multiply_decode","multiply_execute","stage_ID","stage_EX","main"}
BOUNDARY_NAMES={"multiply_decode","multiply_execute","stage_ID","stage_EX","stage_WB"}


def manual_ports(c):
    if c.name != "Multiplier": return []
    from logisim.geometry import Port
    return [Port("a",-40,-10,"in"),Port("b",-40,10,"in"),Port("out",0,0,"out"),
            Port("cin",-20,-20,"in"),Port("cout",-20,20,"out")]


def clear(circ, pt, portpts):
    if pt in portpts: return False
    for w in circ.wires:
        if w.contains(pt): return False
    return True


def replace_tunnel_loc(text,cname,old,label,new):
    a,b=edit._circuit_span(text,cname); body=text[a:b]
    pat=re.compile(r'<comp lib="0" loc="\(%d,%d\)" name="Tunnel">.*?'
                   r'<a name="label" val="%s"/>.*?</comp>'
                   % (old[0],old[1],re.escape(label)),re.S)
    m=pat.search(body)
    if not m: raise RuntimeError("tunnel not found %s %s %s"%(cname,old,label))
    block=m.group(0).replace('loc="(%d,%d)"'%old,'loc="(%d,%d)"'%new,1)
    body=body[:m.start()]+block+body[m.end():]
    return text[:a]+body+text[b:]


def add_wire_safe(text,cname,old,new):
    a,b=edit._circuit_span(text,cname); body=text[a:b]
    line='    <wire from="(%d,%d)" to="(%d,%d)"/>\n'%(old[0],old[1],new[0],new[1])
    anchor="    <wire" if "    <wire" in body else "    <comp"
    if anchor in body:
        body=body.replace(anchor,line+anchor,1)
    else:
        body+=line
    return text[:a]+body+text[b:]


def main():
    text=PATH.read_text(); d=model.load(PATH); moved=0
    for cname in TARGETS:
        circ=d[cname]
        owners={}
        for c in circ.components:
            if c.name=="Tunnel": continue
            try: ports=geometry.ports(d,c)
            except Exception: ports=manual_ports(c)
            if not ports and c.name=="Multiplier": ports=manual_ports(c)
            for p in ports:
                owners.setdefault(p.at(c),[]).append((c,p))
        portpts=set(owners)
        for t in [x for x in circ.components if x.name=="Tunnel"]:
            if t.loc not in owners: continue
            c,p=owners[t.loc][0]
            if cname not in {"multiply_decode","multiply_execute"} and c.name not in BOUNDARY_NAMES:
                continue
            dx=t.loc[0]-c.loc[0]; dy=t.loc[1]-c.loc[1]
            if abs(dx)>=abs(dy) and dx:
                dirs=[(1 if dx>0 else -1,0),(0,1),(0,-1)]
            elif dy:
                dirs=[(0,1 if dy>0 else -1),(1,0),(-1,0)]
            else:
                dirs=[((1 if p.kind=="out" else -1),0),(0,1),(0,-1)]
            new=None
            for ux,uy in dirs:
                for dist in (40,60,80,100,120):
                    q=(t.loc[0]+ux*dist,t.loc[1]+uy*dist)
                    if clear(circ,q,portpts): new=q; break
                if new: break
            if not new: raise RuntimeError("no clear stub for %s %s"%(cname,t.loc))
            text=replace_tunnel_loc(text,cname,t.loc,t.attrs.get("label",""),new)
            text=add_wire_safe(text,cname,t.loc,new)
            moved+=1
    PATH.write_text(text)
    print("moved %d overlapping tunnels onto explicit stubs"%moved)


if __name__=="__main__": main()
