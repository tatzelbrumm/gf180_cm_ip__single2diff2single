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
| Macros | `sg13cmos5l_IOPadSingle2Diff`, `sg13cmos5l_IOPadDiff2Single`, `OgueyAebischerBias`, plus template `inverter`, `counter` | `gf180mcu_IOPadSingle2Diff`, `gf180mcu_IOPadDiff2Single`, `OgueyAebischerBias` (added 2026-10-06) | template `inverter` and `counter` removed; each new macro has a Makefile (CACE targets dropped), `xschemrc` files and `scripts/check_pex_ports.py`; none has been run |
| `xschemrc` PDK default | `ihp-sg13cmos5l` | `gf180mcuD` | all six files done; the GF180 PDK `libs.tech/xschem/xschemrc` exists in the PDK source tree |
| `submission.yaml` | IHP values | name, description rewritten | `slot-size` and `analog-pins` still the IHP values, marked unverified |
| Bias reference | `OgueyAebischerBias` + `ToBiasStartup` (`sg13_hv_*`, mirrors W = L = 1 µm, 47 nA, σ(I) ≈ 50 %, PSRR 24 dB) | `macros/OgueyAebischerBias`, cells `OgueyAebischerBias_<v>`, `ToBiasStartup_<v>`, `OgueyAebischerRef_<v>`, `<v>` = `03v3` / `06v0` (v) | 2026-10-06: topology and wiring unchanged, sizes re-derived (100 nA, σ(I1) ≈ 5 %); schematic netlist checked device by device against the IHP netlist; CACE suite ported and run. See the macro README |
| CACE corners | `cornerMOShv.lib mos_<tt,ss,…>`, `mos_tt_mismatch`, `cornerRES.lib res_<…>` | `design.ngspice` + `sm141064.ngspice <typical,ss,ff,sf,fs>`; mismatch with `.param sw_stat_mismatch=1` (no `*_mismatch` corner); `diode_<c>`, `res_<c>`, `moscap_<c>` sections (v) | used in the bias and input-pad decks |
| Mismatch model | `mm_ok=1`, `m` multiplies area | `fets_mm` draws one sample per instance and ignores `m` (v) | draw matched multi-unit devices as one instance with `nf` = units, `W` = units × W_unit |
| Model bin limit | – | W ≤ 100 µm per FET instance (v) | larger W fails with "could not find a valid modelname" |
| Analog pad in xschem | `sg13cmos5l_io/sg13cmos5l_IOPadAnalog.sym` | `gf180mcu_ocd_io/xschem/gf180mcu_ocd_io__asig_5p0.sym` with `$PDK_ROOT/$PDK/libs.ref` on the library path; netlist `libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice` (open_pdks layout) | used in `gf180mcu_IOPadSingle2Diff` testbenches; CACE templates need a copy of the symbol next to them |
| xschem version for CACE | 3.4.8 in the container | ≥ 3.4.8 needed: 3.4.4 ignores `top_is_subckt` and rejects the BOM in the project `xschemrc` files | checked 2026-10-06 |
| Class-AB driver | `d2s_mpdda` + `unit_r2` (IHP notes worktree `design_considerations/class_ab_pad_driver/improvements/`) | `macros/ClassABDriver`: `ClassABDriver`, `ClassABUnitR`, fixture `ClassABDriverBiased` | 2026-10-08: hand-drawn IHP sheets ported (wires kept), sizes re-derived: tails 20u/6u, OP/ON split with `m` (bin limit), rhigh → `ppolyf_u_3k`; ports `a b` added for the enable |
| Driver bias | `d2s_bias_in`, `_out`, `d2s_bias_lp` (+ `_oa`, `_bg`) | `macros/ClassABBias`: `ClassABBiasIn`, `ClassABBiasOut`, `ClassABBiasIdeal` | 2026-10-08; `_oa` and `_bg` not ported (need a GF180 re-design) |
| Enable / power-down | switches inside every `_pd` cell (`power_down/`) | `macros/PadEnable`: `EnableInv`, `DriverEnable`, `BiasRefEnable`, `InputEnable` | 2026-10-08: same switch plan, as cells of their own; `en` 0 / vdd |
| Degeneration resistor | `rhigh` (body = attribute) | `ppolyf_u_3k` (v), bulk is a pin (M P B) | TC −0.17 %/K vs −0.22 %/K |
| KPEX | supported for IHP | no verified GF180 support | use the Magic PEX targets; the Makefile prints a note |
