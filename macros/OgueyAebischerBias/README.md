# OgueyAebischerBias (GF180MCU)

Resistor-free Oguey–Aebischer current reference with start-up kick and disable, ported from the IHP
`sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias` to `gf180mcuD` on 2026-10-06.

H. J. Oguey and D. Aebischer, "CMOS current reference without resistance,"
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132–1135, Jul. 1997.

**Status: proof of concept.** Schematics, symbols, a start-up testbench and a full CACE suite exist and
run in both variants. No layout. Topology is unchanged from IHP; device sizes are re-derived for GF180.

## Two variants

The device family is not decided yet ([`docs/OPERATING_LIMITS.md`](../../docs/OPERATING_LIMITS.md)), so
the same circuit exists twice. Wires and placement are identical; only devices and sizes differ.

| Variant | Devices | Supply range simulated | Why |
| --- | --- | --- | --- |
| `03v3` | `nfet_03v3` / `pfet_03v3` | 3.0 – 3.6 V | better matching (A_VT ≈ 7 mV·µm vs ≈ 11 mV·µm), smaller |
| `06v0` | `nfet_06v0` / `pfet_06v0` | 3.0 – 5.5 V | keeps a 5 V analog supply open |

| Cell | Content |
| --- | --- |
| `OgueyAebischerBias_<v>` | core: mirrors M10–M14, triode stack M16/18/20/22, diode stack M15/17/19/21, ammeters Vi1/Vi4/Viaux |
| `ToBiasStartup_<v>` | kick (M21, M22, M25, MOS cap M20), disable switches (M23, M24), vbp bypass M26 |
| `OgueyAebischerRef_<v>` | core + start-up; the CACE DUT. Ports: `vdd vbp vbn disable vbr vss` |

`make VARIANT=06v0 <target>` selects the variant (default `03v3`); `TOP = OgueyAebischerRef_<VARIANT>`.

## Sizing (re-derived, not copied)

Device data from the gf180mcuD ngspice models (`sm141064`, typical, 27 °C, extracted 2026-10-06):

| Device | n | I_spec per square at IC = 1 | A_VT (`fets_mm`) |
| --- | --- | --- | --- |
| nfet_03v3 | 1.41 | ≈ 360 nA | 7.1 mV·µm |
| pfet_03v3 | 1.46 | ≈ 97 nA | 6.7 mV·µm |
| nfet_06v0 | 1.52 | ≈ 430 nA | 11.6 mV·µm (L_eff = L − 0.4 µm) |
| pfet_06v0 | 1.62 | ≈ 85 nA | 10.5 mV·µm |

Targets: I1 = 100 nA (typical, 27 °C, 3.3 V); M11, the densest device, at IC ≈ 0.1 so that
ΔV_GS = n·U_T·ln K holds (K = 16); σ(I1) ≈ 5 % from local mismatch.

| | 03v3 | 06v0 |
| --- | --- | --- |
| NMOS mirror unit (M11; M10 = 4 units) | 22 µm / 2.2 µm | 24 µm / 3.0 µm |
| PMOS mirror unit (M12; M13 = 4, M14 = 2 units) | 18 µm / 2.8 µm | 24 µm / 4.0 µm |
| Stack devices M15–M22 (4 in series, each) | 2 µm / 20.4 µm | 2 µm / 14.8 µm |
| Kick / disable switches M21–M24 | 1 µm / 1 µm | 1 µm / 1 µm |
| M25 (kick release mirror) | PMOS unit | PMOS unit |
| MOS caps M20, M26 | 8 µm / 2 µm | 8 µm / 4 µm |

Two GF180 specifics shaped the drawing:

- **Multi-unit devices are one instance with `nf` = units, `W` = units × W_unit, `m = 1`.** The GF180
  mismatch subcircuits draw one random sample per instance and scale σ with that instance's own W·L;
  they ignore `m`. With `m = 4` the 4-unit devices would get the σ of a single unit.
- **W ≤ 100 µm per instance** (model bin limit), hence at most 25 µm per unit for the 4-unit devices; the
  06v0 variant gets its area from L instead.

The stack length sets the absolute current and barely touches mismatch or PSRR; the mirror areas set the
mismatch. `scripts/port_from_ihp.py` holds the size table and did the one-time port.

## Results (CACE, schematic netlist, 2026-10-06)

Run in a cloud container with ngspice-42, xschem 3.4.8RC (built from source) and CACE 2.13, against a
gf180mcuD tree assembled from `gf180mcu_fd_pr` at the commit open_pdks pins (`e11a8c9`). Not yet
reproduced in the IIC-OSIC-TOOLS container. Full tables and plots: [`verification/cace/results/`](verification/cace/results/).

