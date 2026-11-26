# Proposals for `tatzelbrumm/claude-cloud-config` (repository C)

Written 2026-11-26 in the pad-structure exploration session (brief: `docs/AGENT_BRIEF_PAD_STRUCTURES.md`; report:
`docs/PAD_STRUCTURES.md`). **Nothing was pushed to C.** These are drafts for the user to hand over when he chooses.

C as I found it (`main` at `39d01fc`): `README.md`, `CLAUDE.md`, `make-setup.sh`, `parts/`, `setup-*.sh`, `recipe/`,
`sources/`, `tools/`. It builds the environment and carries no process, rule, pad or harness facts, as the brief says.
**[V]** directory listing of the clone.

Marks, as in the report: **[V]** verified in a file (path and line), **[I]** inferred (from what), **[U]** unverified.
Source abbreviations are those of `docs/PAD_STRUCTURES.md` section 0 (`IO/`, `FDIO/`, `TECH/`, `B:`, `OCD:`, `DRM:`, `D:`,
`LOG/`).

The four kinds of fact are kept in four separate proposed files (P1 to P4), so that each can go stale and be
refreshed on its own: process facts depend on the PDK commit, design rules on the deck and the manual, pad facts on
the pad library commit, the slot interface on the harness commit. P5 to P8 are tools and housekeeping.

A general remark first. Each proposed file states the commits it was read from. A reference file without that
line is worse than none, because the next agent cannot tell whether it still applies. I suggest C's `CLAUDE.md` says so.

---

## P1. Process facts: `reference/gf180mcuD/PROCESS_FACTS.md`

**Why.** I had to find out by trial which files answer basic questions: which PDK build is installed, what the GDS
layer numbers mean, what the units of a `.mag` file are, which devices the pad library uses and what their models
can and cannot do. None of it is hard, and all of it cost tool calls that the next session will repeat.

**Draft content.**

```markdown
# gf180mcuD: process facts for agents (read from open_pdks e7a6777; re-check after a PDK change)

## Which build is installed
- `$PDK_ROOT/gf180mcuD/.config/nodeinfo.json` lists every library with its commit, and the options
  ("MIM_2P0", "METAL5"; description: 5 metal layers, 1.1 um thick top metal, 2 fF/um2 MiM, 1k high-res poly).
- `$PDK_ROOT/gf180mcuD/SOURCES` holds the open_pdks commit.
- `$PDK_ROOT/gf180mcuD` is a link into `ciel/gf180mcu/versions/<commit>/`.

## Layer numbers
- Names and GDS numbers: `libs.tech/klayout/tech/gf180mcu.lyp`, in `<source>NAME L/D@1</source>` elements
  (the name is inside the source element, not in a `<name>` element).
- The ones needed for pads: COMP 22/0, Nplus 32/0, Pplus 31/0, Nwell 21/0, DNWELL 12/0, LVPWELL 204/0,
  Dualgate 55/0, Poly2 30/0, SAB 49/0, ESD 24/0, Contact 33/0, Metal1..5 34, 36, 42, 46, 81 /0,
  Via1..4 35, 38, 40, 41 /0, Pad 37/0, PR_bndry 0/0, DIODE_MK 115/5, MOS_CAP_MK 166/5, RES_MK 110/5,
  ESD_MK 24/5, Latchup_MK 137/5, LVS_IO 119/5, LVS_Source 100/8, ISOSUB 23/5.
- Metal5 is the top metal of this variant; the pad library has no MetalTop layer.

## Magic files
- `magscale 1 10` in the PDK's .mag files: one unit is 5 nm.
- Magic splits a contacted diffusion into a contact tile and a diffusion tile. Ring widths cannot be read from
  a .mag file; take them from the GDS.
- Device tiles of the 6 V diodes: `mvndiode`, `mvpdiode` (contacts `mvndiodec`, `mvpdiodec`).

## Devices and models (libs.tech/ngspice/sm141064.ngspice)
- 6 V diodes: `diode_nd2ps_06v0` (bv = 11), `diode_pd2nw_06v0` (bv = 10.5). Ordinary level-3 diode models.
- ESD-style FETs: `nfet_06v0_dss`, `pfet_06v0_dss` with `d_sab`, `s_sab` (salicide block lengths).
- `ppolyf_u`: 350 ohm/sq typical, 420 in `res_ss`, 280 in `res_ff`.
- `cap_nmos_06v0`: 2.18 fF/um2 above threshold (formula in the subcircuit).
- No model contains snapback, second breakdown or self-heating. There is no ESD model in the PDK.
- Corner sections: `typical ss ff sf fs`, plus `diode_<c>`, `res_<c>`, `moscap_<c>`.

## Known tool traps
- ngspice-47 rejects the pad netlist's `XC1 ... cap_nmos_06v0 ... m=36`: "unknown parameter (e9)".
- FET model bins end at W = 100 um per instance (total W, not W/nf); mismatch ignores `m`.
- The container has no `gdstk` and no `column`; `import klayout.db` works in python3.
```

