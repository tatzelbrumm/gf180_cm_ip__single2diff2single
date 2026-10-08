<!-- CACE run in Claude's cloud container, 2026-10-09: CACE 2.13, ngspice-47, xschem 3.4.8RC ddc73448, gf180mcuD open_pdks 1689ac3 (ciel). Session 01Btt65c, log _sudelbuecher/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md. -->

# CACE Summary for ClassABBiasBG

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Error of iout        | ngspice              | e_iout               |            -3 % |   -1.610 % |          0 % |   -1.220 % |          3 % |    1.664 % |   Pass ✅    |
| Supply current       | ngspice              | Idd                  |             any |  10.028 uA |          any |  10.351 uA |          any |  10.741 uA |   Pass ✅    |
| Error of iout - process spread | ngspice              | e_iout               |             any |  -22.929 % |          0 % |   -0.521 % |          any |   37.925 % |   Pass ✅    |
| Line sensitivity of iout | ngspice              | s_iout               |          -1 %/V | -0.005 %/V |        0 %/V |  0.323 %/V |        1 %/V |  0.416 %/V |   Pass ✅    |
| Start-up time        | ngspice              | t_startup            |             any | -581.883 us |         1 us | -125.042 us |        20 us |   1.292 us |   Pass ✅    |
| Error of iout after start-up | ngspice              | e_end                |            -3 % |   -1.610 % |          0 % |   -1.174 % |          3 % |    1.664 % |   Pass ✅    |
| Error of iout - Mismatch | ngspice              | e_iout               |            -6 % |   -1.211 % |          0 % |    1.261 % |          6 % |    4.000 % |   Pass ✅    |
| Supply current - Mismatch | ngspice              | Idd                  |             any |  10.299 uA |          any |  10.507 uA |          any |  10.759 uA |   Pass ✅    |
| Supply current disabled | ngspice              | Idd_off_end          |             any |   0.017 nA |         1 nA |   0.092 nA |        50 nA |   0.240 nA |   Pass ✅    |
| Output current disabled | ngspice              | iout_off             |             any |   0.003 nA |       0.1 nA |   0.011 nA |        10 nA |   0.065 nA |   Pass ✅    |

