#!/bin/bash
# init.sh — configuration loader
#
# Resolution order (first found wins):
#   1. init.local.sh  — machine-specific overrides (gitignored, copy from init.sh.example)
#   2. Environment variables already set by caller
#   3. Network profile from _framework/networks/<NETWORK>.sh (when NETWORK is set)
#
# To configure: cp _framework/init.sh.example _framework/init.local.sh
# then edit init.local.sh with your paths.

FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load machine-specific local config if present
if [ -f "${FRAMEWORK_DIR}/init.local.sh" ]; then
    # shellcheck source=/dev/null
    source "${FRAMEWORK_DIR}/init.local.sh"
fi

# Load network profile if NETWORK is set and profile file exists
if [ -n "${NETWORK:-}" ] && [ -f "${FRAMEWORK_DIR}/networks/${NETWORK}.sh" ]; then
    # shellcheck source=/dev/null
    source "${FRAMEWORK_DIR}/networks/${NETWORK}.sh"
fi

# Validate that required variables are set
_missing=0
for _var in SMARTPY LIGO TEZOSCLIENT; do
    if [ -z "${!_var:-}" ]; then
        echo "ERROR: \$$_var is not set." >&2
        echo "       Copy _framework/init.sh.example to _framework/init.local.sh and configure it." >&2
        _missing=1
    fi
done
if [ "${_missing}" -eq 1 ]; then
    exit 1
fi

export SMARTPY LIGO TEZOSCLIENT
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=Y