**Sources.**

| Fact | Source | Mark |
| --- | --- | --- |
| nodeinfo content, SOURCES, the link | `$PDK_ROOT/gf180mcuD/.config/nodeinfo.json`, `$PDK_ROOT/gf180mcuD/SOURCES`, `ls -la /foss/pdks` | [V] |
| `.lyp` format and the layer numbers | `TECH/klayout/tech/gf180mcu.lyp` (e.g. line 220 COMP, 373 SAB, 390 ESD, 1427 Latchup_MK, 1631 ESD_MK); table in `LOG/tools/layers.tsv` | [V] |
| Metal5 is the top metal in the pad library | layer list of `IO/gds/gf180mcu_ocd_io.gds` (report section 2) | [V] |
| 5 nm unit | `IO/mag/gf180mcu_ocd_io__asig_5p0.mag:3` against the LEF pad rectangle `IO/lef/gf180mcu_ocd_io.lef:18` (1500..13500 units = 7.5..67.5 um) | [V] |
| contact/diffusion split in Magic | `IO/mag/comp018green_esd_hbm.mag:260-302` (a 3 um stripe appears as a 0.135 um frame and a 2.73 um contact tile) | [V] |
| diode models | `TECH/ngspice/sm141064.ngspice:38379-38380, 38405-38406` | [V] |
| `*_dss` models | same file, lines 37039, 38075 | [V] |
| `ppolyf_u` sheet resistance | same file, lines 413, 441, 469 (sections `res_typical` 406, `res_ss` 434, `res_ff` 462) | [V] |
| MOS cap formula | same file, lines 39037-39042 | [V]; 2.18 fF/um2 is [I] (sum of the two coefficients) |
| no ESD content in the models | search for esd, snapback, tlp, hbm, cdm in `TECH/ngspice/*.ngspice`: no hit | [V] |
| ngspice error | this session, `LOG/2026-11-26_fable_pad_structures_log.md` entry 12 | [V] |
| W limit, mismatch | `docs/IHP_TO_GF180_PORT_MAP.md` (rows "Model bin limit", "Mismatch model"), `HANDOVER_gf180_migration.md:188` | [V] as statements of those files; not re-tested |
| missing `gdstk`, `column` | this session | [V] |

---

## P2. Design rules: `reference/gf180mcuD/DESIGN_RULES_INDEX.md`

**Why.** Three things were not obvious. (1) `gf180mcu.drc` is a 202-line loader; the rules are in
`rule_decks/*.rb`, one file per layer family. (2) The design manual is **not in the installed PDK**; it lives in
`google/gf180mcu-pdk` under `docs/physical_verification/design_manual/` as `.rst` files with the tables in
`tables_clear/*.csv`, and on a site the environment blocked until today. (3) The manual's ESD and I/O latch-up
guidelines are not coded in the DRC deck, so "DRC clean" does not cover them.

**Draft content (outline with the entries I can vouch for).**

