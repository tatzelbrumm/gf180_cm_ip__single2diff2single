# HANDOVER_gf180_migration.md

Written 2026-10-06 (evening, Berlin) by Claude Sonnet 5.5, handing the design migration to a fresh
session (intended: Claude Opus). Technical state only. The verbatim record of how we got here is the
chatlog in the `_sudelbuecher` worktree (`sudelbuecher/chatlog/`); read it for exact wording, not this file.

**Read `CLAUDE.md` first**, then `docs/IHP_TO_GF180_PORT_MAP.md`, then this file.

## 1. Goal

Port `sg13cmos5l_cm_ip__single2diff2single` (IHP, reference repo next to this one) to GlobalFoundries
GF180MCU (`gf180mcuD`) for Chipalooza #3: single-ended analog input pad -> on-chip fully differential
signal -> buffered single-ended analog output pad. The user wants a thorough migration, not a copy:
device sizes, protection and operating limits are re-derived for GF180.

## 2. Done (mechanical retarget, 2026-10-06)

- Skeleton and docs: `CLAUDE.md`, `docs/{GF180_PROCESS_OPTIONS,OPERATING_LIMITS,IHP_TO_GF180_PORT_MAP}.md`,
  `harness_stub/`, `dependencies/`, `floorplan/README.md`, macro placeholders.
- Layout convention: `layout/{klayout,magic,gds}/` at top level and in both macros. Every Makefile target
  reads `layout/gds/<cell>.gds` only (`LAY_GDS_DIR`), no fallback to `layout/klayout/`. See README, "Layout
  Sources and the Exported Tapeout GDS".
- Makefile (top + both macros) retargeted: `TOP = gf180_cm_ip__single2diff2single`, `gf180mcuD.magicrc`,
  `RENDER_TECH = gf180mcuD` (listed by `sak-pdk`, not yet run through `sak-render.py`). Macro Makefiles are
  derived from the template's analog macro Makefile with the CACE targets dropped.
- `xschemrc` files (six) default to `gf180mcuD`; the top one sources both macros.
- `submission.yaml`, `.gitignore`, `scripts/check_boundary.py` (PR boundary layer 0, read from PDK sources),
  README rewritten for GF180.
- Removed (all were tracked and unmodified vs the git index): template `macros/inverter`, `macros/counter`,
  IHP floorplan GDS, IHP-named layout/schematic/testbench files, generated `final/ netlist/ render/ verification/`.
- Verified only by `make -n`, a Tcl parse of the `xschemrc` files, Python syntax and a link check.
  **No target has been run. No GF180 layout, schematic or testbench exists.**

## 3. Open: design questions (yours to settle, ask the user)

1. **Harness.** `RTimothyEdwards/gf180mcu_ocd_chipalooza` was empty (LICENSE only) on 2026-09-30. Slot
   geometry, wrapper interface, supply names and precheck rules are unknown. `submission.yaml`
   `slot-size: tiny` and `analog-pins: 3` are IHP values. Check the repo again before assuming.
2. **Device choice.** `nfet_03v3`/`pfet_03v3` versus `nfet_06v0`/`pfet_06v0` (the 5 V and 6 V device is one
   device, usable at 5 V; there is no `*_05v00`). Tim Edwards allows 3.3 V-only designs; digital slot signals
   are 3.3 V; pads may see 5 V levels, so `docs/OPERATING_LIMITS.md` (an open table) must state limits.
3. **Deep n-well.** Available. Inside it nFET bulks can be isolated, pFET bulks cannot; isolating both costs area.
4. **Passives.** `ppolyf_u_1k` (1 kOhm/sq), MiM `cap_mim_2p0fF` (2 fF/um^2, option B per Tim; confirm). Top metal
   "1100 A" was relayed from a chat; probably the 1.1 um thick option, unconfirmed.
