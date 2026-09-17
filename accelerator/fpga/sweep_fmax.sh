#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vivado_bin="${VIVADO_BIN:-vivado}"
part="${NPU_PART:-xc7k480t-ffg901-2}"
arrays="${NPU_ARRAY_SIZES:-1 4 8 16 32}"
periods="${NPU_PERIODS_NS:-5.000 4.000 3.333 3.000 2.500 2.000}"
result_root="${NPU_RESULT_DIR:-$script_dir/results}"

if ! command -v "$vivado_bin" >/dev/null 2>&1 && [[ ! -x "$vivado_bin" ]]; then
    echo "ERROR: Vivado not found. Set VIVADO_BIN to the full path of the Vivado executable." >&2
    exit 127
fi

mkdir -p "$result_root"
combined="$result_root/all_results.tsv"
printf 'part\tarray_size\tperiod_ns\twns_ns\ttiming_met\tfmax_mhz\tpeak_gops\tluts\tffs\tdsps\tramb18\tramb36\n' > "$combined"

for array_size in $arrays; do
    for period_ns in $periods; do
        tag="a${array_size}_p${period_ns//./_}"
        run_dir="$result_root/$tag"
        mkdir -p "$run_dir"
        echo "=== ARRAY_SIZE=$array_size PERIOD=$period_ns ns PART=$part ==="
        "$vivado_bin" -mode batch -notrace -nojournal \
            -log "$run_dir/vivado.log" \
            -source "$script_dir/run_impl.tcl" \
            -tclargs "$array_size" "$period_ns" "$run_dir" "$part"
        tail -n 1 "$run_dir/summary.tsv" >> "$combined"
    done
done

echo
echo "Routed sweep complete: $combined"
column -t -s $'\t' "$combined" 2>/dev/null || sed -n '1,200p' "$combined"
