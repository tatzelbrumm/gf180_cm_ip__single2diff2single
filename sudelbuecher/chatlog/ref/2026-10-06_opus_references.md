# References used in 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md

Pointers only; nothing is copied.

## Literature

- H. J. Oguey and D. Aebischer, "CMOS current reference without resistance," IEEE J. Solid-State Circuits,
  vol. 32, no. 7, pp. 1132–1135, Jul. 1997. The topology of `macros/OgueyAebischerBias`.

## Sources cloned into the cloud container (GitHub)

- [fossi-foundation/globalfoundries-pdk-libs-gf180mcu_fd_pr](https://github.com/fossi-foundation/globalfoundries-pdk-libs-gf180mcu_fd_pr)
  @ `e11a8c9` (the commit open_pdks pins): ngspice models `sm141064`, `design`; xschem symbols. Device data,
  corners and mismatch coefficients (`fets_mm`) were read from here.
- [RTimothyEdwards/open_pdks](https://github.com/RTimothyEdwards/open_pdks), `gf180mcu/`: install layout,
  `custom/scripts/fix_xschemrc.py`, `make_primitive.py`, the pinned commits in `gf180mcu.json`.
- [StefanSchippers/xschem](https://github.com/StefanSchippers/xschem) @ `ce52727` (3.4.8RC), built from source.
- CACE 2.13.0 and Ciel 3.0.1 from PyPI (Ciel could not list releases: GitHub API blocked by the proxy).

## Local sources read on the computer

- IHP design: `~/EDA/sg13cmos5l_cm_ip__single2diff2single`, macro `OgueyAebischerBias` and the CACE run
  `RUN_2026-09-04_08-27-47` (templates, conditions, summary).
- IHP notes: `~/EDA/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/2026-09-04_opus_cace_templates_and_oab_sizing.md`
  (sizing analysis: loop amplification, mismatch, start-up threshold).
- `~/EDA/gf180mcu_ocd_io` @ `6e0e354`: `cells/asig_5p0` symbol and `netlist/schematic` SPICE of the analog pad.
- `~/EDA/gf180_cm_ip__gatekeeper/macros/inverter/verification/cace`: CACE template conventions.
- `~/EDA/chipalooza3`: GF180 xschem conventions (symbol paths, model include lines).
