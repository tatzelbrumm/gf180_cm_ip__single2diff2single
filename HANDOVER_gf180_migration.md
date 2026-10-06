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
