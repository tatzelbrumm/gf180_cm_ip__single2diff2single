#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# run_trial.sh --- the placeholder trial, reproducible: a fresh scratch copy of the harness fork, the two existing
# fork fixes (fixes/pad_pins/), then (MODE=custom) the placeholder pad library and patches 0001-0004 (+0005 if
# WITH_0005=1), then the quick steps only: clean-config config padframe wrappers symbols, the abutment/port check
# and a netgen read check of the padframe verilog. Nothing here is pushed anywhere.
#
# usage: PDK_ROOT=/foss/pdks PDK=gf180mcuD ./run_trial.sh <harness clone> <workdir> <base|custom>
#   <harness clone>: a local clone of tatzelbrumm/gf180mcu_ocd_chipalooza (tested at main 2f18cd4), with submodules
#                    either initialised in it or reachable on the network.
# Logs: <workdir>/logs/<MODE>_<step>.log and <workdir>/logs/<MODE>_summary.txt
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "${1:?harness clone}" && pwd); WORK=${2:?workdir}; MODE=${3:?base|custom}
export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk} PDK=${PDK:-gf180mcuD}
mkdir -p "$WORK/logs"; WORK=$(cd "$WORK" && pwd); T=$WORK/$MODE; L=$WORK/logs; SUM=$L/${MODE}_summary.txt
rm -rf "$T"; git clone -q "$SRC" "$T" || exit 1
cd "$T"
echo "harness $(git log --oneline -1)  mode $MODE  PDK $PDK_ROOT/$PDK  magic $(magic --version 2>/dev/null)" | tee "$SUM"
# submodules: copy from the source clone if it has them, else fetch
for d in $(git config -f .gitmodules --get-regexp path | awk '{print $2}'); do
    if [ -n "$(ls -A "$SRC/$d" 2>/dev/null)" ]; then rm -rf "$d"; cp -a "$SRC/$d" "$d"; else git submodule update --init --depth 1 "$d" >/dev/null 2>&1; fi
done
step() { # step <name> <command...>
    local n=$1; shift; local s=$(date +%s)
    "$@" > "$L/${MODE}_$n.log" 2>&1; local rc=$?
    echo "STEP $n rc=$rc seconds=$(( $(date +%s) - s ))  ($*)" | tee -a "$SUM"; return $rc
}
step apply_pad_pins git apply "$HERE/upstream_fixes/pad_pins.patch" || exit 1
step apply_lvs_scripts git apply "$HERE/upstream_fixes/lvs_scripts.patch" || exit 1
if [ "$MODE" = custom ]; then
    step make_placeholder_pads "$HERE/make_placeholder_pads.sh" custom_pads/gf180_cm_io || exit 1
    for p in "$HERE"/patches/000[1-4]-*.patch; do step "apply_$(basename "$p" .patch | cut -c1-4)" git apply "$p" || exit 1; done
    if [ "${WITH_0005:-0}" = 1 ]; then step apply_0005 git apply "$HERE"/patches/0005-*.patch || exit 1; fi
fi
for t in clean-config config padframe wrappers symbols; do step "$t" make "$t"; done
# Failures that the steps do not report through their exit code
{
echo "--- log scan (the make steps exit 0 even on these)"
grep -H -n "Bad pad type\|Error" "$L/${MODE}_config.log"
grep -H -n "couldn't be read" "$L/${MODE}_padframe.log"
grep -H -n "Bad cell path\|Calma output warning" "$L/${MODE}_padframe.log"
echo "--- slot 16 in the generated views"
grep -n "pad_s16_an" scripts/gen_padframe.tcl
grep -n "pad_s16_an_[01] (" verilog/gl/gf180mcu_padframe.v
grep -n -A3 "pad_s16_an_[01]" magic/gf180mcu_padframe.mag | grep "^[0-9]*:use\|transform"
grep "s16_an" magic/slot16_wrapper.mag
} >> "$SUM" 2>&1
CUSTOM_PAD_DIRS=""; [ -d custom_pads/gf180_cm_io/mag ] && CUSTOM_PAD_DIRS=$T/custom_pads/gf180_cm_io/mag
export CUSTOM_PAD_DIRS
step abutment magic -dnull -noconsole -rcfile "$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc" "$HERE/pad_abutment_check_custom.tcl"
grep -E "^(ABUT_SUMMARY|CUSTOM_)" "$L/${MODE}_abutment.log" >> "$SUM"
# netgen: read the pad netlists and the generated padframe verilog; an undefined pad cell shows up as a placeholder
cat > netgen_read.tcl <<EOF
set c2 [readnet spice $PDK_ROOT/$PDK/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice]
if {[file exists custom_pads/gf180_cm_io/spice/gf180_cm_io.spice]} {readnet spice custom_pads/gf180_cm_io/spice/gf180_cm_io.spice \$c2}
readnet verilog verilog/gl/netlists_lvs.v \$c2
readnet verilog verilog/gl/gf180mcu_padframe.v \$c2
quit
EOF
step netgen_read netgen -batch source netgen_read.tcl
grep -i -E "placeholder|undefined|error" "$L/${MODE}_netgen_read.log" | grep -i -E "cm_io|asig" | sed 's/^/netgen: /' >> "$SUM"
echo "netgen placeholder/undefined lines mentioning a pad cell: $(grep -i -E 'placeholder|undefined' "$L/${MODE}_netgen_read.log" | grep -c -i -E 'cm_io|asig')" >> "$SUM"
echo "DONE $MODE" >> "$SUM"
