#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
"""
Generate the CACE datasheets and testbench templates of the OgueyAebischerRef_<variant> DUTs.

Port of the IHP sg13cmos5l suite (reference.yaml + six reference_tb_*.sch templates,
RUN_2026-09-04_08-27-47) to gf180mcuD.  What changed besides the PDK lines:

  * MODEL block: design.ngspice + sm141064.ngspice <corner>; mismatch is switched on with
    sw_stat_mismatch (CACE condition mm), there is no separate *_mismatch corner in GF180.
  * corner_r dropped: the circuit has no resistor.
  * start-up: the IHP measurement (vbr crossing 100 mV) fired on supply-ramp coupling, and a
    0.9 V threshold would fire during the ramp as well.  t_startup is now measured on the
    core current itself: time from the END of the supply ramp until I1 is within 10 % of
    its final value (negative = settled before the ramp ended).  A second ramp time (1 ms)
    checks start-up on a slow supply, as with the slow-ramp concern Tim raised for his PoR.
  * spec limits that the IHP sessions identified as wrong (Ibias 200 nA..1 uA, Iq 10/20 uA,
    matching +-2 %/+-1 %) are replaced by placeholders derived from the
    GF180 sizing goals.  They are marked "placeholder" in the yaml and need the designer's
    decision.  PSRR (50 dB), noise and start-up (20/40 us) limits are kept from IHP on purpose;
    the start-up limits now grade a real settling measurement.

After a first run the generated files are the source of truth; edit them, not this script.

Usage: python3 gen_cace.py <macro_dir>
"""
import os, sys, textwrap

VARIANTS = {
    "03v3": dict(vdd=[3.0, 3.3, 3.6], vmax=3.6, nrep="nfet_03v3", Wrep="22u", Lrep="2.2u",
                 desc="3.3 V nfet_03v3/pfet_03v3 devices"),
    "06v0": dict(vdd=[3.0, 3.3, 3.6, 5.0, 5.5], vmax=5.5, nrep="nfet_06v0", Wrep="24u", Lrep="3u",
                 desc="6 V nfet_06v0/pfet_06v0 devices, 3.3 V and 5 V supply"),
}

HDR = "v {xschem version=3.4.4 file_version=1.2}\nG {}\nK {}\nV {}\nS {}\nE {}\n"
REF = """T {H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 400 -140 0 0 0.3 0.3 {}
"""

OPTS = (".options savecurrents klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15 "
        "SEED=CACE[CACE\\{seed=12345\\} + CACE\\{iterations=0\\}]")

def model_block(y=-780):
    return f'''C {{devices/code_shown.sym}} 20 {y} 0 0 {{name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice CACE\\{{corner_mos\\}}
* local mismatch on/off (fets_mm subcircuits in sm141064); default off
.param sw_stat_mismatch=CACE\\{{mm=0\\}}
"}}
'''

def dut(v, vdd_value, dis_src='C {devices/vsource.sym} 260 -210 0 1 {name=Voff value=0}\n', dis_lab='#net1'):
    """DUT with supply source, disable source and labelled outputs (IHP template geometry)."""
    return (f"C {{OgueyAebischerRef_{v}.sym}} 360 -300 0 0 {{name=x1}}\n"
            "N 180 -140 180 -120 {lab=0}\n"
            "N 420 -320 480 -320 {lab=vbp}\nN 420 -300 480 -300 {lab=vbn}\nN 420 -280 480 -280 {lab=vbr}\n"
            f"N 260 -280 300 -280 {{lab={dis_lab}}}\nN 260 -280 260 -240 {{lab={dis_lab}}}\n"
            "N 360 -260 360 -140 {lab=0}\nN 260 -140 360 -140 {lab=0}\nN 180 -180 180 -140 {lab=0}\n"
            "N 260 -180 260 -140 {lab=0}\nN 180 -140 260 -140 {lab=0}\n"
            "N 360 -360 360 -340 {lab=vdd}\nN 180 -360 360 -360 {lab=vdd}\nN 180 -360 180 -240 {lab=vdd}\n"
            f"C {{devices/vsource.sym}} 180 -210 0 1 {{name=VDD value={vdd_value}}}\n"
            "C {devices/gnd.sym} 180 -120 0 0 {name=l1 lab=0}\n"
            + dis_src +
            "C {devices/lab_wire.sym} 270 -360 0 0 {name=l6 lab=vdd}\n"
            "C {devices/lab_wire.sym} 480 -320 0 0 {name=l2 lab=vbp}\n"
            "C {devices/lab_wire.sym} 480 -300 0 0 {name=l3 lab=vbn}\n"
            "C {devices/lab_wire.sym} 480 -280 0 0 {name=l4 lab=vbr}\n"
            "C {devices/title.sym} 160 -40 0 0 {name=l5 author=\"Christoph Maier\"}\n")

