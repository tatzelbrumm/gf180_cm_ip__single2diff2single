v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {InputEnable} 60 -560 0 0 0.5 0.5 {}
T {Input switch of an analog input pad, behind the CDM resistor:} 60 -500 0 0 0.25 0.25 {}
T {TGN1 / TGP1 pass pin to pout while en = 1; while en = 0 they open and TGN2 / TGP2 park pout on vpark} 60 -478 0 0 0.25 0.25 {}
T {(the common-mode reference), so the circuit behind the pad sees a defined input when the pad is off.} 60 -456 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 60 120 0 0 0.2 0.2 {layer=4}
N 60 -300 760 -300 {lab=vdd}
N 60 0 760 0 {lab=vss}
C {devices/iopin.sym} 60 -300 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 0 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 60 -180 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 60 -140 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 60 -100 0 1 {name=p5 lab=pin}
C {devices/iopin.sym} 840 -140 0 0 {name=p6 lab=pout}
C {devices/ipin.sym} 840 -100 0 0 {name=p7 lab=vpark}
C {symbols/pfet_03v3.sym} 200 -220 0 0 {name=TGP1
L=0.5u
W=4u
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
N 180 -220 140 -220 {lab=en_b}
C {devices/lab_pin.sym} 140 -220 0 0 {name=l8 sig_type=std_logic lab=en_b}
N 220 -250 220 -270 {lab=pin}
C {devices/lab_pin.sym} 220 -270 0 1 {name=l9 sig_type=std_logic lab=pin}
N 220 -190 220 -170 {lab=pout}
C {devices/lab_pin.sym} 220 -170 0 1 {name=l10 sig_type=std_logic lab=pout}
N 220 -220 260 -220 {lab=vdd}
C {devices/lab_pin.sym} 260 -220 0 1 {name=l11 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 200 -60 0 0 {name=TGN1
L=0.5u
W=4u
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
N 180 -60 140 -60 {lab=en}
C {devices/lab_pin.sym} 140 -60 0 0 {name=l12 sig_type=std_logic lab=en}
N 220 -90 220 -110 {lab=pin}
C {devices/lab_pin.sym} 220 -110 0 1 {name=l13 sig_type=std_logic lab=pin}
N 220 -30 220 -10 {lab=pout}
C {devices/lab_pin.sym} 220 -10 0 1 {name=l14 sig_type=std_logic lab=pout}
N 220 -60 260 -60 {lab=vss}
C {devices/lab_pin.sym} 260 -60 0 1 {name=l15 sig_type=std_logic lab=vss}
C {symbols/pfet_03v3.sym} 500 -220 0 0 {name=TGP2
L=0.5u
W=4u
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
N 480 -220 440 -220 {lab=en}
C {devices/lab_pin.sym} 440 -220 0 0 {name=l16 sig_type=std_logic lab=en}
N 520 -250 520 -270 {lab=pout}
C {devices/lab_pin.sym} 520 -270 0 1 {name=l17 sig_type=std_logic lab=pout}
N 520 -190 520 -170 {lab=vpark}
C {devices/lab_pin.sym} 520 -170 0 1 {name=l18 sig_type=std_logic lab=vpark}
N 520 -220 560 -220 {lab=vdd}
C {devices/lab_pin.sym} 560 -220 0 1 {name=l19 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 500 -60 0 0 {name=TGN2
L=0.5u
W=4u
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
N 480 -60 440 -60 {lab=en_b}
C {devices/lab_pin.sym} 440 -60 0 0 {name=l20 sig_type=std_logic lab=en_b}
N 520 -90 520 -110 {lab=pout}
C {devices/lab_pin.sym} 520 -110 0 1 {name=l21 sig_type=std_logic lab=pout}
N 520 -30 520 -10 {lab=vpark}
C {devices/lab_pin.sym} 520 -10 0 1 {name=l22 sig_type=std_logic lab=vpark}
N 520 -60 560 -60 {lab=vss}
C {devices/lab_pin.sym} 560 -60 0 1 {name=l23 sig_type=std_logic lab=vss}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
