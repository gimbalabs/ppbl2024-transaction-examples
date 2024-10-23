#!/bin/bash

. ../env.sh
. ../utils.sh

slot=$1

ex3_validator_addr=addr_test1wz64nnxqvcgghn49pw0tny6jgvk3hrezvn8nyccuqfm4d4ga9yy6f
ex3_reference_utxo=d3e141bd955441346e08df3a092319da98324a0690b2989ca1f86b75be9a5b6b#0

# ex3_validator_addr=addr_test1wz4hghsfegcta2set8g02y262fes4vf3u0gl7qyjrn5v9kqqzzydw
# ex3_reference_utxo=117c77f218ad719b221923857f3adb553889a59b50bff9d5044fa9452aec81ca#0


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
	--spending-reference-tx-in-redeemer-file datum.json \
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
