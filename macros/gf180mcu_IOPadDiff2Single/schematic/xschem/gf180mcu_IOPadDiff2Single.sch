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
T {Bias enters as a current (iref), never as a voltage. vddo / vsso: output-stage rails (OP, ON and their replicas RP1, RN1).} 60 -1268 0 0 0.25 0.25 {}
T {Not included yet: CDM / ESD network at out (OP and ON are meant to double as the pad clamps, IHP case (a)); a level shifter for a 1.2 V enable.} 60 -1244 0 0 0.25 0.25 {}
N 700 -920 720 -920 {lab=vdd}
N 700 -560 720 -560 {lab=vss}
N 880 -920 900 -920 {lab=vddo}
N 880 -560 900 -560 {lab=vsso}
N 640 -740 660 -740 {lab=iref_en}
N 940 -840 960 -840 {lab=vbp}
N 940 -800 960 -800 {lab=vbn}
N 940 -760 960 -760 {lab=vbpc}
N 940 -720 960 -720 {lab=vbnc}
N 940 -680 960 -680 {lab=vabp}
N 940 -640 960 -640 {lab=vabn}
N 360 -860 360 -840 {lab=vdd}
N 360 -640 360 -620 {lab=vss}
N 220 -740 240 -740 {lab=en}
N 220 -700 240 -700 {lab=en_b}
N 220 -780 240 -780 {lab=iref}
N 480 -740 500 -740 {lab=iref_en}
N 1260 -920 1280 -920 {lab=vdd}
N 1260 -680 1280 -680 {lab=vss}
N 1560 -920 1580 -920 {lab=vddo}
N 1560 -680 1580 -680 {lab=vsso}
N 1200 -860 1220 -860 {lab=inp}
N 1200 -820 1220 -820 {lab=inn}
N 1200 -780 1220 -780 {lab=vref}
N 1620 -860 1640 -860 {lab=out}
N 1200 -740 1220 -740 {lab=out}
N 1300 -680 1320 -680 {lab=vbp}
N 1340 -680 1360 -680 {lab=vbn}
N 1400 -680 1400 -660 {lab=vbpc}
N 1440 -680 1460 -680 {lab=vbnc}
N 1480 -680 1500 -680 {lab=vabp}
N 1520 -680 1540 -680 {lab=vabn}
N 1620 -900 1640 -900 {lab=a}
N 1620 -820 1640 -820 {lab=b}
N 1360 -520 1380 -520 {lab=vdd}
N 1360 -280 1380 -280 {lab=vss}
N 1420 -520 1440 -520 {lab=vddo}
N 1420 -280 1440 -280 {lab=vsso}
N 1260 -420 1280 -420 {lab=en}
N 1260 -380 1280 -380 {lab=en_b}
N 1520 -460 1540 -460 {lab=a}
N 1520 -340 1540 -340 {lab=b}
N 1520 -420 1540 -420 {lab=vabp}
N 1520 -380 1540 -380 {lab=vabn}
N 360 -450 360 -430 {lab=vdd}
N 360 -360 360 -340 {lab=vss}
N 300 -400 320 -400 {lab=en}
N 400 -400 420 -400 {lab=en_b}
C {devices/iopin.sym} 60 -900 0 1 {name=p1 lab=vdd}
C {devices/iopin.sym} 60 -140 0 1 {name=p2 lab=vss}
C {devices/iopin.sym} 60 -920 0 1 {name=p3 lab=vddo}
C {devices/iopin.sym} 60 -120 0 1 {name=p4 lab=vsso}
C {devices/ipin.sym} 60 -800 0 0 {name=p5 lab=inp}
C {devices/ipin.sym} 60 -780 0 0 {name=p6 lab=inn}
C {devices/ipin.sym} 60 -760 0 0 {name=p7 lab=vref}
C {devices/iopin.sym} 60 -720 0 1 {name=p8 lab=iref}
C {devices/ipin.sym} 60 -700 0 0 {name=p9 lab=en}
C {devices/iopin.sym} 1800 -800 0 0 {name=p10 lab=out}
C {ClassABBiasIn.sym} 800 -740 0 0 {name=xbias}
C {devices/lab_pin.sym} 700 -920 0 0 {name=l11 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 700 -560 0 0 {name=l12 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 900 -920 0 1 {name=l13 sig_type=std_logic lab=vddo}
C {devices/lab_pin.sym} 900 -560 0 1 {name=l14 sig_type=std_logic lab=vsso}
C {devices/lab_pin.sym} 640 -740 0 0 {name=l15 sig_type=std_logic lab=iref_en}
C {devices/lab_pin.sym} 960 -840 0 1 {name=l16 sig_type=std_logic lab=vbp}
C {devices/lab_pin.sym} 960 -800 0 1 {name=l17 sig_type=std_logic lab=vbn}
C {devices/lab_pin.sym} 960 -760 0 1 {name=l18 sig_type=std_logic lab=vbpc}
C {devices/lab_pin.sym} 960 -720 0 1 {name=l19 sig_type=std_logic lab=vbnc}
C {devices/lab_pin.sym} 960 -680 0 1 {name=l20 sig_type=std_logic lab=vabp}
C {devices/lab_pin.sym} 960 -640 0 1 {name=l21 sig_type=std_logic lab=vabn}
C {BiasRefEnable.sym} 360 -740 0 0 {name=xref}
C {devices/lab_pin.sym} 360 -860 0 1 {name=l22 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 360 -620 0 1 {name=l23 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 220 -740 0 0 {name=l24 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 220 -700 0 0 {name=l25 sig_type=std_logic lab=en_b}
C {devices/lab_pin.sym} 220 -780 0 0 {name=l26 sig_type=std_logic lab=iref}
C {devices/lab_pin.sym} 500 -740 0 1 {name=l27 sig_type=std_logic lab=iref_en}
C {ClassABDriver.sym} 1400 -800 0 0 {name=xdrv}
C {devices/lab_pin.sym} 1260 -920 0 0 {name=l28 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 1260 -680 0 0 {name=l29 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1580 -920 0 1 {name=l30 sig_type=std_logic lab=vddo}
C {devices/lab_pin.sym} 1580 -680 0 1 {name=l31 sig_type=std_logic lab=vsso}
C {devices/lab_pin.sym} 1200 -860 0 0 {name=l32 sig_type=std_logic lab=inp}
C {devices/lab_pin.sym} 1200 -820 0 0 {name=l33 sig_type=std_logic lab=inn}
C {devices/lab_pin.sym} 1200 -780 0 0 {name=l34 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 1640 -860 0 1 {name=l35 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} 1200 -740 0 0 {name=l36 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} 1300 -680 0 0 {name=l37 sig_type=std_logic lab=vbp}
C {devices/lab_pin.sym} 1340 -680 0 0 {name=l38 sig_type=std_logic lab=vbn}
C {devices/lab_pin.sym} 1400 -660 0 1 {name=l39 sig_type=std_logic lab=vbpc}
C {devices/lab_pin.sym} 1460 -680 0 1 {name=l40 sig_type=std_logic lab=vbnc}
C {devices/lab_pin.sym} 1500 -680 0 1 {name=l41 sig_type=std_logic lab=vabp}
C {devices/lab_pin.sym} 1540 -680 0 1 {name=l42 sig_type=std_logic lab=vabn}
C {devices/lab_pin.sym} 1640 -900 0 1 {name=l43 sig_type=std_logic lab=a}
C {devices/lab_pin.sym} 1640 -820 0 1 {name=l44 sig_type=std_logic lab=b}
C {DriverEnable.sym} 1400 -400 0 0 {name=xen}
C {devices/lab_pin.sym} 1360 -520 0 0 {name=l45 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 1360 -280 0 0 {name=l46 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 1440 -520 0 1 {name=l47 sig_type=std_logic lab=vddo}
C {devices/lab_pin.sym} 1440 -280 0 1 {name=l48 sig_type=std_logic lab=vsso}
C {devices/lab_pin.sym} 1260 -420 0 0 {name=l49 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 1260 -380 0 0 {name=l50 sig_type=std_logic lab=en_b}
C {devices/lab_pin.sym} 1540 -460 0 1 {name=l51 sig_type=std_logic lab=a}
C {devices/lab_pin.sym} 1540 -340 0 1 {name=l52 sig_type=std_logic lab=b}
C {devices/lab_pin.sym} 1540 -420 0 1 {name=l53 sig_type=std_logic lab=vabp}
C {devices/lab_pin.sym} 1540 -380 0 1 {name=l54 sig_type=std_logic lab=vabn}
C {EnableInv.sym} 360 -400 0 0 {name=xinv}
C {devices/lab_pin.sym} 360 -450 0 1 {name=l55 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 360 -340 0 1 {name=l56 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 300 -400 0 0 {name=l57 sig_type=std_logic lab=en}
C {devices/lab_pin.sym} 420 -400 0 1 {name=l58 sig_type=std_logic lab=en_b}
C {devices/title.sym} 160 -40 0 0 {name=l0 author="Christoph Maier"}
