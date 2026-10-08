v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Template: loop gain - ClassABDriverBiased} 60 -1000 0 0 0.45 0.45 {}
T {ClassABDriver (x1.xd) on the ideal bias fixture ClassABBiasIdeal (x1.xb): 5 / 5 / 2 / 2 / 5 / 5 uA into the six diodes.
vddo = vdd from its own source, vsso = vss. vref = vdd/2. Stimulus and load: element lines in the NGSPICE block.
Iq: drain currents of OP (x1.xd.xop) and ON (x1.xd.xon) at vd = 0; Idd = vdd + vddo.
Loop broken at vfb: DC closed through 1 GH, AC injected through 1 F; T = -v(vout)/v(fb) (vfb only drives gates).} 60 -950 0 0 0.25 0.25 {}
C {ClassABDriverBiased.sym} 700 -400 0 0 {name=x1}
N 580 -520 560 -520 {lab=vdd}
C {devices/lab_pin.sym} 560 -520 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 580 -280 560 -280 {lab=0}
C {devices/lab_pin.sym} 560 -280 0 0 {name=l2 sig_type=std_logic lab=0}
N 860 -520 880 -520 {lab=vddo}
C {devices/lab_pin.sym} 880 -520 0 1 {name=l3 sig_type=std_logic lab=vddo}
N 860 -280 880 -280 {lab=0}
C {devices/lab_pin.sym} 880 -280 0 1 {name=l4 sig_type=std_logic lab=0}
N 520 -460 500 -460 {lab=vinp}
C {devices/lab_pin.sym} 500 -460 0 0 {name=l5 sig_type=std_logic lab=vinp}
N 520 -420 500 -420 {lab=vinn}
C {devices/lab_pin.sym} 500 -420 0 0 {name=l6 sig_type=std_logic lab=vinn}
N 520 -380 500 -380 {lab=vref}
C {devices/lab_pin.sym} 500 -380 0 0 {name=l7 sig_type=std_logic lab=vref}
N 920 -460 940 -460 {lab=vout}
C {devices/lab_pin.sym} 940 -460 0 1 {name=l8 sig_type=std_logic lab=vout}
N 520 -340 500 -340 {lab=fb}
C {devices/lab_pin.sym} 500 -340 0 0 {name=l9 sig_type=std_logic lab=fb}
N 620 -280 600 -280 {lab=vbp}
C {devices/lab_pin.sym} 600 -280 0 0 {name=l10 sig_type=std_logic lab=vbp}
N 660 -280 640 -280 {lab=vbn}
C {devices/lab_pin.sym} 640 -280 0 0 {name=l11 sig_type=std_logic lab=vbn}
N 700 -280 700 -260 {lab=vbpc}
C {devices/lab_pin.sym} 700 -260 0 1 {name=l12 sig_type=std_logic lab=vbpc}
N 740 -280 760 -280 {lab=vbnc}
C {devices/lab_pin.sym} 760 -280 0 1 {name=l13 sig_type=std_logic lab=vbnc}
N 780 -280 800 -280 {lab=vabp}
C {devices/lab_pin.sym} 800 -280 0 1 {name=l14 sig_type=std_logic lab=vabp}
N 820 -280 840 -280 {lab=vabn}
C {devices/lab_pin.sym} 840 -280 0 1 {name=l15 sig_type=std_logic lab=vabn}
C {devices/vsource.sym} 160 -100 0 0 {name=Vvdd value="CACE\{vdd\}"}
N 160 -130 160 -150 {lab=vdd}
C {devices/lab_pin.sym} 160 -150 0 1 {name=l16 sig_type=std_logic lab=vdd}
N 160 -70 160 -50 {lab=0}
C {devices/lab_pin.sym} 160 -50 0 1 {name=l17 sig_type=std_logic lab=0}
C {devices/vsource.sym} 280 -100 0 0 {name=Vvddo value="CACE\{vdd\}"}
N 280 -130 280 -150 {lab=vddo}
C {devices/lab_pin.sym} 280 -150 0 1 {name=l18 sig_type=std_logic lab=vddo}
N 280 -70 280 -50 {lab=0}
C {devices/lab_pin.sym} 280 -50 0 1 {name=l19 sig_type=std_logic lab=0}
C {devices/vsource.sym} 400 -100 0 0 {name=Vref value="CACE[CACE\{vdd\}/2]"}
N 400 -130 400 -150 {lab=vref}
C {devices/lab_pin.sym} 400 -150 0 1 {name=l20 sig_type=std_logic lab=vref}
N 400 -70 400 -50 {lab=0}
C {devices/lab_pin.sym} 400 -50 0 1 {name=l21 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1200 -760 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-15
Vd dp 0 0
Ep vinp vref dp 0 0.5
En vinn vref dp 0 -0.5
RL vout vref CACE\{rload\}
CL vout 0 CACE\{cload\}
Lb vout fb 1G
Cb fb inj 1
Vinj inj 0 dc 0 ac 1
.control
save all
ac dec 50 10 1G
let T = -v(vout)/v(fb)
meas ac T0 find vdb(T) at=10
meas ac fc when vdb(T)=0
meas ac pT find vp(T) when vdb(T)=0
let pm = 180/pi*pT + 180
echo $&T0 $&fc $&pm > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
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
"}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
