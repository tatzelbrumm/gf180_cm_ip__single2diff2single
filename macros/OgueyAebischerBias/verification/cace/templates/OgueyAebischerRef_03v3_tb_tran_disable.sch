v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {Template testbench: disable / quiescent current - OgueyAebischerRef_03v3} 120 -960 0 0 0.5 0.5 {}
T {H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 400 -140 0 0 0.3 0.3 {}
T {VDD fixed at CACE\{vdd\}. disable steps 0 -> CACE\{vdd\} at 200 us (100 ns edge).
  0..200 us enabled,  Iq_enabled  = average over 150..195 us
  200..400 us disabled, Iq_disabled = average over 350..395 us
t_disable: delay from the edge until vbr falls through 100 mV.
These three times are fixed and must agree with each other.} 600 -560 0 0 0.3 0.3 {}
C {devices/code_shown.sym} 20 -890 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents klu method=gear reltol=1e-4 abstol=1e-13 gmin=1e-15 SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
.option warn=1
.nodeset v(vbp)=2.0
.control
save all
tran CACE\{tstep=100n\} 400u
* supply current drawn = -i(vdd)
meas tran iq_en_raw avg i(vdd) from=1.5e-4 to=1.95e-4
meas tran iq_dis_raw avg i(vdd) from=3.5e-4 to=3.95e-4
let Iq_enabled = -iq_en_raw
let Iq_disabled = -iq_dis_raw
meas tran t_dis_abs when v(vbr)=100m fall=1 td=2e-4
let t_disable = t_dis_abs - 2e-4
echo $&t_disable $&Iq_enabled $&Iq_disabled > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {devices/code_shown.sym} 20 -1010 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice CACE\{corner_mos\}
* local mismatch on/off (fets_mm subcircuits in sm141064); default off
.param sw_stat_mismatch=CACE\{mm=0\}
"}
C {OgueyAebischerRef_03v3.sym} 360 -300 0 0 {name=x1}
N 180 -140 180 -120 {lab=0}
N 420 -320 480 -320 {lab=vbp}
N 420 -300 480 -300 {lab=vbn}
N 420 -280 480 -280 {lab=vbr}
N 260 -280 300 -280 {lab=disable}
N 260 -280 260 -240 {lab=disable}
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
C {devices/vsource.sym} 260 -210 0 0 {name=Vdis value="dc 0 pulse(0 CACE\{vdd\} 200u 100n 100n 1 2)"}
C {devices/lab_wire.sym} 280 -280 0 0 {name=l7 lab=disable}
C {devices/lab_wire.sym} 270 -360 0 0 {name=l6 lab=vdd}
C {devices/lab_wire.sym} 480 -320 0 0 {name=l2 lab=vbp}
C {devices/lab_wire.sym} 480 -300 0 0 {name=l3 lab=vbn}
C {devices/lab_wire.sym} 480 -280 0 0 {name=l4 lab=vbr}
C {devices/title.sym} 160 -40 0 0 {name=l5 author="Christoph Maier"}
