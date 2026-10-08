v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {EnableInv} 60 -560 0 0 0.5 0.5 {}
T {en_b = not en, on vdd / vss. One per pad.} 60 -500 0 0 0.25 0.25 {}
T {When the enable comes from 1.2 V logic, a level shifter replaces this cell.} 60 -478 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 60 120 0 0 0.2 0.2 {layer=4}
N 60 -300 400 -300 {lab=vdd}
N 60 0 400 0 {lab=vss}
C {devices/iopin.sym} 60 -300 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 0 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 60 -150 0 0 {name=p3 lab=en}
C {devices/opin.sym} 400 -150 0 0 {name=p4 lab=en_b}
C {symbols/pfet_03v3.sym} 200 -220 0 0 {name=MP
L=0.5u
W=2u
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
N 180 -220 140 -220 {lab=en}
C {devices/lab_pin.sym} 140 -220 0 0 {name=l5 sig_type=std_logic lab=en}
N 220 -250 220 -300 {lab=vdd}
N 220 -190 220 -170 {lab=en_b}
C {devices/lab_pin.sym} 220 -170 0 1 {name=l6 sig_type=std_logic lab=en_b}
N 220 -220 260 -220 {lab=vdd}
N 260 -220 260 -300 {lab=vdd}
C {symbols/nfet_03v3.sym} 200 -60 0 0 {name=MN
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
N 180 -60 140 -60 {lab=en}
C {devices/lab_pin.sym} 140 -60 0 0 {name=l7 sig_type=std_logic lab=en}
N 220 -90 220 -110 {lab=en_b}
C {devices/lab_pin.sym} 220 -110 0 1 {name=l8 sig_type=std_logic lab=en_b}
N 220 -30 220 0 {lab=vss}
N 220 -60 260 -60 {lab=vss}
N 260 -60 260 0 {lab=vss}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
