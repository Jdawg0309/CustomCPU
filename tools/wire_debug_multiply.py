#!/usr/bin/env python3
"""Integrate all ARM multiply-family operations in debug_armv4t_2.circ only."""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from logisim import edit, geometry, model

PATH = Path("debug_armv4t_2.circ")


def add_pin(text, circ, loc, label, width=1, output=False):
    a = {"appearance": "classic", "label": label,
         "facing": "west" if output else "east"}
    if width != 1:
        a["width"] = str(width)
    if output:
        a["output"] = "true"
    return edit.add_component(text, circ, "0", "Pin", loc, a)


def add_tunnel(text, circ, loc, label, width=1, facing="east"):
    a = {"facing": facing, "label": label}
    if width != 1:
        a["width"] = str(width)
    return edit.add_component(text, circ, "0", "Tunnel", loc, a)


def at_port(text, circ, loc, label, width=1):
    return add_tunnel(text, circ, loc, label, width)


def component_ports(design, name, lib, loc, attrs):
    c = model.Component(name=name, lib=lib, loc=loc, attrs=attrs)
    return {p.name: p.at(c) for p in geometry.ports(design, c)}


def sub_ports(design, subname, loc):
    w = geometry._subcircuit_box_width(design, subname)
    sub = design[subname]
    out = {}
    for k, p in enumerate(sub.outputs()):
        out[p.label] = (loc[0], loc[1] + 20*k)
    for k, p in enumerate(sub.inputs()):
        out[p.label] = (loc[0]-w, loc[1] + 20*k)
    return out


def add_mux(text, circ, design, loc, width, select=1, inputs=2, label=None):
    attrs = {"width": str(width)}
    if select != 1:
        attrs["select"] = str(select)
    if label:
        attrs["label"] = label
    text = edit.add_component(text, circ, "4", "Multiplexer", loc, attrs)
    return text, component_ports(design, "Multiplexer", "4", loc, attrs)


