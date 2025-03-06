#!/bin/bash

# Source the environment variables from env.sh
# See Lesson 205.2 for details on what to include in env.sh.
. ../env.sh  

# Source utility functions (ensure utils.sh exists in the parent directory)
. ../utils.sh

validator_addr=$1
lovelace_to_lock=$2

tx_in=$(get_address_biggest_lovelace ${sender})

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $tx_in \
	--tx-out $validator_addr+$lovelace_to_lock \
	--tx-out-inline-datum-value 1337 \
	--change-address $sender \
	--out-file lock-tokens.draft

cardano-cli conway transaction sign \
	--signing-key-file $sender_key \
	--testnet-magic 1 \
	--tx-body-file lock-tokens.draft \
	--out-file lock-tokens.signed

cardano-cli conway transaction submit \
	--tx-file lock-tokens.signed \
	--testnet-magic 1