```markdown
# gf180mcuD: where the rules are (deck from open_pdks e7a6777; manual from google/gf180mcu-pdk de3240d)

## KLayout DRC deck
- Loader: `libs.tech/klayout/tech/drc/gf180mcu.drc`. Rules: `libs.tech/klayout/tech/drc/rule_decks/<family>.rb`.
- Rule names are the first argument of `.output('NAME', ...)`; list a family with
  `grep -n "output('" rule_decks/<family>.rb`.
- Families used for pad and ESD cells: comp (DF.*), nwell (NW.*), dualgate (DV.*), lvpwell (LPW.*), dnwell (DN.*),
  nplus (NP.*), pplus (PP.*), poly2, contact (CO.*), metal (M<n>.*), via, sab (SB.*), esd (ESD.*), pres (PRES.*),
  hres (HRES.*), guard_ring (GR.*: the die seal ring, not device guard rings).
- "_LV" / "_MV" suffix: 3.3 V / 5-6 V geometry.

## Design manual (not installed with the PDK)
- Source: github.com/google/gf180mcu-pdk, `docs/physical_verification/design_manual/drm_<chapter>.rst`,
  tables in `tables_clear/<nn>_<name>.csv`, figures in `images/`.
- Rendered: gf180mcu-pdk.readthedocs.io (allow this host in the environment, or clone the repository).
- Chapter 14 "Reliability": 14.3 latch-up (`drm_14_3*.rst`, tables 55, 56), 14.4 ESD layout guidelines
  (`drm_14_4*.rst`, tables 57-59), 14.5 ESD characterization data (`drm_14_5*.rst`, tables 60-67).

## Coded and not coded
- Coded: ESD.1-ESD.10, ESD.pl (ESD implant), SB.1-SB.16 (salicide block).
- NOT coded in the KLayout deck: HVNESD.*, HVPESD.*, the LV equivalents, the diode guidelines 14.4.2.x and
  14.4.5.x, the I/O latch-up rules IO.1-IO.4. `Latchup_MK` and `ESD_MK` are only checked for grid and angle.
- So: an ESD or pad cell needs its own checks for these; DRC will not flag them.
```

**Sources.**

| Fact | Source | Mark |
| --- | --- | --- |
| loader and rule decks | `TECH/klayout/tech/drc/gf180mcu.drc` (202 lines), `TECH/klayout/tech/drc/rule_decks/` (41 files) | [V] |
| rule names per family | e.g. `rule_decks/esd.rb:34-124`, `sab.rb:39-176`, `dualgate.rb:34-92`, `contact.rb:25-235` | [V] |
| `guard_ring.rb` is the seal ring | `rule_decks/guard_ring.rb:43-109` (GR.2: "space to prime die") | [V] rule text; the reading is [I] |
| manual location and structure | `DRM:` clone (`drm_14_4.rst`, `drm_14_4_5.rst`, `drm_14_5_7.rst`, `tables_clear/58_HV_SAB_MOSFET_168.csv`, ...) | [V] |
| the site was blocked, then allowed | this session: HTTP code 000 before, 200 after the user approved the host | [V] |
| not coded | search of the deck for `HVNESD`, `HVPESD`, `IO.<n>`, `14.4.5`: no hit; `generic_layers.rb:67, 78`, `geom.rb:87, 98` | [V] for the KLayout deck. The Magic DRC section (`TECH/magic/gf180mcuD.tech`) was searched for `hvnesd`, `latch`, `IO.1` only, without hit | 
| table numbers 55-67 | file names in `DRM:tables_clear/` | [V] for 55, 56, 58, 59, 64-67 (opened); 57, 60-63 by file name only |

---

## P3. Pad library facts: `reference/gf180mcuD/PAD_LIBRARY_gf180mcu_ocd_io.md`

**Why.** The questions "what is in the analog pad" and "where are its terminals" took most of this session. The
answers are stable for a given library commit and fit on a page. The report `docs/PAD_STRUCTURES.md` sections 2 to 4
and 12.1 / 12.3 hold the full version; C should carry the short one and point to the report.

**Draft content.**

