# gf180mcu_IOPadDiff2Single

Class-AB differential → single-ended driver for the analog output pad. IHP counterpart:
`sg13cmos5l_IOPadDiff2Single` (ESD clamps `sg13cmos5l_ClampN15N15`/`ClampP15N15` only, no GF180
equivalent; dropped for now).

**Status (2026-10-06): skeleton.** `schematic/xschem/gf180mcu_IOPadDiff2Single.sch/.sym` have the ports
`vdd inp inn out vss` and no devices. The IHP symbol declared `vcm` twice and `inp`/`inn` as outputs;
this symbol fixes that. Sizing notes for the driver: IHP notes worktree,
`design_considerations/class_ab_pad_driver/`.
