# Tezos Security Baseline Checking Framework - Improvement Plan

## Project Summary

A bash-based security baseline checking framework for Tezos smart contracts.
Tests Michelson opcodes, Ligo, and SmartPy behavior across Tezos protocol versions.
60 test cases across 6 categories, executed via bash scripts against live testnets.

---

## 1. Architecture Analysis

### Current Architecture

```
_framework/          # init.sh (config), functions.sh (utils), execute_all.sh (runner)
testcases/TC-*/      # Each has: execute_test.sh, contract files (.tz/.mligo/.py), readme.md
results/             # Manual result logs per network
```

### Architecture Verdict

The flat test-case-per-directory approach is sound for this type of integration testing.
However, several structural issues limit maintainability, reproducibility, and extensibility.

### Key Architecture Issues

1. **Hardcoded local paths** in `init.sh` (user-specific `/home/gonzo/...` paths)
2. **No environment isolation** - depends on globally installed tools
3. **No structured test output** - only grep-based pass/fail on stdout
4. **No CI/CD** - fully manual execution
5. **No dependency management** - tool versions tracked only in comments
6. **Single-file config** with commented-out history instead of proper environment profiles

---

## 2. Categorized Improvements

### CATEGORY A: Framework Infrastructure (High Priority)

#### A1. Externalize configuration from `init.sh`

**Problem:** `_framework/init.sh` contains hardcoded absolute paths to `/home/gonzo/...` and maintains network history as commented-out lines. This makes the framework unusable for anyone else without manual editing.

**Action steps:**
1. Create a file `_framework/init.sh.example` with placeholder paths and documentation
2. Add `_framework/init.sh` to `.gitignore` (it contains user-specific config)
3. Modify `_framework/init.sh.example` to use environment variables with defaults:
   ```bash
   export SMARTPY="${SMARTPY:-/path/to/smartpy}"
   export LIGO="${LIGO:-/path/to/ligo}"
   export TEZOSCLIENT="${TEZOSCLIENT:-/path/to/octez-client -d /path/to/datadir -E https://rpc.endpoint}"
   export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=Y
   ```
4. Create a `_framework/init.sh` loader that sources from env vars, `.env` file, or `init.local.sh`:
   ```bash
   #!/bin/bash
   if [ -f "$(dirname "$0")/init.local.sh" ]; then
       source "$(dirname "$0")/init.local.sh"
   fi
   # Validate required vars are set
   for var in SMARTPY LIGO TEZOSCLIENT; do
       if [ -z "${!var}" ]; then
           echo "ERROR: $var is not set. Copy init.sh.example to init.local.sh and configure." >&2
           exit 1
       fi
   done
   export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=Y
   ```
5. Add `init.local.sh` to `.gitignore`

#### A2. Add network profile support

**Problem:** Switching networks requires editing `init.sh` and commenting/uncommenting lines.

**Action steps:**
1. Create directory `_framework/networks/`
2. Create one config file per network, e.g. `_framework/networks/nextnet-20251022.sh`:
   ```bash
   export NETWORK_NAME="nextnet-20251022"
   export TEZOSCLIENT_DATADIR="$HOME/nextnet-20251022-testing"
   export TEZOSCLIENT_RPC="https://rpc.nextnet-20251022.teztnets.com"
   ```
3. Modify `init.sh` to accept a network parameter:
   ```bash
   NETWORK="${1:-nextnet-20251022}"
   source "$(dirname "$0")/networks/${NETWORK}.sh"
   export TEZOSCLIENT="${OCTEZ_CLIENT_BIN:-octez-client} -d ${TEZOSCLIENT_DATADIR} -E ${TEZOSCLIENT_RPC}"
   ```
4. Update `execute_all.sh` to pass network parameter through
5. Migrate all commented-out network configs from `init.sh` into individual network files

#### A3. Improve `functions.sh` robustness

**Problem:** Utility functions lack error handling, quoting, and return codes. `checkResult` only does exact line matching via `grep -Fxq` which is fragile.

