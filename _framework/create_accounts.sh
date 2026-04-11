#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_framework/init.sh
source "${SCRIPT_DIR}/init.sh"

$TEZOSCLIENT gen keys admin
$TEZOSCLIENT gen keys deploy