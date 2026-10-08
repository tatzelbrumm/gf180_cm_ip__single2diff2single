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
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 50 -120 0 0 0.2 0.2 {layer=4}
N 240 -440 240 -390 {lab=vdd}
N 240 -330 240 -310 {lab=en_b}
N 260 -440 260 -360 {lab=vdd}
N 240 -250 240 -230 {lab=en_b}
N 240 -170 240 -140 {lab=vss}
N 260 -200 260 -140 {lab=vss}
N 180 -360 180 -200 {lab=en}
N 180 -200 200 -200 {lab=en}
N 180 -360 200 -360 {lab=en}
N 240 -310 240 -250 {lab=en_b}
N 140 -280 180 -280 {lab=en}
N 240 -200 260 -200 {lab=vss}
N 240 -360 260 -360 {lab=vdd}
N 240 -280 280 -280 {lab=en_b}
N 140 -440 260 -440 {lab=vdd}
N 140 -140 260 -140 {lab=vss}
C {devices/iopin.sym} 140 -440 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 140 -140 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 140 -280 0 0 {name=p3 lab=en}
C {devices/opin.sym} 280 -280 0 0 {name=p4 lab=en_b}
C {symbols/pfet_03v3.sym} 220 -360 0 0 {name=MP
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
C {symbols/nfet_03v3.sym} 220 -200 0 0 {name=MN
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
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
