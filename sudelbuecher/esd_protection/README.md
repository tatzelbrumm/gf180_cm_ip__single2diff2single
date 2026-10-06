# esd_protection

Finding (2026-10-06): the GF180 analog pad `gf180mcu_ocd_io__asig_5p0` contains only HBM protection diodes
(see [docs/analog.rst](https://github.com/RTimothyEdwards/gf180mcu_ocd_io/blob/main/docs/analog.rst) in
[RTimothyEdwards/gf180mcu_ocd_io](https://github.com/RTimothyEdwards/gf180mcu_ocd_io)). If it drives gates, the user must
add CDM protection next to those gates: a CDM diode with perimeter above 25 µm and a poly resistor above 50 Ω.
Open: protection scheme and sizing for `vin`, `vout`, `vcm`.
