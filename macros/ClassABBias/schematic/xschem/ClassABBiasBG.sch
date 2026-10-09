v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ClassABBiasBG} 60 -1060 0 0 0.5 0.5 {}
T {Self-contained current-mode (Banba) bandgap reference, 5 uA out of iout into the ClassABBiasIn tree. GF180 re-design (2026-10-09) of the IHP bg_core:} 60 -1010 0 0 0.25 0.25 {}
T {[C] input branch PB / PBC -> NB (gate line g) -> eb: R1B to vss and R0 + Q2 (8 x pnp_05p00x05p00); diode branch PA / PAC -> NA (diode, g) -> ea: R1A and Q1.} 60 -988 0 0 0.25 0.25 {}
T {    NA / NB force ea = eb, the mirror equal currents, so each branch carries V_BE1 / R1 + U_T ln 8 / R0 (32 % PTAT with ppolyf_u_3k's -0.15 %/K); PO / POC = 2 x -> 5 uA.} 60 -966 0 0 0.25 0.25 {}
T {    Wide-swing cascode: the input branch's diode connection closes around PBC (vpg = its drain); the cascode gate line vpc = vpg - I RC (RC 150k), NB's drain on vpc.} 60 -944 0 0 0.25 0.25 {}
T {    R1A is 10 % longer than R1B: with both PNPs off the loop gain is > 1, so the core cannot rest in the resistor-only state.} 60 -922 0 0 0.25 0.25 {}
T {[S] start-up: MS1 weak pull-up (gate en_b) on ks, MS3 pulls vpg down while ks is high, MS2 releases ks once g is up. [E] RefCoreEnable: vpg -> vdd, ks -> vss while en = 0.} 60 -900 0 0 0.25 0.25 {}
T {NA / NB bulks on vss (common substrate). The deep-n-well variant is ClassABBiasBGdn.} 60 -878 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices, sizes from scripts/bg_reference.spice; written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.} 60 -90 0 0 0.2 0.2 {layer=4}
T {[E]} 300 -800 0 0 0.3 0.3 {layer=10}
T {[S]} 160 -800 0 0 0.3 0.3 {layer=10}
T {[C]} 510 -800 0 0 0.3 0.3 {layer=10}
T {Q2 = 8 x Q1 (m=8)} 760 -120 0 1 0.2 0.2 {}
T {[E]} 180 -240 0 0 0.3 0.3 {layer=10}
N 280 -740 300 -740 {lab=en}
N 160 -180 180 -180 {lab=en_b}
N 160 -740 180 -740 {lab=en_b}
N 220 -840 220 -770 {lab=vdd}
N 220 -710 220 -300 {lab=ks}
N 240 -840 240 -740 {lab=vdd}
N 500 -840 500 -770 {lab=vdd}
N 480 -740 500 -740 {lab=vdd}
N 480 -840 480 -740 {lab=vdd}
N 500 -570 500 -500 {lab=vpg}
N 480 -600 500 -600 {lab=vdd}
N 700 -390 700 -360 {lab=eb}
N 680 -420 700 -420 {lab=vss}
N 600 -150 600 -100 {lab=vss}
N 560 -180 580 -180 {lab=vss}
N 780 -270 780 -210 {lab=e2}
N 800 -300 840 -300 {lab=vss}
N 840 -180 860 -180 {lab=vss}
N 740 -570 740 -520 {lab=vpc}
N 920 -740 940 -740 {lab=vpg}
N 980 -840 980 -770 {lab=vdd}
N 1000 -840 1000 -740 {lab=vdd}
N 920 -600 940 -600 {lab=vpc}
N 980 -570 980 -480 {lab=g}
N 980 -390 980 -360 {lab=ea}
N 1160 -740 1180 -740 {lab=vpg}
N 1220 -840 1220 -770 {lab=vdd}
N 1240 -840 1240 -740 {lab=vdd}
N 1160 -600 1180 -600 {lab=vpc}
N 1220 -570 1220 -500 {lab=iout}
N 560 -180 560 -100 {lab=vss}
N 520 -100 560 -100 {lab=vss}
N 480 -840 500 -840 {lab=vdd}
N 1120 -180 1120 -100 {lab=vss}
N 1100 -180 1120 -180 {lab=vss}
N 1080 -100 1120 -100 {lab=vss}
N 560 -100 600 -100 {lab=vss}
N 780 -150 780 -100 {lab=vss}
N 900 -150 900 -100 {lab=vss}
N 1080 -150 1080 -100 {lab=vss}
N 840 -100 900 -100 {lab=vss}
N 900 -100 1080 -100 {lab=vss}
N 600 -360 600 -200 {lab=eb}
N 780 -360 780 -330 {lab=eb}
N 900 -360 900 -210 {lab=ea}
N 1080 -360 1080 -200 {lab=ea}
N 840 -180 840 -100 {lab=vss}
N 840 -300 840 -180 {lab=vss}
N 600 -100 780 -100 {lab=vss}
N 820 -180 840 -180 {lab=vss}
N 780 -100 840 -100 {lab=vss}
N 980 -480 980 -450 {lab=g}
N 900 -480 900 -420 {lab=g}
N 700 -360 780 -360 {lab=eb}
N 980 -420 1000 -420 {lab=vss}
N 980 -360 1080 -360 {lab=ea}
N 900 -360 980 -360 {lab=ea}
N 740 -420 900 -420 {lab=g}
N 600 -360 700 -360 {lab=eb}
N 900 -480 980 -480 {lab=g}
N 900 -420 940 -420 {lab=g}
N 840 -600 840 -300 {lab=vss}
N 920 -600 920 -520 {lab=vpc}
N 920 -520 1160 -520 {lab=vpc}
N 1160 -600 1160 -520 {lab=vpc}
N 700 -520 700 -450 {lab=vpc}
N 740 -520 920 -520 {lab=vpc}
N 700 -520 740 -520 {lab=vpc}
N 760 -600 840 -600 {lab=vss}
N 560 -600 560 -520 {lab=vpc}
N 340 -710 340 -680 {lab=vpg}
N 220 -150 220 -100 {lab=vss}
N 240 -180 240 -100 {lab=vss}
N 240 -100 340 -100 {lab=vss}
N 220 -740 240 -740 {lab=vdd}
N 980 -840 1000 -840 {lab=vdd}
N 980 -740 1000 -740 {lab=vdd}
N 1220 -840 1240 -840 {lab=vdd}
N 1220 -740 1240 -740 {lab=vdd}
N 500 -300 520 -300 {lab=vss}
N 500 -100 520 -100 {lab=vss}
N 500 -270 500 -100 {lab=vss}
N 520 -300 520 -100 {lab=vss}
N 340 -100 360 -100 {lab=vss}
N 340 -180 340 -100 {lab=vss}
N 360 -150 360 -100 {lab=vss}
N 360 -300 360 -210 {lab=ks}
N 220 -180 240 -180 {lab=vss}
N 160 -480 160 -180 {lab=en_b}
N 340 -840 360 -840 {lab=vdd}
N 340 -740 360 -740 {lab=vdd}
N 1160 -740 1160 -680 {lab=vpg}
N 920 -680 1160 -680 {lab=vpg}
N 540 -740 560 -740 {lab=vpg}
N 560 -740 560 -680 {lab=vpg}
N 560 -520 700 -520 {lab=vpc}
N 540 -600 560 -600 {lab=vpc}
N 500 -500 580 -500 {lab=vpg}
N 340 -840 340 -770 {lab=vdd}
N 360 -840 360 -740 {lab=vdd}
N 240 -840 340 -840 {lab=vdd}
N 560 -680 580 -680 {lab=vpg}
N 420 -480 420 -180 {lab=g}
N 500 -840 980 -840 {lab=vdd}
N 160 -740 160 -480 {lab=en_b}
N 580 -680 580 -500 {lab=vpg}
N 1240 -740 1240 -600 {lab=vdd}
N 1000 -740 1000 -600 {lab=vdd}
N 480 -740 480 -600 {lab=vdd}
N 1220 -600 1240 -600 {lab=vdd}
N 980 -600 1000 -600 {lab=vdd}
N 500 -710 500 -630 {lab=cb}
N 980 -710 980 -630 {lab=ca}
N 1220 -710 1220 -630 {lab=co}
N 500 -500 500 -330 {lab=vpg}
N 340 -680 560 -680 {lab=vpg}
N 360 -100 500 -100 {lab=vss}
N 360 -300 460 -300 {lab=ks}
N 360 -840 480 -840 {lab=vdd}
N 420 -480 900 -480 {lab=g}
N 220 -300 360 -300 {lab=ks}
N 740 -680 740 -630 {lab=vpg}
N 580 -680 740 -680 {lab=vpg}
N 280 -740 280 -520 {lab=en}
N 340 -180 360 -180 {lab=vss}
N 400 -180 420 -180 {lab=g}
N 920 -740 920 -680 {lab=vpg}
N 740 -680 920 -680 {lab=vpg}
N 220 -300 220 -210 {lab=ks}
N 1220 -500 1280 -500 {lab=iout}
N 60 -100 220 -100 {lab=vss}
N 60 -520 280 -520 {lab=en}
N 60 -480 160 -480 {lab=en_b}
N 1000 -840 1220 -840 {lab=vdd}
N 60 -840 220 -840 {lab=vdd}
N 220 -840 240 -840 {lab=vdd}
N 220 -100 240 -100 {lab=vss}
N 1000 -420 1000 -100 {lab=vss}
N 680 -420 680 -100 {lab=vss}
C {devices/iopin.sym} 60 -840 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 -100 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 60 -520 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 60 -480 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 1280 -500 0 0 {name=p5 lab=iout}
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
C {devices/lab_pin.sym} 280 -740 0 0 {name=l8 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 160 -180 0 0 {name=l9 sig_type=std_logic lab=en_b}
C {symbols/pfet_03v3.sym} 200 -740 0 0 {name=MS1
L=50u
W=0.22u
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
C {devices/lab_pin.sym} 220 -690 0 1 {name=l13 sig_type=std_logic lab=ks}
C {symbols/nfet_03v3.sym} 480 -300 0 0 {name=MS3
L=2u
W=0.5u
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
C {devices/lab_pin.sym} 500 -350 0 1 {name=l15 sig_type=std_logic lab=vpg}
C {symbols/nfet_03v3.sym} 380 -180 0 1 {name=MS2
L=1u
W=10u
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
C {devices/lab_pin.sym} 420 -180 0 1 {name=l18 sig_type=std_logic lab=g}
C {devices/lab_pin.sym} 360 -230 0 0 {name=l19 sig_type=std_logic lab=ks}
C {symbols/pfet_03v3.sym} 520 -740 0 1 {name=PB
L=4u
W=48u
nf=4
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
C {symbols/pfet_03v3.sym} 520 -600 0 1 {name=PBC
L=2u
W=48u
nf=4
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
C {devices/lab_pin.sym} 560 -600 0 1 {name=l22 sig_type=std_logic lab=vpc}
C {devices/lab_pin.sym} 500 -650 0 1 {name=l23 sig_type=std_logic lab=cb}
C {devices/lab_pin.sym} 500 -550 0 0 {name=l24 sig_type=std_logic lab=vpg}
C {symbols/nfet_03v3.sym} 720 -420 0 1 {name=NB
L=12u
W=20u
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
C {devices/lab_pin.sym} 700 -470 0 0 {name=l27 sig_type=std_logic lab=vpc}
C {symbols/ppolyf_u_3k.sym} 600 -180 0 0 {name=R1B
W=1u
L=107.4u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 600 -230 0 1 {name=l30 sig_type=std_logic lab=eb}
C {symbols/ppolyf_u_3k.sym} 780 -300 0 1 {name=R0
W=1u
L=32.8u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {symbols/pnp_05p00x05p00.sym} 800 -180 0 1 {name=Q2
model=pnp_05p00x05p00
spiceprefix=X
m=8
}
C {devices/lab_pin.sym} 780 -230 0 0 {name=l36 sig_type=std_logic lab=e2}
C {symbols/ppolyf_u_3k.sym} 740 -600 0 1 {name=RC
W=1u
L=50u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 740 -650 0 0 {name=l39 sig_type=std_logic lab=vpg}
C {devices/lab_pin.sym} 740 -550 0 0 {name=l40 sig_type=std_logic lab=vpc}
C {symbols/pfet_03v3.sym} 960 -740 0 0 {name=PA
L=4u
W=48u
nf=4
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
C {symbols/pfet_03v3.sym} 960 -600 0 0 {name=PAC
L=2u
W=48u
nf=4
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
C {devices/lab_pin.sym} 980 -650 0 0 {name=l45 sig_type=std_logic lab=ca}
C {devices/lab_pin.sym} 980 -550 0 1 {name=l46 sig_type=std_logic lab=g}
C {symbols/nfet_03v3.sym} 960 -420 0 0 {name=NA
L=12u
W=20u
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
C {devices/lab_pin.sym} 980 -470 0 1 {name=l49 sig_type=std_logic lab=g}
C {symbols/ppolyf_u_3k.sym} 1080 -180 0 1 {name=R1A
W=1u
L=118.1u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 1080 -230 0 0 {name=l52 sig_type=std_logic lab=ea}
C {symbols/pnp_05p00x05p00.sym} 880 -180 0 0 {name=Q1
model=pnp_05p00x05p00
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 900 -230 0 1 {name=l55 sig_type=std_logic lab=ea}
C {symbols/pfet_03v3.sym} 1200 -740 0 0 {name=PO
L=4u
W=96u
nf=8
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
C {symbols/pfet_03v3.sym} 1200 -600 0 0 {name=POC
L=2u
W=96u
nf=8
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
C {devices/lab_pin.sym} 1220 -650 0 0 {name=l61 sig_type=std_logic lab=co}
C {devices/lab_pin.sym} 1220 -550 0 1 {name=l62 sig_type=std_logic lab=iout}
C {symbols/pfet_03v3.sym} 320 -740 0 0 {name=SPG
L=0.5u
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
C {devices/lab_pin.sym} 340 -690 0 1 {name=l1 sig_type=std_logic lab=vpg}
C {symbols/nfet_03v3.sym} 200 -180 0 0 {name=SKS
L=0.5u
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
C {devices/lab_pin.sym} 220 -230 0 1 {name=l2 sig_type=std_logic lab=ks}
