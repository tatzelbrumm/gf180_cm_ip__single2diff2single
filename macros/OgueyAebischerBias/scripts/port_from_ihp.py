#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
"""
One-time port of the IHP sg13cmos5l OgueyAebischerBias macro to GF180MCU (gf180mcuD).

Reads the IHP xschem sources (OgueyAebischerBias.sch/.sym, ToBiasStartup.sch/.sym,
OgueyAebischerBias_tb.sch) and writes GF180 versions in two device-family variants:

    03v3  nfet_03v3 / pfet_03v3   (3.3 V core devices; analog supply <= 3.3 V + 10 %)
    06v0  nfet_06v0 / pfet_06v0   (6 V devices; keeps a 5 V analog supply option open)

Every wire and every instance position of the IHP drawings is kept: the GF180 FET symbols
have the same pin geometry as sg13_hv_nmos/pmos (D/S at (20,-+30), G at (-20,0), B at (20,0)).
Only the symbol reference and the device properties change.

The W/L values are NOT copied from IHP. They were re-derived for GF180 on 2026-10-06
(see ../README.md, "Sizing"), by simulation with the gf180mcuD ngspice models:

  * mirror devices M10..M14: weak inversion, IC(M11) ~ 0.1, unit area chosen for
    sigma(I1) ~ 5 % (mismatch Monte Carlo); multi-unit devices drawn as ONE instance
    with nf = units and W = units * W_unit, because the GF180 mismatch model (fets_mm)
    computes sigma from the instance's own W*L and ignores m.  Max W per instance 100 um
    (model bin limit), hence at most 25 um per unit for the 4-unit devices.
  * triode stack M15..M22: length tuned for I1 = 100 nA at typical / 27 C / 3.3 V.

After this script has run once, the .sch files are the source of truth. Hand edits to
them are expected; do not re-run this script over edited files without diffing first.

Usage:
    python3 port_from_ihp.py <ihp_macro_dir> <gf180_macro_dir>
"""
import os, re, sys

SIZES = {
    "03v3": dict(n="nfet_03v3", p="pfet_03v3",
                 Wn=22, Ln=2.2, Wp=18, Lp=2.8,        # mirror unit devices
                 Wst=2, Lst=20.4,                     # triode / diode stacks, 4 in series
                 Wsu=1, Lsu=1,                        # start-up kick and disable switches
                 Wcap=8, Lcap=2),                     # MOS capacitors M20, M26
    "06v0": dict(n="nfet_06v0", p="pfet_06v0",
                 Wn=24, Ln=3.0, Wp=24, Lp=4.0,
                 Wst=2, Lst=14.8,
                 Wsu=1, Lsu=1,
                 Wcap=8, Lcap=4),
}

def fmt(x):
    s = f"{x:.4f}".rstrip("0").rstrip(".")
    return s + "u"

def fet_props(name, model, W, L, nf=1):
    return (f"name={name}\n"
            f"L={fmt(L)}\n"
            f"W={fmt(W)}\n"
            f"nf={nf}\n"
            f"m=1\n"
            "ad=\"'int((nf+1)/2) * W/nf * 0.18u'\"\n"
            "pd=\"'2*int((nf+1)/2) * (W/nf + 0.18u)'\"\n"
            "as=\"'int((nf+2)/2) * W/nf * 0.18u'\"\n"
            "ps=\"'2*int((nf+2)/2) * (W/nf + 0.18u)'\"\n"
            "nrd=\"'0.18u / W'\" nrs=\"'0.18u / W'\"\n"
            "sa=0 sb=0 sd=0\n"
            f"model={model}\n"
            "spiceprefix=X\n")

def device_table(v):
    s = SIZES[v]
    n, p = s["n"], s["p"]
    core = {
        "M10": (n, 4 * s["Wn"], s["Ln"], 4),
        "M11": (n, s["Wn"], s["Ln"], 1),
        "M12": (p, s["Wp"], s["Lp"], 1),
        "M13": (p, 4 * s["Wp"], s["Lp"], 4),
        "M14": (p, 2 * s["Wp"], s["Lp"], 2),
    }
    for k in range(15, 23):
        core[f"M{k}"] = (n, s["Wst"], s["Lst"], 1)
    start = {
        "M21": (p, s["Wsu"], s["Lsu"], 1),
        "M22": (p, s["Wsu"], s["Lsu"], 1),
        "M23": (n, s["Wsu"], s["Lsu"], 1),
        "M24": (n, s["Wsu"], s["Lsu"], 1),
        "M25": (p, s["Wp"], s["Lp"], 1),     # replica of the PMOS mirror unit
        "M20": (n, s["Wcap"], s["Lcap"], 1),
        "M26": (n, s["Wcap"], s["Lcap"], 1),
    }
    return core, start

HDR = "v {xschem version=3.4.4 file_version=1.2}\n"

INST = re.compile(r"^C \{([^}]*)\} (\S+) (\S+) (\S+) (\S+) \{(.*?)\}\s*$", re.M | re.S)

def split_records(text):
    """Split an xschem file into top-level records (a record may span lines inside braces)."""
    recs, cur, depth = [], "", 0
    i = 0
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

