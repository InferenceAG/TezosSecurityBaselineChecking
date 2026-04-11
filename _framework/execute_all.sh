#!/bin/bash
# execute_all.sh — run all (or a filtered subset of) test cases
#
# Usage:
#   ./execute_all.sh [network] [--filter PREFIX] [--stop-on-failure]
#
# Examples:
#   ./execute_all.sh latest
#   ./execute_all.sh latest --filter TC-T
#   ./execute_all.sh latest --filter TC-001 --stop-on-failure
#   NETWORK=nextnet-20260320 ./execute_all.sh latest

FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=_framework/init.sh
source "${FRAMEWORK_DIR}/init.sh"
# shellcheck source=_framework/functions.sh
source "${FRAMEWORK_DIR}/functions.sh"
# shellcheck source=_framework/versions.sh
if [ -f "${FRAMEWORK_DIR}/versions.sh" ]; then
    source "${FRAMEWORK_DIR}/versions.sh"
fi

# Parse arguments
NETWORK_ARG="${1:-latest}"
FILTER=""
STOP_ON_FAILURE=0

shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --filter)   FILTER="$2"; shift 2 ;;
        --stop-on-failure) STOP_ON_FAILURE=1; shift ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

# Check tool versions
if declare -f checkToolVersions &>/dev/null; then
    checkToolVersions
fi

# Check accounts are funded
if [ -f "${FRAMEWORK_DIR}/check_accounts.sh" ]; then
    bash "${FRAMEWORK_DIR}/check_accounts.sh" || true
fi

TESTCASES_DIR="${FRAMEWORK_DIR}/../testcases"
RESULTS_DIR="${FRAMEWORK_DIR}/../results"
mkdir -p "$RESULTS_DIR"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${RESULTS_DIR}/run_${TIMESTAMP}.log"

# Propagate colour to test scripts even though their stdout goes through tee
[ -t 1 ] && export FORCE_COLOR=1

initResults

PASS=0
FAIL=0
ERROR=0
declare -a FAILED_TESTS=()

echo "======================================================="
echo " Tezos Security Baseline Checking Framework"
echo " Network arg : ${NETWORK_ARG}"
echo " Filter      : ${FILTER:-<all>}"
echo " Started     : $(date)"
echo "======================================================="
echo ""

for tc_dir in "${TESTCASES_DIR}"/T*/; do
    tc_name="$(basename "$tc_dir")"

    # Apply filter if set
    if [ -n "$FILTER" ] && [[ "$tc_name" != ${FILTER}* ]]; then
        continue
    fi

    echo "--- ${tc_name} ---"

    if [ ! -f "${tc_dir}/execute_test.sh" ]; then
        logError "${tc_name}: execute_test.sh not found, skipping"
        (( ERROR++ ))
        continue
    fi

    # Run in subshell to isolate environment.
    # Terminal gets coloured output; log files get plain text (ANSI codes stripped).
    test_log="${RESULTS_DIR}/${tc_name}_${TIMESTAMP}.log"
    (cd "${tc_dir}" && bash ./execute_test.sh "${NETWORK_ARG}") 2>&1 \
        | tee >(sed 's/\x1b\[[0-9;]*[mK]//g' >> "${test_log}") \
               >(sed 's/\x1b\[[0-9;]*[mK]//g' >> "${LOG_FILE}") \
               | cat

    # Test scripts exit 0 even on assertion failures — they signal failure by
    # printing "testcase failed". Check the log for that string.
    if grep -q "testcase failed" "${test_log}"; then
        (( FAIL++ ))
        FAILED_TESTS+=("${tc_name}")
        recordResult "${tc_name}" "FAIL" "see ${test_log}"
        if [ "${STOP_ON_FAILURE}" -eq 1 ]; then
            echo ""
            echo "Stopping on first failure (--stop-on-failure set)."
            break
        fi
    else
        (( PASS++ ))
        recordResult "${tc_name}" "PASS" ""
    fi
    echo ""

done

# Summary — written to stdout and appended to the main log
{
    echo "======================================================="
    echo " RESULTS SUMMARY"
    echo "======================================================="
    echo " PASS  : ${PASS}"
    echo " FAIL  : ${FAIL}"
    echo " ERROR : ${ERROR}"
    echo " TOTAL : $(( PASS + FAIL + ERROR ))"
    echo ""

    if [ "${#FAILED_TESTS[@]}" -gt 0 ]; then
        echo " Failed tests:"
        for t in "${FAILED_TESTS[@]}"; do
            echo "   - ${t}"
        done
    fi

    echo "======================================================="
    echo " Log: ${LOG_FILE}"
    echo "======================================================="
} | tee -a "$LOG_FILE"

# Generate structured report if results collection was active
if [ -n "$(getResultsFile)" ] && [ -f "$(getResultsFile)" ]; then
    if [ -f "${FRAMEWORK_DIR}/generate_report.sh" ]; then
        bash "${FRAMEWORK_DIR}/generate_report.sh" "$(getResultsFile)" "${RESULTS_DIR}/report_${TIMESTAMP}"
    fi
fi

# Exit with non-zero if any failures
[ "${FAIL}" -eq 0 ] && [ "${ERROR}" -eq 0 ]
