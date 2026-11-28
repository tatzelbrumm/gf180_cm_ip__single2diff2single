<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Custom analog pads for slot 16: plan, and the placeholder trial

Written for the user on 2026-11-28 by a Claude Code cloud session, following `docs/AGENT_BRIEF_CUSTOM_PADS.md`.
Work journal: `docs/CUSTOM_PADS_JOURNAL.md`. Patches, scripts and logs: `docs/custom_pads/` (its `README.md` says how to
apply them). No pad was designed; nothing was pushed to the harness fork.

## 0. How to read this

Every statement carries a mark:

- **[V]** verified: a file and line, or a command and its output (logs under `docs/custom_pads/logs/`).
- **[I]** inferred: the source of the inference is named.
- **[U]** unverified: not checked; why is said.

Abbreviations: **B** = the harness fork `tatzelbrumm/gf180mcu_ocd_chipalooza`, branch `main` at `2f18cd4` unless another
branch is named. **PDK** = `/foss/pdks/gf180mcuD`, `libs.ref/gf180mcu_ocd_io/` (open_pdks `1.0.588-128-ge7a6777`).
**A** = this repository. **asig** = `gf180mcu_ocd_io__asig_5p0`. Tools: Magic 8.3.706, netgen 1.5.332, KLayout 0.30.12
**[V]** (`/foss/setup.log`, `logs/run/*_summary.txt`). Coordinates of a pad are pad-local, in µm: x across the 75 µm
width, y from the chip edge (y = 0, bond pad) to the core edge (y = 350).

The placeholder names `gf180_cm_io__asig_in`, `gf180_cm_io__asig_out` and the library name `gf180_cm_io` are **my
choice, provisional** (assumption A1 in section 10); the user decides the real names.

## 1. Summary

1. **The idea holds, with conditions.** Two renamed copies of asig as new pad types work in the harness flow: with
   three small harness patches the quick steps run clean, the padframe gets the two placeholders at exactly the
   positions of the standard pads, and every other generated view (all 18 slot wrappers, symbols, LVS views, the
   slot 16 wrapper GDS) stays the same apart from timestamps **[V]** (`logs/run/base_vs_custom.txt`, section 5).
   The placeholders' GDS written by Magic is geometrically identical to asig (XOR 0 on all layers) **[V]**.
2. **It does not work with `config.txt` alone.** The pad type is not a free string: `parse_config.py` recognises asig by
   exact name in five places and every other analog name falls through **[V]** (section 2). Worse, every failure in the
   chain is silent: `make config` and `make padframe` exit 0 while writing broken output **[V]** (section 5.2).
3. **The condition that limits the idea:** the harness supports custom pads only if they keep asig's electrical
   interface: one signal net `ASIG5V` that is both the bond pad and the core-side terminal, plus `DVDD DVSS VDD VSS`
   **[V]** (`parse_config.py:196-199, 213-215, 382-387`; `gen_padframe_template.tcl:169-219`). A custom input pad whose
   CDM resistor sits inside the pad (bond pad and protected core node as two nets) does not fit that class; it needs a
   new pad class in the harness and Tim Edwards' agreement (section 8).
4. **"Replace the placeholder later without changing the flow again"** holds for the layout, the GDS and the netlist of
   the pad, as long as the names, the size (75 x 350 µm), the pins and the edge geometry (section 3) stay. It does not
   hold if any of those change. **[I]** from sections 2-4.
5. The harness README itself allows "even a custom pad design" for the dedicated pads **[V]** (`B:README:136-141`),
   and requires that "every specified pad *must* have a wirebond pad" **[V]** (`B:README:182`). Changes to `s<N>_an`
   pad types "may *only* be made in coordination with the slot's project designer" **[V]** (`B:config.txt:35-46`).

## 2. Where the pad type matters (question 1)

