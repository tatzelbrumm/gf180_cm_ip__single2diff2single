v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {RefCoreEnable} 60 -560 0 0 0.5 0.5 {}
T {Disable switches of a self-biased reference core (ClassABBiasBG), on while en = 0:} 60 -500 0 0 0.25 0.25 {}
T {SPG: vpg (PMOS mirror gate line) to vdd -- every mirror branch off, iout = 0;} 60 -478 0 0 0.25 0.25 {}
T {SKS: ks (start-up node) to vss -- otherwise ks floats with MS1 off and MS3 would pull vpg.} 60 -456 0 0 0.25 0.25 {}
T {The core's always-on start-up pull-up MS1 has its gate on en_b (off while disabled).} 60 -434 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-09, edit the sheet from now on.} 150 -90 0 0 0.2 0.2 {layer=4}
N 300 -400 300 -350 {lab=vdd}
N 300 -290 300 -270 {lab=vpg}
N 300 -320 340 -320 {lab=vdd}
N 340 -400 340 -320 {lab=vdd}
N 300 -210 300 -190 {lab=ks}
N 300 -130 300 -100 {lab=vss}
N 300 -160 340 -160 {lab=vss}
N 340 -160 340 -100 {lab=vss}
N 140 -400 300 -400 {lab=vdd}
N 300 -400 340 -400 {lab=vdd}
N 140 -160 260 -160 {lab=en_b}
N 140 -100 300 -100 {lab=vss}
N 300 -100 340 -100 {lab=vss}
N 140 -320 260 -320 {lab=en}
N 300 -270 300 -260 {lab=vpg}
N 300 -260 380 -260 {lab=vpg}
N 300 -220 300 -210 {lab=ks}
N 300 -220 380 -220 {lab=ks}
C {devices/iopin.sym} 140 -400 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 140 -100 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 140 -320 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 140 -160 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 380 -260 0 0 {name=p5 lab=vpg}
C {devices/iopin.sym} 380 -220 0 0 {name=p6 lab=ks}
C {symbols/pfet_03v3.sym} 280 -320 0 0 {name=SPG
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
C {devices/lab_pin.sym} 300 -270 0 1 {name=l8 sig_type=std_logic lab=vpg}
C {symbols/nfet_03v3.sym} 280 -160 0 0 {name=SKS
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
C {devices/lab_pin.sym} 300 -210 0 1 {name=l10 sig_type=std_logic lab=ks}
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
