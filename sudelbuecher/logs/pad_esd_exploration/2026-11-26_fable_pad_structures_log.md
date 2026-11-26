<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Work journal: exploration of the GF180 pad structures and their ESD protection

Claude Code cloud session `session_01XU3KH8TTLjkQNhWPaFJmRL` (environment `gf180mcuD`; configured model
`claude-fable-5-2`, last served model the same per the session record; the serving model may differ). 2026-11-26, times UTC
(Europe/Berlin is one hour ahead). Brief: branch `pad_esd_exploration`, `docs/AGENT_BRIEF_PAD_STRUCTURES.md`.
Written by the assistant; not a chat log. The chat log is `sudelbuecher/chatlog/2026-11-26_fable_pad_structures_and_esd_exploration.md`.

Deliverables: branch `pad_esd_exploration`, `docs/PAD_STRUCTURES.md` (the report) and
`docs/PROPOSALS_FOR_CLAUDE_CLOUD_CONFIG.md`. This journal, the scripts (`tools/`) and their outputs (`*.out`) are here
because Christoph said during the session that the logs go on `sudel_buecher`; the brief had asked for the journal
"next to the report".

Entries are numbered because the report cites them. Each: what I did, what I found, what I could not check.

## 1. Brief and project documents

Read `docs/AGENT_BRIEF_PAD_STRUCTURES.md`, `CLAUDE.md`, `docs/IHP_TO_GF180_PORT_MAP.md`, `HANDOVER_gf180_migration.md`,
`docs/OPERATING_LIMITS.md`, `docs/GF180_PROCESS_OPTIONS.md`, and the READMEs of the two pad macros.
The session started on `pad_esd_exploration` at `f7974eb`, working tree clean.

## 2. Repositories

| Repository | How | Commit |
| --- | --- | --- |
| A, this one | the session's checkout; `sudel_buecher` added as a worktree `../gf180_cm_ip__single2diff2single_sudelbuecher` | `pad_esd_exploration` `f7974eb`, `sudel_buecher` `7b4c6f9` |
| B `tatzelbrumm/gf180mcu_ocd_chipalooza` | `add_repo` answered that read access to a public repository needs no attachment; shallow clone of all branches | `main` `2f18cd4` |
| C `tatzelbrumm/claude-cloud-config` | anonymous shallow clone | `main` `39d01fc` |
| D `tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single` | anonymous shallow clone, all branches | `main` `60f270a`, `claude/c3-s2d-pad-layout` `c913388`, `claude/c2-pad-layout` `c503b87`, `pcells` `4e0fdb7`, `claude/c3-s2d-pad-layout-sudel` `0e98d06` |
| `google/gf180mcu-pdk` | anonymous shallow clone; **not in the brief's list** (entry 16) | `de3240d` |
| `RTimothyEdwards/gf180mcu_ocd_io` | anonymous shallow clone; **not in the brief's list** (entry 16) | `6e0e354` |

Nothing was pushed to B, C, D or the two upstream repositories.

## 3. Two subagents

- **evampire page.** A web-fetch subagent read `https://evampire.readthedocs.io/en/latest/esd/io-cells.html` and five
  sibling pages (`index`, `simulation`, `references`, `layout`, `cells` under `/esd/`) and returned 43 numbered claims
  with the page's own source keys. Not fetched by it: `events`, `discharges`, `results-hbm`, `results-iec`,
  `higher-levels`, `standards`, `glossary`. It found: the page is about `gf180mcu_fd_io` only; no author is named; the
  page links to `github.com/mithro/evampire` (`docs/esd/io-cells.rst`), which I did not read; three different values
  for the NMOS holding voltage on the page (about 6 V, 6.2 V, 6.8 V).
  I treated its report as a list of claims to check, not as facts (report section 8).
- **IHP parametric cells.** A general-purpose subagent surveyed D for the parametric clamp, diode and pad-wiring
  generators. It made three detached worktrees under the session scratchpad. Its report gave `branch:path:line` for
  each statement; I checked a sample myself (entry 15).
- Both reports are filed verbatim next to this journal (`2026-11-26_fable_subagent_report_1_extract_evampire_esd_page_claims.md`,
  `..._report_2_ihp_parametric_cells_survey.md`), extracted from the transcript by `tools/extract_handbacks.py`; only the
  session-internal agent id in their first line is removed. They are subagent output, not checked text.

## 4. Chat log convention

Christoph asked during the session to follow the chat log conventions of his repositories and to pick the most
complete and verbatim one that does not conflict with what may be shared. I compared every chat log tool on every
branch of A, B, C and D:

| Tool | Where | User and assistant text | Tool calls | Check |
| --- | --- | --- | --- | --- |
| `export_chatlog.py` (11417 bytes) | A `sudel_buecher`, `sudelbuecher/chatlog/` | verbatim, mid-turn user messages placed where they arrived, attached text files verbatim, question cards | one-line summary, **shell commands verbatim** in collapsed blocks, outputs omitted | none |
| `build_chatlog.py` + `verify_chatlog.py` + `session_chatlog.sh` | B and C `sudel_buecher` (identical), `sudelbuecher/chatlog_tools/` | verbatim, mid-turn messages, hand-backs and notifications labelled | one-line summary only | script: every text present, no 40-character window of the reasoning |
| older `build_chatlog.py`, `verify_chatlog.py` | D, `sudelbuecher/design_considerations/*/chatlog_tools/` | as B, earlier versions | summary only | as B, earlier |
| `export_chatlog.py` (1.4 to 2.2 kB) | D, `docs/*/tools/` | text only | none | none |

Choice: **A's `export_chatlog.py`** for the content (the only one that keeps the commands; it is also the tool of
the branch the log is filed on), **plus B's `verify_chatlog.py`** as the check the brief asked for through
`session_chatlog.sh`. The reasoning is left out by both. `session_chatlog.sh` itself was not used, because it calls
B's builder; its two checks are what `verify_chatlog.py` does. Result of the final run: entry 17.

## 5. The pad library in the PDK

- `/foss/pdks/gf180mcuD` links to `ciel/gf180mcu/versions/e7a6777d157a9d94c7ac757457b9e4309e9e9000/gf180mcuD`.
  `.config/nodeinfo.json`: open_pdks `e7a6777`, `gf180mcu_ocd_io` `6e0e354`, `gf180mcu_fd_io` `40cdef6`,
  `gf180mcu_fd_pr` `5e4be87`; options `MIM_2P0`, `METAL5`.
- `libs.ref/gf180mcu_ocd_io/`: `gds` (one file, 57.8 MB), `lef` (one file), `lib` (12 corners), `mag` (107 files),
  `spice` (one file, 945 lines), `verilog` (3 files), `xschem` (17 symbols).
- Read the spice file completely, the LEF macro of `asig_5p0` completely, the liberty entry and the Verilog module
  of `asig_5p0`.
- Documents inside `$PDK_ROOT/gf180mcuD`: a search for `*.pdf`, `*.rst`, `*.md`, `README*` finds only
  `libs.tech/klayout/tech/lvs/README.md` and `libs.tech/klayout/tech/drc/README.md`. No design manual.

## 6. Models

- `grep -n -i 'esd\|snapback\|tlp\|hbm\|cdm' libs.tech/ngspice/sm141064.ngspice libs.tech/ngspice/design.ngspice`: no hit.
- Diode models read: `diode_nd2ps_06v0` (line 38379, `bv=11`, `rs='2e-010*rsa'`, `ik=229000`), `diode_pd2nw_06v0`
  (line 38405, `bv=10.5`). `nfet_06v0_dss` (37039, defaults `s_sab=0.28u d_sab=3.78u`), `pfet_06v0_dss` (38075,
  `d_sab=2.78u`). `rsh_ppolyf_u` 350 / 420 / 280 (lines 413, 441, 469). `cap_nmos_06v0` (39037-39042).
- The 6 V FET sections in every corner are `nfet_06v0_t`, `pfet_06v0_t`, with corner parameters set before them
  (lines 137-167); I first took that for a mistake and then saw the parameters.

## 7. Layout hierarchy

`tools/magtree.py` over the 17 pad cells: `2026-11-26_fable_mag_hierarchy.out`. `asig_5p0` → `GF_NI_ASIG_5P0_BASE` →
`comp018green_esd_hbm`, nothing else with devices. `comp018green_esd_cdm` is in the five digital pads, the clamp
cells in `dvdd`, `dvss`, `vdd`, `vss`, `cor`.

## 8. Geometry of `asig_5p0` from the GDS

`tools/gds_layers.py`, `gds_shapes.py`, `gds_rings.py` with `klayout.db` 0.30.12:
`2026-11-26_fable_asig_gds_layers.out`, `..._asig_gds_shapes.out`, `..._asig_gds_rings.out`.
A first version of `gds_layers.py` parsed the `.lyp` wrongly (names came out as `?`); the version filed here reads
`tools/layers.tsv`. Contact arrays (6 x 100 at pitch 0.5; 2 x 85 at 0.47 x 0.64) came from an inline script that is
not filed; the numbers are in the report, section 4.2.

