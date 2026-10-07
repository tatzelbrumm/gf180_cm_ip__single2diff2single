v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {Template testbench: mismatch Monte Carlo - OgueyAebischerRef_06v0} 120 -890 0 0 0.5 0.5 {}
T {H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 400 -140 0 0 0.3 0.3 {}
T {Same op point as the DC template, run with mm=1 (sw_stat_mismatch) and collate: iterations;
the per-iteration seed comes from SEED=seed+iterations.
GF180 mismatch (fets_mm) draws one sample per INSTANCE and scales sigma with that
instance's W*L; it ignores m. The multi-unit mirror devices are therefore drawn as one
instance with nf=units, W=units*Wunit. Run on the schematic netlist only.
ibias_nom = 100 nA is the design target (typical, 27 C, 3.3 V), not a measured value.} 400 -560 0 0 0.3 0.3 {}
C {devices/code_shown.sym} 20 -670 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15 SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
.option warn=1
.nodeset v(vbp)=2.0
.control
save all
op
let I1 = v.x1.xbias.vi1#branch
let I2 = v.x1.xbias.vi4#branch
let ibias_nom = CACE\{ibias_nom=1.0e-7\}
* raw fractions; CACE converts to the yaml's % for display
let Ibias_accuracy = (I1 - ibias_nom) / ibias_nom
* PMOS mirror ratio M12:M13 = 1:4, so I2 should be 4*I1
let Leg_matching = (I2 / (4 * I1) - 1)
echo $&Ibias_accuracy $&Leg_matching > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {devices/code_shown.sym} 20 -780 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice CACE\{corner_mos\}
* local mismatch on/off (fets_mm subcircuits in sm141064); default off
.param sw_stat_mismatch=CACE\{mm=0\}
"}
C {OgueyAebischerRef_06v0.sym} 360 -300 0 0 {name=x1}
N 180 -140 180 -120 {lab=0}
N 420 -320 480 -320 {lab=vbp}
N 420 -300 480 -300 {lab=vbn}
N 420 -280 480 -280 {lab=vbr}
N 260 -280 300 -280 {lab=#net1}
N 260 -280 260 -240 {lab=#net1}
N 360 -260 360 -140 {lab=0}
N 260 -140 360 -140 {lab=0}
N 180 -180 180 -140 {lab=0}
N 260 -180 260 -140 {lab=0}
N 180 -140 260 -140 {lab=0}
N 360 -360 360 -340 {lab=vdd}
N 180 -360 360 -360 {lab=vdd}
N 180 -360 180 -240 {lab=vdd}
C {devices/vsource.sym} 180 -210 0 1 {name=VDD value=CACE\{vdd\}}
C {devices/gnd.sym} 180 -120 0 0 {name=l1 lab=0}
C {devices/vsource.sym} 260 -210 0 1 {name=Voff value=0}
C {devices/lab_wire.sym} 270 -360 0 0 {name=l6 lab=vdd}
C {devices/lab_wire.sym} 480 -320 0 0 {name=l2 lab=vbp}
C {devices/lab_wire.sym} 480 -300 0 0 {name=l3 lab=vbn}
C {devices/lab_wire.sym} 480 -280 0 0 {name=l4 lab=vbr}
C {devices/title.sym} 160 -40 0 0 {name=l5 author="Christoph Maier"}
