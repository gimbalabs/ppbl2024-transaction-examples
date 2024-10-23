#!/bin/bash

. ../env.sh
. ../utils.sh

slot=$1

ex2_validator_addr=addr_test1wzvx4awpyfszq33s3ghlzpyp2a55276sjgw8f0m5jum7luquj3c4u
ex2_reference_utxo=1b0612cb1b26ac54b277741c98b5bb735a93919b17fe08e7e87a823037c4acfc#0

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${ex2_validator_addr})

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $sender_tx_in \
	--tx-in-collateral $sender_tx_in \
	--tx-in $validator_tx_in \
	--spending-tx-in-reference $ex2_reference_utxo \
	--spending-plutus-script-v3 \
	--spending-reference-tx-in-inline-datum-present \
	--spending-reference-tx-in-redeemer-value 1337 \
	--invalid-before $slot \
	--change-address $sender \
	--out-file unlock-tokens.draft

cardano-cli conway transaction sign \
	--signing-key-file $sender_key \
	--testnet-magic 1 \
	--tx-body-file unlock-tokens.draft \
	--out-file unlock-tokens.signed

cardano-cli conway transaction submit \
	--tx-file unlock-tokens.signed \
	--testnet-magic 1
