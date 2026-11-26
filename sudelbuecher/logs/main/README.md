<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# `logs/main/` — index

One line per file: which log entry it belongs to, and what it shows. The running logs (`*_log.md`) tell the story;
the other files are the evidence they quote. `../../MANIFEST.tsv` records each file's original mtime, size and origin.
Run files of the harness itself (`make_*.out/.err`) are not copied here: they are committed in the harness fork
`gf180mcu_ocd_chipalooza` and quoted as `<commit>:<file>:<line>` in the running log of 2026-11-19.

## Running logs

| File | Covers |
|---|---|
| [2026-10-08_opus_classab_port_log.md](2026-10-08_opus_classab_port_log.md) | Class-AB pad driver, its bias and the pad enables, IHP → GF180 (2026-10-08) |
| [2026-10-08_fable_reference_redesign_log.md](2026-10-08_fable_reference_redesign_log.md) | GF180 redesign of the driver's bandgap reference `ClassABBiasBG` (2026-10-08/09) |
| [2026-11-19_opus_padframe_minesweeping_log.md](2026-11-19_opus_padframe_minesweeping_log.md) | Harness `make` targets, timestamp mismatches, Magic 8.3.705, ciel PDK e7a6777 (2026-11-18 to 11-20) |

## 2026-10-06 — bias reference and input pad (chat log `../../chatlog/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md`)

| File | What it shows |
|---|---|
| [2026-10-06_opus_cace_03v3.out](2026-10-06_opus_cace_03v3.out) | CACE run, `OgueyAebischerBias` 03v3; summary table 17 Pass, 4 Fail |
| [2026-10-06_opus_cace_06v0.out](2026-10-06_opus_cace_06v0.out) | CACE run, `OgueyAebischerBias` 06v0; summary table 15 Pass, 6 Fail |
| [2026-10-06_opus_cace_s2d.out](2026-10-06_opus_cace_s2d.out) | CACE run, input-range deck of `gf180mcu_IOPadSingle2Diff`; 1 Pass, 2 Fail |
| [2026-10-06_opus_sim-all.out](2026-10-06_opus_sim-all.out) | `make sim-xschem` of the bias testbenches (ngspice transcript, no pass/fail table) |

## 2026-10-08 — class-AB port (log `2026-10-08_opus_classab_port_log.md`)

| File | What it shows |
|---|---|
| [2026-10-08_opus_cace_ClassABBiasIn.out](2026-10-08_opus_cace_ClassABBiasIn.out) | CACE run, `ClassABBias` In tree; summary 3 Pass, 0 Fail |
| [2026-10-08_opus_cace_ClassABBiasOut.out](2026-10-08_opus_cace_ClassABBiasOut.out) | CACE run, `ClassABBias` Out tree; 3 Pass, 0 Fail |
| [2026-10-08_opus_cace_ClassABDriverBiased.out](2026-10-08_opus_cace_ClassABDriverBiased.out) | CACE run, driver core with bias; 3 Pass, 2 Fail |
| [2026-10-08_opus_cace_IOPadDiff2Single.out](2026-10-08_opus_cace_IOPadDiff2Single.out) | CACE run, output pad `gf180mcu_IOPadDiff2Single`; 3 Pass, 0 Fail |
| [2026-10-08_opus_cace_IOPadSingle2Diff.out](2026-10-08_opus_cace_IOPadSingle2Diff.out) | CACE run, input pad `gf180mcu_IOPadSingle2Diff`; 0 Pass, 1 Fail |
| [2026-10-08_opus_classab_delivery.md5](2026-10-08_opus_classab_delivery.md5) | md5 of every file delivered by the class-AB session |

## 2026-10-08/09 — bandgap reference (log `2026-10-08_fable_reference_redesign_log.md`, chat log `../../chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md`)

