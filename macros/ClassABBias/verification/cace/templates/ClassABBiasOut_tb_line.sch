v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Template: DC line sensitivity - ClassABBiasOut} 60 -1000 0 0 0.45 0.45 {}
T {ClassABBiasOut with an ideal reference current CACE{i_ref} out of iref; vddo tied to vdd, vsso to vss.
Bias currents are the drain currents of the six diodes inside the DUT: XBP, XBN, XBPC, XBNC, XRP2, XRN2
(echoed as fractions: CACE shows a unit of % as 100 x the value)
(@m.x1.<dev>.m0[id]); errors in % of 5 / 5 / 2 / 2 / 5 / 5 uA.
vdd = vddo swept 3.0 ... 3.6 V; sensitivity = (I(3.6) - I(3.0)) / I(3.3) / 0.6 V, in %/V.} 60 -950 0 0 0.25 0.25 {}
C {ClassABBiasOut.sym} 700 -400 0 0 {name=x1}
N 620 -580 600 -580 {lab=vdd}
C {devices/lab_pin.sym} 600 -580 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 620 -220 600 -220 {lab=0}
C {devices/lab_pin.sym} 600 -220 0 0 {name=l2 sig_type=std_logic lab=0}
N 780 -580 800 -580 {lab=vdd}
C {devices/lab_pin.sym} 800 -580 0 1 {name=l3 sig_type=std_logic lab=vdd}
N 780 -220 800 -220 {lab=0}
C {devices/lab_pin.sym} 800 -220 0 1 {name=l4 sig_type=std_logic lab=0}
N 560 -400 540 -400 {lab=iref}
C {devices/lab_pin.sym} 540 -400 0 0 {name=l5 sig_type=std_logic lab=iref}
N 840 -500 860 -500 {lab=vbp}
C {devices/lab_pin.sym} 860 -500 0 1 {name=l6 sig_type=std_logic lab=vbp}
N 840 -460 860 -460 {lab=vbn}
C {devices/lab_pin.sym} 860 -460 0 1 {name=l7 sig_type=std_logic lab=vbn}
N 840 -420 860 -420 {lab=vbpc}
C {devices/lab_pin.sym} 860 -420 0 1 {name=l8 sig_type=std_logic lab=vbpc}
N 840 -380 860 -380 {lab=vbnc}
C {devices/lab_pin.sym} 860 -380 0 1 {name=l9 sig_type=std_logic lab=vbnc}
N 840 -340 860 -340 {lab=vabp}
C {devices/lab_pin.sym} 860 -340 0 1 {name=l10 sig_type=std_logic lab=vabp}
N 840 -300 860 -300 {lab=vabn}
C {devices/lab_pin.sym} 860 -300 0 1 {name=l11 sig_type=std_logic lab=vabn}
C {devices/vsource.sym} 160 -100 0 0 {name=Vvdd value="CACE\{vdd\}"}
N 160 -130 160 -150 {lab=vdd}
C {devices/lab_pin.sym} 160 -150 0 1 {name=l12 sig_type=std_logic lab=vdd}
N 160 -70 160 -50 {lab=0}
C {devices/lab_pin.sym} 160 -50 0 1 {name=l13 sig_type=std_logic lab=0}
C {devices/isource.sym} 280 -100 0 0 {name=Iref value="CACE\{i_ref\}"}
N 280 -130 280 -150 {lab=iref}
C {devices/lab_pin.sym} 280 -150 0 1 {name=l14 sig_type=std_logic lab=iref}
N 280 -70 280 -50 {lab=0}
C {devices/lab_pin.sym} 280 -50 0 1 {name=l15 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1200 -760 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15 SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
.control
save all
dc Vvdd 3.0 3.6 0.3
let i_bn = abs(@m.x1.xbn.m0[id])
let s_bn = (i_bn[2] - i_bn[0])/i_bn[1]/0.6
let i_abp = abs(@m.x1.xrp2.m0[id])
let s_abp = (i_abp[2] - i_abp[0])/i_abp[1]/0.6
echo $&s_bn $&s_abp > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
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
