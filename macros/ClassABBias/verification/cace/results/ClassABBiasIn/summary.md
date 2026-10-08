<!-- CACE run RUN_2026-10-08_20-11-55 in Claude's cloud container: CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->

# CACE Summary for ClassABBiasIn

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Error of bp          | ngspice              | e_bp                 |            -5 % |    0.486 % |          0 % |    0.953 % |          5 % |    1.758 % |   Pass ✅    |
| Error of bn          | ngspice              | e_bn                 |            -5 % |    0.696 % |          0 % |    1.294 % |          5 % |    2.249 % |   Pass ✅    |
| Error of bpc         | ngspice              | e_bpc                |            -5 % |   -1.677 % |          0 % |    0.668 % |          5 % |    2.938 % |   Pass ✅    |
| Error of bnc         | ngspice              | e_bnc                |            -5 % |    0.440 % |          0 % |    1.032 % |          5 % |    1.966 % |   Pass ✅    |
| Error of abp         | ngspice              | e_abp                |            -5 % |   -0.682 % |          0 % |    0.222 % |          5 % |    0.801 % |   Pass ✅    |
| Error of abn         | ngspice              | e_abn                |            -5 % |    0.416 % |          0 % |    1.103 % |          5 % |    2.068 % |   Pass ✅    |
| Supply current       | ngspice              | Idd                  |             any |  24.031 uA |          any |  24.211 uA |          any |  24.375 uA |   Pass ✅    |
| Line sensitivity of vbn | ngspice              | s_bn                 |          -3 %/V |  0.789 %/V |        0 %/V |  1.013 %/V |        3 %/V |  1.330 %/V |   Pass ✅    |
| Line sensitivity of vabp | ngspice              | s_abp                |          -3 %/V |  0.582 %/V |        0 %/V |  0.774 %/V |        3 %/V |  1.091 %/V |   Pass ✅    |
| Error of bp - Mismatch | ngspice              | e_bp                 |           -10 % |   -0.522 % |          0 % |    0.954 % |         10 % |    2.777 % |   Pass ✅    |
| Error of bn - Mismatch | ngspice              | e_bn                 |           -10 % |   -0.631 % |          0 % |    1.139 % |         10 % |    3.604 % |   Pass ✅    |
| Error of bpc - Mismatch | ngspice              | e_bpc                |           -10 % |   -1.383 % |          0 % |    0.604 % |         10 % |    3.489 % |   Pass ✅    |
| Error of bnc - Mismatch | ngspice              | e_bnc                |           -10 % |   -1.446 % |          0 % |    0.877 % |         10 % |    3.164 % |   Pass ✅    |
| Error of abp - Mismatch | ngspice              | e_abp                |           -10 % |   -1.732 % |          0 % |    0.355 % |         10 % |    1.993 % |   Pass ✅    |
| Error of abn - Mismatch | ngspice              | e_abn                |           -10 % |   -0.657 % |          0 % |    0.987 % |         10 % |    3.296 % |   Pass ✅    |
| Supply current - Mismatch | ngspice              | Idd                  |             any |  23.910 uA |          any |  24.191 uA |          any |  24.629 uA |   Pass ✅    |

