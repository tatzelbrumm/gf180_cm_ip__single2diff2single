v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {gf180mcu_IOPadDiff2Single: class-AB differential -> single-ended pad driver with enable (PROOF OF CONCEPT, 2026-10-08)} 60 -1160 0 0 0.5 0.5 {}
T {Blocks: ClassABBiasIn (macros/ClassABBias): bias tree and the six diodes, fed by iref (5 uA into the pad) through BiasRefEnable.} 60 -1100 0 0 0.25 0.25 {}
T {ClassABDriver (macros/ClassABDriver): matched-pair DDA, folded cascode, class-AB output OP / ON, Miller compensation; vfb = out, so out - vref = (inp - inn)/2.} 60 -1076 0 0 0.25 0.25 {}
T {DriverEnable, EnableInv (macros/PadEnable): en = 0 -> OP / ON gates tied to vddo / vsso, vabp / vabn to vdd / vss, iref cut off and NI's gate line to vss.} 60 -1052 0 0 0.25 0.25 {}
T {Bias enters as a current (iref), never as a voltage. vddo / vsso: output-stage rails (OP, ON and their replicas RP1, RN1).} 60 -1028 0 0 0.25 0.25 {}
T {Not included yet: CDM / ESD network at out (OP and ON are meant to double as the pad clamps, IHP case (a)); a level shifter for a 1.2 V enable.} 60 -1004 0 0 0.25 0.25 {}
C {devices/iopin.sym} 60 -900 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 -880 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 60 -860 0 1 {name=p3 lab=vddo}
C {devices/iopin.sym} 60 -840 0 1 {name=p4 lab=vsso}
C {devices/ipin.sym} 60 -800 0 0 {name=p5 lab=inp}
C {devices/ipin.sym} 60 -780 0 0 {name=p6 lab=inn}
C {devices/ipin.sym} 60 -760 0 0 {name=p7 lab=vref}
C {devices/iopin.sym} 60 -720 0 1 {name=p8 lab=iref}
C {devices/ipin.sym} 60 -700 0 0 {name=p9 lab=en}
C {devices/iopin.sym} 1800 -800 0 0 {name=p10 lab=out}
C {ClassABBiasIn.sym} 800 -500 0 0 {name=xbias}
N 720 -680 700 -680 {lab=vdd}
C {devices/lab_pin.sym} 700 -680 0 0 {name=l11 sig_type=std_logic lab=vdd}
N 720 -320 700 -320 {lab=vss}
C {devices/lab_pin.sym} 700 -320 0 0 {name=l12 sig_type=std_logic lab=vss}
N 880 -680 900 -680 {lab=vddo}
C {devices/lab_pin.sym} 900 -680 0 1 {name=l13 sig_type=std_logic lab=vddo}
N 880 -320 900 -320 {lab=vsso}
C {devices/lab_pin.sym} 900 -320 0 1 {name=l14 sig_type=std_logic lab=vsso}
N 660 -500 640 -500 {lab=iref_en}
C {devices/lab_pin.sym} 640 -500 0 0 {name=l15 sig_type=std_logic lab=iref_en}
N 940 -600 960 -600 {lab=vbp}
C {devices/lab_pin.sym} 960 -600 0 1 {name=l16 sig_type=std_logic lab=vbp}
N 940 -560 960 -560 {lab=vbn}
C {devices/lab_pin.sym} 960 -560 0 1 {name=l17 sig_type=std_logic lab=vbn}
N 940 -520 960 -520 {lab=vbpc}
C {devices/lab_pin.sym} 960 -520 0 1 {name=l18 sig_type=std_logic lab=vbpc}
N 940 -480 960 -480 {lab=vbnc}
C {devices/lab_pin.sym} 960 -480 0 1 {name=l19 sig_type=std_logic lab=vbnc}
N 940 -440 960 -440 {lab=vabp}
C {devices/lab_pin.sym} 960 -440 0 1 {name=l20 sig_type=std_logic lab=vabp}
N 940 -400 960 -400 {lab=vabn}
C {devices/lab_pin.sym} 960 -400 0 1 {name=l21 sig_type=std_logic lab=vabn}
C {BiasRefEnable.sym} 360 -500 0 0 {name=xref}
N 360 -600 360 -620 {lab=vdd}
C {devices/lab_pin.sym} 360 -620 0 1 {name=l22 sig_type=std_logic lab=vdd}
N 360 -400 360 -380 {lab=vss}
C {devices/lab_pin.sym} 360 -380 0 1 {name=l23 sig_type=std_logic lab=vss}
N 240 -500 220 -500 {lab=en}
C {devices/lab_pin.sym} 220 -500 0 0 {name=l24 sig_type=std_logic lab=en}
N 240 -460 220 -460 {lab=en_b}
C {devices/lab_pin.sym} 220 -460 0 0 {name=l25 sig_type=std_logic lab=en_b}
N 240 -540 220 -540 {lab=iref}
C {devices/lab_pin.sym} 220 -540 0 0 {name=l26 sig_type=std_logic lab=iref}
N 480 -500 500 -500 {lab=iref_en}
C {devices/lab_pin.sym} 500 -500 0 1 {name=l27 sig_type=std_logic lab=iref_en}
C {ClassABDriver.sym} 1400 -560 0 0 {name=xdrv}
N 1280 -680 1260 -680 {lab=vdd}
C {devices/lab_pin.sym} 1260 -680 0 0 {name=l28 sig_type=std_logic lab=vdd}
N 1280 -440 1260 -440 {lab=vss}
C {devices/lab_pin.sym} 1260 -440 0 0 {name=l29 sig_type=std_logic lab=vss}
N 1560 -680 1580 -680 {lab=vddo}
C {devices/lab_pin.sym} 1580 -680 0 1 {name=l30 sig_type=std_logic lab=vddo}
N 1560 -440 1580 -440 {lab=vsso}
C {devices/lab_pin.sym} 1580 -440 0 1 {name=l31 sig_type=std_logic lab=vsso}
N 1220 -620 1200 -620 {lab=inp}
C {devices/lab_pin.sym} 1200 -620 0 0 {name=l32 sig_type=std_logic lab=inp}
N 1220 -580 1200 -580 {lab=inn}
C {devices/lab_pin.sym} 1200 -580 0 0 {name=l33 sig_type=std_logic lab=inn}
N 1220 -540 1200 -540 {lab=vref}
C {devices/lab_pin.sym} 1200 -540 0 0 {name=l34 sig_type=std_logic lab=vref}
N 1620 -620 1640 -620 {lab=out}
C {devices/lab_pin.sym} 1640 -620 0 1 {name=l35 sig_type=std_logic lab=out}
N 1220 -500 1200 -500 {lab=out}
C {devices/lab_pin.sym} 1200 -500 0 0 {name=l36 sig_type=std_logic lab=out}
N 1320 -440 1300 -440 {lab=vbp}
C {devices/lab_pin.sym} 1300 -440 0 0 {name=l37 sig_type=std_logic lab=vbp}
N 1360 -440 1340 -440 {lab=vbn}
C {devices/lab_pin.sym} 1340 -440 0 0 {name=l38 sig_type=std_logic lab=vbn}
N 1400 -440 1400 -420 {lab=vbpc}
C {devices/lab_pin.sym} 1400 -420 0 1 {name=l39 sig_type=std_logic lab=vbpc}
N 1440 -440 1460 -440 {lab=vbnc}
C {devices/lab_pin.sym} 1460 -440 0 1 {name=l40 sig_type=std_logic lab=vbnc}
N 1480 -440 1500 -440 {lab=vabp}
C {devices/lab_pin.sym} 1500 -440 0 1 {name=l41 sig_type=std_logic lab=vabp}
N 1520 -440 1540 -440 {lab=vabn}
C {devices/lab_pin.sym} 1540 -440 0 1 {name=l42 sig_type=std_logic lab=vabn}
N 1620 -660 1640 -660 {lab=a}
C {devices/lab_pin.sym} 1640 -660 0 1 {name=l43 sig_type=std_logic lab=a}
N 1620 -580 1640 -580 {lab=b}
C {devices/lab_pin.sym} 1640 -580 0 1 {name=l44 sig_type=std_logic lab=b}
C {DriverEnable.sym} 1400 -160 0 0 {name=xen}
N 1380 -280 1360 -280 {lab=vdd}
C {devices/lab_pin.sym} 1360 -280 0 0 {name=l45 sig_type=std_logic lab=vdd}
N 1380 -40 1360 -40 {lab=vss}
C {devices/lab_pin.sym} 1360 -40 0 0 {name=l46 sig_type=std_logic lab=vss}
N 1420 -280 1440 -280 {lab=vddo}
C {devices/lab_pin.sym} 1440 -280 0 1 {name=l47 sig_type=std_logic lab=vddo}
N 1420 -40 1440 -40 {lab=vsso}
C {devices/lab_pin.sym} 1440 -40 0 1 {name=l48 sig_type=std_logic lab=vsso}
N 1280 -180 1260 -180 {lab=en}
C {devices/lab_pin.sym} 1260 -180 0 0 {name=l49 sig_type=std_logic lab=en}
N 1280 -140 1260 -140 {lab=en_b}
C {devices/lab_pin.sym} 1260 -140 0 0 {name=l50 sig_type=std_logic lab=en_b}
N 1520 -220 1540 -220 {lab=a}
C {devices/lab_pin.sym} 1540 -220 0 1 {name=l51 sig_type=std_logic lab=a}
N 1520 -100 1540 -100 {lab=b}
C {devices/lab_pin.sym} 1540 -100 0 1 {name=l52 sig_type=std_logic lab=b}
N 1520 -180 1540 -180 {lab=vabp}
C {devices/lab_pin.sym} 1540 -180 0 1 {name=l53 sig_type=std_logic lab=vabp}
N 1520 -140 1540 -140 {lab=vabn}
C {devices/lab_pin.sym} 1540 -140 0 1 {name=l54 sig_type=std_logic lab=vabn}
C {EnableInv.sym} 360 -160 0 0 {name=xinv}
N 360 -220 360 -240 {lab=vdd}
C {devices/lab_pin.sym} 360 -240 0 1 {name=l55 sig_type=std_logic lab=vdd}
N 360 -100 360 -80 {lab=vss}
C {devices/lab_pin.sym} 360 -80 0 1 {name=l56 sig_type=std_logic lab=vss}
N 240 -160 220 -160 {lab=en}
C {devices/lab_pin.sym} 220 -160 0 0 {name=l57 sig_type=std_logic lab=en}
N 480 -160 500 -160 {lab=en_b}
C {devices/lab_pin.sym} 500 -160 0 1 {name=l58 sig_type=std_logic lab=en_b}
C {devices/title.sym} 160 220 0 0 {name=l0 author="Christoph Maier"}
