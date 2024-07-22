#!/bin/bash

. ../env.sh
. ../utils.sh

validator_path=$1
lovelace_to_lock=$2
ref_script_min_utxo_lovelace=$3
ref=initial

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file $validator_path)

tx_in=$(get_address_biggest_lovelace ${sender})

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-out $validator_addr+$lovelace_to_lock \
--tx-out-inline-datum-file claim-window-datum-$ref.json \
--tx-out $reference_scripts_addr+$ref_script_min_utxo_lovelace \
--tx-out-reference-script-file $validator_path \
--change-address $sender \
--out-file lock-tokens-and-deploy-validator.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file lock-tokens-and-deploy-validator.draft \
--out-file lock-tokens-and-deploy-validator.signed

cardano-cli transaction submit \
--tx-file lock-tokens-and-deploy-validator.signed \
--testnet-magic 1

echo "$(cardano-cli transaction txid --tx-file lock-tokens-and-deploy-validator.signed)#1" > reference-script-$ref.utxo