**Action steps:**
1. Add `set -euo pipefail` guidance or at minimum proper quoting throughout
2. Fix `checkResult` to:
   - Return exit codes (0 for pass, 1 for fail) in addition to printing
   - Accept a test name/ID parameter for structured output
   - Quote all variable references: `"$1"` and `"$2"`
   ```bash
   function checkResult() {
       local file="$1"
       local expected="$2"
       local testname="${3:-unnamed}"
       if ! grep -Fq "$expected" "$file"; then
           echo "FAIL: $testname - expected string not found: $expected"
           return 1
       else
           echo "PASS: $testname"
           return 0
       fi
   }
   ```
3. Add a `checkResultNot` function for verifying strings are absent
4. Add a `checkResultRegex` function for regex-based matching
5. Fix `getDirName` and `getReadmeHead` to quote variables properly
6. Remove the dead `main()` function that calls undefined `code`
7. Add a `logInfo` / `logError` helper for consistent output formatting

#### A4. Add structured test result output

**Problem:** Test output is unstructured echo statements. No machine-readable results, no summary report.

**Action steps:**
1. Add a results collection mechanism in `functions.sh`:
   ```bash
   RESULTS_FILE=""
   function initResults() {
       RESULTS_FILE="$(mktemp)"
   }
   function recordResult() {
       local tc_id="$1" status="$2" detail="$3"
       echo "${tc_id}|${status}|${detail}|$(date -Iseconds)" >> "$RESULTS_FILE"
   }
   ```
2. Create `_framework/generate_report.sh` that reads the results file and produces:
   - A summary line: `PASSED: X / FAILED: Y / TOTAL: Z`
   - A markdown table for human review
   - A JSON file for machine consumption
3. Modify `execute_all.sh` to call `initResults` before running and `generate_report.sh` after
4. Store reports in `results/` with naming convention `{network}_{date}_report.{md,json}`

#### A5. Add error handling to `execute_all.sh`

**Problem:** `execute_all.sh` is a single line that silently fails if any test errors out. No summary, no error collection.

**Action steps:**
1. Replace the one-liner with a proper loop:
   ```bash
   #!/bin/bash
   source "$(dirname "$0")/init.sh"
   source "$(dirname "$0")/functions.sh"
   PASS=0; FAIL=0; ERROR=0
   for tc_dir in ../testcases/TC*/; do
       echo "=== Running: $(basename "$tc_dir") ==="
       if (cd "$tc_dir" && ./execute_test.sh "$1"); then
           ((PASS++))
       else
           ((FAIL++))
       fi
   done
   echo "=== Results: PASS=$PASS FAIL=$FAIL ==="
   ```
2. Add optional `--stop-on-failure` flag
3. Add optional `--filter` flag to run subset of tests (e.g., `--filter TC-T` for ticket tests only)
4. Capture stdout/stderr per test to individual log files
5. Print a summary table at the end

---

### CATEGORY B: Test Case Quality (Medium Priority)

#### B1. Standardize test script structure

**Problem:** Test scripts vary significantly in structure. Some use case statements, some don't. Variable naming, temp file handling, and output patterns are inconsistent.

**Action steps:**
1. Create a test case template file `_framework/test_template.sh`:
   ```bash
   #!/bin/bash
   set -euo pipefail
   SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
   source "$SCRIPT_DIR/../../_framework/init.sh"
   source "$SCRIPT_DIR/../../_framework/functions.sh"

   TC_ID="$(getDirName)"
   TC_TITLE="$(getTestcaseTitle)"
   echo "=== $TC_ID: $TC_TITLE ==="

   # --- Setup ---
   # removeContract "contract_name"

   # --- Execute ---
   # $TEZOSCLIENT transfer ...

   # --- Verify ---
   # checkResult "file.tmp" "expected string" "subtestcase description"

   # --- Cleanup ---
   rm -f *.tmp.* 2>/dev/null
   ```
2. Audit all 60 test scripts and identify deviations from the template pattern
3. Refactor each test script to follow the template structure while preserving test logic
4. Ensure all scripts use `set -euo pipefail` or at minimum proper error handling
5. Ensure all scripts source init.sh and functions.sh using relative paths from script location (not relying on `pwd`)

#### B2. Fix fragile path references in test scripts

**Problem:** Many test scripts use `source ../../_framework/init.sh` which breaks if the script is invoked from a different working directory.

