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
| PR boundary | GDS layer 189 (`scripts/check_boundary.py`) | unknown | verify the BOUND mapping in `gf180mcuD.tech` before reuse |
| Magic rc | `ihp-sg13cmos5l.magicrc` (Makefile line ~167) | `gf180mcuD.magicrc` | |
| Render tech | `sak-render.py -t ihp-sg13cmos5l` (Makefile line ~246) | `gf180mcuD` | |
| Slot/floorplan | `floorplan/chipalooza_template_*.gds` | none | wait for the harness |
| Digital supply | `vdd_1v2` | 3.3 V per Tim | domain structure to confirm |
