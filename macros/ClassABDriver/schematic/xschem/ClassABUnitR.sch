v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ppolyf_u_3k bulk = vss} 270 -330 0 0 0.2 0.2 {}
T {unit_r2: split-tail PMOS pair, ppolyf_u_3k degeneration (unit of d2s_mpdda)} 60 -640 0 0 0.4 0.4 {}
T {gp drains to y, gn drains to x; x and y go to the folding nodes} 60 -600 0 0 0.25 0.25 {}
T {GF180MCU (gf180mcuD) 03v3 port of the IHP sheet unit_r2.sch, 2026-10-08. Wires and placement unchanged;
devices pfet_03v3 / nfet_03v3 / ppolyf_u_3k, sizes re-derived for GF180 (README.md).} 60 -100 0 0 0.3 0.3 {layer=4}
N 60 -540 200 -540 {lab=vdd}
N 220 -540 220 -510 {lab=vdd}
N 200 -480 220 -480 {lab=vdd}
N 200 -540 200 -480 {lab=vdd}
N 400 -540 400 -510 {lab=vdd}
N 400 -480 420 -480 {lab=vdd}
N 420 -540 420 -480 {lab=vdd}
N 60 -420 260 -420 {lab=vbp}
N 260 -480 260 -420 {lab=vbp}
N 260 -480 360 -480 {lab=vbp}
N 220 -450 220 -360 {lab=sa}
N 220 -360 240 -360 {lab=sa}
N 220 -280 240 -280 {lab=sa}
N 240 -360 240 -280 {lab=sa}
N 400 -450 400 -360 {lab=sb}
N 380 -360 400 -360 {lab=sb}
N 380 -280 400 -280 {lab=sb}
N 380 -360 380 -280 {lab=sb}
N 60 -280 180 -280 {lab=gp}
N 60 -200 460 -200 {lab=gn}
N 460 -280 460 -200 {lab=gn}
N 440 -280 460 -280 {lab=gn}
N 220 -250 220 -120 {lab=y}
N 220 -120 520 -120 {lab=y}
N 400 -250 400 -160 {lab=x}
N 400 -160 520 -160 {lab=x}
N 400 -540 420 -540 {lab=vdd}
N 200 -540 220 -540 {lab=vdd}
N 220 -360 220 -310 {lab=sa}
N 240 -360 280 -360 {lab=sa}
N 400 -360 400 -310 {lab=sb}
N 220 -540 400 -540 {lab=vdd}
N 340 -360 380 -360 {lab=sb}
C {devices/opin.sym} 520 -160 0 0 {name=p1 lab=x}
C {devices/opin.sym} 520 -120 0 0 {name=p2 lab=y}
C {devices/ipin.sym} 60 -280 0 0 {name=p3 lab=gp}
C {devices/ipin.sym} 60 -200 0 0 {name=p4 lab=gn}
C {devices/iopin.sym} 60 -540 0 1 {name=p5 lab=vdd}
C {devices/iopin.sym} 60 -40 0 1 {name=p6 lab=vss}
C {devices/ipin.sym} 60 -420 0 0 {name=p7 lab=vbp}
C {symbols/pfet_03v3.sym} 240 -480 0 1 {name=Ta
L=6u
W=20u
nf=2
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
C {symbols/pfet_03v3.sym} 380 -480 0 0 {name=Tb
L=6u
W=20u
nf=2
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
C {symbols/pfet_03v3.sym} 200 -280 0 0 {name=Ma
L=1u
W=20u
nf=2
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
C {symbols/pfet_03v3.sym} 420 -280 0 1 {name=Mb
L=1u
W=20u
nf=2
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
C {symbols/ppolyf_u_3k.sym} 310 -360 3 0 {name=R
W=1u
L=50u
model=ppolyf_u_3k
spiceprefix=X
m=1
}
C {devices/lab_pin.sym} 310 -340 0 0 {name=lb_R sig_type=std_logic lab=vss}
C {devices/lab_wire.sym} 260 -360 0 0 {name=l1 sig_type=std_logic lab=sa}
C {devices/lab_wire.sym} 360 -360 0 1 {name=l2 sig_type=std_logic lab=sb}
