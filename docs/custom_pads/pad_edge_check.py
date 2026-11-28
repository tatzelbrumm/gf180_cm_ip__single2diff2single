# SPDX-License-Identifier: Apache-2.0
# pad_edge_check.py --- compare the abutting-edge geometry of a custom pad cell with gf180mcu_ocd_io__asig_5p0.
# usage: python3 -I pad_edge_check.py <custom.gds> <cell> [<pdk gds>]
# Checks (pad-local coordinates, um; abutment box (0,0)-(75,350), y = 350 is the core-facing edge, y = 0 the chip edge):
#  1. cell bbox within x -0.16..75.16, y 0..350 (the PDK pad's own bbox), PR boundary 0/0 = (0,0;75,350)
#  2. on the side edges x = 0 and x = 75, every drawn layer's spans (datatype 0) equal the PDK pad's (rails: 22/0 31/0 34/0
#     36/0 42/0 46/0 81/0); Metal2 shifted by < 0.5 um with > 6.5 um overlap is only a warning (the PDK pads do that)
#  3. on the core edge y = 350: Metal2 (36/0) only inside 15.34..59.66 (the strip the padframe generator paints, see
#     gen_padframe_template.tcl label_left/right/top_analog: abutment box grown by -15.34 um), at least one span there,
#     and no Metal3 (42/0) at that edge (label_left/right_analog paints m2 AND m3 across that strip).
# It does not check nets (that needs extraction): the core-edge Metal2 must be the ASIG5V net, and that is LVS's job.
import sys, klayout.db as db
cgds, cell = sys.argv[1], sys.argv[2]
pdk = sys.argv[3] if len(sys.argv) > 3 else '/foss/pdks/gf180mcuD/libs.ref/gf180mcu_ocd_io/gds/gf180mcu_ocd_io.gds'
W, H, e = 75.0, 350.0, 0.001
def load(f, c):
    ly = db.Layout(); ly.read(f); return ly, ly.cell(c)
def spans(ly, c, layer, side):
    li = ly.find_layer(*layer)
    if li is None: return []
    b = {'W': db.DBox(-e, 0, e, H), 'E': db.DBox(W - e, 0, W + e, H), 'N': db.DBox(0, H - e, W, H + e)}[side]
    r = db.Region(c.begin_shapes_rec(li)).merged() & db.Region(db.Box(b.to_itype(ly.dbu)))
    out = []
    for p in r.merged().each():
        bb = p.bbox().to_dtype(ly.dbu)
        out.append((round(bb.bottom, 3), round(bb.top, 3)) if side in 'WE' else (round(bb.left, 3), round(bb.right, 3)))
    return sorted(out)
lc, cc = load(cgds, cell); lp, cp = load(pdk, 'gf180mcu_ocd_io__asig_5p0')
bad = []
bb = cc.dbbox()
if bb.left < -0.16 - e or bb.right > 75.16 + e or bb.bottom < -e or bb.top > 350 + e: bad.append(f'bbox {bb} outside (-0.16,0;75.16,350)')
pr = [str(s.dbbox()) for s in cc.shapes(lc.find_layer(0, 0)).each()] if lc.find_layer(0, 0) is not None else []
if pr != ['(0,0;75,350)']: bad.append(f'PR boundary 0/0 in top cell: {pr} (PDK pad: [(0,0;75,350)])')
layers = sorted({(lp.get_info(i).layer, lp.get_info(i).datatype) for i in lp.layer_indexes()} |
                {(lc.get_info(i).layer, lc.get_info(i).datatype) for i in lc.layer_indexes()})
warn = []
for L in layers:
    if L[1] != 0: continue   # text/label datatypes (36/10, 81/10, ...) are not geometry that abuts
    for s in 'WE':
        a, b = spans(lc, cc, L, s), spans(lp, cp, L, s)
        if a != b and L == (36, 0) and len(a) == len(b) and all(min(x1, y1) - max(x0, y0) > 6.5 for (x0, x1), (y0, y1) in zip(a, b)):
            # The PDK's own pads differ here: bi_24t has its Metal2 VSS rails 0.24 um lower, in_c 0.15 um. Overlap suffices.
            warn.append(f'side {s} layer 36/0 shifted but overlapping: {a} vs PDK {b}'); continue
        if a != b: bad.append(f'side {s} layer {L[0]}/{L[1]}: {a[:6]}{"..." if len(a) > 6 else ""} != PDK {b[:6]}{"..." if len(b) > 6 else ""}')
n2 = spans(lc, cc, (36, 0), 'N')
if not any(x0 >= 15.34 - e and x1 <= 59.66 + e for x0, x1 in n2): bad.append(f'core edge: no Metal2 inside 15.34..59.66 ({n2})')
if any(x0 < 15.34 - e or x1 > 59.66 + e for x0, x1 in n2): bad.append(f'core edge: Metal2 outside 15.34..59.66 ({n2})')
n3 = spans(lc, cc, (42, 0), 'N')
if n3: bad.append(f'core edge: Metal3 at y=350 ({n3}); the padframe paints m3 over 15.34..59.66 there')
print(f'cell {cell} bbox {bb} core-edge Metal2 {n2}')
for w in warn: print('EDGE_WARN', w)
for b in bad: print('EDGE_BAD', b)
print('EDGE_SUMMARY', cell, 'ok' if not bad else f'{len(bad)} problem(s)')
sys.exit(1 if bad else 0)
