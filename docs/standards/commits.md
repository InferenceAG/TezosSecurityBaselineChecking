# Commit Message Standard

This project follows [Conventional Commits](https://www.conventionalcommits.org/).

---

## Format

```
<type>(<scope>): <short summary>

[optional body — explain WHY, not WHAT]

[optional footer — breaking changes, issue refs]
```

---

## Types

| Type       | When to use                                              |
|------------|----------------------------------------------------------|
| `feat`     | New test case or new framework capability                |
| `fix`      | Correcting a broken test, wrong assertion, or bug        |
| `refactor` | Restructuring code without changing behaviour            |
| `docs`     | Documentation only changes                              |
| `test`     | Changes to test infrastructure (not a new test case)    |
| `chore`    | Maintenance — dependency updates, gitignore, tooling     |
| `ci`       | CI/CD configuration changes                             |

---

## Scope (optional)

Use the test case ID or subsystem name:

```
feat(TC-020): add address-index behaviour test
fix(TCS-003): correct expected operation ordering
docs(architecture): add Docker execution diagram
chore(deps): pin octez-client to v21.1
```

---

## Rules

- **Summary line:** imperative mood, max 72 characters, no trailing period.
  - Good: `feat(TC-T-027): verify zero-amount ticket rejection`
  - Bad: `Added a test for ticket stuff.`
- **Body:** explain the motivation, not the mechanics. What was wrong or why
  this behaviour matters for security.
- **Never commit:** secrets, private keys, funded account addresses, or
  `init.local.sh`.
- **Scope is optional** for small changes. Use it when the change is clearly
  scoped to one test case or subsystem.

---

## Examples

```
feat(TC-020): add address-index boundary behaviour test

The address index in Michelson operations was undocumented for large
contracts. This test pins the observed behaviour so we detect regressions
across protocol upgrades.
```

```
fix(execute_all.sh): strip ANSI codes from log files

Log files written via tee preserved escape codes, making them unreadable
in editors and CI output. Added sed filter in the tee pipeline.
```

```
docs: add AICD-required docs structure

Creates docs/architecture.md, docs/services.md, docs/data-model.md,
docs/standards/, docs/adr/, and memory/MEMORY.md per AICD §4.2.
```