def ngspice_block(body, y=-670):
    return f'''C {{devices/code_shown.sym}} 20 {y} 0 0 {{name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\\{{DUT_path\\}}
.temp CACE\\{{temp\\}}
{body}"}}
'''

def title(text, y=-860):
    return f"T {{{text}}} 120 {y} 0 0 0.5 0.5 {{}}\n"

def note(text, x, y):
    return f"T {{{text}}} {x} {y} 0 0 0.3 0.3 {{}}\n"

# --------------------------------------------------------------------------------------
def tb_dc(v):
    body = OPTS + """
.option warn=1
.nodeset v(vbp)=2.0
.control
save all
op
let Vbp_val = v(vbp)
let Vbn_val = v(vbn)
let Vbr_val = v(vbr)
let Ibias_val = v.x1.xbias.vi1#branch
echo $&Vbp_val $&Vbn_val $&Vbr_val $&Ibias_val > CACE\\{simpath\\}/CACE\\{filename\\}_CACE\\{N\\}.data
.endc
"""
    return (HDR + title(f"Template testbench: DC bias point - OgueyAebischerRef_{v}") + REF +
            note("Op point at CACE\\{vdd\\} / CACE\\{temp\\} / CACE\\{corner_mos\\}, disable held low (enabled).\n"
                 "Core reference current I1 = branch current of the ammeter Vi1 inside xbias.\n"
                 ".nodeset only steers the solver away from the zero-current solution;\n"
                 "start-up without help is tested in the tran template.", 600, -260) +
            ngspice_block(body) + model_block() + dut(v, "CACE\\{vdd\\}"))

def tb_tran(v):
    body = OPTS_TRAN + """
.option warn=1
.control
save all
* tmax = tstop/1000: without it ngspice caps the step at the print step and the
* 200 us settling tail takes minutes (same result to 4 digits)
tran CACE[CACE\\{tramp\\}/100] CACE[3*CACE\\{tramp\\}+200e-6] 0 CACE[(3*CACE\\{tramp\\}+200e-6)/1000]
meas tran Ifinal find v.x1.xbias.vi1#branch at=CACE[0.99*(3*CACE\\{tramp\\}+200e-6)]
* settling time = last time sample at which I1 is outside +-10 % of its final value.
* (A meas WHEN on the 90 % level fails when I1 is already in the band at the first sample,
* and displacement current through the ammeter crosses that level early in a fast ramp.)
let i1 = v.x1.xbias.vi1#branch
let outside = abs(i1 - Ifinal) gt 0.1*abs(Ifinal)
let t_settle = vecmax(time * outside)
let t_startup = t_settle - CACE\\{tramp\\}
meas tran Vbp_final find v(vbp) at=CACE[0.99*(3*CACE\\{tramp\\}+200e-6)]
meas tran Vbn_final find v(vbn) at=CACE[0.99*(3*CACE\\{tramp\\}+200e-6)]
meas tran Vbr_final find v(vbr) at=CACE[0.99*(3*CACE\\{tramp\\}+200e-6)]
echo $&t_startup $&Vbp_final $&Vbn_final $&Vbr_final > CACE\\{simpath\\}/CACE\\{filename\\}_CACE\\{N\\}.data
.endc
"""
    return (HDR + title(f"Template testbench: start-up transient - OgueyAebischerRef_{v}") + REF +
            note("No .nodeset: VDD ramps from 0 to CACE\\{vdd\\} in CACE\\{tramp\\}, and the start-up kick has to\n"
                 "leave the zero-current state unaided. t_startup = time from the END of the ramp until the\n"
                 "core current I1 is within 10 % of its final value (negative: settled during the ramp).\n"
                 "If I1 never gets there the meas fails, nothing is echoed and CACE reports a failure,\n"
                 "which is the correct outcome for a reference that did not start.\n"
                 "IHP version measured vbr crossing 100 mV, which fired on ramp coupling (see 2026-09-04 log).",
                 600, -330) +
            ngspice_block(body, -690) + model_block(-810) +
            dut(v, '"dc CACE\\{vdd\\} pwl(0 0 CACE\\{tramp\\} CACE\\{vdd\\})"'))

