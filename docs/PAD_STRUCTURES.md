# The existing GF180 pad structures (`gf180mcu_ocd_io`) and their ESD protection

Report for the brief `docs/AGENT_BRIEF_PAD_STRUCTURES.md`. Written 2026-11-26 in a Claude Code cloud session
(environment `gf180mcuD`). Exploration only: no layout, schematic, Makefile or `config.txt` was changed.
Work journal, script outputs and the chat log are on the branch `sudel_buecher` (section 13).

## 0. How to read this report

Every statement carries one of three marks:

- **[V]** verified in a file; the path and line follow. A GDS has no lines, so GDS facts name the cell, the layer and
  the script output that holds the numbers.
- **[I]** inferred; the sentence says from what. Results of a model evaluation run in this session are also [I]:
  they are what the PDK models say, not what silicon does.
- **[U]** unverified: known only from the evampire page or the FOSSi chat excerpt in the brief.

Abbreviations for sources:

| Short | Meaning |
| --- | --- |
| `IO/` | `$PDK_ROOT/gf180mcuD/libs.ref/gf180mcu_ocd_io/` in the installed PDK (open_pdks `e7a6777`, `gf180mcu_ocd_io` `6e0e354`; `$PDK_ROOT/gf180mcuD/.config/nodeinfo.json`) |
| `FDIO/` | `$PDK_ROOT/gf180mcuD/libs.ref/gf180mcu_fd_io/`, the foundry's 5 V library in the same PDK |
| `TECH/` | `$PDK_ROOT/gf180mcuD/libs.tech/` |
| `B:` | harness fork `tatzelbrumm/gf180mcu_ocd_chipalooza`, `main` at `2f18cd4` |
| `OCD:` | `RTimothyEdwards/gf180mcu_ocd_io` at `6e0e354`, the source of `IO/` (public, cloned read-only; not in the brief's list, see section 13) |
| `DRM:` | `google/gf180mcu-pdk` at `de3240d`, folder `docs/physical_verification/design_manual/`: the foundry design manual. **It is not part of the installed PDK** (cloned read-only; the same text is served at `gf180mcu-pdk.readthedocs.io`) |
| `D:` | `tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single`, cited as `branch:path:line` |
| `LOG/` | branch `sudel_buecher` of this repository, `sudelbuecher/logs/pad_esd_exploration/` |

Coordinates are in µm in the pad cell's own frame: origin at the lower left, bond pad at the bottom (chip edge),
core edge at the top (y = 350).

## 1. Summary

1. **The claim in `CLAUDE.md` is correct.** `gf180mcu_ocd_io__asig_5p0` holds one diode group from the pad to DVDD, one
   from DVSS to the pad, one from DVSS to DVDD and a decoupling capacitor; nothing else. No series resistor, no second
   diode stage, no clamp, no transistor. The netlist and the layout agree on that (section 4). The library's own
   datasheet says the same and asks the user to add a "CDM protection network" next to input gates (section 4.4).
2. **The pad's diodes go to the 5 V pad ring (DVDD = `vdd5v0`, DVSS = `vss5v0`), not to the slot's supplies.** The slot
   gets its `vdd_5v0` and `vdd_3v3` through per-slot power switches (section 6.3). Anything the design hangs on the pad
   wire and ties to a slot rail can therefore be forward-biased while the slot is switched off.
3. **The core-side terminal is the bond pad itself.** `ASIG5V` is one Metal2 net from the bond pad to the core edge. The
   design sees the full pad voltage and the full residual ESD voltage (section 4.3).
4. **Foundry numbers exist only for test structures that differ from the pad's diodes.** The design manual gives TLP
   data for a 4-finger diode of 0.9 µm x 25 µm; the pad uses 4 fingers of 3 µm x 50 µm, twice the recommended maximum
   finger length. The library datasheet states *targets* (2 kV HBM, 200 V MM, 500 V CDM), not measurements, and they
   were written for the foundry library `gf180mcu_fd_io`, from which `gf180mcu_ocd_io` was derived (section 7).
5. **The installed PDK contains no ESD limit data at all**: no TLP numbers, no ESD models. It contains layout rules for
   the ESD implant and the salicide block, and device models that were not made for ESD currents (section 7.1).
6. **The evampire page describes `gf180mcu_fd_io`, not the library on this chip.** Its device sizes match the foundry
   netlist where I could check them; its limits are the design manual's test-structure numbers applied to other
   layouts, which is the objection raised in the chat (section 8).
7. **`CLAUDE.md` section 5 holds up**, with one addition: the harness padframe netlist on `main` still connects the
   pads through the pin names `iovdd iovss vdd vss`, which the PDK cell does not have (section 10).
8. **KLayout (added later, section 14).** The PDK's KLayout DRC runs untouched and the pads pass it. Its KLayout LVS
   passes none of the pad cells, not even the foundry's own analog pad: N+ diodes in bare substrate are not extracted,
   and the open pad library's GDS has lost two LVS marker layers. A KLayout twin of the pads would need PDK-wide
   fixes, so nothing was built and the question is put to the user (section 11, question 9).

9. **Other public sources (added later, section 15).** No measured ESD result for these pads is public anywhere.
   The public documentation does add limits that section 7 lacked: the analog pad is rated for 10 mA DC, gate oxide
   breakdown limits are 12 V (6 V gate) and 7 V (3.3 V gate), and the foundry's own second stage (about 110 Ω, 84 µm
   of diode perimeter per polarity) is the best public example for the network the design has to add.
   The industry council's white papers, read in full, recommend 1 kV HBM and 250 V CDM as targets and give resistor
   ranges for exactly this pad architecture: 100 to 5000 Ω in front of receivers, 5 to 100 Ω (optional) behind drivers.

## 2. The pad library: cell table

All cells: `IO/lef/gf180mcu_ocd_io.lef` for class and size, `IO/spice/gf180mcu_ocd_io.spice` for content. **[V]** for
the columns "LEF", "size", "pins" and "devices in the netlist"; the column "what it is for" is **[I]** from the pins,
the netlist content and the cell name, unless a source is given.

| Cell | LEF line, class | Size (µm) | Pins (spice `.subckt` line) | What it is for | Devices in the netlist that matter for ESD |
| --- | --- | --- | --- | --- | --- |
| `asig_5p0` | 5, PAD INOUT | 75 x 350 | `ASIG5V DVDD DVSS VDD VSS` (2) | analog signal pad, pad wired straight to the core | 3 diode groups, 1 MOS cap group (section 4) |
| `bi_t` | 1042, PAD INOUT | 75 x 350 | `A CS DVDD DVSS IE OE PAD PD PDRV0 PDRV1 PU SL VDD VSS Y` (495) | digital bidirectional pad, drive strength selectable (`PDRV0/1`), slew (`SL`), pull-up/down, input select (`CS`) | output FETs with drain salicide block (`io_out`, 501); 4 x `ppolyf_u` 2.5 x 2.8 µm to the input node (497-500); diodes 2 x (20 x 1 µm) each way on the input node (506-507) |
| `bi_a` | 656, PAD INOUT | 75 x 350 | as `bi_t` plus `ANA` (348) | `bi_t` with the node behind the four resistors brought out as `ANA` | as `bi_t`; `ANA` is the resistor/diode node (350-353, 359-360) |
| `bi_24t` | 308, PAD INOUT | 75 x 350 | `A CS DVDD DVSS IE OE PAD PD PU SL VDD VSS Y` (16) | digital bidirectional pad, fixed high drive ("24" in the name; no `PDRV` pins) | `io_out_24` (22): larger output FETs; same resistors and diodes (18-21, 27-28) |
| `in_c` | 2883, PAD INPUT | 75 x 350 | `DVDD DVSS PAD PD PU VDD VSS Y` (737) | digital input, `CS` tied low (744) | an `io_out` with all inputs tied low (743), so the output FETs are present and off; resistors and diodes as `bi_t` |
| `in_s` | 3180, PAD INPUT | 75 x 350 | same (814) | digital input, `CS` tied high (821); "s" presumably Schmitt | as `in_c` |
| `dvdd` | 1736, PAD POWER | 75 x 350 | `DVDD DVSS VDD VSS` (633) | supply pad of the 5 V pad ring | RC-triggered clamp DVDD to DVSS (638-653), diode DVSS to DVDD 4 x (40 x 1 µm) (635), cap (636) |
| `dvss` | 2024, PAD POWER | 75 x 350 | same (661) | ground pad of the 5 V pad ring | the same clamp, diode and cap (663-681) |
| `vdd` | 3477, PAD POWER | 75 x 350 | same (891) | supply pad of the core domain (3.3 V in the harness) | the same clamp circuit between VDD and VSS (896-911), diode VSS to VDD (893) |
| `vss` | 3765, PAD POWER | 75 x 350 | same (919) | ground pad of the core domain | the same clamp between VDD and VSS (921-939) |
| `cor` | 1485, PAD SPACER | 355 x 355 | `DVDD DVSS VDD VSS` (592) | corner | two clamps: DVDD to DVSS (595-610) and VDD to VSS (611-626); 70 MOS caps 25 x 10 µm on DVDD (594) |
| `brk2`, `brk5` | 1419, 1452, PAD SPACER | 2 x 350, 5 x 350 | `VSS` (574, 583) | rail break: only the two VSS rails pass | none |
| `fill1`, `fill5`, `fill10` | 2312, 2453, 2599, PAD SPACER | 1, 5, 10 x 350 | `DVDD DVSS VDD VSS` (689, 701, 713) | fillers that continue all rails | none in the netlist |
| `fillnc` | 2742, PAD SPACER | 0.1 x 350 | same (725) | 0.1 µm filler | none |

Notes on the table:

- The break cells really interrupt the other rails: in the GDS, `brk2` and `brk5` have exactly two full-width
  polygons on each of Metal3, Metal4 and Metal5, at y 246-253 and 318-325, the VSS positions; `fill5` has 26 on each
  layer. **[V]** `IO/gds/gf180mcu_ocd_io.gds`, cells `gf180mcu_ocd_io__brk5`, `__brk2`, `__fill5`, layers 42/0, 46/0,
  81/0 (checked with a KLayout script, journal entry 14).
- `fill5` and `fill10` contain MOS-capacitor marker shapes in the layout (70 and 32 `MOS_CAP_MK` polygons) while
  their netlist subcircuits are empty. **[V]** GDS layer 166/5 against `IO/spice/gf180mcu_ocd_io.spice:701-719`.
  Whether these are connected devices or dummy structures was not checked.
- The clamp in the `vdd`, `vss` and `cor` cells on the core domain uses the same 6 V devices and sizes as the one on
  the pad ring. The library's own to-do list says "The low-voltage domain clamp should be reworked for the lower
  voltage." **[V]** `OCD:TODO:17-18`.
- The library was "copied from Google's open source PDK ... and modified for dual-voltage use" (3.3 V core, 5 V
  pad). **[V]** `OCD:README.rst:4-6`.
- The whole library GDS uses 32 layers. There is no deep n-well (12/0), no ESD implant (24/0), no `LVS_IO` and no
  `LVS_Source` layer anywhere in it. `ESD_MK` (24/5) and `Latchup_MK` (137/5) are present in `bi_t` (the one digital
  pad I looked at) and absent from `asig_5p0`, `dvdd` and `cor`. **[V]** `IO/gds/gf180mcu_ocd_io.gds`, layer list and per-cell counts
  (journal entry 9).

## 3. Layout hierarchy of the pad cells

**[V]** from the `use` statements of `IO/mag/*.mag`; full listing in `LOG/2026-11-26_fable_mag_hierarchy.out`.

| Pad cell | ESD-related sub-cells |
| --- | --- |
| `asig_5p0` | `GF_NI_ASIG_5P0_BASE` → `comp018green_esd_hbm` (the 8 pad diodes); the rail diode and the 36 MOS caps are drawn in the base cell itself |
| `bi_t`, `bi_a`, `bi_24t`, `in_c`, `in_s` | `comp018green_esd_cdm` (resistors and small diodes), `comp018green_out_paddrv_16T` or `_24T` (output FETs) |
| `dvdd`, `dvss`, `vdd`, `vss` | `comp018green_esd_clamp_v5p0_DVDD` or `_DVSS` → `comp018green_esd_rc_v5p0` (timer) and `nmos_clamp_20_50_4_*` (clamp FET) |
| `cor` | `comp018green_esd_clamp_v5p0_1` and `_2`, 10 `moscap_corner*` cells |

`asig_5p0` does not instantiate `comp018green_esd_cdm`, any clamp cell or any FET cell. That is the layout side of
finding 1. **[V]** `IO/mag/gf180mcu_ocd_io__asig_5p0.mag:68-75` (two `use` lines: the metal rail cell and the base
cell) and `IO/mag/GF_NI_ASIG_5P0_BASE.mag` (one `use`: `comp018green_esd_hbm`).