`DIODE_MK` total 1360 µm² = 4 x 150 + 4 x 150 + 4 x 40, which matches the netlist. `PR_bndry` 0/0 is one
75 x 350 rectangle.

## 9. Layers across the library

Inline script (not filed). Layers present in `gf180mcu_ocd_io.gds`: 0/0, 21/0, 22/0, 23/5, 24/5, 30/0, 31/0, 32/0,
33/0, 34/0, 34/10, 35/0, 36/0, 36/10, 37/0, 38/0, 40/0, 41/0, 42/0, 42/10, 46/0, 46/10, 49/0, 55/0, 81/0, 81/10,
110/5, 112/1, 115/5, 137/5, 166/5, 204/0. Absent: DNWELL 12/0, ESD 24/0, LVS_IO 119/5, LVS_Source 100/8.

| Cell | SAB 49/0 | DIODE_MK | RES_MK | MOS_CAP_MK | ESD_MK 24/5 | Latchup_MK 137/5 |
| --- | --- | --- | --- | --- | --- | --- |
| `asig_5p0` | 0 | 12 (1360 µm²) | 0 | 36 (8100 µm²) | 0 | 0 |
| `bi_t`, `bi_a` | 22 (3842 µm²) | 16 (87 µm²) | 12 | 14 | 2 (6743 µm², `bi_t`) | 2 (3934 µm², `bi_t`) |
| `bi_24t` | 23 (4602 µm²) | 16 | 14 | 12 | not looked at | not looked at |
| `in_c`, `in_s` | 23 (3853 µm²) | 16 | 14 | 12 | not looked at | not looked at |
| `dvdd`, `dvss`, `vdd`, `vss` | 1 (1070 µm²) | 4 (160 µm²) | 12 | 12 (2900 µm²) | 0 (`dvdd`) | 0 (`dvdd`) |
| `cor` | 2 (2140 µm²) | 0 | 24 | 86 (21500 µm²) | 0 | 0 |
| `fill5` / `fill10` | 0 | 0 | 0 | 70 (158 µm²) / 32 (1344 µm²) | - | - |
| `brk2`, `brk5`, `fill1`, `fillnc` | 0 | 0 | 0 | 0 | - | - |

## 10. Harness: padframe

- `B:config.txt`: pad types (lines 51-56), `s16_source` (88), `slot_16: Maier` (132), `s16_an[0]`, `s16_an[1]` both
  `asig_5p0` (169-170).
- Supply nets per pad type in `B:verilog/gl/gf180mcu_padframe.v` (pin names as written in that file):

  | Count | Cell | iovdd | iovss | vdd | vss | Instances (first) |
  | --- | --- | --- | --- | --- | --- | --- |
  | 40 | `asig_5p0` | vdd5v0 | vss5v0 | vdd3v3 | vss3v3 | `pad_s1_an_0` ... |
  | 4 | `bi_24t` | vdd5v0 | vss5v0 | vdd3v3 | vss3v3 | `pad_gpio_8` ... `pad_gpio_11` |
  | 9 | `bi_24t` | vdd5v0 | vss5v0 | vddd | vss3v3 | `pad_SDO`, `pad_gpio_0` ... |
  | 4 | `in_c` | vdd5v0 | vss5v0 | vddd | vss3v3 | `pad_SDI`, `pad_CSB`, `pad_SCK`, `pad_clk` |
  | 2 / 1 | `dvdd` | vdd5v0 | vss5v0 | vdd3v3 / vddd | vss3v3 | `pad_vdd5v0_1`, `_2` / `pad_vdd5v0_0` |
  | 6 | `dvss` | vdd5v0 | vss5v0 | vdd3v3 | vss3v3 | `pad_vss5v0_0` ... `_5` |
  | 5 / 2 | `vdd` | vdd5v0 | vss5v0 | vdd3v3 / vddd | vss3v3 | `pad_vdd3v3_0` ... `_4` / `pad_vddd_0`, `_1` |
  | 6 / 1 | `vss` | vdd5v0 | vss5v0 | vdd3v3 / vddd | vss3v3 | `pad_vss3v3_0` ... `_5` / `pad_vss3v3_6` |
  | 2 / 2 | `cor` | vdd5v0 | vss5v0 | vdd3v3 / vddd | vss3v3 | `corner_nw`, `corner_ne` / `corner_sw`, `corner_se` |