def tb_ac_psrr(v):
    body = OPTS + """
.option warn=1
.nodeset v(vbp)=2.0
.control
save all
ac dec CACE\\{ac_pts=21\\} CACE\\{fstart=1\\} CACE\\{fstop=1G\\}
* VDD carries AC 1, so v(vbr) is the vdd -> vbr transfer; PSRR = -20 log10 |v(vbr)|
let psrr_vbr_db = -db(v(vbr))
meas ac PSRR_vbr find psrr_vbr_db when frequency = CACE\\{f_psrr=1000\\}
echo $&PSRR_vbr > CACE\\{simpath\\}/CACE\\{filename\\}_CACE\\{N\\}.data
.endc
"""
    return (HDR + title(f"Template testbench: supply rejection (AC) - OgueyAebischerRef_{v}") + REF +
            note("VDD = CACE\\{vdd\\} DC + 1 V AC, so v(vbr) is the supply-to-vbr transfer function.\n"
                 "PSRR is its inverse in dB: a large positive number is good rejection.", 600, -260) +
            ngspice_block(body) + model_block() + dut(v, '"dc CACE\\{vdd\\} ac 1"'))

def tb_noise(v):
    p = VARIANTS[v]
    body = (OPTS.replace(" klu ", " sparse ") + f"""
.option warn=1
.nodeset v(vbp)=2.0
* ngspice .noise does not run with option klu; sparse here only.
* --- output-current sense network (replica of the diode NMOS M11, see note) ---
XMREP ndrep vbn 0 0 {p['nrep']} W={p['Wrep']} L={p['Lrep']} nf=1 m=1
VDS ndsup 0 CACE\\{{vds_rep=1.0\\}}
Vsense ndsup ndrep 0
HSENSE nsense 0 Vsense 1
.control
save all
op
noise v(nsense) VDD dec CACE\\{{noise_pts=10\\}} CACE\\{{f_spot=1\\}} CACE\\{{fn_stop=100k\\}}
setplot noise1
* the sweep starts at f_spot, so index 0 is the spot frequency; raw A/rtHz,
* CACE converts to the yaml's nA/rtHz itself
let Ibias_noise = onoise_spectrum[0]
echo $&Ibias_noise > CACE\\{{simpath\\}}/CACE\\{{filename\\}}_CACE\\{{N\\}}.data
.endc
""")
    return (HDR + title(f"Template testbench: output current noise - OgueyAebischerRef_{v}", -1030) + REF +
            note("ngspice .noise needs a voltage output, so the mirrored current is sensed by a noiseless CCVS:\n"
                 f"  XMREP   replica of M11 ({p['nrep']} W={p['Wrep']} L={p['Lrep']}), gate on vbn\n"
                 "  VDS     fixed drain voltage, an AC short: all of XMREP's noise current flows in Vsense\n"
                 "  HSENSE  1 V/A CCVS: v(nsense) is numerically the short-circuit output noise current\n"
                 "A resistor would swamp the ~0.1 pA/rtHz device noise with its own thermal noise.\n"
                 "Ibias_noise is the spot density at f_spot (default 1 Hz).", 770, -520) +
            ngspice_block(body, -880) + model_block(-990) + dut(v, '"dc CACE\\{vdd\\} ac 1"'))

