<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Running log — class-AB pad driver, its bias and the pad enables, IHP → GF180 (proof of concept)

Session ae2f9665 (continued), Claude (configured model `claude-opus-5-5`; the serving model may differ).
Newest entries at the bottom. Times are Europe/Berlin. Written to preempt context compaction. Times corrected at 21:17 from the transcript (the first
versions of the entries 19:53–20:26 carried later, wrong times); the
chat log of the session is `../../chatlog/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md`.

## 2026-10-08 19:46 — task and decisions (Christoph)

Task: port the IHP class-AB buffer (d2s_mpdda), its bias circuits, test setups and CACE sketch to GF180
as a proof of concept and smoke test of the schematic and verification flow. Re-migrate to IHP later.

Hierarchy (agreed 19:33–19:46):

- Every schematic becomes a macro in the hierarchy of the main repo `gf180_cm_ip__single2diff2single`.
- Bias circuits: separate macros, each with its own verification suite (they simulate stand-alone).
- Class-AB driver: a macro, characterized with an ideal bias fixture and with a real bias macro.
- The driver may end up (partly or whole) in custom analog pads, not in the Chipalooza slot.
- Analog input and output pads need enable circuits: the enable goes into its own sub-macro, unlike
  the IHP `power_down/` cells where the switches are spread through every cell.

Where things go:

- Main repo: `macros/<Macro>/{schematic/xschem, testbenches/xschem, verification/cace(+results), scripts, README.md}`,
  laid out like `macros/OgueyAebischerBias`. Schematic renders in `render/img/`.
- Notes worktree: this log and tool output in `sudelbuecher/logs/main/`, the chat log in `sudelbuecher/chatlog/`.
- IHP trees are read only.

## 19:50 — sources read (indexed, not copied)

IHP notes worktree `sudelbuecher/design_considerations/class_ab_pad_driver/`:

- `port_gf180/kickoff_port_gf180.md` (2026-10-06): scope defaults (03v3 devices at 3.3 V; in: diodes, the
  four bias variants, d2s_bias_lp, d2s_mpdda with units and Miller caps), re-derive sizes, PDK facts.
- `improvements/bias.md`, `improvements/xschem/README.md`, `improvements/sim/{d2s_bias_ref,d2s_bias_lp,d2s_mpdda,units,ccomp}.spice`,
  `improvements/sim/tb/tb_mpdda_{dc,loop,step,thd,noise,op}.spice`, `run_bias.py`, results files.
