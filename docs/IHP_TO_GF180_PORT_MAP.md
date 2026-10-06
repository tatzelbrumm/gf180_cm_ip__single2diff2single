# IHP sg13cmos5l → GF180 gf180mcuD port map

Names marked (v) were seen in PDK/library sources; the rest must be verified against the installed PDK.

| Topic | IHP (current design) | GF180 | Notes |
| --- | --- | --- | --- |
| PDK env | `ihp-sg13cmos5l` | `gf180mcuD` | `.designinit` done |
| Core FETs | `sg13_lv_nmos/pmos` | `nfet_03v3` / `pfet_03v3` (v) | sizing must be re-derived, no copy of W/L |
| I/O-voltage FETs | `sg13_hv_*` | `nfet_06v0` / `pfet_06v0` (v) | one device for 5 V and 6 V; there is no `*_05v00` |
| High-value resistor | `rhigh` | `ppolyf_u_1k` (v) | 1 kΩ/sq |
| MiM / MOM caps | MOM Miller caps, MiM | `cap_mim_2p0fF` (v) | confirm type B; MOM not assumed available |
| Analog pad | `sg13cmos5l_IOPadAnalog` (with clamps) | `gf180mcu_ocd_io__asig_5p0` (v) | HBM diodes only; add own CDM diode (perimeter > 25 µm) and poly resistor (> 50 Ω) next to gates |
| Clamp pcells | `scripts/pcells/Clamp_*` (IHP-specific) | none yet | new CDM clamp work, deferred |
| Metal stack | 5 metals + TopMetal1/2 | 3LM/4LM/5LM pad views exist (v) | pick the shuttle's stack; thick top metal option |
| PR boundary | GDS layer 189 (`scripts/check_boundary.py`) | layer 0, datatype 0 (`PR_bndry 0/0` in `gf180mcu.lyp`; `calma BOUND 0 0` in `gf180mcuD.tech`) | script updated 2026-10-06; read from PDK sources only, not checked against a real GF180 GDS or the harness precheck |
| Magic rc | `ihp-sg13cmos5l.magicrc` | `gf180mcuD.magicrc` | Makefile retargeted 2026-10-06 |
| Render tech | `sak-render.py -t ihp-sg13cmos5l` | `gf180mcuD` via `RENDER_TECH` | Makefile variable; `gf180mcuD` is listed by `sak-pdk` in the container (user check 2026-10-06), not yet run through `sak-render.py` |
| Slot/floorplan | `floorplan/chipalooza_template_*.gds` | none | IHP GDS files removed 2026-10-06; wait for the harness |
| Digital supply | `vdd_1v2` | 3.3 V per Tim | domain structure to confirm |
| Layout paths in the Makefile | flat `layout/<TOP>.gds`, then `layout/{klayout,gds}` with `.klay.gds` fallback | strict `layout/gds/<cell>.gds` (`LAY_GDS_DIR`), no fallback | done 2026-10-06; `layout/klayout` and `layout/magic` are never read by a target |
| Top cell name | `sg13cmos5l_cm_ip__single2diff2single` | `gf180_cm_ip__single2diff2single` | `Makefile`, `submission.yaml` done; the GDS cell name inside `layout/gds/` is still to be set when the layout exists |
| Macros | `sg13cmos5l_IOPadSingle2Diff`, `sg13cmos5l_IOPadDiff2Single`, plus template `inverter`, `counter` | `gf180mcu_IOPadSingle2Diff`, `gf180mcu_IOPadDiff2Single` | template `inverter` and `counter` removed; each new macro has a Makefile (CACE targets dropped), `xschemrc` files and `scripts/check_pex_ports.py`; none has been run |
| `xschemrc` PDK default | `ihp-sg13cmos5l` | `gf180mcuD` | all six files done; the GF180 PDK `libs.tech/xschem/xschemrc` exists in the PDK source tree |
| `submission.yaml` | IHP values | name, description rewritten | `slot-size` and `analog-pins` still the IHP values, marked unverified |
| KPEX | supported for IHP | no verified GF180 support | use the Magic PEX targets; the Makefile prints a note |