```markdown
# gf180mcu_ocd_io (commit 6e0e354 in open_pdks e7a6777): facts for agents

- Location: `$PDK_ROOT/gf180mcuD/libs.ref/gf180mcu_ocd_io/{gds,lef,lib,mag,spice,verilog,xschem}`.
- Origin: Tim Edwards' dual-voltage (3.3 V core, 5 V pad) rework of the foundry library gf180mcu_fd_io
  (github.com/RTimothyEdwards/gf180mcu_ocd_io). Its `docs/` are the foundry datasheet pages, not rewritten.
- Cells: asig_5p0, bi_t, bi_a, bi_24t, in_c, in_s, dvdd, dvss, vdd, vss, cor, brk2, brk5, fill1, fill5, fill10,
  fillnc. Pads are 75 x 350 um, the corner 355 x 355 um.
- Supply pins of every pad: DVDD/DVSS = the 5 V pad ring, VDD/VSS = the core domain.
- Analog pad `asig_5p0` (`ASIG5V DVDD DVSS VDD VSS`):
  - 4 x (3 x 50 um) P+/n-well diodes pad -> DVDD, 4 x (3 x 50 um) N+/substrate diodes DVSS -> pad,
    4 x (1 x 40 um) diodes DVSS -> DVDD, 36 x (15 x 15 um) MOS caps DVDD-DVSS. Nothing else.
  - VDD and VSS are not connected inside the cell.
  - ASIG5V is one Metal2 net: the bond pad, then eight 2.54 um strips to the core edge (y = 350).
  - Datasheet: "contain only HBM protection diodes"; the user adds a CDM network (resistor > 50 ohm,
    diode perimeter > 25 um) next to input gates.
- Digital pads: output FETs with salicide-blocked drains on the pad; 4 x ppolyf_u (2.5 x 2.8 um) in parallel
  (about 110 ohm) and 2 x (20 x 1 um) diodes each way in front of the input buffer. `bi_a` exposes that node as ANA.
- Supply pads and corners: an RC-triggered NMOS clamp (W = 4 mm) per cell; two in a corner.
- brk2/brk5 pass only the two VSS rails; fill1/5/10 pass all 26 rails (Metal3, Metal4, Metal5).
- The library uses no ESD implant, no deep n-well, no LVS_IO/LVS_Source layers.
- ESD ratings in the datasheet (2 kV HBM, 200 V MM, 500 V CDM) are labelled "Target" and were written for the
  foundry library. No measured value is published in these files.
```

**Sources.** Every line is taken from `docs/PAD_STRUCTURES.md`, which carries the path-and-line citations:
cells and sizes, section 2 **[V]**; analog pad, sections 4.1 to 4.4 **[V]**; digital pads and clamps, section 5.1
**[V]** (the "about 110 ohm" is **[V]** from the foundry netlist annotation `FDIO/cdl/gf180mcu_fd_io.cdl:1174-1177`);
break and fill cells, section 2 notes **[V]**; layers, section 2 last note **[V]**; ratings, section 7.3 **[V]**;
origin, `OCD:README.rst:4-6` **[V]**, "not rewritten" is **[I]** from identical text on the foundry site.

**Related, for the repository A rather than C.** `CLAUDE.md` of A could replace "the earlier note ... was not
re-checked" by a pointer to the report. I did not edit `CLAUDE.md`.

---

## P4. Slot interface: `reference/chipalooza3/SLOT_INTERFACE.md`

**Why.** What a slot project gets from the harness is spread over `config.txt`, the generated wrapper layout, two
Verilog files and a Tcl script. The earlier sessions had to rebuild the harness to find the numbers now in A's
`CLAUDE.md`; I had to trace the supplies through `chipalooza_frame.v` to learn that they are switched.

**Draft content.**

