# Architecture — Tezos Security Baseline Checking Framework

## Purpose

This framework verifies that the Tezos smart contract platform behaves as documented
across protocol upgrades, compiler releases, and RPC endpoints. It provides a reproducible,
living baseline for security assessors and smart contract developers.

It is the technical underpinning of the
[Tezos Security Assessment Checklist](https://github.com/Inference/TezosSecurityAssessmentChecklist).

---

## Design Principles

- **No mocks.** Every test runs against a live testnet. Simulated execution cannot
  reveal real protocol deviations or edge cases in RPC behaviour.
- **One test, one concern.** Each test case verifies a single, named behaviour.
  Failures are unambiguous.
- **Self-contained test cases.** Each test directory carries everything needed to run
  and understand it: script, contract files, and documentation.
- **Framework stays thin.** `_framework/` provides utilities only. It does not dictate
  business logic — that lives in each test case.

---

## Component Overview

```
┌─────────────────────────────────────────────────────┐
│  Human / CI                                         │
│  make test  |  make test-single TC=TC-001           │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│  _framework/execute_all.sh                          │
│  Batch runner — discovers test cases, applies       │
│  --filter, streams output, writes logs to results/  │
└──────────────────────┬──────────────────────────────┘
                       │  runs each in subshell
                       ▼
┌─────────────────────────────────────────────────────┐
│  testcases/TC-NNN/execute_test.sh                   │
│  Individual test — sources init.sh, calls           │
│  checkResult / expectFailure / etc.                 │
└────────┬──────────────────────┬─────────────────────┘
         │                      │
         ▼                      ▼
┌─────────────────┐   ┌───────────────────────────────┐
│  _framework/    │   │  External toolchain            │
│  init.sh        │   │  $TEZOSCLIENT  octez-client    │
│  functions.sh   │   │  $SMARTPY      SmartPy CLI     │
│  versions.sh    │   │  $LIGO         Ligo binary     │
└────────┬────────┘   └───────────────────┬───────────┘
         │                                │
         ▼                                ▼
┌─────────────────┐   ┌───────────────────────────────┐
│  init.local.sh  │   │  Live testnet (Ghostnet,       │
│  (gitignored)   │   │  Nextnet, or custom RPC)       │
└─────────────────┘   └───────────────────────────────┘
```

---

## Directory Structure

```
_framework/
  init.sh               Configuration loader — sources init.local.sh, then
                         network profile, then validates required env vars
  init.sh.example       Template for init.local.sh (committed; safe to share)
  init.local.sh         Machine-specific paths (gitignored — never commit)
  functions.sh          Shared assertions (checkResult, expectFailure, etc.)
                         and utilities (createTempFile, setupCleanup, etc.)
  execute_all.sh        Batch runner with --filter and --stop-on-failure
  generate_report.sh    Produces markdown + JSON reports from run results
  create_accounts.sh    Generates admin + deploy accounts in octez-client
  check_accounts.sh     Verifies accounts exist and have sufficient balance
  versions.sh           Pinned tool versions; checkToolVersions function
  test_template.sh      Starter template for new test cases
  readme_template.md    Starter readme template for new test cases
  networks/             Per-network RPC profile files (ghostnet.sh, etc.)

testcases/
  TC-NNN/               General / Michelson opcode tests
  TC-T-NNN/             Tezos ticket system tests
  TC-V-NNN/             On-chain view tests
  TCS-NNN/              SmartPy compiler tests
  TCL-NNN/              Ligo compiler tests
  TCR-NNN/              Smart optimistic rollup tests
  old/                  Deprecated test cases (retained for reference)

results/                Run logs and reports (gitignored *.out / *.log)
docs/                   Project documentation (this file and siblings)
memory/                 Agent memory index and topic files
```

---

## Configuration and Initialisation

`init.sh` applies the following resolution order (first found wins):

1. `init.local.sh` — machine-specific overrides (gitignored)
2. Caller's environment — variables already exported before sourcing
3. Network profile — `_framework/networks/${NETWORK}.sh` when `NETWORK` is set

Required variables after resolution: `SMARTPY`, `LIGO`, `TEZOSCLIENT`.
If any are missing, `init.sh` exits with a clear error message.

---

## Assertion Model

Test scripts do **not** exit non-zero on assertion failure. Instead:

- `checkResult` / `checkResultNot` / `checkResultRegex` print `testcase succeeded`
  or `testcase failed` and increment counters.
- `expectFailure` passes when a known error string appears in the output.
- `expectSuccess` passes when no known error patterns appear.

`execute_all.sh` detects failures by scanning each test's log file for
`testcase failed`. This allows a single test to run multiple assertions without
aborting on the first failure.

---

## Results and Reporting

Each batch run produces:
- `results/run_TIMESTAMP.log` — combined log of all test output (plain text)
- `results/TC-NNN_TIMESTAMP.log` — per-test log
- `results/report_TIMESTAMP.md` / `.json` — structured summary (if `generate_report.sh` is present)

Log files strip ANSI escape codes so they are readable as plain text. Terminal output
preserves colour.

---

## Docker Execution

`Dockerfile` + `docker-compose.yml` package the framework for environments where
native tool installation is impractical. The container reads `TEZOSCLIENT_RPC` from
the environment and constructs its own `TEZOSCLIENT` command.

```
make build                               # build image
TEZOSCLIENT_RPC=https://... make test-docker
```

---

## Test Accounts

Two accounts are used: `admin` and `deploy`. They must be funded before running tests.

```bash
make accounts          # generate keypairs in octez-client's wallet
make check-accounts    # verify balances ≥ minimum threshold
```

Fund via [teztnets.com](https://teztnets.com) faucet. Minimum: 100 tez each.
Account details must never be committed.