- Positions from `B:magic/gf180mcu_padframe.mag` (transform lines, 5 nm units). West side, south to north, y of the
  instance origin in µm: `vss3v3_6` 532, [`brk5` 627], `vdd3v3_4` 702, `vdd3v3_3` 872, `s18_an_1` 1042, `s18_an_0` 1212,
  `s17_an_1` 1382, `s17_an_0` 1552, `vss3v3_5` 1722, **`s16_an_1` 1892, `s16_an_0` 2062**, `s15_an_1` 2232,
  `s15_an_0` 2402, `vss5v0_5` 2572, `s14_an_1` 2742, ... `vss5v0_4` 3422, ... corner NW 5070.
  `dvdd` pads: `vdd5v0_0` east side y 457; `vdd5v0_1`, `_2` top side x 1169, 967. `dvss` pads: east 1647, 4027; top
  x 2381, 1371; west 3422, 2572. `brk5`: east y 622 (line 2449), west y 627 (line 5469).
- `B:scripts/gen_padframe.tcl`: placement procedures (lines 62-96), `place_spacers_left` (346-363: nine `fill10`, then
  `fill5` or `brk5`, then `fill1` extras), the west-side sequence (528-551).
- Earlier analysis of the pin names: B `sudel_buecher`, `sudelbuecher/harness_tools/fixes/pad_pins/ANALYSIS.md` (read
  the first 80 lines). `main` at `2f18cd4` still has `.iovdd/.iovss/.vdd/.vss`.

## 11. Harness: slot 16 wrapper and supplies

- `B:magic/slot16_wrapper.mag`: label count by layer: `metal3`: `analog_bus0..3`, `clk`, 24 `dig_in[N]`, 12
  `dig_out[N]`, `enable`, `ibias0`, `ibias1`, `reset`, 2 `s16_an[N]`, `vbias`; `metal5`: `vdd_3v3`, `vdd_5v0`, `vss_3v3`,
  `vss_5v0`. `FIXED_BBOX 0 0 254854 82542` (line 189).
- `B:verilog/rtl/chipalooza_frame.v`: `power_stage switch5v0` and `power_stage3v3 switch3v3` per slot (895-913),
  `avdd_rail = vdd5v0`, `dvdd_rail = vdd3v3` (265-266), slot 16 instance (1379-1399).
- Not traced: the `power_stage` cells themselves, the `s16_an_*_esd` wires in the top-level netlist, the routing from
  pad to wrapper pin.

## 12. Model evaluation of the pad diodes

`tools/asig_diodes_dc.spice`, output `2026-11-26_fable_asig_diodes_dc_ngspice.out`. ngspice-47.

- The first deck included the PDK pad netlist and stopped with
  `Error on line 1412 or its substitute: g.x1.xc1.gc_moscap x1.xc1.c_moscap_int1 0 dvss dvdd 3.600000000000000e+01 e9`
  `unknown parameter (e9)`. The line comes from `XC1 ... cap_nmos_06v0 ... m=36` (behavioural capacitor with a
  multiplier). The filed deck uses a copy of the three diode lines without `XC1`.
- Typical corner, DVDD = 5 V, DVSS = 0. Pad current: 27 °C: -0.6 V 2.8 µA, -0.5 V 77 nA, -0.3 V 56 pA; 5.5 V 59 nA,
  5.6 V 2.6 µA, 5.7 V 94 µA. 125 °C: -0.3 V 0.37 µA, 5.3 V 0.24 µA. -40 °C: -0.7 V 0.38 µA, 5.7 V 0.32 µA.
  Between the rails the current equals `gmin` times the voltage (5 pA at 5 V), so the models give no leakage figure.
- Small-signal capacitance of the pad node at 1 MHz: 0.96 pF (0 V), 0.81 pF (1.65 V), 0.80 pF (2.5 V), 0.96 pF (5 V).
- `ppolyf_u` 2.5 x 2.8 µm: 449 Ω.
- DVDD = 0 V: pad 0.5 V 59 nA, 0.6 V 2.6 µA, 0.7 V 94 µA, 0.8 V 2.7 mA into DVDD.

## 13. The pad net through the metal stack

Inline script (not filed) with `klayout.db`: starting from the Metal5 polygon under the pad centre, following Via4 to
Via1. Result: Metal5 one polygon 4442 µm², Metal4 and Metal3 3001 µm² each, all within x 3.5-71.5, y 0-65.33; Metal2
one polygon x 3.5-71.5, y 0-350; Metal1 eight polygons within x 12.5-62.5, y 73.41-134.5; COMP on the net: eight
shapes of 50 x 3 µm. Cross-sections of the Metal2 polygon: `2026-11-26_fable_asig_pad_net_metal2.out` (68 µm wide
at y 63; eight strips, 20.32 µm in total, from y 66 to 349).

## 14. Rules