| File | What it shows |
|---|---|
| [2026-10-08_fable_cace_ClassABBiasIn_rerun.out](2026-10-08_fable_cace_ClassABBiasIn_rerun.out) | CACE rerun, `ClassABBias` In; 3 Pass, 0 Fail |
| [2026-10-08_fable_cace_ClassABDriverBiased_rerun.out](2026-10-08_fable_cace_ClassABDriverBiased_rerun.out) | CACE rerun, driver with bias; 3 Pass, 2 Fail |
| [2026-10-09_fable_cace_ClassABBiasBG.out](2026-10-09_fable_cace_ClassABBiasBG.out) | CACE run, bandgap `ClassABBiasBG`; 6 Pass, 0 Fail |
| [2026-10-09_fable_cace_ClassABBiasBGdn.out](2026-10-09_fable_cace_ClassABBiasBGdn.out) | CACE run, deep-n-well variant; 6 Pass, 0 Fail |
| [2026-10-09_fable_cace_ClassABBiasBGTree.out](2026-10-09_fable_cace_ClassABBiasBGTree.out) | CACE run, bandgap with bias tree; 1 Pass, 0 Fail |
| [2026-10-09_fable_cace_ClassABBiasBGdnTree.out](2026-10-09_fable_cace_ClassABBiasBGdnTree.out) | CACE run, deep-n-well variant with tree; 1 Pass, 0 Fail |
| [2026-10-09_fable_sizing_bg_core.txt](2026-10-09_fable_sizing_bg_core.txt) | `bg_core` corners: output current, deviation from 5 µA, Idd, node voltages |
| [2026-10-09_fable_sizing_bg_core_dn.txt](2026-10-09_fable_sizing_bg_core_dn.txt) | the same for `bg_core_dn` |
| [2026-10-09_fable_driver_with_bg.txt](2026-10-09_fable_driver_with_bg.txt) | `ClassABDriver` with each bias, 1 kΩ ‖ 100 pF, over PVT |
| [2026-10-09_fable_bandgap_delivery.md5](2026-10-09_fable_bandgap_delivery.md5) | md5 of every file delivered by the bandgap session |

(Pass/Fail counts are the number of `Pass ✅` / `Fail ❌` rows in CACE's summary tables; which failures are expected is
in the running logs.)

## 2026-11-17 — PDK and pad library in the IIC container (chat log `../../chatlog/2026-11-13_sonnet-opus_iic_osic_tools_cloud_config_setup.md`; before the running log starts)

| File | What it shows |
|---|---|
| [2026-11-17_sonnet_inspect_pdk_klayout.sh](2026-11-17_sonnet_inspect_pdk_klayout.sh) / [.out](2026-11-17_sonnet_inspect_pdk_klayout.out) / [.err](2026-11-17_sonnet_inspect_pdk_klayout.err) | `sak-pdk gf180mcuD`, `/foss/pdks`, KLayout tech files and version, `/etc/profile.d/iic-osic-tools-setup.sh` (chat T23); `.err`: two missing version files in `/foss/tools/` |
| [2026-11-17_sonnet_inspect_io_metal.sh](2026-11-17_sonnet_inspect_io_metal.sh) / [.out](2026-11-17_sonnet_inspect_io_metal.out) / [.err](2026-11-17_sonnet_inspect_io_metal.err) | metal-stack settings in the KLayout DRC/LVS decks, metal layers in layer properties and Magic tech, `SOURCES` (chat T31); `.err` 0 lines |
| [2026-11-17_sonnet_inspect_ocd_io.sh](2026-11-17_sonnet_inspect_ocd_io.sh) / [.out](2026-11-17_sonnet_inspect_ocd_io.out) / [.err](2026-11-17_sonnet_inspect_ocd_io.err) | copies of `gf180mcu_ocd_io`, installed ciel versions, how the harness scripts name the pad library and `PDK_ROOT` (chat T42); `.err` 0 lines |

## 2026-11-18 — `make padframe` and timestamp mismatches (running log 2026-11-19, section 2026-11-18)

