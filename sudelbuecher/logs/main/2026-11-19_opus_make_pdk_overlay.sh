#!/bin/bash
# make_pdk_overlay.sh -- build a writable overlay PDK_ROOT that adds the
# gf180mcu_ocd_io pad layouts to the read-only /foss/pdks/gf180mcuD.
#
# What it writes, all below $OV and nowhere else:
#   * symbolic links to the real PDK and to the extra library clones;
#   * the Magic views of gf180mcu_ocd_io, GENERATED FROM THE PAD REPO'S GDS
#     ($IO_REPO/cells/*/*_$IO_STACK.gds.gz) into $OV/$PDK/libs.ref/gf180mcu_ocd_io/mag.
# It never writes into /foss/pdks, into the pad repo or into the Chipalooza
# repo. Running it again replaces the links and regenerates the pad views.
#
# Why the pad views are generated (changed 2026-11-19).  Earlier versions
# linked the pad repo's magic/ folder.  Those hand-saved .mag files record
# child timestamps that disagree with the children (GF_NI_COR_BASE in
# gf180mcu_ocd_io__cor, and others);  Magic then prints "Timestamp
# mismatches found" and the first `instance list abutment <name>' after
# `getcell' returns an empty string, which is where `make padframe' died
# ("can't use empty string as operand of "-"").  open_pdks does not use that
# folder either:  it builds the pad library from the GDS (Makefile.in target
# ocd-io-%, options custom/scripts/gds_import_io.tcl = "gds flatglob
# *_CDNS_*", metal stack 5lm for gf180mcuD).  This script does the same, all
# 17 pads in ONE Magic session so that shared subcells are written once and
# every recorded timestamp matches.  Tested in a sandbox with Magic 8.3.685
# and the 1689ac3 tech:  0 mismatches, every pad's abutment box returned on
# the first call.  Differences from open_pdks:  it reads the tech file only,
# not the full PDK magicrc, and does not post-process the cells.
#
# Output goes to make_pdk_overlay.out / .err beside this script.
# Run it inside the container as:  bash <path>/make_pdk_overlay.sh

D=$(cd "$(dirname "$0")" && pwd)
OUT="$D/make_pdk_overlay.out"; ERR="$D/make_pdk_overlay.err"
exec >"$OUT" 2>"$ERR"; set +e

SRC_PDK=${SRC_PDK:-/foss/pdks/gf180mcuD}              # read-only PDK variant dir
IO_REPO=${IO_REPO:-/foss/designs/gf180mcu_ocd_io}      # pad repo clone (GDS in cells/*/)
IO_STACK=${IO_STACK:-5lm}                              # metal stack of gf180mcuD (open_pdks D_STACK)
OV=${OV:-/foss/designs/pdk_overlay}                    # overlay PDK_ROOT to create
DESIGNS=${DESIGNS:-/foss/designs}                      # where the library clones live
# extra libraries, each a clone $DESIGNS/<lib> laid out as <lib>/pdk/libs.ref/<lib>
EXTRA_LIBS=${EXTRA_LIBS:-gf180mcu_as_sc_mcu7t3v3}
PDK=gf180mcuD
export OV PDK

sec() { echo; echo "##### $*"; }
run() { echo "\$ $*"; "$@"; local rc=$?; [ $rc -ne 0 ] && echo "(exit status $rc)"; return 0; }

sec "0. settings"
echo "SRC_PDK=$SRC_PDK"; echo "IO_REPO=$IO_REPO"; echo "IO_STACK=$IO_STACK"; echo "OV=$OV"
echo "DESIGNS=$DESIGNS"; echo "EXTRA_LIBS=$EXTRA_LIBS"
date -u +%Y-%m-%dT%H:%M:%SZ

