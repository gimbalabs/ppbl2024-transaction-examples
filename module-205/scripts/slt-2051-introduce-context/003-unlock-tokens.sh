#!/bin/bash

. ../env.sh
. ../utils.sh

reference_utxo=0f7405ebc9d8be81abb3337e4f9ed2619956631faeced869f65f0a16ecacc6b6#1

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file introduce-context-aiken-with-data-type.plutus)
validator_tx_in=$(get_address_biggest_lovelace ${validator_addr})

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $sender_tx_in \
--tx-in-collateral $sender_tx_in \
--tx-in $validator_tx_in \
--spending-tx-in-reference $reference_utxo \
--spending-plutus-script-v2 \
--spending-reference-tx-in-inline-datum-present \
--spending-reference-tx-in-redeemer-file data.json \
--invalid-before 65958631 \
--change-address $sender \
--out-file unlock-tokens.draft

# cardano-cli transaction sign \
# --signing-key-file $sender_key \
# --testnet-magic 1 \
# --tx-body-file unlock-tokens.draft \
# --out-file unlock-tokens.signed

# cardano-cli transaction submit \
# --tx-file unlock-tokens.signed \
# --testnet-magic 1