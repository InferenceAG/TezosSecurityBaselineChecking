# Coding Standard — Bash / Shell Scripts

All shell scripts in this project must pass `shellcheck --severity=warning`.
Run `make lint` to verify before committing.

---

## Shebang and Portability

```bash
#!/bin/bash
```

Always use `bash`, not `sh`. The framework relies on bash-specific features
(`[[ ]]`, arrays, `local`, `declare`).

---

## Path Resolution

Always use `SCRIPT_DIR` for portable path resolution:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

Source framework files relative to `SCRIPT_DIR`, never with bare relative paths:

```bash
# Correct
source "$SCRIPT_DIR/../../_framework/init.sh"

# Wrong
source ../../_framework/init.sh
```

---

## Variable Quoting

Quote all variable expansions. Unquoted variables break on paths with spaces
and are a shellcheck warning.

```bash
# Correct
"$var"
"${array[@]}"

# Wrong
$var
${array[@]}
```

---

## Function Scoping

Declare all variables inside functions with `local`:

```bash
function myFunc() {
    local name="$1"
    local result
    result=$(some_command)
    echo "$result"
}
```

---

## Temp Files

Never hardcode `.tmp` filenames. Use the framework's temp file manager:

```bash
setupCleanup                      # registers EXIT trap
OUT=$(createTempFile "out")       # creates /tmp/TC-NNN-out.XXXXXX.tmp
```

Files registered via `createTempFile` are automatically deleted on exit.

---

## Assertions

Use framework assertion functions. Never echo pass/fail strings manually.

| Do this                                     | Not this                          |
|---------------------------------------------|-----------------------------------|
| `checkResult "$OUT" "expected"`             | `echo "testcase succeeded"`       |
| `expectFailure "$OUT" "error message"`      | `echo "testcase failed"`          |
| `checkResultNot "$OUT" "absent string"`     | custom grep + echo                |

---

## Contract Alias Cleanup

Always clean up contract aliases before originating, to avoid conflicts on re-runs:

```bash
removeContract "my-contract"
$TEZOSCLIENT originate contract "my-contract" ...
```

---

## Conditional Syntax

Use `[[ ]]` for conditionals in bash scripts (not `[ ]`):

```bash
if [[ "$var" == "value" ]]; then
    ...
fi
```

Use `(( ))` for arithmetic:

```bash
if (( count > 0 )); then
    ...
fi
```

---

## Error Handling

Do not use `set -e` in test scripts — assertion functions rely on commands
returning non-zero without aborting the script.

Framework scripts (`execute_all.sh`, etc.) should handle errors explicitly.

---

## Naming

| Thing           | Convention             | Example                  |
|-----------------|------------------------|--------------------------|
| Functions       | camelCase              | `checkResult`            |
| Local variables | snake_case or camelCase | `tc_name`, `outFile`    |
| Global/exported | UPPER_SNAKE_CASE       | `TEZOSCLIENT`, `NETWORK` |
| Private helpers | leading underscore     | `_cleanupTempFiles`      |

---

## shellcheck Directives

Use `# shellcheck source=` annotations when sourcing files with dynamic paths,
so shellcheck can follow the include:

```bash
# shellcheck source=../../_framework/init.sh
source "$SCRIPT_DIR/../../_framework/init.sh"
```

Suppress warnings only when genuinely unavoidable, and always with a comment
explaining why.
