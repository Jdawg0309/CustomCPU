create_clock -name npu_clk -period $npu_period_ns [get_ports clk]

# The accelerator's host/configuration interface is intentionally excluded from
# the core-to-core Fmax measurement. These ports are driven and sampled by a
# slower control plane in the eventual system.
set_false_path -from [get_ports rst]
set_false_path -to [get_ports {result_probe[*]}]
