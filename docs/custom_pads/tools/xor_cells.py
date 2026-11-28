# Flattened per-layer XOR of two cells (possibly from two GDS files), texts listed separately.
# usage: python3 -I xor_cells.py <gdsA> <cellA> <gdsB> <cellB>
import sys, klayout.db as db
def load(f, c):
    ly = db.Layout(); ly.read(f); return ly, ly.cell(c)
la, ca = load(sys.argv[1], sys.argv[2]); lb, cb = load(sys.argv[3], sys.argv[4])
keys = {(la.get_info(i).layer, la.get_info(i).datatype) for i in la.layer_indexes()} | {(lb.get_info(i).layer, lb.get_info(i).datatype) for i in lb.layer_indexes()}
bad = 0
for k in sorted(keys):
    ia = la.find_layer(*k); ib = lb.find_layer(*k)
    ra = db.Region(ca.begin_shapes_rec(ia)) if ia is not None else db.Region()
    rb = db.Region(cb.begin_shapes_rec(ib)) if ib is not None else db.Region()
    x = (ra ^ rb).merged()
    ta = sorted((s.string, s.x, s.y) for s in db.Texts(ca.begin_shapes_rec(ia)).each()) if ia is not None else []
    tb = sorted((s.string, s.x, s.y) for s in db.Texts(cb.begin_shapes_rec(ib)).each()) if ib is not None else []
    if not x.is_empty() or ta != tb:
        bad += 1
        print(f"layer {k[0]}/{k[1]}: xor polygons {x.count()} area {x.area()*la.dbu**2:.3f} um2; texts A {len(ta)} B {len(tb)}")
print("XOR_SUMMARY layers_differing", bad)
