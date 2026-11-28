# SPDX-License-Identifier: Apache-2.0
# pad_abutment_check_custom.tcl --- extension of sudelbuecher/harness_tools/pad_abutment_check.tcl (fork B, branch sudel_buecher).
# 1. First-call abutment box of every gf180mcu_ocd_io__* pad cell AND of every custom pad *.mag in $CUSTOM_PAD_DIRS, read
#    the way scripts/gen_padframe_template.tcl reads it (getcell, identify, `instance list abutment`, units microns).
# 2. For each custom pad: its abutment box must equal that of gf180mcu_ocd_io__asig_5p0, and its ports (name, class, use)
#    must equal the analog pad's (name, index, class, use).
# usage: CUSTOM_PAD_DIRS="<dir> ..." PDK_ROOT=... PDK=gf180mcuD magic -dnull -noconsole \
#            -rcfile $PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc pad_abutment_check_custom.tcl
# Prints ABUT <cell>: <box>, PORTS <cell>: <list>, CUSTOM_OK/CUSTOM_BAD <cell> <reason>, and a summary line
# ABUT_SUMMARY pads <n> empty <n> custom <n> custom_bad <n>.
drc off
crashbackups stop
units microns
set dirs {}
if {[info exists env(CUSTOM_PAD_DIRS)]} {set dirs $env(CUSTOM_PAD_DIRS)}
foreach d $dirs {addpath $d}
set files [lsort [glob $env(PDK_ROOT)/$env(PDK)/libs.ref/gf180mcu_ocd_io/mag/gf180mcu_ocd_io__*.mag]]
set custom {}
foreach d $dirs {foreach f [lsort [glob -nocomplain $d/*.mag]] {lappend files $f; lappend custom [file rootname [file tail $f]]}}
# Ports read from the .mag text (label line followed by its "port <index> <dirs> <class> <use>" line).
# (Magic's own "port first/last" returned empty strings for these GDS-backed pad views in Magic 8.3.706.)
proc ports_of {f} {
    set fh [open $f r]; set lines [split [read $fh] "\n"]; close $fh
    set out {}; set prev {}
    foreach l $lines {
        if {[regexp {^port\s+(\d+)\s+(\S+)\s+(\S+)\s+(\S+)} $l -> idx dirs cls use] && [regexp {^[fr]label\s} $prev]} {
            lappend out [list [lindex $prev end] $idx $cls $use]
        }
        set prev $l
    }
    return [lsort -unique $out]
}
array set path {}
foreach f $files {set path([file rootname [file tail $f]]) $f}
set n 0; set empty {}; array set abut {}
foreach f $files {
    set c [file rootname [file tail $f]]
    load abut_test_$n -silent
    box values 0 0 0 0
    getcell $c
    identify pad_$n
    set a [instance list abutment pad_$n]
    if {[string trim $a] eq ""} {lappend empty $c}
    set abut($c) $a
    puts "ABUT $c: $a"
    incr n
}
set ref gf180mcu_ocd_io__asig_5p0
set refports [ports_of $path($ref)]
puts "PORTS $ref: $refports"
set bad 0
foreach c $custom {
    set p [ports_of $path($c)]
    puts "PORTS $c: $p"
    set why {}
    if {$abut($c) ne $abut($ref)} {lappend why "abutment $abut($c) != $abut($ref)"}
    if {$p ne $refports} {lappend why "ports differ from $ref"}
    if {[llength $why]} {puts "CUSTOM_BAD $c [join $why {; }]"; incr bad} else {puts "CUSTOM_OK $c"}
}
puts "ABUT_SUMMARY pads $n empty [llength $empty] $empty custom [llength $custom] custom_bad $bad"
quit -noprompt
