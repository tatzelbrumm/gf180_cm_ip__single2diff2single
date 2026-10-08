<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Kickoff: GF180 redesign of the self-contained bias references of the class-AB driver

Written 2026-10-08 22:40 by the session that ported the class-AB driver (Claude, configured model `claude-opus-5-5`),
for a new session. Christoph decides scope and targets; confirm the open questions (§3) with him first.

## 1. Task

The class-AB pad driver of `gf180_cm_ip__single2diff2single` takes its six bias currents from the bias tree
`ClassABBiasIn`, fed by a 5 µA reference current into `iref`. On IHP there were two self-contained references
that make that current on chip; on GF180 they do not exist yet. **Re-design them for GF180MCU (gf180mcuD) — do not
transliterate the IHP sizes:**

1. `ClassABBiasOA`: resistor-free Oguey–Aebischer core (IHP `oa_core`), output 5 µA into the `ClassABBiasIn` tree.
2. `ClassABBiasBG`: current-mode (Banba) bandgap core with vertical PNPs (IHP `bg_core`), same output.

Each as cells in `macros/ClassABBias/` (schematic, symbol, CACE suite like `ClassABBiasIn`), with start-up, and with
a disable (see §3.5). The IHP design stays the reference and is not changed.

## 2. Where things are

| what | where |
|---|---|
| design repo (write) | `~/EDA/gf180_cm_ip__single2diff2single` — macros `ClassABBias`, `ClassABDriver`, `PadEnable`, the two pads, `OgueyAebischerBias` |
| notes worktree (write) | `~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/` — `logs/main/`, `chatlog/`, `backups/`, `deliveries/`, this folder |
| IHP notes (read only) | `~/EDA/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/` |

Read first:

- IHP `improvements/bias.md` (design, results, open points of all four variants), `improvements/sim/d2s_bias_ref.spice`
  (`oa_core`, `bg_core`, the source netlists), `improvements/sim/run_bias.py` and `results_bias.txt` (the IHP checks and
  numbers; do not rerun IHP), `improvements/xschem/d2s_bias_oa.sch`, `d2s_bias_bg.sch` (Christoph's hand-edited
  drawings, layout conventions in `improvements/xschem/README.md`).
- IHP `power_down/log.md`, entry 17:10 and 20:45: the switch plan for the cores (MS1 gated, vpg pulled to vdd, ks to vss).
- GF180 repo: `macros/ClassABBias/README.md`, `macros/ClassABDriver/README.md`, `macros/PadEnable/README.md`,
  `HANDOVER_gf180_migration.md` §7–8, `macros/OgueyAebischerBias/README.md` (the earlier GF180 resistor-free reference at
  100 nA: sizing method, I_spec / A_VT table, PSRR problem).
- Running log of the port: `sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md` (every number and pitfall).
- `tools/` next to this file: the plain-ngspice sizing harness of the port (README there).

## 3. Open questions for Christoph (ask at the start; defaults in brackets)

1. Which of the two (or both)? The pads take iref from outside; maybe one chip-level reference feeds all pads.
   [both, OA first]
2. Targets: output current [5 µA into the tree], allowed drift −40…125 °C [bandgap: ±3 %; OA: whatever the topology
   gives, report it], process spread [report], mismatch σ [≤ 2 % bandgap, ≤ 5 % OA], line sensitivity [≤ 1 %/V],
   start-up from 0 V with 1 µs and 1 ms ramps at all corners [required], area budget [report].
3. Device family and supply: 03v3 at 3.0–3.6 V [default], or 06v0 / 5 V (`docs/OPERATING_LIMITS.md`).
4. Relation to `macros/OgueyAebischerBias` (100 nA, PSRR 31 dB, cascoding not done): merge, replace or leave alone?
   [leave alone]
