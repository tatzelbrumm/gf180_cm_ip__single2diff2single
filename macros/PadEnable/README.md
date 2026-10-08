<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# PadEnable (GF180MCU)

Enable circuits of the analog pads, as cells of their own instead of switches spread through the driver and bias
cells (as in the IHP `power_down/` study, 2026-10-06, whose switch plan they implement). `en` is active high,
0 / vdd; every switch is **on while disabled** and off while enabled.

**Status: proof of concept (2026-10-08).** Schematics and symbols; tested inside the pads
(`../gf180mcu_IOPadDiff2Single` CACE `off_params`, `enable_params`). No layout.

| cell | ports | devices (03v3) | function |
|---|---|---|---|
| `EnableInv` | vdd vss en en_b | MP 2u/0.5u, MN 1u/0.5u | en_b for the other cells, one per pad. A 1.2 V → 3.3 V level shifter replaces it when the enable comes from 1.2 V logic |
| `DriverEnable` | vdd vss vddo vsso en en_b a b vabp vabn | SA, SABP (pfet), SB, SABN (nfet), 1u/0.5u | disabled: a (gate of OP) → vddo, b (gate of ON) → vsso, so OP / ON are off with their gates tied to their own rails as in a clamp; vabp → vdd, vabn → vss, otherwise ABP / ABN would conduct from the a pull-up into the b pull-down |
| `BiasRefEnable` | vdd vss en en_b iin iout | TGN, TGP, TDN 1u/0.5u | transmission gate iin → iout (the bias tree's iref) while enabled; disabled: open, and TDN pulls iout (gate line of the NMOS input diode NI) to vss. The external reference is not relied on to switch off |
| `InputEnable` | vdd vss en en_b pin pout vpark | TGN1/TGP1, TGN2/TGP2 4u/0.5u | input switch behind the CDM network: pin → pout while enabled; disabled: pout parked on vpark (the common-mode reference) |

SA and SB sit on the output-stage rails: SA's n-well on vddo, SB in ON's tap ring on vsso.

`scripts/gen_padenable.py` wrote the sheets and symbols (rails as wires, sources and bulks wired to them, gates
and drains by stub and label); `scripts/padenable_reference.spice` is the reference netlist, checked with
`../ClassABDriver/scripts/check_classab_port.py` (MISMATCHES 0). The first draft had a PMOS and an NMOS drain stub
meet at one point, which merged iin with iout; the round trip caught it.

## What the IHP study found that carries over (not re-simulated here unless stated)

- The bias lines without a switch (vbp, vbpc, vbn, vbnc) only carry leakage once the roots are off.
- Unpowered (no supply, en floating or 0): the pull-ups have no gate drive; ESD protection has to come from the
  pad's own network. Not modelled in GF180 yet.
- At enable, a and b are released at once while the bias is still coming up: an output glitch. GF180 pad CACE:
  170–490 mV, settled within 1 mV after 1.3–1.5 µs.
