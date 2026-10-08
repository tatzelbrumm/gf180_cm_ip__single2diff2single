#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""One-time edit (2026-10-08): adds the enable to gf180mcu_IOPadSingle2Diff. InputEnable (PadEnable macro) behind
the CDM network: in_prot -> in_en while en = 1, in_en parked on vcm while en = 0; EnableInv makes en_b.
New port en, last in the port list. Afterwards the sheet is the source of truth.
Usage: add_input_enable.py <macros dir>"""
import os, sys
M = sys.argv[1]
sys.path.insert(0, os.path.join(M, "..", "scripts"))
from xsheet import Sheet, sym_pins
d = os.path.join(M, "gf180mcu_IOPadSingle2Diff", "schematic", "xschem")
P = lambda cell: sym_pins(os.path.join(M, "PadEnable", "schematic", "xschem", cell + ".sym"))
s = Sheet(); s.n = 100
s.pin("ipin", 60, -200, "en")
s.block("InputEnable.sym", "xinen", 900, -300, P("InputEnable"),
        dict(vdd="vdd", vss="vss", en="en", en_b="en_b", pin="in_prot", pout="in_en", vpark="vcm"))
s.block("EnableInv.sym", "xinv", 1300, -300, P("EnableInv"), dict(vdd="vdd", vss="vss", en="en", en_b="en_b"))
s.text("2026-10-08: enable added. InputEnable (macros/PadEnable) passes in_prot to in_en while en = 1 and parks in_en on vcm\n"
       "while en = 0; EnableInv makes en_b. in_en is where the single-ended -> differential buffer will connect.", 700, -520, 0.25, 4)
sch = os.path.join(d, "gf180mcu_IOPadSingle2Diff.sch")
t = open(sch).read().rstrip("\n")
t = t.replace("The single-ended -> differential buffer is NOT designed yet: in_prot, vcm, outp, outn\nare unconnected",
              "The single-ended -> differential buffer is NOT designed yet: in_en (behind InputEnable), outp, outn\nare unconnected")
open(sch, "w").write(t + "\n" + "\n".join(s.recs) + "\n")
sym = os.path.join(d, "gf180mcu_IOPadSingle2Diff.sym")
t = open(sym).read().rstrip("\n")
t += "\nL 4 -60 -20 -40 -20 {}\nB 5 -62.5 -22.5 -57.5 -17.5 {name=en dir=in }\nT {en} -35 -26 0 0 0.2 0.2 {}\n"
open(sym, "w").write(t)
print("edited", sch, sym)