- `power_down/log.md`, `power_down/sim/{d2s_mpdda_pd,d2s_bias_ref_pd}.spice` (switch plan for the enable).
- `verification/cace/d2s_miller_biased.yaml` and templates (the original driver's CACE draft).

Targets carried over: bias currents 5 / 5 / 2 / 2 / 5 / 5 µA (vbp vbn vbpc vbnc vabp vabn), I_Q ≈ 212 µA,
loop T0 ≈ 79 dB / f_c ≈ 1.4 MHz / PM ≈ 72° into 1 kΩ ∥ 100 pF, gain −6 dB (vout − vref = (vinp − vinn)/2).

## 19:50 — plan

Order: diode replicas and bias macros → driver core on the ideal fixture → enable sub-macro → pad wrappers.
Device family 03v3 (kickoff default; 5 V not decided). IHP sheets are hand drawn; the GF180 FET symbols have
the IHP pin geometry, so the sheets are ported by symbol and property substitution (as `OgueyAebischerBias`),
resistors and capacitors re-drawn where their pins differ.

## 19:53 — GF180 sizing, driver on the ideal fixture (cloud: ngspice-42, gf180mcuD from fd_pr e11a8c9)

Sizing netlists first (cloud scratch, later `macros/ClassABDriver/scripts/gf180_sizing.spice`), started from the
IHP geometry and changed only where GF180 simulation said so:

- Model limits read from `sm141064.ngspice`: 03v3 bins W 0.22–100 µm **per instance, total W, not W/nf**
  (W = 400 µm with nf = 40 gives "could not find a valid modelname"), L 0.28–50 µm. So OP and ON are
  drawn with m: OP 91.02u/0.6u nf=14 m=6 (546.12 µm, as IHP), ON 96.8u/1u nf=22 m=3 (290.4 µm, as IHP).
- Transliterated first try: I_Q 192 µA, T0 92.4 dB, f_c 1.37 MHz, PM 72.3° (IHP 212 µA, 78.9 dB, 1.37 MHz,
  72.4°). The GF 03v3 devices behave much like sg13_hv here.
- I_Q: class-AB replicas RP1 13.32u → 12u/0.6u nf=2 and RN1 8.8u → 8u/1u nf=2 give 212.0 µA.
- Headroom: at ss/−40 °C/3.0 V the DDA tails (5u/6u) had V_DS 0.35 V < V_DSsat 0.43 V; INL 6 mV, offset
  −3 mV within |vd| ≤ 0.2 V. Tails Ta/Tb and the vbp diode BP 5u/6u → 20u/6u nf=2: INL 0.37 mV, offset −0.16 mV.
- Degeneration rhigh 0.5u/50.6u → ppolyf_u_3k 1u/50u (≈ 150 kΩ; TC −0.17 %/K vs rhigh −0.22 %/K).
- Miller capacitors: pfet_03v3 16u/16u in accumulation, as IHP.

Corners (ideal fixture, 1 kΩ ∥ 100 pF): I_Q 198–222 µA; T0 64 dB (ff/3.6 V/125 °C) … 98 dB; PM 68–75°;
offset ≤ 0.58 mV (ff/3.6 V/125 °C). Loads: 100 pF only 105.6 dB / 1.77 MHz / 61.9°; 50 Ω 66.8 dB / 0.23 MHz /
89.2°; 1 kΩ ∥ 1 nF PM 33° (as IHP: the Miller loop is sized for 100 pF).

## 19:54 — bias variants in / out (GF180 netlists)

Same mirror ratios, PMOS sources 20u/6u (copies of BP), NBPC 2.4u → 2.5u (narrow-width error −3.6 % → +0.7 %).
Current errors over MOS/res corners, −40…125 °C, 3.0…3.6 V: in −0.7…+1.8 %, out −0.5…+1.8 % (IHP: ≈ ±1.2 %).

## 19:57 — xschem port of the hand-drawn IHP sheets

`scripts/port_classab_from_ihp.py` (to go into `macros/ClassABDriver/scripts/`): wires and placement kept,
sg13_hv → pfet/nfet_03v3, rhigh → ppolyf_u_3k (+ bulk label vss), sizes from `gf180_sizing.spice`,
code blocks: IHP `.lib` lines → a tcleval MODELS block, `@n.*.nsg13_hv_*[ids]` → `@m.*.m0[id]`.

Cell names: d2s_bias_lp → ClassABBiasIdeal, d2s_bias_in/out → ClassABBiasIn/Out (macro `ClassABBias`);
unit_r2 → ClassABUnitR, d2s_mpdda → ClassABDriver (ports + `a b`, the OP/ON gates, for the enable switches),
d2s_mpdda_biased → ClassABDriverBiased (CACE fixture), tb_mpdda_* → ClassABDriver_tb_* (macro `ClassABDriver`).

Round trip (`scripts/check_classab_port.py`, xschem 3.4.8RC netlist vs gf180_sizing.spice, device by device,
nets by bijection, ports by name and order): MISMATCHES 0 on all five cells. Checker sanity: one moved gate
and one changed W each give MISMATCHES 1.

Ported testbenches, netlisted by xschem and run: dc gain 0.49999, offset 0.017 mV, nonlin 1.5 mV (±1 V),
I_Q 212.8 µA, Idd 297 µA; loop 93.1 dB / 1.40 MHz / 72.7°; step ±0.25 V no overshoot, 2.4 V/µs (10–90 %);
THD 0.145 % (10 kHz, 1 V diff.); noise total 249 µV; op prints all saturation margins.

## 20:00 — chat log across the compaction

The automatic compaction at 19:23 rewrote the transcript; the turns before it are only in the 03:07 export.
`chatlog/export_chatlog.py` now skips the compaction summary (not a user message), marks the cut, and can append
to an earlier export (CHATLOG_TURN_OFFSET, CHATLOG_BODY_ONLY, CHATLOG_COMPACT_USER/TIME). The chat log file keeps
turns 1–7 from the earlier export; turn 8 (19:22) has its user message reconstructed from the compaction summary
and says so.

## 20:03 — PadEnable cells (new macro `macros/PadEnable`)

The IHP power_down switch plan, moved into cells of their own (`scripts/gen_padenable.py`, devices 03v3):

- `EnableInv` en → en_b (2u/0.5u, 1u/0.5u). One per pad; a 1.2 V → 3.3 V level shifter would replace it.
- `DriverEnable` SA a→vddo, SB b→vsso, SABP vabp→vdd, SABN vabn→vss (1u/0.5u), on while en = 0.
  ClassABDriver got the ports `a b` (gates of OP / ON) for this.
- `BiasRefEnable` transmission gate iin→iout, TDN pulls iout (NI's gate line) to vss while disabled.
- `InputEnable` transmission gate pin→pout, second gate parks pout on vpark while disabled (4u/0.5u).

Sheets: rails as wires, sources and bulks wired, gates and drains by stub + label. The first draft had the PMOS
drain stub and the NMOS drain stub meet at one point, which merged iin with iout and pin with pout; the round trip
against `scripts/padenable_reference.spice` caught it (XTGN "iout en iout"). Rows moved apart: MISMATCHES 0 on
all four.

Repo-level `scripts/xsheet.py`: the sheet/symbol/CACE-template helpers shared by the generators.

## 20:05 — pads

- `gf180mcu_IOPadDiff2Single` (was ports only): xbias ClassABBiasIn ← xref BiasRefEnable ← iref; xdrv
  ClassABDriver with vfb = out; xen DriverEnable; xinv EnableInv. Ports `vdd vss vddo vsso inp inn vref out iref en`.
  Bias enters as a current. Block level, pins by stub + label (`scripts/gen_iopad_d2s.py`).
- `gf180mcu_IOPadSingle2Diff`: InputEnable behind the CDM network (in_prot → in_en, parked on vcm), EnableInv;
  new port `en`, last (`scripts/add_input_enable.py`, a one-time edit of the existing sheet and symbol).
- macro xschemrc files append the sibling macros they instantiate (`../../../<Macro>/schematic/xschem`).
- Cloud note: the xschem / Tcl here rejects the UTF-8 BOM at the start of the IOPad and top-level xschemrc files
  (every symbol "IS MISSING", netlist empty). The cloud netlisting runs from a BOM-stripped mirror; the files on
  the computer keep their BOM. (The 2026-10-06 note that 3.4.8 accepts the BOM was wrong for this build.)

## 20:14 — CACE: ClassABBiasIn, ClassABBiasOut (`macros/ClassABBias/verification/cace`)

Three parameters each: bias-current errors over 5 MOS corners × −40/27/125 °C × 3.0/3.3/3.6 V; DC line
sensitivity (vdd = vddo 3.0 → 3.6 V); local mismatch, 100 iterations. All pass the placeholder limits:

| | In | Out |
|---|---|---|
| errors over PVT | −1.7 … +2.9 % | −1.5 … +3.4 % |
| line sensitivity vbn / vabp | 0.8–1.3 / 0.6–1.1 %/V | 0.19–0.23 / 0.8–1.3 %/V |
| mismatch, 100 runs, extremes | −1.7 … +3.6 % | −1.7 … +3.8 % |
| Idd (vdd + vddo, without iref) | 24.0–24.4 µA | 29.0–29.3 µA |

CACE lessons (worth keeping): a condition named like a pin (`iref`) took a value of its own (1 mA) — renamed
`i_ref`; every parameter must state the conditions it does not sweep (vdd defaulted to 3.0 V, the pin's Vmin);
`CACE{...}` in a symbol's `value=` must be brace-escaped or xschem eats it; for a unit of `%` CACE shows
100 × the echoed value, so fractions are echoed; `off` is YAML for false.

## 20:26 — CACE: ClassABDriverBiased (`macros/ClassABDriver/verification/cace`)

DUT = ClassABDriver + ClassABBiasIdeal (the IHP d2s_mpdda_biased fixture). 45 + 15 + 9 + 15 + 3 runs, 6 min:

- DC over PVT: gain 0.49943–0.50007, offset 0.013–0.72 mV, I_Q 205–223 µA, Idd 289–307 µA. INL 0.02–3.5 mV,
  fails the 2 mV placeholder only at ss/3.0 V/−40 °C (input pairs out of headroom at vref ± 0.2 V, as on IHP).
- Loop over corners and temperature: T0 59–97 dB, f_c 1.31–1.47 MHz, PM 68–76°.
- Loop vs load (50 Ω / 1 kΩ / open × 10 p / 100 p / 1 nF): PM 24.9° at 1 nF fails, as on IHP.
- Step ±0.25 V: overshoot ≤ 0.3 %, 2.0–2.8 V/µs, 1 % settling 250–415 ns. Noise 10 Hz–10 MHz 245–251 µV.
- ngspice noise does not run with `option KLU` (the OAB template options); the driver templates use the sparse
  solver. Vectors of an earlier plot are read as `op1.<vec>` after a later analysis.

## 20:52 — CACE: gf180mcu_IOPadDiff2Single (`macros/gf180mcu_IOPadDiff2Single/verification/cace`)

DUT = the pad (bias tree + driver + enables). Reference current from a behavioural source on its own supply vsup
(5 µA, tanh compliance near vsup, 100 MΩ), so that Idd excludes it. Three parameters, 75 runs, 8 min:

- enabled, PVT (45): gain 0.49934–0.50007, offset 0.013–0.78 mV, I_Q 203–223 µA, Idd 289–310 µA.
- disabled (15): Idd 0.08–2.9 nA; OP / ON gates within 1 µV of their rails; reference current ≤ 0.08 nA.
- enable transient (15): output glitch 171–489 mV, out within 1 mV after 1.27–1.52 µs, I_Q back to 207–219 µA.

The disabled state first gave Idd of ±17 µA in some runs. The device currents were all fA–pA and the source currents
did not satisfy KCL: with every current root off most nodes float, and ngspice accepted DC operating points with large
residues (at gmin = 1e-15; at 1e-12 still in 1 of 15 runs; rshunt did not help). A 5 µs transient from that point
settles to the leakage (fs/27 °C: 17 µA → 0.24 nA). The template reads the disabled state at the end of the transient.

## 21:09 — CACE: gf180mcu_IOPadSingle2Diff rerun with the enable

en tied to vdd in the testbench and the template. The transmission gate adds junctions on in_prot: −0.3 V up to −42 nA
(hot), 0…3.6 V ≤ 5.3 nA, 5.0 V 2.3–4.8 mA at in_prot 4.29 V, 5.5 V 3.8–7.5 mA (before: 2.0–3.9 mA / 4.34 V and
3.4–6.4 mA / 4.38 V). Not 5 V tolerant, as before. Results in the repo replaced; the old ones are in the backup below.

## 21:12 — xschemrc chain of the whole project

Netlisting the output pad through the top-level `schematic/xschem/xschemrc` lost ClassABBiasIn and ClassABDriver.
Cause: the gf180mcuD PDK xschemrc does not set the Tcl variable `PDK` (IHP's does), so the guard
`if {![info exists PDK]}` never fired and every chained project xschemrc re-sourced the PDK file, which resets
`XSCHEM_LIBRARY_PATH`. Every project xschemrc now does `set PDK $env(PDK)` after sourcing it (19 files incl. the
OgueyAebischerBias and IOPad ones). After the fix the pad and a driver testbench netlist through the top-level files
with every cell found.

## 21:17 — delivery

- Backup of the 26 files that were overwritten (as found on the computer before the delivery):
  `sudelbuecher/backups/2026-10-08_before_classab_port/` (copied on the computer, checksums identical).
- 123 files written to the main repo with device_commit_files, mtime guards on the 26 existing ones; none rejected.
- `logs/main/2026-10-08_opus_classab_delivery.md5`: `md5sum -c` on the computer: 106 OK, the 17 PNGs differ
  (provenance stamp in transit); their decoded pixels are identical (hash of all 17 decoded images matches).
- Not delivered: Makefiles for the three new macros (the bridge refuses Makefiles). The bias variants `_oa` and `_bg`
  are not ported (need a GF180 re-design).
- No git commands were run.

## 21:46 — Makefiles as a package (Christoph, 21:42: "drop me a zip file into the _sudelbuecher")

`sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip` (md5 558bde3f…): `repo/` mirrors the design repository,
`README.md` lists every file and change, `install.sh` installs, `changes_to_existing_makefiles.diff` shows the
changes to the four existing files.

- New: `macros/ClassABBias/Makefile` (sim-cace, sim-cace-all for In/Out; sim-all = sim-cace-all),
  `macros/ClassABDriver/Makefile` (sim-all = six testbenches + sim-cace on ClassABDriverBiased),
  `macros/PadEnable/Makefile` (sim-all only points to the pad's CACE).
- Changed: both IOPad Makefiles (their sim-all called a non-existent `<TOP>_tb_tran`; now CACE, and for Single2Diff
  the `_tb_dc` testbench, tolerating xschem's exit status 10 for the undriven outp/outn); OgueyAebischerBias
  (`CACE_OPTS ?= --nofail`); top level (`sim-cace-macros`, `clean-macros` covers all macros).
- `install.sh` replaces an existing Makefile only if its checksum is still the 2026-10-08 one (all four were, checked on
  the computer at 21:47), keeps it as `Makefile.orig-2026-10-08`, and checks the result.
- Tested in a copy of the repository in the cloud: help and dry runs everywhere; the six driver testbenches through
  sim-xschem; Single2Diff sim-all (exit 0); a ClassABBias CACE parameter; clean-macros; install.sh on the original
  files (all replaced, all checks OK) and a second run (all "already installed").
- `README.md` and `HANDOVER_gf180_migration.md` now point to the package (so their checksums in
  `2026-10-08_opus_classab_delivery.md5` are superseded: a5e740cb… and edd6d62f…).
