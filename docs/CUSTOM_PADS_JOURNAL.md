<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Work journal: custom analog pads for slot 16 (2026-11-28)

Short journal of the cloud session that wrote `CUSTOM_PADS_PLAN.md`. Times are not recorded; the order is the order of
work. "Scratch" is the session's scratch directory (not in any repository); its runs are reproducible with
`custom_pads/run_trial.sh`.

1. **Read** `docs/AGENT_BRIEF_CUSTOM_PADS.md`, `CLAUDE.md`, `docs/AGENT_BRIEF_PAD_STRUCTURES.md`. Environment:
   `/foss/pdks/gf180mcuD` with `gf180mcu_ocd_io` (mag, gds, lef, lib, spice, verilog, xschem), Magic 8.3.706, netgen
   1.5.332, KLayout 0.30.12 (`/foss/setup.log`).
2. **Repository B** is public: `add_repo` reported read access without attaching; shallow clone of `main` (`2f18cd4`),
   then the branches `chipalooza_artifacts_run1`, `chipalooza_artifacts_run2`, `sudel_buecher`, `chipalooza_logs_run1`
   (depth 1). Read `config.txt`, `scripts/parse_config.py` (all of it), `gen_padframe_template.tcl`, the padframe verilog
   template, the run scripts, `Makefile`, `README`, the LVS scripts, `layout_setup.tcl`, `gen_xschem_sym.py` (pad parts),
   `fixes/pad_pins/ANALYSIS.md`, `fixes/TIM_SUMMARY.md`, the run 1 step logs, `pad_abutment_check.tcl`, the 2026-11-19
   harness handoff note (stale child timestamps).
3. **Measured asig** from the PDK GDS with `custom_pads/tools/pad_edges.py`: per layer, the shapes touching each edge of
   (0,0)-(75,350). Rail nets from the Metal5 labels of the mag view (26 bands, both edges equal: `diff` of the two
   sorted lists empty).
4. **Single-pad GDS test.** Copy of asig's mag file under a new name, (a) with the PDK's `GDS_*` properties, (b) without.
   Magic, in a test cell: `getcell` both the copy and asig, `instance list abutment` (both `0 0 15000 70000`), `gds write`.
   (a) warns `Structure definition has name gf180mcu_ocd_io__asig_5p0 but cell definition has name gf180_cm_io__asig_in`
   and writes the renamed cell; `tools/xor_cells.py` against the PDK cell: `XOR_SUMMARY layers_differing 0`.
   (b) `layer 36/10: xor polygons 8 ...; texts A 16 B 8`, `layer 81/10: ... texts A 127 B 79`. Chose (a).
5. **Which cell carries the edges.** Edge spans of `5LM_METAL_RAIL_PAD_60`, `GF_NI_ASIG_5P0_BASE`, `fill10`, `bi_24t`
   compared with asig: the rail cell has the same side-edge spans on 22/0, 31/0, 34/0, 42/0, 46/0, 81/0; it lacks the
   Metal2 VSS bands (they are in `GF_NI_ASIG_5P0_BASE`, at its y 182.485-189.485 and 254.485-261.485 plus the instance
   offset 63.515) and the full 0/0 boundary (top cell). `bi_24t` has its Metal2 bands 0.24 µm lower.
6. **First scratch copy, baseline.** `make clean-config config padframe wrappers symbols`, all rc 0. `git status`: all
   regenerated views modified against the committed ones, e.g. `magic/slot16_wrapper.mag` (checkpaint, `obsm1` width
   368 → 400, a `metal2` rect at 254779 and two `metal3` rects removed). So comparisons are run-against-run from then on.
7. **Stage 1** (second scratch copy): only the two `s16_an` lines of `config.txt` changed. `make config` rc 0 with
   `Error:  Bad pad type gf180_cm_io__asig_in` / `..._out` (once in the wrapper part, twice each in the padframe part).
   Diff against the baseline:
   ```
   gen_padframe.tcl:   < label_left_analog pad_s16_an_0  pad s16_an\[0\]
                       < label_left_analog pad_s16_an_1  pad s16_an\[1\]
                       > label_left_analog pad_s15_an_1  pad s15_an\[1\]      (twice)
   gf180mcu_padframe.v:< .ASIG5V(s16_an[0])  < // (core signal name = pad name)
                       > .PAD(s15_an_1),     > PAD_16_0_SIGNALS
                       (pad_s16_an_1: > .PAD(s16_an_0), > PAD_16_1_SIGNALS)
   chipalooza_frame_wrapper.v: > INPUT_OUTPUT_LIST (twice, instead of the two comments)
   ```
