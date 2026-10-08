<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Sizing harness of the 2026-10-08 class-AB port (copied as a starting point)

Plain ngspice decks and two Python drivers, used to size the GF180 class-AB driver and bias before drawing
schematics. Needs `PDK_ROOT` (and `PDK`, default `gf180mcuD`) and ngspice on the path.

| file | content |
|---|---|
| `bias_ref_gf.spice` | `d2s_bias_diodes`, `d2s_bias_in`, `d2s_bias_out` with the GF180 sizes (= the `ClassABBias` sheets) |
| `units_gf.spice`, `mpdda_gf.spice`, `bias_lp_gf.spice` | DDA unit, driver, ideal bias fixture (= the `ClassABDriver` sheets) |
| `run_bias_gf.py` | the six bias currents (0 V sources in the diode drains) over MOS/res corners, temperature, supply. Variant keys `in out oa bg`: `oa`/`bg` expect subckts `d2s_bias_oa` / `d2s_bias_bg` with an `Xt` instance of `d2s_bias_in` (IHP structure); add their netlist file to `FILES` |
| `run_gf.py` | driver on the ideal fixture: op, loop gain, DC transfer; `tt`, `corners`, `loads` |

```
python3 run_bias_gf.py in out          # current errors, % of 5/5/2/2/5/5 uA
python3 run_gf.py corners
```

## 2026-10-09 — bandgap sizing (session 01Btt65c)

| file | content |
|---|---|
| `bg_gf.spice` | `bg_core` / `bg_core_dn` (the GF180 bandgap core as sized; `.param` knobs at the top, defaults = the delivered `ClassABBiasBG`) and `d2s_bias_bg` / `d2s_bias_bgdn` with the tree |
| `run_bg.py` | sections `temp corners line startup mc` of one variant: `python3 run_bg.py var=bg_core_dn wp=48u line`; `RMODEL=ppolyf_u_1k` swaps the resistor type |
| `tune_r.py` | PTAT-share scan of the resistor lengths for a resistor type (`python3 tune_r.py bg_core 3k`) |

The driver with the reference: `run_gf.py` with `bias="Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_bg"` and
`extra` including `bias_ref_gf.spice`, `bg_gf.spice` and the bjt/diode model sections (see the log, 00:30).
