#!/usr/bin/env bash
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/.." && pwd)
logisim_jar=${LOGISIM_JAR:-/snap/logisim-evolution/current/logisim-evolution/logisim-evolution.jar}
rom_name=${1:-practical_rom}
if (( $# > 0 )); then
    shift
fi
checks=("$@")
if (( ${#checks[@]} == 0 )); then
    checks=(40:00000018 ff:00000001)
fi

if [[ ! -f "$logisim_jar" ]]; then
    echo "Logisim JAR not found: $logisim_jar" >&2
    echo "Set LOGISIM_JAR to the Logisim Evolution JAR path." >&2
    exit 1
fi

test_circuit=$(mktemp --suffix=.circ)
ram_image=$(mktemp)
trap 'rm -f "$test_circuit" "$ram_image"' EXIT

cp "$root/armv4t.circ" "$test_circuit"
rom_words=$(tail -n +2 "$here/$rom_name" | tr '\n' ' ')

PRACTICAL_WORDS=$rom_words perl -0pi -e '
    if (!$done) {
        s{<a name="contents">addr/data: 8 32\n.*?</a>}
         {<a name="contents">addr/data: 8 32\n$ENV{PRACTICAL_WORDS}\n</a>}s
            and $done = 1;
    }
' "$test_circuit"
sed -i 's/label" val="is_BX"/label" val="halt"/' "$test_circuit"

runner=()
if command -v xvfb-run >/dev/null 2>&1; then
    runner=(xvfb-run -a)
fi

"${runner[@]}" java -jar "$logisim_jar" \
    --tty halt \
    --save "$ram_image" \
    --toplevel-circuit main \
    "$test_circuit"

for check in "${checks[@]}"; do
    index=${check%%:*}
    expected=${check#*:}
    target=$((16#$index + 1))
    actual=$(awk -v target="$target" '
        NR == 1 { next }
        {
            for (field = 1; field <= NF; ++field) {
                ++word
                if (word == target) {
                    print $field
                    exit
                }
            }
        }
    ' "$ram_image")
    if [[ $actual != "$expected" ]]; then
        echo "RAM[$index]: got $actual, expected $expected" >&2
        exit 1
    fi
    echo "RAM[$index]=$actual"
done

echo "Logisim $rom_name PASS"
