<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# External sources used by the 2026-11-26 pad structure and ESD exploration session (indexed, not copied)

- gf180mcuD PDK as installed in the cloud environment (open_pdks `e7a6777`, via ciel): `libs.ref/gf180mcu_ocd_io/{spice,lef,lib,mag,gds,verilog,xschem}`, `libs.ref/gf180mcu_fd_io/cdl`, `libs.tech/ngspice/sm141064.ngspice`, `libs.tech/klayout/tech/{gf180mcu.lyp,drc/rule_decks/*.rb}`, `libs.tech/magic/gf180mcuD.tech`, `.config/nodeinfo.json`.
- [tatzelbrumm/gf180mcu_ocd_chipalooza](https://github.com/tatzelbrumm/gf180mcu_ocd_chipalooza), `main` at `2f18cd4` (harness fork): `config.txt`, `README`, `scripts/gen_padframe.tcl`, `scripts/get_project_gds.sh`, `magic/gf180mcu_padframe.mag`, `magic/slot16_wrapper.mag`, `verilog/gl/gf180mcu_padframe.v`, `verilog/rtl/chipalooza_frame.v`, `verilog/rtl/slot16_wrapper.v`; branch `sudel_buecher`: `sudelbuecher/chatlog_tools/`, `sudelbuecher/harness_tools/fixes/pad_pins/ANALYSIS.md`.
- [tatzelbrumm/claude-cloud-config](https://github.com/tatzelbrumm/claude-cloud-config), `main` at `39d01fc`: `README.md`, `CLAUDE.md`, `parts/pdk-gf180mcuD.sh`.
- [tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single](https://github.com/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single): `claude/c3-s2d-pad-layout` at `c913388` (`scripts/pcells/`), `claude/c3-s2d-pad-layout-sudel` at `0e98d06` (`Claude/skills/ihp-flat-cell-to-pcell/SKILL.md`).
- [google/gf180mcu-pdk](https://github.com/google/gf180mcu-pdk) at `de3240d`: `docs/physical_verification/design_manual/` (chapter 14: latch-up rules, ESD layout guidelines, ESD characterization data; `tables_clear/*.csv`, `images/`). Rendered at <https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_14_4.html> and following pages.
- [RTimothyEdwards/gf180mcu_ocd_io](https://github.com/RTimothyEdwards/gf180mcu_ocd_io) at `6e0e354`: `README.rst`, `TODO`, `docs/analog.rst`, `docs/power.rst`, `docs/specs/15_Operating_Conditions.csv`, `docs/specs/16_ESD_Protection.csv`, `docs/specs/Analogue_Signal_Cells{1,2}.png`.
- Foundry I/O library datasheet pages: <https://gf180mcu-pdk.readthedocs.io/en/latest/IPs/IO/gf180mcu_fd_io/index.html> (`analog`, `esd`, `latchup`, `conditions`, `power`, `specs`, `features`, `functional`).
- <https://evampire.readthedocs.io/en/latest/esd/io-cells.html> and the sibling pages `index`, `simulation`, `references`, `layout`, `cells` under `/esd/`: read by a subagent; treated as unverified (see `docs/PAD_STRUCTURES.md` section 8 on the branch `pad_esd_exploration`). Its source repository `github.com/mithro/evampire` was not read.
- <https://en.wikipedia.org/wiki/Snapback_(electrical)>: fetched for availability only, not used as a source.
