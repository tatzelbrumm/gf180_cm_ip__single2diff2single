#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the CACE datasheet and templates of gf180mcu_IOPadDiff2Single (driver + bias tree + enables), GF180MCU,
2026-10-08, proof of concept: enabled DC transfer, disabled state, enable transient (subset of the IHP power_down
checks, power_down/log.md 20:45). After the first run, edit the generated files, not this script.
The reference current comes from a behavioural source between vdd and iref that loses its compliance near vdd
(Bref: I = CACE{i_ref} * tanh(V(vsup, iref) / 0.1 V), with 100 MOhm output resistance Rref), a stand-in for an external
PMOS source on its own supply vsup = vdd, so that Idd does not include it. With the pad disabled the transmission gate
is open and the source runs out of compliance instead of forcing the node.
Usage: gen_cace.py <gf180mcu_IOPadDiff2Single macro dir>"""
import os, sys
MAC = os.path.abspath(sys.argv[1])
sys.path.insert(0, os.path.join(MAC, "..", "..", "scripts"))
from xsheet import cace_template, sym_pins

CELL = "gf180mcu_IOPadDiff2Single"
OPTS = ".options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-15\n"
OUT = "echo {vals} > CACE{{simpath}}/CACE{{filename}}_CACE{{N}}.data\n"
STIM = ("Vsup vsup 0 CACE{vdd}\nBref vsup iref I=CACE{i_ref}*tanh(max(v(vsup,iref),0)/0.1)\nRref vsup iref 100Meg\n"
        "Ep inp vref dp 0 0.5\nEn inn vref dp 0 -0.5\nRL out vref CACE{rload}\nCL out 0 CACE{cload}\n")

def templates(tdir):
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", CELL + ".sym"))
    conns = dict(vdd="vdd", vss="0", vddo="vddo", vsso="0", inp="inp", inn="inn", vref="vref", out="out", iref="iref", en="en")
    src = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Vvddo", "CACE{vdd}", "vddo", "0"), ("Vref", "CACE[CACE{vdd}/2]", "vref", "0")]
    note = ("gf180mcu_IOPadDiff2Single (x1): bias tree x1.xbias fed through x1.xref from iref, driver x1.xdrv (vfb = out),\n"
            "enable switches x1.xen, inverter x1.xinv. vddo = vdd from its own source, vsso = vss, vref = vdd/2.\n"
            "Bref, Rref, Vsup (NGSPICE block): reference current CACE{i_ref} into iref from a separate vsup = vdd, compliance lost near vsup.\n"
            "Stimulus inp - vref = vd/2, inn - vref = -vd/2; load CACE{rload} to vref || CACE{cload}.")
    en_src = ("Ven en 0 CACE{en_v}\n")
    dc = (OPTS + en_src + "Vd dp 0 0\n" + STIM + ".control\nsave all\nop\n"
          "let iqp = abs(@m.x1.xdrv.xop.m0[id])\nlet idd = -i(Vvdd) - i(Vvddo)\n"
          "dc Vd -0.4 0.4 0.01\nlet vo = v(out) - v(vref)\n"
          "meas dc vop find vo at=0.2\nmeas dc von find vo at=-0.2\nmeas dc vos find vo at=0\nlet gain = (vop - von)/0.4\n"
          "let iq_p = op1.iqp\nlet i_dd = op1.idd\n" + OUT.format(vals="$&gain $&vos $&iq_p $&i_dd") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_on.sch"), f"Template: enabled DC transfer - {CELL}",
                  note + "\nen = CACE{en_v} (vdd). Idd = vdd + vddo (the reference current has its own supply vsup).", f"{CELL}.sym", pins, conns, src, dc)
    # With every current root switched off most nodes float, and the DC operating point is not reliable: at
    # gmin = 1e-15 (and in one of 15 runs at 1e-12) ngspice accepted solutions whose supply currents broke KCL by
    # ~17 uA (checked 2026-10-08). A 5 us transient from that point settles to the leakage; the values are read
    # at its end.
    m = lambda n, e: f"meas tran {n} find {e} at=5u\n"
    off = (OPTS.replace("gmin=1e-15", "gmin=1e-12") + en_src + "Vd dp 0 0\n" + STIM + ".control\nsave all\ntran 10n 5u\n"
           + m("i1", "i(Vvdd)") + m("i2", "i(Vvddo)") + m("vo1", "v(vddo)") + m("va1", "v(x1.a)") + m("vb", "v(x1.b)")
           + m("vout1", "v(out)") + m("vref1", "v(vref)") + m("vn", "v(x1.iref_en)") + m("ir", "i(Vsup)")
           + "let idd_off = -i1 - i2\nlet va_off = vo1 - va1\nlet vb_off = vb\nlet vout_off = vout1 - vref1\nlet iref_n = vn\nlet iref_off = -ir\n"
           + OUT.format(vals="$&idd_off $&va_off $&vb_off $&vout_off $&iref_n $&iref_off") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_off.sch"), f"Template: disabled state - {CELL}",
                  note + "\nen = 0: OP / ON gates a, b held at vddo / vsso; Read at the end of a 5 us transient (the DC operating point of the switched-off circuit is not reliable).\nIdd = vdd + vddo; iref_off = current still delivered by the reference source.",
                  f"{CELL}.sym", pins, conns, src, off)
    ena = (OPTS + "Ven en 0 pwl(0 0 1u 0 1.01u CACE{vdd})\nVd dp 0 0\n" + STIM + ".control\nsave all\n"
           "tran 5n 31u 0 20n\nlet vo = v(out) - v(vref)\n"
           "meas tran glitch_max max vo from=1u to=31u\nmeas tran glitch_min min vo from=1u to=31u\n"
           "let glitch = max(abs(glitch_max), abs(glitch_min))\n"
           "let outside = abs(vo) gt 1e-3\nlet t_on = vecmax(time * outside) - 1u\n"
           "meas tran iq_on find @m.x1.xdrv.xop.m0[id] at=30u\nlet iqp = abs(iq_on)\n"
           + OUT.format(vals="$&glitch $&t_on $&iqp") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_enable.sch"), f"Template: enable transient - {CELL}",
                  note + "\nen rises at 1 us (10 ns edge), vd = 0. glitch = max |out - vref| after the edge; t_on = time after the edge\n"
                  "until out stays within 1 mV of vref. OP's current is saved for the end value.",
                  f"{CELL}.sym", pins, conns, src, ena.replace(".control\nsave all\n", ".save all @m.x1.xdrv.xop.m0[id]\n.control\n"))

def spec(name, disp, desc, unit, mn, typ, mx):
    f = lambda x: "{value: %s}" % x
    return (f"      {name}:\n        display: {disp}\n        description: '{desc}'\n        unit: '{unit}'\n"
            f"        minimum: {f(mn)}\n        typical: {f(typ)}\n        maximum: {f(mx)}\n")

def tool(t, variables):
    return (f"    tool:\n      ngspice:\n        template: {CELL}_tb_{t}.sch\n        format: ascii\n        suffix: .data\n"
            f"        variables: [{', '.join(variables)}]\n")

def conds(**kw):
    s = "    conditions:\n"
    for k, v in kw.items():
        s += f"      {k}:\n" + (f"        enumerate: [{', '.join(map(str, v))}]\n" if isinstance(v, list) else f"        typical: {v}\n")
    return s

def plot(name, x, y):
    return f"      {name}:\n        type: xyplot\n        xaxis: {x}\n        yaxis: {y}\n        limits: auto\n"

def yaml():
    pins = ""
    for p, d, t in [("vdd", "Analog supply (front end, bias, enables)", "power"), ("vss", "Ground", "ground"),
                    ("vddo", "Output-stage supply (OP, RP1, SA)", "power"), ("vsso", "Output-stage ground (ON, RN1, SB)", "ground"),
                    ("inp", "Positive input", "signal"), ("inn", "Negative input", "signal"), ("vref", "Output reference", "signal"),
                    ("out", "Pad output, out - vref = (inp - inn)/2", "signal"), ("iref", "Reference current input, 5 uA into the pin", "signal"),
                    ("en", "Enable, active high, 0 / vdd", "digital")]:
        pins += f"  {p}:\n    description: {d}\n    type: {t}\n    direction: inout\n" + ("    Vmin: 3.0\n    Vmax: 3.6\n" if p == "vdd" else "")
    std = dict(vdd=3.3, corner_mos="typical", temp=27, rload=1000, cload="100e-12", i_ref="5e-6")
    ct = dict(corner_mos=["typical", "ss", "sf", "fs", "ff"], temp=[-40, 27, 125])
    return f"""# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#--------------------------------------------------------------
