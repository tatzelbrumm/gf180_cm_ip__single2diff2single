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
