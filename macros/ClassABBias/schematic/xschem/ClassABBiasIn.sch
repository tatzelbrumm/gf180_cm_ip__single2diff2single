v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 10 5 160 -1070 300 -1070 300 -115 160 -115 160 -1070 {dash=6}
P 10 5 480 -1070 780 -1070 780 -115 480 -115 480 -1070 {dash=6}
P 10 5 320 -1070 460 -1070 460 -115 320 -115 320 -1070 {dash=6}
P 10 5 960 -1070 1260 -1070 1260 -115 960 -115 960 -1070 {dash=6}
P 10 5 800 -1070 940 -1070 940 -35 800 -35 800 -1070 {dash=6}
T {[R] input} 165 -1090 0 0 0.3 0.3 {layer=10}
T {d2s_bias_in: reference current INTO iref (from an external PMOS source, 5 uA nominal)} 60 -1290 0 0 0.5 0.5 {}
T {NI (a copy of BN) takes I_ref; its gate line drives the sinks NBPC, NBP, NABP out of the PMOS diodes; BP's gate line drives the sources PBNC, PBN, PABN into the NMOS diodes.} 60 -1240 0 0 0.3 0.3 {}
T {Mirror tree and diodes. The six diodes are those of d2s_bias_lp and set the bias voltages:} 60 -20 0 0 0.3 0.3 {layer=10}
T {   vbp: BP 20u/6u, 5 uA (unit tails).  vbpc: BPC 1u/4u, 2 uA (mirror cascodes).  vabp: RP2 on RP1, 5 uA (ABP, FPL).} 60 4 0 0 0.3 0.3 {layer=10}
T {   vbn: BN 6u/6u, 5 uA (fold sinks).  vbnc: BNC 1u/8u, 2 uA (fold cascodes).  vabn: RN2 on RN1, 5 uA (ABN, FNL).} 60 28 0 0 0.3 0.3 {layer=10}
T {PMOS gate lines come from PMOS diodes on vdd, NMOS gate lines from NMOS diodes on vss: bias crosses blocks as currents.} 60 52 0 0 0.3 0.3 {layer=10}
T {RP1 and RN1 are the class-AB replicas of OP and ON: they sit on the output-stage rails vddo / vsso (separate rails} 60 76 0 0 0.3 0.3 {layer=10}
T {   from the right). RP2 keeps its n-well on vdd, like ABP. RN1 needs a local substrate tap ring on vsso, like ON.} 60 100 0 0 0.3 0.3 {layer=10}
T {[8] PMOS diodes, NMOS sinks} 485 -1090 0 0 0.3 0.3 {layer=10}
T {[8] vabp} 325 -1090 0 0 0.3 0.3 {layer=10}
T {[8] PMOS sources, NMOS diodes} 965 -1090 0 0 0.3 0.3 {layer=10}
T {[8] vabn} 805 -1090 0 0 0.3 0.3 {layer=10}
N 60 -1040 360 -1040 {lab=vddo}
N 60 -1000 340 -1000 {lab=vdd}
N 60 -560 220 -560 {lab=iref}
N 60 -100 200 -100 {lab=vss}
N 60 -60 860 -60 {lab=vsso}
N 200 -200 200 -100 {lab=vss}
N 200 -200 220 -200 {lab=vss}
N 200 -100 220 -100 {lab=vss}
N 220 -560 220 -230 {lab=iref}
N 220 -560 260 -560 {lab=iref}
N 220 -170 220 -100 {lab=vss}
N 220 -100 380 -100 {lab=vss}
N 260 -560 340 -560 {lab=iref}
N 340 -1000 340 -800 {lab=vdd}
N 340 -1000 520 -1000 {lab=vdd}
N 340 -800 380 -800 {lab=vdd}
N 340 -560 500 -560 {lab=iref}
N 360 -1040 360 -920 {lab=vddo}
N 360 -1040 380 -1040 {lab=vddo}
N 360 -920 380 -920 {lab=vddo}
N 380 -1040 380 -950 {lab=vddo}
N 380 -890 380 -860 {lab=n1}
N 380 -860 380 -830 {lab=n1}
N 380 -860 420 -860 {lab=n1}
N 380 -770 380 -660 {lab=vabp}
N 380 -660 380 -230 {lab=vabp}
N 380 -660 420 -660 {lab=vabp}
N 380 -200 400 -200 {lab=vss}
N 380 -170 380 -100 {lab=vss}
N 380 -100 400 -100 {lab=vss}
N 400 -200 400 -100 {lab=vss}
N 400 -100 540 -100 {lab=vss}
N 420 -920 420 -860 {lab=n1}
N 420 -800 420 -660 {lab=vabp}
N 420 -660 1300 -660 {lab=vabp}
N 500 -560 660 -560 {lab=iref}
N 520 -1000 520 -920 {lab=vdd}
N 520 -1000 540 -1000 {lab=vdd}
N 520 -920 540 -920 {lab=vdd}
N 540 -1000 540 -950 {lab=vdd}
N 540 -1000 680 -1000 {lab=vdd}
N 540 -890 540 -700 {lab=vbpc}
N 540 -700 540 -230 {lab=vbpc}
N 540 -700 580 -700 {lab=vbpc}
N 540 -200 560 -200 {lab=vss}
N 540 -170 540 -100 {lab=vss}
N 540 -100 560 -100 {lab=vss}
N 560 -200 560 -100 {lab=vss}
N 560 -100 700 -100 {lab=vss}
N 580 -920 580 -700 {lab=vbpc}
N 580 -700 1300 -700 {lab=vbpc}
N 680 -1000 680 -920 {lab=vdd}
N 680 -1000 700 -1000 {lab=vdd}
N 680 -920 700 -920 {lab=vdd}
N 700 -1000 700 -950 {lab=vdd}
N 700 -1000 880 -1000 {lab=vdd}
N 700 -890 700 -740 {lab=vbp}
N 700 -740 700 -230 {lab=vbp}
N 700 -740 740 -740 {lab=vbp}
N 700 -200 720 -200 {lab=vss}
N 700 -170 700 -100 {lab=vss}
N 700 -100 720 -100 {lab=vss}
N 720 -200 720 -100 {lab=vss}
N 720 -100 840 -100 {lab=vss}
N 740 -920 740 -740 {lab=vbp}
N 740 -740 840 -740 {lab=vbp}
N 840 -920 840 -740 {lab=vbp}
N 840 -740 980 -740 {lab=vbp}
N 840 -320 840 -100 {lab=vss}
N 840 -320 880 -320 {lab=vss}
N 840 -100 1000 -100 {lab=vss}
N 860 -200 860 -60 {lab=vsso}
N 860 -200 880 -200 {lab=vsso}
N 860 -60 880 -60 {lab=vsso}
N 880 -1000 880 -950 {lab=vdd}
N 880 -1000 900 -1000 {lab=vdd}
N 880 -920 900 -920 {lab=vdd}
N 880 -890 880 -460 {lab=vabn}
N 880 -460 880 -350 {lab=vabn}
N 880 -460 920 -460 {lab=vabn}
N 880 -290 880 -260 {lab=n2}
N 880 -260 880 -230 {lab=n2}
N 880 -260 920 -260 {lab=n2}
N 880 -170 880 -60 {lab=vsso}
N 900 -1000 900 -920 {lab=vdd}
N 900 -1000 1020 -1000 {lab=vdd}
N 920 -460 920 -320 {lab=vabn}
N 920 -460 1300 -460 {lab=vabn}
N 920 -260 920 -200 {lab=n2}
N 980 -920 980 -740 {lab=vbp}
N 980 -740 1140 -740 {lab=vbp}
N 1000 -200 1000 -100 {lab=vss}
N 1000 -200 1020 -200 {lab=vss}
N 1000 -100 1020 -100 {lab=vss}
N 1020 -1000 1020 -950 {lab=vdd}
N 1020 -1000 1040 -1000 {lab=vdd}
N 1020 -920 1040 -920 {lab=vdd}
N 1020 -890 1020 -420 {lab=vbnc}
N 1020 -420 1020 -230 {lab=vbnc}
N 1020 -420 1060 -420 {lab=vbnc}
N 1020 -170 1020 -100 {lab=vss}
N 1020 -100 1160 -100 {lab=vss}
N 1040 -1000 1040 -920 {lab=vdd}
N 1040 -1000 1180 -1000 {lab=vdd}
N 1060 -420 1060 -200 {lab=vbnc}
N 1060 -420 1300 -420 {lab=vbnc}
N 1140 -920 1140 -740 {lab=vbp}
N 1140 -740 1300 -740 {lab=vbp}
N 1160 -200 1160 -100 {lab=vss}
N 1160 -200 1180 -200 {lab=vss}
N 1160 -100 1180 -100 {lab=vss}
N 1180 -1000 1180 -950 {lab=vdd}
N 1180 -1000 1200 -1000 {lab=vdd}
N 1180 -920 1200 -920 {lab=vdd}
N 1180 -890 1180 -380 {lab=vbn}
N 1180 -380 1180 -230 {lab=vbn}
N 1180 -380 1220 -380 {lab=vbn}
N 1180 -170 1180 -100 {lab=vss}
N 1200 -1000 1200 -920 {lab=vdd}
N 1220 -380 1220 -200 {lab=vbn}
N 1220 -380 1300 -380 {lab=vbn}
N 260 -560 260 -200 {}
N 340 -560 340 -200 {}
N 500 -560 500 -200 {}
N 660 -560 660 -200 {}
C {symbols/nfet_03v3.sym} 240 -200 0 1 {name=NI
L=6u
W=6u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/title.sym} 170 200 0 0 {name=l1 author="Christoph Maier"}
C {symbols/pfet_03v3.sym} 560 -920 0 1 {name=BPC
L=4u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 520 -200 0 0 {name=NBPC
L=6u
W=2.5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 540 -700 0 0 {name=l1 sig_type=std_logic lab=vbpc}
C {symbols/pfet_03v3.sym} 720 -920 0 1 {name=BP
L=6u
W=20u
nf=2
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 680 -200 0 0 {name=NBP
L=6u
W=6u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 700 -740 0 0 {name=l2 sig_type=std_logic lab=vbp}
C {symbols/pfet_03v3.sym} 400 -920 0 1 {name=RP1
L=0.6u
W=12u
nf=2
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 400 -800 0 1 {name=RP2
L=0.6u
W=6.66u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 380 -845 0 1 {name=l3 sig_type=std_logic lab=n1}
C {symbols/nfet_03v3.sym} 360 -200 0 0 {name=NABP
L=6u
W=6u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 380 -660 0 0 {name=l4 sig_type=std_logic lab=vabp}
C {symbols/pfet_03v3.sym} 1000 -920 0 0 {name=PBNC
L=6u
W=8u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1040 -200 0 1 {name=BNC
L=8u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 1020 -420 0 0 {name=l5 sig_type=std_logic lab=vbnc}
C {symbols/pfet_03v3.sym} 1160 -920 0 0 {name=PBN
L=6u
W=20u
nf=2
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1200 -200 0 1 {name=BN
L=6u
W=6u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 1180 -380 0 0 {name=l6 sig_type=std_logic lab=vbn}
C {symbols/pfet_03v3.sym} 860 -920 0 0 {name=PABN
L=6u
W=20u
nf=2
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 900 -320 0 1 {name=RN2
L=1u
W=4.4u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 900 -200 0 1 {name=RN1
L=1u
W=8u
nf=2
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 880 -275 0 1 {name=l7 sig_type=std_logic lab=n2}
C {devices/lab_wire.sym} 880 -460 0 0 {name=l8 sig_type=std_logic lab=vabn}
C {devices/iopin.sym} 60 -1000 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 -100 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 60 -1040 0 1 {name=p3 lab=vddo}
C {devices/iopin.sym} 60 -60 0 1 {name=p4 lab=vsso}
C {devices/iopin.sym} 60 -560 0 1 {name=p5 lab=iref}
C {devices/opin.sym} 1300 -740 0 0 {name=p6 lab=vbp}
C {devices/opin.sym} 1300 -380 0 0 {name=p7 lab=vbn}
C {devices/opin.sym} 1300 -700 0 0 {name=p8 lab=vbpc}
C {devices/opin.sym} 1300 -420 0 0 {name=p9 lab=vbnc}
C {devices/opin.sym} 1300 -660 0 0 {name=p10 lab=vabp}
C {devices/opin.sym} 1300 -460 0 0 {name=p11 lab=vabn}
T {GF180MCU (gf180mcuD) 03v3 port of the IHP sheet d2s_bias_in.sch, 2026-10-08. Wires and placement unchanged;
devices pfet_03v3 / nfet_03v3 / ppolyf_u_3k, sizes re-derived for GF180 (README.md).} 60 -1410 0 0 0.3 0.3 {layer=4}
