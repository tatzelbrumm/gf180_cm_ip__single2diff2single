#!/bin/bash
# KLayout DRC with the PDK's deck (all rule decks, variant gf180mcuD, deep mode) on each pad cell, one line per cell.
# usage: klayout_drc_pads.sh <dir with the single-cell GDS files made by klayout_split_pads.py>
W=$1; K=$PDK_ROOT/gf180mcuD/libs.tech/klayout/tech; cd "$W" || exit 1
for c in asig_5p0 bi_t bi_a bi_24t in_c in_s dvdd dvss vdd vss brk2 brk5 fill1 fill5 fill10 fillnc cor; do
  n=gf180mcu_ocd_io__$c; t0=$(date +%s)
  klayout -b -r $K/drc/gf180mcu.drc -rd input=$W/$n.gds -rd topcell=$n -rd report=$W/drc_$c.lyrdb -rd variant=gf180mcuD -rd run_mode=deep -rd threads=2 > drc_$c.log 2>&1
  echo "$c: $(grep -o 'DRC RESULT.*' drc_$c.log | tail -1) rules $(grep -c 'Executing rule' drc_$c.log) time $(( $(date +%s) - t0 )) s"
done