| Parameter | Limits | 03v3 | 06v0 |
| --- | --- | --- | --- |
| I1, all corners × temp × vdd | 70 – 130 nA *(placeholder)* | 90.3 – 120.0 nA ✅ | 85.7 – 147.6 nA ❌ (only at 5.0/5.5 V) |
| I1 typical, 27 °C | 100 nA | 100.0 nA | 100.0 nA (115.9 nA at 5 V) |
| t_startup after a 1 µs ramp | typ 20 µs, max 40 µs *(IHP)* | 11.0 – 16.3 µs ✅ | 6.2 – 8.4 µs ✅ |
| core at 90 % on a 1 ms ramp | – | 0.33 – 0.51 ms before the ramp ends | 0.35 – 0.48 ms before |
| PSRR of vbr at 1 kHz | min 50 dB *(IHP)* | 30.7 dB ❌ | 35.2 dB ❌ |
| current noise at 1 Hz | max 1 nA/√Hz *(IHP)* | 0.066 nA/√Hz ✅ | 0.051 nA/√Hz ✅ |
| Iq enabled / disabled | max 2 µA *(placeholder)* / max 20 nA | 0.71 µA / 1.24 nA ✅ | 0.71 µA / 1.27 nA ✅ |
| t_disable | – | 53 ns | 48 ns |
| σ(I1), mismatch MC, 200 runs | ±15 % *(placeholder)* | 4.9 %, extremes ±12.4 % ✅ | 4.5 %, extremes −11.7/+12.3 % ✅ |
| leg matching I2/(4·I1) − 1 | ±6 % *(placeholder)* | mean +2.3 %, σ 1.8 %, max 7.5 % ❌ | mean +2.0 %, σ 1.5 %, max 6.4 % ❌ |

Over the IHP original (47 nA, σ(I1) ≈ 50 %, PSRR 24 dB): the mismatch problem is solved by area, the
current is set where intended, and the temperature drift is small (typical, 3.3 V: 103.1 / 100.0 / 100.1 nA
at −40 / 27 / 85 °C in 03v3, 95.8 / 100.0 / 105.2 nA in 06v0). What is left:

1. **PSRR / line sensitivity.** 15 %/V (03v3) and 7.6 %/V (06v0) on I1. The 2026-09-04 IHP analysis
   (`sg13cmos5l…_sudelbuecher/sudelbuecher/chatlog/2026-09-04_opus_cace_templates_and_oab_sizing.md`)
   applies unchanged: M10, M13 and M14 have drains that follow vdd and the self-biased loop multiplies that by
   about 10. Cascoding them is the fix; it is a topology change and was not made here.
2. **Leg matching** has a systematic +2 % from the different V_DS of M12 and M13 (finite r_o); the spread
   alone would pass. Same cascode fix.
3. **Start-up overshoot.** On a 1 µs supply ramp the kick drives I1 to about 14× nominal (1.4 µA, 03v3,
   ff), and the reference then takes 6–16 µs to settle within 10 %. It always starts, also on 1 ms and
   100 ms ramps (core up once vdd ≈ 1.7–2.3 V). A weaker kick (M21/M22) or a faster release (M25) would
   shorten this.
4. **M26** (vbp bypass) is an NMOS with V_GS ≈ −0.7 V, depleted rather than inverted, as in IHP. A MiM
   capacitor would do the job once the MiM option is confirmed.

## Testbenches and CACE

- `testbenches/xschem/OgueyAebischerRef_<v>_tb_tran.sch`: start-up from a 0 → 3.3 V ramp (1 ms), no
  `.nodeset`. `make sim-all` runs both variants (I1 settles at 100.0 / 99.95 nA).
- `verification/cace/OgueyAebischerRef_<v>.yaml` with six templates each in `verification/cace/templates/`:
  `dc_params` (45 resp. 75 points), `tran_startup_params` (ramps 1 µs and 1 ms), `ac_psrr_params`,
  `noise_params`, `disable_params`, `mm_params` (200 iterations). `make sim-cace [VARIANT=…]`,
  `make sim-cace-all`. 4–6 min per variant on two cores.
- Changes from the IHP deck: GF180 model lines (`sm141064.ngspice <corner>`, mismatch through
  `sw_stat_mismatch`, there is no `*_mismatch` corner); `corner_r` dropped (no resistor); start-up time is
  now the time after the supply ramp until I1 stays within ±10 % of its final value. The IHP measurement
  (vbr crossing 100 mV) fired on ramp coupling, and a 90 %-crossing on I1 fires on displacement current
  through the ammeter. Spec limits the IHP sessions found wrong are marked *placeholder* in the yaml;
  PSRR, noise and start-up limits are the IHP ones.
- Simulation speed: the transient templates use `abstol=1e-13` and an explicit `tmax`. With
  `abstol=1e-15` and the default step limit, single cold-corner runs took minutes for an identical result.

`scripts/gen_cace.py` generated the yaml files and templates; edit those files directly from now on.
`scripts/check_port.py` compares xschem's netlist of the port against the IHP netlist device by device
(`scripts/ihp_reference.spice`), including the sizes in `port_from_ihp.py`:

```sh
cd schematic/xschem
xschem --rcfile xschemrc -n -s -q -x -o /tmp OgueyAebischerRef_03v3.sch
python3 ../../scripts/check_port.py ../../scripts/ihp_reference.spice /tmp/OgueyAebischerRef_03v3.spice 03v3 ../../scripts/port_from_ihp.py
```

## Notes for running it

- CACE 2.13 netlists the DUT with `--tcl "set top_is_subckt 1"`; xschem 3.4.4 (Ubuntu 24.04 package)
  ignores that and writes the top as `**.subckt`, so the testbenches cannot find the DUT. Use xschem ≥ 3.4.8.
- xschem 3.4.4 also rejects the UTF-8 byte-order mark the project's other `xschemrc` files start with;
  3.4.8 accepts it. The files in this macro have none.
- open_pdks ships no `libs.tech/ngspice/spiceinit` for gf180mcuD; CACE warns and runs without one.
- Not done: layout, LVS netlist export, PEX. `layout/{gds,klayout,magic}` are empty.