sec "1. preconditions"
if [ ! -d "$SRC_PDK/libs.ref" ]; then echo "STOP: $SRC_PDK/libs.ref missing"; exit 1; fi
TECHFILE="$SRC_PDK/libs.tech/magic/$PDK.tech"
if [ ! -f "$TECHFILE" ]; then echo "STOP: $TECHFILE missing"; exit 1; fi
if ! ls "$IO_REPO"/cells/*/*_"$IO_STACK".gds.gz >/dev/null 2>&1; then
  echo "STOP: no $IO_REPO/cells/*/*_$IO_STACK.gds.gz"; exit 1; fi
if ! command -v magic >/dev/null 2>&1; then echo "STOP: magic not found (needed to import the pad GDS)"; exit 1; fi
echo "ok: PDK, tech file, pad GDS and magic exist"
echo "magic: $(magic --version 2>/dev/null)"
echo "pad repo commit: $(cat "$IO_REPO/.git/HEAD" 2>/dev/null) $(git -C "$IO_REPO" --no-optional-locks rev-parse HEAD 2>/dev/null)"

sec "2. pad GDS files to import (name, size, md5)"
for g in "$IO_REPO"/cells/*/*_"$IO_STACK".gds.gz; do
  echo "$(basename "$g")  $(stat -c %s "$g")  $(md5sum < "$g" | cut -c1-32)"
done

sec "3. build the overlay (links, plus pad views generated from GDS)"
run mkdir -p "$OV/$PDK/libs.ref/gf180mcu_ocd_io"
# every top-level entry of the PDK variant except libs.ref
for e in "$SRC_PDK"/* "$SRC_PDK"/.[!.]*; do
  [ -e "$e" ] || continue
  b=$(basename "$e"); [ "$b" = libs.ref ] && continue
  ln -sfn "$e" "$OV/$PDK/$b"
done
# every library of libs.ref
for e in "$SRC_PDK"/libs.ref/*; do
  [ -e "$e" ] || continue
  ln -sfn "$e" "$OV/$PDK/libs.ref/$(basename "$e")"
done
# the addition: the pad library, Magic views generated from the pad repo's GDS.
# Built in mag.new; replaces mag only when the import produced the corner cell.
IOD="$OV/$PDK/libs.ref/gf180mcu_ocd_io"
rm -rf "$IOD/mag.new"; mkdir -p "$IOD/mag.new"
{
  echo "tech load $TECHFILE -noprompt"
  echo "gds flatglob *_CDNS_*"
  echo "gds noduplicates true"
  for g in "$IO_REPO"/cells/*/*_"$IO_STACK".gds.gz; do echo "gds read $g"; done
  echo "writeall force"
  echo "quit -noprompt"
} > "$IOD/mag.new/import.tcl"
echo "\$ (cd $IOD/mag.new && magic -dnull -noconsole -rcfile /dev/null import.tcl)"
( cd "$IOD/mag.new" && time timeout 1800 magic -dnull -noconsole -rcfile /dev/null import.tcl ) \
  > "$IOD/import.log" 2>&1
echo "(magic exit status $?; log: $IOD/import.log)"
grep -i "error" "$IOD/import.log" | sort | uniq -c | head -20
tail -4 "$IOD/import.log"
if [ -f "$IOD/mag.new/gf180mcu_ocd_io__cor.mag" ]; then
  [ -L "$IOD/mag" ] && rm -f "$IOD/mag"     # link made by earlier versions of this script
  rm -rf "$IOD/mag"; mv "$IOD/mag.new" "$IOD/mag"
  echo "generated $(ls "$IOD"/mag/*.mag | wc -l) .mag files in $IOD/mag"
  {
    echo "generated by make_pdk_overlay.sh $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "magic $(magic --version 2>/dev/null)"
    echo "tech $TECHFILE"
    echo "from $IO_REPO $(git -C "$IO_REPO" --no-optional-locks rev-parse HEAD 2>/dev/null) cells/*/*_$IO_STACK.gds.gz"
  } > "$IOD/mag/SOURCES"
else
  echo "IMPORT FAILED: no gf180mcu_ocd_io__cor.mag in $IOD/mag.new; old mag left as it was"