The cell names say what the foundry meant them for: `esd_hbm` in the analog pad, `esd_cdm` in the digital pads. **[I]**
from the names; the datasheet wording in section 4.4 agrees.

## 4. The analog pad `gf180mcu_ocd_io__asig_5p0`

### 4.1 Netlist

**[V]** `IO/spice/gf180mcu_ocd_io.spice:1-10`, complete:

```spice
.subckt gf180mcu_ocd_io__asig_5p0 ASIG5V DVDD DVSS VDD VSS
D1 DVSS DVDD diode_nd2ps_06v0 area='1u * 40u ' pj='2*1u + 2*40u ' m=4
D2 DVSS ASIG5V diode_nd2ps_06v0 area='3u * 50u ' pj='2*3u + 2*50u ' m=4
D3 ASIG5V DVDD diode_pd2nw_06v0 area='3u * 50u ' pj='2*3u + 2*50u ' m=4
XC1 DVDD DVSS cap_nmos_06v0 c_width=15e-6 c_length=15e-6 m=36
* noconn VDD
* noconn VSS
.ends
```

| Device | From → to (anode → cathode) | Type | Size | Total |
| --- | --- | --- | --- | --- |
| D3 | pad → DVDD | P+ in n-well, 6 V (`diode_pd2nw_06v0`) | 4 x (3 µm x 50 µm) | area 600 µm², perimeter 424 µm, finger length 200 µm |
| D2 | DVSS → pad | N+ in p-substrate, 6 V (`diode_nd2ps_06v0`) | 4 x (3 µm x 50 µm) | area 600 µm², perimeter 424 µm, finger length 200 µm |
| D1 | DVSS → DVDD | N+ in p-substrate, 6 V | 4 x (1 µm x 40 µm) | area 160 µm² |
| XC1 | DVDD to DVSS | NMOS capacitor, 6 V oxide | 36 x (15 µm x 15 µm) | 8100 µm²; about 17.6 pF at 5 V **[I]** from the model formula `TECH/ngspice/sm141064.ngspice:39037-39042` (2.18 fF/µm² above threshold, corner factor taken as 1) |

- `VDD` and `VSS` are pins of the cell but connect to nothing inside it. **[V]** lines 8-9. The pad cell still carries
  the VDD and VSS rails across (section 4.3).
- The foundry library's analog pad has the same four devices with the same sizes. **[V]**
  `FDIO/cdl/gf180mcu_fd_io.cdl:15-20`.
- The liberty and Verilog views describe a bare pad: `pad_cell : true`, pin capacitance 0, `drive_current : 0`, an
  empty Verilog module. **[V]** `IO/lib/gf180mcu_ocd_io__tt_025C_5v00.lib:124-149`,
  `IO/verilog/gf180mcu_ocd_io.v:27-33`. The capacitance entry 0 is a placeholder, not a value (section 9.2).

### 4.2 Layout of the devices

**[V]** `IO/gds/gf180mcu_ocd_io.gds`, cell `gf180mcu_ocd_io__asig_5p0`, flattened and merged; numbers in
`LOG/2026-11-26_fable_asig_gds_shapes.out`, `..._asig_gds_rings.out`, `..._asig_gds_layers.out`.

From the chip edge towards the core:

| y (µm) | What | Layers |
| --- | --- | --- |
| 2 - 62 | bond pad opening 60 x 60 at x 7.5 - 67.5 | `Pad` 37/0; Metal5 pin `IO/lef/gf180mcu_ocd_io.lef:17-18` |
| 73.4 - 97.5 | D3: four P+ stripes 50 x 3 at x 12.5 - 62.5, pitch 7.02, in an n-well 55.3 x 29.36 | `DIODE_MK` 115/5, COMP 22/0, Pplus, Nwell 21/0 |
| 110.4 - 134.5 | D2: four N+ stripes 50 x 3, same x and pitch, in substrate, enclosed by an n-well ring 3.28 wide | `DIODE_MK`, COMP, Nplus |
| 147.5 - 161.5 | D1: four N+ stripes 40 x 1 at x 17.5 - 57.5, pitch 4.36, enclosed by an n-well ring 2.78 wide | same |
| 171.8 - 344.8 | XC1: 36 MOS caps 15 x 15 in 4 columns x 9 rows | `MOS_CAP_MK` 166/5, LVPWELL 204/0, Poly2 |

Details that a generator would have to reproduce (all **[V]** from the same GDS outputs):

- Each D2/D3 stripe is contacted by 6 rows x 100 columns of 0.22 µm contacts on a 0.5 µm pitch. D1: 2 rows x 85
  columns, pitch 0.47 µm x 0.64 µm.
- Each diode stripe sits in its own window of a tap grid (COMP of the opposite type): window 52.03 x 5.03 for D2/D3,
  so 1.015 µm from stripe to tap on all four sides; grid frame 1.22 µm wide, bars between stripes 1.99 µm.
- Around each tap grid lies a second COMP ring: 2.45 µm wide for D2 and D3, 1.95 µm for D1. For D3 it is P+ in
  substrate around the n-well; for D2 it is the N+ tap of the n-well ring.
- Implant enclosure of a diode stripe 0.16 µm (Nplus/Pplus 50.32 x 3.32), Dualgate enclosure 0.24 µm (50.48 x 3.48).
- The whole area is covered by `ISOSUB` (23/5), the marker Magic calls `isosubstrate`. There is no deep n-well.

No `Latchup_MK` on any of these diffusions (section 2, last note). The design manual recommends that marker on
diodes that can be forward biased, "such as ESD diodes". **[V]** `DRM:drm_14_3_2.rst:6-10`.

### 4.3 Terminals, metal and supply rails

- **`ASIG5V` is a single net.** Starting from the Metal5 pad, the net is Metal5, Metal4 and Metal3 only under the
  bond pad (y 0 - 65.33), and Metal2 from y 0 to y 350. **[V]** GDS trace, `LOG/2026-11-26_fable_asig_pad_net_metal2.out`
  and journal entry 13.
- Above the bond pad the net is **eight Metal2 strips, each 2.54 µm wide, 20.32 µm in total**, at x 15.34, 21.02,
  26.70, 32.38, 40.08, 45.76, 51.44, 57.12 (left edges). They cross the diode stripes at right angles and end at
  the core edge. **[V]** same output; `IO/lef/gf180mcu_ocd_io.lef:19-51` lists the same eight Metal2 ports from
  y 134.37 to 350.
- The diodes hang on those strips through Via1 and eight Metal1 plates of 50 x 3 µm. **[V]** same trace (8 COMP
  shapes of 50 x 3 on the pad net).
- So the complete ESD current of this pad, and the complete signal current, run in 20.32 µm of Metal2. The Metal2
  current limit was not looked up. **Open.**
- Supply rails cross the cell horizontally on Metal3, Metal4 and Metal5 (the LEF lists the Metal5 edge stubs). From
  bottom to top, with heights in µm: DVSS 3 x 15 (y 70 - 117), DVDD 7, DVSS 7, DVDD 4 x 15 (y 134 - 197), DVSS 7,
  DVDD 7, DVDD 15, DVSS 15 (y 230 - 245), **VSS 7 (246 - 253), VDD 7 (254 - 261)**, DVDD 3 x 7, DVSS 7, DVDD 7, DVSS 7,
  **VDD 7 (310 - 317), VSS 7 (318 - 325)**, DVSS 7, DVDD 7, DVSS 6.39 (to y 348.39). **[V]**
  `IO/lef/gf180mcu_ocd_io.lef:53-276`.
  The core-domain rails are two 7 µm lines each; the pad-ring rails take the rest.

### 4.4 What the library says about its own protection

- "The analogue signal pads contain only HBM protection diodes. If they are connected to input gates, the designer
  needs to include CDM protection network near to these gates". **[V]** `OCD:docs/analog.rst:15`.
- "The perimeter of the CDM diode should be larger than 25µm. The CDM resistor should be larger than 50 and should be
  realized using appropriate poly resistor." **[V]** `OCD:docs/analog.rst:25`. (After "50" the source has the
  character U+F057, an Ω of the Symbol font that most viewers do not show; ohms are meant **[I]**.)
- The figure next to it draws the added network as a series resistor followed by one diode to **DVDD** and one to
  **DVSS**, i.e. to the pad ring. **[V]** `OCD:docs/specs/Analogue_Signal_Cells2.png` (looked at in this session).
- These are the numbers `CLAUDE.md`, `HANDOVER_gf180_migration.md` §3.5 and `docs/IHP_TO_GF180_PORT_MAP.md` attribute
  to Tim Edwards' chat messages. Their written origin is this datasheet page, which exists with the same words for
  the foundry library (`gf180mcu-pdk.readthedocs.io/en/latest/IPs/IO/gf180mcu_fd_io/analog.html`, fetched in this
  session). **[V]** for the text; that the chat quoted it is **[I]**.
- The pad is "meant for analogue circuits that use the thick-gate transistors". **[V]** `OCD:docs/analog.rst:4`.

### 4.5 Check of the claim "HBM diodes only; CDM protection is ours"

| Part of the claim | Result |
| --- | --- |
| The pad contains diodes and no other protection device | **[V]** netlist (4.1) and layout hierarchy (section 3) |
| The pad has no series resistor and no second stage towards the core | **[V]** netlist; `ASIG5V` is one metal net (4.3) |
| The diodes are "HBM" diodes | **[V]** as the library's own description (4.4) and the layout cell name `comp018green_esd_hbm`; whether they reach any HBM level in silicon is not known (section 7) |
| CDM protection must be added by the user | **[V]** as the library's instruction (4.4), for pads "connected to input gates". For a pad driven by an output stage the datasheet gives no instruction. **Open** (section 11, question 4) |

## 5. The ESD structure in plain language

### 5.1 What is in the cells

- **Pad diodes (analog pad).** One diode from the pad up to the 5 V ring supply, one from the 5 V ring ground up to
  the pad. In normal use both are reverse biased. When the pad is pushed above DVDD or below DVSS by about 0.6 V, one
  of them conducts and steers the charge into a ring rail. **[V]** topology, section 4.1.
- **Rail clamps (supply pads and corners).** A discharge that enters through a pad diode ends up on a rail and still
  has to get to the other rail. Each `dvdd`/`dvss` pad and each corner has a circuit for that: a 4000 µm wide NMOS
  (80 fingers; `W=4m nf=80`, L = 0.7 µm) between DVDD and DVSS, switched on by three inverters, which are in turn
  driven by a timer made of a poly resistor (0.8 µm x 766.26 µm) and eight MOS caps (25 µm x 10 µm). **[V]**
  `IO/spice/gf180mcu_ocd_io.spice:638-653`. A fast rise of DVDD turns the NMOS on; a slow power-up does not. **[I]**
  from the circuit (resistor to DVDD, capacitor to DVSS, odd number of inverters).
  Timer constant about 1.6 µs **[I]**: 350 Ω/sq (`TECH/ngspice/sm141064.ngspice:413`) x 766.26 / 0.75 ≈ 360 kΩ, times
  2000 µm² x 2.18 fF/µm² ≈ 4.4 pF. The evampire page states the same value **[U]**; I did not simulate the clamp.
- **A diode from DVSS to DVDD** (4 x 40 x 1 µm) in every `asig`, `dvdd` and `dvss` cell, for discharges that make
  DVSS positive against DVDD. **[V]** lines 4, 635, 663.
- **Output transistors (digital pads only).** NMOS and PMOS with a salicide-blocked drain (`*_06v0_dss`, `d_sab` 3.78 µm
  and 2.78 µm) directly on the pad. In `bi_t`: 8 NMOS of 38 µm (L = 1.15 µm) = 304 µm, and PMOS 4 x 80 µm + 4 x 40 µm =
  480 µm. **[V]** `IO/spice/gf180mcu_ocd_io.spice:437-453` (one `drive_select`, used four times, lines 381-393). In
  `bi_24t`: NMOS 8 x 37 µm (L = 0.8 µm), PMOS 4 x 120 µm + 4 x 60 µm. **[V]** lines 234-249, 68-71.
  According to Staf Verhaegen in the chat, such pads rely on snapback of these transistors, not on a separate
  diode. **[U]** for this library: nothing in the installed PDK says which mechanism the foundry relied on.
- **Second stage (digital pads only).** Four poly resistors in parallel (2.5 µm x 2.8 µm each) between the pad and
  the input buffer, then two small diodes each way (2 x 20 x 1 µm). **[V]** lines 497-500, 506-507. Each resistor is
  449 Ω in an operating-point run with the typical model **[I]** (`LOG/2026-11-26_fable_asig_diodes_dc_ngspice.out`,
  line `1/i(vr)`), and the foundry netlist annotates them `r=432.59` and `r=449.157` **[V]**
  `FDIO/cdl/gf180mcu_fd_io.cdl:1174-1177`; so about 110 Ω in parallel.
