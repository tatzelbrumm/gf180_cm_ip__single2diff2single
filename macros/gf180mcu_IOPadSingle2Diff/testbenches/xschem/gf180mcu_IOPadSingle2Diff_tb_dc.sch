v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 200 -300 370 -300 {lab=pad}
N 200 -300 200 -260 {lab=pad}
N 200 -200 200 -120 {lab=0}
N 430 -300 560 -300 {lab=pad_in}
N 620 -360 620 -400 {lab=vdd}
N 620 -240 620 -120 {lab=0}
N 560 -280 540 -280 {lab=vcm}
N 200 -120 820 -120 {lab=0}
C {devices/vsource.sym} 1000 -250 0 0 {name=Vvdd value=3.3}
C {devices/vsource.sym} 1100 -250 0 0 {name=Vdvdd value=5.0}
C {devices/vsource.sym} 1200 -250 0 0 {name=Vvcm value=1.65}
C {devices/lab_pin.sym} 1000 -280 0 0 {name=l20 lab=vdd}
C {devices/lab_pin.sym} 1100 -280 0 0 {name=l21 lab=dvdd}
C {devices/lab_pin.sym} 1200 -280 0 0 {name=l22 lab=vcm}
C {devices/gnd.sym} 1000 -220 0 0 {name=l23 lab=0}
C {devices/gnd.sym} 1100 -220 0 0 {name=l24 lab=0}
C {devices/gnd.sym} 1200 -220 0 0 {name=l25 lab=0}
C {devices/vsource.sym} 200 -230 0 0 {name=Vpad value="dc 1.65"}
C {devices/gnd.sym} 200 -120 0 0 {name=l2 lab=0}
C {devices/ammeter.sym} 400 -300 3 0 {name=Vin_meas}
C {gf180mcu_IOPadSingle2Diff.sym} 620 -300 0 0 {name=xdut}
C {devices/lab_pin.sym} 620 -400 0 0 {name=l3 lab=vdd}
C {devices/lab_pin.sym} 540 -280 0 0 {name=l4 lab=vcm}
C {devices/lab_pin.sym} 700 -320 0 1 {name=l5 lab=outp}
C {devices/lab_pin.sym} 700 -280 0 1 {name=l6 lab=outn}
C {devices/lab_pin.sym} 280 -300 1 0 {name=l7 lab=pad}
C {gf180mcu_ocd_io/xschem/gf180mcu_ocd_io__asig_5p0.sym} 340 -560 0 0 {name=xpad}
C {devices/lab_pin.sym} 490 -560 0 1 {name=l8 lab=pad}
C {devices/lab_pin.sym} 330 -630 0 0 {name=l9 lab=dvdd}
C {devices/lab_pin.sym} 330 -490 0 0 {name=l10 lab=0}
C {devices/lab_pin.sym} 370 -630 0 1 {name=l11 lab=vdd}
C {devices/lab_pin.sym} 370 -490 0 1 {name=l12 lab=0}
C {devices/title.sym} 160 -40 0 0 {name=l1 author="Christoph Maier"}
C {devices/code_shown.sym} 860 -700 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
save all
dc Vpad -0.5 5.5 0.01
let iin = i(Vin_meas)
wrdata gf180mcu_IOPadSingle2Diff_tb_dc.txt iin v(xdut.in_prot)
meas dc Iin_5v0 find iin at=5.0
meas dc Vprot_5v0 find v(xdut.in_prot) at=5.0
plot iin
plot v(pad) v(xdut.in_prot)
.endc
"}
C {devices/code_shown.sym} 860 -900 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
* harness analog pad cell (open_pdks install of gf180mcu_ocd_io)
.include $env(PDK_ROOT)/$env(PDK)/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
"}
T {DC input sweep through the real analog pad cell gf180mcu_ocd_io__asig_5p0 (HBM diodes to DVDD = 5 V)
into the CDM front end of the macro. Vin_meas = current INTO the macro's in pin.
The pad's own diodes go to DVDD/DVSS; ours go to the 3.3 V vdd, so ours conduct first.} 60 -800 0 0 0.3 0.3 {}
