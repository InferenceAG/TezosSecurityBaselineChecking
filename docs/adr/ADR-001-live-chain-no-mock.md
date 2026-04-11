# ADR-001: Tests Run Against Live Testnets — No Mocks

**Status:** Accepted

---

## Context

The framework's purpose is to verify that the Tezos smart contract platform
behaves as expected across protocol upgrades, compiler releases, and RPC
implementations. The value of the baseline comes from its ability to detect
real deviations in real protocol execution.

When designing the test execution model, two approaches were considered:
a mock/simulation model and a live-chain model.

---

## Decision

All test cases execute against a live Tezos testnet using real `octez-client`
commands. No mocked RPC layer, no local sandbox, no Michelson interpreter
simulation. The environment under test is always an actual Tezos node.

---

## Consequences

**Benefits:**
- Tests reveal actual protocol behaviour, not an approximation of it.
- Deviations caused by RPC implementation details, node versions, or protocol
  amendments are caught — these would be invisible in a mock.
- The framework can be run unchanged against any network (Ghostnet, Nextnet,
  or a custom node) by changing one environment variable.
- Security assessors can trust that a passing baseline reflects real-world
  behaviour, not simulation behaviour.

**Trade-offs:**
- Tests require funded accounts and a live network. They cannot run offline or
  in a fully hermetic CI environment without a testnet node.
- Tests are slower than unit tests (RPC round-trips, block propagation for some
  operations).
- Flaky network conditions can cause occasional false failures; these must be
  distinguished from genuine regressions.
- Faucet funding must be maintained manually.

**Constraints this decision imposes:**
- `init.local.sh` must be configured before any test can run.
- Test accounts must be funded with ≥ 100 tez before running the full suite.
- CI pipelines running these tests need access to a testnet RPC endpoint and
  pre-funded accounts (stored as secrets, never committed).

---

## Alternatives Considered

### Local sandbox (e.g. `octez-sandbox`)

A local sandboxed Tezos node would allow offline execution. Rejected because:
- Sandboxes do not reflect production protocol behaviour precisely.
- They require non-trivial setup and maintenance.
- Protocol-level bugs in testnets (the ones we care about detecting) do not
  appear in sandboxes until the sandbox is updated.

### Michelson interpreter (e.g. `octez-client run script`)

Dry-run execution without originating to a chain. Rejected because:
- Does not test RPC behaviour, operation submission, or inter-contract calls.
- Does not exercise ticket semantics, on-chain views, or rollup interactions
  in a realistic way.
- Many of the security-relevant behaviours under test are emergent from full
  execution, not static interpretation.
