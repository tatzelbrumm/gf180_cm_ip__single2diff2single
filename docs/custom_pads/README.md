<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# custom_pads: the placeholder trial for slot 16

Material for `../CUSTOM_PADS_PLAN.md`. Nothing here has been applied to the harness fork
(`tatzelbrumm/gf180mcu_ocd_chipalooza`); it was tried in scratch copies only, on the fork's `main` at `2f18cd4`, with
PDK `gf180mcuD` (open_pdks `1.0.588-128-ge7a6777`), Magic 8.3.706, netgen 1.5.332, KLayout 0.30.12.

## What is here

| Path | What it is |
| --- | --- |
| `make_placeholder_pads.sh` | writes the placeholder library `gf180_cm_io` (two renamed copies of `gf180mcu_ocd_io__asig_5p0`) in the views mag, gds, lef, spice, verilog (3 files), xschem. Names are **provisional** |
| `patches/0001-config-slot16-custom-pad-types.patch` | `config.txt`: `s16_an[0]` → `gf180_cm_io__asig_in`, `s16_an[1]` → `gf180_cm_io__asig_out`, header comment |
| `patches/0002-parse_config-analog-pad-types.patch` | `scripts/parse_config.py`: a set `analog_pad_types`; the five `== 'gf180mcu_ocd_io__asig_5p0'` tests become `in analog_pad_types` |
| `patches/0003-magic-search-path-custom-pads.patch` | `addpath ../custom_pads/gf180_cm_io/mag` in `scripts/gen_padframe_template.tcl` and `scripts/layout_setup.tcl` |
| `patches/0004-lvs-read-custom-pad-spice.patch` | `readnet spice` of the custom pad netlist in `validate/run_lvs_ocd_chipalooza.sh` and `validate/run_lvs_padframe.sh`. **Only on top of** `upstream_fixes/lvs_scripts.patch`. Applied, not run (no LVS was run) |
| `patches/0005-parse_config-stop-on-bad-pad-type.patch` | optional, on top of 0002: `make config` exits 1 on an unknown pad type instead of writing broken files and exiting 0 |
| `upstream_fixes/pad_pins.patch`, `upstream_fixes/lvs_scripts.patch` | verbatim copies of the fork's own fixes, branch `chipalooza_artifacts_run1`, `fixes/pad_pins/` (DVDD/DVSS pad pin names; LVS script fixes). The trial applies them first |
| `run_trial.sh` | the whole trial from a fresh copy: `base` mode = fork fixes only, `custom` mode = fork fixes + placeholders + 0001-0004 (`WITH_0005=1` adds 0005) |
| `pad_abutment_check_custom.tcl` | `pad_abutment_check.tcl` (fork, branch `sudel_buecher`, `sudelbuecher/harness_tools/`) extended to custom pad directories, plus an abutment-box and port comparison with `asig_5p0` |
| `pad_edge_check.py` | KLayout check of a custom pad's GDS against `asig_5p0`: side-edge rails per layer, PR boundary, core-edge Metal2/Metal3 |
| `tools/pad_edges.py`, `tools/xor_cells.py` | the measurement and XOR helpers used for the plan |
| `measurements/` | edge geometry of `asig_5p0`, of its rail cell `5LM_METAL_RAIL_PAD_60` and of `bi_24t`; the rail-to-net table |
| `logs/stage1_2/` | the two failing stages (config.txt only; parse_config patched but no search path) |
| `logs/run/` | `run_trial.sh` logs, both modes; `*_summary.txt` first; `base_vs_custom.txt` is the diff of all generated files |
| `logs/gds_route/` | the import route for a pad drawn outside Magic (GDS → Magic view with its own `GDS_FILE`) |
| `logs/single_pad_gds/` | Magic GDS output of one renamed pad, with and without the PDK's `GDS_*` properties |

In the logs, the session's scratch directory is written `<scratch>` (replaced after the run; nothing else was edited).

## How to apply them to the harness fork (when the user decides to)

In a fresh branch of the fork, from the top directory, with `PDK_ROOT` and `PDK` set:

```
git apply <this dir>/upstream_fixes/pad_pins.patch        # if not applied already
git apply <this dir>/upstream_fixes/lvs_scripts.patch     # if not applied already
<this dir>/make_placeholder_pads.sh custom_pads/gf180_cm_io
git apply <this dir>/patches/0001-config-slot16-custom-pad-types.patch
git apply <this dir>/patches/0002-parse_config-analog-pad-types.patch
git apply <this dir>/patches/0003-magic-search-path-custom-pads.patch
git apply <this dir>/patches/0004-lvs-read-custom-pad-spice.patch
git apply <this dir>/patches/0005-parse_config-stop-on-bad-pad-type.patch   # optional
make clean-config config padframe wrappers symbols
```

0001-0003 and 0005 also apply to a plain `main` without the fork fixes; 0004 does not (`logs/run/patch_check_plain_main.txt`).

Then check what the make steps do not report (they exit 0 on all of these, see the plan, section 5):

```
grep -n "Bad pad type" <config log>                      # must be empty
grep -n "couldn't be read" <padframe log>                # only "Cell open_source couldn't be read" (also in the baseline)
grep -n "Bad cell path" <padframe log>                   # must be empty
CUSTOM_PAD_DIRS=$PWD/custom_pads/gf180_cm_io/mag magic -dnull -noconsole \
  -rcfile $PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc <this dir>/pad_abutment_check_custom.tcl   # custom_bad 0
python3 -I <this dir>/pad_edge_check.py custom_pads/gf180_cm_io/gds/gf180_cm_io.gds gf180_cm_io__asig_in
```

Or run the whole trial in scratch, which changes nothing in the clone it is given:

```
PDK_ROOT=/foss/pdks PDK=gf180mcuD <this dir>/run_trial.sh <fork clone> <workdir> base
PDK_ROOT=/foss/pdks PDK=gf180mcuD <this dir>/run_trial.sh <fork clone> <workdir> custom
```

Steps it does not run, by the brief: `drc-final`, full-chip LVS (`lvs-top`), `extract-top`, and anything after `symbols`
except `gds-slots` (run by hand, under a second, `logs/run/*_gds-slots.log`) and one GDS write of the padframe alone
(286 s, `logs/run/custom_padframe_gds_write.log`).