- **The analog pad has neither output transistors nor a second stage.**

### 5.2 Discharge paths for the analog pad

**[I]** from the netlist topology; none of this was simulated at ESD currents, and no model in the PDK is valid
there (section 7.1).

| Stress | Path |
| --- | --- |
| pad positive, DVDD grounded | D3 forward, into DVDD |
| pad negative, DVSS grounded | D2 forward, out of DVSS |
| pad positive, DVSS grounded | D3 forward onto DVDD, then a rail clamp from DVDD to DVSS |
| pad negative, DVDD grounded | a rail clamp from DVDD to DVSS, then D2 forward |
| pad to another signal pad | D3, DVDD, rail clamp, DVSS, the other pad's lower diode |
| pad against VDD or VSS (core domain) | no device in the pad cell connects the two domains. DVSS and VSS are both taps of the one p-substrate (no deep n-well anywhere in the library, section 2), so there is a resistive substrate connection whose value is unknown |

The voltage on the pad wire during a discharge is the sum of one diode drop at ESD current, the rail voltage drop
to the nearest clamps and the clamp's own drop. All of it appears at the design's first device (finding 3).

## 6. The pads in the harness padframe

### 6.1 Which pads, on which nets

- Slot 16 has two pads, `s16_an[0]` and `s16_an[1]`, both `gf180mcu_ocd_io__asig_5p0`. **[V]** `B:config.txt:169-170`.
- The pad type of a slot's own pads can be changed in `config.txt` to one of six: `bi_24t`, `bi_t`, `bi_a`, `in_c`,
  `in_s`, `asig_5p0`; a change needs coordination with the slot's designer and a rebuild. **[V]** `B:config.txt:36-58`.
- Every pad's `DVDD/DVSS` is on `vdd5v0/vss5v0`; `VDD/VSS` is on `vdd3v3/vss3v3`, except in the bottom segment where
  VDD is `vddd`. **[V]** `B:verilog/gl/gf180mcu_padframe.v:1024-1043` for the two slot 16 pads; tabulated for all pads
  in the journal (entry 10). The comments name the nets: "vdd5v0 Global 5.0V power", "vdd3v3 User project 3.3V
  power". **[V]** `B:verilog/gl/gf180mcu_padframe.v:17-21`.
- In that file the pad instances use the pin names `.iovdd .iovss .vdd .vss`. The PDK cell's pins are
  `DVDD DVSS VDD VSS`. See section 10.

### 6.2 Where they sit

**[V]** `B:magic/gf180mcu_padframe.mag` (instance transforms; line numbers below) and
`B:scripts/gen_padframe.tcl:8-19, 528-551`.

- Padframe 3880 µm x 5070 µm, 80 pads: 15 on top and bottom, 25 on each side. Pads are 75 µm wide; the spacer
  between two pads is 95 µm on the left and right sides (nine `fill10` and one `fill5`) and 127 µm on top and
  bottom. So the **pad pitch on the slot 16 side is 170 µm**.
- `pad_s16_an_0` and `pad_s16_an_1` are on the west side, origins at y = 2062 and y = 1892 (lines 1257, 1261).
- Neighbours going north from `s16_an_0`: `s15_an_1`, `s15_an_0`, then `pad_vss5v0_5` (a `dvss` cell, y = 2572, line
  1381). Going south from `s16_an_1`: `pad_vss3v3_5` (a `vss` cell, y = 1722).
- **The nearest cell with a DVDD-to-DVSS clamp is `pad_vss5v0_5`, three pad positions (510 µm) from `s16_an_0` and
  four (680 µm) from `s16_an_1`.** The `vss` pad next to `s16_an_1` clamps VDD to VSS, not the 5 V ring.
- The ring is cut by two `brk5` cells, on the east side at y = 622 and on the west side at y = 627 (lines 2449,
  5469). The slot 16 pads are in the upper segment. That segment contains 2 `dvdd` pads (top side), 6 `dvss` pads and
  2 corners, i.e. 10 DVDD-to-DVSS clamps **[I]** counted from the positions; the lower segment has 1 `dvdd` pad and
  2 corners. Whether the two segments' 5 V rails are joined again inside the chip was not extracted.
- The rail resistance between the slot 16 pads and those clamps was not computed. **Open.**

### 6.3 From the pad to the slot

- The slot wrapper `slot16_wrapper` is 1274.27 µm x 412.71 µm. **[V]** `B:magic/slot16_wrapper.mag:189`
  (`FIXED_BBOX 0 0 254854 82542`, units of 5 nm).
- `s16_an[0]` and `s16_an[1]` arrive as Metal3 pins on the wrapper's west edge: x 1.24 - 3.24 µm, y 272.70 - 317.02 µm
  and y 102.70 - 147.02 µm (each 2 µm x 44.32 µm). **[V]** lines 184, 186.
- "a dedicated pad runs straight to the bond pad with nothing in between". **[V]** `B:verilog/rtl/slot16_wrapper.v:62-71`.
- **The slot's positive supplies are switched.** `vdd_5v0` of the slot is `user_avdd[15]`, the output of a
  `power_stage` fed from `vdd5v0`; `vdd_3v3` is `user_dvdd[15]`, the output of a `power_stage3v3` fed from `vdd3v3`.
  The grounds `vss_5v0` and `vss_3v3` are connected directly. **[V]** `B:verilog/rtl/chipalooza_frame.v:895-913,
  265-266, 1379-1385`.
- Consequence **[I]**: the pad's own diodes refer to rails that are up whenever the chip is powered; a diode or a
  PMOS body the design ties to `vdd_3v3` or `vdd_5v0` refers to a rail that is down while the slot is disabled. A
  signal on the pad then feeds that rail through the design's diode. The existing proof-of-concept front end has
  its diodes on the slot's `vdd` (section 9.1).
- The routing between the pad's Metal2 strips and the wrapper pin (layer changes, width, resistance) was not
  examined. **Open.**
- The harness README describes a second, "non-ESD"/"_esd" pair of core pins for analog pads; that text was written
  for another process. On this chip the pad has one core terminal. **[V]** `B:README:276-290` against
  `IO/spice/gf180mcu_ocd_io.spice:2`. `B:verilog/gl/gf180mcu_ocd_chipalooza.v:90-91` still declares wires named
  `s16_an_0_esd` and `s16_an_1_esd`; what drives them was not traced.

## 7. What is known about limits, and what is not

### 7.1 In the installed PDK

- **No ESD characterisation data.** A search of `TECH/ngspice/*.ngspice` for `esd`, `snapback`, `tlp`, `hbm`, `cdm`
  finds nothing; the PDK ships no design manual (the only documents under `$PDK_ROOT/gf180mcuD` are two KLayout
  `README.md` files). **[V]** journal entries 5 and 6.
- **Layout rules that exist** (KLayout deck, `TECH/klayout/tech/drc/rule_decks/`): `ESD.1` to `ESD.10` and `ESD.pl`
  for the ESD implant layer (`esd.rb:34-124`), `SB.1` to `SB.16` for the salicide block (`sab.rb:39-176`). **[V]**
- **Rules that do not exist in the deck:** the manual's ESD device guidelines (`HVNESD.*`, `HVPESD.*`, the diode
  guidelines 14.4.5.x) and the I/O latch-up rules `IO.1` to `IO.4`. A search of the deck for these names finds
  nothing; `Latchup_MK` and `ESD_MK` are only read and checked for grid and angle. **[V]** journal entry 14
  (`generic_layers.rb:67, 78`, `geom.rb:87, 98`). A layout can violate every ESD guideline and pass DRC.
- **Device models.** The 6 V diode models have a reverse breakdown parameter of 11 V (N+/substrate) and 10.5 V
  (P+/n-well). **[V]** `TECH/ngspice/sm141064.ngspice:38379-38380, 38405-38406`. The `*_dss` FET models take the
  salicide block lengths as parameters (`nfet_06v0_dss ... s_sab=0.28u d_sab=3.78u`, line 37039). None of these
  models contains snapback or a thermal limit **[I]**: they are ordinary `level=3` diode and compact MOS models.

### 7.2 In the foundry design manual (not in the installed PDK)

All **[V]** in `DRM:`; file names relative to that folder.

- The manual characterises three device types for ESD: grounded-gate NMOS, grounded-gate PMOS and diodes, with TLP
  pulses of 100 ns width and 10 ns rise time. `drm_14_4.rst:9`.
- It warns that the numbers do not transfer directly: "it is not un-common to see drastic deviations from the TLP
  based ESD robustness prediction and actual Human Body Model ESD qualification levels achieved." `drm_14_4.rst:11`.
- 5 V/6 V diodes, `tables_clear/66_ESD7_Performance_180.csv` and `67_ESD8_Performance_181.csv`:

  | Device | It2 (second breakdown current) | Vt2 |
  | --- | --- | --- |
  | N+/p-well diode | ~30 mA/µm | ~6.7 V |
  | P+/n-well diode | ~31 mA/µm | ~6.9 V |

  The test structure is four fingers of 0.9 µm x 25 µm (caption of `images/ESD_Characterization7.png`:
  "DW=0.9um, DL=25um, NF=4"; the plot ends near 3 A). So "per µm" means per µm of finger length, 100 µm in the test
  structure. **[I]** from 3 A / 100 µm = 30 mA/µm.
- 5 V/6 V transistors without ESD implant, `tables_clear/64_ESD5_Performance_178.csv`, `65_ESD6_Performance_179.csv`:

  | Device | Vt1 | Holding voltage | It2 | Vt2 |
  | --- | --- | --- | --- | --- |
  | grounded-gate NMOS | ~10.7 V | ~6.2 V | ~7 mA/µm | ~8 V |
  | grounded-gate PMOS | ~9.7 V | (none given) | ~5.3 mA/µm | ~14.1 V |

- Layout guidelines for 5 V/6 V diodes (`drm_14_4_5.rst:6-19`, figure `images/HV_SAB3.png`): junction width at least
  0.9 µm; "recommended maximum" finger length 25 µm. In the figure the short side of the stripe is 14.4.5.1 and the
  long side 14.4.5.2. (The text calls the short side DL and the long side DW; the caption of the TLP plot uses the
  letters the other way round.)
- Guidelines for 5 V/6 V ESD transistors: `tables_clear/58_HV_SAB_MOSFET_168.csv` (NMOS) and
  `59_HV2_SAB_MOSFET_170.csv` (PMOS); the values a generator would need are in section 12.2.
- I/O latch-up rules `IO.1` to `IO.4`: diffusion connected to a pad needs a tap ring and a guard ring of the other
  type within 15 µm, guard ring at least 2 µm wide. `tables_clear/56_IO_Latch-up1_156.csv`, `56_IO_Latch-up2_158.csv`.

### 7.3 In the library datasheet

- ESD: "Human Body Model (HBM) 2000V, Machine Model (MM) 200V, Charged Device Model (CDM) 500V", under the column
  heading **"Target"**. **[V]** `OCD:docs/specs/16_ESD_Protection.csv:1-4`.
- Latch-up: ±100 mA at 25 to 125 °C, JESD78B, also a target. **[V]** fetched page `.../gf180mcu_fd_io/latchup.html`;
  `OCD:docs/latchup.rst` exists (its table file was not opened).
- Operating conditions: I/O supply 4.5 / 5 / 5.5 V, junction temperature -40 / 25 / 125 °C. **[V]**
  `OCD:docs/specs/15_Operating_Conditions.csv:1-3`.
- Clamp leakage: 648 nA maximum per clamp "from simulation" (FF, 5.5 V, 125 °C). **[V]** `OCD:docs/power.rst:4`.
- These pages were copied from the foundry library's documentation; the same text is on the foundry site. The
  library has since been changed to two voltage domains. **[V]** `OCD:README.rst:4-6`; that the targets were not
  re-examined after the change is **[I]** from `OCD:TODO:9-18`, which lists the liberty data and the low-voltage
  clamp as not yet reworked.

### 7.4 The pad's diodes measured against the manual

| Quantity | Pad diode D2 / D3 | Manual | Mark |
| --- | --- | --- | --- |
| junction width (short side) | 3.0 µm | at least 0.9 µm | [V] both |
| finger length (long side) | 50 µm | recommended maximum 25 µm | [V] both |
| fingers | 4 | test structure: 4 | [V] both |
| total finger length | 200 µm | test structure: 100 µm | [V] / [V] caption |
| failure current | **not known** | ~3 A for the test structure | [V] manual only |