fi
# the extra libraries, taken from their own clones
for lib in $EXTRA_LIBS; do
  src="$DESIGNS/$lib/pdk/libs.ref/$lib"
  if [ -d "$src" ]; then
    ln -sfn "$src" "$OV/$PDK/libs.ref/$lib"; echo "linked    $lib -> $src"
  else
    echo "NOT FOUND $lib: $src does not exist"
  fi
done
# gf180mcu_ocd_alpha: one clone holding three libraries, <clone>/{small,large,misc}/magic
for sz in small large misc; do
  src="$DESIGNS/gf180mcu_ocd_alpha/$sz/magic"
  dst="$OV/$PDK/libs.ref/gf180mcu_ocd_alpha_$sz"
  if [ -d "$src" ]; then
    mkdir -p "$dst"; ln -sfn "$src" "$dst/mag"; echo "linked    gf180mcu_ocd_alpha_$sz/mag -> $src"
  else
    echo "NOT FOUND gf180mcu_ocd_alpha_$sz: $src does not exist"
  fi
done
# gf180mcu_ocd_ip_sram: the clone keeps one folder per macro, <clone>/cells/<macro>/magic/*.mag;
# Magic wants one flat folder, so this one is made of one link per .mag file
SRAM="$DESIGNS/gf180mcu_ocd_ip_sram"
dst="$OV/$PDK/libs.ref/gf180mcu_ocd_ip_sram/mag"
if [ -d "$SRAM/cells" ]; then
  mkdir -p "$dst"
  declare -A seen; n=0; dup=0
  for f in "$SRAM"/cells/*/magic/*.mag; do
    [ -e "$f" ] || continue
    b=$(basename "$f")
    if [ -n "${seen[$b]}" ]; then dup=$((dup+1)); echo "DUPLICATE name $b: kept ${seen[$b]}, skipped $f"; continue; fi
    seen[$b]="$f"; ln -sfn "$f" "$dst/$b"; n=$((n+1))
  done
  echo "linked    gf180mcu_ocd_ip_sram/mag: $n .mag files from $SRAM/cells/*/magic ($dup duplicate names skipped)"
else
  echo "NOT FOUND gf180mcu_ocd_ip_sram: $SRAM/cells does not exist"
fi
echo "done"
run ls -la "$OV" "$OV/$PDK" "$OV/$PDK/libs.ref" "$OV/$PDK/libs.ref/gf180mcu_ocd_io"

sec "4. do the pad cells that gen_padframe.tcl places resolve?"
for c in asig_5p0 bi_24t in_c vdd vss dvdd dvss cor brk5 fill1 fill5 fill10; do
  f="$OV/$PDK/libs.ref/gf180mcu_ocd_io/mag/gf180mcu_ocd_io__$c.mag"
  if [ -f "$f" ]; then echo "found    $c"; else echo "MISSING  $c"; fi
done

