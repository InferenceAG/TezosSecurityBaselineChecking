#!/bin/bash
# generate_report.sh — read pipe-delimited results file, produce markdown + JSON reports
#
# Usage: ./generate_report.sh <results-pipe-file> <output-base-path>
# Output: <output-base-path>.md  and  <output-base-path>.json

RESULTS_FILE="$1"
OUTPUT_BASE="$2"

if [ -z "$RESULTS_FILE" ] || [ ! -f "$RESULTS_FILE" ]; then
    echo "Usage: generate_report.sh <results-file> <output-base>" >&2
    exit 1
fi

# Read the results file once into parallel arrays
declare -a TC_IDS=()
declare -a STATUSES=()
declare -a DETAILS=()
declare -a TIMESTAMPS=()
PASS=0; FAIL=0; TOTAL=0

while IFS='|' read -r tc_id status detail timestamp; do
    TC_IDS+=("$tc_id")
    STATUSES+=("$status")
    DETAILS+=("$detail")
    TIMESTAMPS+=("$timestamp")
    (( TOTAL++ ))
    if [ "$status" = "PASS" ]; then (( PASS++ )); else (( FAIL++ )); fi
done < "$RESULTS_FILE"

# --- Markdown report ---
{
    echo "# Tezos Security Baseline — Test Report"
    echo ""
    echo "Generated: $(date -Iseconds)"
    echo ""
    echo "| Test Case | Status | Detail | Timestamp |"
    echo "|-----------|--------|--------|-----------|"
    for i in "${!TC_IDS[@]}"; do
        echo "| ${TC_IDS[$i]} | ${STATUSES[$i]} | ${DETAILS[$i]} | ${TIMESTAMPS[$i]} |"
    done
    echo ""
    echo "**PASSED: ${PASS} / FAILED: ${FAIL} / TOTAL: ${TOTAL}**"
} > "${OUTPUT_BASE}.md"

# --- JSON report ---
{
    echo "{"
    echo "  \"generated\": \"$(date -Iseconds)\","
    echo "  \"results\": ["
    for i in "${!TC_IDS[@]}"; do
        [ "$i" -gt 0 ] && echo ","
        printf '    {"tc_id": "%s", "status": "%s", "detail": "%s", "timestamp": "%s"}' \
            "${TC_IDS[$i]}" "${STATUSES[$i]}" "${DETAILS[$i]}" "${TIMESTAMPS[$i]}"
    done
    echo ""
    echo "  ],"
    echo "  \"summary\": {\"pass\": ${PASS}, \"fail\": ${FAIL}, \"total\": ${TOTAL}}"
    echo "}"
} > "${OUTPUT_BASE}.json"

echo "Report written: ${OUTPUT_BASE}.md  ${OUTPUT_BASE}.json"
echo "Summary: PASS=${PASS} FAIL=${FAIL} TOTAL=${TOTAL}"
