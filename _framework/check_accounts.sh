#!/bin/bash
# check_accounts.sh — verify that test accounts exist and are funded
#
# Usage: ./check_accounts.sh
# Called automatically by execute_all.sh before running tests.

FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_framework/init.sh
source "${FRAMEWORK_DIR}/init.sh"

# Minimum balance required per account (tez)
MIN_BALANCE_TEZ=100

REQUIRED_ACCOUNTS=("admin" "deploy")

echo "=== Account Balance Check ==="
WARN=0

for account in "${REQUIRED_ACCOUNTS[@]}"; do
    # Check account exists in client
    if ! $TEZOSCLIENT list known addresses 2>/dev/null | grep -q "^${account}:"; then
        echo "  MISSING : ${account} — not found in client keystore"
        echo "            Run: cd _framework && ./create_accounts.sh"
        WARN=1
        continue
    fi

    # Get balance
    balance_output=$($TEZOSCLIENT get balance for "$account" 2>&1)
    # octez-client outputs something like "100.5 ꜩ"
    balance_tez=$(echo "$balance_output" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1)

    if [ -z "$balance_tez" ]; then
        echo "  ERROR   : ${account} — could not read balance: ${balance_output}"
        WARN=1
        continue
    fi

    # Integer comparison (strip decimals)
    balance_int="${balance_tez%%.*}"
    if [ "${balance_int:-0}" -lt "${MIN_BALANCE_TEZ}" ]; then
        echo "  LOW     : ${account} — balance ${balance_tez} ꜩ is below minimum ${MIN_BALANCE_TEZ} ꜩ"
        echo "            Fund at: https://teztnets.com (faucet)"
        WARN=1
    else
        echo "  OK      : ${account} — ${balance_tez} ꜩ"
    fi
done

echo "============================="

if [ "$WARN" -ne 0 ]; then
    echo "WARNING: Some accounts need attention. Tests may fail due to insufficient funds."
    # Return non-zero but don't abort — let execute_all.sh decide
    exit 1
fi
