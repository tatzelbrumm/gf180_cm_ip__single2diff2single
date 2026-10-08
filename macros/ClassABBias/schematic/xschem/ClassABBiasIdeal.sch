v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 10 5 155 -830 305 -830 305 -70 155 -70 155 -830 {dash=6}
P 10 5 315 -830 465 -830 465 -70 315 -70 315 -830 {dash=6}
P 10 5 475 -830 625 -830 625 -70 475 -70 475 -830 {dash=6}
P 10 5 635 -830 785 -830 785 -70 635 -70 635 -830 {dash=6}
P 10 5 795 -830 945 -830 945 -70 795 -70 795 -830 {dash=6}
P 10 5 955 -830 1105 -830 1105 -70 955 -70 955 -830 {dash=6}
T {[8] vbp} 160 -870 0 0 0.35 0.35 {layer=10}
T {[8] vbpc} 320 -870 0 0 0.35 0.35 {layer=10}
T {[8] vabp} 480 -870 0 0 0.35 0.35 {layer=10}
T {[8] vbn} 640 -870 0 0 0.35 0.35 {layer=10}
T {[8] vbnc} 800 -870 0 0 0.35 0.35 {layer=10}
T {[8] vabn} 960 -870 0 0 0.35 0.35 {layer=10}
T {d2s_bias_lp: bias for d2s_mpdda / d2s_lc2 (ideal reference currents, iab = 5u, ibnc = 2u)} 60 -980 0 0 0.5 0.5 {}
T {vabp, vabn: replicas of the class-AB pairs (FPL/ABP 6.66u/0.6u, FNL/ABN 4.4u/1u), stacked on RP1 12u/0.6u, RN1 8u/1u} 60 -930 0 0 0.3 0.3 {}
T {[8] bias: ideal reference currents into diode-connected devices.} 60 -30 0 0 0.3 0.3 {layer=10}
T {      vbp: BP 20u/6u at 5 uA, for the unit tails Ta, Tb (20u/6u, 5 uA each).   vbn: BN 6u/6u at 5 uA, for the sinks SX, SY (36u/6u, 30 uA each).} 60 -6 0 0 0.3 0.3 {layer=10}
T {      vbpc: BPC 1u/4u at 2 uA, for the mirror cascodes PCL, PCR.   vbnc: BNC 1u/8u at 2 uA, for the fold cascodes CX, CY.} 60 18 0 0 0.3 0.3 {layer=10}
T {      vabp: RP2 (= ABP) on RP1 (12u/0.6u) at 5 uA, for ABP, FPL.   vabn: RN2 (= ABN) on RN1 (8u/1u) at 5 uA, for ABN, FNL.} 60 42 0 0 0.3 0.3 {layer=10}
N 180 -760 180 -700 {lab=vbp}
N 180 -700 220 -700 {lab=vbp}
N 220 -730 220 -700 {lab=vbp}
N 220 -840 220 -790 {lab=vdd}
N 220 -760 240 -760 {lab=vdd}
N 240 -840 240 -760 {lab=vdd}
N 220 -700 220 -540 {lab=vbp}
N 220 -110 220 -60 {lab=vss}
N 220 -540 1200 -540 {lab=vbp}
N 340 -760 340 -700 {lab=vbpc}
N 340 -700 380 -700 {lab=vbpc}
N 380 -730 380 -700 {lab=vbpc}
N 380 -840 380 -790 {lab=vdd}
N 380 -760 400 -760 {lab=vdd}
N 400 -840 400 -760 {lab=vdd}
N 380 -700 380 -500 {lab=vbpc}
N 380 -110 380 -60 {lab=vss}
N 380 -500 1200 -500 {lab=vbpc}
N 500 -760 500 -700 {lab=n1}
N 500 -700 540 -700 {lab=n1}
N 540 -730 540 -700 {lab=n1}
N 540 -760 560 -760 {lab=vddo}
N 500 -640 500 -580 {lab=vabp}
N 500 -580 540 -580 {lab=vabp}
N 540 -610 540 -580 {lab=vabp}
N 540 -700 540 -670 {lab=n1}
N 540 -640 580 -640 {lab=vdd}
N 540 -580 540 -460 {lab=vabp}
N 540 -110 540 -60 {lab=vss}
N 540 -460 1200 -460 {lab=vabp}
N 700 -840 700 -790 {lab=vdd}
N 700 -730 700 -420 {lab=vbn}
N 660 -200 660 -140 {lab=vbn}
N 660 -200 700 -200 {lab=vbn}
N 700 -200 700 -170 {lab=vbn}
N 700 -110 700 -60 {lab=vss}
N 700 -140 720 -140 {lab=vss}
N 720 -140 720 -60 {lab=vss}
N 700 -420 1200 -420 {lab=vbn}
N 860 -840 860 -790 {lab=vdd}
N 860 -730 860 -380 {lab=vbnc}
N 820 -200 820 -140 {lab=vbnc}
N 820 -200 860 -200 {lab=vbnc}
N 860 -200 860 -170 {lab=vbnc}
N 860 -110 860 -60 {lab=vss}
N 860 -140 880 -140 {lab=vss}
N 880 -140 880 -60 {lab=vss}
N 860 -380 1200 -380 {lab=vbnc}
N 1020 -840 1020 -790 {lab=vdd}
N 1020 -730 1020 -340 {lab=vabn}
N 980 -320 980 -260 {lab=vabn}
N 980 -320 1020 -320 {lab=vabn}
N 1020 -320 1020 -290 {lab=vabn}
N 980 -200 980 -140 {lab=n2}
N 980 -200 1020 -200 {lab=n2}
N 1020 -200 1020 -170 {lab=n2}
N 1020 -230 1020 -200 {lab=n2}
N 1020 -110 1020 -40 {lab=vsso}
N 1020 -140 1040 -140 {lab=vsso}
N 1040 -140 1040 -40 {lab=vsso}
N 1020 -260 1060 -260 {lab=vss}
N 1020 -340 1200 -340 {lab=vabn}
N 60 -840 220 -840 {lab=vdd}
N 60 -60 220 -60 {lab=vss}
N 220 -540 220 -170 {lab=vbp}
N 380 -500 380 -170 {lab=vbpc}
N 540 -460 540 -170 {lab=vabp}
N 700 -420 700 -200 {lab=vbn}
N 860 -380 860 -200 {lab=vbnc}
N 1020 -340 1020 -320 {lab=vabn}
N 220 -840 240 -840 {lab=vdd}
N 540 -60 700 -60 {lab=vss}
N 380 -60 540 -60 {lab=vss}
N 220 -60 380 -60 {lab=vss}
N 580 -840 700 -840 {lab=vdd}
N 380 -840 400 -840 {lab=vdd}
N 240 -840 380 -840 {lab=vdd}
N 700 -60 720 -60 {lab=vss}
N 860 -840 1020 -840 {lab=vdd}
N 860 -60 880 -60 {lab=vss}
N 720 -60 860 -60 {lab=vss}
N 700 -840 860 -840 {lab=vdd}
N 1020 -40 1040 -40 {lab=vsso}
N 560 -860 560 -760 {lab=vddo}
N 540 -860 560 -860 {lab=vddo}
N 540 -860 540 -790 {lab=vddo}
N 60 -860 540 -860 {lab=vddo}
N 580 -840 580 -640 {lab=vdd}
N 400 -840 580 -840 {lab=vdd}
N 60 -40 1020 -40 {lab=vsso}
N 880 -60 1060 -60 {lab=vss}
N 1060 -260 1060 -60 {lab=vss}
C {devices/iopin.sym} 60 -840 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 -60 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 60 -860 0 1 {name=p9 lab=vddo}
C {devices/iopin.sym} 60 -40 0 1 {name=p10 lab=vsso}
C {devices/opin.sym} 1200 -540 0 0 {name=p3 lab=vbp}
C {devices/opin.sym} 1200 -420 0 0 {name=p4 lab=vbn}
C {devices/opin.sym} 1200 -500 0 0 {name=p5 lab=vbpc}
C {devices/opin.sym} 1200 -380 0 0 {name=p6 lab=vbnc}
C {devices/opin.sym} 1200 -460 0 0 {name=p7 lab=vabp}
C {devices/opin.sym} 1200 -340 0 0 {name=p8 lab=vabn}
C {symbols/pfet_03v3.sym} 200 -760 0 0 {name=BP
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
C {devices/isource.sym} 220 -140 0 0 {name=IBP value=5u}
C {symbols/pfet_03v3.sym} 360 -760 0 0 {name=BPC
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
C {devices/isource.sym} 380 -140 0 0 {name=IBPC value=2u}
C {symbols/pfet_03v3.sym} 520 -760 0 0 {name=RP1
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
C {symbols/pfet_03v3.sym} 520 -640 0 0 {name=RP2
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
C {devices/isource.sym} 540 -140 0 0 {name=IABP value=5u}
C {devices/lab_wire.sym} 540 -690 0 0 {name=l1 sig_type=std_logic lab=n1}
C {devices/isource.sym} 700 -760 0 0 {name=IBN value=5u}
C {symbols/nfet_03v3.sym} 680 -140 0 0 {name=BN
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
C {devices/isource.sym} 860 -760 0 0 {name=IBNC value=2u}
C {symbols/nfet_03v3.sym} 840 -140 0 0 {name=BNC
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
C {devices/isource.sym} 1020 -760 0 0 {name=IABN value=5u}
C {symbols/nfet_03v3.sym} 1000 -260 0 0 {name=RN2
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
C {symbols/nfet_03v3.sym} 1000 -140 0 0 {name=RN1
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
C {devices/lab_wire.sym} 1020 -220 0 0 {name=l2 sig_type=std_logic lab=n2}
C {devices/title.sym} 160 160 0 0 {name=l1 author="Christoph Maier"}
T {GF180MCU (gf180mcuD) 03v3 port of the IHP sheet d2s_bias_lp.sch, 2026-10-08. Wires and placement unchanged;
devices pfet_03v3 / nfet_03v3 / ppolyf_u_3k, sizes re-derived for GF180 (README.md).} 60 -1100 0 0 0.3 0.3 {layer=4}
