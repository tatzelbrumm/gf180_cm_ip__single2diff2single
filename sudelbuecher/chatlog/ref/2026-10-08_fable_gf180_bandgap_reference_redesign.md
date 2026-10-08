<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# External sources used by the 2026-10-08/09 bandgap reference session (indexed, not copied)

- H. Banba et al., "A CMOS bandgap reference circuit with sub-1-V operation," IEEE JSSC 34(5), 1999 — the current-mode core (as the IHP `bg_core`).
- Self-biased wide-swing cascode mirror with a resistor between the gate lines: R. J. Baker, *CMOS Circuit Design, Layout, and Simulation*, ch. 20 (wide-swing current mirrors).
- gf180mcuD PDK (open_pdks 1689ac3 via ciel): `libs.tech/ngspice/sm141064.ngspice` (device models, mismatch, PNP, well diodes, resistors), `libs.tech/klayout/tech/drc/rule_decks/{dnwell,lvpwell,nwell,hres,pres}.rb` (DNW / p-well / resistor rules), `libs.tech/klayout/tech/lvs/rule_decks/{mos_extraction,diode_extraction}.lvs` (how LVS sees a DNW NMOS and the well diodes).
- Tool sources per `sg13cmos5l_…_sudelbuecher/sudelbuecher/cloud_environment.md` (xschem ddc73448, ngspice-47 mirror, ciel release asset).
