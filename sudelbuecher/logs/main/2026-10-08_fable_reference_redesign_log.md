<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Running log — GF180 redesign of the class-AB driver's bandgap reference (`ClassABBiasBG`)

Session 01Btt65c, Claude (configured model `claude-fable-5-1`; the serving model may differ). Newest entries at the
bottom. Times Europe/Berlin. Kickoff: `sudelbuecher/kickoffs/2026-10-08_reference_redesign/kickoff_reference_redesign.md`.
Written to preempt context compaction; every number here comes from the cloud harness `tools/` (copied in §23:40).

## 2026-10-08 23:16 — task and decisions (Christoph, §3 of the kickoff, answered 23:20–23:25)

1. Scope: **bandgap only** (`ClassABBiasBG`); the Oguey–Aebischer core is deferred.
2. Targets as the kickoff defaults, as pass/fail limits in CACE: 5 µA into the tree; drift −40…125 °C ±3 %; mismatch
   σ ≤ 2 %; line sensitivity ≤ 1 %/V; start-up from 0 V with 1 µs and 1 ms ramps at all corners; process spread,
   area reported.
3. Devices 03v3 at 3.0–3.6 V; **also check at 5 V now** with 06v0 devices substituted (informative, no limits).
4. `macros/OgueyAebischerBias` stays as it is.
5. Disable as a sub-cell `RefCoreEnable` in `macros/PadEnable`, instantiated in the core cell.
6. (23:25) If the process has deep-n-well NMOS (isolated p-wells), make a design variant with them; compare before the
   full CACE run; report the difference (PSRR, area).

## 23:27 — cloud tools

Built per `sg13cmos5l_…_sudelbuecher/sudelbuecher/cloud_environment.md`: xschem 3.4.8RC (ddc73448), ngspice-47
(danchitnis mirror, image configure options), gf180mcuD from the ciel release asset `1689ac3f…` (`tar --wildcards` is
needed, the recipe's bare patterns extract nothing), CACE 2.13 in a venv on `/usr/bin/python3.12` (the default
python3.13 has no tkinter; `apt-get install python3-tk` serves 3.12 only). No `.spiceinit` in the gf180mcuD tree
(CACE warns, as on 2026-10-06). Repository snapshot transferred as one tar
(`gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete/cloud_transfer_2026-10-08.tgz`, md5 1dfd369b…, 13.1 MB;
**the folder `_to_delete/` on the computer can be removed**).

**Rerun of the 2026-10-08 CACE suites with this toolchain** (kickoff §5): `ClassABBiasIn` — all 16 result values
identical to the stored `results/ClassABBiasIn/summary.md` to the last digit. `ClassABDriverBiased` — 13 of 16 identical;
overshoot 0.308 → 0.307 %, rise rate 2.042 → 2.043 V/µs, 1 % settling 250.0/337.1/414.9 → 250.6/337.4/419.6 ns
(ngspice-42 → 47 transient step control). Logs: `logs/main/2026-10-08_fable_cace_*_rerun.out`.

## 23:40 — PDK facts checked for this design (gf180mcuD 1689ac3, `sm141064.ngspice`)

- **Deep n-well NMOS:** no separate ngspice model. An NMOS in an isolated p-well is `nfet_03v3` with its bulk pin on the
  p-well net, plus the well junctions as `diode_pw2dw` (p-well → DNW) and `diode_dw2ps` (DNW → substrate), both with
  `area`/`pj` and xschem symbols. KLayout LVS extracts it as `nfet_03v3` with the p-well as bulk net (as
  `nfet_03v3_dn` only with `CONSIDER_DN_DW_FEATURES`); the well diodes are extracted only under a `well_diode_mk`
  marker. DRC: DNWELL min width 1.7 µm, DNWELL encloses LVPWELL 2.5 µm, N-well outside to DNWELL 3.1 µm, DNWELL space
  5.42 µm (different potential), each DNWELL surrounded by a PCOMP guard ring on substrate (DN.3).
- **PNP mismatch** is in the model: `mis_is` σ 0.052 %, `mis_bf` σ 0.31 % per device, scaled by `1/sqrt(par)`,
  switched by `sw_stat_mismatch`. Tiny (0.05 % of I_S is 13 µV of V_BE).
