v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
E {}
T {TGate: on-resistance of a 4u/0.5u gate (10 mV across a <-> b, swept 0 ... 3.29 V), off-state leakage. 2026-10-09} 0 -200 0 0 0.3 0.3 {}
C {TGate.sym} 300 0 0 0 {name=x1 VDD=vdd VSS=0 W_N=4u L_N=0.5u W_P=4u L_P=0.5u}
C {devices/lab_pin.sym} 260 0 0 0 {name=l1 lab=va}
C {devices/lab_pin.sym} 340 0 0 1 {name=l2 lab=vb}
C {devices/lab_pin.sym} 300 40 0 0 {name=l3 lab=en}
C {devices/lab_pin.sym} 300 -40 0 0 {name=l4 lab=en_b}
C {devices/vsource.sym} 0 100 0 0 {name=Vdd value=3.3}
C {devices/lab_pin.sym} 0 70 0 0 {name=l5 lab=vdd}
C {devices/gnd.sym} 0 130 0 0 {name=l6 lab=0}
C {devices/code_shown.sym} 0 200 0 0 {name=MODELS only_toplevel=true format="tcleval( @value )" value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
Ven en 0 3.3
Venb en_b 0 0
Va va 0 0
Vb vb va 0.01
.dc Va 0 3.29 0.01
.control
run
let ron = 0.01/(-i(Vb))
meas dc ronmax max ron
meas dc ron_mid find ron at=1.65
meas dc ron_0 find ron at=0
alter Ven dc=0
alter Venb dc=3.3
run
let ioff = abs(i(Vb))
meas dc ioff_max max ioff
.endc
"}