def tb_disable(v):
    body = OPTS_TRAN + """
.option warn=1
.nodeset v(vbp)=2.0
.control
save all
tran CACE\\{tstep=100n\\} 400u
* supply current drawn = -i(vdd)
meas tran iq_en_raw avg i(vdd) from=1.5e-4 to=1.95e-4
meas tran iq_dis_raw avg i(vdd) from=3.5e-4 to=3.95e-4
let Iq_enabled = -iq_en_raw
let Iq_disabled = -iq_dis_raw
meas tran t_dis_abs when v(vbr)=100m fall=1 td=2e-4
let t_disable = t_dis_abs - 2e-4
echo $&t_disable $&Iq_enabled $&Iq_disabled > CACE\\{simpath\\}/CACE\\{filename\\}_CACE\\{N\\}.data
.endc
"""
    dis = 'C {devices/vsource.sym} 260 -210 0 0 {name=Vdis value="dc 0 pulse(0 CACE\\{vdd\\} 200u 100n 100n 1 2)"}\n'
    dis += "C {devices/lab_wire.sym} 280 -280 0 0 {name=l7 lab=disable}\n"
    return (HDR + title(f"Template testbench: disable / quiescent current - OgueyAebischerRef_{v}", -960) + REF +
            note("VDD fixed at CACE\\{vdd\\}. disable steps 0 -> CACE\\{vdd\\} at 200 us (100 ns edge).\n"
                 "  0..200 us enabled,  Iq_enabled  = average over 150..195 us\n"
                 "  200..400 us disabled, Iq_disabled = average over 350..395 us\n"
                 "t_disable: delay from the edge until vbr falls through 100 mV.\n"
                 "These three times are fixed and must agree with each other.", 600, -560) +
            ngspice_block(body, -890) + model_block(-1010) +
            dut(v, "CACE\\{vdd\\}", dis_src=dis, dis_lab="disable"))

def tb_dc_mm(v):
    body = OPTS + """
.option warn=1
.nodeset v(vbp)=2.0
.control
save all
op
let I1 = v.x1.xbias.vi1#branch
let I2 = v.x1.xbias.vi4#branch
let ibias_nom = CACE\\{ibias_nom=1.0e-7\\}
* raw fractions; CACE converts to the yaml's % for display
let Ibias_accuracy = (I1 - ibias_nom) / ibias_nom
* PMOS mirror ratio M12:M13 = 1:4, so I2 should be 4*I1
let Leg_matching = (I2 / (4 * I1) - 1)
echo $&Ibias_accuracy $&Leg_matching > CACE\\{simpath\\}/CACE\\{filename\\}_CACE\\{N\\}.data
.endc
"""
    return (HDR + title(f"Template testbench: mismatch Monte Carlo - OgueyAebischerRef_{v}", -890) + REF +
            note("Same op point as the DC template, run with mm=1 (sw_stat_mismatch) and collate: iterations;\n"
                 "the per-iteration seed comes from SEED=seed+iterations.\n"
                 "GF180 mismatch (fets_mm) draws one sample per INSTANCE and scales sigma with that\n"
                 "instance's W*L; it ignores m. The multi-unit mirror devices are therefore drawn as one\n"
                 "instance with nf=units, W=units*Wunit. Run on the schematic netlist only.\n"
                 "ibias_nom = 100 nA is the design target (typical, 27 C, 3.3 V), not a measured value.", 400, -560) +
            ngspice_block(body) + model_block() + dut(v, "CACE\\{vdd\\}"))

OPTS_TRAN = OPTS.replace("abstol=1e-15", "abstol=1e-13")
# abstol 1e-15 makes the cold (-40 C) start-up transient ~30x slower for the same result
# (I1 identical to 7 digits); 0.1 pA is still 1e-6 of the 100 nA core current.

TEMPLATES = {"dc": tb_dc, "tran": tb_tran, "ac_psrr": tb_ac_psrr, "noise": tb_noise,
             "tran_disable": tb_disable, "dc_mm": tb_dc_mm}

