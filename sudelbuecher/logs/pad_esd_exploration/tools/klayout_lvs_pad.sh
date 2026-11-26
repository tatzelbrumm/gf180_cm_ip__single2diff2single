#!/bin/bash
# KLayout LVS with the PDK's deck on one single-cell GDS, called directly (run_lvs.py needs the module docopt).
# The switches are those run_lvs.py sets for variant D. The netlist must be in KLayout's dialect: convert xschem
# netlists first with $PDK_ROOT/gf180mcuD/libs.tech/klayout/tech/lvs/gf180_xschem_klayout_spice_convert.py.
# usage: klayout_lvs_pad.sh <workdir> <cell name> <netlist> <tag>
W=$1; n=$2; K=$PDK_ROOT/gf180mcuD/libs.tech/klayout/tech
klayout -b -r $K/lvs/gf180mcu.lvs -rd input=$W/$n.gds -rd topcell=$n -rd schematic=$3 -rd report=$W/lvs_${n}_$4.lvsdb -rd target_netlist=$W/lvs_${n}_$4.cir -rd thr=2 -rd run_mode=deep -rd metal_top=11K -rd mim_option=B -rd metal_level=5LM -rd poly_res=1k -rd mim_cap=2 -rd lvs_sub=gf180mcu_gnd -rd verbose=false -rd spice_net_names=true -rd spice_comments=false -rd scale=false -rd schematic_simplify=true -rd net_only=false -rd top_lvl_pins=true -rd combine=true -rd purge=true -rd purge_nets=false > $W/lvs_${n}_$4.log 2>&1
echo "$n ($4): $(grep -o 'ERROR : Netlists.*\|INFO : Congratulations.*\|ERROR.*' $W/lvs_${n}_$4.log | tail -1)"
