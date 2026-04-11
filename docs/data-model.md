# Data Model

This document describes the key data structures, file formats, and conventions
used by the framework.

---

## 1. Test Case Directory

Each test case lives in `testcases/<ID>/` and must contain:

| File                     | Required | Description                                      |
|--------------------------|----------|--------------------------------------------------|
| `execute_test.sh`        | Yes      | Test runner script                               |
| `readme.md`              | Yes      | Human-readable description and expected result   |
| `*.tz`                   | Varies   | Michelson contract source                        |
| `*.mligo`                | Varies   | Ligo contract source                             |
| `*.py`                   | Varies   | SmartPy contract source                          |

---

## 2. Test Case Naming

| Prefix     | Category                              | Example      |
|------------|---------------------------------------|--------------|
| `TC-NNN`   | General / Michelson opcode tests      | `TC-001`     |
| `TC-T-NNN` | Tezos ticket system tests             | `TC-T-001`   |
| `TC-V-NNN` | On-chain view tests                   | `TC-V-001`   |
| `TCS-NNN`  | SmartPy compiler-specific tests       | `TCS-001`    |
| `TCL-NNN`  | Ligo compiler-specific tests          | `TCL-001`    |
| `TCR-NNN`  | Smart optimistic rollup tests         | `TCR-001`    |

Numbers within each series are sequential and never reused. Deprecated tests are
moved to `testcases/old/` and prefixed with `_`.

---

## 3. Test Case Readme Format

Every `testcases/<ID>/readme.md` must follow this structure (see `_framework/readme_template.md`):

```markdown
# <One-line title>

## Description

<What is being tested — the specific behaviour or opcode under examination.>

## Background

<Why this matters for security — potential attack vectors or misunderstandings
this test guards against.>

## Expected Result

<Clearly stated pass/fail criteria. What should happen when the contract is
deployed and the test is executed.>
```

The first line (`# Title`) is used by `getTestcaseTitle()` in `functions.sh` to
label test output.

---

## 4. Test Runner Script (`execute_test.sh`)

Every test runner must follow this skeleton (see `_framework/test_template.sh`):

```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../_framework/init.sh
source "$SCRIPT_DIR/../../_framework/init.sh"
# shellcheck source=../../_framework/functions.sh
source "$SCRIPT_DIR/../../_framework/functions.sh"

setupCleanup
OUT=$(createTempFile "out")

# ... test logic using $TEZOSCLIENT, $SMARTPY, $LIGO ...

checkResult "$OUT" "expected string"
```

Key rules:
- Source framework files via `"$SCRIPT_DIR/../../_framework/init.sh"` — never relative paths.
- Call `setupCleanup` once at the top to register trap for temp file cleanup.
- Use `createTempFile` for all output files — never hardcode `.tmp` filenames.
- Use assertion functions (`checkResult`, `checkResultNot`, `expectFailure`, etc.) — never
  echo `testcase failed` / `testcase succeeded` manually.

---

## 5. Assertion Functions

| Function              | Passes when                                                     |
|-----------------------|-----------------------------------------------------------------|
| `checkResult F S`     | String `S` is found anywhere in file `F`                        |
| `checkResultNot F S`  | String `S` is **not** found in file `F`                         |
| `checkResultRegex F P`| Regex `P` matches anywhere in file `F`                          |
| `expectSuccess F`     | File `F` contains no known error patterns                       |
| `expectFailure F E`   | File `F` contains error string `E` (operation failed as expected)|

All functions print `testcase succeeded | <label>` or `testcase failed | <label>`.
They increment `_TC_PASS` / `_TC_FAIL` counters rather than exiting.

---

## 6. Result Log Format

The batch runner (`execute_all.sh`) writes per-test logs and a combined log:

```
results/
  run_20260410_143000.log          Combined log for the whole run
  TC-001_20260410_143000.log       Per-test log (plain text, ANSI stripped)
  report_20260410_143000.md        Structured markdown report
  report_20260410_143000.json      Structured JSON report
```

The internal results collector appends pipe-delimited records to a temp file:

```
TC-001|PASS||2026-04-10T14:30:05+00:00
TC-002|FAIL|see results/TC-002_20260410_143000.log|2026-04-10T14:30:12+00:00
```

Fields: `tc_id | status (PASS/FAIL) | detail | ISO-8601 timestamp`

---

## 7. Network Profile Format

Files in `_framework/networks/` export shell variables consumed by `init.sh`:

```bash
# ghostnet.sh
export TEZOSCLIENT="octez-client -d /path/to/datadir -E https://rpc.ghostnet.teztnets.com"
```

The filename (without `.sh`) is the value passed as `NETWORK=<name>`.

---

## 8. Environment Variables

| Variable                               | Source         | Description                              |
|----------------------------------------|----------------|------------------------------------------|
| `TEZOSCLIENT`                          | `init.local.sh`| Full octez-client command with `-d` `-E` |
| `SMARTPY`                              | `init.local.sh`| Path to SmartPy CLI binary               |
| `LIGO`                                 | `init.local.sh`| Path to Ligo binary                      |
| `NETWORK`                              | Caller env     | Network profile name (selects .sh file)  |
| `TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER` | `init.sh`    | Set to `Y` — suppresses CLI disclaimer   |
| `FORCE_COLOR`                          | `execute_all.sh`| Set to `1` to propagate colour through tee |