5. Disable: the cores have internal nodes that need switches (MS1's gate, vpg, ks). Ports `en`, `en_b` on the core cells
   with the switches inside, or a `PadEnable`-style sub-cell? [a sub-cell `RefCoreEnable` in `macros/PadEnable`,
   instantiated in the core cell, so the enable stays its own sub-macro]

## 4. GF180 facts the redesign starts from (checked 2026-10-06/08 in gf180mcuD from gf180mcu_fd_pr e11a8c9)

- MOS 03v3 bins: L 0.28–50 µm, **W ≤ 100 µm per instance counting the total W, not W/nf** (W = 400 µm with nf = 40 fails
  "could not find a valid modelname"). IHP `oa_core` MS1 is 0.5/100 µm → needs a different solution (L ≤ 50 µm).
- Mismatch: `.param sw_stat_mismatch=1`; `fets_mm` draws one sample per instance with σ from that instance's own W·L and
  **ignores `m`**: draw matched multi-unit devices as one instance with nf = units. A_VT ≈ 7.1 (n) / 6.7 (p) mV·µm;
  I_spec per square at IC = 1 ≈ 360 nA (n, slope 1.41) / 97 nA (p, 1.46) (`OgueyAebischerBias/README.md`).
- Corners: `sm141064.ngspice` sections `typical ss ff sf fs`, `res_typical res_ss res_ff`, `bjt_typical bjt_ss bjt_ff`,
  `moscap_*`, `mimcap_*`, `bjt_statistical`, `res_statistical`. (06v0 devices use `_t` in every MOS corner in this file.)
- Resistors (first-order body TC `r_tc1` from the model cards; the terminal resistances have their own TC, so simulate the
  effective TC): `ppolyf_u_1k` 1 kΩ/sq −0.094 %/K; `ppolyf_u_2k`; `ppolyf_u_3k` −0.167 %/K; `ppolyf_u` 350 Ω/sq
  −0.009 %/K; `npolyf_u` 310 Ω/sq −0.14 %/K; `ppolyf_s` 7.3 Ω/sq +0.32 %/K; `nplus_u` 60 Ω/sq +0.136 %/K; `pplus_u`
  185 Ω/sq +0.138 %/K. Symbols: pins M P B (bulk is a pin). IHP rhigh was −0.22 %/K and nearly cancelled V_BE by itself;
  that balance has to be rebuilt (a series mix of negative- and positive-TC resistors is one option).
- PNPs: `pnp_05p00x05p00`, `pnp_10p00x10p00` (and the 0.42 µm strips), pins C B E, **geometry fixed, ratios only via m**;
  they have mismatch parameters (`mis_is_*`, `mis_bf_*`, agauss); check whether `sw_stat_mismatch` turns them on.
- MIM option 2 fF/µm² (`cap_mim_2f0fF`); MOS caps `cap_pmos_03v3` etc. (moscap sections).

## 5. Cloud tools (the new session's container starts empty)

Follow `sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/cloud_environment.md` (IHP notes): it builds
xschem 3.4.8RC and ngspice-47 as in Christoph's IIC-OSIC-TOOLS image and installs gf180mcuD from the image's open_pdks
build (`1689ac3`, ciel release asset). The IHP PDK and OpenVAF are not needed for this task. Add CACE in a venv
(`pip install cace`, 2.13 was used) and `PDK_ROOT`/`PDK=gf180mcuD`.
The 2026-10-08 numbers came from a different setup (ngspice-42, gf180mcuD assembled from gf180mcu_fd_pr `e11a8c9`):
rerun `ClassABBiasIn` and `ClassABDriverBiased` CACE once first and note any differences in the log before designing.

## 6. Verification flow (reuse; it works)

1. Size in plain ngspice first (`tools/`), then draw: start from the IHP sheets `d2s_bias_oa.sch` / `d2s_bias_bg.sch`
   with `macros/ClassABDriver/scripts/port_classab_from_ihp.py` (symbol/property substitution keeps Christoph's
   drawing; extend its tables for the new devices, PNPs and resistors whose pins differ) or with `scripts/xsheet.py`.
2. Round trip: `macros/ClassABDriver/scripts/check_classab_port.py <reference.spice> <xschem netlist> <subckt> <cell>`,
   MISMATCHES 0, and sanity-check it once with a deliberate error.
3. CACE: copy `macros/ClassABBias/scripts/gen_cace.py` (currents of the six diodes, line sensitivity, mismatch) and add
   start-up (supply ramps, `t_startup` measured as in `OgueyAebischerBias`: last time outside ±10 % of the final value)
   and temperature sweeps. `make sim-cace` once the Makefile package (`deliveries/2026-10-08_opus_makefiles.zip`) is
   installed; add the new datasheets to `CACE_CELLS` in `macros/ClassABBias/Makefile`.
4. Then the driver with the real reference: an `iref`-free pad variant, or a CACE fixture `ClassABBiasOA` → driver.

Pitfalls already paid for (details in the running log):

- CACE 2.13: a condition named like a pin takes its own value (use `i_ref`, not `iref`); state every condition a
  parameter does not sweep (else a pin's Vmin is used); brace-escape `CACE{…}` inside symbol `value=` strings; unit `%`
  shows 100 × the echoed value (echo fractions); `off` in a YAML list is false; templates are netlisted with the PDK
  xschemrc + templates folder only, the DUT with its own folder's xschemrc.
- ngspice: noise refuses `option KLU`; read earlier plots as `op1.<vec>` after a later analysis; with all current roots
  off (disabled state) the DC operating point is unreliable — read leakage at the end of a short transient.
- Transients: `abstol=1e-13` and an explicit tmax, or cold corners take minutes.
- xschem: in a cloud container the UTF-8 BOM at the start of some project `xschemrc` files breaks loading (netlist from a
  BOM-stripped copy there; leave the files alone); xschem exits 10 on undriven output pins while writing a complete netlist.
- Self-biased references can have a zero-current or a false operating point: check start-up from 0 V without `.nodeset`,
  and the IHP bandgap's R1A/R1B asymmetry trick.

## 7. Rules (Christoph's standing orders)

- **No git commands** without asking first (even `status`/`log` can leave an `index.lock` on the bridge). Never
  `git switch sudel_buecher` in the main directory.
- Write to the computer only with `device_commit_files` from a staged folder under `/mnt/user-data/outputs/`, with
  `expectedMtimeMs` guards on existing files; verify checksums afterwards (PNG/SVG get a provenance stamp: compare
  decoded pixels). Before overwriting anything, copy the old version into `sudelbuecher/backups/<date>_<topic>/` on the
  computer. Never overwrite Christoph's hand edits.
- Makefiles cannot be written by the bridge: deliver them as a zip in `sudelbuecher/deliveries/` with an installer.
- No Microsoft formats; never suggest a spreadsheet. Index external sources, don't copy them.
- Memory: never add inferences about Christoph's habits or views to persistent memory without asking.
- Keep a running log `sudelbuecher/logs/main/<date>_<model>_reference_redesign_log.md`, updated after each milestone
  (context compaction happens); export the chat log with `sudelbuecher/chatlog/export_chatlog.py` (it handles compaction).
- Results go to the macro READMEs and `verification/cace/results/<cell>/`; update `HANDOVER_gf180_migration.md`.

## 8. Suggested order and checkpoints

1. Confirm §3 with Christoph. 2. OA core: size (tools), start-up, PVT, mismatch → sheet → round trip → CACE → log.
3. Checkpoint with Christoph (numbers, area, usage so far). 4. Bandgap: TC balance with GF180 resistors, PNP ratio via
m, false operating point, start-up, headroom at ss/3.0 V/−40 °C → sheet → round trip → CACE → log. 5. Driver with each
reference over PVT (I_Q, loop, offset), compare with the ideal fixture as on IHP (`bias.md`, "Results, driver").