- **Resistor mismatch: none in the PDK.** `ppolyf_u`, `npolyf_u`, `nplus_u`, `pplus_u` have a `mis_r=0` instance
  parameter, the 1k/2k/3k resistors nothing at all. Mismatch MC below is MOS + PNP only.
- Resistors at 1 µm × 100 µm, effective (incl. terminal resistance), −40/27/125 °C: `ppolyf_u_1k` 110.7/103.0/96.1 kΩ
  (−0.086 %/K, tc2 2.51e-6/K²); `ppolyf_u_2k` and `_3k` −0.154 %/K, tc2 3.74e-6; `ppolyf_u` 37.3/37.0/36.9 kΩ
  (−0.008 %/K, tc2 0.7e-6); `npolyf_u` −0.134 %/K; `pplus_u` +0.139; `nplus_u` +0.138. Spread: 1k/2k ±20 %, 3k ±25 %
  (`res_ss` = +20 %, `res_ff` = −20 % of R_sh). Min width 1 µm (HRES.2) for the 1k/2k/3k, 0.8 µm (PRES.1) for `ppolyf_u`.
- V_BE of `pnp_05p00x05p00` at 2.5 µA: 0.807/0.687/0.504 V (−1.84 mV/K); 8 in parallel 0.765/0.633/0.432 V.
- pfet_03v3 V_SG at 2.5 µA, −40/27/125 °C: 40/1 0.87/0.79/0.68 V; 48/2 ≈ 0.90/0.83/0.73; 20/4 0.99/0.94/0.87.
  nfet_03v3 20/4 at 2.5 µA with the source 0.7 V above the bulk: V_GS 1.00/0.94/0.85 V; bulk tied to source
  0.76/0.70/0.61 V — **the body effect costs 0.24 V** here.
- 06v0 devices: min W 0.3 µm (0.22 µm fails the bin).

## 00:05 (2026-10-09) — core topology for GF180 and sizing (`tools/bg_gf.spice`, `tools/run_bg.py`)

Transliterating the IHP `bg_core` (stacked-diode cascode PB/PBC, NB's drain at the lower diode) fails at
**ss / 3.0 V / −40 °C**: pfet_03v3's V_SG at 2.5 µA is ≈ 1.0 V there, so vpc = vdd − 2 V_SG ≈ 1.0 V leaves NB
(source at V_BE = 0.78 V) no V_DS; the core settled at 3.3 µA with ea ≠ eb. Changes, kept minimal:

1. **Self-biased wide-swing cascode mirror.** The input branch's diode connection closes around the cascode (vpg =
   drain of PBC); the cascode gate line vpc = vpg − I·RC with a resistor RC (`ppolyf_u_1k` 1u/150u ≈ 150 kΩ, 0.37 V)
   between the two gate lines, NB's drain on vpc. Every mirror device then has V_SD = I·RC (0.31–0.37 V over
   corners), every cascode V_SG − I·RC. Costs one resistor, no current. (A first try with a separate bias branch
   PX/PXD failed: the bias diode needs a current sink to ground that the core does not have.)
2. **Start-up pulls vpg** (the mirror gate line) instead of vpc; otherwise as IHP: MS1 weak always-on pull-up on ks,
   MS2 senses g, MS3 the pull-down. MS1 0.5/100 → **0.22/50** (L ≤ 50 µm bin; 0.4–0.5 µA, as the IHP device).
3. **NMOS pair NA/NB 20/4 → 20/12.** NB's V_DS (= vpc − eb) moves 1:1 with vdd, and its g_ds/g_m becomes an input
   offset of the pair; L = 12 µm halves the line sensitivity (0.63 → 0.42 %/V).
4. **PMOS mirror 40/1 → 48/4 nf=4, cascodes 48/2 nf=4**, PO/POC 96/4 and 96/2 nf=8 (one instance each, the 100 µm
   bin limit; the mismatch model ignores `m`). The mirror devices set the mismatch: 48/2 gave σ 1.83 %, 48/4 1.05 %
   (4 × L: σ_VT halves and g_m/I drops), 48/8 would give 0.6 %.
