#!/bin/bash

. ../env.sh
. ../utils.sh

validator_addr=$1
slot=$2

reference_utxo=4a93b62fd95c07efeb56e03d5cc32424149e239e3f4689566a062e6a5a22f0e7#0

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${validator_addr})

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $sender_tx_in \
	--tx-in-collateral $sender_tx_in \
	--tx-in $validator_tx_in \
	--spending-tx-in-reference $reference_utxo \
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
