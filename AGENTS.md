# Agent Configuration — Tezos Security Baseline Checking Framework

> Agent-agnostic project config. Referenced by AICD.md as the project override layer.
> Tool-specific files (CLAUDE.md, .cursorrules, etc.) are thin shims that point here.

## Framework

This project follows the AICD framework defined in `AICD.md`.
Load context in this order before acting:

1. `AICD.md` — framework rules and principles
2. `docs/architecture.md` — system design, components, data flow
3. `docs/services.md` — external tools and credentials policy
4. `docs/data-model.md` — test case format, assertions, env vars
5. `memory/MEMORY.md` — persistent agent memory

Rules in this file override AICD where they conflict.

## Project-Specific Rules

- Runtime: Bash (bash, not sh)
- Language: Shell scripts + Michelson / Ligo / SmartPy contract files
- Test runner: `make test` → `_framework/execute_all.sh` against a live testnet
- Quality gate: `make lint` (shellcheck --severity=warning on all .sh files)
- Agents must run `make lint` before considering any script change complete
- Never bypass git hooks (`--no-verify`) without explicit human instruction

## What This Project Does

Bash-based integration test framework for verifying Tezos smart contract platform behaviour
across protocol versions. Tests Michelson opcodes, Ligo, and SmartPy behaviour using
`octez-client` against live testnets.

60 active test cases across 6 categories. No mock — tests run against real chains.

## Key Commands

```bash
# Run all tests
make test

# Run all tests (with filter)
make test FILTER=TC-T

# Run a single test
make test-single TC=TC-001

# Lint all shell scripts
make lint

# Build Docker image
make build

# Check account balances
make check-accounts
```

## Architecture

```
_framework/           # Framework scripts (init, functions, runner, templates)
  init.sh             # Loader — sources init.local.sh (gitignored)
  init.sh.example     # Template for local config
  init.local.sh       # Machine config — NEVER commit this file
  functions.sh        # checkResult, expectFailure, createTempFile, etc.
  execute_all.sh      # Batch runner with --filter and --stop-on-failure
  versions.sh         # Pinned tool versions
  networks/           # Per-network RPC configs (ghostnet.sh, nextnet-*.sh, etc.)

testcases/TC-*/       # One directory per test case
  execute_test.sh     # Test runner script
  readme.md           # Test documentation (title, description, expected result)
  *.tz / *.mligo / *.py  # Contract source files

results/              # Test run logs and reports (not committed)
```

## Test Case Conventions

- `TC-NNN`   — General / Michelson opcode tests
- `TC-T-NNN` — Ticket system tests
- `TC-V-NNN` — On-chain view tests
- `TCS-NNN`  — SmartPy compiler tests
- `TCL-NNN`  — Ligo compiler tests
- `TCR-NNN`  — Smart optimistic rollup tests

Each test case directory **must** have `execute_test.sh`, `readme.md`, and contract files.

## Bash Style Rules

- Always source framework files via `"$SCRIPT_DIR/../../_framework/init.sh"` (not `../../`)
- Use `checkResult`, `expectFailure`, `checkResultNot` for assertions — do not echo pass/fail manually
- Use `setupCleanup` + `createTempFile` — do not use hardcoded `.tmp` filenames
- All scripts must pass `shellcheck --severity=warning`

## Do Not

- Hardcode absolute paths to tools in any committed file
- Commit `_framework/init.local.sh` or any file with machine-specific paths
- Commit private keys, funded account details, or secrets
- Run `make test` without first configuring `init.local.sh` and funding accounts
- Force-push to master or skip pre-commit hooks

## Configuration

Copy `_framework/init.sh.example` to `_framework/init.local.sh` and set:
- `SMARTPY` — path to SmartPy CLI
- `LIGO` — path to Ligo binary
- `TEZOSCLIENT` — octez-client command with `-d <datadir> -E <rpc>`

Switch networks by setting `NETWORK=<profile>` where profile matches a file in `_framework/networks/`.
