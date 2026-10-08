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
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 60 -110 0 0 0.2 0.2 {layer=4}
N 150 -380 170 -380 {lab=iin}
N 230 -380 250 -380 {lab=iout}
N 200 -420 200 -380 {lab=vdd}
N 230 -180 250 -180 {lab=iout}
N 150 -180 170 -180 {lab=iin}
N 200 -180 200 -140 {lab=vss}
N 360 -250 360 -230 {lab=iout}
N 360 -170 360 -140 {lab=vss}
N 380 -200 380 -140 {lab=vss}
N 200 -340 200 -320 {lab=en_b}
N 140 -380 140 -180 {lab=iin}
N 140 -180 150 -180 {lab=iin}
N 140 -380 150 -380 {lab=iin}
N 100 -280 140 -280 {lab=iin}
N 250 -380 260 -380 {lab=iout}
N 260 -380 260 -180 {lab=iout}
N 250 -180 260 -180 {lab=iout}
N 100 -320 200 -320 {lab=en_b}
N 100 -240 200 -240 {lab=en}
N 200 -240 200 -220 {lab=en}
N 200 -320 300 -320 {lab=en_b}
N 300 -320 300 -200 {lab=en_b}
N 300 -200 320 -200 {lab=en_b}
N 260 -280 420 -280 {lab=iout}
N 360 -200 380 -200 {lab=vss}
N 100 -140 380 -140 {lab=vss}
N 360 -280 360 -250 {lab=iout}
N 100 -420 200 -420 {lab=vdd}
C {devices/iopin.sym} 100 -420 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 100 -140 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 100 -240 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 100 -320 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 100 -280 0 1 {name=p5 lab=iin}
C {devices/iopin.sym} 420 -280 0 0 {name=p6 lab=iout}
C {symbols/pfet_03v3.sym} 200 -360 3 0 {name=TGP
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
C {symbols/nfet_03v3.sym} 200 -200 1 0 {name=TGN
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
C {symbols/nfet_03v3.sym} 340 -200 0 0 {name=TDN
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
