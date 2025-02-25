#!/bin/bash

. ../env.sh
. ../utils.sh

validator_path=$1
ref_script_min_utxo_lovelace=$2
ref=$3

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file $validator_path)

tx_in=$(get_address_biggest_lovelace ${sender})

cardano-cli conway transaction build \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-out $reference_scripts_addr+$ref_script_min_utxo_lovelace \
--tx-out-reference-script-file $validator_path \
--change-address $sender \
--out-file deploy-reference-script.draft

cardano-cli conway transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file deploy-reference-script.draft \
--out-file deploy-reference-script.signed

cardano-cli conway transaction submit \
--tx-file deploy-reference-script.signed \
--testnet-magic 1

echo "$(cardano-cli transaction txid --tx-file deploy-reference-script.signed)#0" > reference-script-$ref.utxo
