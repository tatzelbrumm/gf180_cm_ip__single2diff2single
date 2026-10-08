#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the CACE datasheet and templates of ClassABDriverBiased (ClassABDriver on the ideal bias fixture
ClassABBiasIdeal), GF180MCU, 2026-10-08. Proof-of-concept subset of the IHP decks tb_mpdda_{dc,loop,step,noise}
and of the d2s_miller_biased CACE draft. After the first run, edit the generated files, not this script.
Stimulus and load are element lines in the NGSPICE block: vinp - vref = +vd/2, vinn - vref = -vd/2 (E sources),
load CACE{rload} to vref || CACE{cload} to vss. Values are echoed in SI units (CACE scales to the unit shown);
quantities in % are echoed as fractions.
Usage: gen_cace.py <ClassABDriver macro dir>"""
import os, sys
MAC = os.path.abspath(sys.argv[1])
sys.path.insert(0, os.path.join(MAC, "..", "..", "scripts"))
from xsheet import cace_template, sym_pins

CELL = "ClassABDriverBiased"
OPTS = ".options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-15\n"  # sparse solver: ngspice noise does not run with KLU
OUT = "echo {vals} > CACE{{simpath}}/CACE{{filename}}_CACE{{N}}.data\n"
STIM = ("Ep vinp vref dp 0 0.5\nEn vinn vref dp 0 -0.5\nRL vout vref CACE{rload}\nCL vout 0 CACE{cload}\n")
IQ = ("let iqp = abs(@m.x1.xd.xop.m0[id])\nlet iqn = abs(@m.x1.xd.xon.m0[id])\nlet idd = -i(Vvdd) - i(Vvddo)\n")

def templates(tdir):
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", CELL + ".sym"))
    base = dict(vdd="vdd", vss="0", vddo="vddo", vsso="0", vinp="vinp", vinn="vinn", vref="vref", vout="vout",
                **{p: p for p in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]})
    src = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Vvddo", "CACE{vdd}", "vddo", "0"), ("Vref", "CACE[CACE{vdd}/2]", "vref", "0")]
    note = ("ClassABDriver (x1.xd) on the ideal bias fixture ClassABBiasIdeal (x1.xb): 5 / 5 / 2 / 2 / 5 / 5 uA into the six diodes.\n"
            "vddo = vdd from its own source, vsso = vss. vref = vdd/2. Stimulus and load: element lines in the NGSPICE block.\n"
            "Iq: drain currents of OP (x1.xd.xop) and ON (x1.xd.xon) at vd = 0; Idd = vdd + vddo.")
    # dc: vfb = vout
    dc = (OPTS + "Vd dp 0 0\n" + STIM + ".control\nsave all\nop\n" + IQ +
          "dc Vd -1 1 0.01\nlet vo = v(vout) - v(vref)\n"
          "meas dc vop find vo at=0.2\nmeas dc von find vo at=-0.2\nmeas dc vos find vo at=0\n"
          "let gain = (vop - von)/0.4\n"
          "let inrange = abs(v(dp)) le 0.4001\nlet inl = vecmax(abs(vo - gain*v(dp) - vos) * inrange)\n"
          "let iq_p = op1.iqp\nlet iq_n = op1.iqn\nlet i_dd = op1.idd\n"
          + OUT.format(vals="$&gain $&vos $&inl $&iq_p $&iq_n $&i_dd") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_dc.sch"), f"Template: DC transfer - {CELL}",
                  note + "\nGain = (vo(+0.2) - vo(-0.2))/0.4 with vo = vout - vref; INL = max deviation from that line for |vd| <= 0.4 V (vo = +-0.2 V).",
                  f"{CELL}.sym", pins, dict(base, vfb="vout"), src, dc)
    loop = (OPTS + "Vd dp 0 0\n" + STIM + "Lb vout fb 1G\nCb fb inj 1\nVinj inj 0 dc 0 ac 1\n.control\nsave all\n"
            "ac dec 50 10 1G\nlet T = -v(vout)/v(fb)\nmeas ac T0 find vdb(T) at=10\nmeas ac fc when vdb(T)=0\n"
            "meas ac pT find vp(T) when vdb(T)=0\nlet pm = 180/pi*pT + 180\n" + OUT.format(vals="$&T0 $&fc $&pm") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_loop.sch"), f"Template: loop gain - {CELL}",
                  note + "\nLoop broken at vfb: DC closed through 1 GH, AC injected through 1 F; T = -v(vout)/v(fb) (vfb only drives gates).",
                  f"{CELL}.sym", pins, dict(base, vfb="fb"), src, loop)
    step = (OPTS + "Vd dp 0 pulse(-0.5 0.5 1u 1n 1n 4u 8u)\n" + STIM + ".control\nsave all\n"
            "tran 2n 5u 0 5n\nmeas tran vlo find v(vout) at=0.99u\nmeas tran vhi find v(vout) at=4.9u\n"
            "meas tran vmax max v(vout) from=1u to=5u\nlet overshoot = (vmax - vhi)/(vhi - vlo)\n"
            "let v10 = vlo + 0.1*(vhi - vlo)\nlet v90 = vlo + 0.9*(vhi - vlo)\n"
            "meas tran t10 when v(vout)=v10 rise=1\nmeas tran t90 when v(vout)=v90 rise=1\nlet slew = 0.8*(vhi - vlo)/(t90 - t10)\n"
            "let outside = abs(v(vout) - vhi) gt 0.01*(vhi - vlo)\nlet t_settle = vecmax(time * outside) - 1u\n"
            + OUT.format(vals="$&overshoot $&slew $&t_settle") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_step.sch"), f"Template: step response - {CELL}",
                  note + "\nvd steps -0.5 -> +0.5 V at 1 us (vout vref - 0.25 -> vref + 0.25 V). Settling: last time outside +-1 % of the step.",
                  f"{CELL}.sym", pins, dict(base, vfb="vout"), src, step)
    noise = (OPTS + "Vd dp 0 0 ac 1\n" + STIM + ".control\nsave all\nnoise v(vout) Vd dec 20 10 10meg\nsetplot noise2\n"
             "let vn_total = onoise_total\n" + OUT.format(vals="$&vn_total") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_noise.sch"), f"Template: output noise - {CELL}",
                  note + "\nOutput noise integrated 10 Hz ... 10 MHz.", f"{CELL}.sym", pins, dict(base, vfb="vout"), src, noise)

def spec(name, disp, desc, unit, mn, typ, mx):
    f = lambda x: "{value: %s}" % x
    return (f"      {name}:\n        display: {disp}\n        description: '{desc}'\n        unit: '{unit}'\n"
            f"        minimum: {f(mn)}\n        typical: {f(typ)}\n        maximum: {f(mx)}\n")

def tool(t, variables, collate=False):
    return (f"    tool:\n      ngspice:\n        template: {CELL}_tb_{t}.sch\n" + ("        collate: iterations\n" if collate else "")
            + f"        format: ascii\n        suffix: .data\n        variables: [{', '.join(variables)}]\n")

def conds(**kw):
    s = "    conditions:\n"
    for k, v in kw.items():
        s += f"      {k}:\n" + (f"        enumerate: [{', '.join(map(str, v))}]\n" if isinstance(v, list) else f"        typical: {v}\n")
    return s

def plot(name, x, y):
    return f"      {name}:\n        type: xyplot\n        xaxis: {x}\n        yaxis: {y}\n        limits: auto\n"

def yaml():
    pins = ""
    for p, d, t in [("vdd", "Front-end and bias supply", "power"), ("vss", "Ground", "ground"), ("vddo", "Output-stage supply (OP, RP1)", "power"),
                    ("vsso", "Output-stage ground (ON, RN1)", "ground"), ("vinp", "Positive input", "signal"), ("vinn", "Negative input", "signal"),
                    ("vref", "Output reference (vout - vref = (vinp - vinn)/2)", "signal"), ("vout", "Output", "signal"),
                    ("vfb", "Feedback input (tied to vout in normal use)", "signal")] + \
                   [(b, "Bias line of the ideal fixture, exposed for perturbation", "signal") for b in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]]:
        pins += f"  {p}:\n    description: {d}\n    type: {t}\n    direction: inout\n" + ("    Vmin: 3.0\n    Vmax: 3.6\n" if p == "vdd" else "")
    std = dict(vdd=3.3, corner_mos="typical", temp=27, rload=1000, cload="100e-12")
    pvt = dict(std, vdd=[3.0, 3.3, 3.6], corner_mos=["typical", "ss", "sf", "fs", "ff"], temp=[-40, 27, 125])
    return f"""# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#--------------------------------------------------------------
