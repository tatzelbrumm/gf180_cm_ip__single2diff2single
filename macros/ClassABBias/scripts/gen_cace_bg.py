#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the CACE datasheets and templates of ClassABBiasBG (and the deep-n-well variant ClassABBiasBGdn),
GF180MCU, 2026-10-09: output current over PVT (limits: the kickoff targets), process spread of resistors and PNPs
(report), DC line sensitivity, start-up from 0 V (1 us and 1 ms ramps), local mismatch, disabled state, and the six
bias lines of the ClassABBiasIn tree fed by the reference. After the first run, edit the generated files, not this script.
Usage: gen_cace_bg.py <ClassABBias macro dir> [cells...]"""
import os, sys
MAC = os.path.abspath(sys.argv[1])
sys.path.insert(0, os.path.join(MAC, "..", "..", "scripts"))
from xsheet import Sheet, sym_pins, esc, vsrc

OPTS = (".options savecurrents klu method=gear reltol=1e-4 abstol=1e-13 gmin=1e-15 "
        "SEED=CACE[CACE{seed=12345} + CACE{iterations=0}]\n")
OUT = "echo {vals} > CACE{{simpath}}/CACE{{filename}}_CACE{{N}}.data\n"
LINES = [("bp", "xbp", 5e-6), ("bn", "xbn", 5e-6), ("bpc", "xbpc", 2e-6), ("bnc", "xbnc", 2e-6), ("abp", "xrp2", 5e-6), ("abn", "xrn2", 5e-6)]
MODELS = (".lib $::180MCU_MODELS/sm141064.ngspice CACE{corner_bjt=bjt_typical}\n"
          ".lib $::180MCU_MODELS/sm141064.ngspice diode_typical\n")

def template(path, title, notes, blocks, sources, body, extra_models=MODELS, cond_en=True):
    """blocks: list of (sym, name, x, y, pins, conns)."""
    s = Sheet()
    s.text(title, 60, -1000, 0.45)
    s.text(notes, 60, -950, 0.25)
    for sym, name, x, y, pins, conns in blocks:
        s.block(sym, name, x, y, pins, conns)
    for i, src in enumerate(sources):
        name, value, plus, minus = src[:4]
        kind = src[4] if len(src) > 4 else "vsource"
        vsrc(s, name, 160 + 120 * i, -100, value, plus, minus, kind)
    s.raw('C {devices/code_shown.sym} 1200 -760 0 0 {name=NGSPICE\nsimulator=ngspice\nonly_toplevel=false\nvalue="\n'
          + esc(".include CACE{DUT_path}\n"
                ".temp CACE{temp}\n" + body) + '"}')
    s.raw('C {devices/code_shown.sym} 1200 -900 0 0 {name=MODEL\nonly_toplevel=true\nformat="tcleval( @value )"\nvalue="\n'
          '.include $::180MCU_MODELS/design.ngspice\n'
          + esc(".lib $::180MCU_MODELS/sm141064.ngspice CACE{corner_mos}\n"
                ".lib $::180MCU_MODELS/sm141064.ngspice CACE{corner_res=res_typical}\n"
                ".lib $::180MCU_MODELS/sm141064.ngspice moscap_typical\n"
                ".param sw_stat_mismatch=CACE{mm=0}\n" + extra_models) + '"}')
    s.write(path, title=True)

def templates(cell, tdir):
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", cell + ".sym"))
    conns = dict(vdd="vdd", vss="0", iout="iout", en="en", en_b="en_b")
    dut = [(f"{cell}.sym", "x1", 700, -400, pins, conns)]
    # NI-type diode load (6u/6u, as the tree's input diode) through a 0 V ammeter
    load = ("Vs iout s 0\nXNI s s 0 0 nfet_03v3 L=6u W=6u nf=1\n")
    srcs = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Ven", "'CACE{vdd}*CACE{en=1}'", "en", "0"), ("Venb", "'CACE{vdd}*(1-CACE{en=1})'", "en_b", "0")]
    note = (f"{cell} alone: iout (5 uA out of the pin) into an NMOS diode 6u/6u like the tree's input diode NI, read as i(Vs).\n"
            "en = CACE{en} x vdd (1 = enabled), en_b its complement. Errors echoed as fractions (CACE shows a unit of % as 100 x the value).")
    # dc: iout error and Idd
    template(os.path.join(tdir, f"{cell}_tb_dc.sch"), f"Template: output current - {cell}", note, dut, srcs,
             OPTS + load + ".control\nsave all\nop\nlet e_iout = (abs(i(Vs))/5e-6 - 1)\nlet Idd = -i(Vvdd)\n"
             + OUT.format(vals="$&e_iout $&Idd") + ".endc\n")
    # line sensitivity
    template(os.path.join(tdir, f"{cell}_tb_line.sch"), f"Template: DC line sensitivity - {cell}",
             note + "\nvdd swept 3.0 ... 3.6 V; sensitivity = (I(3.6) - I(3.0)) / I(3.3) / 0.6 V, in %/V.", dut, srcs,
             OPTS + load + ".control\nsave all\ndc Vvdd 3.0 3.6 0.3\nlet ii = abs(i(Vs))\nlet s_iout = (ii[2] - ii[0])/ii[1]/0.6\n"
             + OUT.format(vals="$&s_iout") + ".endc\n")
    # start-up: supply ramp, en tied to vdd (ramps with it)
    srcs_ramp = [("Vvdd", "pwl(0 0 CACE{t_ramp} CACE{vdd})", "vdd", "0"), ("Ven", "pwl(0 0 CACE{t_ramp} CACE{vdd})", "en", "0"), ("Venb", "0", "en_b", "0")]
    tr = (".control\nsave all\nlet tend = CACE{t_ramp} + 1e-3\n"
          "tran CACE[CACE{t_ramp}/1000] CACE[CACE{t_ramp} + 1e-3] 0 CACE[CACE{t_ramp}/200] uic\n"
          "let ii = abs(i(Vs))\nmeas tran ifin find ii at=CACE[CACE{t_ramp} + 1e-3]\n"
          "let lo = 0.9*ifin\nlet hi = 1.1*ifin\nmeas tran tlo when ii=lo cross=last\nmeas tran thi when ii=hi cross=last\n"
          "let tl = tlo\nlet th = thi\nif tl < 0\n  let tl = 0\nend\nif th < 0\n  let th = 0\nend\n"
          "let tmax = tl\nif th > tl\n  let tmax = th\nend\n"
          "let t_startup = tmax - CACE{t_ramp}\nlet e_end = (ifin/5e-6 - 1)\n"
          + OUT.format(vals="$&t_startup $&e_end") + ".endc\n")
    template(os.path.join(tdir, f"{cell}_tb_startup.sch"), f"Template: start-up - {cell}",
             f"{cell} alone, NI-type diode load. vdd and en ramp from 0 V to CACE{{vdd}} in CACE{{t_ramp}}; all nodes start at 0 V (uic), no .nodeset.\n"
             "t_startup = last time iout is outside +-10 % of its value 1 ms after the ramp, minus the ramp time (negative: settled before the ramp ends);\n"
             "e_end = that final value's deviation from 5 uA.", dut, srcs_ramp, OPTS + load + tr)
    # disabled: en = 0, short transient (the DC point is unreliable with every current root off), leakage at the end
    srcs_off = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Ven", "0", "en", "0"), ("Venb", "CACE{vdd}", "en_b", "0")]
    off = (".control\nsave all\ntran 1u 200u\nlet Idd_off = -i(Vvdd)\nlet io = abs(i(Vs))\n"
           "meas tran Idd_off_end find Idd_off at=200u\nmeas tran iout_off find io at=200u\n"
           + OUT.format(vals="$&Idd_off_end $&iout_off") + ".endc\n")
    template(os.path.join(tdir, f"{cell}_tb_off.sch"), f"Template: disabled state - {cell}",
             f"{cell} with en = 0 (en_b = vdd): RefCoreEnable holds vpg at vdd and ks at vss, MS1 is off. Supply and output leakage read 200 us into a transient\n"
             "(with every current root off the DC operating point is unreliable).", dut, srcs_off, OPTS.replace("gmin=1e-15", "gmin=1e-12") + load + off)

def tree_template(cell, tdir):
    """cell = ClassABBiasBGTree / ClassABBiasBGdnTree: the fixture as the DUT, six diode currents of the tree inside it."""
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", cell + ".sym"))
    conns = dict(vdd="vdd", vss="0", vddo="vdd", vsso="0", en="en", en_b="en_b", **{p: p for p in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]})
    srcs = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Ven", "'CACE{vdd}*CACE{en=1}'", "en", "0"), ("Venb", "'CACE{vdd}*(1-CACE{en=1})'", "en_b", "0")]
    e = "".join(f"let e_{k} = (abs(@m.x1.x2.{dev}.m0[id])/{nom} - 1)\n" for k, dev, nom in LINES)
    v = " ".join(f"$&e_{k}" for k, _, _ in LINES)
    template(os.path.join(tdir, f"{cell}_tb_dc.sch"), f"Template: bias tree fed by the reference - {cell}",
             f"{cell}: the reference feeding ClassABBiasIn (iout -> iref, no enable switch in between); vddo tied to vdd, vsso to vss.\n"
             "Bias currents are the drain currents of the six diodes inside the tree (@m.x1.x2.<dev>.m0[id]); errors in % of 5 / 5 / 2 / 2 / 5 / 5 uA\n"
             "(echoed as fractions: CACE shows a unit of % as 100 x the value).",
             [(f"{cell}.sym", "x1", 700, -400, pins, conns)], srcs,
             OPTS + ".control\nsave all\nop\n" + e + "let Idd = -i(Vvdd)\n" + OUT.format(vals=v + " $&Idd") + ".endc\n")

def spec(name, disp, desc, unit, mn, typ, mx):
    f = lambda x: "{value: %s}" % x
    return (f"      {name}:\n        display: {disp}\n        description: '{desc}'\n        unit: '{unit}'\n"
            f"        minimum: {f(mn)}\n        typical: {f(typ)}\n        maximum: {f(mx)}\n")

def yaml_tree(cell, core):
    treespec = "".join(spec(f"e_{k}", f"Error of {k}", f"Deviation of the v{k} diode current from {nom*1e6:g} uA (tree ClassABBiasIn fed by {core}). Limits are placeholders.",
                            "%", -5, 0, 5) for k, _, nom in LINES)
    v6 = ", ".join(f"e_{k}" for k, _, _ in LINES)
    head = yaml(core, core.endswith("dn")).split("parameters:")[0]
    head = head.replace(f"name:           {core}", f"name:           {cell}").replace("Self-contained", "CACE fixture: ClassABBiasIn tree fed by the self-contained")
    head = head.replace("""  iout:
    description: Reference current output, 5 uA flowing OUT of the pin (into the ClassABBiasIn tree's iref)
    type: signal
    direction: output
""", """  vddo:
    description: Output-stage supply (rail of OP and its replica RP1)
    type: power
    direction: inout
  vsso:
    description: Output-stage ground (rail of ON and its replica RN1)
    type: ground
    direction: inout
""" + "".join(f"""  {p}:
    description: bias line {p} of the tree (see ClassABBiasIn.yaml)
    type: signal
    direction: output
""" for p in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]))
    return head + "parameters:\n" + TREE_BLOCK.replace("{treespec}", treespec).replace("{v6}", v6).replace("{cell}", cell).replace("{{", "{").replace("}}", "}")

def yaml(cell, dn):
    treespec = "".join(spec(f"e_{k}", f"Error of {k}", f"Deviation of the v{k} diode current from {nom*1e6:g} uA (tree ClassABBiasIn fed by {cell}). Limits are placeholders.",
                            "%", -5, 0, 5) for k, _, nom in LINES)
    v6 = ", ".join(f"e_{k}" for k, _, _ in LINES)
    desc = "Self-contained current-mode bandgap reference of the class-AB driver, 5 uA out of iout, GF180MCU 03v3" + (", NMOS pair in a deep n-well" if dn else "")
    return f"""# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#--------------------------------------------------------------
# CACE circuit characterization file (2026-10-09): GF180 bandgap reference {cell}.
# Limits are the targets agreed on 2026-10-08 (kickoff_reference_redesign.md section 3): drift +-3 % over
# -40...125 C, line sensitivity <= 1 %/V, start-up from 0 V with 1 us and 1 ms ramps, mismatch sigma <= 2 %
# (checked as +-6 % on the extremes of 100 runs; sigma from the csv). Process spread and leakage: report only.
# Generated by ../../scripts/gen_cace_bg.py; edit this file from now on.
#--------------------------------------------------------------

name:           {cell}
description:    "{desc}"
PDK:            gf180mcuD

cace_format:    5.2

authorship:
  designer:         Christoph Maier
  creation_date:    October 9, 2026
  license:          Apache-2.0

paths:
  root:             ..
  schematic:        ../schematic/xschem
  netlist:          cace/netlist
  documentation:    cace/_docs
  runs:             cace/_runs

pins:
  vdd:
    description: Analog supply
    type: power
    direction: inout
    Vmin: 3.0
    Vmax: 3.6
  vss:
    description: Analog ground
    type: ground
    direction: inout
  iout:
    description: Reference current output, 5 uA flowing OUT of the pin (into the ClassABBiasIn tree's iref)
    type: signal
    direction: output
  en:
    description: Enable, active high (0 / vdd)
    type: digital
    direction: input
  en_b:
    description: Complement of en (from PadEnable/EnableInv)
    type: digital
    direction: input

default_conditions:
  vdd:
    description: Analog supply voltage
    display: VDD
    unit: V
    typical: 3.3
  en:
    description: Enable (1 = enabled, 0 = disabled), as a fraction of vdd
    display: en
    typical: 1
  corner_mos:
    description: Process corner MOSFET (sm141064.ngspice section)
    display: Corner MOSFET
    typical: typical
  corner_res:
    description: Process corner resistors (sm141064.ngspice section)
    display: Corner resistor
    typical: res_typical
  corner_bjt:
    description: Process corner vertical PNPs (sm141064.ngspice section)
    display: Corner PNP
    typical: bjt_typical
  mm:
    description: Local mismatch switch (sw_stat_mismatch; MOS and PNP, the PDK has no resistor mismatch)
    display: Mismatch
    typical: 0
  temp:
    description: Ambient temperature
    display: Temperature
    unit: °C
    typical: 27
  t_ramp:
    description: Supply ramp time
    display: Ramp
    unit: s
    typical: 1e-6

parameters:
  dc_params:
    spec:
{spec("e_iout", "Error of iout", "Deviation of iout from 5 uA over MOS corners, supply and temperature (resistors and PNPs typical).", "%", -3, 0, 3)}      Idd:
        display: Supply current
        description: Current from vdd (enabled)
        unit: uA
        minimum: {{value: any}}
        typical: {{value: any}}
        maximum: {{value: any}}
    tool:
      ngspice:
        template: {cell}_tb_dc.sch
        format: ascii
        suffix: .data
        variables: [e_iout, Idd]
    plot:
      e_iout_vs_temp:
        type: xyplot
        xaxis: temp
        yaxis: e_iout
        limits: auto
      e_iout_vs_vdd:
        type: xyplot
        xaxis: vdd
        yaxis: e_iout
        limits: auto
    conditions:
      en:
        typical: 1
      vdd:
        enumerate: [3.0, 3.3, 3.6]
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      corner_res:
        typical: res_typical
      corner_bjt:
        typical: bjt_typical
      temp:
        enumerate: [-40, 27, 125]

  spread_params:
    spec:
{spec("e_iout", "Error of iout - process spread", "Deviation of iout from 5 uA over resistor and PNP corners (R_sh +-25 % goes straight into the current; no trim). Report only.", "%", "any", 0, "any")}    tool:
      ngspice:
        template: {cell}_tb_dc.sch
        format: ascii
        suffix: .data
        variables: [e_iout, null]
    plot:
      e_iout_vs_corner_res:
        type: xyplot
        xaxis: corner_res
        yaxis: e_iout
        limits: auto
    conditions:
      en:
        typical: 1
      vdd:
        typical: 3.3
      corner_mos:
        typical: typical
      corner_res:
        enumerate: [res_typical, res_ss, res_ff]
      corner_bjt:
        enumerate: [bjt_typical, bjt_ss, bjt_ff]
      temp:
        enumerate: [-40, 27, 125]

  line_params:
    spec:
{spec("s_iout", "Line sensitivity of iout", "DC change of iout per volt of vdd, 3.0 ... 3.6 V.", "%/V", -1, 0, 1)}    tool:
      ngspice:
        template: {cell}_tb_line.sch
        format: ascii
        suffix: .data
        variables: [s_iout]
    conditions:
      en:
        typical: 1
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      corner_res:
        enumerate: [res_typical, res_ss, res_ff]
      corner_bjt:
        typical: bjt_typical
      temp:
        enumerate: [-40, 27, 125]

  tran_startup_params:
    spec:
{spec("t_startup", "Start-up time", "Time after the supply ramp until iout stays within +-10 % of its final value (negative: settled before the ramp ends). Limit: 20 us after a 1 us ramp (placeholder).", "us", "any", 1, 20)}{spec("e_end", "Error of iout after start-up", "Deviation of iout from 5 uA 1 ms after the ramp: the core must reach its operating point, not a false one.", "%", -3, 0, 3)}    tool:
      ngspice:
        template: {cell}_tb_startup.sch
        format: ascii
        suffix: .data
        variables: [t_startup, e_end]
    conditions:
      t_ramp:
        enumerate: [1e-6, 1e-3]
      vdd:
        enumerate: [3.0, 3.6]
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      corner_res:
        typical: res_typical
      corner_bjt:
        typical: bjt_typical
      temp:
        enumerate: [-40, 27, 125]

  mm_params:
    spec:
{spec("e_iout", "Error of iout - Mismatch", "Deviation of iout from 5 uA under local mismatch (MOS, PNP), 100 runs; the limit is 3 sigma of the 2 % target.", "%", -6, 0, 6)}      Idd:
        display: Supply current - Mismatch
        description: Current from vdd under local mismatch
        unit: uA
        minimum: {{value: any}}
        typical: {{value: any}}
        maximum: {{value: any}}
    tool:
      ngspice:
        template: {cell}_tb_dc.sch
        collate: iterations
        format: ascii
        suffix: .data
        variables: [e_iout, Idd]
    conditions:
      iterations:
        description: Iterations to run
        display: Iterations
        minimum: 1
        maximum: 100
        step: linear
        stepsize: 1
      mm:
        typical: 1
      en:
        typical: 1
      vdd:
        typical: 3.3
      corner_mos:
        typical: typical
      corner_res:
        typical: res_typical
      corner_bjt:
        typical: bjt_typical
      temp:
        typical: 27

  off_params:
    spec:
{spec("Idd_off_end", "Supply current disabled", "Current from vdd with en = 0, 200 us into a transient. Limit: placeholder.", "nA", "any", 1, 50)}{spec("iout_off", "Output current disabled", "Current out of iout with en = 0 (into the NI-type diode). Limit: placeholder.", "nA", "any", 0.1, 10)}    tool:
      ngspice:
        template: {cell}_tb_off.sch
        format: ascii
        suffix: .data
        variables: [Idd_off_end, iout_off]
    conditions:
      en:
        typical: 0
      vdd:
        enumerate: [3.0, 3.6]
      corner_mos:
        enumerate: [typical, ss, ff]
      corner_res:
        typical: res_typical
      corner_bjt:
        typical: bjt_typical
      temp:
        enumerate: [-40, 27, 125]

"""

TREE_BLOCK = '''  tree_params:
    spec:
{treespec}      Idd:
        display: Supply current with tree
        description: Current from vdd, reference and tree together (vddo tied to vdd)
        unit: uA
        minimum: {{value: any}}
        typical: {{value: any}}
        maximum: {{value: any}}
    tool:
      ngspice:
        template: {cell}_tb_dc.sch
        format: ascii
        suffix: .data
        variables: [{v6}, Idd]
    plot:
      e_bn_vs_temp:
        type: xyplot
        xaxis: temp
        yaxis: e_bn
        limits: auto
    conditions:
      en:
        typical: 1
      vdd:
        enumerate: [3.0, 3.3, 3.6]
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      corner_res:
        typical: res_typical
      corner_bjt:
        typical: bjt_typical
      temp:
        enumerate: [-40, 27, 125]
'''

if __name__ == "__main__":
    cells = sys.argv[2:] or ["ClassABBiasBG", "ClassABBiasBGdn"]
    cdir, tdir = os.path.join(MAC, "verification", "cace"), os.path.join(MAC, "verification", "cace", "templates")
    for cell in cells:
        templates(cell, tdir)
        open(os.path.join(cdir, cell + ".yaml"), "w").write(yaml(cell, cell.endswith("dn")))
        tree_template(cell + "Tree", tdir)
        open(os.path.join(cdir, cell + "Tree.yaml"), "w").write(yaml_tree(cell + "Tree", cell))
        print("wrote", cell, cell + "Tree")
