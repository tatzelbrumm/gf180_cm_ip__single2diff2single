v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Template testbench: start-up transient - OgueyAebischerRef_03v3} 120 -960 0 0 0.5 0.5 {}
T {H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 400 -140 0 0 0.3 0.3 {}
T {No .nodeset: VDD ramps from 0 to CACE\{vdd\} in CACE\{tramp\}, and the start-up kick has to
leave the zero-current state unaided. t_startup = time from the END of the ramp until the
core current I1 is within 10 % of its final value (negative: settled during the ramp).
If I1 never gets there the meas fails, nothing is echoed and CACE reports a failure,
which is the correct outcome for a reference that did not start.
IHP version measured vbr crossing 100 mV, which fired on ramp coupling (see 2026-09-04 log).} 600 -330 0 0 0.3 0.3 {}
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
C {devices/code_shown.sym} 20 -790 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents klu method=gear reltol=1e-4 abstol=1e-13 gmin=1e-15 SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
.option warn=1
.control
save all
* tmax = tstop/1000: without it ngspice caps the step at the print step and the
* 200 us settling tail takes minutes (same result to 4 digits)
tran CACE[CACE\{tramp\}/100] CACE[3*CACE\{tramp\}+200e-6] 0 CACE[(3*CACE\{tramp\}+200e-6)/1000]
meas tran Ifinal find v.x1.xbias.vi1#branch at=CACE[0.99*(3*CACE\{tramp\}+200e-6)]
* settling time = last time sample at which I1 is outside +-10 % of its final value.
* (A meas WHEN on the 90 % level fails when I1 is already in the band at the first sample,
* and displacement current through the ammeter crosses that level early in a fast ramp.)
let i1 = v.x1.xbias.vi1#branch
let outside = abs(i1 - Ifinal) gt 0.1*abs(Ifinal)
let t_settle = vecmax(time * outside)
let t_startup = t_settle - CACE\{tramp\}
meas tran Vbp_final find v(vbp) at=CACE[0.99*(3*CACE\{tramp\}+200e-6)]
meas tran Vbn_final find v(vbn) at=CACE[0.99*(3*CACE\{tramp\}+200e-6)]
meas tran Vbr_final find v(vbr) at=CACE[0.99*(3*CACE\{tramp\}+200e-6)]
echo $&t_startup $&Vbp_final $&Vbn_final $&Vbr_final > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {devices/code_shown.sym} 20 -910 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice CACE\{corner_mos\}
* local mismatch on/off (fets_mm subcircuits in sm141064); default off
.param sw_stat_mismatch=CACE\{mm=0\}
"}
C {OgueyAebischerRef_03v3.sym} 360 -300 0 0 {name=x1}
C {devices/vsource.sym} 180 -210 0 1 {name=VDD value="dc CACE\{vdd\} pwl(0 0 CACE\{tramp\} CACE\{vdd\})"}
C {devices/gnd.sym} 180 -120 0 0 {name=l1 lab=0}
C {devices/vsource.sym} 260 -210 0 1 {name=Voff value=0}
C {devices/lab_wire.sym} 270 -360 0 0 {name=l6 lab=vdd}
C {devices/lab_wire.sym} 480 -320 0 0 {name=l2 lab=vbp}
C {devices/lab_wire.sym} 480 -300 0 0 {name=l3 lab=vbn}
C {devices/lab_wire.sym} 480 -280 0 0 {name=l4 lab=vbr}
C {devices/title.sym} 160 -40 0 0 {name=l5 author="Christoph Maier"}
