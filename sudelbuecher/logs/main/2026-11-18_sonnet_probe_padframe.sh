#!/bin/bash
# probe_padframe.sh -- read-only probe of why gen_padframe.tcl stops at the
# first pad ("can't use empty string as operand of "-"").
# It repeats the first four steps of gen_padframe.tcl inside Magic, prints
# what Magic answers at each step, and quits without saving anything.
# Output: probe_padframe.out / .err beside this script.

D=$(cd "$(dirname "$0")" && pwd)
OUT="$D/probe_padframe.out"; ERR="$D/probe_padframe.err"
exec >"$OUT" 2>"$ERR"; set +e

CH=${CH:-/foss/designs/gf180mcu_ocd_chipalooza}
export PDK_ROOT=${PDK_ROOT:-/foss/designs/pdk_overlay}
export PDK=gf180mcuD
export COR=${COR:-gf180mcu_ocd_io__cor}
RC="$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc"
sec() { echo; echo "##### $*"; }

sec "0. settings"
echo "CH=$CH"; echo "PDK_ROOT=$PDK_ROOT"; echo "rcfile=$RC"; date -u +%Y-%m-%dT%H:%M:%SZ

sec "1. generated files in $CH/magic (name, size, mtime)"
ls -la --time-style=full-iso "$CH"/magic/gf180mcu_padframe.mag \
   "$CH"/magic/chipalooza_frame_wrapper.mag 2>&1
echo "--- gf180mcu_padframe.mag: lines mentioning pad_corner_sw / count of 'use' lines"
grep -n "pad_corner_sw" "$CH"/magic/gf180mcu_padframe.mag 2>&1 | head
grep -c "^use " "$CH"/magic/gf180mcu_padframe.mag 2>&1

sec "2. Magic: the first steps of gen_padframe.tcl, answers printed"
cd "$CH/magic" || exit 0
timeout 120 magic -dnull -noconsole -rcfile "$RC" <<'EOF'
namespace path {::tcl::mathop ::tcl::mathfunc}
proc probe {label script} {
    if {[catch {uplevel #0 $script} r]} { puts "PROBE $label: ERROR: $r" } \
    else { puts "PROBE $label: '$r'" }
}
set cor $::env(COR)
addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_ocd_io/mag
probe padframe-exists-before   {cellname list exists gf180mcu_padframe}
probe load                     {load gf180mcu_padframe -silent}
probe children-after-load      {cellname list children gf180mcu_padframe}
probe box-set                  {box values 0 0 0 0}
probe getcell                  {getcell $cor}
probe children-after-getcell   {cellname list children gf180mcu_padframe}
probe identify                 {identify pad_corner_sw}
probe abutment-named           {instance list abutment pad_corner_sw}
probe abutment-selected        {instance list abutment}
probe selected-instance        {select cell pad_corner_sw; select list cell}
probe abutment-after-select    {instance list abutment}
probe box-now                  {box values}
quit -noprompt
EOF
echo "(magic exit status $?)"

sec "end"
echo "finished normally"