# --------------------------------------------------------------------------------------
def yaml(v):
    p = VARIANTS[v]
    vdds = ", ".join(str(x) for x in p["vdd"])
    vmin = min(p["vdd"])
    return textwrap.dedent(f"""\
    # SPDX-FileCopyrightText: 2026 Christoph Maier
    # SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
    #
    #--------------------------------------------------------------
    # CACE circuit characterization file
    # Port of the IHP sg13cmos5l OgueyAebischerBias "reference" deck to gf180mcuD.
    # Generated by ../../scripts/gen_cace.py on 2026-10-06; edit this file from now on.
    #--------------------------------------------------------------

    name:           OgueyAebischerRef_{v}
    description:    Oguey-Aebischer resistor-free current reference + start-up kick, GF180MCU, {p['desc']}
    PDK:            gf180mcuD

    cace_format:    5.2

    authorship:
      designer:         Christoph Maier
      creation_date:    October 6, 2026
      license:          Apache-2.0 WITH SHL-2.1

    paths:
      root:             ..
      schematic:        ../schematic/xschem
      netlist:          cace/netlist
      documentation:    cace/_docs
      runs:             cace/_runs

    pins:
      vdd:
        description: Positive analog power supply
        type: power
        direction: inout
        Vmin: {vmin}
        Vmax: {p['vmax']}
      vss:
        description: Analog ground
        type: ground
        direction: inout
      vbp:
        description: PMOS current-mirror bias voltage (to downstream PMOS legs)
        type: signal
        direction: output
      vbn:
        description: NMOS current-mirror bias voltage (to downstream NMOS legs)
        type: signal
        direction: output
      vbr:
        description: Resistor-free reference node (gates of the MOS triode stack)
        type: signal
        direction: output
      disable:
        description: Active-high shutdown of the core and the start-up kick
        type: digital
        direction: input

    default_conditions:
      vdd:
        description: Analog power supply voltage
        display: VDD
        unit: V
        typical: 3.3
      corner_mos:
        description: Process corner MOSFET (sm141064.ngspice section)
        display: Corner MOSFET
        typical: typical
      mm:
        description: Local mismatch switch (sw_stat_mismatch)
        display: Mismatch
        typical: 0
      temp:
        description: Ambient temperature
        display: Temperature
        unit: °C
        typical: 27

    parameters:
      dc_params:
        spec:
          Vbp_val:
            display: PMOS mirror bias voltage
            description: Operating point of vbp
            unit: V
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: any}}
          Vbn_val:
            display: NMOS mirror bias voltage
            description: Operating point of vbn
            unit: V
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: any}}
          Vbr_val:
            display: Resistor-free reference voltage
            description: Operating point of vbr
            unit: V
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: any}}
          Ibias_val:
            display: Core reference current
            description: Current in the M12/M10 branch (ammeter Vi1). Limits are placeholders around the 100 nA target.
            unit: nA
            minimum: {{value: 70}}
            typical: {{value: 100}}
            maximum: {{value: 130}}
        tool:
          ngspice:
            template: OgueyAebischerRef_{v}_tb_dc.sch
            format: ascii
            suffix: .data
            variables: [Vbp_val, Vbn_val, Vbr_val, Ibias_val]
        plot:
          Ibias_vs_vdd:
            type: xyplot
            xaxis: vdd
            yaxis: Ibias_val
            limits: auto
          Ibias_vs_temp:
            type: xyplot
            xaxis: temp
            yaxis: Ibias_val
            limits: auto
          Ibias_vs_corner_mos:
            type: xyplot
            xaxis: corner_mos
            yaxis: Ibias_val
            limits: auto
          Vbr_vs_vdd:
            type: xyplot
            xaxis: vdd
            yaxis: Vbr_val
            limits: auto
        conditions:
          vdd:
            enumerate: [{vdds}]
          corner_mos:
            enumerate: [typical, ss, sf, fs, ff]
          temp:
            enumerate: [-40, 27, 85]

      tran_startup_params:
        spec:
          t_startup:
            display: Start-up time
            description: End of the supply ramp until I1 stays within 10 % of its final value (negative = settled during the ramp). Limits are the IHP deck's.
            unit: us
            minimum: {{value: any}}
            typical: {{value: 20}}
            maximum: {{value: 40}}
          Vbp_final:
            display: Settled vbp
            description: vbp at the end of the transient
            unit: V
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: any}}
          Vbn_final:
            display: Settled vbn
            description: vbn at the end of the transient
            unit: V
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: any}}
          Vbr_final:
            display: Settled vbr
            description: vbr at the end of the transient
            unit: V
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: any}}
        tool:
          ngspice:
            template: OgueyAebischerRef_{v}_tb_tran.sch
            format: ascii
            suffix: .data
            variables: [t_startup, Vbp_final, Vbn_final, Vbr_final]
        plot:
          t_startup_vs_corner_mos:
            type: xyplot
            xaxis: corner_mos
            yaxis: t_startup
            limits: auto
          t_startup_vs_temp:
            type: xyplot
            xaxis: temp
            yaxis: t_startup
            limits: auto
        conditions:
          vdd:
            typical: 3.3
          tramp:
            description: Supply ramp time 0 -> vdd
            display: Ramp
            unit: s
            enumerate: [1e-6, 1e-3]
          corner_mos:
            enumerate: [typical, ss, sf, fs, ff]
          temp:
            enumerate: [-40, 27, 85]

      ac_psrr_params:
        spec:
          PSRR_vbr:
            display: PSRR of vbr at 1 kHz
            description: -20 log10 |v(vbr)/v(vdd)| at f_psrr. Limits kept from the IHP deck.
            unit: dB
            minimum: {{value: 50}}
            typical: {{value: 60}}
            maximum: {{value: any}}
        tool:
          ngspice:
            template: OgueyAebischerRef_{v}_tb_ac_psrr.sch
            format: ascii
            suffix: .data
            variables: [PSRR_vbr]
        conditions:
          vdd:
            typical: 3.3
          corner_mos:
            typical: typical
          temp:
            typical: 27

      noise_params:
        spec:
          Ibias_noise:
            display: Output current noise density
            description: Spot noise of the mirrored current (replica of M11) at f_spot. Limits kept from the IHP deck (inherited from sky130).
            unit: nA/rtHz
            minimum: {{value: any}}
            typical: {{value: 0.5}}
            maximum: {{value: 1}}
        tool:
          ngspice:
            template: OgueyAebischerRef_{v}_tb_noise.sch
            format: ascii
            suffix: .data
            variables: [Ibias_noise]
        conditions:
          vdd:
            typical: 3.3
          corner_mos:
            typical: typical
          temp:
            typical: 27

      disable_params:
        spec:
          t_disable:
            display: Turn-off time
            description: disable edge until vbr falls through 100 mV
            unit: ns
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: any}}
          Iq_enabled:
            display: Quiescent supply current, enabled
            description: Average supply current, enabled. Limit is a placeholder (about 8 x I1 by construction).
            unit: uA
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: 2}}
          Iq_disabled:
            display: Quiescent supply current, disabled
            description: Average supply current, disabled
            unit: nA
            minimum: {{value: any}}
            typical: {{value: 10}}
            maximum: {{value: 20}}
        tool:
          ngspice:
            template: OgueyAebischerRef_{v}_tb_tran_disable.sch
            format: ascii
            suffix: .data
            variables: [t_disable, Iq_enabled, Iq_disabled]
        conditions:
          vdd:
            typical: 3.3
          corner_mos:
            typical: typical
          temp:
            typical: 27

      mm_params:
        spec:
          Ibias_accuracy:
            display: Core current accuracy - Mismatch
            description: (I1 - 100 nA) / 100 nA under local mismatch. Limits are placeholders (3 sigma of a 5 % design goal).
            unit: '%'
            minimum: {{value: -15}}
            typical: {{value: 0}}
            maximum: {{value: 15}}
          Leg_matching:
            display: Leg-to-leg current matching - Mismatch
            description: I2 / (4 I1) - 1, the 1:4 PMOS mirror M12:M13. Limits are placeholders.
            unit: '%'
            minimum: {{value: -6}}
            typical: {{value: 0}}
            maximum: {{value: 6}}
        tool:
          ngspice:
            template: OgueyAebischerRef_{v}_tb_dc_mm.sch
            collate: iterations
            format: ascii
            suffix: .data
            variables: [Ibias_accuracy, Leg_matching]
        conditions:
          vdd:
            typical: 3.3
          iterations:
            description: Iterations to run
            display: Iterations
            minimum: 1
            maximum: 200
            step: linear
            stepsize: 1
          corner_mos:
            typical: typical
          mm:
            typical: 1
          temp:
            typical: 27
    """)