echo "--- extra libraries: Magic technology named in each .mag file (first 'tech' line)"
for lib in $EXTRA_LIBS; do
  m="$OV/$PDK/libs.ref/$lib/mag"
  if [ -d "$m" ]; then
    echo "$lib: $(ls "$m"/*.mag 2>/dev/null | wc -l) .mag files"
    grep -h -m1 '^tech ' "$m"/*.mag 2>/dev/null | sort | uniq -c
  else
    echo "$lib: no mag/ folder in the overlay"
  fi
done
t="$OV/$PDK/libs.ref/gf180mcu_as_sc_mcu7t3v3/mag/gf180mcu_as_sc_mcu7t3v3__tap_2.mag"
if [ -f "$t" ]; then echo "found    as_sc tap_2"; else echo "MISSING  as_sc tap_2"; fi
for x in gf180mcu_ocd_alpha_small/mag/font_76 gf180mcu_ocd_alpha_large/mag/alpha_0 gf180mcu_ocd_alpha_misc/mag/open_source gf180mcu_ocd_ip_sram/mag/gf180mcu_ocd_ip_sram__sram1024x8m8wm1; do
  if [ -f "$OV/$PDK/libs.ref/$x.mag" ]; then echo "found    $x"; else echo "MISSING  $x"; fi
done
echo "--- technology named in the alpha and sram .mag files (first 'tech' line of each file)"
for l in gf180mcu_ocd_alpha_small gf180mcu_ocd_alpha_large gf180mcu_ocd_alpha_misc gf180mcu_ocd_ip_sram; do
  echo "$l: $(ls "$OV/$PDK/libs.ref/$l/mag/"*.mag 2>/dev/null | wc -l) .mag files"
  grep -h -m1 '^tech ' "$OV/$PDK/libs.ref/$l/mag/"*.mag 2>/dev/null | sort | uniq -c
done

sec "5. Magic test: load those cells through the overlay (reads only, never saves)"
if ! command -v magic >/dev/null 2>&1; then echo "magic not found"; exit 0; fi
export PDK_ROOT="$OV"
RC="$OV/$PDK/libs.tech/magic/$PDK.magicrc"
echo "PDK_ROOT=$PDK_ROOT  rcfile=$RC"
[ -f "$RC" ] || { echo "rcfile missing"; exit 0; }
SCR=$(mktemp -d)   # scratch working directory, so Magic writes nothing near your repos
cd "$SCR" || exit 0
timeout 120 magic -dnull -noconsole -rcfile "$RC" <<'EOF'
addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_ocd_io/mag
addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_as_sc_mcu7t3v3/mag
foreach l {gf180mcu_ocd_alpha_small gf180mcu_ocd_alpha_large gf180mcu_ocd_alpha_misc gf180mcu_ocd_ip_sram} {
    addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/$l/mag
}
foreach n {gf180mcu_as_sc_mcu7t3v3__tap_2 font_76 alpha_0 open_source gf180mcu_ocd_ip_sram__sram1024x8m8wm1} {
    load $n
    puts "LOADED $n: [llength [cellname list children $n]] subcell(s)"
}
foreach c {asig_5p0 bi_24t in_c vdd vss dvdd dvss cor brk5 fill1 fill5 fill10} {
    set n gf180mcu_ocd_io__$c
    load $n
    puts "LOADED $n: [llength [cellname list children $n]] subcell(s)"
}
# The call that failed in gen_padframe.tcl: getcell, identify, then the
# NAMED abutment lookup.  Every line must show a box, never ''.
load overlay_abutment_test -silent
foreach c {asig_5p0 bi_24t bi_a bi_t brk2 brk5 cor dvdd dvss fill1 fill10 fill5 fillnc in_c in_s vdd vss} {
    box values 0 0 0 0
    if {[catch {getcell gf180mcu_ocd_io__$c} r]} { puts "ABUTMENT $c: getcell failed: $r"; continue }
    identify t_$c
    set b [instance list abutment t_$c]
    if {$b eq ""} { puts "ABUTMENT $c: EMPTY  <-- would break make padframe" } \
    else { puts "ABUTMENT $c: $b" }
}
quit -noprompt
EOF
echo "(magic exit status $?)"
cd / && rmdir "$SCR" 2>/dev/null

sec "6. timestamps:  pad views, and the harness cells that record them"
CHECK=${CHECK:-/foss/designs/gf180mcu_ocd_chipalooza/scripts/check_timestamps.py}
if [ -f "$CHECK" ]; then
  echo "--- pad views alone"
  python3 -I "$CHECK" "$IOD/mag" | head -3
  echo "--- Chipalooza magic/ against this overlay"
  echo "    (stale lines here are repaired in the Chipalooza repo with"
  echo "     'make resave-stale', run with PDK_ROOT=$OV; see that script)"
  ( cd /foss/designs/gf180mcu_ocd_chipalooza 2>/dev/null && \
    PDK_ROOT="$OV" PDK=$PDK python3 -I "$CHECK" magic "$IOD/mag" | head -30 )
else
  echo "check_timestamps.py not found at $CHECK; skipped"
fi

sec "end"
echo "finished normally"
