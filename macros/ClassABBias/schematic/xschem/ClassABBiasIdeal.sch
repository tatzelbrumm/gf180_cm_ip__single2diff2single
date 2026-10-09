v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 10 5 155 -1000 305 -1000 305 -240 155 -240 155 -1000 {dash=6}
P 10 5 315 -1000 465 -1000 465 -240 315 -240 315 -1000 {dash=6}
P 10 5 475 -1000 625 -1000 625 -240 475 -240 475 -1000 {dash=6}
P 10 5 635 -1000 785 -1000 785 -240 635 -240 635 -1000 {dash=6}
P 10 5 795 -1000 945 -1000 945 -240 795 -240 795 -1000 {dash=6}
P 10 5 955 -1000 1105 -1000 1105 -240 955 -240 955 -1000 {dash=6}
T {[8] vbp} 160 -1040 0 0 0.35 0.35 {layer=10}
T {[8] vbpc} 320 -1040 0 0 0.35 0.35 {layer=10}
T {[8] vabp} 480 -1040 0 0 0.35 0.35 {layer=10}
T {[8] vbn} 640 -1040 0 0 0.35 0.35 {layer=10}
T {[8] vbnc} 800 -1040 0 0 0.35 0.35 {layer=10}
T {[8] vabn} 960 -1040 0 0 0.35 0.35 {layer=10}
T {d2s_bias_lp: bias for d2s_mpdda / d2s_lc2 (ideal reference currents, iab = 5u, ibnc = 2u)} 60 -1150 0 0 0.5 0.5 {}
T {vabp, vabn: replicas of the class-AB pairs (FPL/ABP 6.66u/0.6u, FNL/ABN 4.4u/1u), stacked on RP1 12u/0.6u, RN1 8u/1u} 60 -1100 0 0 0.3 0.3 {}
T {[8] bias: ideal reference currents into diode-connected devices.} 60 -200 0 0 0.3 0.3 {layer=10}
T {      vbp: BP 20u/6u at 5 uA, for the unit tails Ta, Tb (20u/6u, 5 uA each).   vbn: BN 6u/6u at 5 uA, for the sinks SX, SY (36u/6u, 30 uA each).} 60 -176 0 0 0.3 0.3 {layer=10}
T {      vbpc: BPC 1u/4u at 2 uA, for the mirror cascodes PCL, PCR.   vbnc: BNC 1u/8u at 2 uA, for the fold cascodes CX, CY.} 60 -152 0 0 0.3 0.3 {layer=10}
T {      vabp: RP2 (= ABP) on RP1 (12u/0.6u) at 5 uA, for ABP, FPL.   vabn: RN2 (= ABN) on RN1 (8u/1u) at 5 uA, for ABN, FNL.} 60 -128 0 0 0.3 0.3 {layer=10}
T {GF180MCU (gf180mcuD) 03v3 port of the IHP sheet d2s_bias_lp.sch, 2026-10-08. Wires and placement unchanged;
devices pfet_03v3 / nfet_03v3 / ppolyf_u_3k, sizes re-derived for GF180 (README.md).} 60 -1200 0 0 0.3 0.3 {layer=4}
N 180 -930 180 -870 {lab=vbp}
N 180 -870 220 -870 {lab=vbp}
N 220 -900 220 -870 {lab=vbp}
N 220 -1010 220 -960 {lab=vdd}
N 220 -930 240 -930 {lab=vdd}
N 240 -1010 240 -930 {lab=vdd}
N 220 -870 220 -710 {lab=vbp}
N 220 -280 220 -230 {lab=vss}
N 220 -710 1200 -710 {lab=vbp}
N 340 -930 340 -870 {lab=vbpc}
N 340 -870 380 -870 {lab=vbpc}
N 380 -900 380 -870 {lab=vbpc}
N 380 -1010 380 -960 {lab=vdd}
N 380 -930 400 -930 {lab=vdd}
N 400 -1010 400 -930 {lab=vdd}
N 380 -870 380 -670 {lab=vbpc}
N 380 -280 380 -230 {lab=vss}
N 380 -670 1200 -670 {lab=vbpc}
N 500 -930 500 -870 {lab=n1}
N 500 -870 540 -870 {lab=n1}
N 540 -900 540 -870 {lab=n1}
N 540 -930 560 -930 {lab=vddo}
N 500 -810 500 -750 {lab=vabp}
N 500 -750 540 -750 {lab=vabp}
N 540 -780 540 -750 {lab=vabp}
N 540 -870 540 -840 {lab=n1}
N 540 -810 580 -810 {lab=vdd}
N 540 -750 540 -630 {lab=vabp}
N 540 -280 540 -230 {lab=vss}
N 540 -630 1200 -630 {lab=vabp}
N 700 -1010 700 -960 {lab=vdd}
N 700 -900 700 -590 {lab=vbn}
N 660 -370 660 -310 {lab=vbn}
N 660 -370 700 -370 {lab=vbn}
N 700 -370 700 -340 {lab=vbn}
N 700 -280 700 -230 {lab=vss}
N 700 -310 720 -310 {lab=vss}
N 720 -310 720 -230 {lab=vss}
N 700 -590 1200 -590 {lab=vbn}
N 860 -1010 860 -960 {lab=vdd}
N 860 -900 860 -550 {lab=vbnc}
N 820 -370 820 -310 {lab=vbnc}
N 820 -370 860 -370 {lab=vbnc}
N 860 -370 860 -340 {lab=vbnc}
N 860 -280 860 -230 {lab=vss}
N 860 -310 880 -310 {lab=vss}
N 880 -310 880 -230 {lab=vss}
N 860 -550 1200 -550 {lab=vbnc}
N 1020 -1010 1020 -960 {lab=vdd}
N 1020 -900 1020 -510 {lab=vabn}
N 980 -490 980 -430 {lab=vabn}
N 980 -490 1020 -490 {lab=vabn}
N 1020 -490 1020 -460 {lab=vabn}
N 980 -370 980 -310 {lab=n2}
N 980 -370 1020 -370 {lab=n2}
N 1020 -370 1020 -340 {lab=n2}
N 1020 -400 1020 -370 {lab=n2}
N 1020 -280 1020 -210 {lab=vsso}
N 1020 -310 1040 -310 {lab=vsso}
N 1040 -310 1040 -210 {lab=vsso}
N 1020 -430 1060 -430 {lab=vss}
N 1020 -510 1200 -510 {lab=vabn}
N 60 -1010 220 -1010 {lab=vdd}
N 60 -230 220 -230 {lab=vss}
N 220 -710 220 -340 {lab=vbp}
N 380 -670 380 -340 {lab=vbpc}
N 540 -630 540 -340 {lab=vabp}
N 700 -590 700 -370 {lab=vbn}
N 860 -550 860 -370 {lab=vbnc}
N 1020 -510 1020 -490 {lab=vabn}
N 220 -1010 240 -1010 {lab=vdd}
N 540 -230 700 -230 {lab=vss}
N 380 -230 540 -230 {lab=vss}
N 220 -230 380 -230 {lab=vss}
N 580 -1010 700 -1010 {lab=vdd}
N 380 -1010 400 -1010 {lab=vdd}
N 240 -1010 380 -1010 {lab=vdd}
N 700 -230 720 -230 {lab=vss}
N 860 -1010 1020 -1010 {lab=vdd}
N 860 -230 880 -230 {lab=vss}
N 720 -230 860 -230 {lab=vss}
N 700 -1010 860 -1010 {lab=vdd}
N 1020 -210 1040 -210 {lab=vsso}
N 560 -1030 560 -930 {lab=vddo}
N 540 -1030 560 -1030 {lab=vddo}
N 540 -1030 540 -960 {lab=vddo}
N 60 -1030 540 -1030 {lab=vddo}
N 580 -1010 580 -810 {lab=vdd}
N 400 -1010 580 -1010 {lab=vdd}
N 60 -210 1020 -210 {lab=vsso}
N 880 -230 1060 -230 {lab=vss}
N 1060 -430 1060 -230 {lab=vss}
C {devices/iopin.sym} 60 -1010 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 -230 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 60 -1030 0 1 {name=p9 lab=vddo}
C {devices/iopin.sym} 60 -210 0 1 {name=p10 lab=vsso}
C {devices/opin.sym} 1200 -710 0 0 {name=p3 lab=vbp}
C {devices/opin.sym} 1200 -590 0 0 {name=p4 lab=vbn}
C {devices/opin.sym} 1200 -670 0 0 {name=p5 lab=vbpc}
C {devices/opin.sym} 1200 -550 0 0 {name=p6 lab=vbnc}
C {devices/opin.sym} 1200 -630 0 0 {name=p7 lab=vabp}
C {devices/opin.sym} 1200 -510 0 0 {name=p8 lab=vabn}
C {symbols/pfet_03v3.sym} 200 -930 0 0 {name=BP
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
C {devices/isource.sym} 220 -310 0 0 {name=IBP value=5u}
C {symbols/pfet_03v3.sym} 360 -930 0 0 {name=BPC
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
C {devices/isource.sym} 380 -310 0 0 {name=IBPC value=2u}
C {symbols/pfet_03v3.sym} 520 -930 0 0 {name=RP1
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
C {symbols/pfet_03v3.sym} 520 -810 0 0 {name=RP2
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
C {devices/isource.sym} 540 -310 0 0 {name=IABP value=5u}
C {devices/lab_wire.sym} 540 -860 0 0 {name=l1 sig_type=std_logic lab=n1}
C {devices/isource.sym} 700 -930 0 0 {name=IBN value=5u}
C {symbols/nfet_03v3.sym} 680 -310 0 0 {name=BN
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
C {devices/isource.sym} 860 -930 0 0 {name=IBNC value=2u}
C {symbols/nfet_03v3.sym} 840 -310 0 0 {name=BNC
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
C {devices/isource.sym} 1020 -930 0 0 {name=IABN value=5u}
C {symbols/nfet_03v3.sym} 1000 -430 0 0 {name=RN2
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
C {symbols/nfet_03v3.sym} 1000 -310 0 0 {name=RN1
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
C {devices/lab_wire.sym} 1020 -390 0 0 {name=l2 sig_type=std_logic lab=n2}
C {devices/title.sym} 160 -50 0 0 {name=l1 author="Christoph Maier"}
