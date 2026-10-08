v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {BiasRefEnable} 60 -560 0 0 0.5 0.5 {}
T {Reference-current switch in front of ClassABBiasIn (NMOS input diode NI):} 60 -500 0 0 0.25 0.25 {}
T {TGN / TGP pass iin to iout while en = 1; while en = 0 they open and TDN pulls iout,} 60 -478 0 0 0.25 0.25 {}
T {NI's gate line, to vss. The external reference is not relied on to switch off.} 60 -456 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 60 120 0 0 0.2 0.2 {layer=4}
N 60 -300 560 -300 {lab=vdd}
N 60 0 560 0 {lab=vss}
C {devices/iopin.sym} 60 -300 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 0 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 60 -180 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 60 -140 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 60 -100 0 1 {name=p5 lab=iin}
C {devices/iopin.sym} 640 -100 0 0 {name=p6 lab=iout}
C {symbols/pfet_03v3.sym} 200 -220 0 0 {name=TGP
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
N 180 -220 140 -220 {lab=en_b}
C {devices/lab_pin.sym} 140 -220 0 0 {name=l7 sig_type=std_logic lab=en_b}
N 220 -250 220 -270 {lab=iin}
C {devices/lab_pin.sym} 220 -270 0 1 {name=l8 sig_type=std_logic lab=iin}
N 220 -190 220 -170 {lab=iout}
C {devices/lab_pin.sym} 220 -170 0 1 {name=l9 sig_type=std_logic lab=iout}
N 220 -220 260 -220 {lab=vdd}
C {devices/lab_pin.sym} 260 -220 0 1 {name=l10 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 200 -60 0 0 {name=TGN
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
C {devices/lab_pin.sym} 140 -60 0 0 {name=l11 sig_type=std_logic lab=en}
N 220 -90 220 -110 {lab=iin}
C {devices/lab_pin.sym} 220 -110 0 1 {name=l12 sig_type=std_logic lab=iin}
N 220 -30 220 -10 {lab=iout}
C {devices/lab_pin.sym} 220 -10 0 1 {name=l13 sig_type=std_logic lab=iout}
N 220 -60 260 -60 {lab=vss}
C {devices/lab_pin.sym} 260 -60 0 1 {name=l14 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 400 -60 0 0 {name=TDN
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
N 380 -60 340 -60 {lab=en_b}
C {devices/lab_pin.sym} 340 -60 0 0 {name=l15 sig_type=std_logic lab=en_b}
N 420 -90 420 -110 {lab=iout}
C {devices/lab_pin.sym} 420 -110 0 1 {name=l16 sig_type=std_logic lab=iout}
N 420 -30 420 0 {lab=vss}
N 420 -60 460 -60 {lab=vss}
N 460 -60 460 0 {lab=vss}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
