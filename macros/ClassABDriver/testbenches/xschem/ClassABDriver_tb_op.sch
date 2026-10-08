v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ClassABDriver_tb_op: operating point of d2s_mpdda at vd = 0: device currents and saturation margin} 60 -440 0 0 0.5 0.5 {}
T {DUT and bias from ../../schematic/xschem and ../../../ClassABBias/schematic/xschem; code block = the deck's .lib/.param/.save lines and its .control section} 60 -395 0 0 0.3 0.3 {}
N 100 -300 100 170 {lab=vdd}
N 100 230 100 700 {lab=GND}
N 200 130 200 170 {lab=vref}
N 200 230 200 700 {lab=GND}
N 620 -300 620 300 {lab=vdd}
N 620 620 620 700 {lab=GND}
N 920 -300 920 -80 {lab=vdd}
N 920 160 920 700 {lab=GND}
N 840 360 960 360 {lab=vbp}
N 960 160 960 360 {lab=vbp}
N 840 400 1000 400 {lab=vbn}
N 1000 160 1000 400 {lab=vbn}
N 840 440 1040 440 {lab=vbpc}
N 1040 160 1040 440 {lab=vbpc}
N 840 480 1080 480 {lab=vbnc}
N 1080 160 1080 480 {lab=vbnc}
N 840 520 1120 520 {lab=vabp}
N 1120 160 1120 520 {lab=vabp}
N 840 560 1160 560 {lab=vabn}
N 1160 160 1160 560 {lab=vabn}
N 300 230 300 700 {lab=GND}
N 300 -20 300 170 {lab=vinp}
N 300 -20 860 -20 {lab=vinp}
N 400 230 400 700 {lab=GND}
N 400 20 400 170 {lab=vinn}
N 400 20 860 20 {lab=vinn}
N 820 60 860 60 {lab=vref}
N 820 100 860 100 {lab=vout}
N 1260 -20 1320 -20 {lab=vout}
N 1420 -20 1460 -20 {lab=vout}
N 1320 -20 1320 40 {lab=vout}
N 1320 100 1320 140 {lab=vref}
N 1420 -20 1420 40 {lab=vout}
N 1420 100 1420 700 {lab=GND}
N 60 -300 100 -300 {lab=vdd}
N 100 700 200 700 {lab=GND}
N 1320 -20 1420 -20 {lab=vout}
N 620 -300 920 -300 {lab=vdd}
N 100 -300 620 -300 {lab=vdd}
N 300 700 400 700 {lab=GND}
N 200 700 300 700 {lab=GND}
N 920 700 1420 700 {lab=GND}
N 620 700 920 700 {lab=GND}
N 400 700 620 700 {lab=GND}
N 480 130 480 170 {lab=vddo}
N 480 230 480 700 {lab=GND}
N 560 130 560 170 {lab=vsso}
N 560 230 560 700 {lab=GND}
N 1200 -120 1200 -80 {lab=vddo}
N 1200 160 1200 200 {lab=vsso}
N 660 260 660 300 {lab=vddo}
N 660 620 660 660 {lab=vsso}
C {devices/vsource.sym} 100 200 0 0 {name=Vdd value=3.3 savecurrent=false}
C {devices/vsource.sym} 200 200 0 0 {name=Vcm value=1.65 savecurrent=false}
C {devices/lab_pin.sym} 200 130 0 1 {name=l1 sig_type=std_logic lab=vref}
C {ClassABBiasIdeal.sym} 700 460 0 0 {name=Xb}
C {ClassABDriver.sym} 1040 40 0 0 {name=Xd}
C {devices/lab_wire.sym} 960 360 0 0 {name=l2 sig_type=std_logic lab=vbp}
C {devices/lab_wire.sym} 1000 400 0 0 {name=l3 sig_type=std_logic lab=vbn}
C {devices/lab_wire.sym} 1040 440 0 0 {name=l4 sig_type=std_logic lab=vbpc}
C {devices/lab_wire.sym} 1080 480 0 0 {name=l5 sig_type=std_logic lab=vbnc}
C {devices/lab_wire.sym} 1120 520 0 0 {name=l6 sig_type=std_logic lab=vabp}
C {devices/lab_wire.sym} 1160 560 0 0 {name=l7 sig_type=std_logic lab=vabn}
C {devices/vsource.sym} 300 200 0 0 {name=Vp value=1.65 savecurrent=false}
C {devices/lab_wire.sym} 300 -20 0 0 {name=l8 sig_type=std_logic lab=vinp}
C {devices/vsource.sym} 400 200 0 0 {name=Vn value=1.65 savecurrent=false}
C {devices/lab_wire.sym} 400 20 0 0 {name=l9 sig_type=std_logic lab=vinn}
C {devices/lab_pin.sym} 820 60 0 0 {name=l10 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 820 100 0 0 {name=l11 sig_type=std_logic lab=vout}
C {devices/lab_pin.sym} 1460 -20 0 1 {name=l12 sig_type=std_logic lab=vout}
C {devices/res.sym} 1320 70 0 0 {name=RL value=1k m=1}
C {devices/lab_pin.sym} 1320 140 0 1 {name=l13 sig_type=std_logic lab=vref}
C {devices/capa.sym} 1420 70 0 0 {name=CL value=100p m=1}
C {devices/code_shown.sym} 60 820 0 0 {name=s1 only_toplevel=false value=".control
op
print v(xd.x) v(xd.y) v(xd.a) v(xd.b) v(xd.l1) v(xd.l2) v(xd.pl) v(xd.pr) i(vdd) i(vddo)
print @m.xd.xsx.m0[id] @m.xd.xsx.m0[vds] @m.xd.xsx.m0[vdsat]
print @m.xd.xsy.m0[id] @m.xd.xsy.m0[vds] @m.xd.xsy.m0[vdsat]
print @m.xd.xcx.m0[id] @m.xd.xcx.m0[vds] @m.xd.xcx.m0[vdsat]
print @m.xd.xcy.m0[id] @m.xd.xcy.m0[vds] @m.xd.xcy.m0[vdsat]
print @m.xd.xfnl.m0[id] @m.xd.xfnl.m0[vds] @m.xd.xfnl.m0[vdsat]
print @m.xd.xabn.m0[id] @m.xd.xabn.m0[vds] @m.xd.xabn.m0[vdsat]
print @m.xd.xon.m0[id] @m.xd.xon.m0[vds] @m.xd.xon.m0[vdsat]
print @m.xd.xpl.m0[id] @m.xd.xpl.m0[vds] @m.xd.xpl.m0[vdsat]
print @m.xd.xpr.m0[id] @m.xd.xpr.m0[vds] @m.xd.xpr.m0[vdsat]
print @m.xd.xpcl.m0[id] @m.xd.xpcl.m0[vds] @m.xd.xpcl.m0[vdsat]
print @m.xd.xpcr.m0[id] @m.xd.xpcr.m0[vds] @m.xd.xpcr.m0[vdsat]
print @m.xd.xfpl.m0[id] @m.xd.xfpl.m0[vds] @m.xd.xfpl.m0[vdsat]
print @m.xd.xabp.m0[id] @m.xd.xabp.m0[vds] @m.xd.xabp.m0[vdsat]
print @m.xd.xop.m0[id] @m.xd.xop.m0[vds] @m.xd.xop.m0[vdsat]
.endc"}
C {devices/lab_wire.sym} 60 -300 0 0 {name=l14 sig_type=std_logic lab=vdd}
C {devices/gnd.sym} 800 700 0 0 {name=l0 lab=GND}
C {devices/vsource.sym} 480 200 0 0 {name=Vddo value=3.3 savecurrent=false}
C {devices/vsource.sym} 560 200 0 0 {name=Vsso value=0 savecurrent=false}
C {devices/lab_pin.sym} 480 130 0 1 {name=l31 sig_type=std_logic lab=vddo}
C {devices/lab_pin.sym} 560 130 0 1 {name=l32 sig_type=std_logic lab=vsso}
C {devices/lab_pin.sym} 1200 -120 0 1 {name=l33 sig_type=std_logic lab=vddo}
C {devices/lab_pin.sym} 1200 200 0 1 {name=l34 sig_type=std_logic lab=vsso}
C {devices/lab_pin.sym} 660 260 0 1 {name=l35 sig_type=std_logic lab=vddo}
C {devices/lab_pin.sym} 660 660 0 1 {name=l36 sig_type=std_logic lab=vsso}
C {devices/code_shown.sym} 1160 820 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
"}
T {GF180MCU (gf180mcuD) 03v3 port of the IHP sheet tb_mpdda_op.sch, 2026-10-08. Wires and placement unchanged;
devices pfet_03v3 / nfet_03v3 / ppolyf_u_3k, sizes re-derived for GF180 (README.md).} 60 -560 0 0 0.3 0.3 {layer=4}
