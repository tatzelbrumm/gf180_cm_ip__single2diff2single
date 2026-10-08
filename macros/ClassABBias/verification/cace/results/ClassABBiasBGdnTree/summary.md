<!-- CACE run in Claude's cloud container, 2026-10-09: CACE 2.13, ngspice-47, xschem 3.4.8RC ddc73448, gf180mcuD open_pdks 1689ac3 (ciel). Session 01Btt65c, log _sudelbuecher/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md. -->

# CACE Summary for ClassABBiasBGdnTree

**netlist source**: schematic

|      Parameter       |         Tool         |     Result      | Min Limit  |  Min Value   | Typ Target |  Typ Value   | Max Limit  |  Max Value   |  Status  |
| :------------------- | :------------------- | :-------------- | ---------: | -----------: | ---------: | -----------: | ---------: | -----------: | :------: |
| Error of bp          | ngspice              | e_bp                 |            -5 % |   -0.964 % |          0 % |    0.101 % |          5 % |    3.454 % |   Pass ✅    |
| Error of bn          | ngspice              | e_bn                 |            -5 % |   -0.756 % |          0 % |    0.495 % |          5 % |    3.941 % |   Pass ✅    |
| Error of bpc         | ngspice              | e_bpc                |            -5 % |   -2.985 % |          0 % |    1.192 % |          5 % |    3.218 % |   Pass ✅    |
| Error of bnc         | ngspice              | e_bnc                |            -5 % |   -1.007 % |          0 % |    0.275 % |          5 % |    3.693 % |   Pass ✅    |
| Error of abp         | ngspice              | e_abp                |            -5 % |   -2.002 % |          0 % |   -0.513 % |          5 % |    2.686 % |   Pass ✅    |
| Error of abn         | ngspice              | e_abn                |            -5 % |   -0.971 % |          0 % |    0.373 % |          5 % |    3.796 % |   Pass ✅    |
| Supply current with tree | ngspice              | Idd                  |             any |  33.816 uA |          any |  34.362 uA |          any |  35.599 uA |   Pass ✅    |