def port_sch(src, table, variant, rename_syms, title_note):
    out = []
    for r in split_records(open(src).read()):
        if r.startswith("v {"):
            out.append(HDR); continue
        m = re.match(r"^C \{([^}]*)\} (\S+) (\S+) (\S+) (\S+) \{(.*)\}\s*$", r, re.S)
        if m:
            sym, x, y, rot, flip, props = m.groups()
            if "sg13_hv_" in sym or "sg13_lv_" in sym:
                name = re.search(r"name=(\S+)", props).group(1)
                model, W, L, nf = table[name]
                out.append(f"C {{symbols/{model}.sym}} {x} {y} {rot} {flip} {{{fet_props(name, model, W, L, nf)}}}\n")
                continue
            base = os.path.basename(sym)
            if base in rename_syms:
                out.append(f"C {{{rename_syms[base]}}} {x} {y} {rot} {flip} {{{props}}}\n")
                continue
            if base == "title.sym":
                out.append(f"C {{devices/title.sym}} {x} {y} {rot} {flip} {{name=l1 author=\"Christoph Maier\"}}\n")
                continue
        out.append(r if r.endswith("\n") else r + "\n")
    out.append(f"T {{{title_note}}} 160 -880 0 0 0.3 0.3 {{}}\n")
    return "".join(out)

def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, "w").write(text)
    print("wrote", path)

def sym_retitle(src_sym):
    t = open(src_sym).read()
    t = re.sub(r"^v \{[^}]*\}\n", "v {xschem version=3.4.4 file_version=1.2}\n", t)
    return t

# ---------------------------------------------------------------------------------------
# Wrapper OgueyAebischerRef_<v>: core + start-up, the CACE DUT.  Geometry follows the IHP
# testbench, which already wires the two blocks; supplies and outputs become pins.
# ---------------------------------------------------------------------------------------
def ref_sch(v):
    core, start = f"OgueyAebischerBias_{v}.sym", f"ToBiasStartup_{v}.sym"
    s = HDR + "G {}\nK {}\nV {}\nS {}\nE {}\n"
    s += """N 380 -500 760 -500 {lab=vdd}
N 540 -500 540 -380 {lab=vdd}
N 760 -500 760 -380 {lab=vdd}
N 380 -200 760 -200 {lab=vss}
N 540 -300 540 -200 {lab=vss}
N 760 -300 760 -200 {lab=vss}
N 380 -320 480 -320 {lab=disable}
N 600 -360 620 -360 {lab=vbp}
N 620 -420 620 -360 {lab=vbp}
N 620 -420 840 -420 {lab=vbp}
N 840 -420 840 -360 {lab=vbp}
N 820 -360 840 -360 {lab=vbp}
N 840 -420 960 -420 {lab=vbp}
N 600 -340 640 -340 {lab=vbn}
N 640 -340 640 -260 {lab=vbn}
N 640 -260 860 -260 {lab=vbn}
N 860 -340 860 -260 {lab=vbn}
N 820 -340 860 -340 {lab=vbn}
N 860 -260 960 -260 {lab=vbn}
N 600 -320 620 -320 {lab=vbr}
N 620 -320 620 -240 {lab=vbr}
N 620 -240 840 -240 {lab=vbr}
N 840 -320 840 -240 {lab=vbr}
N 820 -320 840 -320 {lab=vbr}
N 840 -240 840 -220 {lab=vbr}
N 840 -220 960 -220 {lab=vbr}
"""
    s += f"C {{{core}}} 760 -340 0 0 {{name=xbias}}\n"
    s += f"C {{{start}}} 540 -340 0 0 {{name=xstart}}\n"
    s += "C {devices/iopin.sym} 380 -500 0 1 {name=p1 lab=vdd}\n"
    s += "C {devices/iopin.sym} 960 -420 0 0 {name=p2 lab=vbp}\n"
    s += "C {devices/iopin.sym} 960 -260 0 0 {name=p3 lab=vbn}\n"
    s += "C {devices/ipin.sym} 380 -320 0 0 {name=p4 lab=disable}\n"
    s += "C {devices/iopin.sym} 960 -220 0 0 {name=p5 lab=vbr}\n"
    s += "C {devices/iopin.sym} 380 -200 0 1 {name=p6 lab=vss}\n"
    s += "C {devices/title.sym} 160 -40 0 0 {name=l1 author=\"Christoph Maier\"}\n"
    s += (f"T {{OgueyAebischerRef_{v}: resistor-free Oguey-Aebischer current reference + start-up kick, GF180MCU {v} devices.\n"
          "CACE DUT. Port order (symbol): vdd vbp vbn disable vbr vss.\n"
          "H. J. Oguey and D. Aebischer, CMOS current reference without resistance,\n"
          "IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 380 -700 0 0 0.3 0.3 {}\n")
    return s

def ref_sym(src_startup_sym):
    # Same pin set and order as ToBiasStartup: vdd vbp vbn disable vbr vss
    t = sym_retitle(src_startup_sym)
    return t