**Action steps:**
1. In every `execute_test.sh`, replace:
   ```bash
   source ../../_framework/init.sh
   ```
   with:
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   source "$SCRIPT_DIR/../../_framework/init.sh"
   ```
2. Apply this change to all 60 test scripts
3. Similarly fix any other relative path references (to contract files, temp files, etc.)

#### B3. Improve temp file management

**Problem:** Tests create `.tmp.*` files in the test directory and sometimes fail to clean them up. File names can collide if tests run in parallel.

**Action steps:**
1. Add a `createTempFile` function to `functions.sh` that uses `mktemp` with a test-case prefix
2. Add a `cleanupTempFiles` function and register it as a `trap` handler
3. Update all test scripts to use these functions instead of manual temp file management
4. Example:
   ```bash
   function setupCleanup() {
       TMPFILES=()
       trap 'rm -f "${TMPFILES[@]}" 2>/dev/null' EXIT
   }
   function createTempFile() {
       local f; f=$(mktemp "${1:-test}.XXXXXX.tmp")
       TMPFILES+=("$f")
       echo "$f"
   }
   ```

#### B4. Add expected-failure test support

**Problem:** Many tests verify that operations fail (e.g., reentrancy attacks should be rejected). But the framework doesn't distinguish between "expected failure" and "unexpected failure". A test that expects a failure but gets a different failure mode would still pass.

**Action steps:**
1. Add an `expectFailure` function that verifies both:
   - The operation did fail (non-zero exit code or error in output)
   - The failure message matches the expected pattern
2. Add an `expectSuccess` function that verifies the operation succeeded
3. Update test scripts that test failure scenarios to use `expectFailure` with specific error patterns

#### B5. Standardize readme.md format across test cases

**Problem:** Test case documentation varies in structure and completeness. Some have Background sections, some don't. Some have detailed test content descriptions, others are minimal.

**Action steps:**
1. Create a readme template `_framework/readme_template.md`:
   ```markdown
   # TC-XXX: Title

   ## Category
   [General | Tickets | On-chain Views | Ligo | SmartPy | Rollups]

   ## Description
   What this test case verifies.

   ## Background
   Why this behavior matters for security.

   ## Test Procedure
   Step-by-step what the test does.

   ## Expected Result
   What constitutes a pass vs. fail.

   ## Related Test Cases
   Links to related TCs if applicable.
   ```
2. Audit all test case readmes against this template
3. Fill in missing sections, especially "Expected Result" which is often absent

---

### CATEGORY C: Reproducibility & Environment (Medium Priority)

#### C1. Add Docker-based execution environment

**Problem:** The framework requires manual installation of octez-client, SmartPy, and Ligo at specific versions. This makes reproduction difficult and version tracking informal.

**Action steps:**
1. Create `Dockerfile` in project root:
   ```dockerfile
   FROM ubuntu:22.04
   ARG OCTEZ_VERSION=latest
   ARG SMARTPY_VERSION=0.18.2
   ARG LIGO_VERSION=0.72.0
   # Install octez-client, SmartPy, Ligo
   # Copy framework and test cases
   COPY . /app
   WORKDIR /app
   ENTRYPOINT ["_framework/execute_all.sh"]
   ```
2. Create `docker-compose.yml` for easy execution:
   ```yaml
   services:
     test-runner:
       build: .
       environment:
         - TEZOSCLIENT_RPC=https://rpc.nextnet.teztnets.com
       volumes:
         - ./results:/app/results
   ```
3. Document Docker usage in README
4. Create a `Makefile` with common targets: `make build`, `make test`, `make test-single TC=TC-001`

#### C2. Add tool version pinning and validation

**Problem:** Tool versions are tracked only as path fragments in `init.sh`. No validation that the correct versions are installed.

**Action steps:**
1. Create `_framework/versions.sh`:
   ```bash
   REQUIRED_OCTEZ_VERSION="v21"
   REQUIRED_SMARTPY_VERSION="0.18.2"
   REQUIRED_LIGO_VERSION="0.72.0"
   ```
2. Add version checking functions to `functions.sh`:
   ```bash
   function checkToolVersions() {
       local octez_ver; octez_ver=$($TEZOSCLIENT --version 2>&1 | head -1)
       echo "octez-client: $octez_ver"
       # Similar for SmartPy and Ligo
   }
   ```
3. Call `checkToolVersions` at the start of `execute_all.sh` and log output
4. Optionally warn (not fail) if versions don't match expected

#### C3. Add account management improvements

**Problem:** `create_accounts.sh` creates accounts but there's no validation that accounts are funded. Tests will silently fail if accounts lack tez.

**Action steps:**
1. Read `_framework/create_accounts.sh` and understand account naming conventions
2. Add a `check_accounts.sh` script that:
   - Lists all test accounts
   - Queries balance for each via `$TEZOSCLIENT get balance for`
   - Warns if any account has less than a minimum threshold (e.g., 100 tez)
3. Call `check_accounts.sh` at the start of `execute_all.sh`
4. Document the account funding requirement more prominently in README

---

### CATEGORY D: CI/CD & Automation (Medium Priority)

#### D1. Add GitHub Actions CI pipeline

**Problem:** No automated testing. All execution is manual.

**Action steps:**
1. Create `.github/workflows/test-baseline.yml`:
   ```yaml
   name: Tezos Baseline Tests
   on:
     workflow_dispatch:
       inputs:
         network:
           description: 'Tezos network to test against'
           required: true
           default: 'ghostnet'
     schedule:
       - cron: '0 6 * * 1'  # Weekly Monday 6am
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Install tools
           run: |
             # Install octez-client, SmartPy, Ligo
         - name: Setup accounts
           run: cd _framework && ./create_accounts.sh
         - name: Run tests
           run: cd _framework && ./execute_all.sh latest
         - name: Upload results
           uses: actions/upload-artifact@v4
           with:
             name: test-results
             path: results/
   ```
2. Note: Full CI requires funded accounts on a testnet, so `workflow_dispatch` (manual trigger) is appropriate as primary trigger
3. Consider a "dry-run" mode that validates contract compilation without deployment

#### D2. Add shellcheck linting

**Problem:** Bash scripts have common issues (unquoted variables, missing error handling) that shellcheck would catch.

**Action steps:**
1. Install `shellcheck` as a dev dependency
2. Create `.github/workflows/lint.yml`:
   ```yaml
   name: Lint
   on: [push, pull_request]
   jobs:
     shellcheck:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Run shellcheck
           run: find . -name "*.sh" -exec shellcheck {} +
   ```
3. Run `shellcheck` on all `.sh` files and fix reported issues
4. Common fixes needed across the codebase:
   - Quote all variable expansions: `$var` -> `"$var"`
   - Use `$()` instead of backticks where backticks are used
   - Add `#!/bin/bash` shebang to all scripts
   - Handle potential word-splitting in `for` loops

