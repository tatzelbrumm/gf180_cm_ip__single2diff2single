#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes PadEnable/TGate (CMOS transmission gate, GF180MCU 03v3) once; afterwards the .sch/.sym are the
source of truth. Symbol pins a b en en_b; bulks VDD VSS are instance properties (`extra`), like the Avalon
gf180mcu_as_sc_mcu7t3v3 standard cells; sizes W_N L_N W_P L_P (not Ln: ngspice reads that as ln()).
Usage: gen_tgate.py <PadEnable/schematic/xschem>
History: the sheet was redrawn by Christoph Maier on 2026-10-09 (horizontal devices, parallel between a and b), and
on 2026-10-10 the symbol got real VDD/VSS pins instead of `extra` properties (xschem's symbol/schematic pin check
rejects `extra` on a symbol that has a schematic). The .sch/.sym in the folder are the reference; this script
reproduces neither and is kept only as a record."""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "scripts"))
from xsheet import Sheet, esc
d = sys.argv[1]
s = Sheet()
s.text("TGate", 60, -560, 0.5)
for i, l in enumerate(["CMOS transmission gate a <-> b: on when en = vdd (en_b = vss).",
                       "Parameters W_N L_N (NMOS), W_P L_P (PMOS); nf=1. Bulks on the instance properties VDD, VSS",
                       "(symbol pins are a b en en_b only, like the Avalon standard cells)."]):
    s.text(l, 60, -500 + 22 * i, 0.25)
s.text("GF180MCU (gf180mcuD), 03v3 devices; written 2026-10-09, edit the sheet from now on.", 60, 120, 0.2, 4)
# both devices drawn source/drain up = a, down = b (drain and source are interchangeable)
s.fet("p", "MP", 220, -150, "b", "en_b", "a", "VDD", W=r"\{W_P\}", L=r"\{L_P\}")
s.fet("n", "MN", 460, -150, "a", "en", "b", "VSS", W=r"\{W_N\}", L=r"\{L_N\}")
s.wire(60, -220, 640, -220, "a"); s.wire(60, -80, 640, -80, "b")
for x in (240, 480):
    s.wire(x, -200, x, -220, "a"); s.wire(x, -100, x, -80, "b")
s.pin("iopin", 60, -220, "a"); s.pin("iopin", 640, -80, "b", right=True)
s.pin("ipin", 60, -320, "en_b"); s.pin("ipin", 60, -360, "en")
s.pin("iopin", 60, 40, "VDD"); s.pin("iopin", 60, 80, "VSS")
s.write(f"{d}/TGate.sch")
open(f"{d}/TGate.sym", "w").write('''v {xschem version=3.4.8RC file_version=1.3}
G {}
K {type=subcircuit
format="@name @pinlist @VDD @VSS @symname W_N=@W_N L_N=@L_N W_P=@W_P L_P=@L_P"
template="name=x1 VDD=vdd VSS=vss W_N=1u L_N=0.5u W_P=1u L_P=0.5u"
extra="VDD VSS"
}
V {}
S {}
F {}
E {}
L 4 -40 0 -20 0 {}
L 4 20 0 40 0 {}
L 4 -20 -15 -20 15 {}
L 4 -20 -15 20 15 {}
L 4 -20 15 20 -15 {}
L 4 20 -15 20 15 {}
L 4 0 -40 0 -18 {}
A 4 0 -11.5 3.5 0 360 {}
L 4 0 40 0 8 {}
B 5 -42.5 -2.5 -37.5 2.5 {name=a dir=inout}
B 5 37.5 -2.5 42.5 2.5 {name=b dir=inout}
B 5 -2.5 37.5 2.5 42.5 {name=en dir=in}
B 5 -2.5 -42.5 2.5 -37.5 {name=en_b dir=in}
T {a} -38 -14 0 0 0.15 0.15 {}
T {b} 38 -14 0 1 0.15 0.15 {}
T {en} 4 24 0 0 0.15 0.15 {}
T {en_b} 4 -36 0 0 0.15 0.15 {}
T {@name} 25 18 0 0 0.2 0.2 {}
T {n @W_N/@L_N p @W_P/@L_P} -40 -58 0 0 0.15 0.15 {}
''')
