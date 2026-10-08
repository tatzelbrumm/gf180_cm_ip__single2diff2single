#!/bin/bash
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#
# Equivalence check after hand edits: netlist each drawn sheet with xschem (using the sheet's own
# folder xschemrc, as CACE does) and compare it device by device with its reference SPICE subckt
# (macros/ClassABDriver/scripts/check_classab_port.py: model, W, L, nf, m, nets via a consistent
# bijection, ports by name and order; resistor P/M and MOSFET drain/source swaps count as equivalent).
#
# Usage (from the repo root, PDK_ROOT and PDK=gf180mcuD set, e.g. after `source .designinit`):
#   scripts/check_schematics.sh            # all cells below
#   scripts/check_schematics.sh InputEnable ClassABDriver
# Netlists and logs go to ${OUT:-/tmp/check_schematics}. Exit status 1 if any cell mismatches.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT=${OUT:-/tmp/check_schematics}; mkdir -p "$OUT"
CHECK=$ROOT/macros/ClassABDriver/scripts/check_classab_port.py
# cell        macro          reference file (in the macro's scripts/)   reference subckt   extra ports
CELLS="
EnableInv      PadEnable      padenable_reference.spice  EnableInv
DriverEnable   PadEnable      padenable_reference.spice  DriverEnable
BiasRefEnable  PadEnable      padenable_reference.spice  BiasRefEnable
InputEnable    PadEnable      padenable_reference.spice  InputEnable
ClassABUnitR   ClassABDriver  gf180_sizing.spice         unit_r2
ClassABDriver  ClassABDriver  gf180_sizing.spice         d2s_mpdda          a b
ClassABBiasIn  ClassABBias    ../../ClassABDriver/scripts/gf180_sizing.spice  d2s_bias_in
ClassABBiasOut ClassABBias    ../../ClassABDriver/scripts/gf180_sizing.spice  d2s_bias_out
"
fail=0; n=0
while read -r cell macro ref sub extra; do
  [ -z "$cell" ] && continue
  [ $# -gt 0 ] && [[ " $* " != *" $cell "* ]] && continue
  n=$((n+1))
  d=$ROOT/macros/$macro/schematic/xschem
  rm -f "$OUT/$cell.spice"
  (cd "$d" && xschem --rcfile "$d/xschemrc" -n -s -q -x --tcl "set top_is_subckt 1" -o "$OUT" "$d/$cell.sch" \
      > "$OUT/$cell.log" 2>&1)   # xschem may exit 10 on undriven output pins; judge by the netlist
  if [ ! -s "$OUT/$cell.spice" ] || grep -q "IS MISSING" "$OUT/$cell.spice"; then
    echo "== $cell: NETLIST FAILED (see $OUT/$cell.log; PDK_ROOT/PDK set?)"; fail=1; continue
  fi
  echo "== $cell"
  python3 "$CHECK" "$ROOT/macros/$macro/scripts/$ref" "$OUT/$cell.spice" "$sub" "$cell" $extra | grep -v " vs "
  [ "${PIPESTATUS[0]}" -eq 0 ] || fail=1
done <<< "$CELLS"
[ $n -eq 0 ] && { echo "no matching cell"; exit 2; }
[ $fail -eq 0 ] && echo "ALL EQUIVALENT ($n cells)" || echo "MISMATCHES FOUND"
exit $fail
