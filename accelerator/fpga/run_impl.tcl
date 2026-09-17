# Batch synthesis, placement, routing and measurement for the registered
# neighbor-to-neighbor systolic fabric.
# Usage:
#   vivado -mode batch -source run_impl.tcl -tclargs ARRAY_SIZE PERIOD_NS OUT_DIR [PART]

set script_dir [file normalize [file dirname [info script]]]
set pe_file    [file normalize [file join $script_dir .. rtl systolic_pe_int8.sv]]
set array_file [file normalize [file join $script_dir .. rtl systolic_array_int8.sv]]
set top_file   [file normalize [file join $script_dir npu_fmax_top.sv]]
set xdc_file   [file normalize [file join $script_dir npu_clock.xdc]]

if {$argc < 3 || $argc > 4} {
    puts "ERROR: expected ARRAY_SIZE PERIOD_NS OUT_DIR ?PART?"
    exit 2
}

set array_size [lindex $argv 0]
set period_ns  [lindex $argv 1]
set out_dir    [file normalize [lindex $argv 2]]
set requested_part [expr {$argc == 4 ? [lindex $argv 3] : "xc7k480t-ffg901-2"}]

if {![string is integer -strict $array_size] || $array_size < 1} {
    puts "ERROR: ARRAY_SIZE must be a positive integer"
    exit 2
}
if {![string is double -strict $period_ns] || $period_ns <= 0.0} {
    puts "ERROR: PERIOD_NS must be positive"
    exit 2
}

set matched_parts [get_parts -quiet $requested_part]
if {[llength $matched_parts] == 0} {
    # Vivado releases have displayed device/package separators inconsistently.
    # Accept the installed CustomerPartsList spelling and try its compact form.
    set compact_part $requested_part
    regsub {^([^-]+)-(.+)$} $requested_part {\1\2} compact_part
    set matched_parts [get_parts -quiet $compact_part]
}
if {[llength $matched_parts] != 1} {
    puts "ERROR: Vivado does not recognize or license part '$requested_part'"
    puts "INFO: matching 480T parts: [get_parts -quiet *xc7k480t*]"
    exit 3
}
set part [get_property NAME [lindex $matched_parts 0]]

file mkdir $out_dir
create_project -in_memory -part $part
set_property target_language Verilog [current_project]
read_verilog -sv $pe_file $array_file $top_file
set npu_period_ns $period_ns
read_xdc $xdc_file

puts "NPU_RUN part=$part array=$array_size period_ns=$period_ns"
synth_design -top npu_fmax_top -part $part -generic N=$array_size
write_checkpoint -force [file join $out_dir post_synth.dcp]
report_utilization -hierarchical -file [file join $out_dir utilization_synth.rpt]

opt_design
place_design
phys_opt_design
route_design
write_checkpoint -force [file join $out_dir post_route.dcp]

report_timing_summary -delay_type max -max_paths 20 -report_unconstrained \
    -file [file join $out_dir timing_summary.rpt]
report_utilization -hierarchical -file [file join $out_dir utilization_route.rpt]
report_drc -file [file join $out_dir drc.rpt]

set timing_paths [get_timing_paths -quiet -delay_type max -max_paths 1]
if {[llength $timing_paths] == 0} {
    puts "ERROR: no routed setup timing path was found"
    exit 4
}

set wns [get_property SLACK [lindex $timing_paths 0]]
set data_path_ns [expr {$period_ns - $wns}]
set fmax_mhz [expr {$data_path_ns > 0.0 ? 1000.0 / $data_path_ns : 0.0}]
set peak_gops [expr {2.0 * $array_size * $array_size * $fmax_mhz / 1000.0}]
set timing_met [expr {$wns >= 0.0 ? "YES" : "NO"}]

# Primitive counts are supplemental. utilization_route.rpt is authoritative.
set dsp_count  [llength [get_cells -hierarchical -filter {REF_NAME == DSP48E1}]]
set ramb18_count [llength [get_cells -hierarchical -filter {REF_NAME =~ RAMB18*}]]
set ramb36_count [llength [get_cells -hierarchical -filter {REF_NAME =~ RAMB36*}]]
set lut_count [llength [get_cells -hierarchical -filter {REF_NAME =~ LUT*}]]
set ff_count  [llength [get_cells -hierarchical -filter {REF_NAME =~ FD*}]]

set summary_file [file join $out_dir summary.tsv]
set fh [open $summary_file w]
puts $fh "part\tarray_size\tperiod_ns\twns_ns\ttiming_met\tfmax_mhz\tpeak_gops\tluts\tffs\tdsps\tramb18\tramb36"
puts $fh "$part\t$array_size\t$period_ns\t$wns\t$timing_met\t[format %.3f $fmax_mhz]\t[format %.3f $peak_gops]\t$lut_count\t$ff_count\t$dsp_count\t$ramb18_count\t$ramb36_count"
close $fh

puts "NPU_RESULT array=$array_size period_ns=$period_ns wns_ns=$wns timing_met=$timing_met fmax_mhz=[format %.3f $fmax_mhz] peak_gops=[format %.3f $peak_gops] luts=$lut_count ffs=$ff_count dsps=$dsp_count ramb18=$ramb18_count ramb36=$ramb36_count"
exit 0