A naive scaling by finger length would give about 6 A. I list that number only to say that it is **a guess [I]**:
the stripe is more than three times as wide and twice as long as the measured one, the finger is longer than the
manual recommends, and the current also has to pass 20.32 µm of Metal2 (section 4.3). For orientation, a 2 kV HBM
discharge peaks near 1.3 A (2000 V across the model's 1500 Ω; general knowledge, not from a file here).

### 7.5 Which numbers are only guesses

- Any HBM, MM or CDM level of `asig_5p0`, of the digital pads, or of the chip. The datasheet numbers are targets.
- Any failure current of the pad diodes (7.4).
- The trigger and holding voltages of the output transistors in `bi_t` and `bi_24t`: the manual's values are for its
  own test transistors, and Sylvain's objection in the chat is that the layouts differ **[U]** (I did not compare the
  salicide block geometry of the library's transistors with the manual's test structure).
- The clamp's on-resistance and turn-on time at ESD current.
- The voltage that reaches the slot during a discharge on a slot 16 pad.
- The "larger than 25 µm" and "larger than 50" of the CDM network: a datasheet instruction without a stated level.

### 7.6 What cannot be known without silicon or foundry data

- Whether the analog pad, as placed on this padframe, survives any given HBM or CDM level.
- The real failure current and on-resistance of 3 µm x 50 µm diode stripes, and of any diode geometry a parametric
  cell would generate that is not the manual's test structure.
- Snapback behaviour (Vt1, holding voltage, It2) of any FET layout other than the measured one, including uniformity
  of turn-on across fingers.
- CDM behaviour in general: it depends on the package, the die capacitance and the rail resistances, and the manual
  has no CDM data.
- Latch-up immunity of a new cell next to the pad.

## 8. The evampire page compared with the files

The page (`https://evampire.readthedocs.io/en/latest/esd/io-cells.html`) and five sibling pages were read by a
subagent, which returned a list of 43 claims; I compared the ones below. The page names its subject as
`gf180mcu_fd_io` throughout and never mentions `gf180mcu_ocd_io` **[V]** (subagent report, journal entry 3). Sylvain's
statement that Claude wrote the page is **[U]**; the page names no author.

| Claim on the page | Check | Result |
| --- | --- | --- |
| library targets 2000 V HBM, 200 V MM, 500 V CDM, ±100 mA latch-up | `OCD:docs/specs/16_ESD_Protection.csv`, foundry site | matches; the source says "Target", and so does the page |
| `asig_5p0`: diodes only, four 150 µm² parts (600 µm²), no series resistor, the core sees the full pad voltage | `FDIO/cdl/gf180mcu_fd_io.cdl:15-20`; `IO/spice/...:4-6` | matches, also for the library on this chip |
| `bi_t` NMOS: eight of 38 µm = 304 µm, L = 1.15 µm, silicide block 3.78 µm | `IO/spice/...:437-444` | matches for `gf180mcu_ocd_io` |
| `bi_t` PMOS: four of 80 µm and four of 40 µm = 480 µm, silicide block 2.78 µm | `IO/spice/...:448-453` | matches for `gf180mcu_ocd_io` |
| input reached through four 440 Ω resistors in parallel, about 110 Ω | `FDIO/cdl/gf180mcu_fd_io.cdl:1174-1177` (`r=432.59`, `r=449.157`) | matches |
| two small secondary diodes, "40 µm²" | `IO/spice/...:506-507` | 2 x 20 µm² each way; the page's wording is ambiguous, the numbers agree |
| rail clamp: 4000 µm NMOS, 80 fingers of 50 µm, three inverters, eight 10 x 25 µm caps | `IO/spice/...:638-653` | matches |
| timer: twelve 30 kΩ resistors in series, 360 kΩ | `IO/spice/...:653` has one resistor 0.8 x 766.26 µm | total length matches 12 x 63.855 µm; ≈ 360 kΩ by my estimate [I] |
| clamp cap 2.18 fF/µm², 4.35 pF | model formula `TECH/ngspice/sm141064.ngspice:39037-39042` | matches [I] |
| junction breakdown "typical 11 V / 10.5 V" | diode models, lines 38380, 38406 | matches the model parameter `bv`; the page cites an electrical-parameter document I did not read |
| TLP table: diodes 30 / 31 mA/µm at 6.7 / 6.9 V; NMOS 10.7 V, 6.2 V, 7 mA/µm, 8 V; PMOS 9.7 V, 5.3 mA/µm, 14.1 V | `DRM:tables_clear/64...67_*.csv` | matches the manual |
| "no separate primary diodes; the output transistors are the primary protection, and their drains form diodes" | topology only | the netlist has no primary diode in `bi_t` [V]; which mechanism protects is not stated in any file [U] |
| the output transistors' drain diodes carry the manual's diode currents (30 mA/µm x 480 µm etc.; simulation page) | - | **unverified, and the weak point**: the manual's diode data is for dedicated diode stripes, not for FET drains. This is Sylvain's objection |
| simulated pad and gate voltages for 2 kV HBM and 8 kV IEC | - | [U]; produced with devices the page's authors added to the models, as the page says itself (simulation page). Not reproduced here |
| "the NMOS snaps back to about 6 V / 6.2 V / 6.8 V" | manual: ~6.2 V | the page is inconsistent with itself (three values); the manual says ~6.2 V |
| gate oxide breakdown minimum 12 V, typical 16 V | - | not checked: the cited electrical-parameter document is not in the installed PDK and I did not open it upstream |

What follows for this project **[I]**:

- The page's statement about the analog pad is right and adds nothing to section 4.
- Its limits table is the manual's table. It may be quoted as "the manual's test-structure data", never as a
  property of a pad cell.
- Nothing on the page concerns the two-domain library on this chip or the harness.

## 9. What the single2diff2single design must connect to

### 9.1 The present state of the design, for reference

- Input macro `gf180mcu_IOPadSingle2Diff`: 200 Ω-class poly resistor, then one diode to the macro's `vdd` and one
  from `vss`, 2 µm x 12 µm each (perimeter 28 µm); proof of concept. **[V]** `macros/gf180mcu_IOPadSingle2Diff/README.md:8-13`.
- Output macro `gf180mcu_IOPadDiff2Single`: class-AB driver, ports `vdd vss vddo vsso inp inn vref out iref en`; "Not
  included yet: the CDM / ESD network at `out`". **[V]** `macros/gf180mcu_IOPadDiff2Single/README.md:21-25`.
- `docs/OPERATING_LIMITS.md` already records that with diodes to a 3.3 V `vdd` the input is not 5 V tolerant.

### 9.2 Electrical facts of the pad, as seen from the slot

Model evaluations **[I]**: typical corner, diode stripes only (`LOG/tools/asig_diodes_dc.spice`, output
`LOG/2026-11-26_fable_asig_diodes_dc_ngspice.out`). The leakage floor of a few pA in that output is the simulator's
`gmin`, not a device property.

| Quantity | Value | Mark |
| --- | --- | --- |
| pad voltage range without diode conduction, DVDD = 5 V | 1 µA is reached near -0.57 V and near DVDD + 0.57 V at 27 °C; at 125 °C, 0.37 µA at -0.3 V and 0.24 µA at DVDD + 0.3 V | [I] |
| junction capacitance of D2 + D3 on the pad | 0.80 pF at 2.5 V, 0.96 pF at 0 V and at 5 V | [I] |
| wiring capacitance of the pad net inside the pad cell | about 1.15 pF (0.54 to DVDD, 0.38 to DVSS, 0.17 to substrate, 0.05 to VDD and VSS) | [I] KLayout 2.5D extraction, accuracy unverified (section 14.3); routing to the slot and the package are not included |
| series resistance pad to slot inside the pad cell | Metal2, 20.32 µm wide, about 285 µm long from the pad edge to the core edge | [V] geometry; resistance not computed |
| DC leakage of the pad | not obtained (model floor only) | open |
| DC current rating of the pad | 10 mA ("DC current carrying capability 10mA") | [V] `OCD:docs/specs/02_Cell_List.csv:18-20` (section 15.2) |
| supply decoupling inside the pad cell | about 17.6 pF between DVDD and DVSS | [I] |
| back-powering: ring unpowered (DVDD = 0 V), pad at 0.7 V | 94 µA flows from the pad into DVDD | [I] |

### 9.3 Consequences for the two pins

- **Input (`vin`).** The pad lets the signal move between about -0.3 V and `vdd5v0` + 0.3 V before its own diodes
  conduct. Inside that window the design's own protection decides. The datasheet's network (4.4) puts the added
  diodes on DVDD/DVSS, the ring rails; the slot has `vdd_5v0` and `vss_5v0` pins, but its `vdd_5v0` is the switched
  copy (6.3). Which rail the design's diodes should use is a decision for the user (question 2).
- **Output (`vout`), DC limit.** The pad is rated for 10 mA DC (section 15.2); the class-AB driver's load current has
  to stay inside that.
- **Output (`vout`).** The driver's output devices sit directly on the pad wire with only the pad diodes in front
  of them. In a discharge they see the full pad voltage; whether they survive, or themselves conduct, depends on
  their layout. On the IHP design the output devices were built as clamp-style cells and doubled as the pad's
  clamps (`macros/gf180mcu_IOPadDiff2Single/README.md:25`). For GF180 the manual's transistor guidelines (12.2) are
  the only foundry statement on how such devices should be drawn.
- **Third signal (`vcm`, per `docs/OPERATING_LIMITS.md`).** Slot 16 has two pads (6.1). The IHP design used three
  analog pins. Where the third signal goes is open (question 5); the shared `analog_bus0..3`, `vbias`, `ibias0/1`
  pins exist on the wrapper (`B:magic/slot16_wrapper.mag:92-104`).
- **Supplies.** The slot's `vdd_5v0`/`vss_5v0` and `vdd_3v3`/`vss_3v3` enter on Metal5 at the wrapper's east edge
  (`B:magic/slot16_wrapper.mag:84-90`), the analog pads on the west edge. The pad ring rails themselves are not
  slot pins.
- **Grounds.** `vss_5v0` and `vss_3v3` are different nets in the netlists and share the substrate (5.2). The
  harness README lists the separation of the two ground domains as an unsolved LVS issue. **[V]** `B:README:456-460`.

## 10. Check of `CLAUDE.md` section 5, and things that look wrong

| Statement in `CLAUDE.md` §5 | Result |
| --- | --- |
| eighteen slots; wrapper 1274.27 x 412.71 µm | [V] `B:magic/slot16_wrapper.mag:189`; `B:gds/` has `slot1..18_wrapper.gds` |
| this project is slot 16 | [V] `B:config.txt:88, 132` |
| wrapper labels: `s16_an[0]`, `s16_an[1]`; four supplies; `analog_bus0..3`, `vbias`, `ibias0`, `ibias1`; 24 `dig_in`, 12 `dig_out`, `reset`, `enable`, `clk` | [V] `B:magic/slot16_wrapper.mag` (label count, journal entry 11) |
| project layout is collected as `slot_<N>.gds` with top cell `slot_<N>`, from `final/gds/`, `gds/`, then anywhere | [V] `B:scripts/get_project_gds.sh:21-23, 34-38` |
| conflict with section 1 (top cell name) | still unresolved; nothing in B settles it |
| `gf180mcu_ocd_io` is installed with `mag gds lef lib spice verilog` | [V]; there is also `xschem` |
| the pad's ports are `ASIG5V DVDD DVSS VDD VSS` | [V] `IO/spice/gf180mcu_ocd_io.spice:2` |
| "HBM diodes only; CDM protection is ours" was not re-checked | re-checked: section 4.5 |

Things I would report as wrong or stale. I changed none of them.

1. **Pad pin names in the harness netlist.** `B:verilog/gl/gf180mcu_padframe.v` (e.g. lines 1026-1029) and its
   template `B:scripts/gf180mcu_padframe_template.v` connect `.iovdd .iovss .vdd .vss`; the cell has
   `DVDD DVSS VDD VSS`. An earlier analysis with a patch is on the fork's notes branch
   (`sudel_buecher`, `sudelbuecher/harness_tools/fixes/pad_pins/ANALYSIS.md`); `main` at `2f18cd4` does not contain
   the fix. The brief's sentence "The GF pads use the pin names DVDD DVSS VDD VSS" is true of the PDK cell and not of
   that file.
2. **`docs/IHP_TO_GF180_PORT_MAP.md`, row "PR boundary":** it says layer 0/0 is "not checked against a real GF180
   GDS". The pad library GDS has `PR_bndry` 0/0 as one 75 x 350 rectangle in `asig_5p0`. **[V]**
   `LOG/2026-11-26_fable_asig_gds_shapes.out`. That is one real GF180 GDS using 0/0; the harness precheck remains
   unchecked.
3. **`submission.yaml` (`analog-pins: 3`) and `harness_stub/`** are stale, as `CLAUDE.md` already says: slot 16 has
   two analog pads.
4. **`docs/OPERATING_LIMITS.md`, last paragraph:** "The pad's own HBM diodes go to DVDD/DVSS and do not conduct in
   this range" holds for DVDD = 5 V. With the ring unpowered they conduct from about 0.6 V (9.2).
