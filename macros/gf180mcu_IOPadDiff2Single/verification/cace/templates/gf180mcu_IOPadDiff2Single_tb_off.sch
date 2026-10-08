v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Template: disabled state - gf180mcu_IOPadDiff2Single} 60 -1000 0 0 0.45 0.45 {}
T {gf180mcu_IOPadDiff2Single (x1): bias tree x1.xbias fed through x1.xref from iref, driver x1.xdrv (vfb = out),
enable switches x1.xen, inverter x1.xinv. vddo = vdd from its own source, vsso = vss, vref = vdd/2.
Bref, Rref, Vsup (NGSPICE block): reference current CACE{i_ref} into iref from a separate vsup = vdd, compliance lost near vsup.
Stimulus inp - vref = vd/2, inn - vref = -vd/2; load CACE{rload} to vref || CACE{cload}.
en = 0: OP / ON gates a, b held at vddo / vsso; Read at the end of a 5 us transient (the DC operating point of the switched-off circuit is not reliable).
Idd = vdd + vddo; iref_off = current still delivered by the reference source.} 60 -950 0 0 0.25 0.25 {}
C {gf180mcu_IOPadDiff2Single.sym} 700 -400 0 0 {name=x1}
N 680 -540 660 -540 {lab=vdd}
C {devices/lab_pin.sym} 660 -540 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 680 -260 660 -260 {lab=0}
C {devices/lab_pin.sym} 660 -260 0 0 {name=l2 sig_type=std_logic lab=0}
N 720 -540 740 -540 {lab=vddo}
C {devices/lab_pin.sym} 740 -540 0 1 {name=l3 sig_type=std_logic lab=vddo}
N 720 -260 740 -260 {lab=0}
C {devices/lab_pin.sym} 740 -260 0 1 {name=l4 sig_type=std_logic lab=0}
N 580 -480 560 -480 {lab=inp}
C {devices/lab_pin.sym} 560 -480 0 0 {name=l5 sig_type=std_logic lab=inp}
N 580 -440 560 -440 {lab=inn}
C {devices/lab_pin.sym} 560 -440 0 0 {name=l6 sig_type=std_logic lab=inn}
N 580 -400 560 -400 {lab=vref}
C {devices/lab_pin.sym} 560 -400 0 0 {name=l7 sig_type=std_logic lab=vref}
N 820 -400 840 -400 {lab=out}
C {devices/lab_pin.sym} 840 -400 0 1 {name=l8 sig_type=std_logic lab=out}
N 580 -360 560 -360 {lab=iref}
C {devices/lab_pin.sym} 560 -360 0 0 {name=l9 sig_type=std_logic lab=iref}
N 580 -320 560 -320 {lab=en}
C {devices/lab_pin.sym} 560 -320 0 0 {name=l10 sig_type=std_logic lab=en}
C {devices/vsource.sym} 160 -100 0 0 {name=Vvdd value="CACE\{vdd\}"}
N 160 -130 160 -150 {lab=vdd}
C {devices/lab_pin.sym} 160 -150 0 1 {name=l11 sig_type=std_logic lab=vdd}
N 160 -70 160 -50 {lab=0}
C {devices/lab_pin.sym} 160 -50 0 1 {name=l12 sig_type=std_logic lab=0}
C {devices/vsource.sym} 280 -100 0 0 {name=Vvddo value="CACE\{vdd\}"}
N 280 -130 280 -150 {lab=vddo}
C {devices/lab_pin.sym} 280 -150 0 1 {name=l13 sig_type=std_logic lab=vddo}
N 280 -70 280 -50 {lab=0}
C {devices/lab_pin.sym} 280 -50 0 1 {name=l14 sig_type=std_logic lab=0}
C {devices/vsource.sym} 400 -100 0 0 {name=Vref value="CACE[CACE\{vdd\}/2]"}
N 400 -130 400 -150 {lab=vref}
C {devices/lab_pin.sym} 400 -150 0 1 {name=l15 sig_type=std_logic lab=vref}
N 400 -70 400 -50 {lab=0}
C {devices/lab_pin.sym} 400 -50 0 1 {name=l16 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1200 -760 0 0 {name=NGSPICE
simulator=ngspice
only_toplevel=false
value="
.include CACE\{DUT_path\}
.temp CACE\{temp\}
.options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-12
Ven en 0 CACE\{en_v\}
Vd dp 0 0
Vsup vsup 0 CACE\{vdd\}
Bref vsup iref I=CACE\{i_ref\}*tanh(max(v(vsup,iref),0)/0.1)
Rref vsup iref 100Meg
Ep inp vref dp 0 0.5
En inn vref dp 0 -0.5
RL out vref CACE\{rload\}
CL out 0 CACE\{cload\}
.control
save all
tran 10n 5u
meas tran i1 find i(Vvdd) at=5u
meas tran i2 find i(Vvddo) at=5u
meas tran vo1 find v(vddo) at=5u
meas tran va1 find v(x1.a) at=5u
meas tran vb find v(x1.b) at=5u
meas tran vout1 find v(out) at=5u
meas tran vref1 find v(vref) at=5u
meas tran vn find v(x1.iref_en) at=5u
meas tran ir find i(Vsup) at=5u
let idd_off = -i1 - i2
let va_off = vo1 - va1
let vb_off = vb
let vout_off = vout1 - vref1
let iref_n = vn
let iref_off = -ir
echo $&idd_off $&va_off $&vb_off $&vout_off $&iref_n $&iref_off > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
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
