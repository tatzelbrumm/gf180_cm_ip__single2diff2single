
# CACE Summary for OgueyAebischerRef_06v0

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| PMOS mirror bias voltage | ngspice              | Vbp_val              |             any |    1.946 V |          any |    2.751 V |          any |    4.844 V |   Pass ✅    |
| NMOS mirror bias voltage | ngspice              | Vbn_val              |             any |    0.448 V |          any |    0.653 V |          any |    0.866 V |   Pass ✅    |
| Resistor-free reference voltage | ngspice              | Vbr_val              |             any |    0.919 V |          any |    1.079 V |          any |    1.245 V |   Pass ✅    |
| Core reference current | ngspice              | Ibias_val            |           70 nA |  85.740 nA |       100 nA | 107.059 nA |       130 nA | 147.568 nA |   Fail ❌    |
| Start-up time        | ngspice              | t_startup            |             any | -477.556 us |        20 us | -170.753 us |        40 us |   8.400 us |   Pass ✅    |
| Settled vbp          | ngspice              | Vbp_final            |             any |    2.245 V |          any |    2.452 V |          any |    2.660 V |   Pass ✅    |
| Settled vbn          | ngspice              | Vbn_final            |             any |    0.450 V |          any |    0.651 V |          any |    0.856 V |   Pass ✅    |
| Settled vbr          | ngspice              | Vbr_final            |             any |    0.924 V |          any |    1.064 V |          any |    1.199 V |   Pass ✅    |
| PSRR of vbr at 1 kHz | ngspice              | PSRR_vbr             |           50 dB |  35.150 dB |        60 dB |  35.150 dB |          any |  35.150 dB |   Fail ❌    |
| Output current noise density | ngspice              | Ibias_noise          |             any | 0.051 nA/rtHz |  0.5 nA/rtHz | 0.051 nA/rtHz |    1 nA/rtHz | 0.051 nA/rtHz |   Pass ✅    |
| Turn-off time        | ngspice              | t_disable            |             any |  47.600 ns |          any |  47.600 ns |          any |  47.600 ns |   Pass ✅    |
| Quiescent supply current, enabled | ngspice              | Iq_enabled           |             any |   0.710 uA |          any |   0.710 uA |         2 uA |   0.710 uA |   Pass ✅    |
| Quiescent supply current, disabled | ngspice              | Iq_disabled          |             any |   1.265 nA |        10 nA |   1.265 nA |        20 nA |   1.265 nA |   Pass ✅    |
| Core current accuracy - Mismatch | ngspice              | Ibias_accuracy       |           -15 % |  -11.691 % |          0 % |    0.387 % |         15 % |   12.255 % |   Pass ✅    |
| Leg-to-leg current matching - Mismatch | ngspice              | Leg_matching         |            -6 % |   -3.046 % |          0 % |    1.909 % |          6 % |    6.385 % |   Fail ❌    |