5. **The pad netlist does not load in the ngspice of this container.** `XC1 ... cap_nmos_06v0 ... m=36` makes
   ngspice-47 stop with `unknown parameter (e9)` on the expanded capacitor line. I evaluated the diodes from a copy
   without `XC1`. The project's earlier pad-in-the-loop runs used other tool builds (`HANDOVER_gf180_migration.md`
   §7, §9); I did not find out which combination works. **[V]** for the error (journal entry 12).
6. **`asig_5p0` carries no `Latchup_MK`** although its diodes are exactly the case the manual names (4.2). Whether
   the shuttle's checks care is unknown.

## 11. Open questions for the user

1. **Pad type.** `config.txt` lets slot 16 choose `bi_a` instead of `asig_5p0` for a pad. `bi_a` brings the four
   resistors and the small diodes (its `ANA` pin) but also a digital output stage on the pad and five control pins.
   Is a change of pad type on the table at all, or is `asig_5p0` fixed?
2. **Which rails for the design's own protection:** the slot's switched `vdd_5v0`/`vdd_3v3`, or does the slot need
   the unswitched ring rails? Related: must the pads tolerate a signal while slot 16 is switched off, or while the
   chip's 5 V supply is absent?
3. **Target levels.** Is there an ESD level the design has to claim (HBM, CDM), or is "follow the datasheet's CDM
   network and state the limits" enough for Chipalooza #3? No file I read sets a requirement for user projects.
4. **Output pad.** Should the output devices be drawn to the manual's ESD transistor guidelines (salicide-blocked
   drain, finger width 20 to 60 µm) and double as protection, as on IHP, or be ordinary devices behind a
   resistor-and-diode network? This decides what the "output layout cells" are.
5. **Third signal.** With two pads, where does `vcm` (or the third IHP pin) go: a shared analog bus line, internal
   generation, or dropped?
6. **Top cell name.** `slot_16` (harness) against `gf180_cm_ip__single2diff2single` (`CLAUDE.md` §1): still open; it
   needs the user and the harness maintainer.
7. **Verification tool for parametric cells.** The IHP cells are KLayout PyCells; this repository's flow and the
   harness are Magic-based. Which tool should own generated cells here (section 12.4)?
8. **May I treat the upstream repositories `google/gf180mcu-pdk` and `RTimothyEdwards/gf180mcu_ocd_io` as allowed
   read-only sources in future tasks?** I cloned both in this session without their being in the brief (section 13).
9. **KLayout support (section 14).** The pads cannot get an honest KLayout twin without PDK-wide work: an LVS deck
   fix for substrate diodes, the lost marker layers and KLayout netlists of `gf180mcu_ocd_io`, and ESD, guard-ring,
   via-stack and bond-pad PCells that IHP has and GF180 lacks. Should I take that on for the whole PDK (as patches and
   proposals for upstream, starting with the diode-array PCell and the LVS deck change), restrict myself to what
   works today (KLayout DRC and parasitic extraction of the pads, no LVS), or leave KLayout aside?

## 12. Notes for parametric cells

### 12.1 Dimensions as parameter candidates

Sources: `SP` = `IO/spice/gf180mcu_ocd_io.spice` with line; `GDS` = `IO/gds/gf180mcu_ocd_io.gds`, cell
`gf180mcu_ocd_io__asig_5p0`, numbers in the `LOG/` outputs named in section 4.2. All **[V]** unless marked.

**(a) Pad diode stripe array (D2, D3 of `asig_5p0`)**

| Name | Value | Unit | Source |
| --- | --- | --- | --- |
| `n_fingers` | 4 | - | SP:5-6 (`m=4`) |
| `finger_length` | 50 | µm | SP:5-6; GDS `DIODE_MK` |
| `junction_width` | 3.0 | µm | SP:5-6; GDS |
| `finger_pitch` | 7.02 | µm | GDS `DIODE_MK` y positions |
| `stripe_to_tap` | 1.015 | µm | GDS COMP: window 52.03 x 5.03 around a 50 x 3 stripe |
| `tap_frame_width` | 1.22 | µm | GDS COMP ring |
| `tap_bar_width` | 1.99 | µm | GDS COMP, bars between windows |
| `outer_ring_width` | 2.45 | µm | GDS COMP outer ring |
| `tap_to_outer_ring` | 0.81 | µm | GDS: outer ring hole 9.455 to tap frame 10.265 |
| `nwell_ring_width` (D2 only) | 3.28 | µm | GDS Nwell ring |
| `nwell_size` (D3) | 55.3 x 29.36 | µm | GDS Nwell |
| `implant_enclosure` | 0.16 | µm | GDS Nplus/Pplus 50.32 x 3.32 |
| `dualgate_enclosure` | 0.24 | µm | GDS Dualgate 50.48 x 3.48 |
| `contact_size`, `contact_pitch` | 0.22, 0.5 | µm | GDS Contact |
| `contact_rows`, `contact_cols` | 6, 100 | - | GDS Contact in one stripe |
| `m2_strap_width`, `n_m2_straps` | 2.54, 8 | µm, - | GDS Metal2; LEF 19-51 |
| `m2_strap_x` | 15.34, 21.02, 26.70, 32.38, 40.08, 45.76, 51.44, 57.12 | µm | LEF 19-51 |

**(b) Rail diode (D1; also in `dvdd`, `dvss`)**

| Name | Value | Unit | Source |
| --- | --- | --- | --- |
| `n_fingers`, `finger_length`, `junction_width` | 4, 40, 1.0 | -, µm, µm | SP:4, 635, 663 |
| `finger_pitch` | 4.36 | µm | GDS |
| `tap_frame_width`, `tap_bar_width` | 1.22, 1.99 | µm | GDS COMP |
| `outer_ring_width`, `nwell_ring_width` | 1.95, 2.78 | µm | GDS COMP, Nwell |
| `contact_rows`, `contact_cols`, pitch | 2, 85, 0.47 x 0.64 | -, -, µm | GDS Contact |

**(c) Second-stage network of the digital pads (`comp018green_esd_cdm`)**

| Name | Value | Unit | Source |
| --- | --- | --- | --- |
| `n_res`, `res_width`, `res_length` | 4 (parallel), 2.5, 2.8 | -, µm, µm | SP:497-500, `ppolyf_u` |
| resistance per resistor | 449 (typical model); 432.59 / 449.157 annotated | Ω | [I] run; `FDIO/cdl/gf180mcu_fd_io.cdl:1174-1177` |
| `n_diode`, `diode_length`, `diode_width` | 2 per polarity, 20, 1.0 | -, µm, µm | SP:506-507 |
| layout dimensions of this cell | not extracted | | open |

**(d) Output driver fingers (`drive_select`, `drive_select_24`)**

| Name | `bi_t` | `bi_24t` | Unit | Source |
| --- | --- | --- | --- | --- |
| NMOS device | `nfet_06v0_dss` | same | | SP:437, 234 |
| NMOS `W` per device, count | 38, 8 | 37, 8 | µm, - | SP:437, 443 x 4 instances (381-393); 234, 240 x 4 (68-71) |
| NMOS `L` | 1.15 | 0.8 | µm | SP:437; 234 |
| NMOS `d_sab`, `s_sab` | 3.78, 0.28 | 3.78, 0.28 | µm | SP:438; 235 |
| PMOS device | `pfet_06v0_dss` | same | | SP:448, 245 |
| PMOS `W`, `nf` per device | 80 (nf 1) and 40 (nf 1) | 120 (nf 2) and 60 (nf 1) | µm | SP:448, 452; 245, 249 |
| PMOS `L` | 0.7 | 0.7 | µm | same |
| PMOS `d_sab`, `s_sab` | 2.78, 0.28 | 2.78, 0.28 | µm | SP:449, 453; 246, 250 |
| drawn finger count and guard rings | not extracted; the evampire layout page says 8 NMOS and 12 PMOS fingers | | [U] |

**(e) Rail clamp (`dvdd`, `dvss`, `vdd`, `vss`, `cor`)**

| Name | Value | Unit | Source |
| --- | --- | --- | --- |
| clamp NMOS `W`, `nf`, `L` | 4000, 80, 0.7 | µm, -, µm | SP:645 (`nfet_06v0`, no salicide block parameter) |
| timer resistor | 0.8 x 766.26, `ppolyf_u` | µm | SP:653 |
| timer capacitor | 8 x (25 x 10), `cap_nmos_06v0` | µm | SP:644 |
| inverter 1 (P/N W) | 20 / 5 | µm | SP:640, 647 |
| inverter 2 | 15 / 30 | µm | SP:642, 651 |
| inverter 3 | 120 (nf 2) / 30 | µm | SP:638, 649 |
| layout dimensions | not extracted | | open |

**(f) Decoupling MOS capacitor:** 15 x 15 µm, 36 per analog pad, 4 columns x 9 rows on a 17.18 µm column pitch
(SP:7; GDS `MOS_CAP_MK`).

**(g) Bond pad:** opening 60 x 60 µm at (7.5, 2); metal stack Metal2 to Metal5 under it (GDS; LEF 17-18).

### 12.2 What is fixed, what is free, and which rules limit the free ones

Fixed by the pad cell or the harness (a new cell has to live with them):

- everything inside `asig_5p0`, unless the pad type is changed (question 1);
- the pad pitch, the rail positions and the wrapper pins (12.3);
- the device types: only `diode_nd2ps_06v0`, `diode_pd2nw_06v0`, `nfet_06v0(_dss)`, `pfet_06v0(_dss)`, `ppolyf_u`,
  `cap_nmos_06v0` occur in the library's protection; the library uses no ESD implant and no deep n-well.

Free for a designer's own cell, with the limiting rules. Rule names are those of the KLayout deck
(`TECH/klayout/tech/drc/gf180mcu.drc` loads them from `rule_decks/*.rb`; file and line given); "MV" is the deck's
suffix for 5 V/6 V geometry. Manual-only guidelines are marked **not in the deck**.

| Free dimension | Limiting rules |
| --- | --- |
| diode junction width | `DF.1a_MV` min COMP width 0.3 µm (`comp.rb:44`); manual 14.4.5.1 / .3: at least 0.9 µm, **not in the deck** |
| diode finger length | manual 14.4.5.2 / .4: recommended maximum 25 µm, **not in the deck**; `DF.9` min COMP area (`comp.rb:513`) |
| number of fingers, pitch | `DF.3a_MV` COMP space (`comp.rb:145`); `NP.2` implant space 0.4 µm (`nplus.rb:50`) and the Pplus counterpart in `pplus.rb` |
| implant enclosure of COMP | `NP.5*` (`nplus.rb:148-199`) and the `PP.5*` counterparts |
| thick-oxide marker | `DV.6` Dualgate encloses COMP by 0.24 µm (`dualgate.rb:66`), `DV.5` width 0.7 µm (`:57`), `DV.2` space 0.44 µm (`:42`), `DV.7` no partial overlap (`:74`) |
| n-well around a P+ diode | `DF.4c_MV` n-well overlap of PCOMP 0.6 µm (`comp.rb:296`), `DF.4d_MV` of the n-well tap 0.16 µm (`:337`), `NW.2b_MV` n-well space at different potential 1.7 µm (`nwell.rb:96`) |
| tap and guard ring width and distance | `DF.1a_MV`; manual `IO.1` to `IO.4`: guard ring within 15 µm, at least 2 µm wide, **not in the deck** |
| contacts | `CO.1` size 0.22 µm (`contact.rb:25`), `CO.2a` space 0.25 µm (`:32`), `CO.2b` 0.28 µm in arrays of 4 x 4 or more (`:55`), `CO.4` COMP overlap 0.07 µm (`:81`), `CO.6` Metal1 overlap (`:125`) |
| series poly resistor (`ppolyf_u`) | `PRES.1` width 0.8 µm (`pres.rb:35`), `PRES.2` to `PRES.7` (`:41-81`), `SB.*` (`sab.rb:39-176`); for the 1 kΩ/sq resistor `HRES.1` to `HRES.10` (`hres.rb:38-123`) |
| ESD-style NMOS (salicide-blocked drain) | `SB.1` to `SB.16`; `SB.16`: salicide block only on FETs marked `LVS_IO`, `OTP_MK` or `ESD_MK` (`sab.rb:170-176`); manual `HVNESD.*`: L at least 0.8 µm, finger width 20 to 60 µm, total width 200 to 720 µm, at most 18 fingers per tap ring, drain contact to gate 1 to 4 µm, **not in the deck** |
| ESD-style PMOS | manual `HVPESD.*`: L at least 0.7 µm, finger width 20 to 60 µm, total 300 to 720 µm, at most 24 fingers per ring, drain contact to gate 1 to 4 µm, **not in the deck** |
| ESD implant (if ever used) | `ESD.1` to `ESD.10`, `ESD.pl` (`esd.rb:34-124`); the pad library does not use this layer |
| metal straps | `M<n>.1`, `M<n>.2a`, `M<n>.2b` (`metal.rb:37-60`); current limits not looked up |
| deep n-well (if used for isolation) | `DN.1` to `DN.3` (`dnwell.rb:32-55`), `LPW.*` (`lvpwell.rb`), `DF.18`, `DF.19_MV` (`comp.rb:768, 804`) |

