# Contributing to the Tezos Security Baseline Checking Framework

Thank you for your interest in contributing. This document explains how to add test cases,
write bash scripts consistently, and submit your work.

---

## Adding a New Test Case

### 1. Choose a test ID

Follow the naming convention for the category:

| Prefix | Category |
|--------|----------|
| `TC-NNN` | General / Michelson opcode behaviour |
| `TC-T-NNN` | Tezos ticket system |
| `TC-V-NNN` | On-chain views |
| `TCS-NNN` | SmartPy compiler-specific |
| `TCL-NNN` | Ligo compiler-specific |
| `TCR-NNN` | Smart optimistic rollups |

Use the next sequential number in the series (check `index.md` for the current highest).

### 2. Create the directory

```bash
mkdir testcases/TC-NNN
```

### 3. Copy the templates

```bash
cp _framework/test_template.sh  testcases/TC-NNN/execute_test.sh
cp _framework/readme_template.md testcases/TC-NNN/readme.md
chmod +x testcases/TC-NNN/execute_test.sh
```

### 4. Write the test

- Edit `execute_test.sh` to implement the test logic.
- Add your contract files (`.tz`, `.mligo`, or `.py`) to the directory.
- Compile high-level contracts to Michelson before committing (or add compilation
  to the `execute_test.sh` script using `$SMARTPY` / `$LIGO`).

### 5. Fill in the readme

Use `_framework/readme_template.md` as your guide. Every test case readme **must** have:
- A **Description** (what is being tested)
- A **Background** (why it matters for security)
- An **Expected Result** section that clearly states pass/fail criteria

### 6. Update the index

Add an entry to `index.md` following the existing format.

---

## Bash Script Style Guide

All shell scripts must pass `shellcheck --severity=warning`. Run the linter with:

```bash
make lint
```

Key rules:

- Use `#!/bin/bash` shebang on every script.
- Use `SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"` for portable path resolution.
- Source framework files via `"$SCRIPT_DIR/../../_framework/init.sh"` (not `../../`).
- Quote all variable expansions: `"$var"` not `$var`.
- Use `local` for all function-scoped variables.
- Use `checkResult`, `checkResultNot`, `expectFailure`, `expectSuccess` for assertions —
  do not echo `testcase failed` / `testcase succeeded` manually.
- Register cleanup with `setupCleanup` and create temp files with `createTempFile` —
  do not use hardcoded `.tmp.*` filenames.

---

## PR Checklist

Before opening a pull request, confirm:

- [ ] New test case directory contains `execute_test.sh`, `readme.md`, and contract files
- [ ] `readme.md` has a populated **Expected Result** section
- [ ] `index.md` has been updated with the new test case entry
- [ ] Scripts pass `make lint` (shellcheck)
- [ ] Test was run manually against a live testnet and output reviewed
- [ ] No machine-specific paths in committed files (no `/home/username/...`)
- [ ] No private keys or funded account details committed

---

## Submitting Test Results

If you have run the full test suite against a network, please share your results by opening
an issue or pull request with the log file from `results/`. Name the file using the pattern:
`{network}_{date}.log` (e.g. `ghostnet_2026-04-10.log`).

---

## Contact

Questions? Open an issue or contact [Inference](https://inference.ag).
