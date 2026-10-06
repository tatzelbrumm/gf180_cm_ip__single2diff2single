# floorplan

Empty on purpose. The four `chipalooza_template_*.gds` files inherited from the IHP template were
removed on 2026-10-06 because their slot geometry, pin positions and layers do not apply to GF180.
GF180 slot templates do not exist until the harness
([RTimothyEdwards/gf180mcu_ocd_chipalooza](https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza),
empty as of 2026-09-30) is published. Until then the assumed interface lives in `../harness_stub/`.