5. **ESD.** `gf180mcu_ocd_io__asig_5p0` has HBM diodes only. Add CDM protection next to the gates:
   CDM diode perimeter above 25 um, poly resistor above 50 Ohm (Tim's numbers). IHP's `ClampN`/`ClampP`
   pcells have no GF180 counterpart. The user said to drop `gf180mcu_CdmClamp` for now.
6. **Class-AB output driver and bias.** Re-derive sizing for GF180. IHP notes:
   `design_considerations/class_ab_pad_driver/improvements/{log.md,log.tex,log.pdf}` in the IHP notes worktree.
   The user dropped `OgueyAebischerBias` and the `slot` macro for now.
7. **PR boundary** layer 0/0 is unverified against a real GF180 GDS or the harness precheck.
8. KPEX has no verified GF180 support; use the Magic PEX targets.
9. Top-cell name `gf180_cm_ip__single2diff2single` is intended, not yet confirmed final.
10. The `verilog` Makefile target hardcodes supply names (`VDD VSS VPWR VDPWR VAPWR VGND VNB VPB`) and
    `di_`/`do_` prefixes; adjust once the harness is known.
11. Unanswered user-side items: whether to add `NOTE.md` to unused `layout/` subdirectories; whether
    "klayout/magic" in the layout request meant `layout/klayout` and `layout/magic` (read that way).

## 4. Next steps (suggested order)

1. Re-check the harness repo and Tim's FOSSi chat for new information.
2. Fill `docs/OPERATING_LIMITS.md`; decide 3.3 V versus 6 V devices.
3. Schematics: `schematic/xschem/<TOP>.sch/.sym`, both macros' schematics, testbenches, with GF180 devices.
4. CDM protection design; then layout (KLayout and/or Magic, one tool per cell), export to `layout/gds/`.
5. Write `TOP_LEVEL_MODULE.md` (boundary spec) once the harness interface is known.
6. Run `make klayout-verify-all`, `make magic-verify-all`, `make check-boundary`, `make build-top` in the container.

## 5. Traps and rules

- **No git commands without asking first.** Even `status`/`log` can leave an unremovable `index.lock` on
  this bridge. If one locks, name the file and stop. Never `git switch sudel_buecher` in the main directory
  (it empties the working tree). Commits are the user's.
- Worktree `~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher` (orphan branch `sudel_buecher`). Its `.git`
  link file holds an absolute `/home/cmaier/...` path (git 2.43 has no `--relative-paths`).
- Tools (xschem, ngspice, magic, netgen, KLayout, `sak-*`) live in the user's IIC-OSIC-TOOLS container
  (`source .designinit` first). The cloud session and the device shell have `make`, `python3`, `tclsh`; the
  EDA tools were not checked there. Simulation, DRC and LVS results have to come from the user.
- Deleting files on the device needs `device_request_delete_permission` per session.
- Cloud-to-device file transfer: `device_commit_files` with a `stagedPath` under `/mnt/user-data/outputs/`,
  not base64 through heredocs.
- User's standing rules: no Microsoft document formats and no spreadsheets unless he asks; chat logs are verbatim,
  script-built, reasoning excluded; never put inferences about him into persistent memory without asking first.
- Chatlog: `sudelbuecher/chatlog/export_chatlog.py` builds it from the session transcript
  (`~/.claude/projects/-home-claude/<session>.jsonl`, copy aside first). The existing export ends at
  16:42 Berlin on 2026-10-06; later turns (including the retarget) are not yet exported. The script
  hardcodes "Sonnet" in the header; use a new file `<date>_opus_<topic>.md` and fix the header for a new model.
- The cloud scratchpad clones (`google/gf180mcu-pdk`, `wafer-space/gf180mcu`, Tim's `gf180mcu_ocd_*` repos) are
  per-session and may be gone; re-clone from GitHub (`dependencies/README.md` has the links).

## 6. Reading list

- IHP repo: `HANDOVER_toplevel.md`, `TOP_LEVEL_MODULE.md`, `CLAUDE.md`, `README.md`, `submission.yaml`.
- IHP notes worktree: `verbatim_chatlog_recovery/verbatim-chatlog-export.md`, the class-AB pad driver notes,
  and the layout-structure chatlog (Turns 14, 19, 21 to 23).
- This repo: `docs/GF180_PROCESS_OPTIONS.md`, `docs/OPERATING_LIMITS.md`, `harness_stub/README.md`.

## 7. Session 2026-10-06 late (Claude Opus): bias port, CACE, IOPad proof of concept

Request: migrate the work-in-progress design; as proof of concept run the bias circuit test and
verification suites, start building CACE suites, create xschem schematics and symbols for circuits and
testbenches. User decision this session: build the bias in **both** device families (`03v3` and `06v0`).

Done (details in each macro README):

- `macros/OgueyAebischerBias/`: IHP bias core + start-up ported wire for wire (GF180 FET symbols have the
  IHP pin geometry), sizes re-derived from extracted gm/ID data and mismatch Monte Carlo; wrapper
  `OgueyAebischerRef_<v>` (the CACE DUT), start-up testbench, CACE yaml + six templates per variant,
  results in `verification/cace/results/`. `scripts/check_port.py` compares xschem's netlist with the IHP
  netlist device by device (PASS for both variants).
- `macros/gf180mcu_IOPadSingle2Diff/`: CDM front end (Tim's > 50 Ω / > 25 µm numbers, placeholder sizes),
  pad-in-the-loop testbench with `gf180mcu_ocd_io__asig_5p0`, CACE `input_params`. Finding: with CDM
  diodes to a 3.3 V vdd the input is not 5 V tolerant; numbers in `docs/OPERATING_LIMITS.md`.
- `macros/gf180mcu_IOPadDiff2Single/`: symbol and port-only schematic (IHP symbol pin bugs fixed).
- Top-level `schematic/xschem/xschemrc` sources the bias macro; `.gitignore` covers CACE outputs;
  `docs/IHP_TO_GF180_PORT_MAP.md`, `docs/OPERATING_LIMITS.md`, `CLAUDE.md`, `README.md` updated.

**Not delivered by the bridge:** `macros/OgueyAebischerBias/Makefile` ("protected file", the bridge
refuses Makefiles). The user received it as a chat attachment and has to copy it in. It is the IOPad macro
Makefile plus `VARIANT`, `sim-cace`, `sim-cace-all`, CACE outputs in `clean`.

Where the numbers came from: a cloud container with ngspice-42, xschem 3.4.8RC built from source,
CACE 2.13, and a gf180mcuD tree assembled by hand from `gf180mcu_fd_pr` @ `e11a8c9` (the commit open_pdks
pins) laid out like open_pdks (`libs.tech/ngspice`, `libs.tech/xschem`, `fix_xschemrc.py` applied) plus the
pad symbol/netlist under `libs.ref/gf180mcu_ocd_io`. **Not yet reproduced in the IIC-OSIC-TOOLS
container**; do that first (`make sim-all`, `make sim-cace-all` in the bias macro, `cace` in the
Single2Diff `verification/cace`).

Open decisions for the user:

1. Device family per block (03v3 vs 06v0) and the analog supply (3.3 V vs 5 V); the input-range result
   ties into this.
2. Bias topology: cascode M10/M13/M14 for PSRR (30.7 / 35.2 dB against the 50 dB target) and leg
   matching; weaker kick or faster release for the start-up overshoot (14× for a µs ramp, 6–16 µs settling);
   MiM instead of the depleted NMOS cap M26.
3. CACE spec limits marked *placeholder* in the yaml files (I1 70–130 nA, Iq < 2 µA, ±15 % / ±6 %
   mismatch, Iin ±1 µA).
4. CDM resistor and diode sizes (placeholders), and whether the diodes go to a 5 V rail.

Traps found this session:

- xschem < 3.4.8 ignores CACE's `top_is_subckt` (DUT netlist has `**.subckt`, testbenches fail) and rejects
  the UTF-8 BOM that the project's older `xschemrc` files start with. The new files have no BOM.
- CACE netlists templates with the PDK `xschemrc` plus the templates folder only; a template's own
  `xschemrc` is ignored. Symbols outside the PDK's `libs.tech/xschem` must sit next to the templates.
- A template whose annotation text used `CACE{dvdd}` while `dvdd` was not declared in the yaml left
  `CACE{dvdd=5.0}` in the code block unsubstituted ("Condition dvdd not defined"); declaring the condition
  in the yaml fixed it. Declare every condition a template mentions.
- GF180 mismatch ignores `m`; W ≤ 100 µm per FET; transient decks need `abstol=1e-13` and an explicit
  `tmax` or cold corners take minutes.
- At the start of this session `git status`/`git log` were run once in the design worktree before this
  file's rule was read; no `index.lock` was left (checked). No further git commands were run.

## 8. 2026-10-08: class-AB driver, its bias and the pad enables (proof of concept)

Requested by Christoph as a smoke test of the schematic and verification flow; the IHP design stays the
reference and is re-migrated later. Running log with every number and decision:
`_sudelbuecher/sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md`.

- New macros: `ClassABDriver` (driver core `ClassABDriver` with ports `a b` for the enable, unit `ClassABUnitR`,
  CACE fixture `ClassABDriverBiased`, six ported IHP testbenches), `ClassABBias` (`ClassABBiasIn`, `ClassABBiasOut`,
  fixture `ClassABBiasIdeal`), `PadEnable` (`EnableInv`, `DriverEnable`, `BiasRefEnable`, `InputEnable`).
- `gf180mcu_IOPadDiff2Single`: block-level sheet (bias tree fed by `iref` through `BiasRefEnable`, driver with
  vfb = out, `DriverEnable`, `EnableInv`); ports `vdd vss vddo vsso inp inn vref out iref en`.
- `gf180mcu_IOPadSingle2Diff`: `InputEnable` behind the CDM network (`in_prot` → `in_en`, parked on `vcm`),
  `EnableInv`, new last port `en`; its testbench and CACE template tie `en` to vdd.
- CACE suites with results: `ClassABBiasIn`, `ClassABBiasOut`, `ClassABDriverBiased`, `gf180mcu_IOPadDiff2Single`;
  `gf180mcu_IOPadSingle2Diff` rerun with the enable. All in a cloud container (same tools as §7); **not yet
  reproduced in IIC-OSIC-TOOLS**.
- Round trip: every ported or generated sheet netlisted by xschem and compared device by device with its reference
  netlist (`ClassABDriver/scripts/check_classab_port.py`), MISMATCHES 0.

Makefiles (three new, four changed) come as `_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip`
(the bridge refuses Makefiles); its `install.sh` copies them and keeps the old ones as `Makefile.orig-2026-10-08`.
Not ported: the self-contained
bias variants `_oa` (Oguey–Aebischer) and `_bg` (bandgap), which need a GF180 re-design; no layout.

Traps found:

- The cloud xschem / Tcl rejects the UTF-8 BOM at the start of the IOPad and top-level `xschemrc` files (every symbol
  "IS MISSING"). §7 said 3.4.8 accepts it; that was wrong for the cloud build. Netlisting there runs from a
  BOM-stripped copy; the files in the repo are unchanged.
- CACE: a condition named like a pin takes a value of its own (`iref` → 1 mA; renamed `i_ref`); state every
  condition a parameter does not sweep, or a pin's `Vmin` is used; brace-escape `CACE{...}` in symbol `value=`;
  a unit of `%` is shown as 100 × the echoed value; `off` in a variable list is YAML for false.
- ngspice: noise analysis refuses `option KLU`; with all current roots switched off (pad disabled), `gmin=1e-15`
  leaves KCL residues of ~17 µA on the supplies, `gmin=1e-12` gives the real leakage.
- GF180 03v3 bins: W ≤ 100 µm per instance counts the total W, not W/nf; large devices need `m`.
- The gf180mcuD PDK `xschemrc` does not set the Tcl variable `PDK` (IHP's does), so the guard
  `if {![info exists PDK]}` in the project files never fired: every chained `xschemrc` re-sourced the PDK file,
  which resets `XSCHEM_LIBRARY_PATH`, and a top-level session saw only the last macro's folders. All project
  `xschemrc` files now `set PDK $env(PDK)` right after sourcing it; checked by netlisting a pad and a driver
  testbench through the top-level files (all cells found).
