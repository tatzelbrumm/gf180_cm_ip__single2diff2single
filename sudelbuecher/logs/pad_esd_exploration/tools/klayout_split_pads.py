#!/usr/bin/env python3
"""Copy each pad cell of gf180mcu_ocd_io (with its sub-cells) into its own GDS file, for single-cell DRC/LVS runs.
usage: klayout_split_pads.py <library.gds> <outdir> [prefix, default gf180mcu_ocd_io__]"""
import sys, os
import klayout.db as kdb
src, out = sys.argv[1:3]; pre = sys.argv[3] if len(sys.argv) > 3 else 'gf180mcu_ocd_io__'
ly = kdb.Layout(); ly.read(src)
for c in ly.each_cell():
    if c.name.startswith(pre):
        o = kdb.Layout(); o.dbu = ly.dbu; o.create_cell(c.name).copy_tree(c); o.write(os.path.join(out, c.name + '.gds'))
        print(c.name)
