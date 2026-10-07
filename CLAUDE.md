# CLAUDE.md — project context

Analog-on-top IC project for **Chipalooza #3** (GlobalFoundries GF180MCU, variant `gf180mcuD`),
a port of `sg13cmos5l_cm_ip__single2diff2single` (IHP, Chipalooza 2026).
Target circuit: a **single-ended → differential → single-ended converter** between analog pads.

**Status (2026-10-06, late):** skeleton and build files retargeted to `gf180mcuD` (see
`HANDOVER_gf180_migration.md`). First GF180 design content, proof of concept: `macros/OgueyAebischerBias`
(bias reference in `03v3` and `06v0` variants: schematics, symbols, start-up testbench, full CACE suite,
run in a cloud container, results in `verification/cace/results/`), the CDM input front end of
`macros/gf180mcu_IOPadSingle2Diff` with a pad-in-the-loop testbench and a CACE input-range deck, and a
port-only skeleton of `macros/gf180mcu_IOPadDiff2Single`. **No layout exists**; DRC/LVS/PEX targets have not
been run. Open items: `docs/IHP_TO_GF180_PORT_MAP.md`, `docs/OPERATING_LIMITS.md`, handover file §7.

## 1. Hard invariant: the top-cell name

Intended name: `gf180_cm_ip__single2diff2single` (matches the folder; not final until confirmed).
It must read the same in `Makefile` (`TOP =`), `submission.yaml` (`top-cell:`), the file names in
`layout/`, `schematic/xschem/`, `testbenches/xschem/`, and as the **GDS cell name inside**
`layout/gds/<TOP>.gds` and `layout/klayout/<TOP>.klay.gds`. `make check-boundary` is the cheapest validator.

## 2. Environment

IIC-OSIC-TOOLS container (check that its tag ships `gf180mcuD`; install the PDK with Ciel otherwise).
Before any `make`: `cd /foss/designs/gf180_cm_ip__single2diff2single && source .designinit`.

## 3. Two worktrees

```
~/EDA/gf180_cm_ip__single2diff2single               ← the design (branch main)
~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher  ← notes, logs (orphan branch sudel_buecher)
```

Never `git switch sudel_buecher` in the main directory (it empties the working tree).

**Agent git access: off-limits.** No git commands without asking first (a bare `status`/`log` can
leave an unremovable `index.lock` on this bridge). If one locks, name the file and stop.

## 4. Process facts (from Tim Edwards, FOSSi Chipalooza chat, 2026-10)

See `docs/GF180_PROCESS_OPTIONS.md` and `docs/OPERATING_LIMITS.md`. In short: 1 kΩ/sq poly resistor
(`ppolyf_u_1k`), 2 fF/µm² MiM type B, thick top metal, deep n-well available, the 5 V and 6 V FETs
are one device (`*_06v0`, usable at 5 V), digital slot I/O at 3.3 V, pads may see 5 V levels.

## 5. Where things are

- Harness: [RTimothyEdwards/gf180mcu_ocd_chipalooza](https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza) — empty (LICENSE only) as of
  2026-09-30. `harness_stub/` holds our *assumed* interface until it is published.
- Analog pad: `gf180mcu_ocd_io__asig_5p0` from [RTimothyEdwards/gf180mcu_ocd_io](https://github.com/RTimothyEdwards/gf180mcu_ocd_io)
  (URL only; not yet added as a dependency). It has HBM diodes only; CDM protection is ours.
- Notes, logs, running chat log: the `_sudelbuecher` worktree (`sudelbuecher/chatlog/`).

## 6. Layout paths

Every Makefile target reads `layout/gds/<cell>.gds` only (`LAY_GDS_DIR`). `layout/klayout/` and
`layout/magic/` are editing sources; export to `layout/gds/` before any `make` target (README, "Layout
Sources and the Exported Tapeout GDS"). Unverified guesses are labelled as such in the Makefile,
`submission.yaml` and `scripts/check_boundary.py`: `slot-size`, `analog-pins`, PR boundary layer 0. (`RENDER_TECH = gf180mcuD` matches the `sak-pdk` list; not yet run through `sak-render.py`.)
