#!/bin/bash

. ../env.sh
. ../utils.sh

slot=$1

ex3_validator_addr=addr_test1wps4xf5w8l6e5rnre3pzrdp4gkmw0x68make7rcsf8azumgceme40
ex3_reference_utxo=55318b209c1d15d5b4dc3b9fcfa1618dae1b13fd8cbc2fc07b46081a337fba8c#0

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${ex3_validator_addr})

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $sender_tx_in \
	--tx-in-collateral $sender_tx_in \
	--tx-in $validator_tx_in \
	--spending-tx-in-reference $ex3_reference_utxo \
	--spending-plutus-script-v3 \
	--spending-reference-tx-in-inline-datum-present \
	--spending-reference-tx-in-redeemer-file redeemer.json \
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
