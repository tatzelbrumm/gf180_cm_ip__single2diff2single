<!-- CACE run RUN_2026-10-08_20-12-58 in Claude's cloud container: CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->

# CACE Summary for ClassABBiasOut

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Error of bp          | ngspice              | e_bp                 |            -5 % |    0.696 % |          0 % |    1.294 % |          5 % |    2.247 % |   Pass ✅    |
| Error of bn          | ngspice              | e_bn                 |            -5 % |    0.195 % |          0 % |    0.339 % |          5 % |    0.486 % |   Pass ✅    |
| Error of bpc         | ngspice              | e_bpc                |            -5 % |   -1.485 % |          0 % |    1.003 % |          5 % |    3.419 % |   Pass ✅    |
| Error of bnc         | ngspice              | e_bnc                |            -5 % |   -0.112 % |          0 % |    0.081 % |          5 % |    0.272 % |   Pass ✅    |
| Error of abp         | ngspice              | e_abp                |            -5 % |   -0.488 % |          0 % |    0.566 % |          5 % |    1.277 % |   Pass ✅    |
| Error of abn         | ngspice              | e_abn                |            -5 % |   -0.168 % |          0 % |    0.143 % |          5 % |    0.375 % |   Pass ✅    |
| Supply current       | ngspice              | Idd                  |             any |  28.984 uA |          any |  29.143 uA |          any |  29.271 uA |   Pass ✅    |
| Line sensitivity of vbn | ngspice              | s_bn                 |          -3 %/V |  0.188 %/V |        0 %/V |  0.206 %/V |        3 %/V |  0.226 %/V |   Pass ✅    |
| Line sensitivity of vabp | ngspice              | s_abp                |          -3 %/V |  0.774 %/V |        0 %/V |  0.978 %/V |        3 %/V |  1.316 %/V |   Pass ✅    |
| Error of bp - Mismatch | ngspice              | e_bp                 |           -10 % |   -1.124 % |          0 % |    1.292 % |         10 % |    3.168 % |   Pass ✅    |
| Error of bn - Mismatch | ngspice              | e_bn                 |           -10 % |   -0.647 % |          0 % |    0.320 % |         10 % |    1.032 % |   Pass ✅    |
| Error of bpc - Mismatch | ngspice              | e_bpc                |           -10 % |   -1.586 % |          0 % |    1.084 % |         10 % |    3.826 % |   Pass ✅    |
| Error of bnc - Mismatch | ngspice              | e_bnc                |           -10 % |   -1.732 % |          0 % |    0.025 % |         10 % |    0.916 % |   Pass ✅    |
| Error of abp - Mismatch | ngspice              | e_abp                |           -10 % |   -1.447 % |          0 % |    0.582 % |         10 % |    2.394 % |   Pass ✅    |
| Error of abn - Mismatch | ngspice              | e_abn                |           -10 % |   -0.826 % |          0 % |    0.169 % |         10 % |    1.187 % |   Pass ✅    |
| Supply current - Mismatch | ngspice              | Idd                  |             any |  28.859 uA |          any |  29.139 uA |          any |  29.386 uA |   Pass ✅    |

