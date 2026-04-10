#!/bin/bash
# test_template.sh — copy this to a new testcase directory as execute_test.sh
#
# Usage: ./execute_test.sh latest
#        ./execute_test.sh <network-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../_framework/init.sh
source "${SCRIPT_DIR}/../../_framework/init.sh"
# shellcheck source=../../_framework/functions.sh
source "${SCRIPT_DIR}/../../_framework/functions.sh"

# Register trap-based cleanup for temp files
setupCleanup

TC_ID="$(getDirName)"
TC_TITLE="$(getTestcaseTitle)"
echo "=== ${TC_ID}: ${TC_TITLE} ==="

case "$1" in
    latest)
        echo "Executing tests for: $1"

        # --- Setup: remove previously deployed contracts ---
        # removeContract "my_contract"

        # --- Sub testcase #1 ---
        echo "## Sub testcase #1:"
        _result1="$(createTempFile result1)"
        # $TEZOSCLIENT originate contract my_contract transferring 0 from deploy \
        #     running my_contract.tz --init 'Unit' --burn-cap 1 --force > "$_result1" 2>&1
        # checkResult "$_result1" "Contract memorized as my_contract." "origination succeeds"

        # --- Sub testcase #2 (expected failure example) ---
        echo "## Sub testcase #2:"
        _result2="$(createTempFile result2)"
        # $TEZOSCLIENT transfer 1 from deploy to my_contract > "$_result2" 2>&1
        # expectFailure "$_result2" "Expected error message" "operation is rejected"

    ;;

    *)
        echo "Network '$1' is not supported by this test case."
        exit 1
    ;;
esac
# Temp files are removed automatically via trap on EXIT
