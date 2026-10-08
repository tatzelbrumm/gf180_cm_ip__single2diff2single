<!-- CACE run RUN_2026-10-08_20-20-47 in Claude's cloud container: CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->

# CACE Summary for ClassABDriverBiased

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Gain                 | ngspice              | gain                 |           0.495 |   0.499425 |          0.5 |    0.49999 |        0.505 |    0.50007 |   Pass ✅    |
| Output offset        | ngspice              | vos                  |           -5 mV |   0.013 mV |         0 mV |   0.021 mV |         5 mV |   0.719 mV |   Pass ✅    |
| Integral nonlinearity | ngspice              | inl                  |             any |   0.018 mV |          any |   0.085 mV |         2 mV |   3.474 mV |   Fail ❌    |
| OP quiescent current | ngspice              | iqp                  |          100 uA | 204.886 uA |       212 uA | 213.060 uA |       500 uA | 222.903 uA |   Pass ✅    |
| ON quiescent current | ngspice              | iqn                  |          100 uA | 204.867 uA |       212 uA | 212.778 uA |       500 uA | 222.858 uA |   Pass ✅    |
| Supply current       | ngspice              | idd                  |             any | 288.901 uA |          any | 297.094 uA |       600 uA | 307.330 uA |   Pass ✅    |
| DC loop gain         | ngspice              | T0                   |           40 dB |  59.428 dB |          any |  93.107 dB |          any |  96.714 dB |   Pass ✅    |
| Loop crossover frequency | ngspice              | fc                   |           1 MHz |  1.307 MHz |          any |  1.389 MHz |          any |  1.470 MHz |   Pass ✅    |
| Phase margin         | ngspice              | pm                   |            45 ° |   68.477 ° |         60 ° |   72.725 ° |          any |   76.498 ° |   Pass ✅    |
| DC loop gain vs load | ngspice              | T0                   |             any |  67.615 dB |          any |  93.107 dB |          any | 105.675 dB |   Pass ✅    |
| Crossover vs load    | ngspice              | fc                   |             any |  0.248 MHz |          any |  0.897 MHz |          any |  1.919 MHz |   Pass ✅    |
| Phase margin vs load | ngspice              | pm                   |            45 ° |   24.878 ° |          any |   81.058 ° |          any |   89.179 ° |   Fail ❌    |
| Overshoot            | ngspice              | overshoot            |             any |    0.000 % |          0 % |    0.000 % |         10 % |    0.308 % |   Pass ✅    |
| Rise rate            | ngspice              | slew                 |             any | 2.042 V/us |          any | 2.429 V/us |          any | 2.811 V/us |   Pass ✅    |
| 1 % settling time    | ngspice              | t_settle             |             any | 250.042 ns |          any | 337.084 ns |      1000 ns | 414.904 ns |   Pass ✅    |
| Output noise         | ngspice              | vn_total             |             any | 245.436 uV |          any | 248.777 uV |          any | 251.444 uV |   Pass ✅    |

