v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {OgueyAebischerRef_06v0: resistor-free Oguey-Aebischer current reference + start-up kick, GF180MCU 06v0 devices.
CACE DUT. Port order (symbol): vdd vbp vbn disable vbr vss.
H. J. Oguey and D. Aebischer, CMOS current reference without resistance,
IEEE J. Solid-State Circuits, vol. 32, no. 7, pp. 1132-1135, Jul. 1997} 380 -700 0 0 0.3 0.3 {}
N 380 -500 760 -500 {lab=vdd}
N 540 -500 540 -380 {lab=vdd}
N 760 -500 760 -380 {lab=vdd}
N 380 -200 760 -200 {lab=vss}
N 540 -300 540 -200 {lab=vss}
N 760 -300 760 -200 {lab=vss}
N 380 -320 480 -320 {lab=disable}
N 600 -360 620 -360 {lab=vbp}
N 620 -420 620 -360 {lab=vbp}
N 620 -420 840 -420 {lab=vbp}
N 840 -420 840 -360 {lab=vbp}
N 820 -360 840 -360 {lab=vbp}
N 840 -420 960 -420 {lab=vbp}
N 600 -340 640 -340 {lab=vbn}
N 640 -340 640 -260 {lab=vbn}
N 640 -260 860 -260 {lab=vbn}
N 860 -340 860 -260 {lab=vbn}
N 820 -340 860 -340 {lab=vbn}
N 860 -260 960 -260 {lab=vbn}
N 600 -320 620 -320 {lab=vbr}
N 620 -320 620 -240 {lab=vbr}
N 620 -240 840 -240 {lab=vbr}
N 840 -320 840 -240 {lab=vbr}
N 820 -320 840 -320 {lab=vbr}
N 840 -240 960 -240 {lab=vbr}
C {OgueyAebischerBias_06v0.sym} 760 -340 0 0 {name=xbias}
C {ToBiasStartup_06v0.sym} 540 -340 0 0 {name=xstart}
C {devices/iopin.sym} 380 -500 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 960 -420 0 0 {name=p2 lab=vbp}
C {devices/iopin.sym} 960 -260 0 0 {name=p3 lab=vbn}
C {devices/ipin.sym} 380 -320 0 0 {name=p4 lab=disable}
C {devices/iopin.sym} 960 -240 0 0 {name=p5 lab=vbr}
C {devices/iopin.sym} 380 -200 0 1 {name=p6 lab=vss}
C {devices/title.sym} 160 -40 0 0 {name=l1 author="Christoph Maier"}
