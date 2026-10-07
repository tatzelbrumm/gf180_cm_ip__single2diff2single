v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {Template testbench: output current noise - OgueyAebischerRef_06v0} 120 -1030 0 0 0.5 0.5 {}
T {H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 400 -140 0 0 0.3 0.3 {}
T {ngspice .noise needs a voltage output, so the mirrored current is sensed by a noiseless CCVS:
  XMREP   replica of M11 (nfet_06v0 W=24u L=3u), gate on vbn
  VDS     fixed drain voltage, an AC short: all of XMREP's noise current flows in Vsense
  HSENSE  1 V/A CCVS: v(nsense) is numerically the short-circuit output noise current
A resistor would swamp the ~0.1 pA/rtHz device noise with its own thermal noise.
Ibias_noise is the spot density at f_spot (default 1 Hz).} 770 -520 0 0 0.3 0.3 {}
C {devices/code_shown.sym} 20 -880 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents sparse method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15 SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
.option warn=1
.nodeset v(vbp)=2.0
* ngspice .noise does not run with option klu; sparse here only.
* --- output-current sense network (replica of the diode NMOS M11, see note) ---
XMREP ndrep vbn 0 0 nfet_06v0 W=24u L=3u nf=1 m=1
VDS ndsup 0 CACE\{vds_rep=1.0\}
Vsense ndsup ndrep 0
HSENSE nsense 0 Vsense 1
.control
save all
op
noise v(nsense) VDD dec CACE\{noise_pts=10\} CACE\{f_spot=1\} CACE\{fn_stop=100k\}
setplot noise1
* the sweep starts at f_spot, so index 0 is the spot frequency; raw A/rtHz,
* CACE converts to the yaml's nA/rtHz itself
let Ibias_noise = onoise_spectrum[0]
echo $&Ibias_noise > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {devices/code_shown.sym} 20 -990 0 0 {name=MODEL only_toplevel=true
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
C {devices/vsource.sym} 180 -210 0 1 {name=VDD value="dc CACE\{vdd\} ac 1"}
C {devices/gnd.sym} 180 -120 0 0 {name=l1 lab=0}
C {devices/vsource.sym} 260 -210 0 1 {name=Voff value=0}
C {devices/lab_wire.sym} 270 -360 0 0 {name=l6 lab=vdd}
C {devices/lab_wire.sym} 480 -320 0 0 {name=l2 lab=vbp}
C {devices/lab_wire.sym} 480 -300 0 0 {name=l3 lab=vbn}
C {devices/lab_wire.sym} 480 -280 0 0 {name=l4 lab=vbr}
C {devices/title.sym} 160 -40 0 0 {name=l5 author="Christoph Maier"}
