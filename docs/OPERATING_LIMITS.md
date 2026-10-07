# Operating limits (to be filled in)

Required by the harness maintainer: if a 5 V input would destroy the circuit, say so here.

| Quantity | Value | Status |
| --- | --- | --- |
| Supply (analog) | 3.3 V assumed; 5 V optional | open. Bias macro simulated at 3.0–3.6 V (`03v3` variant) and 3.0–5.5 V (`06v0` variant), 2026-10-06 |
| Digital control levels (dig_in/dig_out) | 3.3 V | from Tim Edwards |
| `vin` / `vout` / `vcm` pad voltage range | `vin`: −0.3 V … vdd + 0.3 V with the current CDM front end (diodes to the 3.3 V vdd); `vout`, `vcm` open | `vin` simulated (proof-of-concept front end, see below); decision open |
| Absolute max on `vin` | with diodes to a 3.3 V vdd: 5 V on the pad drives 2.0–3.9 mA into the CDM diode to vdd and puts 4.3–4.4 V on the protected gate node, above the 3.3 V device rating, so the input is **not** 5 V tolerant | simulated; design decision open |
| Temperature range | −40 … 85 °C used in all CACE decks | assumed |

## Input range, simulated (2026-10-06)

Source: `macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/` (CACE `input_params`). Harness pad
`gf180mcu_ocd_io__asig_5p0` with DVDD = 5 V, followed by the proof-of-concept CDM front end (about 200 Ω
`ppolyf_u_1k_6p0`, diodes of 28 µm perimeter to vdd = 3.3 V and to vss); diode/resistor corners
typical/ss/ff, −40/27/85 °C.

| Pad voltage | Current into the macro | Protected gate node |
| --- | --- | --- |
| −0.3 … 3.6 V | ≤ 1 nA | follows the pad |
| 4.0 V | 0.01 µA (−40 °C) … 30 µA (85 °C) | 4.0 V |
| 5.0 V | 2.0 … 3.9 mA | 4.34 V (typical, 27 °C) |
| 5.5 V | 3.4 … 6.4 mA | 4.38 V |

The pad's own HBM diodes go to DVDD/DVSS and do not conduct in this range. To accept 5 V levels, the CDM
diodes and the input devices would have to sit on a 5 V supply (`*_06v0` devices).
