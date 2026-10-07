v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 440 -150 0 0 0.3 0.3 {}
T {Start-up testbench, OgueyAebischerRef_06v0. VDD ramps 0 -> 3.3 V in 1 ms; no .nodeset,
so the kick circuit has to start the core on its own. Port of the IHP OgueyAebischerBias_tb.sch
(which still ramped to 1.2 V over 100 ms).} 440 -660 0 0 0.3 0.3 {}
N 380 -200 380 -180 {lab=0}
N 380 -420 380 -200 {lab=0}
N 380 -500 380 -480 {lab=vdd}
N 380 -500 600 -500 {lab=vdd}
N 600 -500 600 -380 {lab=vdd}
N 380 -200 600 -200 {lab=0}
N 600 -300 600 -200 {lab=0}
N 440 -320 540 -320 {lab=disable}
N 440 -320 440 -300 {lab=disable}
N 440 -240 440 -200 {lab=0}
N 660 -360 720 -360 {lab=vbp}
N 660 -340 720 -340 {lab=vbn}
N 660 -320 720 -320 {lab=vbr}
C {OgueyAebischerRef_06v0.sym} 600 -340 0 0 {name=xref}
C {devices/gnd.sym} 380 -180 0 0 {name=l2 lab=0}
C {devices/vsource.sym} 380 -450 0 1 {name=VDD value="dc 3.3 pwl(0 0 1m 3.3)"}
C {devices/vsource.sym} 440 -270 0 1 {name=Voff value=0}
C {devices/lab_wire.sym} 470 -500 0 0 {name=l3 lab=vdd}
C {devices/lab_wire.sym} 500 -320 0 0 {name=l5 lab=disable}
C {devices/lab_pin.sym} 720 -360 0 1 {name=l6 lab=vbp}
C {devices/lab_pin.sym} 720 -340 0 1 {name=l7 lab=vbn}
C {devices/lab_pin.sym} 720 -320 0 1 {name=l8 lab=vbr}
C {devices/title.sym} 160 -40 0 0 {name=l1 author="Christoph Maier"}
C {devices/code_shown.sym} 0 -950 0 0 {name=NGSPICE
only_toplevel=true
value="
.options gmin=1e-15 abstol=1p
.option savecurrents
.control
save all
op
remzerovec
write OgueyAebischerRef_06v0_tb_tran.op.raw
tran 100n 3m
remzerovec
write OgueyAebischerRef_06v0_tb_tran.raw
* core reference current through the ammeter Vi1 inside xbias
meas tran I1_final find v.xref.xbias.vi1#branch at=3m
plot vdd vbp vbn vbr xref.xbias.vres xref.xstart.vkick
plot v.xref.xbias.vi1#branch v.xref.xbias.vi4#branch v.xref.xbias.viaux#branch
.endc
"}
C {devices/code_shown.sym} 0 -610 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