# CACE circuit characterization file, proof of concept (2026-10-08)
# Class-AB output pad: ClassABDriver + ClassABBiasIn + PadEnable cells. Subset of the IHP power_down checks.
# Generated by ../../scripts/gen_cace.py; edit this file from now on. Limits are placeholders.
#--------------------------------------------------------------

name:           {CELL}
description:    "Class-AB differential to single-ended pad driver with bias tree and enable, GF180MCU 03v3"
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
  en_v:
    description: Enable level
    display: en
    unit: V
    typical: 3.3
  i_ref:
    description: Reference current into iref
    display: Iref
    unit: A
    typical: 5e-6
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
  on_params:
    spec:
{spec("gain", "Gain - enabled", "(vo(+0.2 V) - vo(-0.2 V)) / 0.4 V, vo = out - vref", "", 0.495, 0.5, 0.505)}{spec("vos", "Output offset - enabled", "out - vref at vd = 0", "mV", -5, 0, 5)}{spec("iq_p", "OP quiescent current - enabled", "drain current of OP, real bias tree (target 212 uA)", "uA", 100, 212, 500)}{spec("i_dd", "Supply current - enabled", "vdd + vddo; the 5 uA reference comes from its own supply", "uA", "any", "any", 600)}{tool("on", ["gain", "vos", "iq_p", "i_dd"])}    plot:
{plot("iq_p_vs_temp", "temp", "iq_p")}{conds(**dict(std, en_v=3.3, vdd=[3.0, 3.3, 3.6], **ct))}
  off_params:
    spec:
{spec("idd_off", "Supply current - disabled", "vdd + vddo with en = 0, reference source excluded", "nA", "any", "any", 100)}{spec("va_off", "OP gate below vddo - disabled", "vddo - v(a)", "mV", -1, 0, 1)}{spec("vb_off", "ON gate above vsso - disabled", "v(b)", "mV", -1, 0, 1)}{spec("vout_off", "Output - disabled", "out - vref (load to vref)", "mV", "any", "any", "any")}{spec("iref_n", "NI gate line - disabled", "v(iref_en), pulled to vss", "mV", "any", "any", 10)}{spec("iref_off", "Reference current - disabled", "what the external source still delivers into iref", "nA", "any", "any", "any")}{tool("off", ["idd_off", "va_off", "vb_off", "vout_off", "iref_n", "iref_off"])}    plot:
{plot("idd_off_vs_temp", "temp", "idd_off")}{conds(**dict(std, en_v=0, **ct))}
  enable_params:
    spec:
{spec("glitch", "Output glitch at enable", "max |out - vref| after en rises, vd = 0", "mV", "any", "any", "any")}{spec("t_on", "Enable time", "en edge until out stays within 1 mV of vref", "us", "any", "any", 20)}{spec("iqp", "OP current after enable", "at 30 us", "uA", 100, 212, 500)}{tool("enable", ["glitch", "t_on", "iqp"])}    plot:
{plot("t_on_vs_temp", "temp", "t_on")}{conds(**dict(std, **ct))}
"""

if __name__ == "__main__":
    tdir = os.path.join(MAC, "verification", "cace", "templates"); os.makedirs(tdir, exist_ok=True)
    templates(tdir)
    open(os.path.join(MAC, "verification", "cace", CELL + ".yaml"), "w").write(yaml())
    print("wrote", CELL)
