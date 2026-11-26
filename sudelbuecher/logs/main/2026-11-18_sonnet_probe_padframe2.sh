#!/bin/bash
# probe_padframe2.sh -- read-only; confirms the cause of
#   can't use empty string as operand of "-"   in gen_padframe.tcl.
# Hypothesis: the FIRST named "instance list abutment <name>" after getcell
# returns '' when a child cell's file timestamp differs from the one recorded
# in its parent (Magic then prints "Timestamp mismatches found in these cells"
# and the result string is lost). Later calls work.
# Run A: getcell + identify, then the NAMED call twice (expect '' then a box).
# Run B: first "prime" every gf180mcu_ocd_io__* cell the generator names
#        (getcell + named call in a scratch cell, then delete), then repeat
#        the first step (expect a box right away).
# Nothing is saved; no file in the Chipalooza folder is written.
# Output: probe_padframe2.out / .err beside this script.

D=$(cd "$(dirname "$0")" && pwd)
OUT="$D/probe_padframe2.out"; ERR="$D/probe_padframe2.err"
exec >"$OUT" 2>"$ERR"; set +e

CH=${CH:-/foss/designs/gf180mcu_ocd_chipalooza}
export PDK_ROOT=${PDK_ROOT:-/foss/designs/pdk_overlay}
export PDK=gf180mcuD
RC="$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc"
sec() { echo; echo "##### $*"; }

sec "0. settings"
echo "CH=$CH"; echo "PDK_ROOT=$PDK_ROOT"; date -u +%Y-%m-%dT%H:%M:%SZ
# the io cells that gen_padframe.tcl names (one per line)
grep -o 'gf180mcu_ocd_io__[A-Za-z0-9_]*' "$CH/scripts/gen_padframe.tcl" | sort -u > "$D/probe_padframe2.cells"
echo "cells named in gen_padframe.tcl: $(wc -l < "$D/probe_padframe2.cells") (list: probe_padframe2.cells)"

cd "$CH/magic" || exit 0
export CELLS="$D/probe_padframe2.cells"

PRELUDE='
proc probe {label script} {
    if {[catch {uplevel #0 $script} r]} { puts "PROBE $label: ERROR: $r" } \
    else { puts "PROBE $label: [string map {"\n" " "} $r]" }
}
addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_ocd_io/mag
addpath $::env(CHIP)/magic
'
export CHIP="$CH"

sec "A. no priming: named call twice"
timeout 300 magic -dnull -noconsole -rcfile "$RC" <<EOF
$PRELUDE
load scratch_A -silent
box values 0 0 0 0
probe getcell    {getcell gf180mcu_ocd_io__cor}
probe identify   {identify pad_corner_sw}
probe named-1st  {instance list abutment pad_corner_sw}
probe named-2nd  {instance list abutment pad_corner_sw}
quit -noprompt
EOF
echo "(magic exit status $?)"

sec "B. primed: every named io cell placed once in a scratch cell, then deleted"
timeout 900 magic -dnull -noconsole -rcfile "$RC" <<EOF
$PRELUDE
load scratch_prime -silent
set fd [open \$::env(CELLS) r]
set cells [split [string trim [read \$fd]] "\n"]
close \$fd
set n 0
foreach c \$cells {
    box values 0 0 0 0
    if {[catch {getcell \$c} id]} { puts "PRIME skip \$c: \$id"; continue }
    catch {instance list abutment \$id}
    catch {select cell \$id; delete}
    incr n
}
puts "PRIME done: \$n cells primed"
load scratch_B -silent
box values 0 0 0 0
probe getcell    {getcell gf180mcu_ocd_io__cor}
probe identify   {identify pad_corner_sw}
probe named-1st  {instance list abutment pad_corner_sw}
probe named-2nd  {instance list abutment pad_corner_sw}
quit -noprompt
EOF
echo "(magic exit status $?)"

sec "end"
echo "finished normally"
