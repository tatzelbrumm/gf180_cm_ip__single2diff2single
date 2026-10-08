v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {InputEnable} 80 -580 0 0 0.5 0.5 {}
T {Input switch of an analog input pad, behind the CDM resistor:} 80 -520 0 0 0.25 0.25 {}
T {TGN1 / TGP1 pass pin to pout while en = 1; while en = 0 they open and TGN2 / TGP2 park pout on vpark} 80 -498 0 0 0.25 0.25 {}
T {(the common-mode reference), so the circuit behind the pad sees a defined input when the pad is off.} 80 -476 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 80 -100 0 0 0.2 0.2 {layer=4}
N 260 -340 260 -220 {lab=en_b}
N 290 -380 390 -380 {lab=pout}
N 260 -420 260 -380 {lab=vdd}
N 240 -160 240 -120 {lab=vss}
N 450 -380 480 -380 {lab=vpark}
N 420 -420 420 -380 {lab=vdd}
N 400 -220 400 -200 {lab=en_b}
N 430 -160 480 -160 {lab=vpark}
N 400 -160 400 -120 {lab=vss}
N 180 -380 180 -160 {lab=pin}
N 180 -380 230 -380 {lab=pin}
N 180 -160 210 -160 {lab=pin}
N 100 -420 260 -420 {lab=vdd}
N 100 -120 240 -120 {lab=vss}
N 260 -420 420 -420 {lab=vdd}
N 240 -120 400 -120 {lab=vss}
N 270 -160 370 -160 {lab=pout}
N 480 -380 480 -160 {lab=vpark}
N 240 -320 420 -320 {lab=en}
N 240 -320 240 -200 {lab=en}
N 260 -220 400 -220 {lab=en_b}
N 420 -340 420 -320 {lab=en}
N 100 -320 240 -320 {lab=en}
N 100 -220 260 -220 {lab=en_b}
N 340 -380 340 -160 {lab=pout}
N 340 -280 520 -280 {lab=pout}
N 100 -260 480 -260 {lab=vpark}
N 100 -280 180 -280 {lab=pin}
C {devices/iopin.sym} 100 -420 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 100 -120 0 1 {name=p2 lab=vss}
C {devices/ipin.sym} 100 -320 0 0 {name=p3 lab=en}
C {devices/ipin.sym} 100 -220 0 0 {name=p4 lab=en_b}
C {devices/iopin.sym} 100 -280 0 1 {name=p5 lab=pin}
C {devices/iopin.sym} 520 -280 0 0 {name=p6 lab=pout}
C {devices/ipin.sym} 100 -260 0 0 {name=p7 lab=vpark}
C {symbols/pfet_03v3.sym} 260 -360 3 0 {name=TGP1
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
C {devices/lab_pin.sym} 260 -420 3 1 {name=l11 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 240 -180 1 0 {name=TGN1
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
C {symbols/pfet_03v3.sym} 420 -360 1 1 {name=TGP2
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
C {devices/lab_pin.sym} 420 -420 1 0 {name=l19 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} 400 -180 3 1 {name=TGN2
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
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
