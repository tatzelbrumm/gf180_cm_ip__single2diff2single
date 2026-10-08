<!-- CACE run in Claude's cloud container, 2026-10-09: CACE 2.13, ngspice-47, xschem 3.4.8RC ddc73448, gf180mcuD open_pdks 1689ac3 (ciel). Session 01Btt65c, log _sudelbuecher/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md. -->

# CACE Summary for ClassABBiasBGTree

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Error of bp          | ngspice              | e_bp                 |            -5 % |   -1.125 % |          0 % |   -0.129 % |          5 % |    3.202 % |   Pass ✅    |
| Error of bn          | ngspice              | e_bn                 |            -5 % |   -0.916 % |          0 % |    0.232 % |          5 % |    3.688 % |   Pass ✅    |
| Error of bpc         | ngspice              | e_bpc                |            -5 % |   -3.032 % |          0 % |    0.939 % |          5 % |    2.966 % |   Pass ✅    |
| Error of bnc         | ngspice              | e_bnc                |            -5 % |   -1.167 % |          0 % |   -0.015 % |          5 % |    3.440 % |   Pass ✅    |
| Error of abp         | ngspice              | e_abp                |            -5 % |   -2.048 % |          0 % |   -0.774 % |          5 % |    2.434 % |   Pass ✅    |
| Error of abn         | ngspice              | e_abn                |            -5 % |   -1.131 % |          0 % |    0.085 % |          5 % |    3.543 % |   Pass ✅    |
| Supply current with tree | ngspice              | Idd                  |             any |  33.760 uA |          any |  34.294 uA |          any |  35.513 uA |   Pass ✅    |

