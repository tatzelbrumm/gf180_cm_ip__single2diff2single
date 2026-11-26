#!/bin/bash
# gds_archive_padframe.sh: write the archived Chipalooza padframe as GDS, using the PDK overlay.
# Run in the IIC-OSIC-TOOLS container:
#   bash /foss/designs/gf180_cm_ip__single2diff2single_sudelbuecher/_runs/gds_archive_padframe.sh
# Reads:  /foss/designs/gf180mcu_ocd_chipalooza/archive/gf180mcu_padframe.mag (never saves it)
# Writes: gf180mcu_padframe.gds (plain, uncompressed: Magic does not gzip by file name) next to it, in archive/. An earlier gf180mcu_padframe.gds or
#         .gds.gz there is renamed to <name>.old first, nothing is deleted.
# Logs:   gds_archive_padframe.out and .err in the folder of this script (reachable from the host).
# Nothing is written to /tmp.
HERE=$(cd "$(dirname "$0")" && pwd)
exec > >(tee "$HERE/gds_archive_padframe.out") 2> >(tee "$HERE/gds_archive_padframe.err" >&2)

CHIP=${CHIP:-/foss/designs/gf180mcu_ocd_chipalooza}
export PDK_ROOT=${OV:-/foss/designs/pdk_overlay}
export PDK=gf180mcuD
export CHIP
ARCH=$CHIP/archive
RC=$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc

echo "##### settings"; echo "CHIP=$CHIP"; echo "PDK_ROOT=$PDK_ROOT"; echo "PDK=$PDK"; echo "ARCH=$ARCH"; date -u +%FT%TZ
echo; echo "##### preconditions"
for p in "$ARCH/gf180mcu_padframe.mag" "$RC"; do
  [ -e "$p" ] && echo "ok: $p" || { echo "MISSING: $p"; exit 1; }
done
command -v magic >/dev/null || { echo "magic not found"; exit 1; }

echo; echo "##### move earlier output aside (rename only)"
cd "$ARCH" || exit 1
for f in gf180mcu_padframe.gds gf180mcu_padframe.gds.gz; do
  [ -e "$f" ] && { mv -v "$f" "$f.old"; }
done

echo; echo "##### magic batch: load, drc off, gds write (can take several minutes)"
time magic -dnull -noconsole -rcfile "$RC" <<'EOF'
addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_ocd_io/mag
addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_as_sc_mcu7t3v3/mag
foreach l {gf180mcu_ocd_alpha_small gf180mcu_ocd_alpha_large gf180mcu_ocd_alpha_misc gf180mcu_ocd_ip_sram} {
    addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/$l/mag
}
# the Chipalooza repo's own cells (fill10x/y/z, caravel_logo, copyright_block, ...)
addpath $::env(CHIP)/magic
load gf180mcu_padframe
drc off
gds write gf180mcu_padframe.gds
puts "GDS WRITE RETURNED"
puts "##### feedback entries: [feedback count]"
feedback why
quit -noprompt
EOF
echo "(magic exit status $?)"

echo; echo "##### result"
ls -l "$ARCH"/gf180mcu_padframe.gds*
OK=1
# a complete GDS stream ends with the records ENDSTR (00 04 07 00) and ENDLIB (00 04 04 00)
TAILHEX=$(tail -c 8 "$ARCH/gf180mcu_padframe.gds" | od -An -tx1 | tr -d ' \n')
[ "$TAILHEX" = "0004070000040400" ] && echo "GDS trailer: OK (ENDSTR, ENDLIB)" || { echo "GDS trailer: WRONG ($TAILHEX)"; OK=0; }
grep -q "Failure to read entire subtree" "$HERE/gds_archive_padframe.err" && OK=0
[ $OK = 1 ] && echo "RESULT: GDS written, complete" || echo "RESULT: FAILED, the GDS is incomplete (see the lines below)"
echo "--- lines that usually mean trouble:"
grep -n -i -E "couldn't be read|failure|failed|error|not found|incompletely" "$HERE/gds_archive_padframe.out" "$HERE/gds_archive_padframe.err" | head -20
echo; echo "##### end"
