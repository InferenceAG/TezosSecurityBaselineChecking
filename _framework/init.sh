#!/bin/bash/
# SmartPy
#export SMARTPY=/home/user/smartpy-cli/SmartPy.sh
export SMARTPY=/home/user/Installs/SmartPy/v0.15.0/smartpy-cli/SmartPy.sh

# Ligo
#export LIGO=/home/user/ligo/ligo-20211215-1acb57254d3b46dce1a2cdf34283564a2a36f084
export LIGO=/home/user/Installs/ligo/ligo-0.55.0

# Tezos
export TEZOSCLIENT="/home/user/Installs/tezos-clients/octez-client-v15.0-rc1 -d /home/user/Data/Deployments/Lima -E http://10.30.0.200:4415"
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/tezos-client -d /home/user/Data/Deployments/Kathmandu -E https://kathmandunet.smartpy.io/"
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/tezos-client -d /home/user/Data/Deployments/Jakarta -E https://jakartanet.smartpy.io/"
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/tezos-client -d /home/user/Data/Deployments/Ithaca -E https://ithacanet.smartpy.io/"
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/tezos-client -d /home/user/Data/Deployments/Flextesa -E http://10.137.0.18:20000/"
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/tezos-client -d /home/user/Data/Deployments/Hangzhou -E https://hangzhounet.smartpy.io/"
export TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=Y

main() {
	    code
    }

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
	    main "$@"
fi