The library's own cells measured against the manual's guidelines **[V]** for the numbers, **[I]** for the reading:
the pad diodes exceed the recommended finger length (50 against 25 µm); the `bi_t` NMOS is inside every `HVNESD`
range quoted above (L 1.15, W 38, total 304; `d_sab` 3.78, if the salicide block length is taken as the drain
contact-to-gate spacing, which is an approximation); the `bi_t` PMOS netlist has single devices of 80 µm with
`nf=1`, above the 60 µm maximum finger width, unless the layout splits them (not checked). So even the foundry's
cells do not follow every guideline, and "meets the guideline" is not a criterion a generator can enforce blindly.

### 12.3 Anchors a cell would have to match

| Anchor | Value | Source |
| --- | --- | --- |
| pad cell size | 75 x 350 µm, `SITE GF_IO_Site`, symmetry `X Y R90` | `IO/lef/gf180mcu_ocd_io.lef:9-11` |
| pad pitch, slot 16 side | 170 µm (75 pad + 95 spacer) | `B:scripts/gen_padframe.tcl:13-15`; `B:magic/gf180mcu_padframe.mag:1257, 1261` |
| bond pad | opening 60 x 60 at (7.5, 2) to (67.5, 62) | LEF 17-18; GDS `Pad` |
| ESD structure relative to the bond pad | P+ diodes 11.4 µm above the pad opening (y 73.4), N+ diodes from y 110.4, rail diode from y 147.5, capacitors from y 171.8; everything between the bond pad and the core edge, inside the 75 µm width | GDS (section 4.2) |
| core-side signal terminal | Metal2, eight ports 2.54 µm wide at the cell's top edge (y 350), x as in 12.1(a) | LEF 19-51 |
| supply rails | 26 horizontal rails on Metal3, Metal4, Metal5; y positions in section 4.3 | LEF 53-276; GDS of `fill5` |
| core-domain rails in the pad row | VSS y 246-253 and 318-325, VDD y 254-261 and 310-317 | LEF 237-276 |
| slot wrapper | 1274.27 x 412.71 µm | `B:magic/slot16_wrapper.mag:189` |
| slot analog pins | Metal3, west edge, x 1.24-3.24; y 272.70-317.02 (`s16_an[0]`), 102.70-147.02 (`s16_an[1]`) | same file, lines 184, 186 |
| slot supply pins | Metal5, east edge (x 1271.94-1274.25): `vdd_3v3` y 50.6-96.2, `vss_3v3` y 113.4-143.4, `vdd_5v0` y 251.1-353.0, `vss_5v0` y 369.0-399.0 | same file, lines 84-90 |
| slot bias and bus pins | Metal3, east edge, y 177-206 | same file, lines 92-104 |

A cell of this project sits **inside the slot wrapper, not in the pad row**. That differs from the IHP design, whose
pad macros were pad-row cells (12.4). The anchors that bind it are therefore the wrapper pins; the pad-row anchors
matter only if the user negotiates a custom pad with the harness maintainer.

### 12.4 How the IHP cells in D are parametrized, and what carries over

From a subagent's survey of D; I checked the quoted lines of `clamp_base_code.py`, `clamp_engine.py`, the README and
the skill file myself (journal entry 15). Branch `claude/c3-s2d-pad-layout` at `c913388` unless stated; `main` has no
`scripts/pcells`.

- **Language and tool.** KLayout PyCells in IHP's own style: `class <name>(DloGen)` with `defineParamSpecs`,
  `setupParams`, `genLayout`, against IHP's `cni` API. **[V]** `D:claude/c3-s2d-pad-layout:scripts/pcells/clamp_base_code.py:20-22, 38-54`.
- **Structure.** All geometry is in one pure-Python engine in integer nanometres on a 5 nm grid, with no KLayout
  import; the PyCell wrapper, a batch generator and the verifier share it. **[V]** `...:scripts/pcells/clamp_engine.py:19-21`.
- **Cells and parameters.** **[V]** `clamp_base_code.py`:
  - `Clamp_N`, `Clamp_P` (lines 49-54): `ng` (gate fingers, default 8) and `tie` (`D` or `0D`); `ng` is the only
    geometric parameter.
  - `Clamp_N_M1`, `Clamp_P_M1` (105-114): `ng`, `l` (gate length, default `0.6u`), `frame` (`fit` or `80u`), `Lmin`,
    `wiring` (`internal` or `external`).
  - `Clamp_*_M1_wiring` (155-161): `ng`, `l`, `frame`, `roles` (e.g. `'21:rep 20:dummy'`) and net names.
  - `DCNDiode`, `DCPDiode` (196-197): `l` (stripe length, default `27.78u`); the width 1.26 µm is fixed.
- **Where the dimensions come from.** "Per-family rules, measured from the reference layouts": constants in the
  engine, not looked up in a rule file. **[V]** `clamp_engine.py:39-49, 385-389`. The only technology lookup is the
  minimum gate length. The frame and the hand-drawn tie block of the IHP clamps are stored geometry extracted from
  IHP's GDS (`clamp_refdata.py`, made by `extract_clamp_refdata.py`).
- **Checks.** **[V]** `scripts/pcells/README.md:273-292, 318-327` (recorded results, not rerun by me):
  XOR against all 8 IHP reference cells, empty on every drawing and pin layer; a sweep over every legal `ng`; the
  IHP DRC deck with a negative control (an injected error must be flagged); a light connectivity check with
  `klayout.db.LayoutToNetlist`; bad parameters must give an empty cell. No Makefile target runs any of this.
  Stated as not verified there: PDK LVS of the PCells and "ESD adequacy of the ring spacing and `l` choices".
- **The method as written down:** `D:claude/c3-s2d-pad-layout-sudel:Claude/skills/ihp-flat-cell-to-pcell/SKILL.md:18-45`
  (analyse, decompose into rule array / extracted frame / hand block, pure-Python engine, verify by XOR, sweep, DRC,
  extraction).
- **Pad level.** The pad wiring was not parametric: literal-coordinate scripts and drawn cells
  (`macros/sg13cmos5l_IOPadSingle2Diff/layout/klayout/template/build_template.py`; subagent report).

What carries over to GF180 **[I]**:

- the engine/wrapper split, integer-nanometre geometry, and the test set (XOR against a foundry reference, sweep,
  DRC with a negative control, extraction);
- the decomposition "periodic rule part + extracted frame": `comp018green_esd_hbm` is a clean candidate, because it
  is strictly periodic (section 4.2) and its numbers are in 12.1(a). A generator that reproduces it at
  `n_fingers = 4`, `finger_length = 50`, `junction_width = 3` can be XOR-checked against the foundry cell;
- the `roles`/wiring-cell idea for an output stage with replica fingers.

What does not carry over:

- the `cni`/`DloGen`/`SG13_dev` wrapper (IHP's library); on GF180 the PDK's KLayout PyCells need `gdsfactory` in
  KLayout's Python, which the cloud setup does not install (`tatzelbrumm/claude-cloud-config`, `main` at `39d01fc`,
  `parts/pdk-gf180mcuD.sh:117-119`). A plain `pya.PCellDeclarationHelper` wrapper, or batch generation
  through the engine alone, avoids that;
- every constant, layer number and frame geometry;
- the cell's place: IHP pad-row cells against a GF180 cell inside the slot;
- the reference set: IHP ships clamp cells in several sizes to interpolate between; `gf180mcu_ocd_io` has one diode
  cell, one second-stage cell, two output-driver sizes and one clamp;
- the rule check: on IHP the DRC deck was the judge. On GF180 the deck does not contain the ESD guidelines (7.1), so
  a clean DRC says nothing about them; they would have to be coded as assertions in the generator.

### 12.5 What cannot be parametrized safely without silicon or foundry data

- **Diode stripe length and width as free ESD parameters.** The only measured point is 0.9 x 25 µm, four fingers.
  Scaling the failure current with length, width or finger count is a guess (7.4).
- **Anything that relies on snapback:** gate length, drain contact-to-gate spacing (`d_sab`), finger width and finger
  count of a transistor meant to conduct ESD current. The manual's numbers are for one test transistor without the
  ESD implant.
- **The second-stage sizes** beyond the datasheet's "larger than 25 µm, larger than 50": no level is attached to
  them.
- **Guard ring spacing for latch-up** beyond the `IO.1` to `IO.4` numbers.
- **Metal strap widths for ESD current:** no pulse-current limit for the metals was found in the files I read.
- **Clamp device and timer sizes.**

What a parametric cell can do safely: reproduce the foundry geometries exactly at their nominal parameter values,
generate other sizes that pass DRC and the coded guidelines, and print for each instance how far it is from the
measured test structure, so that the judgement stays with the designer.

## 13. What I did, and what I could not check

Work journal (numbered entries cited above): branch `sudel_buecher`,
`sudelbuecher/logs/pad_esd_exploration/2026-11-26_fable_pad_structures_log.md`; scripts under `tools/` next to it.

Steps beyond the brief's list of sources, stated here so they are not implicit:

- I cloned `google/gf180mcu-pdk` (foundry manual) and `RTimothyEdwards/gf180mcu_ocd_io` (source of the pad library),
  both public, read-only. Reason: the installed PDK has no ESD data, and the brief's question 4 could not be
  answered from it.
- The manual site `gf180mcu-pdk.readthedocs.io` was refused by the network policy; the user offered to allow it and
  approved adding that one host to the environment `gf180mcuD` during the session. I then fetched eleven pages from it.
- I ran one ngspice deck (diode DC and AC evaluation). It designs nothing.

Not checked:

- no layout extraction and no LVS of any pad cell; netlist against layout was compared by device counts and sizes
  for `asig_5p0` only;
- no ESD simulation, no clamp simulation;
- layout dimensions of the second-stage cell, the output drivers and the clamp;
- metal sheet resistances, current limits, the rail resistance to the clamps, the routing from pad to slot;
- the manual's electrical-parameter sections (gate oxide and junction breakdown);
- the evampire source repository, and seven of its sibling pages; the Wikipedia article was fetched for
  availability only and is not used as a source;
- the upstream harness repository `RTimothyEdwards/gf180mcu_ocd_chipalooza` (only the fork was read);
- whether `2f18cd4` is still the head of the fork's `main` after today.

## 14. KLayout support: the PDK as a whole, and the pads in it (added later on 2026-11-26)

Question from the user: if the pads and their characterization or extraction exist only in Magic, a KLayout version
homologous to the IHP library would be welcome, but not as a special case if the whole GF180 PDK supports KLayout
weakly. So this section first measures the PDK's KLayout support, then the pads inside it. Everything was run in
this session with KLayout 0.30.12 and the PDK's own decks, unmodified; logs and scripts in `LOG/` (journal entry 18).

### 14.1 What the PDK ships for KLayout

**[V]** `TECH/klayout/tech/`:

| Part | Content | Works here? |
| --- | --- | --- |
| technology | `gf180mcu.lyt`, `gf180mcu.lyp` (119 layers), `gf180mcu.map` | yes |
| DRC | `drc/gf180mcu.drc` + 41 rule decks; 777 rules executed per run | yes, out of the box |
| LVS | `lvs/gf180mcu.lvs` + 26 rule decks, `lvs/run_lvs.py`, `lvs/gf180_xschem_klayout_spice_convert.py` | the deck runs; `run_lvs.py` does not start (`No module named 'docopt'`, `run_lvs.py:49`; `pip install docopt` fails to build under Python 3.13). I called the deck directly with the same switches |
| device PCells, KLayout API | `pymacros/klayout_api_cells/`: 31 PCells (FETs, diodes, MOS and MiM capacitors, resistors, BJTs, efuse) | loads only when the environment variable `USER` is set (`draw_efuse.py:18`); it is not set in the cloud container |
| device PCells, gdsfactory | `pymacros/cells/` | not here: `No module named 'gdsfactory'` (`pymacros/gf180mcu.lym:40-49` catches that and continues) |
| seal ring PCell | `pymacros/sealring_cells/` | yes |
| fill, slots | `scripts/fill_*.rb`, `scripts/slots.drc` | not tried |
| parasitic extraction | not in the PDK; the installed `klayout-pex` 0.6.8 ships its own `gf180mcuD` definition | runs (14.3) |

