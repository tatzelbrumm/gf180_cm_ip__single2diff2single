<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# References — 2026-11-13 to 2026-11-20 — Sonnet/Opus cloud-config and GF180 harness session

Sources consulted for
[`../2026-11-13_sonnet-opus_iic_osic_tools_cloud_config_setup.md`](../2026-11-13_sonnet-opus_iic_osic_tools_cloud_config_setup.md),
indexed per this directory's rule (index, do not copy). Commits are the ones read in this session; "read" means
cloned or fetched into the session's cloud container unless a path on the user's computer is given.

## The harness

- <https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza> (`origin`), the user's fork
  <https://github.com/tatzelbrumm/gf180mcu_ocd_chipalooza> (`tatzelfork`), local `~/EDA/gf180mcu_ocd_chipalooza`.
  Commits by R. Timothy Edwards that the session relied on:
  - `b8d5ede` (2026-10-11): first population; `locking disable` in `gen_padframe_template.tcl`, `set_user_id.py` with
    the IHP via table.
  - `20cfe39` (2026-10-30): last commit of `gds/slot*_wrapper.gds`.
  - `350eb4c` (2026-11-01): shortened Metal5 in `project_control_area.mag`, regenerated slot wrapper `.mag`.
  - `cd6eca2` (2026-11-02): timestamps of vendor-GDS cells with new Magic and Tim's newest PDK.
  - `ba9976e`, `060a4e5` (2026-11-18): padframe template labels.
  - `bf1d19b` (2026-11-19): padframe corrections, top-left corner (unfinished), `generate_fill.py` removed, fill moved
    into `run_gen_filled_final_gds.sh`.
- Files read in it: `README`, `Makefile`, `config.txt`, `scripts/gen_padframe*.tcl`, `scripts/run_gen_*.sh`,
  `scripts/set_user_id.py`, `scripts/generate_fill.py`, `scripts/layout_setup.tcl`, `scripts/check_staleness.py`,
  `magic/*.mag` (padframe, frame, wrappers, `project_control_area`, `user_id_vias*`, `sealring/`), `gds/`.
- <https://github.com/RTimothyEdwards/gf180mcu_ocd_io>, local `~/EDA/gf180mcu_ocd_io` at `6e0e354`: `magic/` views,
  `cells/*/*_5lm.gds.gz`.

## Magic

- <https://github.com/RTimothyEdwards/magic>; local `~/EDA/magic` (remotes `Tim`, `tatzelfork` =
  <https://github.com/tatzelbrumm/magic>).
  - Versions and commits: 8.3.685 (IIC-OSIC-TOOLS 2026.10), 8.3.690 `eeb1052` (relative `GDS_FILE` paths), 8.3.691
    `6f32dde` (timestamps of GDS-derived cells from the GDS data), 8.3.693 `9fd4ee5`, 8.3.704, 8.3.705 `cc0360b`
    (2026-11-18).
  - `1a6e9e5` (2026-11-18): initializes `is_locked` in `database/DBio.c`, the bug found here on 2026-11-19 and
    independently by Belal El-Shinnawey; `cc0360b` adds a regression test for `locking disable`.
  - Source read: `database/DBio.c` (`dbReadOpen`, `file_is_not_writeable`, timestamp checks), `database/DBcellname.c`
    (`DBAbutmentUse`), `commands/CmdCD.c`, `commands/CmdSubrs.c` (`cmdSaveCell`, `cmdCheckNewName`), `utils/path.c`.
- Patch written here: `_runs/magic-is_locked-init.patch`, copy `../logs/main/2026-11-19_opus_magic-is_locked-init.patch`
  (superseded by `1a6e9e5`).

## PDK

- <https://github.com/RTimothyEdwards/open_pdks> (same branches as <https://github.com/fossi-foundation/open_pdks>):
  - `1689ac3` (2026-08-27), the PDK of IIC-OSIC-TOOLS 2026.10 (`1.0.588-62-g1689ac3`);
  - `e7a6777d157a9d94c7ac757457b9e4309e9e9000` (2026-11-12), the release Belal El-Shinnawey recommended, tech
    `1.0.588-128-ge7a6777`, `requires magic-8.3.693`;
  - `0c1f823` (2026-11-15), `main` on 2026-11-19, and all nine branches: no `patternfill` style for gf180mcu.
  - Files read: `gf180mcu/magic/gf180mcu*.tech`, `gf180mcu.magicrc`, `gf180mcu/Makefile.in` (`GF180MCUD_DEFS`,
    `ocd-io-%`), `gf180mcu/gf180mcu.json`, `gf180mcu/custom/scripts/gds_import_io.tcl`, `common/preproc.py`,
    `sky130/magic/sky130-cifout.tech` (`wafflefill`), `sky130/custom/scripts/generate_fill.py`.
- ciel release: <https://github.com/fossi-foundation/ciel-releases/releases/tag/gf180mcu-e7a6777d157a9d94c7ac757457b9e4309e9e9000>,
  installed by the user on 2026-11-19 into `~/EDA/pdk_overlay/ciel/` (`ciel enable --pdk gf180mcu e7a6777… -l all`).
- GF180MCU design manual, layer tables (dummy fill datatype 4, labels datatype 10, NDMY/PMNDMY), as consulted on
  2026-11-18; not stored.

## Tools and environments

- IIC-OSIC-TOOLS: <https://github.com/iic-jku/IIC-OSIC-TOOLS>, main at `f15ef6a` (2026-11-12); `_build/` scripts for
  Magic and open_pdks pins, `sak-pdk-script.sh`, `iic-osic-tools-setup.sh` (the `.designinit` hook), `README.md`.
- Claude Code cloud environments: <https://code.claude.com/docs/en/cloud-environments> (network access, allowed domains).
- Claude admin settings for network egress:
  <https://support.claude.com/en/articles/18342806-set-up-and-manage-the-new-unified-claude-experience-for-your-team-organization>.

## People

- R. Timothy Edwards (Open Circuit Design), author of the harness and of Magic.
- Belal El-Shinnawey (FOSSi Foundation), whose recommendation of 2026-11-19 (PDK e7a6777, current Magic, magicrc order)
  the user relayed in the chat.