# CACE circuit characterization file, proof of concept (2026-10-08)
# ClassABDriver on the ideal bias fixture. Port of the IHP decks tb_mpdda_{{dc,loop,step,noise}} to gf180mcuD.
# Generated by ../../scripts/gen_cace.py; edit this file from now on. Limits: IHP d2s_miller_biased draft
# where it had one, otherwise placeholders.
#--------------------------------------------------------------

name:           {CELL}
description:    "ClassABDriver (matched-pair DDA, folded cascode, class-AB output, Miller compensation) on the ideal bias fixture, GF180MCU 03v3"
PDK:            gf180mcuD

cace_format:    5.2

authorship:
  designer:         Christoph Maier
  creation_date:    October 8, 2026
  license:          Apache-2.0

paths:
  root:             ..
  schematic:        ../schematic/xschem
  netlist:          cace/netlist
  documentation:    cace/_docs
  runs:             cace/_runs

pins:
{pins}
default_conditions:
  vdd:
    description: Supply voltage (vdd = vddo)
    display: VDD
    unit: V
    typical: 3.3
  corner_mos:
    description: Process corner MOSFET (sm141064.ngspice section)
    display: Corner MOSFET
    typical: typical
  corner_res:
    description: Process corner resistors
    display: Corner resistor
    typical: res_typical
  mm:
    description: Local mismatch switch (sw_stat_mismatch)
    display: Mismatch
    typical: 0
  temp:
    description: Ambient temperature
    display: Temperature
    unit: °C
    typical: 27
  rload:
    description: Load resistor to vref
    display: R load
    unit: Ohm
    typical: 1000
  cload:
    description: Load capacitor to vss
    display: C load
    unit: F
    typical: 100e-12

