# Edge geometry of a pad cell from a GDS: per layer, the shapes touching each edge of the cell's
# abutment box (0,0)-(75,350) um. usage: python3 -I pad_edges.py <gds> <cell> [w h]
import sys, klayout.db as db
gds, cell = sys.argv[1], sys.argv[2]
W = float(sys.argv[3]) if len(sys.argv) > 3 else 75.0
H = float(sys.argv[4]) if len(sys.argv) > 4 else 350.0
ly = db.Layout(); ly.read(gds)
c = ly.cell(cell)
print("cell", cell, "bbox_um", c.dbbox(), "dbu", ly.dbu)
names = {(34,0):'Metal1',(36,0):'Metal2',(42,0):'Metal3',(46,0):'Metal4',(81,0):'Metal5',(53,0):'MetalTop',(35,0):'Via1',(38,0):'Via2',(40,0):'Via3',(41,0):'Via4',(37,0):'Pad'}
e = 0.001
edges = {'W': db.DBox(-e,0,e,H), 'E': db.DBox(W-e,0,W+e,H), 'S': db.DBox(0,-e,W,e), 'N': db.DBox(0,H-e,W,H+e)}
for li in ly.layer_indexes():
    info = ly.get_info(li)
    reg = db.Region(c.begin_shapes_rec(li)).merged()
    if reg.is_empty(): continue
    nm = names.get((info.layer, info.datatype), '')
    out = []
    for side, b in edges.items():
        r = reg & db.Region(db.Box(b.to_itype(ly.dbu)))
        if r.is_empty(): continue
        spans = []
        for p in r.merged().each():
            bb = p.bbox().to_dtype(ly.dbu)
            spans.append((round(bb.bottom,3), round(bb.top,3)) if side in 'WE' else (round(bb.left,3), round(bb.right,3)))
        spans.sort()
        out.append(f"  {side}: {len(spans)} spans " + " ".join(f"{a}-{b}" for a,b in spans))
    print(f"layer {info.layer}/{info.datatype} {nm} total_bbox {reg.bbox().to_dtype(ly.dbu)}")
    for o in out: print(o)