TPL_XSCHEMRC = r'''# Set default PDK_ROOT
if { ![info exists env(PDK_ROOT)] } {
  puts stderr "Warning: PDK_ROOT env. var. not found or empty, trying to find an open_pdks install"
  if {[file isdir /usr/share/pdk]} {set ::env(PDK_ROOT) /usr/share/pdk
  } elseif {[file isdir /usr/local/share/pdk]} {set ::env(PDK_ROOT) /usr/local/share/pdk
  } elseif {[file isdir $env(HOME)/share/pdk]} {set ::env(PDK_ROOT) $env(HOME)/share/pdk
  } elseif {[file isdir $env(HOME)/.ciel]} {set ::env(PDK_ROOT) $env(HOME)/.ciel
  } elseif {[file isdir $env(HOME)/.volare]} {set ::env(PDK_ROOT) $env(HOME)/.volare
  } else {
    puts stderr {No open_pdks installation found, set PDK_ROOT env. var. and restart xschem}
  }
}

# Set default PDK
if { ![info exists env(PDK)] } {
  set ::env(PDK) gf180mcuD
}

# Source the PDK xschemrc file
if {![info exists PDK]} {
    source $env(PDK_ROOT)/$env(PDK)/libs.tech/xschem/xschemrc
}

# Append a library path only if not already present.
if {![llength [info commands append_xschem_library_path_unique]]} {
  proc append_xschem_library_path_unique {path} {
    set normalized [file normalize $path]
    if {![info exists ::XSCHEM_LIBRARY_PATH]} {
      set ::XSCHEM_LIBRARY_PATH $normalized
      return
    }
    set entries [split $::XSCHEM_LIBRARY_PATH :]
    if {[lsearch -exact $entries $normalized] < 0} {
      if {$::XSCHEM_LIBRARY_PATH eq ""} {
        set ::XSCHEM_LIBRARY_PATH $normalized
      } else {
        append ::XSCHEM_LIBRARY_PATH :$normalized
      }
    }
  }
}

# Add current directory to xschem library path
append_xschem_library_path_unique [file dirname [info script]]

# Source project xschemrc
source [file normalize [file join [file dirname [info script]] ../../../schematic/xschem/xschemrc]]

# Pin the netlist directory to the simulations folder of the loaded schematic
if {![llength [info commands pin_netlist_dir]]} {
  proc pin_netlist_dir {dir} {
    set dir [file normalize $dir]
    if {[string match */schematic/xschem $dir]} {
      set dir [file join $dir ../../testbenches/xschem]
    } elseif {![string match */testbenches/xschem $dir] && ![string match */cace/templates $dir]} {
      return
    }
    set ::netlist_dir [file normalize [file join $dir simulations]]
  }
}
pin_netlist_dir [file dirname [info script]]
set load_file_postprocess {pin_netlist_dir [xschem get current_dirname]}
'''

def main(macro):
    tdir = os.path.join(macro, "verification/cace/templates")
    os.makedirs(tdir, exist_ok=True)
    open(os.path.join(tdir, "xschemrc"), "w").write(TPL_XSCHEMRC)
    for v in VARIANTS:
        for k, f in TEMPLATES.items():
            fn = os.path.join(tdir, f"OgueyAebischerRef_{v}_tb_{k}.sch")
            open(fn, "w").write(f(v)); print("wrote", fn)
        fn = os.path.join(macro, "verification/cace", f"OgueyAebischerRef_{v}.yaml")
        open(fn, "w").write(yaml(v)); print("wrote", fn)

if __name__ == "__main__":
    main(sys.argv[1])
