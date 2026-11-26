#!/usr/bin/env python3
"""List merged shapes of chosen layers of a GDS cell (flattened), cell-top coordinates in um.
usage: gds_shapes.py <file.gds> <cell> <layers.tsv> L/D[,L/D...] [max] [x0,y0,x1,y1 clip]"""
import sys
import klayout.db as kdb
gds, cell, tsv, want = sys.argv[1:5]
mx = int(sys.argv[5]) if len(sys.argv) > 5 else 30
clip = [float(v) for v in sys.argv[6].split(',')] if len(sys.argv) > 6 else None
names = {l.split('\t')[0]: l.split('\t')[1] for l in open(tsv)}
ly = kdb.Layout(); ly.read(gds); c = ly.cell(cell); u = ly.dbu
for w in want.split(','):
    L, D = map(int, w.split('/'))
    li = ly.find_layer(L, D)
    if li is None: print(w, 'not in file'); continue
    r = kdb.Region(c.begin_shapes_rec(li)); r.merge()
    if clip: r &= kdb.Region(kdb.DBox(*clip).to_itype(u))
    print(f'== {w} {names.get(w)}: {r.count()} merged polygons, area {r.area()*u*u:.2f} um2')
    ps = sorted(r.each(), key=lambda p: (p.bbox().bottom, p.bbox().left))
    for p in ps[:mx]:
        b = p.bbox()
        kind = 'rect' if p.is_box() else f'poly{p.num_points()}pt holes{p.holes()}'
        print(f'   x {b.left*u:8.3f} {b.right*u:8.3f}  y {b.bottom*u:8.3f} {b.top*u:8.3f}  w {b.width()*u:7.3f} h {b.height()*u:7.3f}  {kind} area {p.area()*u*u:.3f}')