def patch_id(text, design):
    c = "stage_ID"
    # Append outputs below every existing output; append new WB inputs below all inputs.
    outputs = [
        ((4700,1900), "mul_any", 1), ((4700,1940), "mul_short", 1),
        ((4700,1980), "mul_long", 1), ((4700,2020), "mul_acc", 1),
        ((4700,2060), "mul_signed", 1), ((4700,2100), "rd_c", 32),
        ((4700,2140), "rd_d", 32),
    ]
    inputs = [
        ((2800,1900), "mul_wd2", 32), ((2800,1940), "mul_wa2", 4),
        ((2800,1980), "mul_we2", 1),
    ]
    for loc, lab, w in outputs:
        text = add_pin(text, c, loc, lab, w, True)
        text = add_tunnel(text, c, loc, lab.upper(), w)
    for loc, lab, w in inputs:
        text = add_pin(text, c, loc, lab, w, False)
        text = add_tunnel(text, c, loc, lab.upper(), w)

    # Decoder instance; connect only with tunnels.
    dec_loc = (4100, 2300)
    text = edit.add_component(text, c, None, "multiply_decode", dec_loc, {})
    for name, pt in sub_ports(design, "multiply_decode", dec_loc).items():
        mapping = {"instr_27_4":"ID_I27_4", "opcode":"ID_OPCODE",
                   "mul_any":"MUL_ANY", "mul_short":"MUL_SHORT",
                   "mul_long":"MUL_LONG", "mul_acc":"MUL_ACC",
                   "mul_signed":"MUL_SIGNED"}
        text = add_tunnel(text, c, pt, mapping[name],
                          24 if name == "instr_27_4" else (4 if name == "opcode" else 1))
    text = add_tunnel(text, c, (1780,590), "ID_I27_4", 24)
    text = add_tunnel(text, c, (1780,1040), "ID_OPCODE", 4)

    # Two extra combinational read ports from the sixteen exposed register outputs.
    regouts = {0:(3180,890), 1:(3180,910), 2:(3180,950), 3:(3180,930),
               4:(3180,990), 5:(3180,970), 6:(3180,1050), 7:(3180,1030),
               8:(3180,1090), 9:(3180,1110), 10:(3180,1150), 11:(3180,1130),
               12:(3180,1190), 13:(3180,1170), 14:(3180,1230), 15:(3180,1210)}
    for k, pt in regouts.items():
        text = add_tunnel(text, c, pt, "RVAL%d" % k, 32)
    for loc, selnet, outnet in (((3700,2700), "RS_IDX", "RD_C"),
                                ((4300,2700), "RD_IDX", "RD_D")):
        text, p = add_mux(text, c, design, loc, 32, select=4, inputs=16,
                          label=outnet + "_MUX")
        for k in range(16):
            text = add_tunnel(text, c, p["in%d" % k], "RVAL%d" % k, 32)
        text = add_tunnel(text, c, p["sel"], selnet, 4)
        text = add_tunnel(text, c, p["out"], outnet, 32)
    text = add_tunnel(text, c, (1780,740), "RS_IDX", 4)
    text = add_tunnel(text, c, (1780,930), "RD_IDX", 4)

    # Short multiply destination is instr[19:16] (rn); long already uses normal Rd.
    text = edit.remove_wire(text, c, (2610,910,2960,910))
    text = edit.remove_wire(text, c, (2610,1090,2620,1090))
    text = add_tunnel(text, c, (2610,910), "WA_OLD", 4)
    text, p = add_mux(text, c, design, (3300,2300), 4, label="WA_MUL_SHORT")
    text = add_tunnel(text, c, p["in0"], "WA_OLD", 4)
    text = add_tunnel(text, c, p["in1"], "RN_IDX", 4)
    text = add_tunnel(text, c, p["sel"], "MUL_SHORT")
    text = add_tunnel(text, c, p["out"], "WA_FINAL", 4)
    text = add_tunnel(text, c, (1780,970), "RN_IDX", 4)
    text = add_tunnel(text, c, (2960,910), "WA_FINAL", 4)
    text = add_tunnel(text, c, (2620,1090), "WA_FINAL", 4)

    # Arbitrate long multiply onto the existing second write port.
    for seg in ((2820,990,2960,990), (2820,1050,2960,1050),
                (2850,1070,2960,1070)):
        text = edit.remove_wire(text, c, seg)
    text = add_tunnel(text, c, (2820,990), "MEM_WD2", 32)
    text = add_tunnel(text, c, (2820,1050), "MEM_WE2")
    text = add_tunnel(text, c, (2850,1070), "MEM_WA2", 4)
    for loc, width, old, new, final in (((3400,3000),32,"MEM_WD2","MUL_WD2","WD2_FINAL"),
                                        ((3400,3100),4,"MEM_WA2","MUL_WA2","WA2_FINAL")):
        text, p = add_mux(text, c, design, loc, width, label=final)
        text = add_tunnel(text, c, p["in0"], old, width)
        text = add_tunnel(text, c, p["in1"], new, width)
        text = add_tunnel(text, c, p["sel"], "MUL_WE2")
        text = add_tunnel(text, c, p["out"], final, width)
    text = edit.add_component(text, c, "1", "OR Gate", (3400,3200), {"label":"WE2_FINAL"})
    gp = component_ports(design, "OR Gate", "1", (3400,3200), {"label":"WE2_FINAL"})
    text = add_tunnel(text, c, gp["in0"], "MEM_WE2")
    text = add_tunnel(text, c, gp["in1"], "MUL_WE2")
    text = add_tunnel(text, c, gp["out"], "WE2_FINAL")
    text = add_tunnel(text, c, (2960,990), "WD2_FINAL", 32)
    text = add_tunnel(text, c, (2960,1050), "WE2_FINAL")
    text = add_tunnel(text, c, (2960,1070), "WA2_FINAL", 4)
    return text


