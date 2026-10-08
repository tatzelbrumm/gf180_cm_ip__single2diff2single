v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Template: DC line sensitivity - ClassABBiasBGdn} 60 -1000 0 0 0.45 0.45 {}
T {ClassABBiasBGdn alone: iout (5 uA out of the pin) into an NMOS diode 6u/6u like the tree's input diode NI, read as i(Vs).
en = CACE{en} x vdd (1 = enabled), en_b its complement. Errors echoed as fractions (CACE shows a unit of % as 100 x the value).
vdd swept 3.0 ... 3.6 V; sensitivity = (I(3.6) - I(3.0)) / I(3.3) / 0.6 V, in %/V.} 60 -950 0 0 0.25 0.25 {}
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
C {devices/vsource.sym} 160 -100 0 0 {name=Vvdd value="CACE\{vdd\}"}
N 160 -130 160 -150 {lab=vdd}
C {devices/lab_pin.sym} 160 -150 0 1 {name=l6 sig_type=std_logic lab=vdd}
N 160 -70 160 -50 {lab=0}
C {devices/lab_pin.sym} 160 -50 0 1 {name=l7 sig_type=std_logic lab=0}
C {devices/vsource.sym} 280 -100 0 0 {name=Ven value="'CACE\{vdd\}*CACE\{en=1\}'"}
N 280 -130 280 -150 {lab=en}
C {devices/lab_pin.sym} 280 -150 0 1 {name=l8 sig_type=std_logic lab=en}
N 280 -70 280 -50 {lab=0}
C {devices/lab_pin.sym} 280 -50 0 1 {name=l9 sig_type=std_logic lab=0}
C {devices/vsource.sym} 400 -100 0 0 {name=Venb value="'CACE\{vdd\}*(1-CACE\{en=1\})'"}
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
dc Vvdd 3.0 3.6 0.3
let ii = abs(i(Vs))
let s_iout = (ii[2] - ii[0])/ii[1]/0.6
echo $&s_iout > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
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
