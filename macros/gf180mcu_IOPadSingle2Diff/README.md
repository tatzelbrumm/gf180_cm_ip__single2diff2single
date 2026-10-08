# gf180mcu_IOPadSingle2Diff

Analog input from the harness pad (`gf180mcu_ocd_io__asig_5p0`) → CDM protection → single-ended →
differential buffer. IHP counterpart: `sg13cmos5l_IOPadSingle2Diff` (an empty stub there as well).

**Status (2026-10-06): proof of concept, input side only. 2026-10-08: enable added (see below).**

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

## Enable (2026-10-08)

`scripts/add_input_enable.py` added, as a one-time edit of the sheet and symbol:

- `InputEnable` (macro `PadEnable`) behind the CDM network: transmission gate `in_prot` → `in_en` while `en` = 1;
  while `en` = 0 it opens and a second gate parks `in_en` on `vcm`. `in_en` is where the single-ended →
  differential buffer will connect (still not designed).
- `EnableInv` for `en_b`; new port **`en`**, last in the port list (`vdd outp vcm in outn vss en`).
- The testbench and the CACE template tie `en` to vdd.

The CACE input deck, rerun with the enable. The files in `verification/cace/results/` now hold this run; the table above is the 2026-10-06 run without the enable:

| Pad voltage | Current into `in` | `in_prot` (max over corners) |
| --- | --- | --- |
| −0.3 V | −42 nA … −0.08 nA | −0.3 V |
| 0 … 3.6 V | ≤ 5.3 nA | follows the pad |
| 4.0 V | 12 … 72 µA | 4.0 V |
| 5.0 V | 2.3 … 4.8 mA | 4.29 V |
| 5.5 V | 3.8 … 7.5 mA | 4.30 V |

The input transmission gate adds junctions on `in_prot`: its PMOS drain to the n-well on vdd is one more diode to
vdd (more current above vdd + 0.6 V, slightly lower `in_prot`), its NMOS drain one more to vss (−42 nA at −0.3 V,
hot). The conclusion is unchanged: the input is not 5 V tolerant with these diodes and a 3.3 V vdd.

