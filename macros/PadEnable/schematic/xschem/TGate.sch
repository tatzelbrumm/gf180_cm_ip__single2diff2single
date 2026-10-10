v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {TGate} 60 -560 0 0 0.5 0.5 {}
T {CMOS transmission gate a <-> b: on when en = vdd (en_b = vss).} 60 -520 0 0 0.25 0.25 {}
T {Parameters W_N L_N (NMOS), W_P L_P (PMOS); nf=1. Bulks on the instance properties VDD, VSS} 60 -498 0 0 0.25 0.25 {}
T {(symbol pins are a b en en_b only, like the Avalon standard cells).} 60 -476 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written 2026-10-09, edit the sheet from now on.} 80 -20 0 0 0.2 0.2 {layer=4}
N 240 -380 240 -340 {lab=VDD}
N 240 -140 240 -100 {lab=VSS}
N 180 -340 210 -340 {lab=a}
N 140 -280 240 -280 {lab=en_b}
N 240 -300 240 -280 {lab=en_b}
N 140 -200 240 -200 {lab=en}
N 240 -200 240 -180 {lab=en}
N 180 -140 210 -140 {lab=a}
N 180 -340 180 -140 {lab=a}
N 270 -140 300 -140 {lab=b}
N 300 -340 300 -140 {lab=b}
N 140 -100 240 -100 {lab=VSS}
N 140 -380 240 -380 {lab=VDD}
N 270 -340 300 -340 {lab=b}
N 140 -240 180 -240 {lab=a}
N 300 -240 340 -240 {lab=b}
C {symbols/pfet_03v3.sym} 240 -320 3 0 {name=MP
L=\{L_P\}
W=\{W_P\}
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
C {symbols/nfet_03v3.sym} 240 -160 1 0 {name=MN
L=\{L_N\}
W=\{W_N\}
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
C {devices/iopin.sym} 140 -240 0 1 {name=p9 lab=a}
C {devices/iopin.sym} 340 -240 0 0 {name=p10 lab=b}
C {devices/ipin.sym} 140 -280 0 0 {name=p11 lab=en_b}
C {devices/ipin.sym} 140 -200 0 0 {name=p12 lab=en}
C {devices/iopin.sym} 140 -380 0 1 {name=p13 lab=VDD}
C {devices/iopin.sym} 140 -100 0 1 {name=p14 lab=VSS}
