<!-- CACE run RUN_2026-10-08_21-00-43 in Claude's cloud container: CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->

# CACE Summary for gf180mcu_IOPadDiff2Single

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Gain - enabled       | ngspice              | gain                 |           0.495 |    0.49934 |          0.5 |   0.499989 |        0.505 |   0.500067 |   Pass ✅    |
| Output offset - enabled | ngspice              | vos                  |           -5 mV |   0.013 mV |         0 mV |   0.024 mV |         5 mV |   0.784 mV |   Pass ✅    |
| OP quiescent current - enabled | ngspice              | iq_p                 |          100 uA | 203.354 uA |       212 uA | 212.629 uA |       500 uA | 223.347 uA |   Pass ✅    |
| Supply current - enabled | ngspice              | i_dd                 |             any | 288.528 uA |          any | 298.406 uA |       600 uA | 309.977 uA |   Pass ✅    |
| Supply current - disabled | ngspice              | idd_off              |             any |   0.078 nA |          any |   0.093 nA |       100 nA |   2.918 nA |   Pass ✅    |
| OP gate below vddo - disabled | ngspice              | va_off               |           -1 mV |   0.000 mV |         0 mV |   0.000 mV |         1 mV |   0.001 mV |   Pass ✅    |
| ON gate above vsso - disabled | ngspice              | vb_off               |           -1 mV |   0.000 mV |         0 mV |   0.000 mV |         1 mV |   0.001 mV |   Pass ✅    |
| Output - disabled    | ngspice              | vout_off             |             any |  -0.005 mV |          any |   0.000 mV |          any |   0.001 mV |   Pass ✅    |
| NI gate line - disabled | ngspice              | iref_n               |             any |   0.000 mV |          any |   0.000 mV |        10 mV |   0.000 mV |   Pass ✅    |
| Reference current - disabled | ngspice              | iref_off             |             any |   0.003 nA |          any |   0.003 nA |          any |   0.081 nA |   Pass ✅    |
| Output glitch at enable | ngspice              | glitch               |             any | 170.621 mV |          any | 326.574 mV |          any | 488.895 mV |   Pass ✅    |
| Enable time          | ngspice              | t_on                 |             any |   1.273 us |          any |   1.338 us |        20 us |   1.524 us |   Pass ✅    |
| OP current after enable | ngspice              | iqp                  |          100 uA | 207.383 uA |       212 uA | 212.629 uA |       500 uA | 219.277 uA |   Pass ✅    |

