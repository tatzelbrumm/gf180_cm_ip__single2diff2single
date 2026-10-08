v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ClassABBiasBGTree} 60 -700 0 0 0.5 0.5 {}
T {CACE fixture: ClassABBiasBG feeding the ClassABBiasIn tree (iout -> iref directly; in the pad BiasRefEnable sits in between). Ports as ClassABBiasIn plus en / en_b.} 60 -650 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD); written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.} 60 140 0 0 0.2 0.2 {layer=4}
C {devices/iopin.sym} 60 -500 0 0 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 -460 0 0 {name=p2 lab=vss}
C {devices/iopin.sym} 60 -420 0 0 {name=p3 lab=vddo}
C {devices/iopin.sym} 60 -380 0 0 {name=p4 lab=vsso}
C {devices/ipin.sym} 60 -340 0 0 {name=p5 lab=en}
C {devices/ipin.sym} 60 -300 0 0 {name=p6 lab=en_b}
C {devices/opin.sym} 1100 -500 0 0 {name=p7 lab=vbp}
C {devices/opin.sym} 1100 -460 0 0 {name=p8 lab=vbn}
C {devices/opin.sym} 1100 -420 0 0 {name=p9 lab=vbpc}
C {devices/opin.sym} 1100 -380 0 0 {name=p10 lab=vbnc}
C {devices/opin.sym} 1100 -340 0 0 {name=p11 lab=vabp}
C {devices/opin.sym} 1100 -300 0 0 {name=p12 lab=vabn}
C {ClassABBiasBG.sym} 400 -400 0 0 {name=x1}
N 400 -480 400 -500 {lab=vdd}
C {devices/lab_pin.sym} 400 -500 0 1 {name=l13 sig_type=std_logic lab=vdd}
N 400 -320 400 -300 {lab=vss}
C {devices/lab_pin.sym} 400 -300 0 1 {name=l14 sig_type=std_logic lab=vss}
N 520 -400 540 -400 {lab=iref}
C {devices/lab_pin.sym} 540 -400 0 1 {name=l15 sig_type=std_logic lab=iref}
N 280 -420 260 -420 {lab=en}
C {devices/lab_pin.sym} 260 -420 0 0 {name=l16 sig_type=std_logic lab=en}
N 280 -380 260 -380 {lab=en_b}
C {devices/lab_pin.sym} 260 -380 0 0 {name=l17 sig_type=std_logic lab=en_b}
C {ClassABBiasIn.sym} 760 -400 0 0 {name=x2}
N 680 -580 660 -580 {lab=vdd}
C {devices/lab_pin.sym} 660 -580 0 0 {name=l18 sig_type=std_logic lab=vdd}
N 680 -220 660 -220 {lab=vss}
C {devices/lab_pin.sym} 660 -220 0 0 {name=l19 sig_type=std_logic lab=vss}
N 840 -580 860 -580 {lab=vddo}
C {devices/lab_pin.sym} 860 -580 0 1 {name=l20 sig_type=std_logic lab=vddo}
N 840 -220 860 -220 {lab=vsso}
C {devices/lab_pin.sym} 860 -220 0 1 {name=l21 sig_type=std_logic lab=vsso}
N 620 -400 600 -400 {lab=iref}
C {devices/lab_pin.sym} 600 -400 0 0 {name=l22 sig_type=std_logic lab=iref}
N 900 -500 920 -500 {lab=vbp}
C {devices/lab_pin.sym} 920 -500 0 1 {name=l23 sig_type=std_logic lab=vbp}
N 900 -460 920 -460 {lab=vbn}
C {devices/lab_pin.sym} 920 -460 0 1 {name=l24 sig_type=std_logic lab=vbn}
N 900 -420 920 -420 {lab=vbpc}
C {devices/lab_pin.sym} 920 -420 0 1 {name=l25 sig_type=std_logic lab=vbpc}
N 900 -380 920 -380 {lab=vbnc}
C {devices/lab_pin.sym} 920 -380 0 1 {name=l26 sig_type=std_logic lab=vbnc}
N 900 -340 920 -340 {lab=vabp}
C {devices/lab_pin.sym} 920 -340 0 1 {name=l27 sig_type=std_logic lab=vabp}
N 900 -300 920 -300 {lab=vabn}
C {devices/lab_pin.sym} 920 -300 0 1 {name=l28 sig_type=std_logic lab=vabn}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
