#!/usr/bin/env python3
"""Ring polygons (polygons with holes) of a layer in a GDS cell: outer box, hole boxes and the four ring widths.
usage: gds_rings.py <gds> <cell> L/D [x0,y0,x1,y1]"""
import sys
import klayout.db as kdb
gds, cell, w = sys.argv[1:4]
ly = kdb.Layout(); ly.read(gds); c = ly.cell(cell); u = ly.dbu
L, D = map(int, w.split('/'))
r = kdb.Region(c.begin_shapes_rec(ly.find_layer(L, D))); r.merge()
if len(sys.argv) > 4:
    r &= kdb.Region(kdb.DBox(*[float(v) for v in sys.argv[4].split(',')]).to_itype(u))
for p in sorted(r.each(), key=lambda p: (p.bbox().bottom, p.bbox().left)):
    if p.holes() == 0: continue
    b = p.bbox()
    print(f'outer x {b.left*u:.3f} {b.right*u:.3f} y {b.bottom*u:.3f} {b.top*u:.3f}  ({b.width()*u:.3f} x {b.height()*u:.3f}), holes {p.holes()}')
    hs = []
    for h in range(p.holes()):
        hb = kdb.Polygon(list(p.each_point_hole(h))).bbox(); hs.append(hb)
    hs.sort(key=lambda hb: hb.bottom)
    for hb in hs:
        print(f'   hole x {hb.left*u:.3f} {hb.right*u:.3f} y {hb.bottom*u:.3f} {hb.top*u:.3f}  ({hb.width()*u:.3f} x {hb.height()*u:.3f})')
    print(f'   ring width: left {(hs[0].left-b.left)*u:.3f} right {(b.right-hs[0].right)*u:.3f} bottom {(hs[0].bottom-b.bottom)*u:.3f} top {(b.top-hs[-1].top)*u:.3f}' + (f' bars between holes {[round((hs[i+1].bottom-hs[i].top)*u,3) for i in range(len(hs)-1)]}' if len(hs) > 1 else ''))
