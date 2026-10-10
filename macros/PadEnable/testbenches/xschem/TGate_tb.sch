v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {TGate: on-resistance of a 4u/0.5u gate (10 mV across a <-> b, swept 0 ... 3.29 V), off-state leakage. 2026-10-09} 0 -180 0 0 0.3 0.3 {}
C {TGate.sym} 200 -100 0 0 {name=x1 W_N=4u L_N=0.5u W_P=4u L_P=0.5u}
C {devices/lab_pin.sym} 160 -100 0 0 {name=l1 lab=va}
C {devices/lab_pin.sym} 240 -100 0 1 {name=l2 lab=vb}
C {devices/lab_pin.sym} 200 -60 0 0 {name=l3 lab=en}
C {devices/lab_pin.sym} 200 -140 0 0 {name=l4 lab=en_b}
C {devices/vsource.sym} 60 -90 0 0 {name=Vdd value=3.3}
C {devices/lab_pin.sym} 60 -120 0 0 {name=l5 lab=vdd}
C {devices/gnd.sym} 60 -60 0 0 {name=l6 lab=0}
C {devices/code_shown.sym} 0 10 0 0 {name=MODELS only_toplevel=true format="tcleval( @value )" value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.control
save all
* on: 10 mV across the gate, common mode swept over the supply
dc Va 0 3.29 0.01
let ron = 0.01/(-i(Vb))
meas dc ron_0 find ron at=0
meas dc ron_mid find ron at=1.65
meas dc ron_max max ron
write TGate_tb_on.raw
plot ron xlabel 'v(a) (V)' ylabel 'R_on (Ohm)'
* off: same sweep, gates reversed
alter Ven dc=0
alter Venb dc=3.3
dc Va 0 3.29 0.01
let ioff = abs(i(Vb))
meas dc ioff_max max ioff
write TGate_tb_off.raw
plot ioff ylog xlabel 'v(a) (V)' ylabel 'I_off (A)'
.endc
"}
C {devices/lab_pin.sym} 230 -140 0 1 {name=l21 lab=vdd}
C {devices/lab_pin.sym} 230 -60 0 1 {name=l22 lab=0}
C {devices/vsource.sym} 340 -90 0 0 {name=Va value=0 savecurrent=false}
C {devices/lab_pin.sym} 340 -120 0 0 {name=l23 lab=va}
C {devices/lab_pin.sym} 340 -60 0 0 {name=l24 lab=0}
C {devices/vsource.sym} 420 -90 0 0 {name=Vb value=0.01 savecurrent=false}
C {devices/lab_pin.sym} 420 -120 0 0 {name=l25 lab=vb}
C {devices/lab_pin.sym} 420 -60 0 0 {name=l26 lab=va}
C {devices/vsource.sym} 500 -90 0 0 {name=Ven value=3.3 savecurrent=false}
C {devices/lab_pin.sym} 500 -120 0 0 {name=l27 lab=en}
C {devices/lab_pin.sym} 500 -60 0 0 {name=l28 lab=0}
C {devices/vsource.sym} 580 -90 0 0 {name=Venb value=0 savecurrent=false}
C {devices/lab_pin.sym} 580 -120 0 0 {name=l29 lab=en_b}
C {devices/lab_pin.sym} 580 -60 0 0 {name=l30 lab=0}