def patch_ex(text, design):
    c = "stage_EX"
    newins = [((700,2450),"rd_c",32), ((700,2490),"rd_d",32),
              ((700,2530),"mul_any",1), ((700,2570),"mul_short",1),
              ((700,2610),"mul_long",1), ((700,2650),"mul_acc",1),
              ((700,2690),"mul_signed",1)]
    for loc, lab, w in newins:
        text = add_pin(text,c,loc,lab,w,False)
        text = add_tunnel(text,c,loc,lab.upper(),w)
    text = add_pin(text,c,(3600,2450),"mul_hi",32,True)
    text = add_tunnel(text,c,(3600,2450),"MUL_HI",32)

    exloc=(2100,3000)
    text=edit.add_component(text,c,None,"multiply_execute",exloc,{})
    mp={"rm":"EX_RD_B","rs":"RD_C","acc_lo":"RD_D","acc_hi":"EX_RD_A",
        "acc":"MUL_ACC","signed":"MUL_SIGNED","lo":"MUL_LO","hi":"MUL_HI"}
    widths={"rm":32,"rs":32,"acc_lo":32,"acc_hi":32,"acc":1,"signed":1,"lo":32,"hi":32}
    for name,pt in sub_ports(design,"multiply_execute",exloc).items():
        text=add_tunnel(text,c,pt,mp[name],widths[name])
    text=add_tunnel(text,c,(700,550),"EX_RD_A",32)
    text=add_tunnel(text,c,(700,600),"EX_RD_B",32)

    # Override ALU result and write-enable for every recognized multiply.
    text=edit.remove_wire(text,c,(2050,690,2120,690))
    text=edit.remove_wire(text,c,(2050,790,2120,790))
    text=add_tunnel(text,c,(2050,690),"ALU_RESULT_OLD",32)
    text=add_tunnel(text,c,(2050,790),"ALU_WE_OLD")
    text,p=add_mux(text,c,design,(3000,2850),32,label="MUL_RESULT_SELECT")
    text=add_tunnel(text,c,p["in0"],"ALU_RESULT_OLD",32)
    text=add_tunnel(text,c,p["in1"],"MUL_LO",32)
    text=add_tunnel(text,c,p["sel"],"MUL_ANY")
    text=add_tunnel(text,c,p["out"],"EX_RESULT",32)
    text=add_tunnel(text,c,(2120,690),"EX_RESULT",32)
    text,p=add_mux(text,c,design,(3000,2950),1,label="MUL_WE_SELECT")
    text=add_tunnel(text,c,p["in0"],"ALU_WE_OLD")
    text=edit.add_component(text,c,"0","Constant",(p["in1"]),{"value":"0x1"})
    text=add_tunnel(text,c,p["sel"],"MUL_ANY")
    text=add_tunnel(text,c,p["out"],"EX_WE")
    text=add_tunnel(text,c,(2120,790),"EX_WE")

    # Multiply flags: short N/Z from low; long N from high and Z from both halves.
    for loc, sig, prefix in (((2500,3300),"MUL_LO","LO"),((2500,3450),"MUL_HI","HI")):
        attrs={"incoming":"32","fanout":"2","appear":"right","spacing":"4"}
        for bit in range(32): attrs["bit%d"%bit]="0" if bit<31 else "1"
        sp=model.Component("Splitter","0",loc,attrs)
        text=edit.add_component(text,c,"0","Splitter",loc,attrs)
        ps={x.name:x.at(sp) for x in geometry.ports(design,sp)}
        text=add_tunnel(text,c,ps["combined"],sig,32)
        text=add_tunnel(text,c,ps["bit1"],prefix+"_N")
        cp=(loc[0]+300,loc[1])
        text=edit.add_component(text,c,"5","Comparator",cp,{"width":"32"})
        text=add_tunnel(text,c,(cp[0]-40,cp[1]-10),sig,32)
        text=edit.add_component(text,c,"0","Constant",(cp[0]-40,cp[1]+10),{"width":"32","value":"0x0"})
        text=add_tunnel(text,c,cp,prefix+"_Z")
    text=edit.add_component(text,c,"1","AND Gate",(3000,3500),{"label":"LONG_Z"})
    gp=component_ports(design,"AND Gate","1",(3000,3500),{"label":"LONG_Z"})
    text=add_tunnel(text,c,gp["in0"],"LO_Z"); text=add_tunnel(text,c,gp["in1"],"HI_Z")
    text=add_tunnel(text,c,gp["out"],"LONG_Z")
    for loc,a,b,out in (((3200,3300),"LO_N","HI_N","MUL_N"),
                        ((3200,3450),"LO_Z","LONG_Z","MUL_Z")):
        text,p=add_mux(text,c,design,loc,1,label=out)
        text=add_tunnel(text,c,p["in0"],a); text=add_tunnel(text,c,p["in1"],b)
        text=add_tunnel(text,c,p["sel"],"MUL_LONG"); text=add_tunnel(text,c,p["out"],out)

    # Preserve current C/V while replacing only N/Z.
    text=add_tunnel(text,c,(2810,830),"OLD_C")
    text=add_tunnel(text,c,(2810,850),"OLD_V")
    attrs={"incoming":"4","fanout":"4","appear":"right","spacing":"4"}
    sp=model.Component("Splitter","0",(3500,3400),attrs)
    text=edit.add_component(text,c,"0","Splitter",sp.loc,attrs)
    ps={x.name:x.at(sp) for x in geometry.ports(design,sp)}
    text=add_tunnel(text,c,ps["bit3"],"MUL_N")
    text=add_tunnel(text,c,ps["bit2"],"MUL_Z")
    text=add_tunnel(text,c,ps["bit1"],"OLD_C")
    text=add_tunnel(text,c,ps["bit0"],"OLD_V")
    text=add_tunnel(text,c,ps["combined"],"MUL_FLAGS",4)
    text=edit.remove_wire(text,c,(2430,780,2620,780))
    text=add_tunnel(text,c,(2430,780),"ALU_FLAGS",4)
    text,p=add_mux(text,c,design,(3800,3400),4,label="FLAGS_SELECT")
    text=add_tunnel(text,c,p["in0"],"ALU_FLAGS",4)
    text=add_tunnel(text,c,p["in1"],"MUL_FLAGS",4)
    text=add_tunnel(text,c,p["sel"],"MUL_ANY")
    text=add_tunnel(text,c,p["out"],"FLAGS_FINAL",4)
    text=add_tunnel(text,c,(2620,780),"FLAGS_FINAL",4)
    return text


