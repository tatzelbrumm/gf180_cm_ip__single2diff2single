v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {TGate} 60 -560 0 0 0.5 0.5 {}
T {CMOS transmission gate a <-> b: on when en = vdd (en_b = vss).} 60 -500 0 0 0.25 0.25 {}
T {Parameters W_N L_N (NMOS), W_P L_P (PMOS); nf=1. Bulks on the instance properties VDD, VSS} 60 -478 0 0 0.25 0.25 {}
T {(symbol pins are a b en en_b only, like the Avalon standard cells).} 60 -456 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written 2026-10-09, edit the sheet from now on.} 60 120 0 0 0.2 0.2 {layer=4}
C {symbols/pfet_03v3.sym} 220 -150 0 0 {name=MP
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
N 200 -150 160 -150 {lab=en_b}
C {devices/lab_pin.sym} 160 -150 0 0 {name=l1 sig_type=std_logic lab=en_b}
N 240 -180 240 -200 {lab=a}
C {devices/lab_pin.sym} 240 -200 0 1 {name=l2 sig_type=std_logic lab=a}
N 240 -120 240 -100 {lab=b}
C {devices/lab_pin.sym} 240 -100 0 1 {name=l3 sig_type=std_logic lab=b}
N 240 -150 280 -150 {lab=VDD}
C {devices/lab_pin.sym} 280 -150 0 1 {name=l4 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 460 -150 0 0 {name=MN
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
N 440 -150 400 -150 {lab=en}
C {devices/lab_pin.sym} 400 -150 0 0 {name=l5 sig_type=std_logic lab=en}
N 480 -180 480 -200 {lab=a}
C {devices/lab_pin.sym} 480 -200 0 1 {name=l6 sig_type=std_logic lab=a}
N 480 -120 480 -100 {lab=b}
C {devices/lab_pin.sym} 480 -100 0 1 {name=l7 sig_type=std_logic lab=b}
N 480 -150 520 -150 {lab=VSS}
C {devices/lab_pin.sym} 520 -150 0 1 {name=l8 sig_type=std_logic lab=VSS}
N 60 -220 640 -220 {lab=a}
N 60 -80 640 -80 {lab=b}
N 240 -200 240 -220 {lab=a}
N 240 -100 240 -80 {lab=b}
N 480 -200 480 -220 {lab=a}
N 480 -100 480 -80 {lab=b}
C {devices/iopin.sym} 60 -220 0 0 {name=p9 lab=a}
C {devices/iopin.sym} 640 -80 0 1 {name=p10 lab=b}
C {devices/ipin.sym} 60 -320 0 0 {name=p11 lab=en_b}
C {devices/ipin.sym} 60 -360 0 0 {name=p12 lab=en}
C {devices/iopin.sym} 60 40 0 0 {name=p13 lab=VDD}
C {devices/iopin.sym} 60 80 0 0 {name=p14 lab=VSS}