Compared with IHP's KLayout tree (**[V]** `D:sudel_buecher:sudelbuecher/IHP_pcell_structure_visualization/ihp_sg13cmos5l_klayout_tree.txt`,
a listing made on 2026-09-28): IHP registers, besides devices, PCells for `esd`, `bondpad`, `ptap1`/`ntap1` (taps),
`guard_ring`, `via_stack`, `NoFillerStack`, `sealring` (lines 85-118 of that listing). GF180 has devices and the seal ring only: **no ESD, bond pad,
tap/guard-ring or via-stack PCell**. Neither PDK has parametric pad cells; on IHP those were written in the
project (section 12.4).

### 14.2 The pad cells through the PDK's KLayout decks

Each pad cell was copied with its sub-cells into its own GDS file and run alone.

**DRC** (`LOG/2026-11-26_fable_klayout_drc_pads.out`): **[V]**

| Cells | Result |
| --- | --- |
| `asig_5p0`, `dvdd`, `dvss`, `vdd`, `vss`, `fill10` | 0 violations |
| `bi_t`, `bi_a`, `bi_24t`, `in_c`, `in_s`, `fill5` | 1 violation: `PL.8`, "Poly2 coverage over the entire die" (`drc/rule_decks/density.rb:65`), a whole-die rule applied to one cell |
| `fill1`, `brk2`, `brk5` | 2 to 5 violations, all coverage rules of the same kind (`PL.8`, `M2.4` to `M5.4`, `MT.3`, `DCF.1b`) |
| `fillnc` (0.1 µm wide) | 89: the same coverage rules plus minimum-width rules that a 0.1 µm sliver cannot meet alone |
| `cor` | 2 violations: `DCF.1a`, `M2.4`, again coverage rules |

The coverage rules are whole-die rules (`drc/rule_decks/density.rb:25-161`: "coverage over the entire die", "global
density"). So KLayout DRC works on the pads, and apart from those rules, which do not apply to a single cell, the
pads are clean; `fillnc` alone is too narrow to be checked outside a row.

**LVS** (`LOG/2026-11-26_fable_klayout_lvs_pads.out`): **[V]** **no pad cell matches**, for three separate reasons.

1. **Netlist dialect.** The library's netlist is xschem output (`XC1 ... cap_nmos_06v0 c_width=... c_length=...`,
   `area=`/`pj=` on diodes); KLayout reads it as an unknown subcircuit. The PDK's converter fixes that
   (`CC1 ... W= L=`, `A=`/`P=`); its header calls itself "a stopgap measure" (`lvs/gf180_xschem_klayout_spice_convert.py:25`).
   All further results use the converted netlist.
2. **N+ diodes in the substrate are not extracted.** The deck takes the anode of `diode_nd2ps_*` from a drawn
   LVPWELL (`lvs/rule_decks/diode_extraction.lvs:68-71`, `general_derivations.lvs:42`). The pads' N+ diodes sit in
   bare substrate with no LVPWELL drawn, so D1 and D2 of `asig_5p0` (8 of its 12 diode stripes) are missing from the
   extracted netlist; so is the rail diode of every supply pad and the N+ diode of every digital pad.
   - Check: on a scratch copy of `asig_5p0` with an LVPWELL rectangle drawn over the two N+ diode blocks, the
     same deck extracts all four device groups and reports "Netlists match". (An experiment to prove the cause;
     that copy is not a proposed layout.)
   - **The foundry library has the same problem**: `gf180mcu_fd_io__asig_5p0` with its own CDL also extracts only
     the P+ diode and the capacitor, and fails.
3. **The salicide-block FETs are not recognised in `gf180mcu_ocd_io`.** The deck recognises `*_dss` devices by
   `ESD_MK` and `SAB` and `LVS_Source` together (`lvs/rule_decks/mos_sab_derivations.lvs:45, 74`). The foundry GDS
   has `LVS_Source` (100/8) and `LVS_IO` (119/5), and its `bi_t` extracts 8 + 8 `*_dss` devices. **The
   `gf180mcu_ocd_io` GDS has neither layer** (section 2), and its `bi_t`, `bi_24t`, `in_c` extract none.
   That is a loss in the pad library's GDS, not a fault of the deck.

Further differences seen: `fill5` and `fill10` extract a MOS capacitor that their netlists do not contain
(the note in section 2); in `bi_t` and its relatives every other device class is found with the schematic's count
(79 + 79 six-volt FETs, 31 + 31 three-volt FETs, the P+ diodes); `in_c` extracts 28 of 31 `pfet_03v3`.
I did not chase these.

The harness itself says: "LVS with klayout has not been attempted". **[V]** `B:README:462-464`.

### 14.3 Parasitic extraction with KLayout

`kpex --pdk gf180mcuD --2.5D` on `asig_5p0` ran to the end and wrote a netlist (capacitances only). **[I]** as to
accuracy: the engine is a 2.5D estimate, and it warned that it left out `isosub` and about a fifth of the contacts.
Wiring capacitance of the pad net: 0.54 pF to DVDD, 0.38 pF to DVSS, 0.17 pF to substrate, 0.05 pF to VDD and VSS;
about 1.15 pF in total. With the junction capacitance of section 9.2 the pad cell loads the signal with roughly
2 pF, package and routing not included. (`LOG/2026-11-26_fable_kpex_asig.out`.)
The statement in this repository's `Makefile` and port map that KPEX has "no verified GF180 support" is now out
of date in one respect: the tool ships a `gf180mcuD` definition and runs. Whether its numbers are right is still
unverified.

### 14.4 Verdict

The PDK's KLayout support is **uneven, not weak across the board**:

- strong: technology files and DRC (complete, runs untouched, pads clean);
- usable with small environment fixes: device PCells, parasitic extraction;
- **weak exactly where pads and ESD need it**: LVS cannot pass the foundry's own analog pad (substrate diodes),
  the open pad library has lost two LVS marker layers, the netlists need a stopgap converter, and there is no
  ESD, guard-ring, bond-pad or via-stack PCell.

A "KLayout version of the pads" that is honest therefore cannot be made inside this project alone: either the
PDK's LVS deck and the pad library's GDS are corrected (PDK-wide work, upstream), or the pads get a private
patched deck and a private patched GDS, which is the special case the user asked me not to invent. **I stopped
here and ask** (section 11, question 9). Nothing was built.

What "upgrading KLayout support for the PDK" would consist of, as far as this session can tell:

| Item | Where it belongs | Size |
| --- | --- | --- |
| LVS: accept the substrate as anode of `diode_nd2ps_*` when no LVPWELL is drawn | the PDK's KLayout LVS deck (upstream of open_pdks) | small change, needs the deck's regression tests |
| restore `LVS_Source`, `LVS_IO` (and `Latchup_MK` on the analog pad) in `gf180mcu_ocd_io` | the pad library (upstream), or its GDS export from Magic | small, but touches a shared library |
| KLayout-readable netlists (CDL) for `gf180mcu_ocd_io`; fill-cell capacitors in the netlists | the pad library | small |
| PCells homologous to IHP's: ESD diode array, tap and guard ring, via stack, bond pad | new library next to the PDK's device PCells, built by the method of section 12.4 and XOR-checked against the pad cells | the real work; the diode array is the natural first cell |
| environment: `docopt` (or a runner without it), `USER`, optionally `gdsfactory` | `claude-cloud-config` | trivial |
| KLayout PEX: compare against Magic extraction on a pad | this project or the harness | medium |

## 15. ESD information from other public sources (added later on 2026-11-26)

Request from the user: where ESD information is missing, look in other available sources that are not trade
secrets. A search subagent ran 42 web searches and GitHub issue searches and read eight public repositories; its
full report is filed verbatim as `LOG/2026-11-26_fable_subagent_report_3_public_gf180_esd_sources_search.md`. I then
opened the sources I could reach and re-read the claims that matter. Marks in this section:

- **[V]** I opened the file or page myself (path and line given);
- **[U-sub]** read by the subagent, not re-opened by me;
- **[U-lead]** the subagent saw it only in a search-engine summary: a lead, not a citable value.

During the search the cloud environment's network policy refused most literature hosts, so its findings from
standards and papers were leads only. Later the user allowed `www.esda.org`, `esdindustrycouncil.org`, `www.jedec.org`
and `ieeexplore.ieee.org`; section 15.4 was then rewritten from the documents themselves. Papers behind IEEE Xplore
and other publishers (ScienceDirect, arXiv, archive.org were not allowed) are still leads.

### 15.1 The main result: nobody has published a measurement

- **No measured ESD result (HBM, CDM, MM, TLP, latch-up) was found for any chip built with `gf180mcu_fd_io` or
  `gf180mcu_ocd_io`**: not for Caravel on GF180, the GFMPW shuttles, the wafer.space runs, Tiny Tapeout on GF180,
  university chips, or Chipalooza. Nor any statement that the pads were, or were not, ESD-tested; nor any report of
  an ESD or latch-up failure on such a chip. **[U-sub]** (a negative result of searches; the query list is in the filed
  report).
- The wafer.space project template lists both pad libraries as "silicon-verified" and says above the tables: "Not
  all of the community-created IPs have been tested yet, so support for them is experimental!" It does not say what
  "silicon-verified" covers; ESD is not mentioned. **[V]** `raw.githubusercontent.com/wafer-space/gf180mcu-project-template/main/README.md`,
  lines 112, 128-129 (fetched 2026-11-26).
- So the only silicon data remains the design manual's test structures (section 7.2), and section 7.6 stands.

### 15.2 Foundry limits that were not in section 7 (all in the public documentation of the PDK)

All **[V]** in `google/gf180mcu-pdk` at `de3240d`, folder `docs/`. These are specification limits, kind "foundry
target", not ESD data; they bound what the design may see in normal operation and give the only public voltage
ceilings for the devices behind the pad.

| Quantity | Value | File |
| --- | --- | --- |
| gate oxide breakdown, 6 V gate | limit 12 V, typical 16 V (N and P) | `analog/spice/elec_specs/tables_clear/5_General_Specification4.csv:5-6` |
| gate oxide breakdown, 3.3 V gate | limit 7 V, typical 9 V (N), 8.8 V (P) | same file, lines 3-4 |
| junction breakdown, 6 V devices | N+/P-: minimum 8.5 V, typical 11 V; P+/N-: limit 8.5 V, typical 10.5 V | `.../5_General_Specification5.csv:5-6` |
| junction breakdown, 3.3 V devices | N+/P-: minimum 7 V, typical 11 V; P+/N-: limit 6.5 V, typical 10.5 V | same file, lines 3-4 |
| n-well to substrate breakdown | minimum 10 V, typical 14 V | same file, line 7 |
| gate oxide capacitance | 3.3 V: 3.4 / 4.4 / 5.4 fF/µm²; 6 V: 1.8 / 2.3 / 2.8 fF/µm² | `.../5_General_Specification3.csv:3-6` |
| oxide thickness in the models | 8.0 nm (`nfet_03v3`), 15.2 nm (`nfet_06v0`), 15.6 nm (`pfet_06v0`) | `TECH/ngspice/sm141064.ngspice:894, 37309, 38255` |
| maximum DC gate voltage | "3.63V (for thin oxide), 6.5V/6V for 5V/6V process thick gate"; supply overshoot tolerance 10 % | `physical_verification/design_manual/drm_14_1.rst:14, 51` |
| metal line current, DC | Metal1 to the metal below the top: 2.09 / 1 / 0.67 mA/µm at 85 / 110 / 125 °C (unidirectional); top metal 11 kÅ: 4.5 / 2.2 / 1.5 mA/µm | `physical_verification/design_manual/tables_clear/54_Electro-migration1_150.csv:4-5, 13-14` |
| contact and via current, DC | COMP contact and Via1 to Via5: 0.58 / 0.28 / 0.18 mA each; Poly2 contact 0.43 / 0.21 / 0.14 mA | `.../54_Electro-migration2_151.csv:4-12` |
| poly resistor current | 1 mA per µm of width | `.../33_ANALOG_DEVICE1_80.csv:9` (PRES.8), `.../16_Poly2_42.csv:29` (PL.10) |
| ESD implant | "ESD is optional mask to provide ESD implant for 3.3V or 5V/6V devices" | `physical_verification/design_manual/drm_04_1.rst:14`; rule ESD.9 restricts it to 5 V/6 V devices (section 7.1) |

And from the pad library's datasheet: the analog pad is a "5V WR analogue signal pad with double diode protection
(DC current carrying capability 10mA)"; `dvdd` and `dvss` carry 60 mA. **[V]** `OCD:docs/specs/02_Cell_List.csv:18-23`.

What follows from these **[I]**:

- **The analog pad has a DC rating: 10 mA.** That is the first hard number for "output drive" (section 9). The pad
  net's 20.32 µm of Metal2 would allow about 20 mA at 110 °C by the line table, so the datasheet figure is the
  tighter one; which element sets it was not found.
