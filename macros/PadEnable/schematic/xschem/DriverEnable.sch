v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {DriverEnable} 60 -560 0 0 0.5 0.5 {}
T {Disable switches of ClassABDriver, on while en = 0:} 60 -500 0 0 0.25 0.25 {}
T {SA: a (gate of OP) to vddo, SB: b (gate of ON) to vsso -- OP and ON off, gates tied to their own rails as in a clamp;} 60 -478 0 0 0.25 0.25 {}
T {SABP: vabp to vdd, SABN: vabn to vss -- otherwise ABP / ABN conduct from the a pull-up into the b pull-down.} 60 -456 0 0 0.25 0.25 {}
T {SA and SB sit on the output-stage rails vddo / vsso (n-well of SA on vddo, SB in ON's tap ring on vsso).} 60 -434 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 60 120 0 0 0.2 0.2 {layer=4}
N 60 -340 560 -340 {lab=vddo}
N 60 -320 560 -320 {lab=vdd}
N 60 0 560 0 {lab=vss}
N 60 20 560 20 {lab=vsso}
C {devices/iopin.sym} 60 -320 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 0 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 60 -340 0 1 {name=p3 lab=vddo}
C {devices/iopin.sym} 60 20 0 1 {name=p4 lab=vsso}
C {devices/ipin.sym} 60 -200 0 0 {name=p5 lab=en}
C {devices/ipin.sym} 60 -160 0 0 {name=p6 lab=en_b}
C {devices/iopin.sym} 640 -220 0 0 {name=p7 lab=a}
C {devices/iopin.sym} 640 -180 0 0 {name=p8 lab=b}
C {devices/iopin.sym} 640 -140 0 0 {name=p9 lab=vabp}
C {devices/iopin.sym} 640 -100 0 0 {name=p10 lab=vabn}
C {symbols/pfet_03v3.sym} 200 -220 0 0 {name=SA
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
N 180 -220 140 -220 {lab=en}
C {devices/lab_pin.sym} 140 -220 0 0 {name=l11 sig_type=std_logic lab=en}
N 220 -250 220 -340 {lab=vddo}
N 220 -190 220 -170 {lab=a}
C {devices/lab_pin.sym} 220 -170 0 1 {name=l12 sig_type=std_logic lab=a}
N 220 -220 260 -220 {lab=vddo}
N 260 -220 260 -340 {lab=vddo}
C {symbols/pfet_03v3.sym} 400 -220 0 0 {name=SABP
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
N 380 -220 340 -220 {lab=en}
C {devices/lab_pin.sym} 340 -220 0 0 {name=l13 sig_type=std_logic lab=en}
N 420 -250 420 -320 {lab=vdd}
N 420 -190 420 -170 {lab=vabp}
C {devices/lab_pin.sym} 420 -170 0 1 {name=l14 sig_type=std_logic lab=vabp}
N 420 -220 460 -220 {lab=vdd}
N 460 -220 460 -320 {lab=vdd}
C {symbols/nfet_03v3.sym} 200 -60 0 0 {name=SB
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
N 180 -60 140 -60 {lab=en_b}
C {devices/lab_pin.sym} 140 -60 0 0 {name=l15 sig_type=std_logic lab=en_b}
N 220 -90 220 -110 {lab=b}
C {devices/lab_pin.sym} 220 -110 0 1 {name=l16 sig_type=std_logic lab=b}
N 220 -30 220 20 {lab=vsso}
N 220 -60 260 -60 {lab=vsso}
N 260 -60 260 20 {lab=vsso}
C {symbols/nfet_03v3.sym} 400 -60 0 0 {name=SABN
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
C {devices/lab_pin.sym} 340 -60 0 0 {name=l17 sig_type=std_logic lab=en_b}
N 420 -90 420 -110 {lab=vabn}
C {devices/lab_pin.sym} 420 -110 0 1 {name=l18 sig_type=std_logic lab=vabn}
N 420 -30 420 0 {lab=vss}
N 420 -60 460 -60 {lab=vss}
N 460 -60 460 0 {lab=vss}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
