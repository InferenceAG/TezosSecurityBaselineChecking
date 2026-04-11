# External Services

This document lists every external service or tool this framework depends on,
how it is configured, and the credentials policy that applies to each.

---

## 1. Tezos Testnets (RPC Endpoints)

| Network   | Default RPC                              | Purpose                       |
|-----------|------------------------------------------|-------------------------------|
| Ghostnet  | `https://rpc.ghostnet.teztnets.com`      | Stable long-running testnet   |
| Nextnet   | See `_framework/networks/nextnet-*.sh`   | Latest protocol preview       |
| Custom    | Set via `TEZOSCLIENT` in `init.local.sh` | Any compatible Tezos node     |

**Configuration:** Set in `_framework/init.local.sh` (gitignored) or via the
`NETWORK` environment variable, which selects a profile from `_framework/networks/`.

**Credentials:** None. RPC endpoints are public and unauthenticated.
Do not use a private node URL with authentication credentials in committed files.

---

## 2. octez-client (`$TEZOSCLIENT`)

The primary Tezos CLI tool used to deploy contracts, submit transactions, and
query chain state.

- **Minimum version:** v21 (pinned in `_framework/versions.sh`)
- **Configuration:** The full command including `-d <datadir> -E <rpc>` is set as
  `TEZOSCLIENT` in `init.local.sh`.
- **Wallet:** Accounts are stored in the octez-client data directory on the local
  machine. Keys are never committed.
- **Accounts used:** `admin` and `deploy` — implicit accounts funded with test tez.

---

## 3. SmartPy CLI (`$SMARTPY`)

High-level smart contract compiler targeting Michelson.

- **Minimum version:** v0.18.2 (pinned in `_framework/versions.sh`)
- **Configuration:** Path to the SmartPy CLI binary, set as `SMARTPY` in `init.local.sh`.
- **Credentials:** None.
- **Official docs:** [smartpy.io/docs/cli](https://smartpy.io/docs/cli)

---

## 4. Ligo (`$LIGO`)

High-level smart contract language and compiler for Tezos.

- **Minimum version:** v0.72.0 (pinned in `_framework/versions.sh`)
- **Configuration:** Path to the Ligo binary, set as `LIGO` in `init.local.sh`.
- **Credentials:** None.
- **Official docs:** [ligolang.org/docs/intro/installation](https://ligolang.org/docs/intro/installation)

---

## 5. Teztnets Faucet

Used to fund test accounts during setup. Human-operated, not automated.

- **URL:** [teztnets.com](https://teztnets.com)
- **Usage:** Fund `admin` and `deploy` accounts with ≥ 100 tez each before running tests.
- **Credentials:** None required (public faucet).
- **Note:** Faucet requests are rate-limited. Do not automate faucet calls.

---

## 6. Docker (optional)

Used for containerised execution of the full test suite without local tool installation.

- **Image:** Built locally via `make build` — not published to a registry.
- **Credentials:** None.
- **Runtime variable:** `TEZOSCLIENT_RPC` — passed at `docker compose run` time.

---

## Credentials Policy

| Item                        | Policy                                               |
|-----------------------------|------------------------------------------------------|
| Private keys / mnemonics    | Never committed; live only in octez-client data dir  |
| Funded account addresses    | Never committed (they can be used to drain funds)    |
| RPC URLs with auth tokens   | Never committed; set only in `init.local.sh`         |
| Public RPC URLs             | Safe to commit in network profile files              |
| Faucet usage                | Manual only — never automate token requests          |
