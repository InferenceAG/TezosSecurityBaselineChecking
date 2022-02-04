#!/bin/bash
. ../../_framework/init.sh

$TEZOSCLIENT activate account deploy with "deploy.json"
$TEZOSCLIENT activate account admin with "admin.json"