```markdown
# Chipalooza #3 harness: what a slot gets (fork tatzelbrumm/gf180mcu_ocd_chipalooza, main 2f18cd4)
# The generated files are the authority; re-read them after any harness update.

- 18 slots; wrapper `slot<N>_wrapper`, 1274.27 x 412.71 um (`magic/slot<N>_wrapper.mag`, FIXED_BBOX, 5 nm units).
- Slot pins (slot 16 as the example; other slots have 1 to 3 analog pads):
  - analog pads `s16_an[0]`, `s16_an[1]`: Metal3, west edge, each 2 x 44.32 um.
  - supplies `vdd_3v3 vss_3v3 vdd_5v0 vss_5v0`: Metal5, east edge.
  - `analog_bus0..3`, `vbias`, `ibias0`, `ibias1`: Metal3, east edge.
  - `dig_in[23:0]`, `dig_out[11:0]`, `reset`, `enable`, `clk`: Metal3.
- A dedicated analog pad is wired straight from the bond pad to the slot pin.
- The slot's `vdd_5v0` and `vdd_3v3` come through per-slot power switches (`power_stage`, `power_stage3v3`)
  from the chip's `vdd5v0` and `vdd3v3`; the grounds are direct.
- The pads' own supply pins: DVDD/DVSS = `vdd5v0`/`vss5v0`, VDD/VSS = `vdd3v3`/`vss3v3` (`vddd` in the bottom
  segment). These ring rails are NOT slot pins.
- Pad type per slot pad: `config.txt`, one of bi_24t, bi_t, bi_a, in_c, in_s, asig_5p0 (default asig_5p0);
  a change needs the slot designer's and the maintainer's agreement and a rebuild.
- Padframe: 3880 x 5070 um, 80 pads, pitch 170 um on the left/right sides and 202 um on top/bottom.
  Two brk5 cells split the ring into a lower and an upper segment.
- Project layout is collected as `slot_<N>.gds` with top cell `slot_<N>` (`scripts/get_project_gds.sh`).
- Known problem on main: `verilog/gl/gf180mcu_padframe.v` connects pads through `.iovdd .iovss .vdd .vss`;
  the PDK cell has `DVDD DVSS VDD VSS`. Analysis and patch: fork branch `sudel_buecher`,
  `sudelbuecher/harness_tools/fixes/pad_pins/`.
```

**Sources.**

| Fact | Source | Mark |
| --- | --- | --- |
| slots, wrapper size | `B:magic/slot16_wrapper.mag:189`; `B:gds/slot1..18_wrapper.gds` | [V] |
| pin layers and positions | `B:magic/slot16_wrapper.mag:84-104, 184, 186` | [V] for slot 16; `dig_*`, `reset`, `enable`, `clk` on Metal3 from the label count (36 + 3 labels), positions not read |
| "1 to 3 analog pads" | `B:README:149-150`; `B:verilog/gl/gf180mcu_padframe.v:33-50` | [V] |
| straight wire | `B:verilog/rtl/slot16_wrapper.v:62-71` | [V] |
| power switches | `B:verilog/rtl/chipalooza_frame.v:895-913, 265-266, 1379-1385` | [V] |
| pad supply nets | `B:verilog/gl/gf180mcu_padframe.v:17-21, 1024-1043` | [V] |
| pad types | `B:config.txt:36-58, 169-170` | [V] |
| padframe size and pitch | `B:scripts/gen_padframe.tcl:8-15`; `B:magic/gf180mcu_padframe.mag:6193` | [V]; 202 um = 75 + 127 is [I] from the same comment |
| ring segments | `B:magic/gf180mcu_padframe.mag:2449, 5469`; GDS of `brk5` | [V] |
| project GDS name | `B:scripts/get_project_gds.sh:21-23, 34-38` | [V] |
| pin name problem | `B:verilog/gl/gf180mcu_padframe.v:1026-1029` against `IO/spice/gf180mcu_ocd_io.spice:2` | [V] |

Everything about the upstream repository `RTimothyEdwards/gf180mcu_ocd_chipalooza` itself is **[U]**: I read only
the fork.

---

## P5. Inspection tools: `tools/pdk-inspect/`

**Why.** I wrote four small scripts to get numbers out of `.mag` and GDS files, because nothing ready-made was at
hand and Magic's interactive commands are awkward in a batch session. They are generic and PDK-independent apart
from the layer table.

**What to add** (the files exist, tested in this session, on branch `sudel_buecher` of A under
`sudelbuecher/logs/pad_esd_exploration/tools/`):