8. **Stage 2**: patch 0002 (`analog_pad_types`). `make config` clean. `make padframe` rc 0 with `Cell
   gf180_cm_io__asig_out couldn't be read` and `... asig_in ...` (log lines 206-207). In the padframe: 38 instead of 40
   asig-like pads; `use gf180mcu_ocd_io__fill5  pad_s16_an_1` at `transform 0 1 0 -1 0 363400`; `pad_s15_an_1` moved
   from 446400 to 416400. (The failed `getcell` left the previous spacer selected, `identify` renamed it.)
9. **Stage 3**: patch 0003 (search paths). All steps rc 0; padframe log: four `Bad cell path in gf180_cm_io__asig_*:
   Instance of cell 5LM_METAL_RAIL_PAD_60 / GF_NI_ASIG_5P0_BASE specifies path ../custom_pads/gf180_cm_io/mag ...`.
   Fix in `make_placeholder_pads.sh`: the two `use` lines of the copy name `$PDKPATH/libs.ref/gf180mcu_ocd_io/mag`.
   Also seen in both runs: `couldn't be read` for the IP blocks, because the submodules were not checked out.
10. **Submodules** checked out (`git submodule update --init --depth 1`: `c21d8c0`, `96a93f8`, `a6f16be`, as in run 1).
    Wrote `run_trial.sh` (fresh clone, submodules copied, fork fixes, placeholders, patches, steps, log scan, abutment
    check, netgen read). Built 0004 on top of the fork's `lvs_scripts.patch` and 0005 on top of 0002. My first 0001 missed
    the `s16_an` lines (they had been staged before the diff); regenerated with `git diff HEAD`, and the first `custom`
    run, which still showed asig at slot 16, was discarded and rerun.
11. **Clean run** (`logs/run/custom_summary.txt`) and the tree diff `diff -rq` baseline vs custom
    (`logs/run/base_vs_custom.txt`): only the expected files differ. Ran again with `WITH_0005=1` (same result) and a
    negative test (`gf180_cm_io__asig_typo`): `make config` exits 1 (`make` reports `Error 1`, shell rc 2).
    Port check: Magic's `port first/last` returned empty strings for these views in batch mode, so
    `pad_abutment_check_custom.tcl` reads the ports from the `.mag` text instead; negative test with a `fill10` copy.
12. **GDS checks.** `make gds-slots` in both runs (0 s), then
    `python3 -I tools/xor_cells.py base/gds/slot16_wrapper.gds slot16_wrapper custom/gds/slot16_wrapper.gds slot16_wrapper`
    → `XOR_SUMMARY layers_differing 0`. In `custom/magic/`, a fresh Magic: `load gf180mcu_padframe`, `gds write`
    (286 s, 58 MB): both placeholders read from the recorded path, XOR 0 against asig, 156 cells, no duplicate names.
    The 58 MB GDS was deleted afterwards.
13. **`pad_edge_check.py`** written and tried: placeholders ok; `bi_24t`, `in_c` fail the core-edge rule (no Metal2 at
    y = 350 within 15.34-59.66) and warn on their shifted Metal2 rails; the first version also flagged the label
    datatype 81/10, which is not geometry, so datatypes other than 0 are skipped on the side edges.
14. **GDS import route.** Flattened the placeholders (KLayout) into a stand-in "external" GDS, imported in Magic with
    `gds readonly true`. First `FIXED_BBOX` came out ten times too big; set from microns it is right. Ports come without
    class/use. Padframe placement and a GDS write work; XOR 0.
15. **Read** the other agent's `docs/PAD_STRUCTURES.md` (`pad_esd_exploration`, `f936d69`): sections 1, 4.3-4.5, 6.2-6.3,
    11, 12.3-12.4, 14.2. Consistent with my measurements (rails, Metal2 strips, slot pins). Read A's macro READMEs,
    `submission.yaml`, `CLAUDE.md` for section 6 of the plan.
16. **Wrote** the plan, this journal, `custom_pads/README.md`; copied logs (scratch path replaced by `<scratch>`),
    measurements and tools; checked which patches apply to a plain `main` (`logs/run/patch_check_plain_main.txt`).

Not done: repository D; any DRC, extraction or LVS; Tim's custom pad netlist (not in any commit); a message to Tim.
