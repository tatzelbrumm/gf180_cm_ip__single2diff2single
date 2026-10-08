#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes ClassABBiasBG (GF180MCU gf180mcuD, 03v3): the self-contained current-mode bandgap reference of the
class-AB pad driver, re-designed for GF180 on 2026-10-09 from the IHP bg_core (sg13cmos5l notes worktree,
design_considerations/class_ab_pad_driver/improvements/sim/d2s_bias_ref.spice). Sizes are the ones of
bg_reference.spice next to this script (sizing: notes worktree, kickoffs/2026-10-08_reference_redesign/tools/,
log 2026-10-08_fable_reference_redesign_log.md). Written once; afterwards the .sch/.sym are the source of truth.

Columns, as on the IHP sheet: [S] start-up and the enable sub-cell on the left, then the current branches rail to
rail (PMOS mirror + cascode on vdd at the top, NMOS pair / resistors / PNPs on vss at the bottom): the input branch
PB-PBC-NB-R1B-R0-Q2, the diode branch PA-PAC-NA-R1A-Q1, the output branch PO-POC -> iout. RC between the gate
lines vpg and vpc.
Usage: gen_bg.py <ClassABBias/schematic/xschem> [dn]   ('dn' writes the deep-n-well variant ClassABBiasBGdn)"""
import os, re, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "scripts"))
from xsheet import Sheet, symbol, fet_props
HERE = os.path.dirname(os.path.abspath(__file__))

def sizes(cell):
    """device -> (model, {k: v}) from bg_reference.spice"""
    tab, cur = {}, None
    for l in open(os.path.join(HERE, "bg_reference.spice")):
        t = l.split()
        if not t: continue
        if t[0].lower() == '.subckt': cur = t[1]; continue
        if t[0].lower() == '.ends': cur = None; continue
        if cur == cell and t[0][0] in 'XxDd':
            kv = dict(re.findall(r"(\w+)=(\S+)", l))
            pos = [x for x in t[1:] if '=' not in x]
            tab[t[0][1:] if t[0][0] in 'Xx' else t[0]] = (pos[-1], kv)
    return tab

class BgSheet(Sheet):
    def res(self, name, model, x, y, p, m, b, W, L):
        """ppolyf resistor, vertical: P at (0,-30) top, M at (0,30) bottom, B at (-20,0)."""
        self.recs.append(f"C {{symbols/{model}.sym}} {x} {y} 0 0 {{name={name}\nW={W}\nL={L}\nmodel={model}\nspiceprefix=X\nm=1\n}}")
        self.wire(x, y - 30, x, y - 50, p); self.label(x, y - 50, p, right=True)
        self.wire(x, y + 30, x, y + 50, m); self.label(x, y + 50, m, right=True)
        self.wire(x - 20, y, x - 60, y, b); self.label(x - 60, y, b)
    def pnp(self, name, model, x, y, e, b, c, m=1):
        """vertical PNP: E at (20,-30) top, B at (-20,0), C at (20,30) bottom."""
        self.recs.append(f"C {{symbols/{model}.sym}} {x} {y} 0 0 {{name={name}\nmodel={model}\nspiceprefix=X\nm={m}\n}}")
        self.wire(x + 20, y - 30, x + 20, y - 50, e); self.label(x + 20, y - 50, e, right=True)
        self.wire(x + 20, y + 30, x + 20, y + 50, c); self.label(x + 20, y + 50, c, right=True)
        self.wire(x - 20, y, x - 60, y, b); self.label(x - 60, y, b)
    def diode(self, name, model, x, y, p, m, W, L):
        self.recs.append(f"C {{symbols/{model}.sym}} {x} {y} 0 0 {{name={name}\nmodel={model}\nr_w={W}\nr_l={L}\nm=1\n}}")
        self.wire(x, y - 30, x, y - 50, p); self.label(x, y - 50, p, right=True)
        self.wire(x, y + 30, x, y + 50, m); self.label(x, y + 50, m, right=True)

def core(d, dn=False):
    cell = "ClassABBiasBGdn" if dn else "ClassABBiasBG"
    S = sizes(cell)
    def F(n): m, kv = S[n]; return dict(W=kv["W"], L=kv["L"], nf=int(kv.get("nf", 1)), m=int(kv.get("m", 1)))
    def R(n): m, kv = S[n]; return m, kv["r_width"], kv["r_length"]
    order = ["vdd", "vss", "iout", "en", "en_b"]
    pins = symbol(f"{d}/{cell}.sym", left=[("en", "in"), ("en_b", "in")], right=[("iout", "inout")],
                  top=[("vdd", "inout")], bottom=[("vss", "inout")], order=order,
                  text="bandgap 5 uA out" + (", NMOS pair in deep n-well" if dn else ""))
    s = BgSheet()
    s.text(cell, 60, -1180, 0.5)
    notes = ["Self-contained current-mode (Banba) bandgap reference, 5 uA out of iout into the ClassABBiasIn tree. GF180 re-design (2026-10-09) of the IHP bg_core:",
             "[C] input branch PB / PBC -> NB (gate line g) -> eb: R1B to vss and R0 + Q2 (8 x pnp_05p00x05p00); diode branch PA / PAC -> NA (diode, g) -> ea: R1A and Q1.",
             "    NA / NB force ea = eb, the mirror equal currents, so each branch carries V_BE1 / R1 + U_T ln 8 / R0 (32 % PTAT with ppolyf_u_3k's -0.15 %/K); PO / POC = 2 x -> 5 uA.",
             "    Wide-swing cascode: the input branch's diode connection closes around PBC (vpg = its drain); the cascode gate line vpc = vpg - I RC (RC 150k), NB's drain on vpc.",
             "    R1A is 10 % longer than R1B: with both PNPs off the loop gain is > 1, so the core cannot rest in the resistor-only state.",
             "[S] start-up: MS1 weak pull-up (gate en_b) on ks, MS3 pulls vpg down while ks is high, MS2 releases ks once g is up. [E] RefCoreEnable: vpg -> vdd, ks -> vss while en = 0.",
             ("NA / NB each in an isolated p-well (bulk = source) inside one deep n-well on vdd; DPWA / DPWB / DDNW are the well junctions (estimated areas; LVS needs a well_diode_mk marker or lvs_ignore)."
              if dn else "NA / NB bulks on vss (common substrate). The deep-n-well variant is ClassABBiasBGdn.")]
    for i, l in enumerate(notes):
        s.text(l, 60, -1130 + 22 * i, 0.25)
    s.text("GF180MCU (gf180mcuD), 03v3 devices, sizes from scripts/bg_reference.spice; written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.", 60, 140, 0.2, 4)
    top, bot = -900, 0
    s.wire(60, top, 1200, top, "vdd"); s.wire(60, bot, 1200, bot, "vss")
    s.pin("iopin", 60, top, "vdd", right=True); s.pin("iopin", 60, bot, "vss", right=True)
    s.pin("ipin", 60, -500, "en"); s.pin("ipin", 60, -460, "en_b")
    s.pin("iopin", 1280, -300, "iout")
    # [E] enable sub-cell
    epins = [("vdd", 0, -80), ("vss", 0, 80), ("en", -120, -20), ("en_b", -120, 20), ("vpg", 120, -20), ("ks", 120, 20)]
    s.block("RefCoreEnable.sym", "XE", 240, -480, epins, dict(vdd="vdd", vss="vss", en="en", en_b="en_b", vpg="vpg", ks="ks"))
    s.text("[E]", 160, -600, 0.3, 10); s.text("[S]", 160, -860, 0.3, 10); s.text("[C]", 520, -860, 0.3, 10)
    # [S] start-up
    s.fet("p", "MS1", 200, -800, "ks", "en_b", "vdd", "vdd", top_rail=top, **F("MS1"))
    s.fet("n", "MS3", 200, -680, "vpg", "ks", "vss", "vss", **F("MS3"))
    s.fet("n", "MS2", 200, -100, "ks", "g", "vss", "vss", bot_rail=bot, **F("MS2"))
    # [C] input branch
    xb = 560
    s.fet("p", "PB", xb, -800, "cb", "vpg", "vdd", "vdd", top_rail=top, **F("PB"))
    s.fet("p", "PBC", xb, -680, "vpg", "vpc", "cb", "vdd", **F("PBC"))
    bn = "eb" if dn else "vss"
    s.fet("n", "NB", xb, -480, "vpc", "g", "eb", bn, **F("NB"))
    m, w, l = R("R1B"); s.res("R1B", m, xb - 60, -300, "eb", "vss", "vss", w, l)
    m, w, l = R("R0"); s.res("R0", m, xb + 120, -300, "eb", "e2", "vss", w, l)
    m, kv = S["Q2"]; s.pnp("Q2", m, xb + 60, -100, "e2", "vss", "vss", int(kv.get("m", 1)))
    s.text("Q2 = 8 x Q1 (m=8)", xb + 100, -40, 0.2)
    # RC between the gate lines
    m, w, l = R("RC"); s.res("RC", m, xb + 200, -740, "vpg", "vpc", "vss", w, l)
    # [C] diode branch
    xa = 900
    s.fet("p", "PA", xa, -800, "ca", "vpg", "vdd", "vdd", top_rail=top, **F("PA"))
    s.fet("p", "PAC", xa, -680, "g", "vpc", "ca", "vdd", **F("PAC"))
    an = "ea" if dn else "vss"
    s.fet("n", "NA", xa, -480, "g", "g", "ea", an, **F("NA"))
    m, w, l = R("R1A"); s.res("R1A", m, xa - 60, -300, "ea", "vss", "vss", w, l)
    m, kv = S["Q1"]; s.pnp("Q1", m, xa + 60, -100, "ea", "vss", "vss", int(kv.get("m", 1)))
    # [C] output branch
    xo = 1140
    s.fet("p", "PO", xo, -800, "co", "vpg", "vdd", "vdd", top_rail=top, **F("PO"))
    s.fet("p", "POC", xo, -680, "iout", "vpc", "co", "vdd", **F("POC"))
    if dn:
        s.text("[W] well junctions", 1100, -520, 0.3, 10)
        s.text("(deep n-well on vdd)", 1100, -500, 0.2)
        m, kv = S["DPWA"]; s.diode("DPWA", m, 1140, -420, "ea", "vdd", kv["r_w"], kv["r_l"])
        m, kv = S["DPWB"]; s.diode("DPWB", m, 1240, -420, "eb", "vdd", kv["r_w"], kv["r_l"])
        m, kv = S["DDNW"]; s.diode("DDNW", m, 1140, -260, "vss", "vdd", kv["r_w"], kv["r_l"])
    s.write(f"{d}/{cell}.sch", title=True)
    return pins

def tree(d, core_cell="ClassABBiasBG"):
    """Fixture: the reference feeding the ClassABBiasIn tree (iout -> iref directly, no BiasRefEnable), for CACE."""
    cell = core_cell + "Tree"
    lines = ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]
    order = ["vdd", "vss", "vddo", "vsso", "en", "en_b"] + lines
    pins = symbol(f"{d}/{cell}.sym", left=[("en", "in"), ("en_b", "in")], right=[(l, "output") for l in lines],
                  top=[("vdd", "inout"), ("vddo", "inout")], bottom=[("vss", "inout"), ("vsso", "inout")], order=order,
                  text="CACE fixture: reference + tree")
    s = BgSheet()
    s.text(cell, 60, -700, 0.5)
    s.text(f"CACE fixture: {core_cell} feeding the ClassABBiasIn tree (iout -> iref directly; in the pad BiasRefEnable sits in between). Ports as ClassABBiasIn plus en / en_b.", 60, -650, 0.25)
    s.text("GF180MCU (gf180mcuD); written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.", 60, 140, 0.2, 4)
    for i, (k, n) in enumerate([("iopin", "vdd"), ("iopin", "vss"), ("iopin", "vddo"), ("iopin", "vsso"), ("ipin", "en"), ("ipin", "en_b")]):
        s.pin(k, 60, -500 + 40 * i, n)
    for i, n in enumerate(lines):
        s.pin("opin", 1100, -500 + 40 * i, n)
    cp = [("vdd", 0, -80), ("vss", 0, 80), ("iout", 120, 0), ("en", -120, -20), ("en_b", -120, 20)]
    s.block(f"{core_cell}.sym", "x1", 400, -400, cp, dict(vdd="vdd", vss="vss", iout="iref", en="en", en_b="en_b"))
    tp = [("vdd", 0, -100), ("vss", 0, 100), ("vddo", 0, -100), ("vsso", 0, 100)]  # placeholder, replaced below
    import re
    tp = []
    for m in re.finditer(r"^B 5 (\S+) (\S+) (\S+) (\S+) \{[^}]*name=(\w+)", open(f"{d}/ClassABBiasIn.sym").read(), re.M):
        x1, y1, x2, y2 = map(float, m.group(1, 2, 3, 4)); tp.append((m.group(5), int(round((x1 + x2) / 2)), int(round((y1 + y2) / 2))))
    s.block("ClassABBiasIn.sym", "x2", 760, -400, tp, dict(vdd="vdd", vss="vss", vddo="vddo", vsso="vsso", iref="iref", **{l: l for l in lines}))
    s.write(f"{d}/{cell}.sch", title=True)
    return pins

if __name__ == "__main__":
    if "tree" in sys.argv[2:]:
        print(tree(sys.argv[1], "ClassABBiasBGdn" if "dn" in sys.argv[2:] else "ClassABBiasBG"))
    else:
        print(core(sys.argv[1], dn="dn" in sys.argv[2:]))
