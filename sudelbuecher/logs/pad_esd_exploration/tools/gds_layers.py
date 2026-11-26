#!/usr/bin/env python3
"""Per-layer summary of one cell of a GDS (flattened): merged polygon count, bbox, area. Layer names from layers.tsv (made from the PDK gf180mcu.lyp).
usage: gds_layers.py <file.gds> <cell> [layers.tsv]"""
import sys, re
import klayout.db as kdb
gds, cell = sys.argv[1], sys.argv[2]
names = {}
if len(sys.argv) > 3:
    for l in open(sys.argv[3]):
        k, n = l.split('\t')[:2]; L, D = k.split('/'); names[(int(L), int(D))] = n
ly = kdb.Layout(); ly.read(gds)
c = ly.cell(cell)
print('dbu', ly.dbu, 'cell', cell, 'bbox', c.dbbox(), 'child cells', sorted({ly.cell(i.cell_index).name for i in c.each_inst()}))
for li in ly.layer_indexes():
    info = ly.get_info(li)
    r = kdb.Region(c.begin_shapes_rec(li)); 
    if r.is_empty(): continue
    r.merge()
    b = r.bbox()
    print(f'{info.layer:4d}/{info.datatype:<3d} {names.get((info.layer, info.datatype), "?"):22s} polys {r.count():6d} area {r.area()*ly.dbu**2:12.2f} um2  bbox x {b.left*ly.dbu:8.3f} {b.right*ly.dbu:8.3f} y {b.bottom*ly.dbu:8.3f} {b.top*ly.dbu:8.3f}')
