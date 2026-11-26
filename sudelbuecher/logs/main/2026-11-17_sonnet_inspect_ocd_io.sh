#!/bin/bash
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#
# inspect_ocd_io.sh -- READ-ONLY inspection inside the IIC-OSIC-TOOLS container.
# Question answered: where could "make padframe" in gf180mcu_ocd_chipalooza find the gf180mcu_ocd_io pad cells,
# and does the layout of /foss/designs/gf180mcu_ocd_io match what the Chipalooza scripts expect?
# Changes nothing: it only reads files and writes two files next to itself.
#
# Run (inside the container):
#   bash /foss/designs/gf180_cm_ip__single2diff2single_sudelbuecher/_runs/inspect_ocd_io.sh
#
# Output (same folder as this script):
#   inspect_ocd_io.out   everything printed
#   inspect_ocd_io.err   error messages (empty if nothing went wrong)
#
# Blocks (each starts with "##### <title>"):
#   1. user, PDK_ROOT, whether /foss/pdks is writable, tool versions
#   2. every gf180mcu_ocd_io folder or file found in /foss/pdks and /foss/designs
#   3. which ciel PDK versions are installed
#   4. how the Chipalooza scripts refer to the pad library and PDK_ROOT
#   5. the layout of the gf180mcu_ocd_io repo (where its .mag files live) and the Chipalooza magic/ folder

D=$(cd "$(dirname "$0")" && pwd)         # absolute folder of this script
OUT="$D/inspect_ocd_io.out"               # <folder of this script> + "/" + file name
ERR="$D/inspect_ocd_io.err"
exec >"$OUT" 2>"$ERR"                     # from here on stdout -> $OUT, stderr -> $ERR
set +e                                    # keep going when one command fails

sec() { echo; echo "##### $*"; }
run() { echo "\$ $*"; "$@"; local rc=$?; [ $rc -ne 0 ] && echo "(exit status $rc)"; return 0; }

CH=/foss/designs/gf180mcu_ocd_chipalooza
IO=/foss/designs/gf180mcu_ocd_io

sec "1. who, PDK_ROOT, tools"
run date -u +%Y-%m-%dT%H:%M:%SZ
run whoami
echo "PDK_ROOT=$PDK_ROOT  PDK=$PDK  PDKPATH=$PDKPATH"
if [ -w /foss/pdks ]; then echo "/foss/pdks is writable by this user"; else echo "/foss/pdks is NOT writable by this user"; fi
run command -v magic
run command -v klayout
run command -v ciel
run ciel --version

sec "2. gf180mcu_ocd_io copies (names containing ocd_io)"
echo "--- below /foss/pdks (max depth 8):"
find /foss/pdks -maxdepth 8 -iname '*ocd_io*' 2>/dev/null | head -40
echo "--- below /foss/designs (max depth 2):"
find /foss/designs -maxdepth 2 -iname '*ocd_io*' 2>/dev/null | head -40
echo "--- the PDK's libs.ref (the place the scripts look in is libs.ref/gf180mcu_ocd_io):"
run ls -la /foss/pdks/gf180mcuD/libs.ref

sec "3. installed ciel PDK versions"
run ls -la /foss/pdks/ciel
run ls -la /foss/pdks/ciel/gf180mcu/versions
run cat /foss/pdks/versions.txt

sec "4. how the Chipalooza scripts name the pad library and PDK_ROOT"
echo "--- scripts/ folder:"
run ls -la "$CH/scripts"
echo "--- lines mentioning ocd_io, addpath, PDK_ROOT or PDKPATH in scripts/*.tcl scripts/*.sh scripts/*.py (max 60):"
grep -n 'ocd_io\|addpath\|PDK_ROOT\|PDKPATH' "$CH"/scripts/*.tcl "$CH"/scripts/*.sh "$CH"/scripts/*.py 2>/dev/null | cut -c1-200 | head -60
echo "--- Makefile lines mentioning PDK_ROOT or setup:"
grep -n 'PDK_ROOT\|PDKPATH\|^setup\|setup.sh' "$CH/Makefile" | head -20

sec "5. layout of the pad repo and of the Chipalooza magic/ folder"
echo "--- $IO/magic (first 40 entries) and entry count:"
ls "$IO/magic" | head -40
ls "$IO/magic" | wc -l
echo "--- where the .mag files of the signal pads are (asig_5p0, bi_24t):"
find "$IO" -name 'gf180mcu_ocd_io__asig_5p0*.mag' -o -name 'gf180mcu_ocd_io__bi_24t*.mag' 2>/dev/null | head
echo "--- $IO/magic/5lm (first 30 entries):"
ls "$IO/magic/5lm" 2>/dev/null | head -30
echo "--- $IO/scripts:"
ls "$IO/scripts"
echo "--- $CH/magic (first 60 entries), its README, and any .magicrc:"
ls -la "$CH/magic" | head -60
run cat "$CH/magic/README"
ls -la "$CH"/magic/.magicrc "$CH"/.magicrc 2>&1

sec "end"
echo "finished normally"
