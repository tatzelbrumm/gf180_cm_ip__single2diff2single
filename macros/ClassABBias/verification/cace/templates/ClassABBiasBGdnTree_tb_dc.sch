v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Template: bias tree fed by the reference - ClassABBiasBGdnTree} 60 -1000 0 0 0.45 0.45 {}
T {ClassABBiasBGdnTree: the reference feeding ClassABBiasIn (iout -> iref, no enable switch in between); vddo tied to vdd, vsso to vss.
Bias currents are the drain currents of the six diodes inside the tree (@m.x1.x2.<dev>.m0[id]); errors in % of 5 / 5 / 2 / 2 / 5 / 5 uA
(echoed as fractions: CACE shows a unit of % as 100 x the value).} 60 -950 0 0 0.25 0.25 {}
C {ClassABBiasBGdnTree.sym} 700 -400 0 0 {name=x1}
N 680 -560 660 -560 {lab=vdd}
C {devices/lab_pin.sym} 660 -560 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 680 -240 660 -240 {lab=0}
C {devices/lab_pin.sym} 660 -240 0 0 {name=l2 sig_type=std_logic lab=0}
N 720 -560 740 -560 {lab=vdd}
C {devices/lab_pin.sym} 740 -560 0 1 {name=l3 sig_type=std_logic lab=vdd}
N 720 -240 740 -240 {lab=0}
C {devices/lab_pin.sym} 740 -240 0 1 {name=l4 sig_type=std_logic lab=0}
N 580 -420 560 -420 {lab=en}
C {devices/lab_pin.sym} 560 -420 0 0 {name=l5 sig_type=std_logic lab=en}
N 580 -380 560 -380 {lab=en_b}
C {devices/lab_pin.sym} 560 -380 0 0 {name=l6 sig_type=std_logic lab=en_b}
N 820 -500 840 -500 {lab=vbp}
C {devices/lab_pin.sym} 840 -500 0 1 {name=l7 sig_type=std_logic lab=vbp}
N 820 -460 840 -460 {lab=vbn}
C {devices/lab_pin.sym} 840 -460 0 1 {name=l8 sig_type=std_logic lab=vbn}
N 820 -420 840 -420 {lab=vbpc}
C {devices/lab_pin.sym} 840 -420 0 1 {name=l9 sig_type=std_logic lab=vbpc}
N 820 -380 840 -380 {lab=vbnc}
C {devices/lab_pin.sym} 840 -380 0 1 {name=l10 sig_type=std_logic lab=vbnc}
N 820 -340 840 -340 {lab=vabp}
C {devices/lab_pin.sym} 840 -340 0 1 {name=l11 sig_type=std_logic lab=vabp}
N 820 -300 840 -300 {lab=vabn}
C {devices/lab_pin.sym} 840 -300 0 1 {name=l12 sig_type=std_logic lab=vabn}
C {devices/vsource.sym} 160 -100 0 0 {name=Vvdd value="CACE\{vdd\}"}
N 160 -130 160 -150 {lab=vdd}
C {devices/lab_pin.sym} 160 -150 0 1 {name=l13 sig_type=std_logic lab=vdd}
N 160 -70 160 -50 {lab=0}
C {devices/lab_pin.sym} 160 -50 0 1 {name=l14 sig_type=std_logic lab=0}
C {devices/vsource.sym} 280 -100 0 0 {name=Ven value="'CACE\{vdd\}*CACE\{en=1\}'"}
N 280 -130 280 -150 {lab=en}
C {devices/lab_pin.sym} 280 -150 0 1 {name=l15 sig_type=std_logic lab=en}
N 280 -70 280 -50 {lab=0}
C {devices/lab_pin.sym} 280 -50 0 1 {name=l16 sig_type=std_logic lab=0}
C {devices/vsource.sym} 400 -100 0 0 {name=Venb value="'CACE\{vdd\}*(1-CACE\{en=1\})'"}
N 400 -130 400 -150 {lab=en_b}
C {devices/lab_pin.sym} 400 -150 0 1 {name=l17 sig_type=std_logic lab=en_b}
N 400 -70 400 -50 {lab=0}
C {devices/lab_pin.sym} 400 -50 0 1 {name=l18 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1200 -760 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents klu method=gear reltol=1e-4 abstol=1e-13 gmin=1e-15 SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
.control
save all
op
let e_bp = (abs(@m.x1.x2.xbp.m0[id])/5e-06 - 1)
let e_bn = (abs(@m.x1.x2.xbn.m0[id])/5e-06 - 1)
let e_bpc = (abs(@m.x1.x2.xbpc.m0[id])/2e-06 - 1)
let e_bnc = (abs(@m.x1.x2.xbnc.m0[id])/2e-06 - 1)
let e_abp = (abs(@m.x1.x2.xrp2.m0[id])/5e-06 - 1)
let e_abn = (abs(@m.x1.x2.xrn2.m0[id])/5e-06 - 1)
let Idd = -i(Vvdd)
echo $&e_bp $&e_bn $&e_bpc $&e_bnc $&e_abp $&e_abn $&Idd > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
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
