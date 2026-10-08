<!-- CACE run in Claude's cloud container, 2026-10-09: CACE 2.13, ngspice-47, xschem 3.4.8RC ddc73448, gf180mcuD open_pdks 1689ac3 (ciel). Session 01Btt65c, log _sudelbuecher/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md. -->

# CACE Summary for ClassABBiasBGdn

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Error of iout        | ngspice              | e_iout               |            -3 % |   -1.450 % |          0 % |   -0.971 % |          3 % |    1.915 % |   Pass ✅    |
| Supply current       | ngspice              | Idd                  |             any |  10.046 uA |          any |  10.375 uA |          any |  10.767 uA |   Pass ✅    |
| Error of iout - process spread | ngspice              | e_iout               |             any |  -22.721 % |          0 % |   -0.398 % |          any |   38.143 % |   Pass ✅    |
| Line sensitivity of iout | ngspice              | s_iout               |          -1 %/V |  0.107 %/V |        0 %/V |  0.470 %/V |        1 %/V |  0.582 %/V |   Pass ✅    |
| Start-up time        | ngspice              | t_startup            |             any | -580.404 us |         1 us | -124.596 us |        20 us |   1.321 us |   Pass ✅    |
| Error of iout after start-up | ngspice              | e_end                |            -3 % |   -1.450 % |          0 % |   -0.965 % |          3 % |    1.915 % |   Pass ✅    |
| Error of iout - Mismatch | ngspice              | e_iout               |            -6 % |   -1.240 % |          0 % |    1.414 % |          6 % |    4.407 % |   Pass ✅    |
| Supply current - Mismatch | ngspice              | Idd                  |             any |  10.296 uA |          any |  10.521 uA |          any |  10.800 uA |   Pass ✅    |
| Supply current disabled | ngspice              | Idd_off_end          |             any |   0.026 nA |         1 nA |   0.120 nA |        50 nA |   1.260 nA |   Pass ✅    |
| Output current disabled | ngspice              | iout_off             |             any |   0.003 nA |       0.1 nA |   0.011 nA |        10 nA |   0.065 nA |   Pass ✅    |

