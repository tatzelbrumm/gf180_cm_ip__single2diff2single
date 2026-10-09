v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ClassABBiasBGTree} 60 -700 0 0 0.5 0.5 {}
T {CACE fixture: ClassABBiasBG feeding the ClassABBiasIn tree (iout -> iref directly; in the pad BiasRefEnable sits in between). Ports as ClassABBiasIn plus en / en_b.} 60 -650 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD); written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.} 100 -90 0 0 0.2 0.2 {layer=4}
N 320 -280 320 -140 {lab=vss}
N 440 -360 540 -360 {lab=iref}
N 600 -180 600 -140 {lab=vss}
N 760 -180 760 -120 {lab=vsso}
N 600 -580 600 -540 {lab=vdd}
N 320 -580 320 -440 {lab=vdd}
N 320 -140 600 -140 {lab=vss}
N 320 -580 600 -580 {lab=vdd}
N 760 -600 760 -540 {lab=vddo}
N 160 -140 320 -140 {lab=vss}
N 160 -120 760 -120 {lab=vsso}
N 160 -580 320 -580 {lab=vdd}
N 160 -600 760 -600 {lab=vddo}
N 160 -380 200 -380 {lab=en}
N 160 -340 200 -340 {lab=en_b}
N 820 -460 860 -460 {lab=#net1}
N 820 -420 860 -420 {lab=#net1}
N 820 -380 860 -380 {lab=#net1}
N 820 -340 860 -340 {lab=#net1}
N 820 -300 860 -300 {lab=#net1}
N 820 -260 860 -260 {lab=#net1}
C {devices/iopin.sym} 160 -580 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 160 -140 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 160 -600 0 1 {name=p3 lab=vddo}
C {devices/iopin.sym} 160 -120 0 1 {name=p4 lab=vsso}
C {devices/ipin.sym} 160 -380 0 0 {name=p5 lab=en}
C {devices/ipin.sym} 160 -340 0 0 {name=p6 lab=en_b}
C {devices/opin.sym} 860 -460 0 0 {name=p7 lab=vbp}
C {devices/opin.sym} 860 -420 0 0 {name=p8 lab=vbn}
C {devices/opin.sym} 860 -380 0 0 {name=p9 lab=vbpc}
C {devices/opin.sym} 860 -340 0 0 {name=p10 lab=vbnc}
C {devices/opin.sym} 860 -300 0 0 {name=p11 lab=vabp}
C {devices/opin.sym} 860 -260 0 0 {name=p12 lab=vabn}
C {ClassABBiasBG.sym} 320 -360 0 0 {name=x1}
C {devices/lab_pin.sym} 320 -460 0 1 {name=l13 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 320 -260 0 1 {name=l14 sig_type=std_logic lab=vss}
C {ClassABBiasIn.sym} 680 -360 0 0 {name=x2}
C {devices/lab_wire.sym} 480 -360 0 0 {name=l22 lab=iref}
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
