v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ClassABBiasBGdn} 60 -1060 0 0 0.5 0.5 {}
T {Self-contained current-mode (Banba) bandgap reference, 5 uA out of iout into the ClassABBiasIn tree. GF180 re-design (2026-10-09) of the IHP bg_core:} 60 -1010 0 0 0.25 0.25 {}
T {[C] input branch PB / PBC -> NB (gate line g) -> eb: R1B to vss and R0 + Q2 (8 x pnp_05p00x05p00); diode branch PA / PAC -> NA (diode, g) -> ea: R1A and Q1.} 60 -988 0 0 0.25 0.25 {}
T {    NA / NB force ea = eb, the mirror equal currents, so each branch carries V_BE1 / R1 + U_T ln 8 / R0 (32 % PTAT with ppolyf_u_3k's -0.15 %/K); PO / POC = 2 x -> 5 uA.} 60 -966 0 0 0.25 0.25 {}
T {    Wide-swing cascode: the input branch's diode connection closes around PBC (vpg = its drain); the cascode gate line vpc = vpg - I RC (RC 150k), NB's drain on vpc.} 60 -944 0 0 0.25 0.25 {}
T {    R1A is 10 % longer than R1B: with both PNPs off the loop gain is > 1, so the core cannot rest in the resistor-only state.} 60 -922 0 0 0.25 0.25 {}
T {[S] start-up: MS1 weak pull-up (gate en_b) on ks, MS3 pulls vpg down while ks is high, MS2 releases ks once g is up. [E] RefCoreEnable: vpg -> vdd, ks -> vss while en = 0.} 60 -900 0 0 0.25 0.25 {}
T {NA / NB each in an isolated p-well (bulk = source) inside one deep n-well on vdd; DPWA / DPWB / DDNW are the well junctions (estimated areas; LVS needs a well_diode_mk marker or lvs_ignore).} 60 -878 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices, sizes from scripts/bg_reference.spice; written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.} 60 -90 0 0 0.2 0.2 {layer=4}
T {[E]} 360 -800 0 0 0.3 0.3 {layer=10}
T {[S]} 220 -800 0 0 0.3 0.3 {layer=10}
T {[C]} 570 -800 0 0 0.3 0.3 {layer=10}
T {Q2 = 8 x Q1 (m=8)} 820 -120 0 1 0.2 0.2 {}
T {[W] well junctions} 680 -820 0 0 0.3 0.3 {layer=10}
T {(deep n-well on vdd)} 680 -800 0 0 0.2 0.2 {}
T {[E]} 240 -240 0 0 0.3 0.3 {layer=10}
N 340 -740 360 -740 {lab=en}
N 220 -180 240 -180 {lab=en_b}
N 220 -740 240 -740 {lab=en_b}
N 280 -840 280 -770 {lab=vdd}
N 280 -710 280 -300 {lab=ks}
N 300 -840 300 -740 {lab=vdd}
N 560 -840 560 -770 {lab=vdd}
N 540 -740 560 -740 {lab=vdd}
N 540 -840 540 -740 {lab=vdd}
N 560 -570 560 -500 {lab=vpg}
N 540 -600 560 -600 {lab=vdd}
N 760 -390 760 -360 {lab=eb}
N 740 -420 760 -420 {lab=eb}
N 660 -150 660 -100 {lab=vss}
N 620 -180 640 -180 {lab=vss}
N 840 -270 840 -210 {lab=e2}
N 860 -300 900 -300 {lab=vss}
N 900 -180 920 -180 {lab=vss}
N 800 -570 800 -520 {lab=vpc}
N 980 -740 1000 -740 {lab=vpg}
N 1040 -840 1040 -770 {lab=vdd}
N 1060 -840 1060 -740 {lab=vdd}
N 980 -600 1000 -600 {lab=vpc}
N 1040 -570 1040 -480 {lab=g}
N 1040 -390 1040 -360 {lab=ea}
N 1220 -740 1240 -740 {lab=vpg}
N 1280 -840 1280 -770 {lab=vdd}
N 1300 -840 1300 -740 {lab=vdd}
N 1220 -600 1240 -600 {lab=vpc}
N 1280 -570 1280 -500 {lab=iout}
N 660 -760 660 -360 {lab=eb}
N 660 -840 660 -820 {lab=vdd}
N 120 -760 120 -100 {lab=vss}
N 120 -840 120 -820 {lab=vdd}
N 620 -180 620 -100 {lab=vss}
N 580 -100 620 -100 {lab=vss}
N 540 -840 560 -840 {lab=vdd}
N 1180 -180 1180 -100 {lab=vss}
N 1160 -180 1180 -180 {lab=vss}
N 1140 -100 1180 -100 {lab=vss}
N 620 -100 660 -100 {lab=vss}
N 840 -150 840 -100 {lab=vss}
N 960 -150 960 -100 {lab=vss}
N 1140 -150 1140 -100 {lab=vss}
N 900 -100 960 -100 {lab=vss}
N 960 -100 1140 -100 {lab=vss}
N 660 -360 660 -200 {lab=eb}
N 840 -360 840 -330 {lab=eb}
N 960 -360 960 -210 {lab=ea}
N 1060 -360 1140 -360 {lab=ea}
N 1140 -360 1140 -200 {lab=ea}
N 900 -180 900 -100 {lab=vss}
N 900 -300 900 -180 {lab=vss}
N 660 -100 840 -100 {lab=vss}
N 880 -180 900 -180 {lab=vss}
N 840 -100 900 -100 {lab=vss}
N 1040 -480 1040 -450 {lab=g}
N 960 -480 960 -420 {lab=g}
N 740 -420 740 -360 {lab=eb}
N 1060 -420 1060 -360 {lab=ea}
N 760 -360 840 -360 {lab=eb}
N 1040 -420 1060 -420 {lab=ea}
N 1040 -360 1060 -360 {lab=ea}
N 960 -360 1040 -360 {lab=ea}
N 800 -420 960 -420 {lab=g}
N 740 -360 760 -360 {lab=eb}
N 660 -360 740 -360 {lab=eb}
N 960 -480 1040 -480 {lab=g}
N 960 -420 1000 -420 {lab=g}
N 900 -600 900 -300 {lab=vss}
N 980 -600 980 -520 {lab=vpc}
N 980 -520 1220 -520 {lab=vpc}
N 1220 -600 1220 -520 {lab=vpc}
N 760 -520 760 -450 {lab=vpc}
N 800 -520 980 -520 {lab=vpc}
N 760 -520 800 -520 {lab=vpc}
N 820 -600 900 -600 {lab=vss}
N 620 -600 620 -520 {lab=vpc}
N 400 -710 400 -680 {lab=vpg}
N 280 -150 280 -100 {lab=vss}
N 300 -180 300 -100 {lab=vss}
N 300 -100 400 -100 {lab=vss}
N 280 -740 300 -740 {lab=vdd}
N 1040 -840 1060 -840 {lab=vdd}
N 1040 -740 1060 -740 {lab=vdd}
N 1280 -840 1300 -840 {lab=vdd}
N 1280 -740 1300 -740 {lab=vdd}
N 560 -300 580 -300 {lab=vss}
N 560 -100 580 -100 {lab=vss}
N 560 -270 560 -100 {lab=vss}
N 580 -300 580 -100 {lab=vss}
N 400 -100 420 -100 {lab=vss}
N 400 -180 400 -100 {lab=vss}
N 420 -150 420 -100 {lab=vss}
N 420 -300 420 -210 {lab=ks}
N 280 -180 300 -180 {lab=vss}
N 220 -480 220 -180 {lab=en_b}
N 400 -840 420 -840 {lab=vdd}
N 400 -740 420 -740 {lab=vdd}
N 1220 -740 1220 -680 {lab=vpg}
N 980 -680 1220 -680 {lab=vpg}
N 600 -740 620 -740 {lab=vpg}
N 620 -740 620 -680 {lab=vpg}
N 620 -520 760 -520 {lab=vpc}
N 600 -600 620 -600 {lab=vpc}
N 560 -500 640 -500 {lab=vpg}
N 400 -840 400 -770 {lab=vdd}
N 420 -840 420 -740 {lab=vdd}
N 300 -840 400 -840 {lab=vdd}
N 620 -680 640 -680 {lab=vpg}
N 480 -480 480 -180 {lab=g}
N 560 -840 660 -840 {lab=vdd}
N 1140 -760 1140 -360 {lab=ea}
N 220 -740 220 -480 {lab=en_b}
N 640 -680 640 -500 {lab=vpg}
N 1300 -740 1300 -600 {lab=vdd}
N 1060 -740 1060 -600 {lab=vdd}
N 540 -740 540 -600 {lab=vdd}
N 1280 -600 1300 -600 {lab=vdd}
N 1040 -600 1060 -600 {lab=vdd}
N 560 -710 560 -630 {lab=cb}
N 1040 -710 1040 -630 {lab=ca}
N 1280 -710 1280 -630 {lab=co}
N 560 -500 560 -330 {lab=vpg}
N 400 -680 620 -680 {lab=vpg}
N 420 -100 560 -100 {lab=vss}
N 420 -300 520 -300 {lab=ks}
N 420 -840 540 -840 {lab=vdd}
N 480 -480 960 -480 {lab=g}
N 280 -300 420 -300 {lab=ks}
N 800 -680 800 -630 {lab=vpg}
N 640 -680 800 -680 {lab=vpg}
N 340 -740 340 -520 {lab=en}
N 400 -180 420 -180 {lab=vss}
N 460 -180 480 -180 {lab=g}
N 980 -740 980 -680 {lab=vpg}
N 800 -680 980 -680 {lab=vpg}
N 280 -300 280 -210 {lab=ks}
N 1280 -500 1340 -500 {lab=iout}
N 120 -100 280 -100 {lab=vss}
N 70 -520 340 -520 {lab=en}
N 70 -480 220 -480 {lab=en_b}
N 1140 -840 1280 -840 {lab=vdd}
N 1140 -840 1140 -820 {lab=vdd}
N 70 -840 120 -840 {lab=vdd}
N 70 -100 120 -100 {lab=vss}
N 1060 -840 1140 -840 {lab=vdd}
N 660 -840 1040 -840 {lab=vdd}
N 120 -840 280 -840 {lab=vdd}
N 280 -840 300 -840 {lab=vdd}
N 280 -100 300 -100 {lab=vss}
C {devices/iopin.sym} 70 -840 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 70 -100 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 70 -520 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 70 -480 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 1340 -500 0 0 {name=p5 lab=iout}
C {devices/lab_pin.sym} 340 -740 0 0 {name=l8 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 220 -180 0 0 {name=l9 sig_type=std_logic lab=en_b}
C {symbols/pfet_03v3.sym} 260 -740 0 0 {name=MS1
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
C {devices/lab_pin.sym} 280 -690 0 1 {name=l13 sig_type=std_logic lab=ks}
C {symbols/nfet_03v3.sym} 540 -300 0 0 {name=MS3
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
C {devices/lab_pin.sym} 560 -350 0 1 {name=l15 sig_type=std_logic lab=vpg}
C {symbols/nfet_03v3.sym} 440 -180 0 1 {name=MS2
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
C {devices/lab_pin.sym} 480 -180 0 1 {name=l18 sig_type=std_logic lab=g}
C {devices/lab_pin.sym} 420 -230 0 0 {name=l19 sig_type=std_logic lab=ks}
C {symbols/pfet_03v3.sym} 580 -740 0 1 {name=PB
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
C {symbols/pfet_03v3.sym} 580 -600 0 1 {name=PBC
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
C {devices/lab_pin.sym} 620 -600 0 1 {name=l22 sig_type=std_logic lab=vpc}
C {devices/lab_pin.sym} 560 -650 0 1 {name=l23 sig_type=std_logic lab=cb}
C {devices/lab_pin.sym} 560 -550 0 0 {name=l24 sig_type=std_logic lab=vpg}
C {symbols/nfet_03v3.sym} 780 -420 0 1 {name=NB
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
C {devices/lab_pin.sym} 760 -470 0 0 {name=l27 sig_type=std_logic lab=vpc}
C {symbols/ppolyf_u_3k.sym} 660 -180 0 0 {name=R1B
W=1u
L=107.4u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 660 -230 0 1 {name=l30 sig_type=std_logic lab=eb}
C {symbols/ppolyf_u_3k.sym} 840 -300 0 1 {name=R0
W=1u
L=32.8u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {symbols/pnp_05p00x05p00.sym} 860 -180 0 1 {name=Q2
model=pnp_05p00x05p00
spiceprefix=X
m=8
}
C {devices/lab_pin.sym} 840 -230 0 0 {name=l36 sig_type=std_logic lab=e2}
C {symbols/ppolyf_u_3k.sym} 800 -600 0 1 {name=RC
W=1u
L=50u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 800 -650 0 0 {name=l39 sig_type=std_logic lab=vpg}
C {devices/lab_pin.sym} 800 -550 0 0 {name=l40 sig_type=std_logic lab=vpc}
C {symbols/pfet_03v3.sym} 1020 -740 0 0 {name=PA
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
C {symbols/pfet_03v3.sym} 1020 -600 0 0 {name=PAC
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
C {devices/lab_pin.sym} 1040 -650 0 0 {name=l45 sig_type=std_logic lab=ca}
C {devices/lab_pin.sym} 1040 -550 0 1 {name=l46 sig_type=std_logic lab=g}
C {symbols/nfet_03v3.sym} 1020 -420 0 0 {name=NA
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
C {devices/lab_pin.sym} 1040 -470 0 1 {name=l49 sig_type=std_logic lab=g}
C {symbols/ppolyf_u_3k.sym} 1140 -180 0 1 {name=R1A
W=1u
L=118.1u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 1140 -230 0 0 {name=l52 sig_type=std_logic lab=ea}
C {symbols/pnp_05p00x05p00.sym} 940 -180 0 0 {name=Q1
model=pnp_05p00x05p00
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 960 -230 0 1 {name=l55 sig_type=std_logic lab=ea}
C {symbols/pfet_03v3.sym} 1260 -740 0 0 {name=PO
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
C {symbols/pfet_03v3.sym} 1260 -600 0 0 {name=POC
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
C {devices/lab_pin.sym} 1280 -650 0 0 {name=l61 sig_type=std_logic lab=co}
C {devices/lab_pin.sym} 1280 -550 0 1 {name=l62 sig_type=std_logic lab=iout}
C {symbols/diode_pw2dw.sym} 1140 -790 2 1 {name=DPWA
model=diode_pw2dw
r_w=12u
r_l=30u
m=1
}
C {devices/lab_pin.sym} 1140 -740 2 0 {name=l64 sig_type=std_logic lab=ea}
C {symbols/diode_pw2dw.sym} 660 -790 2 1 {name=DPWB
model=diode_pw2dw
r_w=12u
r_l=30u
m=1
}
C {devices/lab_pin.sym} 660 -740 2 0 {name=l66 sig_type=std_logic lab=eb}
C {symbols/diode_dw2ps.sym} 120 -790 2 1 {name=DDNW
model=diode_dw2ps
r_w=30u
r_l=60u
m=1
}
C {devices/lab_pin.sym} 120 -740 2 0 {name=l68 sig_type=std_logic lab=vss}
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
C {symbols/pfet_03v3.sym} 380 -740 0 0 {name=SPG
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
C {devices/lab_pin.sym} 400 -690 0 1 {name=l1 sig_type=std_logic lab=vpg}
C {symbols/nfet_03v3.sym} 260 -180 0 0 {name=SKS
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
C {devices/lab_pin.sym} 280 -230 0 1 {name=l2 sig_type=std_logic lab=ks}
