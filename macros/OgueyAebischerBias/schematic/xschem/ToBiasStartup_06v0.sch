v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 900 -480 920 -480 { lab=vdd}
N 920 -540 920 -480 { lab=vdd}
N 900 -540 900 -510 { lab=vdd}
N 840 -480 860 -480 { lab=vkick}
N 740 -340 970 -340 { lab=vbn}
N 400 -480 420 -480 { lab=vdd}
N 400 -540 400 -480 { lab=vdd}
N 420 -540 420 -510 { lab=vdd}
N 350 -540 400 -540 { lab=vdd}
N 350 -100 420 -100 { lab=vss}
N 740 -480 760 -480 { lab=vdd}
N 760 -540 760 -480 { lab=vdd}
N 740 -540 740 -510 { lab=vdd}
N 680 -480 700 -480 { lab=vkick}
N 900 -160 920 -160 { lab=vss}
N 920 -160 920 -100 { lab=vss}
N 900 -130 900 -100 { lab=vss}
N 740 -160 760 -160 { lab=vss}
N 760 -160 760 -100 { lab=vss}
N 740 -130 740 -100 { lab=vss}
N 900 -220 900 -190 { lab=vbr}
N 740 -340 740 -190 { lab=vbn}
N 900 -220 970 -220 { lab=vbr}
N 580 -420 970 -420 { lab=vbp}
N 480 -480 480 -420 { lab=vbp}
N 460 -480 480 -480 { lab=vbp}
N 680 -480 680 -380 { lab=vkick}
N 840 -480 840 -380 { lab=vkick}
N 420 -450 420 -380 { lab=vkick}
N 740 -450 740 -340 { lab=vbn}
N 900 -450 900 -220 { lab=vbr}
N 350 -240 380 -240 { lab=disable}
N 380 -260 380 -240 { lab=disable}
N 380 -260 390 -260 { lab=disable}
N 450 -260 460 -260 { lab=disable}
N 460 -260 460 -240 { lab=disable}
N 380 -240 460 -240 { lab=disable}
N 460 -240 680 -240 { lab=disable}
N 680 -240 680 -160 { lab=disable}
N 680 -160 700 -160 { lab=disable}
N 680 -240 840 -240 { lab=disable}
N 840 -240 840 -160 { lab=disable}
N 840 -160 860 -160 { lab=disable}
N 680 -380 840 -380 { lab=vkick}
N 420 -380 680 -380 { lab=vkick}
N 420 -380 420 -300 { lab=vkick}
N 580 -420 580 -300 { lab=vbp}
N 540 -260 550 -260 { lab=vdd}
N 540 -540 540 -260 { lab=vdd}
N 540 -540 620 -540 { lab=vdd}
N 620 -540 620 -260 { lab=vdd}
N 610 -260 620 -260 { lab=vdd}
N 900 -540 920 -540 { lab=vdd}
N 760 -540 900 -540 { lab=vdd}
N 400 -540 420 -540 { lab=vdd}
N 740 -540 760 -540 { lab=vdd}
N 620 -540 740 -540 { lab=vdd}
N 480 -420 580 -420 { lab=vbp}
N 420 -540 540 -540 { lab=vdd}
N 580 -260 580 -100 { lab=vss}
N 420 -260 420 -100 { lab=vss}
N 900 -100 920 -100 { lab=vss}
N 760 -100 900 -100 { lab=vss}
N 740 -100 760 -100 { lab=vss}
N 580 -100 740 -100 { lab=vss}
N 420 -100 580 -100 { lab=vss}
C {devices/title.sym} 160 -40 0 0 {name=l1 author="Christoph Maier"}
C {symbols/nfet_06v0.sym} 880 -160 0 0 {name=M24
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {symbols/pfet_06v0.sym} 880 -480 0 0 {name=M22
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_06v0
spiceprefix=X
}
C {symbols/pfet_06v0.sym} 440 -480 0 1 {name=M25
L=4u
W=24u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_06v0
spiceprefix=X
}
C {devices/iopin.sym} 360 -100 0 1 {name=p1 lab=vss}
C {devices/iopin.sym} 360 -540 0 1 {name=p2 lab=vdd}
C {devices/iopin.sym} 960 -420 0 0 {name=p3 lab=vbp}
C {devices/iopin.sym} 960 -340 0 0 {name=p4 lab=vbn}
C {symbols/nfet_06v0.sym} 720 -160 0 0 {name=M23
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {symbols/pfet_06v0.sym} 720 -480 0 0 {name=M21
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_06v0
spiceprefix=X
}
C {symbols/nfet_06v0.sym} 420 -280 1 0 {name=M20
L=4u
W=8u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {symbols/nfet_06v0.sym} 580 -280 1 0 {name=M26
L=4u
W=8u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {devices/iopin.sym} 960 -220 0 0 {name=p5 lab=vbr}
C {devices/ipin.sym} 360 -240 0 0 {name=p6 lab=disable}
C {devices/lab_wire.sym} 500 -380 0 0 {name=l11 lab=vkick}
T {GF180MCU port (06v0 devices) of the IHP sg13cmos5l design, 2026-10-06. Wires and placement unchanged; W/L re-derived for GF180, see macro README.} 160 -880 0 0 0.3 0.3 {}