| File | What it does |
| --- | --- |
| `magtree.py <magdir> <cell> [depth]` | prints the cell hierarchy of a Magic cell with instance counts and device-tile counts |
| `gds_layers.py <gds> <cell> [layers.tsv]` | per-layer summary of a flattened cell: polygons, area, bounding box, layer names |
| `gds_shapes.py <gds> <cell> <layers.tsv> L/D,... [max] [clip]` | lists the merged shapes of chosen layers with sizes |
| `gds_rings.py <gds> <cell> L/D [clip]` | finds ring polygons and prints the four ring widths and the bars between holes |
| `layers.tsv` | GDS number, name and `.lyp` line for the 119 layers of `gf180mcu.lyp` |

Outline of a short `README.md` for the folder: the four command lines above; "run python with `-I`"; "the scripts
read only, they never write a layout"; how `layers.tsv` was made (one regular expression over
`<source>NAME L/D@1</source>`); an example output for `gf180mcu_ocd_io__asig_5p0`.

Two further scripts would be worth writing, and I did not write them: a net tracer (which metal shapes belong to
the net of a given point; I did it ad hoc for the bond pad, journal entry 13) and a generator of `layers.tsv` for
the other PDKs.

**Sources.** The scripts and their outputs: `LOG/tools/`, `LOG/2026-11-26_fable_*.out` **[V]**.

---

## P6. Network hosts and upstream documents: additions to `README.md` and `parts/pdk-gf180mcuD.sh`

**Why.** Twice in this session the answer was on a host or in a repository the environment description does not
mention.

**What to add.**

1. In the README's "Use" section, a table of hosts per purpose for the `gf180mcuD` environment. As configured today
   **[V]** (environment settings read in this session): `www.klayout.org`, `github.com`,
   `fossi-foundation.github.io`, `api.github.com`, `release-assets.githubusercontent.com`,
   `objects.githubusercontent.com`, `gitea.osmocom.org`, `evampire.readthedocs.io`, `en.wikipedia.org`, and since
   2026-11-26 `gf180mcu-pdk.readthedocs.io` (the foundry manual and the I/O library datasheet).
2. A paragraph "Documents that are not in the PDK": the design manual (`google/gf180mcu-pdk`, `docs/`), the pad
   library datasheet (`RTimothyEdwards/gf180mcu_ocd_io`, `docs/`; the foundry's version on the site under
   `IPs/IO/gf180mcu_fd_io/`). Public GitHub repositories can be cloned anonymously from a cloud session without
   attaching them. **[V]** done in this session for both.
3. Optional, the user's decision: let the setup script fetch the manual's `docs/physical_verification` folder
   (sparse, shallow) into `/foss/docs/gf180mcu-pdk/`, so that it is on disk in every session. Cost: one more clone
   in the setup time budget; I did not measure it. **[I]**

**A correction for C's README while there.** `README.md:23` says the gf180mcuD environment variable is
`STD_CELL_LIBRARY=gf180mcu_fd_sc_mcu7t5v0`; `parts/pdk-gf180mcuD.sh:25-26` says `gf180mcu_as_sc_mcu7t3v3` and explains
why. The table at `README.md:86-87` lists magic 8.3.685 and netgen 1.5.324, while the gf180mcuD script builds 8.3.706
and 1.5.332 (`parts/pdk-gf180mcuD.sh:33, 37`; `README.md:54` mentions it); the session's tools report 8.3.706 and
1.5.332. **[V]** all four.

---

## P7. A session check: `tools/session-facts.sh`

**Why.** At the start I ran a dozen commands to learn what the session has. One script could print it.

**Outline.** Print: the tail of `/foss/setup.log`; the PDK link target and `nodeinfo.json` commits for
`open_pdks`, `gf180mcu_ocd_io`, `gf180mcu_fd_pr`; versions of magic, netgen, ngspice, xschem, klayout, cace,
python3; whether `import klayout.db` works; the libraries under `libs.ref`; the allowed hosts cannot be read from
inside the container, so print a reminder where they are set. No network access, no writes.

