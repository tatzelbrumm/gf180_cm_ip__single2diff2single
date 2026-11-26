#!/bin/bash
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#
# inspect_io_metal.sh -- READ-ONLY inspection inside the IIC-OSIC-TOOLS container.
# Question answered: which metal stack (3, 4 or 5 metal layers) does the gf180mcuD PDK use, and which
# variants of the gf180mcu_ocd_io pad cells does the installed PDK provide?
# Changes nothing: it only reads files and writes two files next to itself.
#
# Run (inside the container):
#   bash /foss/designs/gf180_cm_ip__single2diff2single_sudelbuecher/_runs/inspect_io_metal.sh
#
# Output (same folder as this script):
#   inspect_io_metal.out   everything printed
#   inspect_io_metal.err   error messages (empty if nothing went wrong)
#
# Blocks (each starts with "##### <title>"):
#   1. sak-pdk gf180mcuD environment (GF_* variables only)
#   2. what is in libs.ref, and the gf180mcu_ocd_io folders with 3lm/4lm/5lm names
#   3. metal-stack settings in the KLayout DRC and LVS decks
#   4. metal layers named in the KLayout layer-properties file and the Magic tech file
#   5. SOURCES and .config of the PDK

D=$(cd "$(dirname "$0")" && pwd)         # absolute folder of this script
OUT="$D/inspect_io_metal.out"             # <folder of this script> + "/" + file name
ERR="$D/inspect_io_metal.err"
exec >"$OUT" 2>"$ERR"                     # from here on stdout -> $OUT, stderr -> $ERR
set +e                                    # keep going when one command fails

sec() { echo; echo "##### $*"; }
run() { echo "\$ $*"; "$@"; local rc=$?; [ $rc -ne 0 ] && echo "(exit status $rc)"; return 0; }

PDK_NAME=gf180mcuD
SAK_SCRIPT=/foss/tools/sak/sak-pdk-script.sh
P=/foss/pdks/$PDK_NAME

sec "1. sak-pdk $PDK_NAME, GF_* variables"
[ -f "$SAK_SCRIPT" ] && . "$SAK_SCRIPT" "$PDK_NAME" >/dev/null     # '.' = source; its own printout is discarded
printenv | grep '^GF_'                    # only variables starting with GF_, not the whole environment
echo "PDK=$PDK PDKPATH=$PDKPATH"

sec "2. libs.ref"
run ls -la "$P/libs.ref"
echo "--- gf180mcu_ocd_io folders (any depth) and their first entries:"
find "$P/libs.ref" -maxdepth 2 -iname '*ocd_io*' 2>/dev/null
for d in $(find "$P/libs.ref" -maxdepth 2 -type d -iname '*ocd_io*' 2>/dev/null); do
	echo "--- $d"; ls -la "$d" | head -40
	echo "--- sub-folders of $d:"; find "$d" -maxdepth 2 -type d | head -40
done
echo "--- every file or folder below libs.ref with 3lm, 4lm or 5lm in its name (max 60 shown):"
find "$P/libs.ref" \( -iname '*3lm*' -o -iname '*4lm*' -o -iname '*5lm*' \) 2>/dev/null | head -60
echo "--- count by variant:"
for v in 3lm 4lm 5lm; do printf '%s: ' "$v"; find "$P/libs.ref" -iname "*${v}*" 2>/dev/null | wc -l; done
echo "--- how many asig_5p0 layout files exist, by extension:"
find "$P/libs.ref" -iname '*asig_5p0*' 2>/dev/null | sed 's/.*\.//' | sort | uniq -c

sec "3. metal-stack settings in the KLayout DRC / LVS decks"
for f in "$P"/libs.tech/klayout/tech/drc/gf180mcu.drc "$P"/libs.tech/klayout/tech/lvs/gf180mcu.lvs; do
	echo "--- $f"
	ls -la "$f"
	grep -n -i 'metal_level\|metal_top\|mim_option\|GF_PDK_OPTION\|variant\|ENV\[' "$f" | head -40
done
echo "--- other files in the drc and lvs folders:"
ls -la "$P/libs.tech/klayout/tech/drc" "$P/libs.tech/klayout/tech/lvs" | head -40

sec "4. metal layers named in the layer-properties file and the Magic tech file"
echo "--- KLayout gf180mcu.lyp: lines naming Metal1..Metal5 (count per name):"
grep -o -i '<name>[^<]*metal[0-9][^<]*</name>' "$P/libs.tech/klayout/tech/gf180mcu.lyp" | sort | uniq -c | head -20
echo "--- Magic: files in libs.tech/magic"
ls -la "$P/libs.tech/magic" | head -30
for f in "$P"/libs.tech/magic/*.tech; do
	echo "--- $f (lines mentioning a metal stack option):"
	grep -n -i 'metal[345]\b\|5lm\|4lm\|3lm\|option\|variant' "$f" | head -25
done

sec "5. SOURCES and .config"
run cat "$P/SOURCES"
run ls -la "$P/.config"

sec "end"
echo "finished normally"
