v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ClassABBiasBG} 60 -1180 0 0 0.5 0.5 {}
T {Self-contained current-mode (Banba) bandgap reference, 5 uA out of iout into the ClassABBiasIn tree. GF180 re-design (2026-10-09) of the IHP bg_core:} 60 -1130 0 0 0.25 0.25 {}
T {[C] input branch PB / PBC -> NB (gate line g) -> eb: R1B to vss and R0 + Q2 (8 x pnp_05p00x05p00); diode branch PA / PAC -> NA (diode, g) -> ea: R1A and Q1.} 60 -1108 0 0 0.25 0.25 {}
T {    NA / NB force ea = eb, the mirror equal currents, so each branch carries V_BE1 / R1 + U_T ln 8 / R0 (32 % PTAT with ppolyf_u_3k's -0.15 %/K); PO / POC = 2 x -> 5 uA.} 60 -1086 0 0 0.25 0.25 {}
T {    Wide-swing cascode: the input branch's diode connection closes around PBC (vpg = its drain); the cascode gate line vpc = vpg - I RC (RC 150k), NB's drain on vpc.} 60 -1064 0 0 0.25 0.25 {}
T {    R1A is 10 % longer than R1B: with both PNPs off the loop gain is > 1, so the core cannot rest in the resistor-only state.} 60 -1042 0 0 0.25 0.25 {}
T {[S] start-up: MS1 weak pull-up (gate en_b) on ks, MS3 pulls vpg down while ks is high, MS2 releases ks once g is up. [E] RefCoreEnable: vpg -> vdd, ks -> vss while en = 0.} 60 -1020 0 0 0.25 0.25 {}
T {NA / NB bulks on vss (common substrate). The deep-n-well variant is ClassABBiasBGdn.} 60 -998 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices, sizes from scripts/bg_reference.spice; written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.} 60 140 0 0 0.2 0.2 {layer=4}
N 60 -900 1200 -900 {lab=vdd}
N 60 0 1200 0 {lab=vss}
C {devices/iopin.sym} 60 -900 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 0 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 60 -500 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 60 -460 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 1280 -300 0 0 {name=p5 lab=iout}
C {RefCoreEnable.sym} 240 -480 0 0 {name=XE}
N 240 -560 240 -580 {lab=vdd}
C {devices/lab_pin.sym} 240 -580 0 1 {name=l6 sig_type=std_logic lab=vdd}
N 240 -400 240 -380 {lab=vss}
C {devices/lab_pin.sym} 240 -380 0 1 {name=l7 sig_type=std_logic lab=vss}
N 120 -500 100 -500 {lab=en}
C {devices/lab_pin.sym} 100 -500 0 0 {name=l8 sig_type=std_logic lab=en}
N 120 -460 100 -460 {lab=en_b}
C {devices/lab_pin.sym} 100 -460 0 0 {name=l9 sig_type=std_logic lab=en_b}
N 360 -500 380 -500 {lab=vpg}
C {devices/lab_pin.sym} 380 -500 0 1 {name=l10 sig_type=std_logic lab=vpg}
N 360 -460 380 -460 {lab=ks}
C {devices/lab_pin.sym} 380 -460 0 1 {name=l11 sig_type=std_logic lab=ks}
T {[E]} 160 -600 0 0 0.3 0.3 {layer=10}
T {[S]} 160 -860 0 0 0.3 0.3 {layer=10}
T {[C]} 520 -860 0 0 0.3 0.3 {layer=10}
C {symbols/pfet_03v3.sym} 200 -800 0 0 {name=MS1
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
N 180 -800 140 -800 {lab=en_b}
C {devices/lab_pin.sym} 140 -800 0 0 {name=l12 sig_type=std_logic lab=en_b}
N 220 -830 220 -900 {lab=vdd}
N 220 -770 220 -750 {lab=ks}
C {devices/lab_pin.sym} 220 -750 0 1 {name=l13 sig_type=std_logic lab=ks}
N 220 -800 260 -800 {lab=vdd}
N 260 -800 260 -900 {lab=vdd}
C {symbols/nfet_03v3.sym} 200 -680 0 0 {name=MS3
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
N 180 -680 140 -680 {lab=ks}
C {devices/lab_pin.sym} 140 -680 0 0 {name=l14 sig_type=std_logic lab=ks}
N 220 -710 220 -730 {lab=vpg}
C {devices/lab_pin.sym} 220 -730 0 1 {name=l15 sig_type=std_logic lab=vpg}
N 220 -650 220 -630 {lab=vss}
C {devices/lab_pin.sym} 220 -630 0 1 {name=l16 sig_type=std_logic lab=vss}
N 220 -680 260 -680 {lab=vss}
C {devices/lab_pin.sym} 260 -680 0 1 {name=l17 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 200 -100 0 0 {name=MS2
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
N 180 -100 140 -100 {lab=g}
C {devices/lab_pin.sym} 140 -100 0 0 {name=l18 sig_type=std_logic lab=g}
N 220 -130 220 -150 {lab=ks}
C {devices/lab_pin.sym} 220 -150 0 1 {name=l19 sig_type=std_logic lab=ks}
N 220 -70 220 0 {lab=vss}
N 220 -100 260 -100 {lab=vss}
N 260 -100 260 0 {lab=vss}
C {symbols/pfet_03v3.sym} 560 -800 0 0 {name=PB
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
N 540 -800 500 -800 {lab=vpg}
C {devices/lab_pin.sym} 500 -800 0 0 {name=l20 sig_type=std_logic lab=vpg}
N 580 -830 580 -900 {lab=vdd}
N 580 -770 580 -750 {lab=cb}
C {devices/lab_pin.sym} 580 -750 0 1 {name=l21 sig_type=std_logic lab=cb}
N 580 -800 620 -800 {lab=vdd}
N 620 -800 620 -900 {lab=vdd}
C {symbols/pfet_03v3.sym} 560 -680 0 0 {name=PBC
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
N 540 -680 500 -680 {lab=vpc}
C {devices/lab_pin.sym} 500 -680 0 0 {name=l22 sig_type=std_logic lab=vpc}
N 580 -710 580 -730 {lab=cb}
C {devices/lab_pin.sym} 580 -730 0 1 {name=l23 sig_type=std_logic lab=cb}
N 580 -650 580 -630 {lab=vpg}
C {devices/lab_pin.sym} 580 -630 0 1 {name=l24 sig_type=std_logic lab=vpg}
N 580 -680 620 -680 {lab=vdd}
C {devices/lab_pin.sym} 620 -680 0 1 {name=l25 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 560 -480 0 0 {name=NB
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
N 540 -480 500 -480 {lab=g}
C {devices/lab_pin.sym} 500 -480 0 0 {name=l26 sig_type=std_logic lab=g}
N 580 -510 580 -530 {lab=vpc}
C {devices/lab_pin.sym} 580 -530 0 1 {name=l27 sig_type=std_logic lab=vpc}
N 580 -450 580 -430 {lab=eb}
C {devices/lab_pin.sym} 580 -430 0 1 {name=l28 sig_type=std_logic lab=eb}
N 580 -480 620 -480 {lab=vss}
C {devices/lab_pin.sym} 620 -480 0 1 {name=l29 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_3k.sym} 500 -300 0 0 {name=R1B
W=1u
L=107.4u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
N 500 -330 500 -350 {lab=eb}
C {devices/lab_pin.sym} 500 -350 0 1 {name=l30 sig_type=std_logic lab=eb}
N 500 -270 500 -250 {lab=vss}
C {devices/lab_pin.sym} 500 -250 0 1 {name=l31 sig_type=std_logic lab=vss}
N 480 -300 440 -300 {lab=vss}
C {devices/lab_pin.sym} 440 -300 0 0 {name=l32 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_3k.sym} 680 -300 0 0 {name=R0
W=1u
L=32.8u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
N 680 -330 680 -350 {lab=eb}
C {devices/lab_pin.sym} 680 -350 0 1 {name=l33 sig_type=std_logic lab=eb}
N 680 -270 680 -250 {lab=e2}
C {devices/lab_pin.sym} 680 -250 0 1 {name=l34 sig_type=std_logic lab=e2}
N 660 -300 620 -300 {lab=vss}
C {devices/lab_pin.sym} 620 -300 0 0 {name=l35 sig_type=std_logic lab=vss}
C {symbols/pnp_05p00x05p00.sym} 620 -100 0 0 {name=Q2
model=pnp_05p00x05p00
spiceprefix=X
m=8
}
N 640 -130 640 -150 {lab=e2}
C {devices/lab_pin.sym} 640 -150 0 1 {name=l36 sig_type=std_logic lab=e2}
N 640 -70 640 -50 {lab=vss}
C {devices/lab_pin.sym} 640 -50 0 1 {name=l37 sig_type=std_logic lab=vss}
N 600 -100 560 -100 {lab=vss}
C {devices/lab_pin.sym} 560 -100 0 0 {name=l38 sig_type=std_logic lab=vss}
T {Q2 = 8 x Q1 (m=8)} 660 -40 0 0 0.2 0.2 {}
C {symbols/ppolyf_u_3k.sym} 760 -740 0 0 {name=RC
W=1u
L=50u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
N 760 -770 760 -790 {lab=vpg}
C {devices/lab_pin.sym} 760 -790 0 1 {name=l39 sig_type=std_logic lab=vpg}
N 760 -710 760 -690 {lab=vpc}
C {devices/lab_pin.sym} 760 -690 0 1 {name=l40 sig_type=std_logic lab=vpc}
N 740 -740 700 -740 {lab=vss}
C {devices/lab_pin.sym} 700 -740 0 0 {name=l41 sig_type=std_logic lab=vss}
C {symbols/pfet_03v3.sym} 900 -800 0 0 {name=PA
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
N 880 -800 840 -800 {lab=vpg}
C {devices/lab_pin.sym} 840 -800 0 0 {name=l42 sig_type=std_logic lab=vpg}
N 920 -830 920 -900 {lab=vdd}
N 920 -770 920 -750 {lab=ca}
C {devices/lab_pin.sym} 920 -750 0 1 {name=l43 sig_type=std_logic lab=ca}
N 920 -800 960 -800 {lab=vdd}
N 960 -800 960 -900 {lab=vdd}
C {symbols/pfet_03v3.sym} 900 -680 0 0 {name=PAC
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
N 880 -680 840 -680 {lab=vpc}
C {devices/lab_pin.sym} 840 -680 0 0 {name=l44 sig_type=std_logic lab=vpc}
N 920 -710 920 -730 {lab=ca}
C {devices/lab_pin.sym} 920 -730 0 1 {name=l45 sig_type=std_logic lab=ca}
N 920 -650 920 -630 {lab=g}
C {devices/lab_pin.sym} 920 -630 0 1 {name=l46 sig_type=std_logic lab=g}
N 920 -680 960 -680 {lab=vdd}
C {devices/lab_pin.sym} 960 -680 0 1 {name=l47 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 900 -480 0 0 {name=NA
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
N 880 -480 840 -480 {lab=g}
C {devices/lab_pin.sym} 840 -480 0 0 {name=l48 sig_type=std_logic lab=g}
N 920 -510 920 -530 {lab=g}
C {devices/lab_pin.sym} 920 -530 0 1 {name=l49 sig_type=std_logic lab=g}
N 920 -450 920 -430 {lab=ea}
C {devices/lab_pin.sym} 920 -430 0 1 {name=l50 sig_type=std_logic lab=ea}
N 920 -480 960 -480 {lab=vss}
C {devices/lab_pin.sym} 960 -480 0 1 {name=l51 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_3k.sym} 840 -300 0 0 {name=R1A
W=1u
L=118.1u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
N 840 -330 840 -350 {lab=ea}
C {devices/lab_pin.sym} 840 -350 0 1 {name=l52 sig_type=std_logic lab=ea}
N 840 -270 840 -250 {lab=vss}
C {devices/lab_pin.sym} 840 -250 0 1 {name=l53 sig_type=std_logic lab=vss}
N 820 -300 780 -300 {lab=vss}
C {devices/lab_pin.sym} 780 -300 0 0 {name=l54 sig_type=std_logic lab=vss}
C {symbols/pnp_05p00x05p00.sym} 960 -100 0 0 {name=Q1
model=pnp_05p00x05p00
spiceprefix=X
m=1
}
N 980 -130 980 -150 {lab=ea}
C {devices/lab_pin.sym} 980 -150 0 1 {name=l55 sig_type=std_logic lab=ea}
N 980 -70 980 -50 {lab=vss}
C {devices/lab_pin.sym} 980 -50 0 1 {name=l56 sig_type=std_logic lab=vss}
N 940 -100 900 -100 {lab=vss}
C {devices/lab_pin.sym} 900 -100 0 0 {name=l57 sig_type=std_logic lab=vss}
C {symbols/pfet_03v3.sym} 1140 -800 0 0 {name=PO
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
N 1120 -800 1080 -800 {lab=vpg}
C {devices/lab_pin.sym} 1080 -800 0 0 {name=l58 sig_type=std_logic lab=vpg}
N 1160 -830 1160 -900 {lab=vdd}
N 1160 -770 1160 -750 {lab=co}
C {devices/lab_pin.sym} 1160 -750 0 1 {name=l59 sig_type=std_logic lab=co}
N 1160 -800 1200 -800 {lab=vdd}
N 1200 -800 1200 -900 {lab=vdd}
C {symbols/pfet_03v3.sym} 1140 -680 0 0 {name=POC
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
N 1120 -680 1080 -680 {lab=vpc}
C {devices/lab_pin.sym} 1080 -680 0 0 {name=l60 sig_type=std_logic lab=vpc}
N 1160 -710 1160 -730 {lab=co}
C {devices/lab_pin.sym} 1160 -730 0 1 {name=l61 sig_type=std_logic lab=co}
N 1160 -650 1160 -630 {lab=iout}
C {devices/lab_pin.sym} 1160 -630 0 1 {name=l62 sig_type=std_logic lab=iout}
N 1160 -680 1200 -680 {lab=vdd}
C {devices/lab_pin.sym} 1200 -680 0 1 {name=l63 sig_type=std_logic lab=vdd}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
