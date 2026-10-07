v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 60 -500 640 -500 {lab=vdd}
N 60 -100 640 -100 {lab=vss}
N 60 -320 120 -320 {lab=inp}
N 60 -280 120 -280 {lab=inn}
N 580 -300 640 -300 {lab=out}
C {devices/iopin.sym} 60 -500 0 1 {name=p1 lab=vdd}
C {devices/ipin.sym} 60 -320 0 0 {name=p2 lab=inp}
C {devices/ipin.sym} 60 -280 0 0 {name=p3 lab=inn}
C {devices/opin.sym} 640 -300 0 0 {name=p4 lab=out}
C {devices/iopin.sym} 60 -100 0 1 {name=p5 lab=vss}
C {devices/lab_pin.sym} 120 -320 0 1 {name=l2 lab=inp}
C {devices/lab_pin.sym} 120 -280 0 1 {name=l3 lab=inn}
C {devices/lab_pin.sym} 580 -300 0 0 {name=l4 lab=out}
C {devices/title.sym} 160 -40 0 0 {name=l1 author="Christoph Maier"}
T {gf180mcu_IOPadDiff2Single - SKELETON (2026-10-06): ports only.
Differential -> single-ended class-AB pad driver, not designed yet for GF180.
IHP counterpart: ESD clamps only (sg13cmos5l_ClampN15N15 / ClampP15N15, no GF180 equivalent,
dropped for now by the designer). The IHP symbol declared vcm twice and inp/inn as outputs;
this symbol uses vdd inp inn out vss. Sizing notes: IHP notes worktree,
design_considerations/class_ab_pad_driver/.} 60 -900 0 0 0.3 0.3 {}
