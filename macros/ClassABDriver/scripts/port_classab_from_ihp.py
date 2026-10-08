#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""
One-time port of the IHP sg13cmos5l class-AB pad driver sheets (hand-edited xschem drawings in
sg13cmos5l_..._sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem)
to GF180MCU (gf180mcuD, 03v3 devices).

Every wire and instance position of the IHP drawings is kept. The GF180 FET symbols have the
sg13_hv pin geometry (D/S at (20,-+30), G at (-20,0), B at (20,0)); rhigh becomes ppolyf_u_3k
(same P/M pins, plus a bulk pin B at (-20,0), which gets a label with the old body= net).
Sizes are NOT copied: they come from the GF180 sizing netlists (gf180_sizing.spice next to this
script), re-derived on 2026-10-08 by simulation (see the macro READMEs).

After this script has run once, the .sch/.sym files are the source of truth.

Usage: port_classab_from_ihp.py <ihp_xschem_dir> <repo_macros_dir>
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
HDR = "v {xschem version=3.4.8RC file_version=1.3}\n"

# ---------------------------------------------------------------- sizes from the GF180 netlist
def size_tables(path):
    tab, cur = {}, None
    for l in open(path):
        t = l.split()
        if not t: continue
        if t[0].lower() == '.subckt': cur = t[1]; tab[cur] = {}; continue
        if t[0].lower() == '.ends': cur = None; continue
        mods = [x for x in t if x in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k')]
        if cur and t[0][0] in 'Xx' and mods:
            kv = dict(re.findall(r'(\w+)=(\S+)', l))
            kv = {k: (v.replace('{rl}', '50u')) for k, v in kv.items()}
            tab[cur][t[0][1:]] = dict(model=mods[0], **kv)
    return tab

def fet_props(name, d):
    return (f"name={name}\nL={d['L']}\nW={d['W']}\nnf={d.get('nf', 1)}\nm={d.get('m', 1)}\n"
            "ad=\"'int((nf+1)/2) * W/nf * 0.18u'\"\n"
            "pd=\"'2*int((nf+1)/2) * (W/nf + 0.18u)'\"\n"
            "as=\"'int((nf+2)/2) * W/nf * 0.18u'\"\n"
            "ps=\"'2*int((nf+2)/2) * (W/nf + 0.18u)'\"\n"
            "nrd=\"'0.18u / W'\" nrs=\"'0.18u / W'\"\n"
            f"sa=0 sb=0 sd=0\nmodel={d['model']}\nspiceprefix=X\n")

def res_props(name, d):
    return f"name={name}\nW={d['r_width']}\nL={d['r_length']}\nmodel={d['model']}\nspiceprefix=X\nm=1\n"

# ---------------------------------------------------------------- xschem record handling
def split_records(text):
    recs, cur, depth, i = [], "", 0, 0
    while i < len(text):
        c = text[i]
        if c == "\\" and i + 1 < len(text):
            cur += text[i:i + 2]; i += 2; continue
        cur += c
        if c == "{": depth += 1
        elif c == "}": depth -= 1
        elif c == "\n" and depth == 0:
            if cur.strip(): recs.append(cur)
            cur = ""
        i += 1
    if cur.strip(): recs.append(cur)
    return recs

def xform(dx, dy, rot, flip):
    if flip: dx = -dx
    for _ in range(rot % 4): dx, dy = -dy, dx
    return dx, dy

CODE_SUBS = [
    (".lib cornerMOShv.lib mos_tt\n.lib cornerRES.lib res_typ\n.lib cornerCAP.lib cap_typ\n", ""),
    ("@n.xd.xop.nsg13_hv_pmos[ids]", "@m.xd.xop.m0[id]"),
    ("@n.xd.xon.nsg13_hv_nmos[ids]", "@m.xd.xon.m0[id]"),
]
MODELS_BLOCK = ('C {devices/code_shown.sym} %d %d 0 0 {name=MODELS\nonly_toplevel=true\nformat="tcleval( @value )"\n'
                'value="\n.include $::180MCU_MODELS/design.ngspice\n.lib $::180MCU_MODELS/sm141064.ngspice typical\n'
                '.lib $::180MCU_MODELS/sm141064.ngspice res_typical\n.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical\n"}\n')

def code_rewrite(rec):
    for a, b in CODE_SUBS: rec = rec.replace(a, b)
    rec = re.sub(r"@n\.(\S+?)\.nsg13_hv_[np]mos\[ids\]", r"@m.\1.m0[id]", rec)
    rec = re.sub(r"@n\.(\S+?)\.nsg13_hv_[np]mos\[vds\]", r"@m.\1.m0[vds]", rec)
    rec = re.sub(r"@n\.(\S+?)\.nsg13_hv_[np]mos\[vdss\]", r"@m.\1.m0[vdsat]", rec)
    return rec

def port_sch(src, dst, sizes, sym_ren, text_subs, note, extra=""):
    out, models_at = [], None
    for r in split_records(open(src).read()):
        if r.startswith("v {"):
            out.append(HDR); continue
        m = re.match(r"^C \{([^}]*)\} (\S+) (\S+) (\S+) (\S+) \{(.*)\}\s*$", r, re.S)
        if m:
            sym, x, y, rot, flip, props = m.groups()
            base = os.path.basename(sym)
            name = re.search(r"name=([^\s}]+)", props).group(1)
            if base in ("sg13_hv_nmos.sym", "sg13_hv_pmos.sym"):
                d = sizes[name]
                out.append(f"C {{symbols/{d['model']}.sym}} {x} {y} {rot} {flip} {{{fet_props(name, d)}}}\n"); continue
            if base == "rhigh.sym":
                d = sizes[name]
                body = re.search(r"body=(\S+)", props).group(1)
                out.append(f"C {{symbols/{d['model']}.sym}} {x} {y} {rot} {flip} {{{res_props(name, d)}}}\n")
                bx, by = xform(-20, 0, int(rot), int(flip))
                out.append(f"C {{devices/lab_pin.sym}} {int(x)+bx} {int(y)+by} 0 0 {{name=lb_{name} sig_type=std_logic lab={body}}}\n")
                continue
            if base in sym_ren:
                out.append(f"C {{{sym_ren[base]}}} {x} {y} {rot} {flip} {{{props}}}\n"); continue
            if base == "title.sym":
                out.append(f"C {{devices/title.sym}} {x} {y} {rot} {flip} {{name=l1 author=\"Christoph Maier\"}}\n"); continue
            if base == "code_shown.sym":
                models_at = (int(float(x)), int(float(y)))
                out.append(code_rewrite(r if r.endswith("\n") else r + "\n")); continue
        if r.startswith("T {"):
            for a, b in text_subs: r = r.replace(a, b)
        out.append(r if r.endswith("\n") else r + "\n")
    if models_at:
        out.append(MODELS_BLOCK % (models_at[0] + 1100, models_at[1]))
    ys = [float(v) for v in re.findall(r"^N \S+ (\S+) \S+ (\S+)", "".join(out), re.M) for v in v] or [0]
    ys += [float(m.group(1)) for m in re.finditer(r"^[CT] \{.*?\} \S+ (\S+) ", "".join(out), re.M)]
    out.append(note.replace(" 60 -1420 ", f" 60 {int(min(ys)) - 120} ") + "\n")
    out.append(extra)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    open(dst, "w").write("".join(out))
    print("wrote", dst)

def port_sym(src, dst, text_subs, extra=""):
    t = open(src).read()
    t = re.sub(r"^v \{[^}]*\}\n", HDR, t)
    for a, b in text_subs: t = t.replace(a, b)
    t = t + extra
    open(dst, "w").write(t)
    print("wrote", dst)

# ---------------------------------------------------------------- the cells
NAMES = [("d2s_mpdda_biased", "ClassABDriverBiased"), ("d2s_mpdda", "ClassABDriver"), ("unit_r2", "ClassABUnitR"),
         ("d2s_bias_lp", "ClassABBiasIdeal"), ("d2s_bias_in", "ClassABBiasIn"), ("d2s_bias_out", "ClassABBiasOut")]
TEXT = [
    ("rhigh body = vss", "ppolyf_u_3k bulk = vss"), ("rhigh", "ppolyf_u_3k"),
    ("hv PMOS in accumulation", "pfet_03v3 in accumulation"),
    ("BP 5u/6u", "BP 20u/6u"), ("Ta, Tb (5u/6u", "Ta, Tb (20u/6u"),
    ("RP1 (2 x ABP)", "RP1 (12u/0.6u)"), ("RN1 (2 x ABN)", "RN1 (8u/1u)"),
    ("stacked on a 2x diode", "stacked on RP1 12u/0.6u, RN1 8u/1u"),
    ("rl = 50.6u (in unit_r2.sch)", "R = ppolyf_u_3k 1u x 50u (in ClassABUnitR.sch)"),
    ("frozen .subckt defaults: lcas = 3", "fixed sizes: lcas = 3"),
    ("the DDA units at transistor level: d2s_mpdda_flat.sch; with the bias network: d2s_mpdda_bias_flat.sch; block descriptions: README.md",
     "block descriptions: ../../README.md (IHP original: d2s_mpdda.sch in the IHP notes worktree)"),
    ("DUT and bias from the schematics in this directory", "DUT and bias from ../../schematic/xschem and ../../../ClassABBias/schematic/xschem"),
]
SYMREN = {f"{a}.sym": f"{b}.sym" for a, b in NAMES}

def note(cell, ihp):
    return (f"T {{GF180MCU (gf180mcuD) 03v3 port of the IHP sheet {ihp}.sch, 2026-10-08. Wires and placement unchanged;\n"
            f"devices pfet_03v3 / nfet_03v3 / ppolyf_u_3k, sizes re-derived for GF180 (README.md).}} 60 -1420 0 0 0.3 0.3 {{layer=4}}")

def main(ihp, macros):
    tab = size_tables(os.path.join(HERE, "gf180_sizing.spice"))
    flat = lambda *cells: {k: v for c in cells for k, v in tab[c].items()}
    bias_x = os.path.join(macros, "ClassABBias", "schematic", "xschem")
    drv_x = os.path.join(macros, "ClassABDriver", "schematic", "xschem")
    drv_tb = os.path.join(macros, "ClassABDriver", "testbenches", "xschem")
    jobs = [
        ("d2s_bias_lp", bias_x, "ClassABBiasIdeal", flat("d2s_bias_lp")),
        ("d2s_bias_in", bias_x, "ClassABBiasIn", flat("d2s_bias_in", "d2s_bias_diodes")),
        ("d2s_bias_out", bias_x, "ClassABBiasOut", flat("d2s_bias_out", "d2s_bias_diodes")),
        ("unit_r2", drv_x, "ClassABUnitR", flat("unit_r2")),
        ("d2s_mpdda", drv_x, "ClassABDriver", flat("d2s_mpdda")),
        ("d2s_mpdda_biased", drv_x, "ClassABDriverBiased", {}),
    ]
    for ihpname, d, cell, sizes in jobs:
        extra = ""
        if cell == "ClassABDriver":
            # a and b (gates of OP / ON) become ports for the enable sub-macro (PadEnable/DriverEnable)
            extra = ("C {devices/iopin.sym} 2440 -800 0 0 {name=p16 lab=a}\n"
                     "C {devices/iopin.sym} 2440 -400 0 0 {name=p17 lab=b}\n"
                     "T {a, b: gates of OP / ON,\nports for the enable\nswitches (PadEnable)} 2300 -900 0 0 0.25 0.25 {layer=10}\n")
        port_sch(os.path.join(ihp, ihpname + ".sch"), os.path.join(d, cell + ".sch"), sizes, SYMREN, TEXT, note(cell, ihpname), extra)
        sx = ""
        if cell == "ClassABDriver":
            sx = ("L 4 200 -100 220 -100 {}\nT {a} 186 -107 0 1 0.2 0.2 {}\nB 5 217.5 -102.5 222.5 -97.5 {name=a dir=inout}\n"
                  "L 4 200 -20 220 -20 {}\nT {b} 186 -27 0 1 0.2 0.2 {}\nB 5 217.5 -22.5 222.5 -17.5 {name=b dir=inout}\n")
        port_sym(os.path.join(ihp, ihpname + ".sym"), os.path.join(d, cell + ".sym"), NAMES, sx)
    for tb in ["dc", "loop", "step", "thd", "noise", "op"]:
        port_sch(os.path.join(ihp, f"tb_mpdda_{tb}.sch"), os.path.join(drv_tb, f"ClassABDriver_tb_{tb}.sch"), {}, SYMREN,
                 TEXT + [(f"tb_mpdda_{tb}", f"ClassABDriver_tb_{tb}")], note(tb, f"tb_mpdda_{tb}"))

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