- **Voltage ceilings at the first device behind the pad:** 12 V for a 6 V gate and 7 V for a 3.3 V gate are DC
  specification limits. Oxide survives more for nanoseconds, but no pulsed data for this process is public, so
  these are the only citable numbers, and they are conservative. A 3.3 V gate directly behind the pad has little
  room: the pad diode to DVDD = 5 V lets the pad reach roughly 6 V before it conducts hard.
- **The data set "without ESD implant" is the applicable one.** The manual's 5 V/6 V transistor tables are headed
  "without ESD implant" (section 7.2), and neither pad library draws the implant layer 24/0 (section 2). Whether
  the shuttle's mask set includes the implant was not found. **Open.**
- **The line and contact limits are lifetime limits for DC, not pulse limits.** No pulse-current limit for metal
  is given anywhere in the PDK documentation. **[U-sub]** (the subagent read chapter 14.2; I read only the tables).
- **A CDM series resistor carries no DC in an input**, so the 1 mA/µm poly limit matters only where a resistor is in
  an output path.

### 15.3 The foundry's own second stage as the public worked example

Already in section 5.1, restated here because it is the best concrete sizing example that is public **[V]**
(`IO/spice/gf180mcu_ocd_io.spice:497-507`, `FDIO/cdl/gf180mcu_fd_io.cdl:1174-1177`):

- resistor: four poly resistors of 2.5 µm x 2.8 µm in parallel, about 110 Ω, 10 µm of total poly width;
- diodes behind it: 2 x (20 µm x 1 µm) per polarity, i.e. 84 µm of perimeter per polarity;
- what it protects: 6 V gates of the input buffer (`pfet_06v0` 3.8 and 4.3 µm, `nfet_06v0` 10.6 and 12 µm wide,
  `IO/spice/gf180mcu_ocd_io.spice:97-113`).

Measured against the datasheet's own minimum for a user-added network (resistor above 50 Ω, diode perimeter above
25 µm, section 4.4), the foundry used about twice the resistance and more than three times the perimeter. **[I]**
Copying this network is the most defensible public starting point; this project's proof-of-concept front end
(about 200 Ω, 28 µm perimeter, section 9.1) has more resistance and a third of the diode.

A discrepancy to know: the commit that added `bi_a` describes its analog tap as going "through the 75 ohm ESD
resistor" and says "The signal line is narrow and it is not intended for high current capacity". **[V]**
`OCD:` commit `a2c433c` (2025-11-24). The netlist gives about 110 Ω (449 Ω per resistor in my model run).

### 15.4 Target levels, discharge currents, time scales and the secondary network (standards bodies)

Rewritten after the user allowed four more hosts later in the session. Read by me, all **[V]** with the page of the
PDF or the web page:

- **WP1** = Industry Council on ESD Target Levels, White Paper 1, "A Case for Lowering Component Level HBM/MM ESD
  Specifications and Requirements", revision 4.0, June 2018 (63 pages; linked from
  `esdindustrycouncil.org/ic/en/index.php/documents/white-paper-1-a-case-for-lowering-component-level-hbm-mm-esd`).
- **WP2** = the same council's White Paper 2, "A Case for Lowering Component Level CDM ESD Specifications and
  Requirements", revision 3.0, May 2021 (173 pages; linked from `.../documents/white-paper-2-a-case-for-lowering-component-level-cdm-esd-sp`).
  JEDEC publishes these two papers as JEP155 and JEP157.
- **ESDA-5** = EOS/ESD Association, "ESD Fundamentals, Part 5: Device Sensitivity and Testing"
  (`www.esda.org/esd-overview/esd-fundamentals/part-5-device-sensitivity-and-testing/`).

| Topic | What the source says | Where |
| --- | --- | --- |
| HBM test circuit | "a 100 pF capacitor" discharged through "a 1.5 kW (1,500 ohms) series resistor" (the page prints the ohm sign as W) | ESDA-5 |
| HBM waveform | "a rise time of 2–10 ns, a peak current of 0.67 amps/kilovolts, and a double-exponential decay with a width of 200 ns" | ESDA-5 |
| HBM and MM peak currents | "the peak current into a short is 1.3 A for a 2 kV HBM discharge and 3.8 A for a 200 V MM discharge" | WP1 p. 56 |
| recommended HBM level | "we have recommended a component HBM qualification shift from 2 kV to 1 kV"; table: 2 kV and 1 kV "Basic ESD Control methods allow safe manufacturing with proven margin"; "Basic ESD controls ensure that devices with a HBM robustness of at least 500 V can be handled safely" | WP1 pp. 52, 7, 12 |
| machine model | "MM testing is redundant to HBM and produces the same failure mechanisms"; "MM qualification testing is not a required component level qualification test per JEDEC" | WP1 pp. 2, 4 |
| CDM event | "often less than one nanosecond – the peak current can reach several tens of amperes"; tested per JS-002 | ESDA-5 |
| recommended CDM level | "we recommend a CDM specification target level of 250 volts"; at 200 V and above basic ESD control methods suffice, below 200 V process-specific measures are needed | WP2 pp. 2, 10 |
| CDM current a design can take | "practical designs are restricted to 2-6 amperes of peak CDM current, which translates to a CDM target level of 125-400 volts for many advanced technology products (depending on pin-count)"; small BGA packages: "not more than 3-4 amperes at 500 volts" | WP2 pp. 8, 43 |
| CDM rise time | "From less than 100 ps to a few ns" | WP2 p. 147 |
| **the architecture GF uses, described** | "Dual Diode ESD Protection": primary diodes D1, D2 at the pad, a power clamp between the buses, and "primary and secondary ESD protection elements ... to protect receiver transistors ... and driver transistors"; "it is important to minimize the total voltage drop between the I/O pad and GND bus local to the stressed I/O pad"; "it is common for multiple power clamps to be distributed in parallel along the power buses" | WP2 p. 34 |
| **receiver resistor** | "any IR drop across R1 will reduce the voltage stress seen across the fragile gates ... R1 values from 100-5000 Ω are common for protecting receiver circuits" | WP2 p. 35 |
| **driver resistor** | a second path "via resistor R2 and the drain to N-well parasitic diode of PMOS transistor"; R2 is optional because some applications "do not typically permit the use of any series resistance between the driver and pad"; "Typical R2 values for digital applications can range from 5-100 Ω. This resistance can have a significant impact on the effective CDM robustness of driver transistors" | WP2 p. 35 |

What this gives the project **[I]**:

- **A defensible target to name** (question 3 of section 11): 1 kV HBM and 250 V CDM are the levels the industry
  council recommends for qualification; the datasheet's 2 kV / 500 V are the older customary values, and its 200 V
  machine-model target refers to a test the same bodies no longer require.
- **Currents to size for:** about 0.67 A at 1 kV HBM (1.3 A at 2 kV) for some hundred nanoseconds; a few amperes for
  about a nanosecond for CDM. For CDM the charge sits on the die and package, so the current does not have to enter
  through the pad's metal from outside; the white paper's point is the voltage drop along diode, bus and clamp.
- **Input (`vin`):** the datasheet's "more than 50 Ω" is below the 100 to 5000 Ω the white paper calls common for
  receivers; the foundry's own 110 Ω (section 15.3) is at the low end of that range, and the proof of concept's
  200 Ω is inside it.
- **Output (`vout`):** published practice for drivers is an optional series resistor of 5 to 100 Ω between driver and
  pad, with the driver's own drain diodes as the second path. That is a third option next to the two of question 4
  in section 11, and it costs output swing: at the pad's 10 mA DC rating, 0.05 V to 1 V.
- **The primary path of section 5.2 is the textbook one**, and the textbook's condition (low voltage drop from the
  pad along the buses to a nearby clamp, several clamps along the ring) is what section 6.2 could not confirm for the
  slot 16 pads: the nearest ring clamp is three and four pad positions away, and the rail resistance is not known.

Still not opened, although the hosts are now allowed:

- **IEEE Xplore** answers a plain request for an abstract page with HTTP 202 and an empty body, and the session's
  page-fetch tool could not resolve the host. A request shaped to look like a browser was refused by the session's
  permission check, and I did not try further. So the papers on pulsed current limits of metal lines (Banerjee,
  Amerasekera et al. 1996 and 1997; Voldman et al. 1998), on gate oxide under ESD pulses (Ille et al.) and the
  GlobalFoundries 180 nm high-voltage paper (IRPS 2015) remain **[U-lead]**.
- **`www.jedec.org`** answers 403 to a plain request. Not needed for the two white papers, which the council hosts.
- The standards JS-001 and JS-002 themselves were not opened; the waveform numbers above come from the ESD
  Association's own summary page.
- White Paper 2 shows oxide breakdown under 1.2 ns pulses and metal current limits only as trend figures over
  technology nodes (pp. 36-37), without numbers I could read from the text. Pulsed limits for this process remain
  unknown (section 15.8).

### 15.5 How two other open PDKs document the same things (method comparison)

- **SkyWater sky130 I/O** **[V]** `raw.githubusercontent.com/google/skywater-pdk-libs-sky130_fd_io/main/docs/user_guide.rst`
  (fetched 2026-11-26): the analog taps `pad_a_esd_0_h` and `pad_a_esd_1_h` are "connected to the pad through a 150 ohm
  ESD resistor" (line 464); "The HV and LV RC ESD clamps are robust up to 3.3KV HBM" (line 1301); clamp with a "2us
  time constant" and "Driver width of 2880 um" (lines 1305-1307); "scheduling a preliminary ESD review is
  recommended before routing is started" (line 2049). So a second foundry's library puts 150 Ω in front of its
  protected analog tap, where GF's digital pads use about 110 Ω; and its clamp has the same time constant class as
  the GF clamp (section 5.1) with a smaller transistor (2880 µm against 4000 µm).
- **IHP SG13G2** **[U-sub]**: the ESD device named `diodevdd_2kv` has a perimeter of 58.08 µm (model file); the
  analog pad's secondary stage extracts as a 1 µm x 2 µm poly resistor with diodes of 7.5 µm and 11.2 µm perimeter
  (IHP-Open-PDK issue 1218); an open issue (1247) notes that the IHP I/O libraries have no clamp between core VDD
  and VSS and names 1 to 2 Ω as the target for a shared-rail ESD path; no measured ESD result is in the IHP tracker
  either. For scale **[I]**: the GF analog pad's diodes have 424 µm of perimeter per polarity, about seven times
  the IHP "2 kV" diode, which supports the reading that the pad diodes themselves are generously sized and that the
  open points are the clamp path, the metal and the voltage at the protected device.

### 15.6 Process lineage: a correction to an assumption

I had told the search that GF180MCU "descends from Chartered's 0.18 µm process". That is not established. The PDK
names the process "FAB3E 0.18UM 3.3V/6V High Voltage CMOS Technology" **[V]**
(`google/gf180mcu-pdk:docs/analog/layout/inter_specs/inter_specs.rst:10`); Fab 3E is the Tampines, Singapore fab
("produces 180 nm wafers"; sold to Vanguard in 2019) **[V]** Wikipedia, "GlobalFoundries" (fetched 2026-11-26).
According to the search, Chartered acquired that fab from Hitachi in 2008 **[U-lead]**. Older Chartered papers on
0.18 µm ESD therefore cannot be assumed to describe this process, and the search found no paper that clearly does.

### 15.7 Other things the search turned up

- **The pad library's GDS is written by Magic**, and its marker layers are generated there: commit `2fa4cdc`
  (2025-11-27) lists "Added required latchup and ESD marker layers on output" and Nplus/Pplus width fixes in "the
  magic cifoutput section". **[V]** `OCD:` history. That is the likely origin of the missing `LVS_Source` and `LVS_IO`
  layers of section 14.2 **[I]**.
- **An upstream issue about the substrate-diode gap is said to exist**: `fossi-foundation/globalfoundries-pdk-libs-gf180mcu_fd_pv`
  issue 33, opened 2026-09-27, KLayout LVS not extracting `diode_nd2ps_06v0` in bare p-substrate on a pad ring.
  **[U-sub]**: my own search access does not reach that repository, so I could not open it. It matches what I
  measured independently in section 14.2, and it names where the deck's upstream is.
- **Third-party statement to avoid quoting:** an automated project's issue claims that no PDK source characterizes
  ESD failure current or snapback for gf180mcu. That is wrong; chapter 14.5 of the manual does (section 7.2). **[U-sub]**
  for the issue, **[V]** for the manual.

### 15.8 What stays unknown after the search

Measured ESD levels of the pads; whether they were ever ESD-tested; pulsed oxide breakdown and pulsed metal limits
for this process; a sizing rule for the user's CDM network beyond the datasheet sentence and the foundry's own
example; whether the shuttle includes the ESD implant; anything said about analog-pad ESD in the FOSSi/Chipalooza
chat, the wafer.space chat or other closed archives, which cannot be searched from here.
