<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# custom_pads: measurements of the PDK pads for slot 16's custom pads

`measurements/` holds edge measurements of PDK pads made for `../CUSTOM_PADS_PLAN.md` (sections 3 and 4). They
constrain the design of the custom pads, so they stay with the design.

| File | What it is |
| --- | --- |
| `measurements/pad_edges_asig_5p0.txt` | shapes of `gf180mcu_ocd_io__asig_5p0` touching each pad edge, per layer |
| `measurements/asig_5p0_metal5_rail_nets_west_edge.txt` | the Metal5 rails of `asig_5p0` at its west edge and their nets |
| `measurements/edges_gf180mcu_ocd_io__bi_24t.txt` | the same edge measurement for `gf180mcu_ocd_io__bi_24t` |
| `measurements/edges_5LM_METAL_RAIL_PAD_60.txt` | the same for the bond pad / rail cell `5LM_METAL_RAIL_PAD_60` |

Until 2026-11-28 this directory also held the material of the first placeholder trial (patches 0001–0005,
`upstream_fixes/`, `run_trial.sh`, `make_placeholder_pads.sh`, `pad_edge_check.py`, `pad_abutment_check_custom.tcl`,
`tools/`, `logs/`). It concerns only the harness and was moved, on the user's instruction, with its history to the
branch `sudel_buecher` of `tatzelbrumm/gf180mcu_ocd_chipalooza`, directory `sudelbuecher/logs/custom_padframe/first_trial/`
(same relative paths; its `README.md` there is the former README of this directory). The patches are also commits
`e81776f` (0001–0004), `21ca197` (0005) and `33743f3` (`upstream_fixes/`) on the branch `custom_padframe` of
`tatzelbrumm/gf180mcu_ocd_chipalooza`.