| File | Entry | What it shows |
|---|---|---|
| [2026-11-18_sonnet_make_pdk_overlay.out](2026-11-18_sonnet_make_pdk_overlay.out) / [.err](2026-11-18_sonnet_make_pdk_overlay.err) | before 03:39 (chat T69–T70) | first overlay, links only; `.out:169` `##### end`, `.err` 0 lines |
| [2026-11-18_sonnet_gds_archive_padframe.sh](2026-11-18_sonnet_gds_archive_padframe.sh) / [.out](2026-11-18_sonnet_gds_archive_padframe.out) / [.err](2026-11-18_sonnet_gds_archive_padframe.err) | before 03:39 (chat T75) | GDS of the archived upstream padframe. `.out:589` `RESULT: FAILED…` is a false alarm: Magic writes uncompressed GDS whatever the name, the script's gzip test failed (`.out:588` `not in gzip format`); the `.sh` was corrected afterwards (`.sh:6`). `.err`: `time` only |
| [2026-11-18_sonnet_layer_21_204_10.out](2026-11-18_sonnet_layer_21_204_10.out) | before 03:39 (chat T77) | GDS layers 21/10 and 204/10 are `NWELLTXT` and `PWELLTXT` in the Magic tech |
| [2026-11-18_sonnet_probe_padframe.sh](2026-11-18_sonnet_probe_padframe.sh) / [.out](2026-11-18_sonnet_probe_padframe.out) / [.err](2026-11-18_sonnet_probe_padframe.err) | 03:39 | named abutment call returns `''` (`.out:140`) after the timestamp-mismatch message (`.out:139`) |
| [2026-11-18_sonnet_probe_padframe2.sh](2026-11-18_sonnet_probe_padframe2.sh) / [.out](2026-11-18_sonnet_probe_padframe2.out) / [.err](2026-11-18_sonnet_probe_padframe2.err) / [.cells](2026-11-18_sonnet_probe_padframe2.cells) | 03:54 | the same on the real cells, with and without priming (`.out:131–132`, `:412–413`); `.cells` = the 13 io cells primed |
| [2026-11-18_sonnet_timestamp_mismatches_repo_copies.out](2026-11-18_sonnet_timestamp_mismatches_repo_copies.out) / [.tsv](2026-11-18_sonnet_timestamp_mismatches_repo_copies.tsv) / [.err](2026-11-18_sonnet_timestamp_mismatches_repo_copies.err) | 04:01 | `check_timestamps.py` on the git checkouts: 480 mismatching uses of 21 cells (`.out:2`); `.tsv` one row per use |
| [2026-11-18_sonnet_timestamp_mismatches_make.tsv](2026-11-18_sonnet_timestamp_mismatches_make.tsv) | 04:01 | the same check on the cells as `make` sees them (466 rows) |

## 2026-11-19 — overlay, Magic bug, harness targets (running log 2026-11-19)

| File | Entry | What it shows |
|---|---|---|
| [2026-11-19_opus_make_pdk_overlay.sh](2026-11-19_opus_make_pdk_overlay.sh) | 02:04 | the overlay script as updated at 02:04 (later versions: `_runs/`, harness `scripts/`, md5 `89021fb…`) |
| [2026-11-19_opus_sandbox_make_pdk_overlay.out](2026-11-19_opus_sandbox_make_pdk_overlay.out) / [.err](2026-11-19_opus_sandbox_make_pdk_overlay.err) | 02:04 | sandbox run: 107 pad views in 9 s, corner box, no mismatches (`.out:40,43,340,401`); `.err` = libraries the sandbox lacks |
| [2026-11-19_opus_magic-is_locked-init.patch](2026-11-19_opus_magic-is_locked-init.patch) | 03:14 | one-line fix of `is_locked` in `database/DBio.c` (`:7–8`); superseded by Magic `1a6e9e5` |