def patch_wb(text, design):
    c="stage_WB"
    for loc,lab,w in [((760,2150),"mul_long",1),((760,2190),"mul_hi",32),
                      ((760,2230),"mul_rdhi",4)]:
        text=add_pin(text,c,loc,lab,w,False); text=add_tunnel(text,c,loc,lab.upper(),w)
    for loc,lab,w in [((2500,2150),"mul_wd2",32),((2500,2190),"mul_wa2",4),
                      ((2500,2230),"mul_we2",1)]:
        text=add_pin(text,c,loc,lab,w,True); text=add_tunnel(text,c,loc,lab.upper(),w)
    text=edit.add_component(text,c,"1","AND Gate",(1800,2200),{"label":"MUL_WE2"})
    gp=component_ports(design,"AND Gate","1",(1800,2200),{"label":"MUL_WE2"})
    text=add_tunnel(text,c,gp["in0"],"MUL_LONG")
    text=add_tunnel(text,c,gp["in1"],"CONDPASS_WB")
    text=add_tunnel(text,c,gp["out"],"MUL_WE2")
    text=add_tunnel(text,c,(760,750),"CONDPASS_WB")
    # wd2/wa2 are direct; enable is condition-gated.
    text=add_tunnel(text,c,(760,2190),"MUL_WD2",32)
    text=add_tunnel(text,c,(760,2230),"MUL_WA2",4)
    return text


def patch_main(text):
    # Reload after all interface edits so positional instance ports are exact.
    PATH.write_text(text)
    d=model.load(PATH)
    locs={"stage_IF":(1200,1000),"stage_ID":(2600,1000),"stage_EX":(4000,1000),
          "stage_MEM":(5400,1000),"stage_WB":(6800,1000)}
    nets={
        ("stage_ID","mul_any"):("MUL_ANY",1), ("stage_ID","mul_short"):("MUL_SHORT",1),
        ("stage_ID","mul_long"):("MUL_LONG",1), ("stage_ID","mul_acc"):("MUL_ACC",1),
        ("stage_ID","mul_signed"):("MUL_SIGNED",1), ("stage_ID","rd_c"):("RD_C",32),
        ("stage_ID","rd_d"):("RD_D",32), ("stage_ID","mul_wd2"):("MUL_WD2",32),
        ("stage_ID","mul_wa2"):("MUL_WA2",4), ("stage_ID","mul_we2"):("MUL_WE2",1),
        ("stage_EX","rd_c"):("RD_C",32), ("stage_EX","rd_d"):("RD_D",32),
        ("stage_EX","mul_any"):("MUL_ANY",1), ("stage_EX","mul_short"):("MUL_SHORT",1),
        ("stage_EX","mul_long"):("MUL_LONG",1), ("stage_EX","mul_acc"):("MUL_ACC",1),
        ("stage_EX","mul_signed"):("MUL_SIGNED",1), ("stage_EX","mul_hi"):("MUL_HI",32),
        ("stage_WB","mul_long"):("MUL_LONG",1), ("stage_WB","mul_hi"):("MUL_HI",32),
        ("stage_WB","mul_rdhi"):("RN",4), ("stage_WB","mul_wd2"):("MUL_WD2",32),
        ("stage_WB","mul_wa2"):("MUL_WA2",4), ("stage_WB","mul_we2"):("MUL_WE2",1),
    }
    for stage,loc in locs.items():
        pp=sub_ports(d,stage,loc)
        for (want_stage,port),(lab,w) in nets.items():
            if stage==want_stage:
                text=add_tunnel(text,"main",pp[port],lab,w)
    return text


def main():
    text=PATH.read_text()
    if 'label" val="mul_any"' in text[text.index('<circuit name="stage_ID"'):text.index('\n  </circuit>',text.index('<circuit name="stage_ID"'))]:
        raise SystemExit("multiply integration already present")
    d=model.load(PATH)
    text=patch_id(text,d)
    PATH.write_text(text); d=model.load(PATH)
    text=patch_ex(text,d)
    PATH.write_text(text); d=model.load(PATH)
    text=patch_wb(text,d)
    text=patch_main(text)
    PATH.write_text(text)
    print("wired multiply family into",PATH)


if __name__=="__main__":
    main()
