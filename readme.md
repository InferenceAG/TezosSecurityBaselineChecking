# Tezos Security Baseline Checking Framework

> Verify that the Tezos smart contract platform behaves as expected across
> protocol upgrades, compiler versions, and RPC endpoints.

---

## Table of Contents

- [Purpose](#purpose)
- [Quick Start](#quick-start)
- [Running Tests](#running-tests)
- [Project Structure](#project-structure)
- [Test Case Index](#test-case-index)
- [Adding New Test Cases](#adding-new-test-cases)
- [Documentation](#documentation)
- [Contribution](#contribution)
- [License](#license)

---

## Purpose

The purpose of this framework is to verify that the underlying Tezos smart contract platform
continues to behave as expected across protocol upgrades, compiler versions, and RPC endpoints.

Performing these checks independently is crucial for smart contract developers and security assessors
to understand how the underlying system works and whether it has changed between versions.
A thorough understanding of the underlying system forms a "baseline" for any security-related work
on Tezos smart contracts.

The framework also enables early detection of critical changes during development of new Tezos
protocols and high-level smart contract compilers (Ligo, SmartPy).

This framework underpins the
[Tezos Security Assessment Checklist](https://github.com/Inference/TezosSecurityAssessmentChecklist).

---

## Quick Start

### 1. Prerequisites

- [octez-client](https://tezos.gitlab.io/introduction/howtoget.html) (v21 or later)
- [SmartPy](https://smartpy.io/docs/cli) (v0.18.2)
- [Ligo](https://ligolang.org/docs/intro/installation) (v0.72.0)

### 2. Clone the repository

```bash
git clone https://github.com/Inference/TezosSecurityBaselineCheckingFramework
cd TezosSecurityBaselineCheckingFramework
```

### 3. Configure tool paths

```bash
cp _framework/init.sh.example _framework/init.local.sh
# Edit init.local.sh with paths to your SmartPy, Ligo, and octez-client installations
```

### 4. Create test accounts

```bash
cd _framework && ./create_accounts.sh
```

Fund both accounts (`admin` and `deploy`) with at least 100 tez each using the
[teztnets.com faucet](https://teztnets.com).

### 5. Verify your setup

Run a single simple test to confirm everything is working:

```bash
cd testcases/TC-001 && ./execute_test.sh latest
```

Expected output should contain `testcase succeeded`.

### 6. Run all tests

```bash
# From the project root using Make:
make test

# Or directly:
cd _framework && ./execute_all.sh latest
```

---

## Running Tests

### Run a single test case

```bash
cd testcases/TC-001 && ./execute_test.sh latest
# or:
make test-single TC=TC-001
```

### Run a filtered subset

```bash
# Run only ticket-related tests:
make test FILTER=TC-T

# Run only SmartPy tests:
make test FILTER=TCS
```

### Run with Docker

```bash
make build
TEZOSCLIENT_RPC=https://rpc.ghostnet.teztnets.com make test-docker
```

### Switching networks

Network profiles live in `_framework/networks/`. Pass the profile name via the `NETWORK` env var:

```bash
NETWORK=nextnet-20260320 make test
```

---

## Project Structure

```
_framework/
  init.sh              # Configuration loader (sources init.local.sh)
  init.sh.example      # Template — copy to init.local.sh and fill in your paths
  init.local.sh        # Machine-specific config (gitignored — do not commit)
  functions.sh         # Shared utility functions (checkResult, etc.)
  execute_all.sh       # Batch test runner with summary and filter support
  generate_report.sh   # Produces markdown + JSON reports from results
  create_accounts.sh   # Generate test accounts
  check_accounts.sh    # Verify accounts exist and have sufficient funds
  versions.sh          # Pinned tool versions and version checker
  test_template.sh     # Template for new test cases
  readme_template.md   # Template for test case documentation
  networks/            # Per-network RPC configuration files

testcases/
  TC-NNN/              # General test cases (Michelson opcodes, core behaviour)
  TC-T-NNN/            # Tezos ticket system tests
  TC-V-NNN/            # On-chain view tests
  TCS-NNN/             # SmartPy compiler-specific tests
  TCL-NNN/             # Ligo compiler-specific tests
  TCR-NNN/             # Smart optimistic rollup tests
  (each contains: execute_test.sh, readme.md, contract files)

results/               # Test run logs and reports (gitignored *.out)

Makefile               # Common make targets: test, test-single, lint, build
Dockerfile             # Containerised execution environment
docker-compose.yml     # Docker Compose configuration
```

---

## Test Case Index

See [./index.md](./index.md) for a full list of test cases with descriptions.

---

## Adding New Test Cases

1. Copy the template: `cp _framework/test_template.sh testcases/TC-NNN/execute_test.sh`
2. Copy the readme template: `cp _framework/readme_template.md testcases/TC-NNN/readme.md`
3. Add your contract files (`.tz`, `.mligo`, or `.py`) to the directory
4. Update [./index.md](./index.md) with the new entry

Naming conventions:
- `TC-NNN` — general / Michelson opcode tests
- `TC-T-NNN` — Tezos ticket tests
- `TC-V-NNN` — on-chain view tests
- `TCS-NNN` — SmartPy compiler tests
- `TCL-NNN` — Ligo compiler tests
- `TCR-NNN` — smart optimistic rollup tests

---

## Contribution

Everyone is invited to contribute. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

---

## Disclaimer

This framework does not claim to be complete. It is continuously developed as new Tezos
protocol versions and compiler releases are made available.

---

## Documentation

Full project documentation lives in [`docs/`](docs/):

| Document | Description |
|---|---|
| [docs/architecture.md](docs/architecture.md) | System design, components, and data flow |
| [docs/services.md](docs/services.md) | External tools, RPC endpoints, credentials policy |
| [docs/data-model.md](docs/data-model.md) | Test case format, assertions, environment variables |
| [docs/standards/coding.md](docs/standards/coding.md) | Bash style guide |
| [docs/standards/commits.md](docs/standards/commits.md) | Commit message format |
| [docs/standards/prs.md](docs/standards/prs.md) | PR template and review criteria |
| [docs/standards/security.md](docs/standards/security.md) | Security rules and gitignore policy |
| [docs/adr/](docs/adr/) | Architectural decision records |

---

## Contact

Maintained by [Inference](https://inference.ag).

---

## License

License not yet specified. Contact [Inference](https://inference.ag) for usage terms.
