#!/bin/bash
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#
# inspect_pdk_klayout.sh -- READ-ONLY inspection inside the IIC-OSIC-TOOLS container.
# Changes nothing: it only reads files, prints selected variables, and writes two files next to itself.
#
# Run (inside the container):
#   bash /foss/designs/gf180_cm_ip__single2diff2single_sudelbuecher/_runs/inspect_pdk_klayout.sh
#
# Output (same folder as this script; stdout and stderr are redirected, so the terminal stays quiet):
#   inspect_pdk_klayout.out   everything printed
#   inspect_pdk_klayout.err   error messages (empty if nothing went wrong)
#
# What it records (each block starts with a line "##### <title>"):
#   1. who/where/when (user, host, date, IIC version files if present)
#   2. the sak-pdk environment after "sak-pdk gf180mcuD" (sourced from the script file, not the alias)
#   3. what /foss/pdks contains and where /foss/pdks/gf180mcuD really points
#   4. the KLayout technology files of that PDK (.lyt name, layer-properties file)
#   5. the KLayout default technology set in /headless/.klayout/klayoutrc
#   6. the KLayout version
#   7. /etc/profile.d/iic-osic-tools-setup.sh (to compare its PDK -> std-cell mapping with sak-pdk)
# Environment variables are NOT dumped wholesale (only the named ones), so no passwords end up in the file.

D=$(cd "$(dirname "$0")" && pwd)         # folder of this script, as an absolute path
OUT="$D/inspect_pdk_klayout.out"          # joined as: <folder of this script> + "/" + file name
ERR="$D/inspect_pdk_klayout.err"
exec >"$OUT" 2>"$ERR"                     # from here on, stdout goes to $OUT and stderr to $ERR
set +e                                    # keep going when one command fails; each failure is noted

sec() { echo; echo "##### $*"; }
run() { echo "\$ $*"; "$@"; local rc=$?; [ $rc -ne 0 ] && echo "(exit status $rc)"; return 0; }

PDK_NAME=gf180mcuD
SAK_SCRIPT=/foss/tools/sak/sak-pdk-script.sh

sec "1. who, where, when"
run date -u +%Y-%m-%dT%H:%M:%SZ
run whoami
run hostname
run uname -sr
run ls -la /foss/tools/versions.txt /foss/tools/iic-osic-tools-version.txt /foss/pdks/versions.txt
run sha256sum "$SAK_SCRIPT"

sec "2. sak-pdk $PDK_NAME (sourcing $SAK_SCRIPT)"
if [ -f "$SAK_SCRIPT" ]; then
	. "$SAK_SCRIPT" "$PDK_NAME"          # '.' = source, so the exported variables stay in this shell
else
	echo "$SAK_SCRIPT not found; trying whatever 'type sak-pdk' says:"
	type sak-pdk
fi
echo "--- selected variables after sourcing:"
for v in PDK_ROOT PDK PDKPATH STD_CELL_LIBRARY SPICE_USERINIT_DIR KLAYOUT_PATH KLAYOUT_PYTHONPATH GF_PDK_OPTION; do
	printf '%s=%s\n' "$v" "${!v}"          # ${!v} = the value of the variable whose name is stored in v
done

sec "3. /foss/pdks"
run ls -la /foss/pdks
run readlink -f "/foss/pdks/$PDK_NAME"
run ls -la "/foss/pdks/$PDK_NAME/"

sec "4. KLayout technology files of $PDK_NAME"
TECH="/foss/pdks/$PDK_NAME/libs.tech/klayout/tech"
run ls -la "$TECH/"
for f in "$TECH"/*.lyt; do
	echo "--- $f"
	grep -n '<name>\|<layer-properties_file>\|<base-path>\|<original-base-path>\|<dbu>\|<description>' "$f"
done
echo "--- all .lyt files below libs.tech/klayout (any depth):"
find "/foss/pdks/$PDK_NAME/libs.tech/klayout/" -name '*.lyt' 2>/dev/null

sec "5. default KLayout technology in /headless/.klayout/klayoutrc"
run grep -n 'initial-technology\|default-technology' /headless/.klayout/klayoutrc
run ls -la /headless/.klayout

sec "6. KLayout version"
run klayout -v

sec "7. /etc/profile.d/iic-osic-tools-setup.sh"
run cat /etc/profile.d/iic-osic-tools-setup.sh

sec "end"
echo "finished normally"