| Place | What depends on the pad type | Mark |
| --- | --- | --- |
| `config.txt:51-59` | header: the "6 valid pad types", default asig | [V] |
| `config.txt:169-170` | `s16_an[0]`, `s16_an[1]`: pad type and core signal name (`s16_an_0`, `s16_an_1`) | [V] |
| `scripts/parse_config.py:74,80-89` | reads every `s<N>_an[k]` line into `padlist` (type, signal name) | [V] |
| `parse_config.py:112, 123, 148, 151-153` | wrapper verilog: dispatch on `startswith('gf180mcu_ocd_io__in')`, `startswith('gf180mcu_ocd_io__bi_')`, `== 'gf180mcu_ocd_io__asig_5p0'`; else "Error:  Bad pad type", and the literal template line `INPUT_OUTPUT_LIST` is copied into the output | [V] |
| `parse_config.py:189-201` | padframe verilog, `PAD_x_y_TYPE` → cell name (any string); `PAD_x_y_PAD` → `.ASIG5V(s<N>_an[k])` only if `== asig`, else `.PAD(<signal_name>)` | [V] |
| `parse_config.py:207-242` | padframe verilog, `PAD_x_y_SIGNALS`: asig → comment only; unknown → "Bad pad type" and the literal template token stays | [V] |
| `parse_config.py:255-297` | padframe verilog port list, same dispatch | [V] |
| `parse_config.py:307, 425, 443` | constant blocks next to the pad only if the name contains `__bi_` or `__in_` (substring) | [V] |
| `parse_config.py:361-414` | `gen_padframe.tcl`: TYPE → cell name; SIGNALS: asig → `label_<side>_analog`; **no `else` branch**: an unknown type re-emits the previous line | [V] |
| `parse_config.py:464` | `sys.exit(0)` in every case, also after "Bad pad type" | [V] |
| `scripts/gen_padframe_template.tcl:35-39` | `addpath` of the PDK pad library (and three logo libraries) only; a cell elsewhere is not found | [V] |
| `gen_padframe_template.tcl:63-96` | `place_pad_*`: `getcell <type>`, `identify`, then advance by the width of `instance list abutment` | [V] |
| `gen_padframe_template.tcl:169-219` | `label_left/right/top_analog`: from the abutment box, grown by -15.34 µm on both sides, paint a 1 µm Metal2+Metal3 strip (left/right) or a 4 µm Metal2 strip (top) just outside the core edge, label it | [V] |
| `gen_padframe_template.tcl:545, 547, 696-697, 885-886` | slot 16: placement (`PAD_16_*_TYPE`), bond pad labels `s16_an[0]`/`[1]`, `PAD_16_*_SIGNALS` | [V] |
| `scripts/gf180mcu_padframe_template.v:48, 989-1010` | port `s16_an[1:0]`; the two instances with `PAD_16_*_TYPE/PAD/SIGNALS`; power pins `.iovdd/.iovss/.vdd/.vss` on `main` (fixed to `DVDD DVSS VDD VSS` by the fork's `fixes/pad_pins/pad_pins.patch`, branch `chipalooza_artifacts_run1`) | [V] |
| `scripts/gen_padframe.tcl`, `verilog/gl/gf180mcu_padframe.v`, `verilog/gl/chipalooza_frame_wrapper.v` | generated by `make config` from the above | [V] |
| `magic/gf180mcu_padframe.mag` (generated by `make padframe`) | one `use <type> <instance> [path]` per pad; the first use of a cell records its directory (`$PDKPATH/...` for PDK cells) | [V] `B:magic/gf180mcu_padframe.mag:1257-1264`; trial: `use gf180_cm_io__asig_in  pad_s16_an_0 ../custom_pads/gf180_cm_io/mag` |
| `scripts/run_gen_user_wrappers.sh:56-145` | slot wrappers are cut out of `chipalooza_frame` by fixed boxes (slot 16 at x 349.76, 1274.25 x 412.71); labels become ports. **Does not read the pad type** | [V] |
| `magic/slot16_wrapper.mag:184, 186, 189` | `s16_an[0]` / `s16_an[1]`: Metal3, x 1.24-3.24, y 272.70-317.02 / 102.70-147.02 (the strips painted by `label_left_analog`); bbox 1274.27 x 412.71 | [V] |
| `scripts/gen_xschem_sym.py:28-32, 337-338`; `scripts/run_gen_xschem_syms.sh:14-17` | slot wrapper symbols and `_lvs.v` from the wrapper layout; "the slot wrapper symbols change whenever a user swaps an analog pad for another one" (that text is about pads with ESD pins, an IHP-era notion **[I]**, see below). With the placeholders: no change **[V]** (`base_vs_custom.txt`: `xschem/`, `verilog/gl/slot*_lvs.v` not listed) | [V] |
| harness core: `xschem/chipalooza_frame.sch:1618, 2806`, `xschem/gf180mcu_ocd_chipalooza.sch:66, 87, 191, 202`, `netlist/*/chipalooza_frame.spice`, `verilog/gl/gf180mcu_ocd_chipalooza.v:42, 130` | carry `s16_an[0:1]` as nets; they do not name a pad type | [V] (grep) |
| `verilog/gl/gf180mcu_ocd_chipalooza.v:90-91, 208-209` | wires `s16_an_0_esd`, `s16_an_1_esd` connected to the padframe instance, whose module has no such ports | [V] for the text; that this is an IHP leftover is [I] (the other agent's report, `docs/PAD_STRUCTURES.md` on `pad_esd_exploration`, section 6.3, and `B:README:276-290`) |
| `scripts/layout_setup.tcl:39` | search path for extraction (`magic/run_extract_*.sh` load with `-dereference`, which ignores the recorded paths: `run_extract_padframe.sh:15`, `run_extract_chipalooza_top.sh:36`), `run_gen_wrapper_gds.sh:28`, `get_project_gds.sh:140` | [V] for the lines; that `-dereference` needs the search path is [I] from Magic's documented meaning of the option, not tested (no extraction run) |
| `validate/run_lvs_ocd_chipalooza.sh:19-20`, `validate/run_lvs_padframe.sh:22-23` | pad netlist: `../netlist/schematic/gf180mcu_ocd_io.spice`, which is in no commit (fork `fixes/ISSUE_lvs_inputs.md`); a custom pad's spice must be read too | [V] |
| `validate/run_lvs_ocd_chipalooza.sh:63-69`, `run_lvs_padframe.sh:37-44` | `flatten class` of named pad cells (`vdd`, `dvdd`); asig is not flattened, so the custom pads need nothing here | [V] |
| `Makefile:76-98` | `config`, `clean-config`, `padframe`, `wrappers`, `symbols` just call the scripts; no pad type logic | [V] |
| `README:136-141, 182, 295, 296-305, 336-365` | custom pads allowed; wirebond pad required; "All pads in this library are the same size"; the rebuild order (4)-(6): `clean-config`, `config`, `padframe`, `wrappers`, `symbols`, `gds-slots` | [V] |
| `scripts/run_gen_prefill_gds.sh`, `scripts/run_gen_filled_final_gds.sh` | no pad logic; the pads reach the chip GDS through Magic's GDS output of `gf180mcu_ocd_chipalooza` (prefill), then KLayout fill | [V] for the scripts; the path of the custom pad's GDS through them is [I] from the padframe GDS test (section 5.4) |

The brief's line numbers for `parse_config.py` (148, 196, 213, 265, 382) are right **[V]**. The rest of the asig
references in B are `porting.txt`, the generated files and two stale LVS reports (`validate/comp_*.out`) **[V]**
(`grep -rln asig_5p0`).

Pre-existing defects found on the way (not caused by custom pads, reported for Tim):

- `parse_config.py:201`: for a non-analog pad, `.PAD(` uses `signal_name` (and `spaces`) left over from the previous pad,
  because they are only set in the SIGNALS branch **[V]**: stage 1 wrote `.PAD(s15_an_1),` into `pad_s16_an_0`
  (`logs/stage1_2/stage1_config_only.log`, and the diff in the journal, entry 7). Whether a digital pad's PAD pin should
  carry the pad name `s<N>_an[k]` (as for asig) rather than the signal name is [U]; Tim's intent is not written down.
- `gen_padframe_template.tcl:1076-1077` (two `dvss` pads labelled `vdd5v0`) is already in the fork's notes
  (`fixes/TIM_SUMMARY.md`), not re-checked here.

## 3. What "same form factor" means (question 2)

Measured from the PDK views (`tools/pad_edges.py` on `PDK/gds/gf180mcu_ocd_io.gds`; output in
`docs/custom_pads/measurements/`) and from the generator scripts.

| Constraint | Value | Source | Mark |
| --- | --- | --- | --- |
| abutment box | (0,0)-(75,350) µm; Magic `FIXED_BBOX 0 0 15000 70000` (5 nm units) | `PDK/mag/gf180mcu_ocd_io__asig_5p0.mag:312`; LEF `SIZE 75.000 BY 350.000` (`lef:9`) | [V] |
| what the padframe reads | only `instance list abutment` (the FIXED_BBOX), on the first call after `getcell` | `gen_padframe_template.tcl:63-96`; abutment check `ABUT gf180_cm_io__asig_in: 0 0 75 350` | [V] |
| drawn extent | bbox (-0.16,0)-(75.16,350): Metal1 overhangs both sides by 0.16 µm (abuts the neighbour's) | `measurements/pad_edges_asig_5p0.txt` | [V] |
| PR boundary | layer 0/0 (`PR_bndry` in `libs.tech/klayout/tech/gf180mcu.lyp:1886`), one rectangle (0,0;75,350) in the top cell | XOR/edge script | [V] |
| LEF | `CLASS PAD INOUT`, `SITE GF_IO_Site`, `SYMMETRY X Y R90` | `lef:6-11` | [V] |
| rails crossing both side edges | Metal3, Metal4, Metal5: the same 26 horizontal bands on both edges, y 70-348.39 | `measurements/pad_edges_asig_5p0.txt` | [V] |
| rail nets | from y 70: DVSS 70-85, 86-101, 102-117; DVDD 118-125; DVSS 126-133; DVDD 134-149, 150-165, 166-181, 182-197; DVSS 198-205; DVDD 206-213, 214-229; DVSS 230-245; **VSS 246-253; VDD 254-261**; DVDD 262-269, 270-277, 278-285; DVSS 286-293; DVDD 294-301; DVSS 302-309; **VDD 310-317; VSS 318-325**; DVSS 326-333; DVDD 334-341; DVSS 342-348.39 (same on both edges) | Metal5 labels of the mag view; `measurements/asig_5p0_metal5_rail_nets_west_edge.txt`; agrees with the other agent's table (`PAD_STRUCTURES.md` 4.3) | [V] |
| Metal2 at the side edges | VSS bands y 246-253 and 318-325, both edges (from `GF_NI_ASIG_5P0_BASE`, not from the rail cell) | edge script on asig and on `GF_NI_ASIG_5P0_BASE` | [V] |
| substrate tie band at the side edges | COMP 22/0, Pplus 31/0 and Metal1 34/0, y 65.5-349.8, both edges (a P+ guard band continuous along the pad row) | edge script; layer names from `gf180mcu.lyp` | [V] for the geometry; that it is the substrate (DVSS/VSUBS) tie is [I] from P+ COMP + Metal1 |
| which cell provides the side-edge rails | `5LM_METAL_RAIL_PAD_60` has exactly asig's side-edge spans on 22/0, 31/0, 34/0, 42/0, 46/0, 81/0; the Metal2 bands come from `GF_NI_ASIG_5P0_BASE` | edge comparison (journal, entry 5) | [V] |
| neighbours | filler `fill10` matches asig on every side-edge layer; the PDK's digital pads (`bi_24t`, `in_c`) have their Metal2 VSS bands 0.24 / 0.15 µm lower, still overlapping | `pad_edge_check.py` negative tests, `logs/run/custom_pad_edge_check.log` | [V] |
| bond pad | Pad layer 37/0 and the `ASIG5V` Metal5 port at (7.5,2)-(67.5,62), i.e. a 60 x 60 µm opening at the chip edge | LEF `lef:16-18`; GDS | [V] |
| core-side terminal | Metal2 only, reaching y = 350 at x 15.34-17.88, 21.02-23.56, 26.70-29.24, 32.38-34.92, 40.08-42.62, 45.76-48.30, 51.44-53.98, 57.12-59.66 (eight 2.54 µm strips) | LEF `lef:19-51`; GDS | [V] |
| what the generator connects to it | a strip over x 15.34-59.66 (abutment box shrunk by 15.34 on each side), 1 µm deep outside the core edge, painted **Metal2 and Metal3** with Via2 (left/right side), or Metal2 only, 4 µm (top side) | `gen_padframe_template.tcl:169-219` | [V] |
| hence on the core edge | the pad's Metal2 that touches y = 350 inside 15.34-59.66 must be `ASIG5V` and nothing else; Metal3 touching y = 350 there would be shorted to it; at least one Metal2 shape must touch, or the pin floats | from the generator code above | [I] |
| supply pins | `DVDD`, `DVSS`, `VDD`, `VSS` as Metal5 ports on the side-edge rail stubs, x 0-5 and 70-75 (mag labels on x 0-1000 and 14000-15000, 5 nm units) | LEF `lef:53-276`; mag labels | [V] |
| what is checked by `pad_edge_check.py` | bbox, PR boundary, all side-edge spans of drawn layers, the core-edge rule above | the script; placeholders pass, `bi_24t`/`in_c` fail the core-edge rule as they must | [V] |

**Constraints a custom pad has to meet** (from the table **[I]**): FIXED_BBOX/PR boundary 75 x 350 µm; side-edge
geometry identical to asig on COMP, Pplus, Metal1, Metal3, Metal4, Metal5 and (overlapping) Metal2, with the nets
above; bond pad opening at the chip edge (the README's wirebond requirement); `ASIG5V` reaching the core edge on Metal2
within x 15.34-59.66 and no other Metal2/Metal3 there; ports `ASIG5V DVDD DVSS VDD VSS`. The simplest way to meet the rail
part is to keep the PDK's `5LM_METAL_RAIL_PAD_60` as a subcell and add the two Metal2 VSS edge stubs **[I]** (it carries
the bond pad `Bondpad_5LM` as well, `PDK/mag/5LM_METAL_RAIL_PAD_60.mag:5-9` **[V]**). Not checked: DRC of a pad next to
each neighbour type (no DRC was run) **[U]**.

## 4. What a custom pad must provide (question 3)

| View | Name and place (in the trial) | Read by | Needed? | Mark |
| --- | --- | --- | --- | --- |
| Magic `.mag` | `custom_pads/gf180_cm_io/mag/<cell>.mag`, with `FIXED_BBOX 0 0 15000 70000` and the five ports | `make padframe` (search path, patch 0003), `wrappers`, `gds-prefill` (the path recorded in `gf180mcu_padframe.mag`), extraction (search path in `layout_setup.tcl`, patch 0003) | yes | [V] for padframe/wrappers/a fresh padframe load; extraction not run [U] |
| GDS | `custom_pads/gf180_cm_io/gds/gf180_cm_io.gds`; Magic copies it through the mag view's `GDS_FILE`/`GDS_START`/`GDS_END` | GDS write (`gds-prefill`) | yes, for a pad drawn outside Magic; for one drawn in Magic the mag geometry suffices | [V] (sections 5.4, 5.5) |
| spice | `custom_pads/gf180_cm_io/spice/gf180_cm_io.spice`, `.subckt <cell> ASIG5V DVDD DVSS VDD VSS` | `lvs-top`, `lvs-padframe` (patch 0004) | yes | [V] netgen reads it with the padframe verilog without a placeholder cell (`logs/run/custom_netgen_read.log`); LVS itself not run [U] |
| verilog | `custom_pads/gf180_cm_io/verilog/gf180_cm_io.v` (+ `__blackbox.v`, `__blackbox_pp.v`) | nothing in B reads the PDK pad verilog **[V]** (grep: no `ocd_io.v` in scripts or `validate/lvs/Makefile`); the cocotb testbenches (`verilog/dv`) were not checked **[U]** | as a courtesy | — |
| LEF | `custom_pads/gf180_cm_io/lef/gf180_cm_io.lef` | nothing in B **[V]** (grep) | for documentation / P&R tools | — |
| xschem symbol | `custom_pads/gf180_cm_io/xschem/<cell>.sym` (the PDK symbol, which takes its name from the file) | testbenches in A that put the real pad in the loop | for A | [V] symbol content `PDK/xschem/gf180mcu_ocd_io__asig_5p0.sym:4` (`@symname`) |
| liberty `.lib` | not made | nothing in B **[V]** (grep) | no | — |
| harness's own pad netlist | `netlist/schematic/gf180mcu_ocd_io.spice` (Tim's corrected PDK netlist, not committed) | LVS | its conventions (it fixes "global sub!" issues, `run_lvs_padframe.sh:20-21`) are unknown, so whether the custom spice must follow them is [U] | [U] |

**Where the files live.** The PDK is read only, so not there **[V]** (the brief). Three options **[I]**:

1. **In the harness fork** (`custom_pads/<lib>/`, as in the trial): one directory, relative paths from `magic/`, no
   network at build time. Tested.
2. **In this repository A** (e.g. `pads/`), reached as `dependencies/slot_16/pads/...` once `make projects` has
   cloned A as the slot 16 submodule (`B:scripts/get_projects.sh:5-10`). Couples the padframe build to the user
   projects being cloned first, and freezes the pad with the slot's commit. Not tested.
3. **A separate repository** as a further submodule under `dependencies/`, like the three IP repositories
   (`B:.gitmodules`). Cleanest for upstream, most work. Not tested.

**What has to point there:** the Magic search path in `gen_padframe_template.tcl` and `layout_setup.tcl` (patch 0003)
**[V]**; the `readnet spice` lines of the two LVS scripts (patch 0004) **[V]** for the lines, not run; netgen's setup file
needs nothing for a subcircuit with the PDK's devices **[I]**; KLayout DRC/fill read the GDS only, so nothing **[I]**
(`run_klayout_drc_final.sh:17`, `run_gen_filled_final_gds.sh`).

## 5. The placeholder trial (question 4)

All in scratch copies of B; quick steps only. Driver: `docs/custom_pads/run_trial.sh` (fresh clone, the fork's two
existing fixes, then in `custom` mode the placeholder library and patches 0001-0004).

### 5.1 Baseline

`make clean-config config padframe wrappers symbols` on a fresh copy with the IP submodules checked out (the same
commits as run 1: `c21d8c0`, `96a93f8`, `a6f16be`): all rc 0, 0 / 0 / 4 / 2 / 0 s **[V]** (`logs/run/base_summary.txt`).
Already in the baseline: `Cell open_source couldn't be read` (padframe) and 18 `slot<N>_wrapper couldn't be read`
(wrappers; the script moves the old wrappers to `archive/` first) **[V]**; run 1 of the fork had the same 18 **[V]**
(`chipalooza_logs_run1:run-20261123T0029Z/wrappers.log`). Regenerating on `main` without changes does **not** reproduce
the committed views byte for byte (e.g. `magic/slot16_wrapper.mag` loses a Metal2/Metal3 stub at x 254779) **[V]**
(`git diff` in the first scratch copy, journal entry 6). So all comparisons below are baseline run against custom run,
same environment, not against the committed files.

### 5.2 What fails, in order (first errors exactly)

| Stage | Change | First error | Exit code | What the output looks like | Mark |
| --- | --- | --- | --- | --- | --- |
| 1 | `config.txt` only (`s16_an[0]` `gf180_cm_io__asig_in`, `s16_an[1]` `gf180_cm_io__asig_out`) | `Error:  Bad pad type gf180_cm_io__asig_in` (stdout of `make config`) | **0** | wrapper verilog: literal `INPUT_OUTPUT_LIST` twice; padframe verilog: `.PAD(s15_an_1),` and the literal `PAD_16_0_SIGNALS` in `pad_s16_an_0`; `gen_padframe.tcl`: `label_left_analog pad_s15_an_1 ...` three times, none for slot 16 | [V] `logs/stage1_2/stage1_config_only.log`; diffs in journal entry 7 |
| 2 | + patch 0002 (`analog_pad_types`) | `make config` clean; `make padframe`: `Cell gf180_cm_io__asig_out couldn't be read` | **0** | the padframe is built anyway, **wrongly**: a `fill5` spacer is renamed `pad_s16_an_1`, slot 16 has no pad, and the pads above are shifted (`pad_s15_an_1` at y 416400 instead of 446400 units) | [V] `logs/stage1_2/stage2_parse_config_no_addpath.log:206-207`; journal entry 8 |
| 3 | + patch 0003 (search path) | `Bad cell path in gf180_cm_io__asig_out:  Instance of cell 5LM_METAL_RAIL_PAD_60 specifies path ../custom_pads/gf180_cm_io/mag, which does not contain the cell.  Cell previously read from /foss/pdks/... will be used instead.` (a warning) | 0 | correct padframe | [V] journal entry 9 |
| 4 | placeholder mag views name `$PDKPATH/libs.ref/gf180mcu_ocd_io/mag` for their two subcells (`make_placeholder_pads.sh`) | none | 0 | correct; see 5.3 | [V] `logs/run/custom_summary.txt` |

Why stage 3 warns: Magic assumes that a cell's subcells without a path live in the cell's own directory. Here it
fell back to the PDK cells because other pads had loaded them already **[V]** (message text); what Magic does if the
custom pad is the first pad loaded was not tested **[U]**, hence stage 4.

### 5.3 The clean run

`logs/run/custom_summary.txt` **[V]**: every step rc 0 (config 0 s, padframe 5 s, wrappers 1 s, symbols 1 s); no
`Bad pad type`, no `Bad cell path`; only the baseline's `open_source` message.

- `gen_padframe.tcl:550, 552`: `place_pad_left pad_s16_an_1 gf180_cm_io__asig_out`, `... pad_s16_an_0 gf180_cm_io__asig_in`;
  lines 890-891 `label_left_analog pad_s16_an_0  pad s16_an\[0\]` and `[1]`.
- `verilog/gl/gf180mcu_padframe.v:1024, 1035`: the two instances with the new cell names, `.ASIG5V(s16_an[0])` etc.
- `magic/gf180mcu_padframe.mag`: `use gf180_cm_io__asig_in  pad_s16_an_0 ../custom_pads/gf180_cm_io/mag`, transform
  `0 1 0 -1 0 412400`, the same as the baseline's asig; `pad_s16_an_1` at 378400, same as the baseline.
- `magic/slot16_wrapper.mag`: `s16_an[0]` and `s16_an[1]` labels identical to the baseline.
- **Everything else identical** apart from timestamps: `logs/run/base_vs_custom.txt` lists only `config.txt`, the
  patched scripts, `gen_padframe.tcl` (9 lines), `gf180mcu_padframe.v` (4 lines) and `gf180mcu_padframe.mag` (4 lines);
  `chipalooza_frame_wrapper.mag`, `padframe_pins.mag`, all 18 `slot<N>_wrapper.mag`: 0 differing lines; no xschem symbol
  and no `_lvs.v` file differs.
- Abutment and port check (`pad_abutment_check_custom.tcl`): 19 pads, 0 empty boxes, both placeholders `0 0 75 350`,
  ports `{ASIG5V 1 signal bidirectional} {DVDD 2 power ...} {DVSS 3 ground ...} {VDD 4 power ...} {VSS 5 ground ...}`
  equal to asig: `CUSTOM_OK` twice. Negative test (a copy of `fill10` as a custom pad): `CUSTOM_BAD ... abutment
  0 0 10 350 != 0 0 75 350; ports differ` **[V]**.
- `pad_edge_check.py` on the placeholder GDS: `EDGE_SUMMARY ... ok` for both; on `bi_24t` and `in_c` it reports the
  missing core-edge Metal2, as it must **[V]** (`logs/run/custom_pad_edge_check.log`).
- netgen reads PDK pad spice + custom spice + `netlists_lvs.v` + the generated padframe verilog: 0 placeholder or
  undefined cells mentioning a pad **[V]** (`logs/run/custom_netgen_read.log`). Not an LVS.
- `make gds-slots` (README step 6, under a second): `gds/slot16_wrapper.gds` XOR baseline vs custom: 0 layers differ
  **[V]** (`logs/run/*_gds-slots.log`; command in the journal, entry 12).
- With patch 0005 as well: same results; and with a typo in `config.txt` `make config` now stops:
  `Error:  4 unknown pad type(s) in config.txt;  the generated files are not usable.`, `make: *** [Makefile:78: config] Error 1`
  **[V]** (`logs/run/custom_with_0005_summary.txt`, `custom_0005_negative_config.log`).

### 5.4 The placeholders' GDS

- A renamed copy of asig's mag view that keeps the PDK's `GDS_FILE/GDS_START/GDS_END` makes Magic copy asig's GDS bytes
  under the new name, with the warning `Calma output warning:  Structure definition has name gf180mcu_ocd_io__asig_5p0
  but cell definition has name gf180_cm_io__asig_in.`; flattened XOR against the PDK cell: 0 layers differ **[V]**
  (`logs/single_pad_gds/keep_gds_properties_magic.log`; journal entry 4).
- Without those properties Magic writes the cell from the mag text: the geometry is the same, but the label layers
  36/10 and 81/10 differ (16 vs 8 texts, 127 vs 79) **[V]**. So the placeholder keeps the properties.
- A fresh Magic session in `magic/` that only loads `gf180mcu_padframe` (as `gds-prefill` does, without the extra search
  path) finds both placeholders through the recorded relative path: `Cell gf180_cm_io__asig_in read from path
  ../custom_pads/gf180_cm_io/mag`; the padframe GDS (286 s) has 156 cells, 0 duplicate names, 38 asig + 2 placeholder
  instances, the placeholders at (0,2062) and (0,1892) R270, and both XOR 0 against asig **[V]**
  (`logs/run/custom_padframe_gds_write.log`, `custom_padframe_gds_xor.log`).
- The placeholders share the PDK subcells `GF_NI_ASIG_5P0_BASE` and `5LM_METAL_RAIL_PAD_60` with the standard pads; no
  duplicate GDS structures result **[V]** (above).

### 5.5 The route for a pad drawn outside Magic (for later)

Tried with a flattened copy of the placeholder as stand-in for a KLayout-drawn pad (`logs/gds_route/`) **[V]**:
`gds readonly true; gds read ../custom_pads/gf180_cm_io/gds/gf180_cm_io.gds` in `magic/` writes mag views with
`string GDS_FILE ../custom_pads/gf180_cm_io/gds/gf180_cm_io.gds` (relative, as given), the padframe places them, and a
GDS write copies the custom GDS (`Copying output for cell gf180_cm_io__asig_in from ../custom_pads/...`), XOR 0 against
asig. Two things needed care:

- `property FIXED_BBOX {0 0 15000 70000}` right after the import was saved as `0 0 150000 700000` (ten times too big);
  setting it from `box values 0 0 75 350` in microns gave the right value **[V]** (`gds_import.log`, `gds_import2.log`).
  The cause (Magic refining its grid during the import) is [I].
- The imported ports have no index order, class or use (`port 1 nsew` only); the port check flags them `CUSTOM_BAD
  ... ports differ` **[V]** (`logs/gds_route/abutment.log`). They have to be set after the import. Whether netgen
  cares (it matches pins by name) is [U].
- The relative `GDS_FILE` works because every harness Magic script runs in `magic/` **[V]** (`run_gen_padframe.sh`,
  `run_gen_user_wrappers.sh`, `run_gen_prefill_gds.sh`, `magic/run_extract_*.sh` all `cd magic` or live there).
- A KLayout pad that instantiates the PDK's `5LM_METAL_RAIL_PAD_60` under its own name would, on import, create a
  second Magic view of that cell; whether `gds noduplicates true` avoids it is [U].

### 5.6 Not run (by the brief), and whether they are needed

`drc-final` (3.2 h in run 1), `extract-top` (27 min), full-chip `lvs-top`, `gds-prefill`, `gds-final`, `projects-gds`
were not run. For the **placeholders** none is needed to show the flow: their GDS is byte-for-byte the PDK pad's under
another name (5.4) **[I]**. For a **real custom pad** the following are needed, in this order, and I ask before running
any of them (section 11, Q9) **[I]**: KLayout DRC on the pad cell alone (minutes, as the other agent did for asig,
`PAD_STRUCTURES.md` 14.2); `make extract-padframe lvs-padframe` (not timed; padframe only); then the chip-level steps.

## 6. What else changes in this repository A (question 5)

Listed, none changed **[V]** (this branch holds only docs).

| Place | Now | What changes with custom pads | Mark |
| --- | --- | --- | --- |
| `macros/gf180mcu_IOPadSingle2Diff/` (schematic `.sch:47-48`, `README.md:3, 18-23`, CACE `gf180mcu_IOPadSingle2Diff.yaml:39`, testbench `tb_dc.sch:33, 59-60`, `verification/cace/templates/`) | names asig; testbench and CACE template simulate through the PDK pad netlist | point the testbench and the CACE template at the custom pad's symbol and spice (`custom_pads/.../xschem`, `.../spice`) once it is designed; with the placeholder nothing changes electrically. If the CDM network moves into the pad, the macro's `Rcdm`, `Dcdmp`, `Dcdmn` move out | [V] for the lines; the rest [I] |
| `macros/gf180mcu_IOPadDiff2Single/` (`README.md:25`) | output ESD/CDM network "not included yet" | decide whether the output pad's protection is in the pad or in the macro | [V] line; [I] |
| `harness_stub/README.md` | IHP-based assumed interface | replace by the real slot 16 wrapper (already superseded per `CLAUDE.md:69`); independent of the pad type, since the wrapper does not change with the placeholders (5.3) | [V] |
| `submission.yaml:24, 27` | `slot-size: tiny`, `analog-pins: 3` (IHP) | slot 16 has two analog pins (`magic/slot16_wrapper.mag:184, 186`) **[V]**; slot size per the harness: 1274.27 x 412.71 µm. Whether the GF180 precheck reads these keys at all is [U]. Line 48 says the pads "come from asig": update when the pads are custom | [V] for the lines |
| `CLAUDE.md` §1 (lines 22-30) vs §5 (lines 66-68) | top cell `gf180_cm_ip__single2diff2single` vs the harness's `slot_16.gds` with top cell `slot_16` | unchanged by the pads: the custom pads sit in the padframe, not in the slot GDS **[V]** (5.3); still open | [V] |
| `CLAUDE.md` §5 (pad line) | "Analog pad asig ... installed" | would need a line on the custom pad library and where it lives | [I] |
| `docs/IHP_TO_GF180_PORT_MAP.md:12, 29`, `docs/OPERATING_LIMITS.md:16`, `HANDOVER_gf180_migration.md:45, 111`, `README.md`, `dependencies/README.md:5` | name asig as the pad | update when the pads are custom | [V] for the lines |
| new | — | the custom pad sources (where: section 4, options 1-3) and their checks (`pad_edge_check.py`, `pad_abutment_check_custom.tcl`) | [I] |

## 7. Coordination and risk (question 6)

- **The harness maintainer (Tim Edwards) has to agree** to: a custom pad library in the harness build (where it lives,
  section 4); the `analog_pad_types` mechanism (patch 0002) or another one of his choosing; the two search paths and
  LVS lines (0003, 0004); and the pad itself (DRC, LVS, ESD responsibility). Reason: the pads are part of the padframe,
  which belongs to the harness, not to the slot (`config.txt:35-46` **[V]**: changes "*only* ... in coordination with
  the slot's project designer", i.e. the change is the maintainer's, done with the slot owner).
- **The slot owner** is the user (`config.txt:132` `slot_16: Maier` **[V]**), so that side is settled **[I]**.
- **Can it stay in the user's fork?** For trials, yes **[V]** (it ran). For tapeout, no: the chip is built from Tim's
  repository (`RTimothyEdwards/gf180mcu_ocd_chipalooza`, the fork's upstream **[V]** `CLAUDE.md:59-61`); a fork-only
  change does not reach the shuttle **[I]**. Not checked: who runs the final build and from which repository **[U]**.
- **What the build does at tapeout with the new types** **[I]** from section 2 and the trial: `make config`/`padframe`
  place them; `gds-prefill` copies their GDS (from the PDK file for placeholders, from the custom GDS later);
  `gds-final` adds KLayout fill over the whole chip (`run_gen_filled_final_gds.sh`), so the pad must be fill-clean
  like the PDK pads (no fill-block layer was seen in asig's layer list, `measurements/pad_edges_asig_5p0.txt`; how
  `fill_all.rb` treats pad areas is [U]); `drc-final` checks them with the rest; `extract-top`/`lvs-top` need the
  search path and the spice (0003, 0004).
- **Risks** **[I]**:
  - silent failures: `make config` and `make padframe` exit 0 on a misspelt type or a missing path and produce a
    shifted padframe (5.2). Patch 0005 fixes the first; the second needs a log check (`couldn't be read`) or a
    harness change (`getcell` result checked in `place_pad_*`), not written.
  - name collisions: a custom name containing `__in`, `__bi_` or starting `gf180mcu_ocd_io__in` is taken for a digital
    pad by `parse_config.py` (startswith/substring tests, section 2); `make_placeholder_pads.sh` refuses such names.
  - the placeholders depend on the PDK GDS byte offsets (`GDS_START 9943626`, `GDS_END 9955592`); a different PDK build
    may move them. The same holds for the PDK pads themselves **[I]** (their mag views carry the same properties).
  - the ESD behaviour of a new pad is the designer's; the other agent found no measured data for the existing pads
    either (`PAD_STRUCTURES.md` section 1, items 4-5, 9).
- **Not checked:** Tim's view on any of this; whether other slot owners use custom pads; the precheck of the shuttle;
  wirebond and package rules for a different bond pad **[U]**.

## 8. Evaluation of the placeholder idea, and alternatives

**What holds** **[V]** (section 5): renamed copies in all views; same size and edge geometry by construction; the
harness flow runs once `parse_config.py` knows the names and Magic knows the directory; replacing the copy later by a
real cell of the same name, size, pins and edge geometry changes no harness file **[I]**.

**What does not hold, or only with conditions:**

1. **"Without changing the flow"**: three harness changes are needed first (0002, 0003, 0004), and they are Tim's to
   accept (section 7) **[V]**.
2. **Input and output types are only names.** The harness treats both identically (analog class, one net); "input" and
   "output" mean nothing to it **[V]** (`analog_pad_types`, one branch). That is fine as long as both real pads keep
   the one-net interface.
3. **The one-net interface is the real constraint.** A pad with the CDM resistor inside (bond pad ≠ core node), or one
   with an enable or a bias pin, needs a new pad class: `parse_config.py` branches for its pins, new
   `label_*` procedures for a second core-side strap, a second wrapper pin (which changes `slot16_wrapper` and its
   symbol), and the top-level netlists **[I]** from section 2. The IHP version of the harness had such a second
   core-side pin per analog pad (`<sig>_esd`, `B:README:276-290`; leftover wires `gf180mcu_ocd_chipalooza.v:90-91`)
   **[V]** for the text, **[I]** that it was a two-terminal pad.
4. **Placeholder validity.** A placeholder that is electrically asig makes later simulation results of the macros
   (CACE, A) still those of asig until the real pad replaces it **[I]**.

**Alternatives** **[I]**:

- **(a) Keep asig and put all protection and drive into the slot** (the present design, A's macros). No harness change;
  the other agent's report points the same way ("a cell of this project sits inside the slot wrapper",
  `PAD_STRUCTURES.md` 12.3). Limits: the bond pad's diodes and the 20 µm of Metal2 to the core edge stay asig's.
- **(b) The user's idea, one-net custom pads** (this plan). Small harness change, needs Tim.
- **(c) One placeholder type instead of two**, until the two real pads differ. Same effort; fewer names to agree.
- **(d) A two-terminal analog pad class** (bond pad + protected core pin), modelled on the IHP harness. Larger harness
  change, changes the slot wrapper; only if the CDM resistor must sit in the pad row.
- **(e) `gf180mcu_ocd_io__bi_a`** from the existing list: its `ANA` pin brings a resistor and small diodes (the other
  agent's question 1, `PAD_STRUCTURES.md` 11) but also a digital driver and five control pins; no new cell, but not
  what the design wants. Not evaluated here.

## 9. Step-by-step plan

1. **User decisions** (section 11): names, one or two types, where the files live, one-net or two-terminal.
2. **Ask Tim** (the user, not an agent; a draft can be written on request): is a custom analog pad library in the
   harness acceptable, which mechanism (0002 or his own), which location.
3. **In the fork, on a new branch** (not `main`): apply the fork's `fixes/pad_pins` patches, the placeholder library
   and 0001-0004 (+0005), as in `docs/custom_pads/README.md`; run `make clean-config config padframe wrappers symbols
   gds-slots`; check the logs for `Bad pad type`, `couldn't be read` (other than `open_source`), `Bad cell path`; run
   `pad_abutment_check_custom.tcl`.
4. **In A**: nothing until the real pads exist, except the documentation lines of section 6 when the user wants them.
5. **Design the real pads** (later, the user): keep `5LM_METAL_RAIL_PAD_60` (or reproduce its edges), add the Metal2 VSS
   edge stubs, the bond pad, the ESD structure, `ASIG5V` on Metal2 at the core edge within x 15.34-59.66; FIXED_BBOX and
   PR boundary 75 x 350; ports `ASIG5V DVDD DVSS VDD VSS` with asig's index/class/use.
6. **Check each real pad**: `pad_edge_check.py`, `pad_abutment_check_custom.tcl`, KLayout DRC of the cell alone, a Magic
   extraction against its spice; then swap it in for the placeholder (same file names) and rerun step 3.
7. **Then, with the user's consent** (hours): `extract-padframe lvs-padframe`, `gds-prefill`, `gds-final`, `drc-final`,
   `extract-top`, `lvs-top`.
8. **Hand the change to Tim** as a pull request or patch set from the fork (the user's decision; no agent pushes to B).

## 10. Assumptions I made (each stated)

- **A1** The names `gf180_cm_io` (library), `gf180_cm_io__asig_in`, `gf180_cm_io__asig_out` (cells). Chosen to avoid the
  `gf180mcu_ocd_io__` prefix and the `__in`/`__bi_` substrings that `parse_config.py` dispatches on. Not decided.
- **A2** `s16_an[0]` is the input and `s16_an[1]` the output (from the brief). The core signal names `s16_an_0`,
  `s16_an_1` were kept unchanged.
- **A3** The placeholder keeps the pin names `ASIG5V DVDD DVSS VDD VSS` (needed by `parse_config.py:199` and the padframe
  verilog template).
- **A4** The custom files sit in the harness under `custom_pads/gf180_cm_io/` (option 1 of section 4), for the trial only.
- **A5** The fork's own `fixes/pad_pins` patches belong in the base of the trial (they fix the pad power pin names the
  LVS needs); the trial applies them first, in both modes.
- **A6** "Quick steps" includes `gds-slots` (README step 6, under a second) and one padframe-only GDS write (286 s);
  neither is on the brief's list of forbidden steps. I ran both. If that was not wanted, say so.
- **A7** The model and effort in the brief ("Sonnet 5.5, high") differ from this session's configuration (another model,
  effort high, per the session metadata). I did the work as briefed regardless; the model is not named in any file.

## 11. Open questions for the user

1. **Names** of the library and the two cells (A1)? Do they have to follow a convention of Tim's?
2. **One type or two** for now (alternative c)?
3. **One-net or two-terminal**: should the CDM resistor of the input stay in the slot (macro), as now, or move into the
   pad (alternative d)? Same question for the output pad's protection.
4. **Where should the custom pad files live**: the harness, this repository, or a separate repository (section 4)?
5. **May I draft the message to Tim** (issue text for the fork, not sent), or do you write to him yourself?
6. **Patch 0005** (stop on a bad pad type): include it in what goes to Tim, or keep it separate as a bug report?
7. **The pre-existing `parse_config.py:201` defect** (stale signal name for digital pads): report it to Tim?
8. **Documentation in A** (section 6): update `submission.yaml`, `CLAUDE.md` §5 and the macro READMEs now, or only when
   the real pads exist?
9. **Long steps**: should a later session run `extract-padframe` and `lvs-padframe` (padframe only, duration unknown)
   with the placeholders, to prove the LVS side (patch 0004), or wait for the real pads?
10. **File names on `sudel_buecher`**: the convention there is `<date>_<model>_<topic>`; I left the model out of the names
    (A7). Rename if you want it in.

## 12. What I could not check

- Any LVS, extraction, DRC or chip-level GDS step (5.6) **[U]**.
- Tim's custom `netlist/schematic/gf180mcu_ocd_io.spice` (not in any commit) **[U]**.
- Repository D (the IHP reference) was not read; its relation of pad macros to harness pads is taken from the other
  agent's report (`PAD_STRUCTURES.md` 12.3-12.4) **[I]**.
- The cocotb testbenches of B (`verilog/dv`) and whether they instantiate pad cells **[U]**.
- How `fill_all.rb` treats the pad row **[U]**.
- What Magic does if a custom pad without explicit subcell paths is the first pad it loads (5.2) **[U]**.