---

### CATEGORY E: Test Coverage Gaps (Lower Priority)

#### E1. Expand Ligo test coverage

**Problem:** Only 1 Ligo test case (TCL-001) exists vs 5 SmartPy tests. Ligo is a major Tezos language.

**Action steps:**
1. Review what TCS-001 through TCS-007 test for SmartPy
2. Create equivalent Ligo test cases for each SmartPy test:
   - TCL-002: Operation ordering in lambda code (equivalent of TCS-002)
   - TCL-003: Operation ordering mixed (equivalent of TCS-003)
   - TCL-004: Operation ordering with external lambdas (equivalent of TCS-006)
   - TCL-005: Similar operators (equivalent of TCS-007)
3. Ensure each new test case has a complete `readme.md`, `execute_test.sh`, and `.mligo` source
4. Update `index.md` with new test cases

#### E2. Add negative test documentation

**Problem:** It's not always clear from the readme whether a test expects success or failure. Security tests often verify that attacks fail.

**Action steps:**
1. For each test case, add to `readme.md` an "Expected Result" section clearly stating:
   - Whether the test expects the operation to succeed or fail
   - What specific error message or behavior constitutes a pass
   - What would constitute a false positive (test passes but shouldn't)
2. Priority test cases to document: TC-001 through TC-005 (core security properties)

#### E3. Add protocol upgrade regression tracking

**Problem:** The framework tests across protocol versions but doesn't systematically track behavior changes between protocols.

**Action steps:**
1. Create a `results/comparison/` directory
2. Create a script `_framework/compare_results.sh` that:
   - Takes two result files as input
   - Diffs the pass/fail status of each test case
   - Highlights tests that changed status between protocol versions
3. Document the comparison process in README
4. Create a `results/baseline/` directory with known-good results for each protocol

---

### CATEGORY F: Documentation & Onboarding (Lower Priority)

#### F1. Improve root README

**Problem:** README has a typo (`cd testcases/TC-001]`), mentions WIP, and lacks setup validation steps.

**Action steps:**
1. Fix typo on line 65: `cd testcases/TC-001]` -> `cd testcases/TC-001`
2. Add a "Quick Start" section with numbered steps
3. Add a "Verify Installation" section that runs a single simple test
4. Add a "Project Structure" section explaining the directory layout
5. Add a "Adding New Test Cases" section with instructions
6. Update the repo clone URL if it has changed
7. Add a "Supported Protocol Versions" section listing tested protocols

#### F2. Create CONTRIBUTING.md

**Problem:** README mentions contributions are welcome but provides no guidelines.

**Action steps:**
1. Create `CONTRIBUTING.md` with:
   - How to create a new test case (copy template, naming convention)
   - Test case naming conventions (TC- for general, TC-T- for tickets, etc.)
   - Code style guidelines for bash scripts
   - How to submit test results
   - PR checklist (readme, script, contracts, index.md updated)

#### F3. Add CLAUDE.md project configuration

**Problem:** No project-specific AI agent instructions exist.

**Action steps:**
1. Create `CLAUDE.md` in project root with:
   ```markdown
   # Project: Tezos Security Baseline Checking Framework

   ## Overview
   Bash-based integration test framework for verifying Tezos smart contract
   platform behavior across protocol versions.

   ## Key Commands
   - Run all tests: `cd _framework && ./execute_all.sh latest`
   - Run single test: `cd testcases/TC-XXX && ./execute_test.sh latest`
   - Lint scripts: `find . -name "*.sh" -exec shellcheck {} +`

   ## Architecture
   - `_framework/` - Test runner framework (bash)
   - `testcases/TC-*/` - Individual test cases
   - `results/` - Historical test results

   ## Conventions
   - Test IDs: TC-NNN (general), TC-T-NNN (tickets), TC-V-NNN (views),
     TCS-NNN (SmartPy), TCL-NNN (Ligo), TCR-NNN (rollups)
   - Each test case directory must have: execute_test.sh, readme.md, contract files
   - All bash scripts must pass shellcheck
   - Do not commit user-specific paths (init.local.sh is gitignored)

   ## Do Not
   - Hardcode absolute paths to tools
   - Commit private keys or funded account details
   - Modify init.sh with user-specific paths (use init.local.sh)
   ```

---

## 3. Execution Priority Order

Execute improvements in this order for maximum impact with minimum risk:

### Phase 1 - Foundation (do first)
1. **A1** - Externalize configuration (unblocks collaboration)
2. **A3** - Fix `functions.sh` robustness (fixes silent failures)
3. **B2** - Fix fragile path references (fixes execution reliability)
4. **F1** - Fix README typos and improve docs (low effort, high value)

### Phase 2 - Standardization
5. **A2** - Network profile support
6. **B1** - Standardize test script structure
7. **B3** - Improve temp file management
8. **A4** - Structured test result output
9. **A5** - Improve execute_all.sh

### Phase 3 - Automation & Quality
10. **D2** - Add shellcheck linting
11. **C2** - Tool version pinning
12. **C3** - Account management improvements
13. **B4** - Expected-failure test support
14. **B5** - Standardize readme format

### Phase 4 - Infrastructure
15. **C1** - Docker-based execution
16. **D1** - GitHub Actions CI
17. **F2** - CONTRIBUTING.md
18. **F3** - CLAUDE.md

### Phase 5 - Coverage
19. **E1** - Expand Ligo test coverage
20. **E2** - Negative test documentation
21. **E3** - Protocol upgrade regression tracking

---

## 4. Additional Best-Practice Recommendations

### Security-specific
- **Never commit private keys**: Add patterns like `*.pem`, `*.key`, `secret*` to `.gitignore`
- **Rotate test accounts**: Document account rotation procedure for when keys leak
- **Pin RPC endpoints**: Document which RPC endpoints are trusted and why

### Code quality
- **Use ShellCheck SC codes as comments** when suppressing warnings intentionally
- **Add `set -euo pipefail`** to all scripts for fail-fast behavior
- **Use `local` keyword** for all function-scoped variables

### Operational
- **Tag releases** when running against new protocol versions (e.g., `git tag oxford-2024-01`)
- **Archive results** in a structured format per protocol version
- **Add a changelog** tracking which test cases were added/modified per protocol
