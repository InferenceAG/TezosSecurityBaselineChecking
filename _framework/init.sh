#!/bin/bash/
# SmartPy
export SMARTPY=/home/user/smartpy-cli/SmartPy.sh

# Ligo
#export LIGO=/home/user/ligo/ligo-20211215-1acb57254d3b46dce1a2cdf34283564a2a36f084
export LIGO=/home/user/ligo/ligo-20220113-d1f2b59c70c5a6ffca9006773f538afd0cda7af0

# Tezos
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/tezos-client -d /home/user/Data/Deployments/Ithaca -E https://ithacanet.smartpy.io/"
export TEZOSCLIENT="/home/user/Installs/tezos-clients/tezos-client -d /home/user/Data/Deployments/Hangzhou -E https://hangzhounet.smartpy.io/"
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=Y

main() {
	    code
    }

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
	    main "$@"
fi
