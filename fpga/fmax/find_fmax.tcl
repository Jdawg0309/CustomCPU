# ---------------------------------------------------------------------------
# Find the real Fmax of the CustomCPU core on a Xilinx part, using Vivado.
#
#   vivado -mode batch -source find_fmax.tcl
#   vivado -mode batch -source find_fmax.tcl -tclargs xc7k160t-ffg676-2
#
# Method: constrain the clock deliberately faster than the design can go, run
# synthesis + implementation, then read worst negative slack (WNS) from the
# post-route timing report.  Fmax = 1 / (target_period - WNS).  A negative WNS
# is expected and is not a failure -- it is the measurement.
#
# Defaults to the board part (XC7K480T).  That part needs Vivado ML Enterprise;
# xc7k160t is in free Vivado ML Standard and is the same Kintex-7 fabric, so
# its timing transfers closely.  Pass it as the first tclarg to use it.
# ---------------------------------------------------------------------------

set part      [expr {$argc > 0 ? [lindex $argv 0] : "xc7k480t-ffg901-2"}]
set target_ns [expr {$argc > 1 ? [lindex $argv 1] : 4.0}]
set top       cpu_timing_top
set here      [file dirname [file normalize [info script]]]
set period_tag [string map {. p} $target_ns]
set outdir    [expr {$argc > 1 ? "$here/vivado_out_${period_tag}ns" : "$here/vivado_out"}]

file mkdir $outdir
puts "\n=== target part: $part   probe clock: ${target_ns} ns ===\n"

read_verilog [list $here/full_cpu.v $here/cpu_timing_top.v]

# Only the clock is constrained. No pin assignment: this measures the core's
# achievable frequency, not a board-specific bitstream.
set xdc $outdir/probe.xdc
set fh [open $xdc w]
puts $fh "create_clock -period $target_ns -name clk \[get_ports clk\]"
puts $fh "set_property HD.CLK_SRC BUFGCTRL_X0Y0 \[get_ports clk\]"
close $fh
read_xdc $xdc

synth_design -top $top -part $part -flatten_hierarchy rebuilt
opt_design
place_design
phys_opt_design
route_design

report_utilization -file $outdir/utilization.rpt
report_timing_summary -delay_type max -max_paths 10 -file $outdir/timing_summary.rpt
report_timing -delay_type max -max_paths 20 -sort_by slack -file $outdir/timing_paths.rpt
report_timing_summary -delay_type min -max_paths 10 -file $outdir/hold_summary.rpt

set wns [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set achieved [expr {$target_ns - $wns}]
set fmax [expr {1000.0 / $achieved}]

set luts [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LUT}]]
set regs [llength [get_cells -hier -filter {PRIMITIVE_GROUP == FLOP_LATCH}]]
set dsps [llength [get_cells -hier -filter {PRIMITIVE_GROUP == DSP}]]
set rams [llength [get_cells -hier -filter {PRIMITIVE_GROUP == BLOCKRAM}]]

set summary $outdir/FMAX.txt
set fh [open $summary w]
foreach line [list \
  "part            : $part" \
  "probe period    : $target_ns ns" \
  "worst slack WNS : $wns ns" \
  "achieved period : [format %.3f $achieved] ns" \
  "FMAX            : [format %.2f $fmax] MHz" \
  "" \
  "LUTs            : $luts" \
  "registers       : $regs" \
  "DSP slices      : $dsps" \
  "block RAMs      : $rams" \
  "" \
  "Sanity check: a small cell count with a high Fmax means the core was" \
  "optimised away. Expect roughly 1500-2000 LUTs and ~646 registers; if" \
  "registers are near zero the clock never reached the logic." ] {
  puts $fh $line
  puts $line
}
close $fh
puts "\nwrote $summary\n"
