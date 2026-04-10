#!/bin/bash
# functions.sh — shared utility functions for all test cases

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------

function logInfo() {
    echo "[INFO]  $*"
}

function logError() {
    echo "[ERROR] $*" >&2
}

# ---------------------------------------------------------------------------
# Test identification helpers
# ---------------------------------------------------------------------------

function getDirName() {
    local dirname
    dirname="$(basename "$(pwd)")"
    echo "$dirname"
}

function getReadmeHead() {
    local readmehead
    readmehead="$(head -n 1 readme.md)"
    echo "$readmehead"
}

function getTestcaseTitle() {
    local readmehead dirname
    readmehead="$(getReadmeHead)"
    dirname="$(getDirName)"
    echo "$dirname $readmehead"
}

# ---------------------------------------------------------------------------
# Contract management
# ---------------------------------------------------------------------------

function removeContract() {
    local name="$1"
    local match
    match=$($TEZOSCLIENT list known contracts 2>/dev/null | grep "^${name}:" | awk -F ":" '{print $1}')
    if [[ "$match" == "$name" ]]; then
        $TEZOSCLIENT forget contract "$name" --force 2>/dev/null || true
    fi
}

# ---------------------------------------------------------------------------
# Assertion functions
# ---------------------------------------------------------------------------

# checkResult <file> <expected-substring> [test-label]
# Passes if the expected string is found anywhere in the file.
function checkResult() {
    local file="$1"
    local expected="$2"
    local label="${3:-$(getDirName)}"
    if ! grep -Fq "$expected" "$file"; then
        echo "testcase failed  | $label | expected: $expected"
        _TC_FAIL=$(( ${_TC_FAIL:-0} + 1 ))
        return 1
    else
        echo "testcase succeeded | $label"
        _TC_PASS=$(( ${_TC_PASS:-0} + 1 ))
        return 0
    fi
}

# checkResultNot <file> <absent-substring> [test-label]
# Passes if the string is NOT found in the file.
function checkResultNot() {
    local file="$1"
    local absent="$2"
    local label="${3:-$(getDirName)}"
    if grep -Fq "$absent" "$file"; then
        echo "testcase failed  | $label | unexpected string found: $absent"
        _TC_FAIL=$(( ${_TC_FAIL:-0} + 1 ))
        return 1
    else
        echo "testcase succeeded | $label"
        _TC_PASS=$(( ${_TC_PASS:-0} + 1 ))
        return 0
    fi
}

# checkResultRegex <file> <regex-pattern> [test-label]
# Passes if the regex matches anywhere in the file.
function checkResultRegex() {
    local file="$1"
    local pattern="$2"
    local label="${3:-$(getDirName)}"
    if ! grep -Eq "$pattern" "$file"; then
        echo "testcase failed  | $label | regex not matched: $pattern"
        _TC_FAIL=$(( ${_TC_FAIL:-0} + 1 ))
        return 1
    else
        echo "testcase succeeded | $label"
        _TC_PASS=$(( ${_TC_PASS:-0} + 1 ))
        return 0
    fi
}

# expectSuccess <file> [test-label]
# Passes if the file does NOT contain any known error/failure indicators.
function expectSuccess() {
    local file="$1"
    local label="${2:-$(getDirName)}"
    if grep -Eq "(Error|failed|rejected|Cannot|invalid)" "$file"; then
        echo "testcase failed  | $label | operation was expected to succeed but failed"
        _TC_FAIL=$(( ${_TC_FAIL:-0} + 1 ))
        return 1
    else
        echo "testcase succeeded | $label"
        _TC_PASS=$(( ${_TC_PASS:-0} + 1 ))
        return 0
    fi
}

# expectFailure <file> <expected-error-substring> [test-label]
# Passes if the operation failed AND the error message matches the expected pattern.
function expectFailure() {
    local file="$1"
    local expected_error="$2"
    local label="${3:-$(getDirName)}"
    if grep -Fq "$expected_error" "$file"; then
        echo "testcase succeeded | $label | operation failed as expected: $expected_error"
        _TC_PASS=$(( ${_TC_PASS:-0} + 1 ))
        return 0
    else
        echo "testcase failed  | $label | expected failure with '$expected_error' but got different result"
        _TC_FAIL=$(( ${_TC_FAIL:-0} + 1 ))
        return 1
    fi
}

# ---------------------------------------------------------------------------
# Temp file management
# ---------------------------------------------------------------------------

_TMPFILES=()

function setupCleanup() {
    _TMPFILES=()
    trap '_cleanupTempFiles' EXIT
}

function _cleanupTempFiles() {
    if [ ${#_TMPFILES[@]} -gt 0 ]; then
        rm -f "${_TMPFILES[@]}" 2>/dev/null
    fi
}

# createTempFile [prefix]  — creates a temp file, registers it for cleanup, echoes its path
function createTempFile() {
    local prefix="${1:-test}"
    local tc_id
    tc_id="$(getDirName)"
    local f
    f=$(mktemp "/tmp/${tc_id}-${prefix}.XXXXXX.tmp")
    _TMPFILES+=("$f")
    echo "$f"
}

# ---------------------------------------------------------------------------
# Results collection (used by execute_all.sh)
# ---------------------------------------------------------------------------

_RESULTS_FILE=""

function initResults() {
    _RESULTS_FILE="$(mktemp /tmp/tc-results.XXXXXX)"
}

function recordResult() {
    local tc_id="$1"
    local status="$2"
    local detail="${3:-}"
    if [ -n "$_RESULTS_FILE" ]; then
        echo "${tc_id}|${status}|${detail}|$(date -Iseconds)" >> "$_RESULTS_FILE"
    fi
}

function getResultsFile() {
    echo "$_RESULTS_FILE"
}
