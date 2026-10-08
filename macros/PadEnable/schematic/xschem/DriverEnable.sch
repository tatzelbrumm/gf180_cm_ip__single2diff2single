v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {DriverEnable} 60 -660 0 0 0.5 0.5 {}
T {Disable switches of ClassABDriver, on while en = 0:} 60 -600 0 0 0.25 0.25 {}
T {SA: a (gate of OP) to vddo, SB: b (gate of ON) to vsso -- OP and ON off, gates tied to their own rails as in a clamp;} 60 -578 0 0 0.25 0.25 {}
T {SABP: vabp to vdd, SABN: vabn to vss -- otherwise ABP / ABN conduct from the a pull-up into the b pull-down.} 60 -556 0 0 0.25 0.25 {}
T {SA and SB sit on the output-stage rails vddo / vsso (n-well of SA on vddo, SB in ON's tap ring on vsso).} 60 -534 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.} 60 -110 0 0 0.2 0.2 {layer=4}
N 300 -390 300 -340 {lab=a}
N 180 -390 180 -320 {lab=vabp}
N 300 -170 300 -120 {lab=vsso}
N 320 -200 320 -120 {lab=vsso}
N 180 -170 180 -140 {lab=vss}
N 200 -200 200 -140 {lab=vss}
N 300 -500 320 -500 {lab=vddo}
N 300 -420 320 -420 {lab=vddo}
N 180 -480 200 -480 {lab=vdd}
N 300 -200 320 -200 {lab=vsso}
N 300 -120 320 -120 {lab=vsso}
N 180 -200 200 -200 {lab=vss}
N 180 -140 200 -140 {lab=vss}
N 320 -500 320 -420 {lab=vddo}
N 200 -480 200 -420 {lab=vdd}
N 180 -420 200 -420 {lab=vdd}
N 180 -480 180 -450 {lab=vdd}
N 300 -500 300 -450 {lab=vddo}
N 240 -420 260 -420 {lab=en}
N 240 -420 240 -360 {lab=en}
N 120 -360 240 -360 {lab=en}
N 120 -420 140 -420 {lab=en}
N 120 -420 120 -360 {lab=en}
N 180 -320 360 -320 {lab=vabp}
N 300 -340 360 -340 {lab=a}
N 180 -300 180 -230 {lab=vabn}
N 180 -300 360 -300 {lab=vabn}
N 300 -280 300 -230 {lab=b}
N 300 -280 360 -280 {lab=b}
N 120 -260 240 -260 {lab=en_b}
N 240 -260 240 -200 {lab=en_b}
N 240 -200 260 -200 {lab=en_b}
N 120 -200 140 -200 {lab=en_b}
N 120 -260 120 -200 {lab=en_b}
N 80 -480 180 -480 {lab=vdd}
N 80 -140 180 -140 {lab=vss}
N 80 -500 300 -500 {lab=vddo}
N 80 -120 300 -120 {lab=vsso}
N 80 -360 120 -360 {lab=en}
N 80 -260 120 -260 {lab=en_b}
C {devices/iopin.sym} 80 -480 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 80 -140 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 80 -500 0 1 {name=p3 lab=vddo}
C {devices/iopin.sym} 80 -120 0 1 {name=p4 lab=vsso}
C {devices/ipin.sym} 80 -360 0 0 {name=p5 lab=en}
C {devices/ipin.sym} 80 -260 0 0 {name=p6 lab=en_b}
C {devices/iopin.sym} 360 -340 0 0 {name=p7 lab=a}
C {devices/iopin.sym} 360 -280 0 0 {name=p8 lab=b}
C {devices/iopin.sym} 360 -320 0 0 {name=p9 lab=vabp}
C {devices/iopin.sym} 360 -300 0 0 {name=p10 lab=vabn}
C {symbols/pfet_03v3.sym} 280 -420 0 0 {name=SA
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
C {devices/lab_pin.sym} 300 -370 0 1 {name=l12 sig_type=std_logic lab=a}
C {symbols/pfet_03v3.sym} 160 -420 0 0 {name=SABP
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
C {devices/lab_pin.sym} 180 -370 0 1 {name=l14 sig_type=std_logic lab=vabp}
C {symbols/nfet_03v3.sym} 280 -200 0 0 {name=SB
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
C {devices/lab_pin.sym} 300 -250 0 1 {name=l16 sig_type=std_logic lab=b}
C {symbols/nfet_03v3.sym} 160 -200 0 0 {name=SABN
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
C {devices/lab_pin.sym} 180 -250 0 1 {name=l18 sig_type=std_logic lab=vabn}
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