# ---------------------------------------------------------------------------------------
# Interactive testbench (port of the IHP OgueyAebischerBias_tb.sch)
# ---------------------------------------------------------------------------------------
def tb_sch(v):
    s = HDR + "G {}\nK {}\nV {}\nS {}\nE {}\n"
    s += """T {H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 440 -150 0 0 0.3 0.3 {}
N 380 -200 380 -180 {lab=0}
N 380 -420 380 -200 {lab=0}
N 380 -500 380 -480 {lab=vdd}
N 380 -500 600 -500 {lab=vdd}
N 600 -500 600 -380 {lab=vdd}
N 380 -200 600 -200 {lab=0}
N 600 -300 600 -200 {lab=0}
N 440 -320 540 -320 {lab=disable}
N 440 -320 440 -300 {lab=disable}
N 440 -240 440 -200 {lab=0}
N 660 -360 720 -360 {lab=vbp}
N 660 -340 720 -340 {lab=vbn}
N 660 -320 720 -320 {lab=vbr}
"""
    s += f"C {{OgueyAebischerRef_{v}.sym}} 600 -340 0 0 {{name=xref}}\n"
    s += "C {devices/gnd.sym} 380 -180 0 0 {name=l2 lab=0}\n"
    s += "C {devices/vsource.sym} 380 -450 0 1 {name=VDD value=\"dc 3.3 pwl(0 0 1m 3.3)\"}\n"
    s += "C {devices/vsource.sym} 440 -270 0 1 {name=Voff value=0}\n"
    s += "C {devices/lab_wire.sym} 470 -500 0 0 {name=l3 lab=vdd}\n"
    s += "C {devices/lab_wire.sym} 500 -320 0 0 {name=l5 lab=disable}\n"
    s += "C {devices/lab_pin.sym} 720 -360 0 1 {name=l6 lab=vbp}\n"
    s += "C {devices/lab_pin.sym} 720 -340 0 1 {name=l7 lab=vbn}\n"
    s += "C {devices/lab_pin.sym} 720 -320 0 1 {name=l8 lab=vbr}\n"
    s += "C {devices/title.sym} 160 -40 0 0 {name=l1 author=\"Christoph Maier\"}\n"
    s += r'''C {devices/code_shown.sym} 0 -880 0 0 {name=NGSPICE
only_toplevel=true
value="
.options gmin=1e-15 abstol=1p
.option savecurrents
.control
save all
op
remzerovec
write OgueyAebischerRef_''' + v + r'''_tb_tran.op.raw
tran 100n 3m
remzerovec
write OgueyAebischerRef_''' + v + r'''_tb_tran.raw
* core reference current through the ammeter Vi1 inside xbias
meas tran I1_final find v.xref.xbias.vi1#branch at=3m
plot vdd vbp vbn vbr xref.xbias.vres xref.xstart.vkick
plot v.xref.xbias.vi1#branch v.xref.xbias.vi4#branch v.xref.xbias.viaux#branch
.endc
"}
C {devices/code_shown.sym} 0 -620 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
'''
    s += (f"T {{Start-up testbench, OgueyAebischerRef_{v}. VDD ramps 0 -> 3.3 V in 1 ms; no .nodeset,\n"
          "so the kick circuit has to start the core on its own. Port of the IHP OgueyAebischerBias_tb.sch\n"
          "(which still ramped to 1.2 V over 100 ms).} 440 -660 0 0 0.3 0.3 {}\n")
    return s

def main(ihp, dst):
    sch_in = os.path.join(ihp, "schematic/xschem")
    tb_in = os.path.join(ihp, "testbenches/xschem")
    for v in SIZES:
        core, start = device_table(v)
        ren = {"OgueyAebischerBias.sym": f"OgueyAebischerBias_{v}.sym",
               "ToBiasStartup.sym": f"ToBiasStartup_{v}.sym"}
        note = (f"GF180MCU port ({v} devices) of the IHP sg13cmos5l design, 2026-10-06. "
                "Wires and placement unchanged; W/L re-derived for GF180, see macro README.")
        write(f"{dst}/schematic/xschem/OgueyAebischerBias_{v}.sch",
              port_sch(f"{sch_in}/OgueyAebischerBias.sch", core, v, ren, note))
        write(f"{dst}/schematic/xschem/ToBiasStartup_{v}.sch",
              port_sch(f"{sch_in}/ToBiasStartup.sch", start, v, ren, note))
        write(f"{dst}/schematic/xschem/OgueyAebischerBias_{v}.sym", sym_retitle(f"{sch_in}/OgueyAebischerBias.sym"))
        write(f"{dst}/schematic/xschem/ToBiasStartup_{v}.sym", sym_retitle(f"{sch_in}/ToBiasStartup.sym"))
        write(f"{dst}/schematic/xschem/OgueyAebischerRef_{v}.sch", ref_sch(v))
        write(f"{dst}/schematic/xschem/OgueyAebischerRef_{v}.sym", ref_sym(f"{sch_in}/ToBiasStartup.sym"))
        write(f"{dst}/testbenches/xschem/OgueyAebischerRef_{v}_tb_tran.sch", tb_sch(v))

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
