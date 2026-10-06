# harness_stub

Our **assumed** slot interface for the GF180 Chipalooza harness, used only until
[RTimothyEdwards/gf180mcu_ocd_chipalooza](https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza) (empty as of 2026-09-30) publishes the real one.
Nothing here is a specification. Model: `user_project_wrapper_3a.v` of
[RTimothyEdwards/sg13cmos5l_ocd_chipalooza](https://github.com/RTimothyEdwards/sg13cmos5l_ocd_chipalooza). Known GF180 differences so far:
digital slot signals are 3.3 V, pads may carry 5 V levels. Replace this folder's contents
with the real wrapper as soon as it exists.
