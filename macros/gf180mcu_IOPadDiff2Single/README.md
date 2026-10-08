# gf180mcu_IOPadDiff2Single

Class-AB differential → single-ended driver for the analog output pad, with its bias tree and enable.
IHP counterpart: `sg13cmos5l_IOPadDiff2Single` (ESD clamps `sg13cmos5l_ClampN15N15`/`ClampP15N15` only, no GF180
equivalent; dropped for now) and the driver of the IHP design notes (`d2s_mpdda`).

**Status (2026-10-08): proof of concept.** Block-level schematic, symbol and CACE suite; no layout.

## Schematic

`schematic/xschem/gf180mcu_IOPadDiff2Single.sch` (written by `scripts/gen_iopad_d2s.py`; edit the sheet from now on):

| instance | cell (macro) | connection |
|---|---|---|
| xref | `BiasRefEnable` (`PadEnable`) | iref → iref_en while enabled; iref_en pulled to vss while disabled |
| xbias | `ClassABBiasIn` (`ClassABBias`) | bias tree and the six diodes, fed by iref_en (5 µA into the pin) |
| xdrv | `ClassABDriver` (`ClassABDriver`) | vinp = inp, vinn = inn, vref, vout = vfb = out: out − vref = (inp − inn)/2 |
| xen | `DriverEnable` (`PadEnable`) | disabled: OP / ON gates to vddo / vsso, vabp / vabn to vdd / vss |
| xinv | `EnableInv` (`PadEnable`) | en_b |

Ports: `vdd vss vddo vsso inp inn vref out iref en`. vddo / vsso are the output-stage rails (OP, ON and their
replicas RP1, RN1); tie them to vdd / vss when the output stage shares the supply. Bias enters as a current (iref),
never as a voltage, so each pad has its own bias tree.

Not included yet: the CDM / ESD network at `out` (on IHP, OP and ON double as the pad's clamps, case (a)); a level
shifter if `en` comes from 1.2 V logic.

## CACE (`verification/cace/`, results in `verification/cace/results/gf180mcu_IOPadDiff2Single/`)

Reference current from a behavioural source on its own supply (5 µA, compliance lost near vdd, 100 MΩ output
resistance), load 1 kΩ to vref ∥ 100 pF. Limits are placeholders. 75 runs, about 8 min on two cores.

| parameter | conditions | result |
|---|---|---|
| gain, enabled | 5 corners × −40/27/125 °C × 3.0/3.3/3.6 V | 0.49934 … 0.50007 |
| offset, enabled | same | 0.013 … 0.78 mV |
| I_Q (OP), enabled, real bias tree | same | 203 … 223 µA |
| Idd (vdd + vddo), enabled | same | 289 … 310 µA (reference current not included) |
| Idd, disabled | 5 corners × 3 temperatures | 0.08 … 2.9 nA |
| OP / ON gate vs its rail, disabled | same | ≤ 1 µV |
| reference current still flowing, disabled | same | ≤ 0.08 nA |
| output glitch at enable (vd = 0) | same | 171 … 489 mV |
| enable time (out within 1 mV) | same | 1.27 … 1.52 µs |

```
cd verification/cace
cace gf180mcu_IOPadDiff2Single.yaml -s schematic --nofail -j 4 --parallel-parameters 1
```

`scripts/gen_cace.py` wrote the yaml and templates. The disabled state is read at the end of a 5 µs transient: with
every current root off most nodes float, and ngspice accepted DC operating points whose supply currents broke KCL
by ~17 µA (in one of 15 runs even at `gmin=1e-12`).

The enable glitch comes from releasing a and b at once while the bias tree is still coming up, as on IHP
(power_down study: 69–300 mV). Staggering the release (bias first, then the output gates) would be the fix.
