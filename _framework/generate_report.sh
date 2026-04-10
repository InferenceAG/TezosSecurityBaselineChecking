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

PASS=0; FAIL=0; TOTAL=0

# --- Markdown report ---
{
    echo "# Tezos Security Baseline — Test Report"
    echo ""
    echo "Generated: $(date -Iseconds)"
    echo ""
    echo "| Test Case | Status | Detail | Timestamp |"
    echo "|-----------|--------|--------|-----------|"

    while IFS='|' read -r tc_id status detail timestamp; do
        echo "| ${tc_id} | ${status} | ${detail} | ${timestamp} |"
        (( TOTAL++ ))
        if [ "$status" = "PASS" ]; then (( PASS++ )); else (( FAIL++ )); fi
    done < "$RESULTS_FILE"

    echo ""
    echo "**PASSED: ${PASS} / FAILED: ${FAIL} / TOTAL: ${TOTAL}**"
} > "${OUTPUT_BASE}.md"

# Re-read for JSON (PASS/FAIL counts were computed above)
PASS=0; FAIL=0; TOTAL=0
{
    echo "{"
    echo "  \"generated\": \"$(date -Iseconds)\","
    echo "  \"results\": ["
    first=1
    while IFS='|' read -r tc_id status detail timestamp; do
        [ "$first" -eq 0 ] && echo ","
        printf '    {"tc_id": "%s", "status": "%s", "detail": "%s", "timestamp": "%s"}' \
            "$tc_id" "$status" "$detail" "$timestamp"
        first=0
        (( TOTAL++ ))
        if [ "$status" = "PASS" ]; then (( PASS++ )); else (( FAIL++ )); fi
    done < "$RESULTS_FILE"
    echo ""
    echo "  ],"
    echo "  \"summary\": {\"pass\": ${PASS}, \"fail\": ${FAIL}, \"total\": ${TOTAL}}"
    echo "}"
} > "${OUTPUT_BASE}.json"

echo "Report written: ${OUTPUT_BASE}.md  ${OUTPUT_BASE}.json"
echo "Summary: PASS=${PASS} FAIL=${FAIL} TOTAL=${TOTAL}"
