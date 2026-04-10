#!/bin/bash
# versions.sh — pinned tool versions for this test framework
#
# These versions are what the test cases were last validated against.
# Mismatches produce warnings, not failures, so tests can still run
# against newer versions to detect regressions.

REQUIRED_OCTEZ_VERSION="24"
REQUIRED_SMARTPY_VERSION="0.18.2"   # SmartPy has no --version flag; used as documentation only
REQUIRED_LIGO_VERSION="0.72.0"

# checkToolVersions — log installed versions and warn on mismatches
function checkToolVersions() {
    echo "=== Tool Version Check ==="

    # octez-client: 'octez-client --version' prints e.g.
    #   aa1d7358 (2026-03-20 11:14:18 +0000) (Octez 24.0~rc1+dev (build: 0))
    local octez_ver
    octez_ver=$($TEZOSCLIENT --version 2>&1 | head -1) || octez_ver="(failed to query)"
    echo "  octez-client : ${octez_ver}"
    if ! echo "$octez_ver" | grep -qF "Octez ${REQUIRED_OCTEZ_VERSION}"; then
        echo "  WARNING: expected Octez ${REQUIRED_OCTEZ_VERSION}, got: ${octez_ver}"
    fi

    # SmartPy: no --version flag available; report the path as a proxy for the version
    echo "  SmartPy      : ${SMARTPY} (version not queryable; expected ${REQUIRED_SMARTPY_VERSION})"

    # Ligo: 'ligo --version' prints e.g. 0.72.0
    local ligo_ver
    ligo_ver=$("$LIGO" --version 2>&1 | head -1) || ligo_ver="(failed to query)"
    echo "  Ligo         : ${ligo_ver}"
    if ! echo "$ligo_ver" | grep -qF "$REQUIRED_LIGO_VERSION"; then
        echo "  WARNING: expected Ligo ${REQUIRED_LIGO_VERSION}, got: ${ligo_ver}"
    fi

    echo "==========================="
}
