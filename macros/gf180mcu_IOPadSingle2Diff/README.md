# gf180mcu_IOPadSingle2Diff

Analog input from the harness pad (`gf180mcu_ocd_io__asig_5p0`) → CDM protection → single-ended →
differential buffer. IHP counterpart: `sg13cmos5l_IOPadSingle2Diff` (an empty stub there as well).

**Status (2026-10-06): proof of concept, input side only.**

- `schematic/xschem/gf180mcu_IOPadSingle2Diff.sch/.sym`: ports `vdd outp vcm in outn vss` (IHP pin
  order; `vcm` moved to the input side of the symbol) and the CDM front end next to the gates, with Tim
  Edwards' numbers (FOSSi Chipalooza chat): series poly resistor > 50 Ω, diode perimeter > 25 µm.
  - `Rcdm` `ppolyf_u_1k_6p0` 5 µm × 1 µm (about 200 Ω; placeholder value), from `in` to `in_prot`
  - `Dcdmp` `diode_pd2nw_06v0` `in_prot` → `vdd`, `Dcdmn` `diode_nd2ps_06v0` `vss` → `in_prot`,
    each 2 µm × 12 µm (perimeter 28 µm)
  - The buffer itself is not designed: `in_prot`, `vcm`, `outp`, `outn` are unconnected, so xschem
    reports `outp`/`outn` as undriven.
- `testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch`: DC sweep of the pad voltage through the real
  pad cell (DVDD = 5 V) into the macro. Its `xschemrc` adds `$PDK_ROOT/$PDK/libs.ref` to the library path,
  so the pad is referenced as `gf180mcu_ocd_io/xschem/gf180mcu_ocd_io__asig_5p0.sym` and its netlist
  comes from `libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice` (open_pdks install layout).
- `verification/cace/gf180mcu_IOPadSingle2Diff.yaml`, `input_params`: current into `in` and the
  voltage at `in_prot` for pad voltages −0.3 … 5.5 V, diode/resistor corners typical/ss/ff, −40/27/85 °C.
  CACE netlists templates with the PDK `xschemrc` and the templates folder only, so
  `verification/cace/templates/` holds a copy of the pad symbol (from `gf180mcu_ocd_io` @ `6e0e354`,
  made primitive as open_pdks does).

## Result: the input is not 5 V tolerant with diodes to a 3.3 V vdd

`verification/cace/results/gf180mcu_IOPadSingle2Diff/` (vdd = 3.3 V, DVDD = 5 V):

| Pad voltage | Current into `in` | `in_prot` (typical, 27 °C) |
| --- | --- | --- |
| −0.3 … 3.6 V | ≤ 1 nA at all corners and temperatures | follows the pad |
| 4.0 V | 0.01 µA (−40 °C) … 30 µA (85 °C, ff) | 4.0 V |
| 5.0 V | 2.0 … 3.9 mA | 4.34 V |
| 5.5 V | 3.4 … 6.4 mA | 4.38 V |

So the usable input range is about −0.3 V … vdd + 0.3 V. At a 5 V pad level the CDM diode to `vdd`
conducts milliamps and the gate node sits at 4.3–4.4 V, above the 3.3 V device rating. The pad's own
HBM diodes go to DVDD/DVSS and do not help here. Options for the designer: state the limit in
`docs/OPERATING_LIMITS.md`, or tie the CDM diodes and the input devices to a 5 V supply with `*_06v0`
devices (see the 06v0 variant of `macros/OgueyAebischerBias`).