- KLayout deck: `libs.tech/klayout/tech/drc/gf180mcu.drc` (202 lines) and 41 files in `rule_decks/`. Listed the rule
  names of `esd`, `sab`, `guard_ring`, `comp`, `nwell`, `dualgate`, `lvpwell`, `dnwell`, `nplus`, `contact`, `pres`,
  `hres` with their lines; read `esd.rb` completely.
- `grep -rn "HVNESD\|HVPESD\|LVESD\|'IO\.[0-9]\|LU\.[0-9]\|14\.4\.5"` over the drc folder: no hit. `latchup_mk` and
  `esd_mk` occur in `generic_layers.rb:67, 78` (layer definition), `geom.rb:87, 98` (grid and angle check) and
  `sab.rb:113-176` (`ESD_MK` as a condition of SB.12 and SB.16).
- Magic tech file `libs.tech/magic/gf180mcuD.tech`: searched for `hvnesd`, `latch`, `IO.1`: no hit. Its DRC section
  was not read.
- Break cells: Metal3, Metal4, Metal5 of `brk5` and `brk2` each have two full-width polygons, y 246-253 and 318-325;
  `fill5` has 26 per layer.

## 15. Spot check of the IHP survey

Read myself on `claude/c3-s2d-pad-layout`: `scripts/pcells/clamp_base_code.py` lines 20-22, 38-54, 105-114, 194-198;
`clamp_engine.py` lines 19-21, 33-49, 93-97, 116-124, 385-389; `scripts/pcells/README.md` lines 9-11, 22, 273-292,
318-327; on `claude/c3-s2d-pad-layout-sudel`: `Claude/skills/ihp-flat-cell-to-pcell/SKILL.md` lines 18-47. All agree
with the subagent's quotations. Not checked by me: its statements on `build_template.py`, the notes-branch reports
and the recorded DRC and LVS results of the IHP pad macros.

## 16. Foundry documents and the network

- `curl` to `https://gf180mcu-pdk.readthedocs.io/...` returned code 000 (refused by the network policy);
  `evampire.readthedocs.io` and `en.wikipedia.org` returned 200.
- I cloned `google/gf180mcu-pdk` and read `docs/physical_verification/design_manual/`: `drm_14.rst`, `drm_14_3*.rst`,
  `drm_14_4*.rst`, `drm_14_5.rst`, `drm_14_5_5.rst` to `drm_14_5_8.rst`, `drm_14_6.rst`, `drm_14_6_3.rst`; tables
  `20_ESD_Implant_54.csv`, `56_IO_Latch-up1_156.csv`, `56_IO_Latch-up2_158.csv`, `58_HV_SAB_MOSFET_168.csv`,
  `59_HV2_SAB_MOSFET_170.csv`, `64` to `67_ESD*_Performance_*.csv`; figures `HV_SAB3.png`,
  `ESD_Characterization7.png` (looked at). Not read: `drm_14_1`, `drm_14_2`, the 3.3 V tables 57, 60-63, the
  electrical-parameter documents.
- Christoph wrote that he would unblock the manual site if told how. I named the host and proposed the change with
  the environment tool; he approved it. `gf180mcu-pdk.readthedocs.io` is now in the allowed hosts of the personal
  environment `gf180mcuD`. Fetched afterwards (HTTP 200): `drm_14_5_7.html`, `drm_14_4_5.html`, and under
  `IPs/IO/gf180mcu_fd_io/`: `index`, `functional`, `features`, `analog`, `conditions`, `esd`, `latchup`, `power`, `specs`
  (two guessed names returned 404). The rendered text agrees with the repository files where I compared
  (`analog`, `esd`, `conditions`, `power`).
- I cloned `RTimothyEdwards/gf180mcu_ocd_io` and read `README.rst`, `TODO`, `docs/analog.rst`,
  `docs/specs/16_ESD_Protection.csv`, `docs/specs/15_Operating_Conditions.csv`, `docs/power.rst`, and looked at
  `docs/specs/Analogue_Signal_Cells1.png` and `..._Cells2.png`.
- `en.wikipedia.org/wiki/Snapback_(electrical)` was fetched once for availability (HTTP 200) and not read.

## 17. Writing, commits, chat log

- Report and proposals written on `pad_esd_exploration`; after writing, I re-checked the line citations I had not
  read off a tool output directly and corrected eight places in the report and three in the proposals.
- Chat log: see the entry appended below this one after the export ran.

## Not checked (summary)

No extraction or LVS of a pad cell. No ESD or clamp simulation. No layout dimensions of `comp018green_esd_cdm`, the
output drivers or the clamp. No metal sheet resistance, current limit or rail resistance. Not the routing from pad
to slot. Not the upstream harness repository. Not the evampire source repository. Whether the fork's `main` moved
during the session.
