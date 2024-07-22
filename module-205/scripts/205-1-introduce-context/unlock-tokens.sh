#!/bin/bash

. ../env.sh
. ../utils.sh

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file introduce-context-aiken.plutus)
validator_tx_in=$(get_address_biggest_lovelace ${validator_addr})

reference_utxo=4cbe6fd16e515ff8da30a50ae9909f3524b3ba570cf8d19ebe6ab83b93ce2690#0

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $sender_tx_in \
--tx-in-collateral $sender_tx_in \
--tx-in $validator_tx_in \
--spending-tx-in-reference $reference_utxo \
--spending-plutus-script-v2 \
--spending-reference-tx-in-inline-datum-present \
--spending-reference-tx-in-redeemer-value 321 \
--invalid-before 65882800 \
--change-address $sender \
--out-file unlock-tokens.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file unlock-tokens.draft \
--out-file unlock-tokens.signed

cardano-cli transaction submit \
--tx-file unlock-tokens.signed \
--testnet-magic 1