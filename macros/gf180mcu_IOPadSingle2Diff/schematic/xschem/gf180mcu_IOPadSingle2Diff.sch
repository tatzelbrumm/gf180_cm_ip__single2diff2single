v {xschem version=3.4.4 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 60 -500 640 -500 {lab=vdd}
N 60 -100 640 -100 {lab=vss}
N 60 -300 230 -300 {lab=in}
N 290 -300 520 -300 {lab=in_prot}
N 260 -280 260 -100 {lab=vss}
N 400 -350 400 -300 {lab=in_prot}
N 400 -410 400 -500 {lab=vdd}
N 400 -250 400 -300 {lab=in_prot}
N 400 -190 400 -100 {lab=vss}
N 60 -260 120 -260 {lab=vcm}
N 580 -220 640 -220 {lab=outp}
N 580 -180 640 -180 {lab=outn}
C {devices/iopin.sym} 60 -500 0 1 {name=p1 lab=vdd}
C {devices/opin.sym} 640 -220 0 0 {name=p2 lab=outp}
C {devices/ipin.sym} 60 -260 0 0 {name=p3 lab=vcm}
C {devices/ipin.sym} 60 -300 0 0 {name=p4 lab=in}
C {devices/opin.sym} 640 -180 0 0 {name=p5 lab=outn}
C {devices/iopin.sym} 60 -100 0 1 {name=p6 lab=vss}
C {symbols/ppolyf_u_1k_6p0.sym} 260 -300 3 0 {name=Rcdm
W=5e-6
L=1e-6
model=ppolyf_u_1k_6p0
spiceprefix=X
m=1}
C {symbols/diode_pd2nw_06v0.sym} 400 -380 2 0 {name=Dcdmp
model=diode_pd2nw_06v0
r_w=2u
r_l=12u
m=1}
C {symbols/diode_nd2ps_06v0.sym} 400 -220 2 0 {name=Dcdmn
model=diode_nd2ps_06v0
r_w=2u
r_l=12u
m=1}
C {devices/lab_pin.sym} 520 -300 0 1 {name=l2 lab=in_prot}
C {devices/lab_pin.sym} 120 -260 0 1 {name=l3 lab=vcm}
C {devices/lab_pin.sym} 580 -220 0 0 {name=l4 lab=outp}
C {devices/lab_pin.sym} 580 -180 0 0 {name=l5 lab=outn}
C {devices/title.sym} 160 -40 0 0 {name=l1 author="Christoph Maier"}
T {gf180mcu_IOPadSingle2Diff - PROOF OF CONCEPT, input side only (2026-10-06).
Analog pad gf180mcu_ocd_io__asig_5p0 (harness side) has HBM diodes only; this is the
CDM protection next to the gates, numbers from Tim Edwards (FOSSi Chipalooza chat):
  series poly resistor > 50 Ohm   -> Rcdm ppolyf_u_1k_6p0, 5u x 1u, about 200 Ohm (placeholder)
  diode perimeter > 25 um         -> 2u x 12u, perimeter 28 um, to vdd and to vss
The single-ended -> differential buffer is NOT designed yet: in_prot, vcm, outp, outn
are unconnected (IHP counterpart was an empty stub as well).
Note: the diode to vdd clamps in_prot (and the pad, through Rcdm) to about vdd + 0.6 V.
With vdd = 3.3 V the input range is therefore NOT 5 V tolerant; see the CACE input_params.} 60 -900 0 0 0.3 0.3 {}
