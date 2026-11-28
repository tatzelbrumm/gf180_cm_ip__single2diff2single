#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# make_placeholder_pads.sh --- write the placeholder pad library: renamed copies of the PDK analog pad
# gf180mcu_ocd_io__asig_5p0, one per new pad type, in every view the harness flow reads.
#
# usage: PDK_ROOT=/foss/pdks PDK=gf180mcuD ./make_placeholder_pads.sh <outdir> [<lib> <cell> ...]
#   default lib name gf180_cm_io, default cells gf180_cm_io__asig_in gf180_cm_io__asig_out (PROVISIONAL names).
# Writes <outdir>/{mag,gds,lef,spice,verilog,xschem}. The mag views keep the PDK's GDS_FILE/GDS_START/GDS_END
# properties, so Magic writes the PDK pad's GDS bytes under the new cell name (Magic warns "Structure definition has
# name gf180mcu_ocd_io__asig_5p0 but cell definition has name ...", and renames). Needs klayout (python module) for gds/.
set -euo pipefail
PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}; PDK=${PDK:-gf180mcuD}
SRC=$PDK_ROOT/$PDK/libs.ref/gf180mcu_ocd_io
STD=gf180mcu_ocd_io__asig_5p0
OUT=${1:?outdir}; shift || true
LIB=${1:-gf180_cm_io}; shift || true
CELLS=("$@"); [ ${#CELLS[@]} -eq 0 ] && CELLS=(${LIB}__asig_in ${LIB}__asig_out)
for c in "${CELLS[@]}"; do
  case "$c" in *__in*|*__bi_*|gf180mcu_ocd_io__*) echo "refusing cell name $c: parse_config.py dispatches on '__in', '__bi_' and the gf180mcu_ocd_io__ prefix" >&2; exit 1;; esac
done
mkdir -p "$OUT"/{mag,gds,lef,spice,verilog,xschem}
: > "$OUT/spice/$LIB.spice"; : > "$OUT/verilog/$LIB.v"; : > "$OUT/verilog/${LIB}__blackbox.v"; : > "$OUT/verilog/${LIB}__blackbox_pp.v"
: > "$OUT/lef/$LIB.lef"
awk '/^MACRO/ {exit} {print}' "$SRC/lef/gf180mcu_ocd_io.lef" >> "$OUT/lef/$LIB.lef"
for c in "${CELLS[@]}"; do
  # Same file, except that the two subcell uses name the PDK directory: Magic otherwise looks for them in the
  # placeholder's own directory and warns "Bad cell path ... Cell previously read from ... will be used instead".
  sed -E 's|^(use (5LM_METAL_RAIL_PAD_60\|GF_NI_ASIG_5P0_BASE) +[^ ]+)$|\1 $PDKPATH/libs.ref/gf180mcu_ocd_io/mag|' \
    "$SRC/mag/$STD.mag" > "$OUT/mag/$c.mag"
  [ "$(grep -c '^use .* \$PDKPATH/libs.ref/gf180mcu_ocd_io/mag$' "$OUT/mag/$c.mag")" = 2 ] || { echo "subcell path edit failed for $c" >&2; exit 1; }
  awk -v s=".subckt $STD " '$0 ~ "^"s {p=1} p {print} p && /^\.ends/ {exit}' "$SRC/spice/gf180mcu_ocd_io.spice" \
    | sed "s/\b$STD\b/$c/g" >> "$OUT/spice/$LIB.spice"; echo >> "$OUT/spice/$LIB.spice"
  for v in gf180mcu_ocd_io.v:$LIB.v gf180mcu_ocd_io__blackbox.v:${LIB}__blackbox.v gf180mcu_ocd_io__blackbox_pp.v:${LIB}__blackbox_pp.v; do
    awk -v s="module $STD " 'index($0,s)==1 {p=1} p {print} p && /^endmodule/ {exit}' "$SRC/verilog/${v%%:*}" \
      | sed "s/\b$STD\b/$c/g" >> "$OUT/verilog/${v##*:}"; echo >> "$OUT/verilog/${v##*:}"
  done
  awk -v s="MACRO $STD" '$0==s {p=1} p {print} p && $0=="END '"$STD"'" {exit}' "$SRC/lef/gf180mcu_ocd_io.lef" \
    | sed "s/\b$STD\b/$c/g" >> "$OUT/lef/$LIB.lef"; echo >> "$OUT/lef/$LIB.lef"
  sed "s/\b$STD\b/$c/g" "$SRC/xschem/$STD.sym" > "$OUT/xschem/$c.sym"
done
echo "END LIBRARY" >> "$OUT/lef/$LIB.lef"
python3 -I - "$SRC/gds/gf180mcu_ocd_io.gds" "$OUT/gds/$LIB.gds" "$STD" "${CELLS[@]}" <<'PY'
import sys, klayout.db as db
src, dst, std, cells = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4:]
ly = db.Layout(); ly.read(src)
s = ly.cell(std); keep = []
for c in cells:
    n = ly.create_cell(c); n.copy_shapes(s)
    for i in s.each_inst(): n.insert(i.cell_inst)
    keep.append(n.cell_index())
o = db.SaveLayoutOptions(); o.clear_cells()
for k in keep: o.add_cell(k)   # each with its child tree (shared PDK subcells keep their PDK names)
ly.write(dst, o)
print("wrote", dst, "tops", cells)
PY
echo "placeholder library $LIB written to $OUT: ${CELLS[*]}"
