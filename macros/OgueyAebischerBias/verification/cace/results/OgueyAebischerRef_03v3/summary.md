
# CACE Summary for OgueyAebischerRef_03v3

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| PMOS mirror bias voltage | ngspice              | Vbp_val              |             any |    2.073 V |          any |    2.581 V |          any |    3.074 V |   Pass ✅    |
| NMOS mirror bias voltage | ngspice              | Vbn_val              |             any |    0.401 V |          any |    0.580 V |          any |    0.766 V |   Pass ✅    |
| Resistor-free reference voltage | ngspice              | Vbr_val              |             any |    0.901 V |          any |    1.023 V |          any |    1.144 V |   Pass ✅    |
| Core reference current | ngspice              | Ibias_val            |           70 nA |  90.333 nA |       100 nA | 102.172 nA |       130 nA | 119.969 nA |   Pass ✅    |
| Start-up time        | ngspice              | t_startup            |             any | -512.339 us |        20 us | -158.203 us |        40 us |  16.333 us |   Pass ✅    |
| Settled vbp          | ngspice              | Vbp_final            |             any |    2.372 V |          any |    2.581 V |          any |    2.778 V |   Pass ✅    |
| Settled vbn          | ngspice              | Vbn_final            |             any |    0.403 V |          any |    0.580 V |          any |    0.764 V |   Pass ✅    |
| Settled vbr          | ngspice              | Vbr_final            |             any |    0.911 V |          any |    1.020 V |          any |    1.136 V |   Pass ✅    |
| PSRR of vbr at 1 kHz | ngspice              | PSRR_vbr             |           50 dB |  30.654 dB |        60 dB |  30.654 dB |          any |  30.654 dB |   Fail ❌    |
| Output current noise density | ngspice              | Ibias_noise          |             any | 0.066 nA/rtHz |  0.5 nA/rtHz | 0.066 nA/rtHz |    1 nA/rtHz | 0.066 nA/rtHz |   Pass ✅    |
| Turn-off time        | ngspice              | t_disable            |             any |  53.000 ns |          any |  53.000 ns |          any |  53.000 ns |   Pass ✅    |
| Quiescent supply current, enabled | ngspice              | Iq_enabled           |             any |   0.712 uA |          any |   0.712 uA |         2 uA |   0.712 uA |   Pass ✅    |
| Quiescent supply current, disabled | ngspice              | Iq_disabled          |             any |   1.238 nA |        10 nA |   1.238 nA |        20 nA |   1.238 nA |   Pass ✅    |
| Core current accuracy - Mismatch | ngspice              | Ibias_accuracy       |           -15 % |  -12.449 % |          0 % |    0.042 % |         15 % |   12.453 % |   Pass ✅    |
| Leg-to-leg current matching - Mismatch | ngspice              | Leg_matching         |            -6 % |   -2.177 % |          0 % |    2.157 % |          6 % |    7.503 % |   Fail ❌    |

