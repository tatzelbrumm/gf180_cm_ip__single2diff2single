#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes gf180mcu_IOPadDiff2Single.sch/.sym once (2026-10-08); afterwards the sheet is the source of truth.
Block level: ClassABBiasIn (bias tree, fed by iref through BiasRefEnable), ClassABDriver (vfb = out),
DriverEnable and EnableInv (PadEnable macro). Pins of the blocks get a stub and a net label.
Usage: gen_iopad_d2s.py <macros dir>"""
import os, sys
M = sys.argv[1]
sys.path.insert(0, os.path.join(M, "..", "scripts"))
from xsheet import Sheet, symbol, sym_pins

def P(macro, cell):
    return sym_pins(os.path.join(M, macro, "schematic", "xschem", cell + ".sym"))

d = os.path.join(M, "gf180mcu_IOPadDiff2Single", "schematic", "xschem")
order = ["vdd", "vss", "vddo", "vsso", "inp", "inn", "vref", "out", "iref", "en"]
symbol(os.path.join(d, "gf180mcu_IOPadDiff2Single.sym"),
       left=[("inp", "in"), ("inn", "in"), ("vref", "in"), ("iref", "inout"), ("en", "in")], right=[("out", "inout")],
       top=[("vdd", "inout"), ("vddo", "inout")], bottom=[("vss", "inout"), ("vsso", "inout")], order=order,
       text="class-AB, vout - vref = (inp - inn)/2")
s = Sheet()
s.text("gf180mcu_IOPadDiff2Single: class-AB differential -> single-ended pad driver with enable (PROOF OF CONCEPT, 2026-10-08)", 60, -1160, 0.5)
for i, l in enumerate([
    "Blocks: ClassABBiasIn (macros/ClassABBias): bias tree and the six diodes, fed by iref (5 uA into the pad) through BiasRefEnable.",
    "ClassABDriver (macros/ClassABDriver): matched-pair DDA, folded cascode, class-AB output OP / ON, Miller compensation; vfb = out, so out - vref = (inp - inn)/2.",
    "DriverEnable, EnableInv (macros/PadEnable): en = 0 -> OP / ON gates tied to vddo / vsso, vabp / vabn to vdd / vss, iref cut off and NI's gate line to vss.",
    "Bias enters as a current (iref), never as a voltage. vddo / vsso: output-stage rails (OP, ON and their replicas RP1, RN1).",
    "Not included yet: CDM / ESD network at out (OP and ON are meant to double as the pad clamps, IHP case (a)); a level shifter for a 1.2 V enable."]):
    s.text(l, 60, -1100 + 24 * i, 0.25)
for i, n in enumerate(["vdd", "vss", "vddo", "vsso"]):
    s.pin("iopin", 60, -900 + 20 * i, n, right=True)
for i, n in enumerate(["inp", "inn", "vref"]):
    s.pin("ipin", 60, -800 + 20 * i, n)
s.pin("iopin", 60, -720, "iref", right=True); s.pin("ipin", 60, -700, "en")
s.pin("iopin", 1800, -800, "out")
rails = dict(vdd="vdd", vss="vss", vddo="vddo", vsso="vsso")
bias = ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]
s.block("ClassABBiasIn.sym", "xbias", 800, -500, P("ClassABBias", "ClassABBiasIn"), dict(rails, iref="iref_en", **{b: b for b in bias}))
s.block("BiasRefEnable.sym", "xref", 360, -500, P("PadEnable", "BiasRefEnable"),
        dict(vdd="vdd", vss="vss", en="en", en_b="en_b", iin="iref", iout="iref_en"))
s.block("ClassABDriver.sym", "xdrv", 1400, -560, P("ClassABDriver", "ClassABDriver"),
        dict(rails, vinp="inp", vinn="inn", vref="vref", vout="out", vfb="out", a="a", b="b", **{b: b for b in bias}))
s.block("DriverEnable.sym", "xen", 1400, -160, P("PadEnable", "DriverEnable"),
        dict(rails, en="en", en_b="en_b", a="a", b="b", vabp="vabp", vabn="vabn"))
s.block("EnableInv.sym", "xinv", 360, -160, P("PadEnable", "EnableInv"), dict(vdd="vdd", vss="vss", en="en", en_b="en_b"))
s.write(os.path.join(d, "gf180mcu_IOPadDiff2Single.sch"), title=True)
print("wrote", d)
