#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the PadEnable cells (GF180MCU gf180mcuD, 03v3 devices) once; afterwards the .sch/.sym are
the source of truth. Switch plan from the IHP power_down session (2026-10-06, sg13cmos5l notes worktree,
design_considerations/class_ab_pad_driver/power_down/log.md, 17:10 entry), moved out of the driver and bias
cells into cells of their own:

  EnableInv      en -> en_b, one per pad (the place for a level shifter when the enable comes from 1.2 V logic)
  DriverEnable   disabled: a (OP gate) -> vddo, b (ON gate) -> vsso, vabp -> vdd, vabn -> vss
  BiasRefEnable  transmission gate iin -> iout (enabled); disabled: iout (NMOS input diode's gate line) -> vss
  InputEnable    transmission gate pin -> pout (enabled); disabled: pout parked on vpark by a second gate

All switches are on while disabled and off while enabled; en is active high (0 / vdd).
Usage: gen_padenable.py <PadEnable/schematic/xschem>"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "scripts"))
from xsheet import Sheet, symbol

SW = dict(W="1u", L="0.5u")
INV_P, INV_N = dict(W="2u", L="0.5u"), dict(W="1u", L="0.5u")
TG = dict(W="4u", L="0.5u")

def title(s, cell, lines):
    s.text(cell, 60, -560, 0.5)
    for i, l in enumerate(lines):
        s.text(l, 60, -500 + 22 * i, 0.25)
    s.text("GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.", 60, 120, 0.2, 4)

def enable_inv(d):
    pins = symbol(f"{d}/EnableInv.sym", left=[("en", "in")], right=[("en_b", "out")], top=[("vdd", "inout")],
                  bottom=[("vss", "inout")], order=["vdd", "vss", "en", "en_b"])
    s = Sheet()
    title(s, "EnableInv", ["en_b = not en, on vdd / vss. One per pad.",
                           "When the enable comes from 1.2 V logic, a level shifter replaces this cell."])
    s.wire(60, -300, 400, -300, "vdd"); s.wire(60, 0, 400, 0, "vss")
    s.pin("iopin", 60, -300, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("ipin", 60, -150, "en"); s.pin("opin", 400, -150, "en_b")
    s.fet("p", "MP", 200, -220, "en_b", "en", "vdd", "vdd", top_rail=-300, **INV_P)
    s.fet("n", "MN", 200, -60, "en_b", "en", "vss", "vss", bot_rail=0, **INV_N)
    s.write(f"{d}/EnableInv.sch", title=True)
    return pins

def driver_enable(d):
    order = ["vdd", "vss", "vddo", "vsso", "en", "en_b", "a", "b", "vabp", "vabn"]
    pins = symbol(f"{d}/DriverEnable.sym", left=[("en", "in"), ("en_b", "in")],
                  right=[("a", "inout"), ("vabp", "inout"), ("vabn", "inout"), ("b", "inout")],
                  top=[("vdd", "inout"), ("vddo", "inout")], bottom=[("vss", "inout"), ("vsso", "inout")], order=order)
    s = Sheet()
    title(s, "DriverEnable", ["Disable switches of ClassABDriver, on while en = 0:",
                              "SA: a (gate of OP) to vddo, SB: b (gate of ON) to vsso -- OP and ON off, gates tied to their own rails as in a clamp;",
                              "SABP: vabp to vdd, SABN: vabn to vss -- otherwise ABP / ABN conduct from the a pull-up into the b pull-down.",
                              "SA and SB sit on the output-stage rails vddo / vsso (n-well of SA on vddo, SB in ON's tap ring on vsso)."])
    s.wire(60, -340, 560, -340, "vddo"); s.wire(60, -320, 560, -320, "vdd")
    s.wire(60, 0, 560, 0, "vss"); s.wire(60, 20, 560, 20, "vsso")
    s.pin("iopin", 60, -320, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("iopin", 60, -340, "vddo", right=True); s.pin("iopin", 60, 20, "vsso", right=True)
    for i, (k, n) in enumerate([("ipin", "en"), ("ipin", "en_b")]):
        s.pin(k, 60, -200 + 40 * i, n)
    for i, n in enumerate(["a", "b", "vabp", "vabn"]):
        s.pin("iopin", 640, -220 + 40 * i, n)
    s.fet("p", "SA", 200, -220, "a", "en", "vddo", "vddo", top_rail=-340, **SW)
    s.fet("p", "SABP", 400, -220, "vabp", "en", "vdd", "vdd", top_rail=-320, **SW)
    s.fet("n", "SB", 200, -60, "b", "en_b", "vsso", "vsso", bot_rail=20, **SW)
    s.fet("n", "SABN", 400, -60, "vabn", "en_b", "vss", "vss", bot_rail=0, **SW)
    s.write(f"{d}/DriverEnable.sch", title=True)
    return pins

def bias_ref_enable(d):
    order = ["vdd", "vss", "en", "en_b", "iin", "iout"]
    pins = symbol(f"{d}/BiasRefEnable.sym", left=[("iin", "inout"), ("en", "in"), ("en_b", "in")], right=[("iout", "inout")],
                  top=[("vdd", "inout")], bottom=[("vss", "inout")], order=order)
    s = Sheet()
    title(s, "BiasRefEnable", ["Reference-current switch in front of ClassABBiasIn (NMOS input diode NI):",
                               "TGN / TGP pass iin to iout while en = 1; while en = 0 they open and TDN pulls iout,",
                               "NI's gate line, to vss. The external reference is not relied on to switch off."])
    s.wire(60, -300, 560, -300, "vdd"); s.wire(60, 0, 560, 0, "vss")
    s.pin("iopin", 60, -300, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("ipin", 60, -180, "en"); s.pin("ipin", 60, -140, "en_b")
    s.pin("iopin", 60, -100, "iin", right=True); s.pin("iopin", 640, -100, "iout")
    s.fet("p", "TGP", 200, -220, "iout", "en_b", "iin", "vdd", top_rail=None, **SW)
    s.fet("n", "TGN", 200, -60, "iin", "en", "iout", "vss", bot_rail=None, **SW)
    s.fet("n", "TDN", 400, -60, "iout", "en_b", "vss", "vss", bot_rail=0, **SW)
    s.write(f"{d}/BiasRefEnable.sch", title=True)
    return pins

def input_enable(d):
    order = ["vdd", "vss", "en", "en_b", "pin", "pout", "vpark"]
    pins = symbol(f"{d}/InputEnable.sym", left=[("pin", "inout"), ("en", "in"), ("en_b", "in")],
                  right=[("pout", "inout"), ("vpark", "in")], top=[("vdd", "inout")], bottom=[("vss", "inout")], order=order)
    s = Sheet()
    title(s, "InputEnable", ["Input switch of an analog input pad, behind the CDM resistor:",
                             "TGN1 / TGP1 pass pin to pout while en = 1; while en = 0 they open and TGN2 / TGP2 park pout on vpark",
                             "(the common-mode reference), so the circuit behind the pad sees a defined input when the pad is off."])
    s.wire(60, -300, 760, -300, "vdd"); s.wire(60, 0, 760, 0, "vss")
    s.pin("iopin", 60, -300, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("ipin", 60, -180, "en"); s.pin("ipin", 60, -140, "en_b")
    s.pin("iopin", 60, -100, "pin", right=True); s.pin("iopin", 840, -140, "pout"); s.pin("ipin", 840, -100, "vpark")
    s.fet("p", "TGP1", 200, -220, "pout", "en_b", "pin", "vdd", **TG)
    s.fet("n", "TGN1", 200, -60, "pin", "en", "pout", "vss", **TG)
    s.fet("p", "TGP2", 500, -220, "vpark", "en", "pout", "vdd", **TG)
    s.fet("n", "TGN2", 500, -60, "pout", "en_b", "vpark", "vss", **TG)
    s.write(f"{d}/InputEnable.sch", title=True)
    return pins

if __name__ == "__main__":
    d = sys.argv[1]
    for f in (enable_inv, driver_enable, bias_ref_enable, input_enable):
        print(f.__name__, f(d))