5. **Resistors `ppolyf_u_1k`, 1 µm wide**, not 3k: the 3k's tc2 (3.74e-6/K²) bends the current by −3.7 % at 125 °C
   on its own; the best PTAT/CTAT balance with 3k gave −3.0…+0.6 % over −40…125 °C (fails ±3 % at the corners),
   with 1k −2.0…+0.1 % (band 2.1 % wide), with `ppolyf_u` the balance needs a PTAT share of 45 % and 2.5 mm of
   resistor. The 1k's TC (−0.086 %/K) makes the balance 68 % CTAT / 32 % PTAT (IHP rhigh: nearly all CTAT).
   **R1B 382 µm, R1A 420 µm (+10 %, IHP's false-state trick), R0 67.5 µm**, all 1u wide: ≈ 384 / 422 / 70 kΩ.
   The band is centred: 27 °C sits at +1.1 %, the ends at −0.8 / −1.0 %.
6. Q1 one `pnp_05p00x05p00`, Q2 `m=8` (ratio 8, ΔV_BE = 54 mV), as IHP (pnpMPA 4 µm² each → 25 µm² each here).

**Results, core alone into an NI-type diode (6u/6u), `bg_core` (NA/NB bulk on vss), tt unless stated:**

| | value |
|---|---|
| iout at 27 °C / 3.3 V | 5.053 µA (+1.1 %); I_dd 10.5 µA (4 branches of 2.5 µA + MS1 0.5 µA) |
| −40 … 125 °C, 3.3 V | 4.96 … 5.06 µA: −0.8 … +1.1 % of 5 µA, band 2.1 % (peak at 50 °C) |
| MOS corners ss/ff/sf/fs at 27 °C | +0.95 … +1.17 % |
| PVT extremes (ss 3.0 V −40 / ff 3.6 V 125 / ss 3.0 V 125 / ff 3.6 V −40) | −1.0 / −0.7 / −1.3 / −0.6 % |
| bjt_ss / bjt_ff | +2.0 / +0.4 % |
| **res_ss / res_ff** | **−16.2 / +27.0 %** (R_sh ±20 %, straight into the current, as rhigh on IHP) |
| DC line 3.0 → 3.6 V | +0.42 %/V (tt), 0.39 (ss −40 °C), 0.50 (ff 125 °C) |
| AC from vdd, 10 Hz / 1 k / 100 k / 1 M / 10 MHz | 0.42 / 0.42 / 3.5 / 14 / 56 %/V |
| mismatch σ, 100 seeds (MOS + PNP) | **1.05 %**, extremes −3.1 / +2.4 % |
| start-up, 1 µs ramp, 10 corners | ends at the DC point everywhere; within ±10 % 0.3–0.9 µs after the ramp |
| start-up, 1 ms ramp | within ±10 % 0.26–0.59 ms **before** the ramp ends (vdd ≈ 1.2–2.2 V) |
| false operating points | from resistor-only start states (ea 0.1 / 0.3 V, start-up disabled, `uic`) the core runs up to the DC point at tt −40, ss 3.0 V −40, res_ff −40, ff 3.6 V 125 °C |
| headroom at ss / 3.0 V / −40 °C | V_SD(PB) 0.31 V, NB V_DS 0.75 V, cascode PAC V_SD 0.5 V |

Pitfall (cost 20 min): `.ic` + `uic` transients with the default trapezoidal method gave `i(Vs)` values ±15 % off
while every node voltage equalled the operating point — ammeter displacement-current ringing. `method=gear` (as the
IHP `run_bias.py` used) gives the exact DC value. All start-up numbers above use Gear.

## 00:20 — deep-n-well variant `bg_core_dn` (same sizes; NA in p-well on ea, NB in p-well on eb, one DNW on vdd)

Well junctions modelled with estimated layout areas (each p-well 30 × 12 µm, DNW 60 × 30 µm).

| | `bg_core` (bulk vss) | `bg_core_dn` |
|---|---|---|
| iout 27 °C | 5.053 µA | 5.066 µA |
| drift −40…125 °C | −2.04 / +0.06 % vs 27 °C | −1.97 / +0.08 % |
| DC line sensitivity | 0.42 %/V | **0.62 %/V** |
| AC from vdd 100 kHz / 1 MHz | 3.5 / 14 %/V | 1.3 / 8.4 %/V with the estimated well areas; 3.5 / 13 with negligible well capacitance; 2.2 / 14 with 2.5 × the areas |
| substrate noise → iout (AC on the NMOS bulks, PNP collectors and DNW anode only, vss clean), 10 Hz / 100 kHz / 1 MHz | 0.16 / 13.5 / 51 %/V | 0.01 / 0.01 / 0.00 %/V |
| mismatch σ | 1.05 % | 1.15 % |
| V_GS of the pair (g − ea) | 1.01 V | 0.77 V |
| start-up, false states | same | same |

What the deep well does here: (a) it **removes the body effect**, which is a loss for DC supply rejection — with the
bulk on vss the pair's diode conductance is g_m + g_mb, and NB's V_DS-induced offset is divided by that; with bulk =
source only g_m is left (0.42 → 0.62 %/V, still under the 1 %/V limit); (b) its AC rejection from vdd depends on the
p-well–to-DNW capacitance (DNW on vdd couples vdd into ea/eb, partly cancelling the mirror's coupling) and is not a
robust advantage: better or worse depending on the actual well areas; (c) **substrate noise** no longer reaches the
pair: that is the real benefit, and the test is idealised (noise on the local substrate only); (d) headroom: 0.24 V
more on node g, not needed; (e) **area:** the pair grows from about 30 × 25 µm (≈ 750 µm² with taps) to about
39 × 34 µm (≈ 1330 µm²: two p-wells inside one DNW, 2.5 µm enclosure, N-well ring, PCOMP guard ring, 3.1 µm to the
nearest other N-well), **+ ≈ 500–700 µm²** incl. the keep-out, ≈ +15 % of the core (DRC-rule estimate, no layout).

## 00:30 — informative: 06v0 devices substituted at 4.5–5.5 V (same sizes, MS1 0.3/50, `ppolyf_u_1k_6p0`)

`bg_core`: 5.14 µA at 5.0 V (+2.8 %), 5.03 / 5.06 µA at −40 / 125 °C (5.0 V), 5.00 µA at ss 4.5 V −40 °C, 5.14 at
ff 5.5 V 125 °C; line sensitivity **1.2 %/V** (4.5 → 5.5 V; NB's V_DS swings 2 V), V_SD(PB) 0.31 V. `bg_core_dn`:
5.19 µA (+3.8 %), 1.45 %/V. So the topology carries over to 5 V without headroom problems; a 06v0 version would need
the resistors re-centred (−3 %) and a longer NB or a cascode to get under 1 %/V. Not drawn.

## 2026-10-09 00:01 — Christoph: "AVOID POLY RESISTORS!" — 00:03: rescinded ("resistors are inevitable; poly resistors
are ok; save area if you can")

Area lever taken: **`ppolyf_u_3k` instead of `ppolyf_u_1k`** (strips 870 → 308 µm, ≈ −900 µm²), with the temperature
band centred on 5 µA so that its 3.0 % width still fits ±3 %: R1B 107.4 µm, R1A 118.1 µm, R0 32.8 µm, RC 50 µm
(150 kΩ), all 1 µm wide. Re-tuned results, `bg_core` (tools, 3k):

| | value |
|---|---|
| iout 27 °C / 3.3 V | 5.077 µA (+1.5 %); band −40…125 °C −1.2 … +1.6 % of 5 µA (3.0 % wide, peak at 50 °C) |
| 5 MOS corners × 3.0/3.3/3.6 V × −40/27/125 °C | **−1.6 … +1.7 %** (worst ss 3.0 V 125 °C / ff 3.6 V 27 °C) |
| bjt_ss / bjt_ff at 27 °C | +2.6 / +0.7 % (bjt_ss reaches +2.9 % at 50 °C) |
| res_ss / res_ff | **−19.4 / +36.5 %** (3k: R_sh ±25 %) |
| DC line, tt / ss −40 / ff 125 | 0.32 / 0.29 / 0.43 %/V; AC 100 k / 1 MHz: 2.9–3.2 / 11–13 %/V |
| mismatch σ (100 seeds) | 0.98 % (dn: 1.05 %) |
| start-up 1 µs / 1 ms ramps, 10 corners | ok everywhere, 0.4–1.1 µs after the ramp / 250–580 µs before its end |
| `bg_core_dn` | line 0.44–0.58 %/V, AC 100 k 0.55–0.86 %/V, else as above |

## 00:06 — sheets, symbols, round trip

- `macros/PadEnable/RefCoreEnable` (SPG vpg → vdd, SKS ks → vss, 1u/0.5u) added to `gen_padenable.py` (new function
  `ref_core_enable`; `main` now takes cell names, only this cell was written — the 2026-10-08 sheets are untouched) and
  to `padenable_reference.spice`.
- `macros/ClassABBias/scripts/gen_bg.py` + `bg_reference.spice`: `ClassABBiasBG` (ports `vdd vss iout en en_b`; MS1's
  gate on en_b, `XE RefCoreEnable` inside), `ClassABBiasBGdn` (NA/NB bulk = source, `diode_pw2dw` × 2 and
  `diode_dw2ps` with the estimated areas as `r_w`/`r_l`), the CACE fixtures `ClassABBiasBGTree` / `…dnTree` (core +
  `ClassABBiasIn`, iout → iref). Drawn in the `PadEnable` label style with the repo's `scripts/xsheet.py` (extended
  locally with resistor / PNP / diode placers); the IHP drawing was not ported because the topology changed.
- `ClassABBias/schematic/xschem/xschemrc`: one line added (the PadEnable schematic folder, for `RefCoreEnable.sym`).
- `ClassABDriver/scripts/check_classab_port.py` extended: models `ppolyf_u_1k`, `pnp_05p00x05p00`, `pnp_10p00x10p00`
  (m compared), `D` primitives (nets compared). **MISMATCHES 0** on `ClassABBiasBG` (18 devices), `ClassABBiasBGdn`
  (21), `RefCoreEnable` (2); a moved gate and a changed resistor length give MISMATCHES 2.
- Figure check: SVG export with `xschem … --script` (print area given explicitly; `xvfb-run` hangs here) — readable.

## 00:14 — CACE (`macros/ClassABBias/verification/cace`, `scripts/gen_cace_bg.py`, four datasheets)

Parameters of `ClassABBiasBG` / `…dn`: `dc_params` (iout over 5 MOS corners × 3 V × 3 T, limit ±3 %), `spread_params`
(res × bjt corners × T, report), `line_params` (≤ 1 %/V), `tran_startup_params` (1 µs and 1 ms ramps × 2 V × 5 corners
× 3 T; t_startup as in OgueyAebischerBias, e_end ±3 %), `mm_params` (100 runs, ±6 % on the extremes, σ from the
`.data` files with `scripts/mm_sigma.py`), `off_params` (en = 0, leakage after 200 µs of transient). The `…Tree`
datasheets: the six diode currents of the tree over 5 corners × 3 V × 3 T (±5 % placeholders, as `ClassABBiasIn`).

Pitfalls (new): CACE expressions `CACE[... + 1m]` fail ("Invalid expression") — write `1e-3`. A template cannot
instantiate a second cell of the macro (templates are netlisted with the PDK xschemrc + the templates folder only;
the cell's outputs then count as undriven, xschem exits 10) — hence the fixture cells. The ClassABBias `Makefile`
change (`CACE_CELLS`) is a package again: `deliveries/2026-10-09_fable_makefile.zip`.

First complete run of `ClassABBiasBG` (RUN_2026-10-09_00-14-03 + the start-up rerun): dc −1.61 … +1.66 % ✅, spread
−22.9 … +37.9 % (incl. bjt corners at −40/125 °C), line −0.005 … +0.416 %/V ✅, start-up t ≤ 1.29 µs after a 1 µs ramp
and ≥ 125 µs before a 1 ms ramp ends, e_end = dc ✅, mismatch σ 1.06 % (mean +1.29, −1.2 / +4.0 %) ✅, disabled
I_dd 0.02–0.24 nA, iout ≤ 0.07 nA ✅.

## 00:30 — driver with the real reference (tools `run_gf.py` + `bg_gf.spice`; `logs/main/…driver_with_bg.txt`)

`ClassABDriver` on `ClassABBiasBG` → `ClassABBiasIn`, 1 kΩ ∥ 100 pF, resistors typical: I_Q 214.5 µA at tt (ideal
fixture 212.8, `in` 211.5), 200–220 µA over ss/3.0 V/−40 … ff/3.6 V/125 °C (ideal 205–218), T0 61–93 dB, PM 66–78°,
offset ≤ 0.8 mV, INL ≤ 0.28 mV. Resistor corners: I_Q 172 / 286 µA (IHP rhigh: 171 / 268). The DNW variant is within
0.3 µA of these. Note `run_gf.py` ties the resistor corner to the MOS corner (ss → res_ss); the table in the log file
separates them.

## 01:03 — CACE complete, all four datasheets (`verification/cace/results/<cell>/`, logs `logs/main/2026-10-09_fable_cace_*.out`)

| | `ClassABBiasBG` | `ClassABBiasBGdn` |
|---|---|---|
| dc_params, 45 points, limit ±3 % | −1.61 … +1.66 % ✅ | −1.45 … +1.92 % ✅ |
| spread_params (res × bjt × T) | −22.9 … +37.9 % | −22.7 … +38.1 % |
| line_params (5 MOS × 3 res × 3 T), limit 1 %/V | −0.005 … +0.416 %/V ✅ | 0.107 … 0.582 %/V ✅ |
| tran_startup_params, 60 runs | t ≤ 1.29 µs after the 1 µs ramp, ≥ 125 µs before the 1 ms ramp ends; e_end = dc ✅ | ≤ 1.32 µs / ≥ 125 µs ✅ |
| mm_params, 100 runs | σ 1.06 %, mean +1.29, −1.2 / +4.0 % ✅ | σ 1.15 %, mean +1.45, −1.2 / +4.4 % ✅ |
| off_params (2 V × 3 corners × 3 T) | I_dd 0.02–0.24 nA, iout ≤ 0.07 nA | I_dd 0.03–1.26 nA (the well junctions at 125 °C), iout ≤ 0.07 nA |
| `…Tree` tree_params, six lines, 45 points, ±5 % placeholder | −3.0 … +3.7 %, I_dd 33.8–35.5 µA ✅ | −3.0 … +3.9 % ✅ |

Run times on two cores: BG 15 min (start-up 10 min), Tree 20 s, BGdn 15 min, dnTree 20 s. The summaries carry a
provenance comment line as the 2026-10-08 ones. Result folders hold `summary.md`, one csv per parameter and the plots.

## 01:10 — delivery

- Backup of the 8 files overwritten in the design repo (as found on the computer, checksums identical to the 23:28
  snapshot): `sudelbuecher/backups/2026-10-09_before_bandgap_reference/` with `MANIFEST.md5`.
- Design repo: 36 new or changed files (sheets, symbols, scripts, datasheets, templates, READMEs, handover, CLAUDE.md,
  checker) plus the four result folders, written with `device_commit_files` (mtime guards on the existing ones);
  checksums verified on the computer (`logs/main/2026-10-09_fable_bandgap_delivery.md5`; the PNG plots get the
  provenance stamp in transit, so their md5 differ — not compared pixel-wise this time, they are CACE plots).
- Makefile change as `deliveries/2026-10-09_fable_makefile.zip` (one line, `CACE_CELLS`; installer as on 2026-10-08,
  tested on a copy).
- Notes worktree: this log, the CACE logs, the sizing harness results (`logs/main/2026-10-09_fable_sizing_*.txt`,
  `…driver_with_bg.txt`), `kickoffs/2026-10-08_reference_redesign/tools/bg_gf.spice`, `run_bg.py`, `tune_r.py`
  (the sizing harness, with the final sizes as defaults), the chat log `chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md`
  (+ README index line), `chatlog/ref/` pointer file.
- The transfer archive `_to_delete/cloud_transfer_2026-10-08.tgz` (13 MB) in the notes worktree can be deleted.
- `check_classab_port.py` had been edited on the computer at 00:59 (drain/source swap accepted as a note) after the
  23:28 snapshot; the mtime guard rejected the write, the newer version was staged and my changes (PNPs, 1k, D primitives)
  merged onto it, round trip re-run (0 / 0 / 2 as before), then written. The backup folder holds the pre-00:59 version.
- The mtime guards need the millisecond value the bridge reports (`deviceMtimeMs`), not `stat %Y` × 1000.
- No git commands were run. No memory writes.

Open for Christoph: (1) DNW or not — `ClassABBiasBGdn` is drawn and characterised, the choice is a layout/noise
decision; (2) the resistor spread (±25 % → −19/+36 %, I_Q 172/286 µA) is the dominant error: trim, or accept, or
a resistor type with tighter spread (1k/2k: ±20 %); (3) the pad does not instantiate the reference yet (iref pin);
(4) layout: the PNP array (9 × 25 µm² common-centroid), the resistor strips (308 µm at 1 µm), the 48/4 mirrors.
