<!-- CACE run RUN_2026-10-08_21-08-47 in Claude's cloud container (2026-10-08, after the enable was added): CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->

# CACE Summary for gf180mcu_IOPadSingle2Diff

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Input current into the macro | ngspice              | Iin                  |           -1 uA |  -0.042 uA |          any |   0.000 uA |         1 uA | 7541.230 uA |   Fail ❌    |
| Protected gate node voltage | ngspice              | Vprot                |             any |   -0.300 V |          any |    3.450 V |          any |    4.299 V |   Pass ✅    |

