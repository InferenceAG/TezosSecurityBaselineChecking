#!/bin/bash

# SmartPy
#export SMARTPY=/home/user/smartpy-cli/SmartPy.sh
#export SMARTPY=/home/user/Installs/SmartPy/v0.16.0/smartpy-cli/SmartPy.sh
export SMARTPY=/home/gonzo/Installs/SmartPy/smartpy_0.18.2

# Ligo
#export LIGO=/home/user/ligo/ligo-20211215-1acb57254d3b46dce1a2cdf34283564a2a36f084
export LIGO=/home/gonzo/Installs/ligo/ligo-0.72.0
#export LIGO=/home/user/Installs/ligo/ligo-0.67.1

# Tezos
export TEZOSCLIENT="/home/gonzo/tezos/octez-client -d /home/gonzo/nextnet-20250610-testing -E https://rpc.nextnet-20250610.teztnets.com"
#export TEZOSCLIENT="/home/gonzo/Installs/tezos-clients/octez-client.v19.1 -d /home/gonzo/Data/Deployments/Oxford -E https://rpc.oxfordnet.teztnets.com"
#export TEZOSCLIENT="/home/gonzo/Installs/tezos-clients/octez-client.v17.1 -d /home/gonzo/Data/Deployments/Nairobi -E http://10.30.0.200:4417"
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/octez-client-v16.0-rc1 -d /home/user/Data/Deployments/Mumbai -E http://10.30.0.200:4416"
#export TEZOSCLIENT="/home/user/Installs/tezos-clients/octez-client-v15.0-rc1 -d /home/user/Data/Deployments/Lima -E http://10.30.0.200:4415"
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
