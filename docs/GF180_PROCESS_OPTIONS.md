# GF180MCU process options for Chipalooza #3

Source: Tim Edwards, FOSSi Foundation Chipalooza chat, week of 2026-10-06 (relayed by the project owner;
not yet checked against the wafer.space option list). GF has ~40 process options, and the xschem and
KLayout technology files do not restrict you to the ones being taped out, so use only these:

| Item | Option on this shuttle | Note |
| --- | --- | --- |
| High-value resistor | `ppolyf_u_1k` (1 kΩ/sq) | |
| MiM capacitor | 2 fF/µm², type B | PDK device family `cap_mim_{1p0,1p5,2p0}fF`; confirm which one is "2 fF type B" |
| Top metal | "1100 Å" as quoted | likely the 1.1 µm (11 kÅ) thick top metal; confirm |
| Deep n-well | available, use for noise isolation | inside a DNW the nFET bulks can be isolated, pFET bulks cannot (Tim's corrected statement); isolating both costs area (DNW spacing rules) |
| FETs | 3.3 V (`*_03v3`) and 5 V/6 V (`*_06v0`) | the 5 V and 6 V FETs are the same device; at the shortest L it breaks down at 6 V, so use it at 5 V |

Harness assumptions from Tim: not specified for 6 V operation; the project may be 3.3 V only; all
digital signals into and out of the slots are 3.3 V; I/O may nevertheless see 5 V signal levels, so
state the operational limits of the circuit in the spec (`OPERATING_LIMITS.md`).