**Sources.** The commands of journal entries 2 and 5, and the versions printed in this session (magic 8.3.706,
netgen 1.5.332, ngspice-47, xschem 3.4.8RC, KLayout 0.30.12, CACE 2.11.0, Python 3.13.18; `/foss/setup.log` ends
`SETUP_DONE gf180mcuD 93s`) **[V]**.

---

## P8. KLayout flow of the gf180mcuD environment: three small fixes and one reference page (added later on 2026-11-26)

**Why.** The user asked how far the PDK's KLayout support goes. Getting the PDK's own KLayout LVS, PCells and the
KLayout parasitic extraction to run at all took three workarounds that belong in the environment
(`docs/PAD_STRUCTURES.md` section 14).

**What to add.**

1. `parts/pdk-gf180mcuD.sh`: make the PDK's `run_lvs.py` usable. It imports `docopt` (`run_lvs.py:49`), which is not
   installed; `pip install --break-system-packages docopt` failed to build a wheel under Python 3.13 in this
   session. **[V]** Options, untested: the maintained fork `docopt-ng`, or installing under `python3.12` as the setup
   already does for CACE. Until then the deck can be called directly; the command line is in
   `LOG/tools/klayout_lvs_pad.sh`. **[V]** that script worked.
2. Environment variables of `gf180mcuD`: add `USER=root`. Without `USER` the PDK's KLayout-API PCell library fails
   to load with `KeyError 'USER'` (`libs.tech/klayout/tech/pymacros/klayout_api_cells/draw_efuse.py:18`); with it the
   library registers 31 PCells. **[V]** `LOG/2026-11-26_fable_klayout_pcell_load.out`.
3. State in the README that the gdsfactory-based PCell library does not load (`No module named 'gdsfactory'`) and
   that this is intended (`parts/pdk-gf180mcuD.sh:117-119`), so nobody takes the message for a broken install.
4. A page `reference/gf180mcuD/KLAYOUT_FLOW.md` with what was measured:

```markdown
# gf180mcuD in KLayout: what works (open_pdks e7a6777, KLayout 0.30.12, klayout-pex 0.6.8)

- DRC: `klayout -b -r $PDK_ROOT/gf180mcuD/libs.tech/klayout/tech/drc/gf180mcu.drc -rd input=<gds> -rd topcell=<cell>
  -rd report=<out.lyrdb> -rd variant=gf180mcuD`. 777 rules; about 30 s for a pad cell. On a single cell the
  die-coverage rules (PL.8, M<n>.4, MT.3, DCF.1a/b) fire and mean nothing.
- LVS: deck `libs.tech/klayout/tech/lvs/gf180mcu.lvs`. xschem netlists must first go through
  `lvs/gf180_xschem_klayout_spice_convert.py`. Known gaps: `diode_nd2ps_*` is extracted only where an LVPWELL is
  drawn (N+ diodes in bare substrate vanish); `*_dss` FETs need ESD_MK, SAB and LVS_Source, and the
  gf180mcu_ocd_io GDS has no LVS_Source layer. No pad cell of gf180mcu_ocd_io or gf180mcu_fd_io passes.
- PCells: library `gf180mcu_klayoutapi` (31 device PCells) needs `USER`; there is no ESD, guard-ring, via-stack or
  bond-pad PCell.
- Parasitics: `kpex --pdk gf180mcuD --gds <gds> --cell <cell> --2.5D --out_dir <dir>` runs (capacitances only);
  accuracy not compared with Magic.
```

**Sources.** `docs/PAD_STRUCTURES.md` sections 14.1 to 14.3 with their file-and-line citations **[V]**; the run
times and the "777 rules" from `LOG/2026-11-26_fable_klayout_drc_pads.out` **[V]**.

---

## What I would not put into C

- ESD limit numbers of any kind. The only published ones are the manual's test-structure values and the datasheet's
  targets (report section 7); in a reference file they would be read as properties of the cells.
- The evampire page's content. It is about the foundry library and nobody with expertise has reviewed it **[U]**.
- Anything about the design's own choices (which rail the protection uses, pad type, target levels): those are
  open questions for the user (report section 11) and belong in A.