parameters:
  dc_params:
    spec:
{spec("gain", "Gain", "(vo(+0.2 V) - vo(-0.2 V)) / 0.4 V, vo = vout - vref; nominal 0.5", "", 0.495, 0.5, 0.505)}{spec("vos", "Output offset", "vout - vref at vd = 0", "mV", -5, 0, 5)}{spec("inl", "Integral nonlinearity", "max deviation from the gain line, vo within +-0.2 V", "mV", "any", "any", 2)}{spec("iqp", "OP quiescent current", "drain current of OP at vd = 0 (target 212 uA)", "uA", 100, 212, 500)}{spec("iqn", "ON quiescent current", "drain current of ON at vd = 0", "uA", 100, 212, 500)}{spec("idd", "Supply current", "vdd + vddo at vd = 0", "uA", "any", "any", 600)}{tool("dc", ["gain", "vos", "inl", "iqp", "iqn", "idd"])}    plot:
{plot("iqp_vs_temp", "temp", "iqp")}{plot("vos_vs_corner_mos", "corner_mos", "vos")}{plot("inl_vs_vdd", "vdd", "inl")}{conds(**pvt)}
  loop_params:
    spec:
{spec("T0", "DC loop gain", "loop gain at 10 Hz", "dB", 40, "any", "any")}{spec("fc", "Loop crossover frequency", "unity loop gain", "MHz", 1, "any", "any")}{spec("pm", "Phase margin", "180 deg + phase of T at fc", "°", 45, 60, "any")}{tool("loop", ["T0", "fc", "pm"])}    plot:
{plot("pm_vs_temp", "temp", "pm")}{plot("T0_vs_corner_mos", "corner_mos", "T0")}{conds(**dict(pvt, vdd=3.3))}
  loop_load_params:
    spec:
{spec("T0", "DC loop gain vs load", "loop gain at 10 Hz", "dB", "any", "any", "any")}{spec("fc", "Crossover vs load", "unity loop gain", "MHz", "any", "any", "any")}{spec("pm", "Phase margin vs load", "180 deg + phase of T at fc", "°", 45, "any", "any")}{tool("loop", ["T0", "fc", "pm"])}    plot:
{plot("pm_vs_cload", "cload", "pm")}{conds(**dict(std, rload=[50, 1000, 1e9], cload=["10e-12", "100e-12", "1e-9"]))}
  step_params:
    spec:
{spec("overshoot", "Overshoot", "step -0.25 -> +0.25 V at the output", "%", "any", 0, 10)}{spec("slew", "Rise rate", "10 - 90 % of the step over its time", "V/us", "any", "any", "any")}{spec("t_settle", "1 % settling time", "after the input step", "ns", "any", "any", 1000)}{tool("step", ["overshoot", "slew", "t_settle"])}{conds(**dict(std, corner_mos=["typical", "ss", "sf", "fs", "ff"], temp=[-40, 27, 125]))}
  noise_params:
    spec:
{spec("vn_total", "Output noise", "integrated 10 Hz ... 10 MHz", "uV", "any", "any", "any")}{tool("noise", ["vn_total"])}{conds(**dict(std, corner_mos=["typical", "ss", "ff"]))}
"""

if __name__ == "__main__":
    tdir = os.path.join(MAC, "verification", "cace", "templates"); os.makedirs(tdir, exist_ok=True)
    templates(tdir)
    open(os.path.join(MAC, "verification", "cace", CELL + ".yaml"), "w").write(yaml())
    print("wrote", CELL)
