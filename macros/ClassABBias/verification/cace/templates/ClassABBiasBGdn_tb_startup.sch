v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Template: start-up - ClassABBiasBGdn} 60 -1000 0 0 0.45 0.45 {}
T {ClassABBiasBGdn alone, NI-type diode load. vdd and en ramp from 0 V to CACE{vdd} in CACE{t_ramp}; all nodes start at 0 V (uic), no .nodeset.
t_startup = last time iout is outside +-10 % of its value 1 ms after the ramp, minus the ramp time (negative: settled before the ramp ends);
e_end = that final value's deviation from 5 uA.} 60 -950 0 0 0.25 0.25 {}
C {ClassABBiasBGdn.sym} 700 -400 0 0 {name=x1}
N 700 -480 700 -500 {lab=vdd}
C {devices/lab_pin.sym} 700 -500 0 1 {name=l1 sig_type=std_logic lab=vdd}
N 700 -320 700 -300 {lab=0}
C {devices/lab_pin.sym} 700 -300 0 1 {name=l2 sig_type=std_logic lab=0}
N 820 -400 840 -400 {lab=iout}
C {devices/lab_pin.sym} 840 -400 0 1 {name=l3 sig_type=std_logic lab=iout}
N 580 -420 560 -420 {lab=en}
C {devices/lab_pin.sym} 560 -420 0 0 {name=l4 sig_type=std_logic lab=en}
N 580 -380 560 -380 {lab=en_b}
C {devices/lab_pin.sym} 560 -380 0 0 {name=l5 sig_type=std_logic lab=en_b}
C {devices/vsource.sym} 160 -100 0 0 {name=Vvdd value="pwl(0 0 CACE\{t_ramp\} CACE\{vdd\})"}
N 160 -130 160 -150 {lab=vdd}
C {devices/lab_pin.sym} 160 -150 0 1 {name=l6 sig_type=std_logic lab=vdd}
N 160 -70 160 -50 {lab=0}
C {devices/lab_pin.sym} 160 -50 0 1 {name=l7 sig_type=std_logic lab=0}
C {devices/vsource.sym} 280 -100 0 0 {name=Ven value="pwl(0 0 CACE\{t_ramp\} CACE\{vdd\})"}
N 280 -130 280 -150 {lab=en}
C {devices/lab_pin.sym} 280 -150 0 1 {name=l8 sig_type=std_logic lab=en}
N 280 -70 280 -50 {lab=0}
C {devices/lab_pin.sym} 280 -50 0 1 {name=l9 sig_type=std_logic lab=0}
C {devices/vsource.sym} 400 -100 0 0 {name=Venb value="0"}
N 400 -130 400 -150 {lab=en_b}
C {devices/lab_pin.sym} 400 -150 0 1 {name=l10 sig_type=std_logic lab=en_b}
N 400 -70 400 -50 {lab=0}
C {devices/lab_pin.sym} 400 -50 0 1 {name=l11 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1200 -760 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents klu method=gear reltol=1e-4 abstol=1e-13 gmin=1e-15 SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
Vs iout s 0
XNI s s 0 0 nfet_03v3 L=6u W=6u nf=1
.control
save all
let tend = CACE\{t_ramp\} + 1e-3
tran CACE[CACE\{t_ramp\}/1000] CACE[CACE\{t_ramp\} + 1e-3] 0 CACE[CACE\{t_ramp\}/200] uic
let ii = abs(i(Vs))
meas tran ifin find ii at=CACE[CACE\{t_ramp\} + 1e-3]
let lo = 0.9*ifin
let hi = 1.1*ifin
meas tran tlo when ii=lo cross=last
meas tran thi when ii=hi cross=last
let tl = tlo
let th = thi
if tl < 0
  let tl = 0
end
if th < 0
  let th = 0
end
let tmax = tl
if th > tl
  let tmax = th
end
let t_startup = tmax - CACE\{t_ramp\}
let e_end = (ifin/5e-6 - 1)
echo $&t_startup $&e_end > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
"}
C {devices/code_shown.sym} 1200 -900 0 0 {name=MODEL
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice CACE\{corner_mos\}
.lib $::180MCU_MODELS/sm141064.ngspice CACE\{corner_res=res_typical\}
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.param sw_stat_mismatch=CACE\{mm=0\}
.lib $::180MCU_MODELS/sm141064.ngspice CACE\{corner_bjt=bjt_typical\}
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
"}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
